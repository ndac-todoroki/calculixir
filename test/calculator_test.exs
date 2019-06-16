defmodule CalculatorTest do
  use ExUnit.Case, async: true
  doctest Calculator, async: true

  @module Calculator

  describe "when calculator has no stages" do
    setup [:calculator_with_no_stages]

    test "#{@module}.answer/1", %{calculator: calc} do
      assert @module.answer(calc, 0) == {:ok, 0}
      assert match?({:error, _}, @module.answer(calc, 1))
      assert match?({:error, _}, @module.answer(calc, -1))
    end
  end

  describe "calculator has many stages" do
    setup [:calculator_with_five_stages]

    test "#{@module}.answer/1", %{calculator: calc} do
      assert match?({:ok, _}, @module.answer(calc, 0))
      assert match?({:ok, _}, @module.answer(calc, 1))
      assert match?({:ok, _}, @module.answer(calc, -1))
    end
  end

  defp calculator_with_no_stages(context) do
    %{calculator: @module.new()}
  end

  defp calculator_with_five_stages(context) do
    calc = @module.new()
    %{calculator: calc}
  end
end
