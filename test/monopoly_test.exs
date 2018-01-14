defmodule MonopolyTest do
  use ExUnit.Case
  doctest Monopoly

  alias Monopoly.{Game, Space, Player}

  setup do
    game = Monopoly.init(players: ["nayeon", "tzuyu", "momo"])

    {:ok, game: game}
  end

  test "plays a game", state do
    game = state.game

    assert game.history == ["Game begins with nayeon, tzuyu, momo!"]

    assert game.players == [
             %Player{name: "nayeon"},
             %Player{name: "tzuyu"},
             %Player{name: "momo"}
           ]
  end

  test "assign to space 1" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)

    assert Enum.at(game.board, 1).players == ["nayeon"]
    assert Enum.at(game.board, 1).name == "Mediterranean Avenue"
  end

  test "assign to space 2" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 2)

    assert Enum.at(game.board, 0).players == []
    assert Enum.at(game.board, 2).players == ["nayeon"]
    assert Enum.at(game.board, 2).name == "Community Chest"
  end

  test "assign to space 3" do
    game =
      Monopoly.assign_to_space(%Game{}, "nayeon", 1)
      |> Monopoly.assign_to_space("nayeon", 2)

    assert Enum.at(game.board, 1).players == ["nayeon"]
    assert Enum.at(game.board, 2).players == ["nayeon"]
    assert Enum.at(game.board, 2).name == "Community Chest"
  end

  test "remove from space 1" do
    game =
      Monopoly.assign_to_space(%Game{}, "nayeon", 1)
      |> Monopoly.remove_from_space("nayeon", 1)
      |> Monopoly.assign_to_space("nayeon", 2)

    assert Enum.at(game.board, 1).players == []
    assert Enum.at(game.board, 2).players == ["nayeon"]
    assert Enum.at(game.board, 2).name == "Community Chest"
  end

  test "move player from to" do
    game =
      Monopoly.assign_to_space(%Game{}, "nayeon", 1)
      |> Monopoly.move_player("nayeon", from: 1, to: 2)

    assert Enum.at(game.board, 1).players == []
    assert Enum.at(game.board, 2).players == ["nayeon"]
    assert Enum.at(game.board, 2).name == "Community Chest"
  end

  test "move player to" do
    game =
      Monopoly.assign_to_space(%Game{}, "nayeon", 1)
      |> Monopoly.move_player("nayeon", to: 2)

    assert Enum.at(game.board, 1).players == []
    assert Enum.at(game.board, 2).players == ["nayeon"]
    assert Enum.at(game.board, 2).name == "Community Chest"
  end

  test "move player spaces" do
    game =
      Monopoly.assign_to_space(%Game{}, "nayeon", 1)
      |> Monopoly.move_player("nayeon", spaces: 1)

    assert Enum.at(game.board, 1).players == []
    assert Enum.at(game.board, 2).players == ["nayeon"]
    assert Enum.at(game.board, 2).name == "Community Chest"
    assert game.history == ["nayeon lands on Community Chest"]
  end

  test "move player spaces 2" do
    game =
      Monopoly.assign_to_space(%Game{}, "nayeon", 1)
      |> Monopoly.move_player("nayeon", spaces: 3)

    assert Enum.at(game.board, 1).players == []
    assert Enum.at(game.board, 4).players == ["nayeon"]
    assert Enum.at(game.board, 4).name == "Income Tax (pay $200)"
    assert game.history == ["nayeon lands on Income Tax (pay $200)"]
  end

  test "move player spaces wrap around", state do
    game =
      state.game
      |> Monopoly.remove_from_space("nayeon", 0)
      |> Monopoly.assign_to_space("nayeon", 35)
      |> Monopoly.move_player("nayeon", spaces: 7)

    assert Enum.at(game.board, 35).players == []
    assert Enum.at(game.board, 2).players == ["nayeon"]
    assert Enum.at(game.board, 2).name == "Community Chest"

    assert game.history == [
             "nayeon lands on Community Chest",
             "nayeon passes Go, collects $200",
             "Game begins with nayeon, tzuyu, momo!"
           ]
  end

  test "player_index" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)
    assert Monopoly.player_index(game.board, "nayeon") == 1

    game = Monopoly.move_player(game, "nayeon", to: 3)
    assert Monopoly.player_index(game.board, "nayeon") == 3
  end

  test "perform_move", state do
    game =
      state.game
      |> Monopoly.perform_move("nayeon", spaces: 8)

    assert Enum.at(game.board, 0).players == ["momo", "tzuyu"]
    assert Enum.at(game.board, 8).players == ["nayeon"]
    assert Enum.at(game.board, 2).name == "Community Chest"

    assert game.history == [
             "nayeon lands on Vermont Avenue",
             "nayeon moves 8 spaces",
             "Game begins with nayeon, tzuyu, momo!"
           ]
  end

  test "passes Go", state do
    game =
      state.game
      |> Monopoly.remove_from_space("nayeon", 0)
      |> Monopoly.assign_to_space("nayeon", 35)
      |> Monopoly.move_player("nayeon", spaces: 7)

    assert Enum.at(game.board, 35).players == []
    assert Enum.at(game.board, 2).players == ["nayeon"]
    assert Enum.at(game.board, 2).name == "Community Chest"

    assert game.history == [
             "nayeon lands on Community Chest",
             "nayeon passes Go, collects $200",
             "Game begins with nayeon, tzuyu, momo!"
           ]

    assert Enum.map(game.players, fn player -> {player.name, player.money} end) == [
             {"nayeon", 1700},
             {"tzuyu", 1500},
             {"momo", 1500}
           ]
  end

  test "find_player_on_board" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)

    assert Monopoly.find_player_on_board(game, "nayeon") == %Monopoly.Space{
             name: "Mediterranean Avenue",
             players: ["nayeon"]
           }
  end

  test "find_player", state do
    assert Monopoly.find_player(state.game.players, "nayeon") ==
             {0, %Player{money: 1500, name: "nayeon"}}
  end

  test "find_player when the player doesn't exist", state do
    assert_raise RuntimeError, "Player dubu does not exist in [nayeon, tzuyu, momo]", fn ->
      Monopoly.find_player(state.game.players, "dubu") == {nil, nil}
    end
  end

  test "add_money", state do
    game = Monopoly.add_money(state.game, "nayeon", 200)

    assert game.players == [
             %Monopoly.Player{money: 1700, name: "nayeon"},
             %Monopoly.Player{money: 1500, name: "tzuyu"},
             %Monopoly.Player{money: 1500, name: "momo"}
           ]
  end
end
