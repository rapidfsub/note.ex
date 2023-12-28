defmodule ScaleGenerator do
  @accidentals ~w[# b]
  @chromatic_scale_count 13
  @chromatic_scale_in_flats ~w[A Bb B C Db D Eb E F Gb G Ab]
  @chromatic_scale_in_sharps ~w[A A# B C C# D D# E F F# G G#]
  @notes_in_flats_scale ~w[F Bb Eb Ab Db Gb d g c f bb eb]
  @tones ~w[a b c d e f g A B C D E F G]

  @doc """
  Find the note for a given interval (`step`) in a `scale` after the `tonic`.

  "m": one semitone
  "M": two semitones (full tone)
  "A": augmented second (three semitones)

  Given the `tonic` "D" in the `scale` (C C# D D# E F F# G G# A A# B C), you
  should return the following notes for the given `step`:

  "m": D#
  "M": E
  "A": F
  """
  @spec step(scale :: list(String.t()), tonic :: String.t(), step :: String.t()) :: String.t()
  def step(scale, tonic, step) do
    cond do
      tonic in scale ->
        Stream.cycle(scale)
        |> Stream.drop_while(&(&1 != tonic))
        |> Enum.fetch!(offset(step))
    end
  end

  defp offset("m"), do: 1
  defp offset("M"), do: 2
  defp offset("A"), do: 3

  @doc """
  The chromatic scale is a musical scale with thirteen pitches, each a semitone
  (half-tone) above or below another.

  Notes with a sharp (#) are a semitone higher than the note below them, where
  the next letter note is a full tone except in the case of B and E, which have
  no sharps.

  Generate these notes, starting with the given `tonic` and wrapping back
  around to the note before it, ending with the tonic an octave higher than the
  original. If the `tonic` is lowercase, capitalize it.

  "C" should generate: ~w(C C# D D# E F F# G G# A A# B C)
  """
  @spec chromatic_scale(tonic :: String.t()) :: list(String.t())
  def chromatic_scale(tonic) do
    case upcase(tonic) do
      tonic when tonic in @chromatic_scale_in_sharps ->
        @chromatic_scale_in_sharps
        |> Stream.cycle()
        |> Stream.drop_while(&(&1 != tonic))
        |> Enum.take(@chromatic_scale_count)
    end
  end

  defp upcase(tonic) when byte_size(tonic) == 1 and tonic in @tones do
    String.upcase(tonic)
  end

  defp upcase(tonic) when byte_size(tonic) == 2 do
    case String.graphemes(tonic) do
      [tone, accidental] when tone in @tones and accidental in @accidentals ->
        String.upcase(tone) <> accidental
    end
  end

  @doc """
  Sharp notes can also be considered the flat (b) note of the tone above them,
  so the notes can also be represented as:

  A Bb B C Db D Eb E F Gb G Ab

  Generate these notes, starting with the given `tonic` and wrapping back
  around to the note before it, ending with the tonic an octave higher than the
  original. If the `tonic` is lowercase, capitalize it.

  "C" should generate: ~w(C Db D Eb E F Gb G Ab A Bb B C)
  """
  @spec flat_chromatic_scale(tonic :: String.t()) :: list(String.t())
  def flat_chromatic_scale(tonic) do
    case upcase(tonic) do
      tonic when tonic in @chromatic_scale_in_flats ->
        @chromatic_scale_in_flats
        |> Stream.cycle()
        |> Stream.drop_while(&(&1 != tonic))
        |> Enum.take(@chromatic_scale_count)
    end
  end

  @doc """
  Certain scales will require the use of the flat version, depending on the
  `tonic` (key) that begins them, which is C in the above examples.

  For any of the following tonics, use the flat chromatic scale:

  F Bb Eb Ab Db Gb d g c f bb eb

  For all others, use the regular chromatic scale.
  """
  @spec find_chromatic_scale(tonic :: String.t()) :: list(String.t())
  def find_chromatic_scale(tonic) when tonic in @notes_in_flats_scale do
    flat_chromatic_scale(tonic)
  end

  def find_chromatic_scale(tonic) do
    chromatic_scale(tonic)
  end

  @doc """
  The `pattern` string will let you know how many steps to make for the next
  note in the scale.

  For example, a C Major scale will receive the pattern "MMmMMMm", which
  indicates you will start with C, make a full step over C# to D, another over
  D# to E, then a semitone, stepping from E to F (again, E has no sharp). You
  can follow the rest of the pattern to get:

  C D E F G A B C
  """
  @spec scale(tonic :: String.t(), pattern :: String.t()) :: list(String.t())
  def scale(tonic, pattern) do
    pattern = String.graphemes(pattern)
    find_chromatic_scale(tonic) |> scale(pattern, [upcase(tonic)])
  end

  defp scale(_scale, [], result) do
    Enum.reverse(result)
  end

  defp scale(scale, [step | pattern], [tonic | _] = result) do
    note = step(scale, tonic, step)
    scale(scale, pattern, [note | result])
  end
end
