# Ash Phoenix Union Form Demo

This repository demonstrates how to implement and use [Union Forms](https://hexdocs.pm/ash_phoenix/union-forms.html) in Ash Framework with Phoenix LiveView. Union type in Ash allow you to create fields that can contain different types of data structures.

## What are Union Forms?

Union Forms in Ash Phoenix allow you to:

- Create forms for fields that can contain different types of data
- Switch between different form types dynamically
- Validate and submit different data structures based on the selected type

## Key Implementation Files

- **lib/my_app/plugin_settings_type.ex**: Defines the union type with two possible resource types (PluginOne and PluginTwo)
- **lib/my_app/plugins/plugin.ex**: The main resource that uses the union type in its settings attribute
- **lib/my_app_web/plugin_live/form_component.ex**: LiveView component that renders the form and handles type switching

## How It Works

1. The form renders with a dropdown to select the plugin type (One or Two)
2. When the type changes, the form dynamically updates to show the appropriate fields
3. The form manages the internal `_union_type` field to track the selected type
4. Data is properly validated and submitted according to the selected type

## Implementation Details

The key aspects of this implementation:

1. **Union Type Definition**: The `PluginSettingsType` creates a union type with two possible embedded resources
2. **Dynamic Form Switching**: The form component uses `AshPhoenix.Form.remove_form/3` and `AshPhoenix.Form.add_form/3` to change types
3. **Type-specific Fields**: The form conditionally renders different fields based on the selected type

## Running The Application

```
mix setup
mix phx.server
```

Open [`localhost:4000/plugins`](http://localhost:4000/plugins) from your browser to see the working example of Union Form.

## Further Resources

- [Ash Framework Documentation](https://ash-hq.org/)
- [Union Forms Documentation](https://hexdocs.pm/ash_phoenix/union-forms.html)
- [Phoenix LiveView Documentation](https://hexdocs.pm/phoenix_live_view)
