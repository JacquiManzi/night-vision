defmodule NightVision.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:night_vision, :port)
    camera = Application.get_env(:picam, :camera, Picam.Camera)

    children = [
      worker(camera, []),
      Plug.Cowboy.child_spec(scheme: :http, plug: NightVision.Router, options: [port: port])
    ]

    opts = [strategy: :one_for_one, name: NightVision.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
