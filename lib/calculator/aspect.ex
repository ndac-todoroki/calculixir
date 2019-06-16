defprotocol Calculator.Aspectable do
  @moduledoc """
  times(div(1, 3), div(3, 5))

  [{:times, }]

  1 / 3 + 3 / 5

  1 3 div 3 5 div add

  add = %Aspect.Add{elems: [
    %Aspect.Div{elems: [1, 3]},
    %Aspect.Div{elems: [3, 5]},
  ]}

  add |> Aspect.compute()
  """

  @spec compute(__MODULE__.t()) :: Alice.t()
  def compute(aspect)

  @spec nearly_equal?(__MODULE__.t(), __MODULE__.t()) :: boolean
  def nearly_equal?(x, y)
end

defimpl Calculator.Aspectable, for: [Integer, Float] do
  def compute(num), do: num

  def nearly_equal?(x, y), do: x == y
end

defmodule Calculator.Aspect do
  @moduledoc """
  Infix operator for Aspect.
  """

  defmacro __using__(_) do
    quote do
      @type aspect :: Calculator.Aspectable.t()

      @doc """
      Equality-ish test for floats that are nearly equal.
      """
      @spec aspect <~> aspect :: boolean
      def x <~> y do
        Calculator.Aspectable.nearly_equal?(x, y)
      end
    end
  end
end
