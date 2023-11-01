defmodule VariableLengthQuantity do
  @marker 0b1000_0000
  @mask 0b0111_1111
  @mask_size 7

  import Bitwise

  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers) do
    integers
    |> Enum.map(&encode_integer/1)
    |> :erlang.list_to_binary()
  end

  defp encode_integer(integer) do
    tail =
      Stream.unfold(integer >>> @mask_size, fn
        n when n > 0 -> {(n &&& @mask) ||| @marker, n >>> @mask_size}
        _ -> nil
      end)

    [integer &&& @mask]
    |> Stream.concat(tail)
    |> Enum.reverse()
    |> :erlang.list_to_binary()
  end

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes) do
    bytes
    |> :erlang.binary_to_list()
    |> decode_bytes([])
  end

  defp decode_bytes([], []) do
    {:ok, []}
  end

  defp decode_bytes([], chunk) do
    with {:ok, result} <- decode_chunk(chunk) do
      {:ok, [result]}
    end
  end

  defp decode_bytes([byte | bytes], chunk) when byte < @marker do
    with {:ok, decoded} <- decode_chunk([byte | chunk]),
         {:ok, result} <- decode_bytes(bytes, []) do
      {:ok, [decoded | result]}
    end
  end

  defp decode_bytes([byte | bytes], chunk) do
    decode_bytes(bytes, [byte | chunk])
  end

  defp decode_chunk([byte | _bytes] = chunk) when byte < @marker do
    result =
      chunk
      |> Enum.map(&(&1 &&& @mask))
      |> Enum.reverse()
      |> Enum.reduce(0, &(&2 <<< @mask_size ||| &1))

    {:ok, result}
  end

  defp decode_chunk(_chunk) do
    {:error, "incomplete sequence"}
  end
end
