defmodule DancingDots.Animation do
  alias DancingDots.Dot

  @type dot :: Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts :: opts()) :: {:ok, opts()} | {:error, error()}
  @callback handle_frame(dot :: dot(), frame_number :: frame_number(), opts :: opts()) :: dot()

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation

      @impl DancingDots.Animation
      def init(opts) do
        {:ok, opts}
      end

      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, _opts) do
    case rem(frame_number, 4) do
      0 -> %{dot | opacity: dot.opacity / 2}
      _ -> dot
    end
  end
end

defmodule DancingDots.Zoom do
  @velocity_required "The :velocity option is required, and its value must be a number."

  use DancingDots.Animation

  @impl DancingDots.Animation
  def init(opts) do
    case Keyword.get(opts, :velocity) do
      velocity when is_number(velocity) -> {:ok, opts}
      velocity -> {:error, "#{@velocity_required} Got: #{inspect(velocity)}"}
    end
  end

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, opts) do
    velocity = Keyword.fetch!(opts, :velocity)
    %{dot | radius: dot.radius + (frame_number - 1) * velocity}
  end
end
