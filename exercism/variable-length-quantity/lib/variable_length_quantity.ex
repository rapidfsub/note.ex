defmodule VariableLengthQuantity do
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
      Stream.unfold(integer >>> 7, fn
        n when n > 0 -> {(n &&& 0x7F) ||| 0x80, n >>> 7}
        _ -> nil
      end)

    [integer &&& 0x7F]
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
    |> Enum.chunk_while(
      [],
      fn byte, chunk ->
        if byte < 0x80 do
          {:cont, [byte | chunk], []}
        else
          {:cont, [byte | chunk]}
        end
      end,
      fn
        [] -> {:cont, []}
        chunk -> {:cont, chunk, []}
      end
    )
    |> Enum.reduce_while([], fn chunk, acc ->
      case decode_chunk(chunk) do
        {:ok, decoded} -> {:cont, [decoded | acc]}
        {:error, _reason} = error -> {:halt, error}
      end
    end)
    |> case do
      {:error, _reason} = error -> error
      result -> {:ok, Enum.reverse(result)}
    end
  end

  defp decode_chunk([byte | _rest] = bytes) when byte < 0x80 do
    bits =
      bytes
      |> Enum.reverse()
      |> Enum.map(&<<&1::7>>)
      |> :erlang.list_to_bitstring()

    count = bit_size(bits)
    <<result::size(count)>> = bits
    {:ok, result}
  end

  defp decode_chunk(_bytes) do
    {:error, "incomplete sequence"}
  end
end
