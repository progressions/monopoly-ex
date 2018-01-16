defmodule Monopoly.Player do
  alias Monopoly.{Game, Space}

  defstruct [
    :name,
    index: 0,
    money: 1500
  ]

  def find(game, name) do
    {{_name, player}, _} = List.keytake(game.players, name, 0)

    player
  end

  def perform_move(game, player, spaces: spaces) do
    game
    |> Game.log("#{player} moves #{spaces} spaces")
    |> move_player(player, spaces: spaces)
  end

  def move_player(game, name, spaces: 0) do
    player = find(game, name)
    space = elem(game.spaces, player.index)

    Space.land_on(game, player.name, space)
  end

  def move_player(game, name, spaces: spaces) do
    player = find(game, name)
    to = Monopoly.destination_index(game.spaces, player.index, 1)

    move_player(game, name, to: to)
    |> Space.traverse(name, player.index, to)
    |> move_player(name, spaces: spaces - 1)
  end

  def move_player(game, name, to: index) do
    player = find(game, name)
    players = List.keyreplace(game.players, name, 0, {name, %{player | index: index}})

    %{game | players: players}
  end

  def add_money(game, name, amount) do
    {{name, player}, _players} = List.keytake(game.players, name, 0)

    players =
      List.keyreplace(game.players, name, 0, {name, %{player | money: player.money + amount}})

    %{game | players: players}
  end

  def pay_money(game, name, amount), do: add_money(game, name, 0 - amount)
end
