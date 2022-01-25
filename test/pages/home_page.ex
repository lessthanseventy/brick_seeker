defmodule BrickSeekerWeb.Pages.HomePage do
  use Wallaby.DSL

  alias BrickSeekerWeb.Endpoint
  alias BrickSeekerWeb.Router.Helpers

  def visit_page(session) do
    session
    |> visit("/")
  end

  def assert_can_navigate_to_part_index_path(session) do
    part_index_path = Helpers.part_index_path(Endpoint, :index)

    session
    |> assert_has(Query.css("a[href='#{part_index_path}']"))
  end

  def assert_on_page(session) do
    session
    |> assert_has(Query.text("Listing Parts"))
  end
end
