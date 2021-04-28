defmodule TextWrap do
  @moduledoc """
  Documentation for `TextWrap`.
  """

  def main(_args) do
    file = File.open!("paragraphs.txt", [:read, :utf8])

    Enum.map(IO.stream(file, :line), &String.trim(&1, "\n"))
    |> Enum.each(fn line ->
      if line == "" do
        IO.puts(line)
      else
        process_line(line, 80)
        |> Enum.each(fn line -> IO.puts(line) end)
      end
    end)

    File.close(file)
  end

  defp process_line(line, max_width) do
    [first_word | line] = String.split(line, ~r/\s+/, trim: true)

    lines_wrapping(line, String.length(first_word), max_width, first_word, [])
  end

  defp lines_wrapping([], _, _, line, acc), do: [line | acc] |> Enum.reverse()

  defp lines_wrapping([first_word | rest], line_length, max_width, line, acc) do
    if max_width_reached?(line_length, first_word, max_width) do
      lines_wrapping(rest, String.length(first_word), max_width, first_word, [line | acc])
    else
      current_line_length = line_length + 1 + String.length(first_word)
      current_line = line <> " " <> first_word

      lines_wrapping(rest, current_line_length, max_width, current_line, acc)
    end
  end

  defp max_width_reached?(line_length, word, max_width),
    do: line_length + 1 + String.length(word) > max_width
end
