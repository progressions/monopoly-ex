defmodule MonopolyTest do
  use ExUnit.Case
  doctest Monopoly

  setup do
    game = Monopoly.init(players: ["nayeon", "tzuyu", "momo"])

    {:ok, game: game}
  end

  test "plays a game", state do
    game = state.game

    assert game.history == ["Game begins with nayeon, tzuyu, momo!"]

    assert Enum.map(game.players, fn {_name, player} -> player.name end) == [
             "nayeon",
             "tzuyu",
             "momo"
           ]
  end

  test "assign to space 1", state do
    game = Monopoly.Player.move_player(state.game, "nayeon", to: 1)

    {{"nayeon", player}, _} = List.keytake(game.players, "nayeon", 0)

    assert player.index == 1
  end

  test "assign to space 2", state do
    game = Monopoly.Player.move_player(state.game, "nayeon", to: 2)

    {{"nayeon", player}, _} = List.keytake(game.players, "nayeon", 0)

    assert player.index == 2
  end

  test "assign to space 3", state do
    game = Monopoly.Player.move_player(state.game, "nayeon", to: 3)

    {{"nayeon", player}, _} = List.keytake(game.players, "nayeon", 0)

    assert player.index == 3
  end

  test "move player spaces", state do
    game =
      Monopoly.Player.move_player(state.game, "nayeon", to: 1)
      |> Monopoly.Player.move_player("nayeon", spaces: 1)

    {{"nayeon", player}, _} = List.keytake(game.players, "nayeon", 0)

    assert player.index == 2

    assert game.history == [
             "nayeon lands on Community Chest",
             "Game begins with nayeon, tzuyu, momo!"
           ]
  end

  test "move player spaces 2", state do
    game =
      Monopoly.Player.move_player(state.game, "nayeon", to: 1)
      |> Monopoly.Player.move_player("nayeon", spaces: 4)

    {{"nayeon", player}, _} = List.keytake(game.players, "nayeon", 0)

    assert player.index == 5

    assert game.history == [
             "nayeon lands on Reading Railroad",
             "Game begins with nayeon, tzuyu, momo!"
           ]
  end

  test "move player spaces wrap around", state do
    game =
      state.game
      |> Monopoly.Player.move_player("nayeon", to: 35)
      |> Monopoly.Player.move_player("nayeon", spaces: 7)

    {{"nayeon", player}, _} = List.keytake(game.players, "nayeon", 0)

    assert player.index == 2

    assert game.history == [
             "nayeon lands on Community Chest",
             "nayeon passes Go, collects $200",
             "Game begins with nayeon, tzuyu, momo!"
           ]
  end

  test "move player spaces wrap around twice if necessary", state do
    game =
      state.game
      |> Monopoly.Player.move_player("nayeon", to: 35)
      |> Monopoly.Player.move_player("nayeon", spaces: 47)

    {{"nayeon", player}, _} = List.keytake(game.players, "nayeon", 0)

    assert player.index == 2

    assert game.history == [
             "nayeon lands on Community Chest",
             "nayeon passes Go, collects $200",
             "nayeon passes Go, collects $200",
             "Game begins with nayeon, tzuyu, momo!"
           ]
  end

  test "Player.perform_move", state do
    game =
      state.game
      |> Monopoly.Player.perform_move("nayeon", spaces: 8)

    {{"nayeon", player}, _} = List.keytake(game.players, "nayeon", 0)

    assert player.index == 8

    assert game.history == [
             "nayeon lands on Vermont Avenue",
             "nayeon moves 8 spaces",
             "Game begins with nayeon, tzuyu, momo!"
           ]
  end

  test "passes Go", state do
    game =
      state.game
      |> Monopoly.Player.move_player("nayeon", to: 35)
      |> Monopoly.Player.move_player("nayeon", spaces: 7)

    player = Monopoly.Player.find(game, "nayeon")

    assert player.index == 2
    assert player.money == 1700

    assert game.history == [
             "nayeon lands on Community Chest",
             "nayeon passes Go, collects $200",
             "Game begins with nayeon, tzuyu, momo!"
           ]
  end

  test "lands on Income Tax", state do
    game =
      state.game
      |> Monopoly.Player.perform_move("nayeon", spaces: 4)

    player = Monopoly.Player.find(game, "nayeon")

    assert player.money == 1300

    assert game.history == [
             "nayeon lands on Income Tax (pay $200)",
             "nayeon moves 4 spaces",
             "Game begins with nayeon, tzuyu, momo!"
           ]
  end

  test "add_money", state do
    player =
      Monopoly.Player.add_money(state.game, "nayeon", 200)
      |> Monopoly.Player.find("nayeon")

    assert player.money == 1700
  end

  test "pay_money", state do
    player =
      Monopoly.Player.pay_money(state.game, "nayeon", 200)
      |> Monopoly.Player.find("nayeon")

    assert player.money == 1300
  end

  test "advance_next_player", state do
  end
end
