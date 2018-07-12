defmodule Hangman do
  alias Hangman.Game

  def new_game() do
    Game.new_game(Dictionary.random_word(), 7)
  end

  def make_move(game, guess) do
    game = Game.make_move(game, guess)
    {game, tally(game)}
  end

  defdelegate tally(game), to: Game
end
