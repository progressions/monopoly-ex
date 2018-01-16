defmodule Monopoly.Game do
  alias Monopoly.{Game, Space}

  defstruct spaces: {
              %Space{name: "Go (collect $200)", type: :go},
              %Space{name: "Mediterranean Avenue"},
              %Space{name: "Community Chest", type: :community_chest},
              %Space{name: "Baltic Avenue"},
              %Space{name: "Income Tax (pay $200)", type: :income_tax},
              %Space{name: "Reading Railroad"},
              %Space{name: "Oriental Avenue"},
              %Space{name: "Chance", type: :chance},
              %Space{name: "Vermont Avenue"},
              %Space{name: "Connecticut Avenue"},
              %Space{name: "In Jail/Just Visiting", type: :jail},
              %Space{name: "St. Charles Place"},
              %Space{name: "Electric Company"},
              %Space{name: "States Avenue"},
              %Space{name: "Virginia Avenue"},
              %Space{name: "Pennsylvania Railroad"},
              %Space{name: "St. James Place"},
              %Space{name: "Community Chest", type: :community_chest},
              %Space{name: "Tennessee Avenue"},
              %Space{name: "New York Avenue"},
              %Space{name: "Free Parking", type: :free_parking},
              %Space{name: "Kentucky Avenue"},
              %Space{name: "Chance", type: :chance},
              %Space{name: "Indiana Avenue"},
              %Space{name: "Illinois Avenue"},
              %Space{name: "B&O Railroad"},
              %Space{name: "Atlantic Avenue"},
              %Space{name: "Ventnor Avenue"},
              %Space{name: "Water Works"},
              %Space{name: "Marvin Gardens"},
              %Space{name: "Go to Jail", type: :go_to_jail},
              %Space{name: "Pacific Avenue"},
              %Space{name: "North Carolina Avenue"},
              %Space{name: "Community Chest", type: :community_chest},
              %Space{name: "Pennsylvania Avenue"},
              %Space{name: "Short Line"},
              %Space{name: "Chance", type: :chance},
              %Space{name: "Park Place"},
              %Space{name: "Luxury Tax (pay $100)", type: :luxury_tax},
              %Space{name: "Boardwalk"}
            },
            history: [],
            players: []

  def log(game, message) do
    %{game | history: [message | game.history]}
  end

  def advance_next_player(%Game{players: [first | tail]} = game) do
    %{game | players: List.flatten(tail, [first])}
  end

  def next_player(%Game{players: [first | _]}), do: first
end
