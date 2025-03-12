defmodule MyApp.Plugins do
  use Ash.Domain,
    otp_app: :my_app

  resources do
    resource MyApp.Plugins.Plugin
  end
end
