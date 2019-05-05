use Mix.Config

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Authorize the device to receive firmware using your public key.
# See https://hexdocs.pm/nerves_firmware_ssh/readme.html for more information
# on configuring nerves_firmware_ssh.

config :nerves_firmware_ssh,
  authorized_keys: [File.read!(Path.join(System.user_home!(), ".ssh/id_rsa.pub"))]

# Configure nerves_init_gadget.
# See https://hexdocs.pm/nerves_init_gadget/readme.html for more information.

# Setting the node_name will enable Erlang Distribution.
# Only enable this for prod if you understand the risks.
node_name = "night_vision"

config :nerves_init_gadget,
  mdns_domain: "nerves.local",
  node_name: node_name,
  node_host: :mdns_domain,
  ifname: "eth0",
  address_method: :dhcp
