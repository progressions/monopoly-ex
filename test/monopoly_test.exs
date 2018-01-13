defmodule MonopolyTest do
  use ExUnit.Case
  doctest Monopoly

  alias Monopoly.{Game, Space, Player}

  test "plays a game" do
    game = Monopoly.init(players: ["nayeon", "tzuyu", "momo"])
    assert game == %Game{board: [%Space{name: "Go",
      players: ["momo", "tzuyu", "nayeon"]},
      %Space{name: "Mediterranean Ave", players: []},
      %Space{name: "Baltic Ave", players: []},
      %Space{name: "Vermont Ave", players: []},
      %Space{name: "Connecticut Ave", players: []}],
      players: [%Player{name: "nayeon"},
      %Player{name: "tzuyu"}, %Player{name: "momo"}]}

    assert Monopoly.next_player(game) == %Player{name: "nayeon"}
    game = Monopoly.move_player(game, "nayeon", 3) |> Monopoly.advance_next_player

    assert Monopoly.next_player(game) == %Player{name: "tzuyu"}
    assert game == %Game{board: [%Space{name: "Go",
      players: ["momo", "tzuyu"]},
      %Space{name: "Mediterranean Ave", players: []},
      %Space{name: "Baltic Ave", players: []},
      %Space{name: "Vermont Ave", players: ["nayeon"]},
      %Space{name: "Connecticut Ave", players: []}],
      players: [%Player{name: "tzuyu"},
      %Player{name: "momo"}, %Player{name: "nayeon"}]}

    game = Monopoly.move_player(game, "tzuyu", 5) |> Monopoly.advance_next_player
    assert Monopoly.next_player(game) == %Player{name: "momo"}
    assert game == %Game{board: [%Space{name: "Go",
      players: ["tzuyu", "momo"]},
      %Space{name: "Mediterranean Ave", players: []},
      %Space{name: "Baltic Ave", players: []},
      %Space{name: "Vermont Ave", players: ["nayeon"]},
      %Space{name: "Connecticut Ave", players: []}],
      players: [%Player{name: "momo"},
      %Player{name: "nayeon"}, %Player{name: "tzuyu"}]}
  end
end
