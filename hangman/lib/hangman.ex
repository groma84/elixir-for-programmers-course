defmodule Hangman do
  alias Hangman.Game

  def new_game() do
    Game.new_game(Dictionary.random_word(), 7)
  end
end
