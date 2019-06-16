defmodule Calculator.Aspect.Div do
  defstruct former: 0, latter: 0

  alias __MODULE__, as: Self

  def new(f, l), do: %Self{former: f, latter: l}

  defimpl Calculator.Aspectable, for: __MODULE__ do
    def compute(%@for{former: elem1, latter: elem2}) do
      Alice.div(@protocol.compute(elem1), @protocol.compute(elem2))
    end

    def nearly_equal?(%@for{former: af, latter: al}, %@for{former: bf, latter: bl}),
      do: af == bf and al == bl

    def nearly_equal?(%x{}, %y{}) when x != y, do: false
    def nearly_equal?(_, _), do: false
  end
end
