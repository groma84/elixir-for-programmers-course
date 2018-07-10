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
    {game, tally(game)}
  end

  def make_move(game, guess) do
    changed_game = accept_move(game, guess, MapSet.member?(game.used, guess))
    {changed_game, tally(changed_game)}
  end

  def accept_move(game, guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  def accept_move(game, guess, _already_guessed = false) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  def score_guess(game, _good_guess = true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> maybe_won

    Map.put(game, :game_state, new_state)
  end

  def score_guess(game = %{turns_left: 1}, _bad_guess) do
    Map.put(game, :game_state, :lost)
  end

  def score_guess(game = %{turns_left: turns_left}, _bad_guess) do
    %{game | game_state: :bad_guess, turns_left: turns_left - 1}
  end

  def maybe_won(true), do: :won
  def maybe_won(_), do: :good_guess

  def tally(game) do
    # TODO
    123
  end
end
