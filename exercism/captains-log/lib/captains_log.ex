defmodule CaptainsLog do
  @planetary_classes ~w[D H J K L M N R T Y]

  def random_planet_class() do
    Enum.random(@planetary_classes)
  end

  def random_ship_registry_number() do
    "NCC-#{Enum.random(1000..9999)}"
  end

  def random_stardate() do
    1000 * :rand.uniform() + 41000
  end

  def format_stardate(stardate) when is_float(stardate) do
    Float.round(stardate, 1) |> to_string()
  end

  def format_stardate(_stardate) do
    raise ArgumentError
  end
end
