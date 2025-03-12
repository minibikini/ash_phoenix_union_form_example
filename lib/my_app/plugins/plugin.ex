defmodule MyApp.Plugins.Plugin do
  use Ash.Resource, otp_app: :my_app, domain: MyApp.Plugins, data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string
    attribute :settings, :plugin_settings
  end
end
