defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    flags = MapSet.new(flags)
    predicate = predicate(pattern, flags)
    files = Enum.uniq(files)

    if MapSet.member?(flags, "-l") do
      for file <- files, File.stream!(file) |> Enum.any?(predicate) do
        "#{file}\n"
      end
    else
      line_numbers? = MapSet.member?(flags, "-n")
      many_files? = length(files) > 1

      files
      |> Stream.flat_map(fn file ->
        file
        |> File.stream!()
        |> Stream.with_index(1)
        |> Stream.filter(fn {line, _index} -> predicate.(line) end)
        |> Stream.map(mapper(file, line_numbers?, many_files?))
      end)
    end
    |> Enum.join()
  end

  defp predicate(pattern, flags) do
    regex = regex_compile!(pattern, flags)

    if MapSet.member?(flags, "-v") do
      &(not Regex.match?(regex, &1))
    else
      &Regex.match?(regex, &1)
    end
  end

  defp regex_compile!(pattern, flags) do
    regex_source(pattern, flags) |> Regex.compile!(regex_options(flags))
  end

  defp regex_source(pattern, flags) do
    if MapSet.member?(flags, "-x") do
      "^#{pattern}$"
    else
      pattern
    end
  end

  defp regex_options(flags) do
    if MapSet.member?(flags, "-i") do
      "i"
    else
      ""
    end
  end

  defp mapper(file, line_number?, many_files?) do
    cond do
      line_number? && many_files? -> fn {line, index} -> "#{file}:#{index}:#{line}" end
      line_number? -> fn {line, index} -> "#{index}:#{line}" end
      many_files? -> fn {line, _index} -> "#{file}:#{line}" end
      true -> fn {line, _index} -> line end
    end
  end
end
