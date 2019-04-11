defmodule NightVision.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:night_vision, :port)

    children = [
      worker(Picam.Camera, []),
      Plug.Cowboy.child_spec(scheme: :http, plug: NightVision.Router, options: [port: 4001])
    ]

    opts = [strategy: :one_for_one, name: NightVision.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
