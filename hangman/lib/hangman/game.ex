defmodule Hangman.Game do
  defstruct(
    turns_left: 0,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  def new_game(word, turns) do
    %Hangman.Game{
      turns_left: turns,
      letters: word |> String.codepoints()
    }
  end

  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game
  end

  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: game.letters |> reveal_guessed(game.used)
    }
  end

  defp accept_move(game, guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  defp accept_move(game, guess, _already_guessed = false) do
    accept_guess(game, guess, valid_guess?(guess))
  end

  defp valid_guess?(guess) do
    guess =~ ~r/[a-z]/ and String.length(guess) == 1
  end

  defp accept_guess(game, guess, _valid_guess = true) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp accept_guess(game, guess, _valid_guess = false) do
    %{game | game_state: :invalid_guess}
  end

  defp score_guess(game, _good_guess = true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> maybe_won

    Map.put(game, :game_state, new_state)
  end

  defp score_guess(game = %{turns_left: 1}, _bad_guess) do
    Map.put(game, :game_state, :lost)
  end

  defp score_guess(game = %{turns_left: turns_left}, _bad_guess) do
    %{game | game_state: :bad_guess, turns_left: turns_left - 1}
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MapSet.member?(used, letter)) end)
  end

  defp reveal_letter(letter, _in_word = true), do: letter
  defp reveal_letter(letter, _in_word = false), do: "_"
end
