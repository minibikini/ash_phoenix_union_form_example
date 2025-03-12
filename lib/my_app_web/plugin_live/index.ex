defmodule MyAppWeb.PluginLive.Index do
  use MyAppWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Plugins
      <:actions>
        <.link patch={~p"/plugins/new"}>
          <.button>New Plugin</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="plugins"
      rows={@streams.plugins}
      row_click={fn {_id, plugin} -> JS.navigate(~p"/plugins/#{plugin}") end}
    >
      <:col :let={{_id, plugin}} label="Id">{plugin.id}</:col>

      <:col :let={{_id, plugin}} label="Name">{plugin.name}</:col>

      <:col :let={{_id, plugin}} label="Settings">{plugin.settings}</:col>

      <:action :let={{_id, plugin}}>
        <div class="sr-only">
          <.link navigate={~p"/plugins/#{plugin}"}>Show</.link>
        </div>

        <.link patch={~p"/plugins/#{plugin}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, plugin}}>
        <.link
          phx-click={JS.push("delete", value: %{id: plugin.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="plugin-modal"
      show
      on_cancel={JS.patch(~p"/plugins")}
    >
      <.live_component
        module={MyAppWeb.PluginLive.FormComponent}
        id={(@plugin && @plugin.id) || :new}
        title={@page_title}
        action={@live_action}
        plugin={@plugin}
        patch={~p"/plugins"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :plugins, Ash.read!(MyApp.Plugins.Plugin))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Plugin")
    |> assign(:plugin, Ash.get!(MyApp.Plugins.Plugin, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Plugin")
    |> assign(:plugin, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Plugins")
    |> assign(:plugin, nil)
  end

  @impl true
  def handle_info({MyAppWeb.PluginLive.FormComponent, {:saved, plugin}}, socket) do
    {:noreply, stream_insert(socket, :plugins, plugin)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    plugin = Ash.get!(MyApp.Plugins.Plugin, id)
    Ash.destroy!(plugin)

    {:noreply, stream_delete(socket, :plugins, plugin)}
  end
end
