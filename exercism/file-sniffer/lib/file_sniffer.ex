defmodule FileSniffer do
  def type_from_extension("exe"), do: "application/octet-stream"
  def type_from_extension("bmp"), do: "image/bmp"
  def type_from_extension("png"), do: "image/png"
  def type_from_extension("jpg"), do: "image/jpg"
  def type_from_extension("gif"), do: "image/gif"
  def type_from_extension(_extension), do: nil

  def type_from_binary(<<0x7F45_4C46::size(4)-unit(8), _::bytes>>), do: "application/octet-stream"
  def type_from_binary(<<0x424D::size(2)-unit(8), _::bytes>>), do: "image/bmp"
  def type_from_binary(<<0x8950_4E47_0D0A_1A0A::size(8)-unit(8), _::bytes>>), do: "image/png"
  def type_from_binary(<<0xFF_D8FF::size(3)-unit(8), _::bytes>>), do: "image/jpg"
  def type_from_binary(<<0x47_4946::size(3)-unit(8), _::bytes>>), do: "image/gif"
  def type_from_binary(_file_binary), do: nil

  def verify(file_binary, extension) do
    type = type_from_binary(file_binary)

    case type_from_extension(extension) do
      ^type when not is_nil(type) -> {:ok, type}
      _ -> {:error, "Warning, file format and file extension do not match."}
    end
  end
end
