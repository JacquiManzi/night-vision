defmodule NightVision.Motion.MotionDetection do
  import ExImageInfo

  def detect_motion(image) do
    %Result{out: decompressed_image, status: status} =
      Porcelain.exec("djpeg -bmp #{image}", [Path.join(:code.priv_dir(:night_vision), "djpeg")])

    # @TODO: Remove this dependancy and just use the hex values for the width and height
    {_format, _width, height, _encode} = ExImageInfo.info(decompressed_image)
    pixel_list = get_pixel_list(decompressed_image)
    get_image_sections(pixel_list, height)
  end

  defp get_pixel_list(image_binary) do
    image_binary
    |> :binary.bin_to_list()
  end

  defp get_image_sections(pixel_list, height) do
    row_length = (length(pixel_list) / height) |> round()

    [top_left, top_right, bottom_left, bottom_right] =
      pixel_list |> Enum.chunk_every(row_length) |> create_sections()
  end

  defp create_sections(image_rows) do
    [top, bottom] = split_list(image_rows)
    split_list(top, [], []) ++ split_list(bottom, [], [])
  end

  defp split_list([], left, right), do: [left, right]

  defp split_list(list, left, right) do
    {val, remaining} = List.pop_at(list, 0)
    [new_left, new_right] = split_list(val)
    split_list(remaining, left ++ new_left, right ++ new_right)
  end

  defp split_list(nil), do: [[], []]

  defp split_list(list) do
    half_length = (length(list) / 2) |> round()
    Enum.chunk_every(list, half_length)
  end
end
