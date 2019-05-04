defmodule NightVision.Motion.Worker do
  use GenServer

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, [init_args], MotionWorker)
  end

  def init(%{working: working} = args) do
    {:ok, args}
  end

  @impl true
  def handle_cast(:detect_motion, image, %{working: working} = state) do
    if working do
      {:reply, state}
    else
      NightVision.Motion.MotionDetection.detect_motion(image)
      {:reply, %{working: false}}
    end
  end
end
