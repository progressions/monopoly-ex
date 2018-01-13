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

    assert game == %Game{
             board: [
               %Space{name: "Go", players: ["momo", "tzuyu", "nayeon"], type: :go},
               %Space{name: "Mediterranean Ave", players: []},
               %Space{name: "Baltic Ave", players: []},
               %Space{name: "Vermont Ave", players: []},
               %Space{name: "Connecticut Ave", players: []}
             ],
             history: ["Game begins with nayeon, tzuyu, momo!"],
             players: [%Player{name: "nayeon"}, %Player{name: "tzuyu"}, %Player{name: "momo"}]
           }
  end

  test "assign to space 1" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)

    assert game.board == [
             %Monopoly.Space{name: "Go", players: [], type: :go},
             %Monopoly.Space{name: "Mediterranean Ave", players: ["nayeon"]},
             %Monopoly.Space{name: "Baltic Ave", players: []},
             %Monopoly.Space{name: "Vermont Ave", players: []},
             %Monopoly.Space{name: "Connecticut Ave", players: []}
           ]
  end

  test "assign to space 2" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 2)

    assert game.board == [
             %Monopoly.Space{name: "Go", players: [], type: :go},
             %Monopoly.Space{name: "Mediterranean Ave", players: []},
             %Monopoly.Space{name: "Baltic Ave", players: ["nayeon"]},
             %Monopoly.Space{name: "Vermont Ave", players: []},
             %Monopoly.Space{name: "Connecticut Ave", players: []}
           ]
  end

  test "assign to space 3" do
    game =
      Monopoly.assign_to_space(%Game{}, "nayeon", 1)
      |> Monopoly.assign_to_space("nayeon", 2)

    assert game.board == [
             %Monopoly.Space{name: "Go", players: [], type: :go},
             %Monopoly.Space{name: "Mediterranean Ave", players: ["nayeon"]},
             %Monopoly.Space{name: "Baltic Ave", players: ["nayeon"]},
             %Monopoly.Space{name: "Vermont Ave", players: []},
             %Monopoly.Space{name: "Connecticut Ave", players: []}
           ]
  end

  test "remove from space 1" do
    game =
      Monopoly.assign_to_space(%Game{}, "nayeon", 1)
      |> Monopoly.remove_from_space("nayeon", 1)
      |> Monopoly.assign_to_space("nayeon", 2)

    assert game.board == [
             %Monopoly.Space{name: "Go", players: [], type: :go},
             %Monopoly.Space{name: "Mediterranean Ave", players: []},
             %Monopoly.Space{name: "Baltic Ave", players: ["nayeon"]},
             %Monopoly.Space{name: "Vermont Ave", players: []},
             %Monopoly.Space{name: "Connecticut Ave", players: []}
           ]
  end

  test "move player from to" do
    game =
      Monopoly.assign_to_space(%Game{}, "nayeon", 1)
      |> Monopoly.move_player("nayeon", from: 1, to: 2)

    assert game.board == [
             %Monopoly.Space{name: "Go", players: [], type: :go},
             %Monopoly.Space{name: "Mediterranean Ave", players: []},
             %Monopoly.Space{name: "Baltic Ave", players: ["nayeon"]},
             %Monopoly.Space{name: "Vermont Ave", players: []},
             %Monopoly.Space{name: "Connecticut Ave", players: []}
           ]
  end

  test "move player to" do
    game =
      Monopoly.assign_to_space(%Game{}, "nayeon", 1)
      |> Monopoly.move_player("nayeon", to: 2)

    assert game.board == [
             %Monopoly.Space{name: "Go", players: [], type: :go},
             %Monopoly.Space{name: "Mediterranean Ave", players: []},
             %Monopoly.Space{name: "Baltic Ave", players: ["nayeon"]},
             %Monopoly.Space{name: "Vermont Ave", players: []},
             %Monopoly.Space{name: "Connecticut Ave", players: []}
           ]
  end

  test "move player spaces" do
    game =
      Monopoly.assign_to_space(%Game{}, "nayeon", 1)
      |> Monopoly.move_player("nayeon", spaces: 1)

    assert game.board == [
             %Monopoly.Space{name: "Go", players: [], type: :go},
             %Monopoly.Space{name: "Mediterranean Ave", players: []},
             %Monopoly.Space{name: "Baltic Ave", players: ["nayeon"]},
             %Monopoly.Space{name: "Vermont Ave", players: []},
             %Monopoly.Space{name: "Connecticut Ave", players: []}
           ]
  end

  test "move player spaces 2" do
    game =
      Monopoly.assign_to_space(%Game{}, "nayeon", 1)
      |> Monopoly.move_player("nayeon", spaces: 3)

    assert game.board == [
             %Monopoly.Space{name: "Go", players: [], type: :go},
             %Monopoly.Space{name: "Mediterranean Ave", players: []},
             %Monopoly.Space{name: "Baltic Ave", players: []},
             %Monopoly.Space{name: "Vermont Ave", players: []},
             %Monopoly.Space{name: "Connecticut Ave", players: ["nayeon"]}
           ]
  end

  test "move player spaces wrap around", state do
    game = Monopoly.move_player(state.game, "nayeon", spaces: 5)

    assert game.board == [
             %Monopoly.Space{name: "Go", players: ["nayeon", "momo", "tzuyu"], type: :go},
             %Monopoly.Space{name: "Mediterranean Ave", players: []},
             %Monopoly.Space{name: "Baltic Ave", players: []},
             %Monopoly.Space{name: "Vermont Ave", players: []},
             %Monopoly.Space{name: "Connecticut Ave", players: []}
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
      Monopoly.assign_to_space(state.game, "nayeon", 1)
      |> Monopoly.perform_move("nayeon", spaces: 4)

    assert game.board == [
             %Monopoly.Space{name: "Go", type: :go, players: ["momo", "tzuyu"]},
             %Monopoly.Space{name: "Mediterranean Ave", players: [], type: nil},
             %Monopoly.Space{name: "Baltic Ave", type: nil, players: ["nayeon"]},
             %Monopoly.Space{name: "Vermont Ave", type: nil, players: ["nayeon"]},
             %Monopoly.Space{name: "Connecticut Ave", players: [], type: nil}
           ]

    assert game.history == [
             "nayeon lands on Baltic Ave",
             "nayeon moves 4 spaces",
             "Game begins with nayeon, tzuyu, momo!"
           ]
  end

  test "passes Go", state do
    game = Monopoly.perform_move(state.game, "nayeon", spaces: 6)

    assert game.history == [
             "nayeon lands on Mediterranean Ave",
             "nayeon passes Go, collects $200",
             "nayeon moves 6 spaces",
             "Game begins with nayeon, tzuyu, momo!"
           ]

    assert game.players == [
             %Monopoly.Player{money: 1700, name: "nayeon"},
             %Monopoly.Player{money: 1500, name: "tzuyu"},
             %Monopoly.Player{money: 1500, name: "momo"}
           ]
  end

  test "find_player_on_board" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)

    assert Monopoly.find_player_on_board(game, "nayeon") == %Monopoly.Space{
             name: "Mediterranean Ave",
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
