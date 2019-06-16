defmodule Calculator.Type.Fraction do
  alias Calculator.Type.NaN

  @moduledoc """

  ## Examples

      iex> frac = #{__MODULE__}.new(3, 5)
      iex> frac
      %#{__MODULE__}{numer: 3, denom: 5}
      iex> frac |> to_string
      "3/5"

      iex> #{__MODULE__}.new(3, 0)
      #{NaN.by_zero_division() |> inspect}
  """
  defstruct denom: nil, numer: nil

  # 分母
  @typep denom :: integer

  # 分子
  @typep numer :: integer

  @type t :: %__MODULE__{numer: numer, denom: denom}

  @doc """
  与えられた引数から分数を作ります。約分はしません。
  """

  def new(i) when i |> is_integer(), do: %__MODULE__{numer: i, denom: 1}

  def new(f) when f |> is_float() do
    index = f |> to_string |> String.split(".") |> Enum.at(1) |> String.length()
    numer = f |> to_string |> String.replace(".", "") |> String.to_integer()
    new(numer, :math.pow(10, index) |> floor)
  end

  def new(%__MODULE__{} = me), do: me

  @doc """
  分子と分母から分数を作ります。約分はしません。
  """
  @spec new(integer, integer) :: Fraction.t() | NaN.t()
  def new(_, 0), do: NaN.by_zero_division()

  def new(a, b) when a |> is_integer and b |> is_integer and b > 0,
    do: %__MODULE__{numer: a, denom: b}

  @doc """
  約分します
  """
  @spec yakubun(__MODULE__.t()) :: __MODULE__.t()
  def yakubun(%__MODULE__{numer: numer, denom: denom}) do
    gcd = Integer.gcd(numer, denom)
    new(numer |> Integer.floor_div(gcd), denom |> Integer.floor_div(gcd))
  end

  defimpl Alice, for: __MODULE__ do
    [:add, :sub, :multi, :div]
    |> Enum.each(fn function ->
      def unquote(function)(_, %NaN{} = nan), do: nan
    end)

    def add(%{numer: pn, denom: pd}, latter) do
      %@for{numer: sn, denom: sd} = @for.new(latter)
      %@for{numer: pn * sd + sn * pd, denom: pd * sd}
    end

    def sub(former, latter) do
      %@for{numer: n, denom: d} = @for.new(latter)
      add(former, @for.new(-n, d))
    end

    def multi(%{numer: pn, denom: pd}, latter) do
      %@for{numer: sn, denom: sd} = @for.new(latter)
      %@for{numer: pn * sn, denom: pd * sd}
    end

    def div(former, latter) do
      %@for{numer: n, denom: d} = @for.new(latter)
      multi(former, @for.new(d, n))
    end
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(fraction) do
      %{numer: n, denom: d} = fraction |> @for.yakubun()

      if d == 1 do
        n |> Kernel.to_string()
      else
        "#{n}/#{d}"
      end
    end
  end

  defimpl Inspect, for: __MODULE__ do
    import Inspect.Algebra

    def inspect(fraction, _opts) do
      concat(["#Calculator.Type.Fraction<", fraction |> to_string(), ">"])
    end
  end
end
