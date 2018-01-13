defmodule Monopoly do
  @moduledoc """
  Documentation for Monopoly.
  """

  defmodule Space do
    defstruct [
      :name,
      :type,
      players: [],
    ]
  end

  defmodule Game do
    defstruct [
      players: [],
      board: [
        %Space{name: "Go", type: :go},
        %Space{name: "Mediterranean Ave"},
        %Space{name: "Baltic Ave"},
        %Space{name: "Vermont Ave"},
        %Space{name: "Connecticut Ave"},
      ],
      history: [],
    ]
  end

  defmodule Player do
    defstruct [
      :name,
      money: 1500,
    ]
  end

  @doc """
  Initialize a new game with a set of players.

  ## Examples

      iex> Monopoly.init(players: ["Isaac", "Darla"])
      %Monopoly.Game{board: [%Monopoly.Space{name: "Go",
        players: ["Darla", "Isaac"], type: :go},
         %Monopoly.Space{name: "Mediterranean Ave", players: []},
         %Monopoly.Space{name: "Baltic Ave", players: []},
         %Monopoly.Space{name: "Vermont Ave", players: []},
         %Monopoly.Space{name: "Connecticut Ave", players: []}],
        history: ["Game begins with Isaac, Darla!"],
        players: [%Monopoly.Player{name: "Isaac"},
         %Monopoly.Player{name: "Darla"}]}

  """
  @spec init(players: list) :: struct
  def init(players: player_names) do
    players = Enum.map(player_names, &(%Player{name: &1}))
    game = %Game{players: players}
    Enum.reduce(players, game, fn (player, game) ->
      assign_to_space(game, player.name, 0)
    end)
    |> log("Game begins with #{Enum.join(player_names, ", ")}!")
  end

  def log(game, message) do
    %Game{game | history: [message|game.history]}
  end

  def new do
    init(players: ["nayeon", "tzuyu", "momo"])
  end

  def advance_next_player(%Game{players: [first|tail]} = game) do
    %{game | players: List.flatten(tail, [first])}
  end

  def next_player(%Game{players: [first|_]}), do: first

  defp roll_dice do
    :rand.uniform(6) + :rand.uniform(6)
  end

  def perform_move(game, player, spaces: spaces) do
    game
    |> log("#{player} moves #{spaces} spaces")
    |> move_player(player, spaces: spaces)
  end

  def move_player(game, player, spaces: 0) do
    space = find_player_on_board(game, player)

    game
    |> log("#{player} lands on #{space.name}")
  end
  def move_player(game, player, spaces: spaces) do
    from = player_index(game.board, player)
    to = destination_index(game.board, from, 1)

    move_player(game, player, from: from, to: to)
    |> traverse(player, to)
    |> move_player(player, spaces: spaces-1)
  end
  def move_player(game, player, to: to) do
    from = player_index(game.board, player)
    move_player(game, player, from: from, to: to)
  end
  def move_player(game, player, from: from, to: to) do
    game
    |> Monopoly.remove_from_space(player, from)
    |> Monopoly.assign_to_space(player, to)
  end

  def traverse(game, name, to) when is_integer(to) do
    space = space_at(game, to)
    traverse(game, name, space)
  end
  def traverse(game, name, %Space{type: :go}) do
    game
    |> add_money(name, 200)
    |> log("#{name} passes Go, collects $200")
  end
  def traverse(game, _player, _), do: game

  def add_money(game, name, amount) do
    {index, _player} = find_player(game.players, name)
    players = List.update_at(game.players, index, fn (p) -> %{p | money: p.money+amount} end)

    %{game | players: players}
  end

  def space_at(game, index) do
    Enum.at(game.board, index)
  end

  @doc """
  Finds the player's destination after moving a given number of spaces along the board.

  Wraps around the board if necessary.

  ## Examples

      iex> Monopoly.destination_index([0,1,2,3,4,5], 1, 1)
      2

      iex> Monopoly.destination_index([0,1,2,3,4,5], 1, 4)
      5

      iex> Monopoly.destination_index([0,1,2,3,4,5], 1, 5)
      0

  """
  def destination_index(board, index, spaces) do
    len = length(board)
    result = (index+spaces)
    if result > len-1 do
      result - len
    else
      result
    end
  end

  def find_player_on_board(game, player) do
    index = player_index(game.board, player)
    space_at(game, index)
  end

  def find_player(players, name), do: find_player(players, name, 0)
  def find_player([%Player{name: name} = player|_], name, acc), do: {acc, player}
  def find_player([_|tail], name), do: find_player(tail, name)
  def find_player([], name, _), do: raise "Player #{name} does not exist in []"
  def find_player(players, name, _) do
    names = players
            |> Enum.map(&(&1.name))
            |> Enum.join(", ")
    raise "Player #{name} does not exist in [#{names}]"
  end

  def player_index(board, player), do: player_index(board, player, 0)
  def player_index([space], player, index) do
    if player in space.players, do: index, else: nil
  end
  def player_index([space|tail], player, index) do
    if player in space.players, do: index, else: player_index(tail, player, index+1)
  end

  def assign_to_space(game, player, space) do
    board = List.update_at(game.board, space, fn (space) ->
      %{space | players: [player|space.players]}
    end)

    %{game | board: board}
  end

  def remove_from_space(game, player, space) do
    board = List.update_at(game.board, space, fn (space) ->
      %{space | players: List.delete(space.players, player)}
    end)
    %{game | board: board}
  end
end
