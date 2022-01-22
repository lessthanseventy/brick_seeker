defmodule BrickSeekerWeb.PartLive.Index do
  use BrickSeekerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :part, nil)}
  end

  @impl true
  def handle_info({:match_selected, part}, socket) do
    {:noreply, assign(socket, part: part)}
  end
end
