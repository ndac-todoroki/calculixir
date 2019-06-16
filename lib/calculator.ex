defmodule Calculator do
  @moduledoc """
  Documentation for Calculator.
  """

  alias Calculator, as: Self

  defstruct stages: []

  @type t :: %__MODULE__{
          stages: [Calculator.Stage.t()]
        }

  @doc """
  ## Examples
      iex> Calculator.new
      %Calculator{stages: []}
  """
  def new, do: %Self{}

  def add_stage(calculator)

  def show_result(calculator), do: calculator |> answer(0)

  @doc """
  指定したindexのステージまでの結果を返す
  `n == 0` で最後の時点での値
  `n < 0` で今から |n|個前のステージまでの答え

  ### Examples

  """
  @spec answer(calculator :: Self.t(), n :: :integer) :: {:ok, :number} | {:error, reason}
        when reason: term
  def answer(calculator, n)

  def answer(calculator, 0) do
    init = Self.new()

    case calculator do
      ^init ->
        {:ok, 0}

      _ ->
        {:error, :not_implemented}
    end
  end

  def answer(calculator, n) when is_integer(n) and n < 0, do: {:error, :not_implemented}
  def answer(calculator, n) when is_integer(n) and n > 0, do: {:error, :not_implemented}
end
