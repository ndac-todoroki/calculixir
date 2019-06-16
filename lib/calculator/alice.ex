defprotocol Alice do
  @moduledoc """
  Alice's Arithmetic!
  """

  alias __MODULE__, as: Alice

  @fallback_to_any true

  @spec add(Alice.t(), Alice.t()) :: Alice.t()
  def add(former, latter)

  @spec sub(Alice.t(), Alice.t()) :: Alice.t()
  def sub(former, latter)

  @spec multi(Alice.t(), Alice.t()) :: Alice.t()
  def multi(former, latter)

  @spec div(Alice.t(), Alice.t()) :: Alice.t()
  def div(former, latter)
end

defimpl Alice, for: Any do
  alias Calculator.Type.{Fraction, NaN}

  [:add, :sub, :multi, :div]
  |> Enum.each(fn function ->
    def unquote(function)(_, %NaN{} = nan), do: nan

    def unquote(function)(any1, any2),
      do: Alice.unquote(function)(Fraction.new(any1), Fraction.new(any2))
  end)
end
