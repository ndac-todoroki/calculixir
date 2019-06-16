defmodule Calculator.Parser do
  @moduledoc """
  Parses string into an Aspect tree.

  ## Examples
      iex> alias Calculator.Parser
      iex> alias Calculator.Aspect.{Add, Sub, Div, Multiply}
      iex> {:ok, result} = "1 + 2 / (5 - 3)" |> Parser.parse()
      {:ok, Div.new(Add.new(1.0, 2.0), Sub.new(5.0, 3.0))}
  """

  alias Calculator.Aspect

  def parse(string) do
    case do_parse(string) do
      {:error, reason} ->
        {:error, reason}

      {former, ""} ->
        {:ok, former}
    end
  end

  @spec do_parse(String.t()) :: {Calculator.Aspect.t(), String.t()}
  def do_parse(string) do
    {result, rest} = do_parse_term(string)
    do_parse(result, rest)
  end

  @spec do_parse(any, any) :: {any, <<>>} | {:error, tuple}
  def do_parse(:error, reason), do: {:error, reason}

  def do_parse(result, ""), do: {result, ""}

  def do_parse(former, string) do
    {result, rest} = do_parse_term(string, former)
    do_parse(result, rest)
  end

  @spec do_parse_term(String.t()) :: {Calculator.Aspect.t(), String.t()}

  defp do_parse_term("(" <> string) do
    {former, rest} = do_parse_term(string, nil)
    do_parse_term(rest, former)
  end

  defp do_parse_term(" " <> string), do: do_parse_term(string)

  # parses number. "1.2 + 3" => {1.2, " + 3"}
  # returns fast. (see do_parse_term/2)
  defp do_parse_term(string) do
    with {float, rest} <- string |> Float.parse() do
      {float, rest}
    else
      :error ->
        {:error, {:invalid_token, string |> String.first()}}
    end
  end

  @spec do_parse_term(String.t(), Calculator.Aspect.t() | nil) ::
          {Calculator.Aspect.t(), String.t()}

  defp do_parse_term(")" <> string, former) do
    {former, string}
  end

  defp do_parse_term(" " <> string, former), do: do_parse_term(string, former)

  # foo "* 2 + 3" => {Aspect.Multiply.new(foo, 2), "+ 3"}
  defp do_parse_term("*" <> string, former) do
    {latter, rest} = do_parse_term(string)
    result = Aspect.Multiply.new(former, latter)
    {result, rest}
  end

  defp do_parse_term("/" <> string, former) do
    {latter, rest} = do_parse_term(string)
    result = Aspect.Div.new(former, latter)
    {result, rest}
  end

  # parses number. "1.2 + 3 + 4" => {Aspect.Add.new(1.2, Aspect.Add.new(3, 4))}
  # returns slow.
  defp do_parse_term(string, nil) do
    {former, rest} = string |> Float.parse()
    do_parse_term(rest, former)
  end

  defp do_parse_term("+" <> string, former) do
    {latter, rest} = do_parse_term(string, nil)
    result = Aspect.Add.new(former, latter)
    {result, rest}
  end

  defp do_parse_term("-" <> string, former) do
    {latter, rest} = do_parse_term(string, nil)
    result = Aspect.Sub.new(former, latter)
    {result, rest}
  end

  defp do_parse_term("", former), do: {former, ""}
end
