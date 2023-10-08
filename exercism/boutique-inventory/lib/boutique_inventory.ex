defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    Enum.sort_by(inventory, & &1.price)
  end

  def with_missing_price(inventory) do
    Enum.filter(inventory, &is_nil(&1.price))
  end

  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, fn item ->
      Map.update!(item, :name, &String.replace(&1, old_word, new_word))
    end)
  end

  def increase_quantity(item, count) do
    Map.update!(item, :quantity_by_size, fn quantity_by_size ->
      Map.new(quantity_by_size, fn {size, quantity} ->
        {size, quantity + count}
      end)
    end)
  end

  def total_quantity(item) do
    Enum.reduce(item.quantity_by_size, 0, fn {_, quantity}, acc ->
      acc + quantity
    end)
  end
end
