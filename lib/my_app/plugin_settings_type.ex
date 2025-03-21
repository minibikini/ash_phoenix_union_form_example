defmodule MyApp.PluginSettingsType do
  defmodule PluginOne do
    use Ash.Resource, data_layer: :embedded

    actions do
      defaults [:read, :destroy, create: :*, update: :*]
    end

    attributes do
      attribute :size, :integer do
        default 1
        public? true
      end
    end
  end

  defmodule PluginTwo do
    use Ash.Resource, data_layer: :embedded

    actions do
      defaults [:read, :destroy, create: :*, update: :*]
    end

    attributes do
      attribute :length, :integer do
        default 1
        public? true
      end
    end
  end

  use Ash.Type.NewType,
    subtype_of: :union,
    constraints: [
      types: [
        plugin_one: [
          type: PluginOne,
          tag: :type,
          tag_value: :plugin_one
        ],
        plugin_two: [
          type: PluginTwo,
          tag: :type,
          tag_value: :plugin_two
        ]
      ]
    ]
end
