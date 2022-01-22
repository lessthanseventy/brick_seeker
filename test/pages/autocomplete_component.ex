defmodule BrickSeekerWeb.Pages.AutocompleteComponent do
  use Wallaby.DSL

  alias BrickSeekerWeb.Option

  @search_input "input[type=text]"

  def within(session, name, fun) do
    find(session, Query.css("##{name}_search"), fun)
  end

  def search(session, search_string) do
    session
    |> fill_in(Query.css(@search_input), with: search_string)
  end

  def select_from_search(session, option) do
    # since browser autocomplete from datalists are seemingly not introspectable
    # or controllable by tests, we just type the value into the input (for now)

    session
    |> fill_in(Query.css(@search_input), with: "")
    |> type_like_a_human(Query.css(@search_input), Option.value(option))
  end

  def type_like_a_human(form, query, text) do
    text
    |> String.graphemes()
    |> Enum.each(fn grapheme ->
      form
      |> send_keys(query, grapheme)

      :timer.sleep(10)
    end)

    form
  end
end
