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
        <.input field={@form[:name]} type="text" label="Name" /><.input
          field={@form[:settings]}
          type="text"
          label="Settings"
        />

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
      end

    assign(socket, form: to_form(form))
  end
end
