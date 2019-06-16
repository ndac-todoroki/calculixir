defmodule Calculator.Type.NaN do
  defstruct reason: nil

  @type t :: %__MODULE__{reason: String.t()}

  def new(reason) when reason |> is_binary(), do: %__MODULE__{reason: reason}

  def by_zero_division, do: new("Zero division occured")

  defimpl Alice, for: __MODULE__ do
    functions = [:add, :sub, :multi, :div]

    functions
    |> Enum.each(fn function ->
      def unquote(function)(nan, _), do: nan
    end)
  end

  defimpl String.Chars, for: __MODULE__ do
    @spec to_string(@for.t) :: String.t()
    def to_string(nan), do: "Invalid calculation occured! reason: #{nan.reason}"
  end
end
