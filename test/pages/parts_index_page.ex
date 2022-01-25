defmodule BrickSeekerWeb.Pages.PartsIndexPage do
  use Wallaby.DSL

  alias BrickSeeker.Parts.Part
  alias BrickSeekerWeb.Option

  def visit_page(session) do
    session
    |> visit("/parts")
  end

  def assert_on_page(session) do
    session
    |> assert_has(Query.text("Listing Parts"))
  end

  def assert_has_part_search(session) do
    session
    |> assert_has(Query.text("Part Search"))
  end

  def assert_part_selected(session, %Part{} = part) do
    session
    |> assert_has(Query.css("[data-test-id='#{part.id}']", text: Option.display_name(part)))
  end
end
