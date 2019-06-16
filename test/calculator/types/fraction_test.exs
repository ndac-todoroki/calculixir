defmodule Calculator.Type.FractionTest do
  use ExUnit.Case, async: true
  @target Calculator.Type.Fraction

  doctest @target, async: true

  describe "#{@target}.new" do
    test "denom is 0" do
      assert @target.new(10, 0) == zero_division_error()
    end
  end

  defp zero_division_error do
    Calculator.Type.NaN.by_zero_division()
  end
end
