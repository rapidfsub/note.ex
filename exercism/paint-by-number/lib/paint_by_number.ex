defmodule PaintByNumber do
  def palette_bit_size(color_count) do
    do_palette_bit_size(color_count, 1)
  end

  defp do_palette_bit_size(color_count, result) do
    if Integer.pow(2, result) < color_count do
      do_palette_bit_size(color_count, result + 1)
    else
      result
    end
  end

  def empty_picture() do
    <<>>
  end

  def test_picture() do
    <<0::2, 1::2, 2::2, 3::2>>
  end

  def prepend_pixel(picture, color_count, pixel_color_index) do
    bit_size = palette_bit_size(color_count)
    <<pixel_color_index::size(bit_size), picture::bits>>
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
    bit_size = palette_bit_size(color_count)
    <<first::size(^bit_size), rest::bits>> = picture
    {first, rest}
  end

  def concat_pictures(picture1, picture2) do
    <<picture1::bits, picture2::bits>>
  end
end
