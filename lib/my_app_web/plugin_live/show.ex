defmodule MyAppWeb.PluginLive.Show do
  use MyAppWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Plugin {@plugin.id}
      <:subtitle>This is a plugin record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/plugins/#{@plugin}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit plugin</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id">{@plugin.id}</:item>

      <:item title="Name">{@plugin.name}</:item>

      <:item title="Settings">{inspect(@plugin.settings)}</:item>
    </.list>

    <.back navigate={~p"/plugins"}>Back to plugins</.back>

    <.modal
      :if={@live_action == :edit}
      id="plugin-modal"
      show
      on_cancel={JS.patch(~p"/plugins/#{@plugin}")}
    >
      <.live_component
        module={MyAppWeb.PluginLive.FormComponent}
        id={@plugin.id}
        title={@page_title}
        action={@live_action}
        plugin={@plugin}
        patch={~p"/plugins/#{@plugin}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:plugin, Ash.get!(MyApp.Plugins.Plugin, id))}
  end

  defp page_title(:show), do: "Show Plugin"
  defp page_title(:edit), do: "Edit Plugin"
end
