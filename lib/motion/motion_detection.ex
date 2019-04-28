defmodule NightVision.Motion.MotionDetection do
  import ExImageInfo

  def detect_motion(image) do
    image_binary = File.read!(image)
    decompressed_image = File.read!("testy.bmp")

    # @TODO: Remove this dependancy and just use the hex values for the width and height
    {_format, width, height, _encode} = ExImageInfo.info(decompressed_image)
    pixel_list = get_pixel_list(decompressed_image)
    get_image_sections(pixel_list, width, height)
  end

  defp get_pixel_list(image_binary) do
    image_binary
    |> :binary.bin_to_list()
  end

  defp get_image_sections(pixel_list, width, height) do
    row_length = (length(pixel_list) / height) |> round()

    rows =
      pixel_list
      |> Enum.chunk_every(row_length)

    File.write!("./row.bmp", concat_rows(rows, [], 0), [])
  end

  defp concat_rows(rows, new_rows, 637), do: new_rows

  defp concat_rows(rows, new_rows, count) do
    concat_rows(rows, new_rows ++ Enum.at(rows, count), count + 1)
  end
end
