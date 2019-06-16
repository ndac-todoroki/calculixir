defmodule Calculator.ParserTest do
  alias Calculator.Aspect.{Add, Sub, Multiply, Div}

  use ExUnit.Case, async: true
  use Calculator.Aspect

  @module Calculator.Parser

  doctest @module, async: true

  describe "#{@module}.parse/1" do
    test "valid: single numbers" do
      assert {:ok, ans} = @module.parse("2")
      assert ans == 2

      assert {:ok, ans} = @module.parse("99")
      assert ans == 99

      assert {:ok, ans} = @module.parse(" 100")
      assert ans == 100

      assert {:ok, ans} = @module.parse("-2")
      assert ans == -2

      assert {:ok, ans} = @module.parse("2.5")
      assert ans == 2.5

      assert {:ok, ans} = @module.parse("-0.6")
      assert ans == -0.6
    end

    test "invalid: wrong single numbers" do
      assert {:error, a} = @module.parse("*3")
    end

    test "valid: simple arthimetics" do
      assert {:ok, a} = @module.parse("2 + 3")
      assert {:ok, ^a} = @module.parse("2+3")
      assert a <~> Add.new(2.0, 3.0)

      assert {:ok, b} = @module.parse("10 - 5")
      assert {:ok, ^b} = @module.parse("10-5")
      assert b <~> Sub.new(10.0, 5.0)

      assert {:ok, c} = @module.parse("1 * 5")
      assert {:ok, ^c} = @module.parse("1*5")
      assert c <~> Multiply.new(1.0, 5.0)

      assert {:ok, d} = @module.parse("10 / 2")
      assert {:ok, ^d} = @module.parse("10/2")
      assert d <~> Div.new(10.0, 2.0)
    end
  end
end
