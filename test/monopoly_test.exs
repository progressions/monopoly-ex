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
    assert game == %Game{board: [%Space{name: "Go",
      players: ["momo", "tzuyu", "nayeon"], type: :go},
      %Space{name: "Mediterranean Ave", players: []},
      %Space{name: "Baltic Ave", players: []},
      %Space{name: "Vermont Ave", players: []},
      %Space{name: "Connecticut Ave", players: []}],
      history: ["Game begins with nayeon, tzuyu, momo!"],
      players: [%Player{name: "nayeon"},
      %Player{name: "tzuyu"}, %Player{name: "momo"}]}
  end

  test "assign to space 1" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)
    assert game.board == [%Monopoly.Space{name: "Go", players: [], type: :go},
      %Monopoly.Space{name: "Mediterranean Ave", players: ["nayeon"]},
      %Monopoly.Space{name: "Baltic Ave", players: []},
      %Monopoly.Space{name: "Vermont Ave", players: []},
      %Monopoly.Space{name: "Connecticut Ave", players: []}]
  end

  test "assign to space 2" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 2)
    assert game.board == [%Monopoly.Space{name: "Go", players: [], type: :go},
      %Monopoly.Space{name: "Mediterranean Ave", players: []},
      %Monopoly.Space{name: "Baltic Ave", players: ["nayeon"]},
      %Monopoly.Space{name: "Vermont Ave", players: []},
      %Monopoly.Space{name: "Connecticut Ave", players: []}]
  end

  test "assign to space 3" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)
           |> Monopoly.assign_to_space("nayeon", 2)
    assert game.board == [%Monopoly.Space{name: "Go", players: [], type: :go},
      %Monopoly.Space{name: "Mediterranean Ave", players: ["nayeon"]},
      %Monopoly.Space{name: "Baltic Ave", players: ["nayeon"]},
      %Monopoly.Space{name: "Vermont Ave", players: []},
      %Monopoly.Space{name: "Connecticut Ave", players: []}]
  end

  test "remove from space 1" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)
           |> Monopoly.remove_from_space("nayeon", 1)
           |> Monopoly.assign_to_space("nayeon", 2)

    assert game.board == [%Monopoly.Space{name: "Go", players: [], type: :go},
      %Monopoly.Space{name: "Mediterranean Ave", players: []},
      %Monopoly.Space{name: "Baltic Ave", players: ["nayeon"]},
      %Monopoly.Space{name: "Vermont Ave", players: []},
      %Monopoly.Space{name: "Connecticut Ave", players: []}]
  end

  test "move player from to" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)
           |> Monopoly.move_player("nayeon", from: 1, to: 2)

    assert game.board == [%Monopoly.Space{name: "Go", players: [], type: :go},
      %Monopoly.Space{name: "Mediterranean Ave", players: []},
      %Monopoly.Space{name: "Baltic Ave", players: ["nayeon"]},
      %Monopoly.Space{name: "Vermont Ave", players: []},
      %Monopoly.Space{name: "Connecticut Ave", players: []}]
  end

  test "move player to" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)
           |> Monopoly.move_player("nayeon", to: 2)

    assert game.board == [%Monopoly.Space{name: "Go", players: [], type: :go},
      %Monopoly.Space{name: "Mediterranean Ave", players: []},
      %Monopoly.Space{name: "Baltic Ave", players: ["nayeon"]},
      %Monopoly.Space{name: "Vermont Ave", players: []},
      %Monopoly.Space{name: "Connecticut Ave", players: []}]
  end

  test "move player spaces" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)
           |> Monopoly.move_player("nayeon", spaces: 1)

    assert game.board == [%Monopoly.Space{name: "Go", players: [], type: :go},
      %Monopoly.Space{name: "Mediterranean Ave", players: []},
      %Monopoly.Space{name: "Baltic Ave", players: ["nayeon"]},
      %Monopoly.Space{name: "Vermont Ave", players: []},
      %Monopoly.Space{name: "Connecticut Ave", players: []}]
  end

  test "move player spaces 2" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)
           |> Monopoly.move_player("nayeon", spaces: 3)

    assert game.board == [%Monopoly.Space{name: "Go", players: [], type: :go},
      %Monopoly.Space{name: "Mediterranean Ave", players: []},
      %Monopoly.Space{name: "Baltic Ave", players: []},
      %Monopoly.Space{name: "Vermont Ave", players: []},
      %Monopoly.Space{name: "Connecticut Ave", players: ["nayeon"]}]
  end

  test "move player spaces wrap around" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)
           |> Monopoly.move_player("nayeon", spaces: 4)

    assert game.board == [%Monopoly.Space{name: "Go", players: ["nayeon"], type: :go},
      %Monopoly.Space{name: "Mediterranean Ave", players: []},
      %Monopoly.Space{name: "Baltic Ave", players: []},
      %Monopoly.Space{name: "Vermont Ave", players: []},
      %Monopoly.Space{name: "Connecticut Ave", players: []}]
  end

  test "player_index" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)
    assert Monopoly.player_index(game.board, "nayeon") == 1

    game = Monopoly.move_player(game, "nayeon", to: 3)
    assert Monopoly.player_index(game.board, "nayeon") == 3
  end

  test "perform_move" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)
           |> Monopoly.perform_move("nayeon", spaces: 4)

    assert game.board == [%Monopoly.Space{name: "Go", players: ["nayeon"], type: :go},
      %Monopoly.Space{name: "Mediterranean Ave", players: []},
      %Monopoly.Space{name: "Baltic Ave", players: []},
      %Monopoly.Space{name: "Vermont Ave", players: []},
      %Monopoly.Space{name: "Connecticut Ave", players: []}]

    assert game.history == ["nayeon lands on Go", "nayeon passes Go", "nayeon moves 4 spaces"]
  end

  test "find_player" do
    game = Monopoly.assign_to_space(%Game{}, "nayeon", 1)
    assert Monopoly.find_player(game, "nayeon") == %Monopoly.Space{name: "Mediterranean Ave", players: ["nayeon"]}
  end
end
