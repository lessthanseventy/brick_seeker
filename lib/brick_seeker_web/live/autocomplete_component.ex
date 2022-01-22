defmodule BrickSeekerWeb.AutocompleteComponent do
  use BrickSeekerWeb, :live_component

  alias BrickSeekerWeb.Option

  @impl true
  def mount(socket) do
    {:ok, assign(socket, matches: [])}
  end

  @impl true
  def handle_event("search_changed", %{"value" => query_string}, socket) do
    matches =
      socket.assigns.search_module
      |> Kernel.apply(socket.assigns.search_fn, [query_string])

    selected_match =
      if length(matches) == 1 && Option.value(Enum.at(matches, 0)) == query_string do
        Enum.at(matches, 0)
      else
        nil
      end

    send(self(), {socket.assigns.on_match_selected, selected_match})

    {:noreply, assign(socket, matches: if(is_nil(selected_match), do: matches, else: []))}
  end
end
