defmodule HighScore do
  @initial_score 0

  def new() do
    %{}
  end

  def add_player(scores, name, score \\ @initial_score)
  def add_player(scores, name, score), do: scores |> Map.put(name, score)

  def remove_player(scores, name) do
    scores |> Map.delete(name)
  end

  def reset_score(scores, name) do
    scores |> Map.put(name, @initial_score)
  end

  def update_score(scores, name, score) do
    scores |> Map.put_new(name, @initial_score) |> Map.update!(name, &(&1 + score))
  end

  def get_players(scores) do
    scores |> Map.keys()
  end
end
