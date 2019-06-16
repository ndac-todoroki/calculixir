defmodule Calculator.Aspect.Multiply do
  defstruct former: 0, latter: 0

  alias __MODULE__, as: Self

  def new(f, l), do: %Self{former: f, latter: l}

  defimpl Calculator.Aspectable, for: __MODULE__ do
    @spec compute(@for.t()) :: Alice.t()
    def compute(%@for{former: elem1, latter: elem2}) do
      @protocol.compute(elem1) |> Alice.multi(@protocol.compute(elem2))
    end

    def nearly_equal?(%@for{former: af, latter: al}, %@for{former: bf, latter: bl}),
      do: af == bf and al == bl

    def nearly_equal?(%x{}, %y{}) when x != y, do: false
    def nearly_equal?(_, _), do: false
  end
end
