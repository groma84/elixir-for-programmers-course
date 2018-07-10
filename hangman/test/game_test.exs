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

      assert {^game, _} = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game(word(), 7)
    {game1, _tally} = Game.make_move(game, "x")
    assert game1.game_state != :already_used
  end

  test "second occurrence of letter is already used" do
    game = Game.new_game(word(), 7)
    {game1, _tally} = Game.make_move(game, "x")
    {game2, _tally} = Game.make_move(game1, "x")
    assert game2.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game(word(), 7)
    {game2, _tally} = Game.make_move(game, "x")

    assert game2.game_state == :good_guess
    assert game2.turns_left == 7
  end

  test "a guessed word is won game" do
    game = Game.new_game(word(), 7)
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "z")

    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "a bad guess is recognized" do
    game = Game.new_game(word(), 7)
    {game, _tally} = Game.make_move(game, "a")

    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "a game without turns is lost" do
    game = Game.new_game(word(), 1)
    {game, _tally} = Game.make_move(game, "a")

    assert game.game_state == :lost
  end
end
