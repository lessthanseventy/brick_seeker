defprotocol BrickSeekerWeb.Option do
  @spec display_name(t) :: String.t()
  def display_name(value)

  @spec value(t) :: String.t()
  def value(value)
end

defimpl BrickSeekerWeb.Option, for: BrickSeeker.Parts.Part do
  alias BrickSeeker.Parts.Part

  def value(%Part{name: name, part_number: part_number}), do: "#{part_number}: #{name}"
  def display_name(part), do: value(part)
end
