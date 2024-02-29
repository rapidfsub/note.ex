defmodule Bed.Extension.Factory.Transformer do
  use Spark.Dsl.Transformer

  @impl Spark.Dsl.Transformer
  def transform(dsl_state) do
    {:ok, dsl_state}
  end
end
