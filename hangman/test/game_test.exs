defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  defp word(), do: "xyz"

  test "new_game returns structure" do
    game = Game.new_game(word(), 7)

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state isnt changed for won or lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game(word(), 7) |> Map.put(:game_state, state)

      assert game = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game =
      Game.new_game(word(), 7)
      |> Game.make_move("x")

    assert game.game_state != :already_used
  end

  test "second occurrence of letter is already used" do
    game =
      Game.new_game(word(), 7)
      |> Game.make_move("x")
      |> Game.make_move("x")

    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game =
      Game.new_game(word(), 7)
      |> Game.make_move("x")

    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is won game" do
    game =
      Game.new_game(word(), 7)
      |> Game.make_move("x")
      |> Game.make_move("y")
      |> Game.make_move("z")

    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "a bad guess is recognized" do
    game =
      Game.new_game(word(), 7)
      |> Game.make_move("a")

    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "a game without turns is lost" do
    game =
      Game.new_game(word(), 1)
      |> Game.make_move("a")

    assert game.game_state == :lost
  end

  test "an invalid input results in an :invalid_guess" do
    game =
      Game.new_game(word(), 1)
      |> Game.make_move("A")

    assert game.game_state == :invalid_guess
  end
end
