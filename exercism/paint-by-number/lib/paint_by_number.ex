defmodule PaintByNumber do
  def palette_bit_size(color_count) when color_count > 2 do
    ceil(color_count / 2)
    |> palette_bit_size()
    |> Kernel.+(1)
  end

  def palette_bit_size(color_count) when color_count > 0 do
    1
  end

  def empty_picture() do
    <<>>
  end

  def test_picture() do
    <<0::2, 1::2, 2::2, 3::2>>
  end

  def prepend_pixel(picture, color_count, pixel_color_index) do
    <<pixel_color_index::size(palette_bit_size(color_count)), picture::bitstring>>
  end

  def get_first_pixel(picture, color_count) do
    split_first_pixel(picture, color_count) |> elem(0)
  end

  def drop_first_pixel(picture, color_count) do
    split_first_pixel(picture, color_count) |> elem(1)
  end

  defp split_first_pixel(<<>>, _color_count) do
    {nil, <<>>}
  end

  defp split_first_pixel(picture, color_count) do
    count = palette_bit_size(color_count)
    <<first::size(^count), rest::bitstring>> = picture
    {first, rest}
  end

  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end
end
