defmodule MyApp.Plugins.Plugin do
  use Ash.Resource, otp_app: :my_app, domain: MyApp.Plugins, data_layer: AshPostgres.DataLayer

  postgres do
    table "plugins"
    repo MyApp.Repo
  end

  actions do
    # defaults [:read, :destroy, create: :*, update: :*]
    defaults [:read, :destroy, create: :*]

    update :update do
      accept [:*]
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      public? true
    end

    attribute :settings, :plugin_settings do
      public? true
    end
  end
end
