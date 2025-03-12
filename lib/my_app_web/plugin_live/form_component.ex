defmodule MyAppWeb.PluginLive.FormComponent do
  use MyAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage plugin records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="plugin-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />

        <.inputs_for :let={fc} field={@form[:settings]}>
          <!-- Dropdown for setting the union type -->
          <.input
            field={fc[:_union_type]}
            phx-change="type-changed"
            type="select"
            options={[One: "plugin_one", Two: "plugin_two"]}
          />
          
    <!-- switch on the union type to display a form -->
          <%= case fc.params["_union_type"] do %>
            <% "plugin_one" -> %>
              <.input type="number" label="Size" field={fc[:size]} />
            <% "plugin_two" -> %>
              <.input type="number" label="Length" field={fc[:length]} />
          <% end %>
        </.inputs_for>

        <:actions>
          <.button phx-disable-with="Saving...">Save Plugin</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"plugin" => plugin_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, plugin_params))}
  end

  def handle_event("type-changed", %{"_target" => path} = params, socket) do
    new_type = get_in(params, path)
    # The last part of the path in this case is the field name
    path = :lists.droplast(path)

    form =
      socket.assigns.form
      |> AshPhoenix.Form.remove_form(path)
      |> AshPhoenix.Form.add_form(path, params: %{"_union_type" => new_type})

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("save", %{"plugin" => plugin_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: plugin_params) do
      {:ok, plugin} ->
        notify_parent({:saved, plugin})

        socket =
          socket
          |> put_flash(:info, "Plugin #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{plugin: plugin}} = socket) do
    form =
      if plugin do
        AshPhoenix.Form.for_update(plugin, :update, as: "plugin")
      else
        AshPhoenix.Form.for_create(MyApp.Plugins.Plugin, :create, as: "plugin")
        |> AshPhoenix.Form.add_form(:settings, params: %{"_union_type" => "plugin_one"})
      end

    assign(socket, form: to_form(form))
  end
end
