class Card < ApplicationRecord
  belongs_to :hand

  RANKS = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace].freeze
  SUITS = %w[hearts diamonds clubs spades].freeze

  SUIT_SYMBOLS = {
  spades: "♠",
  hearts: "♥",
  diamonds: "♦",
  clubs: "♣"
}.freeze

  VALUES = {
  "2"     => 2,
  "3"     => 3,
  "4"     => 4,
  "5"     => 5,
  "6"     => 6,
  "7"     => 7,
  "8"     => 8,
  "9"     => 9,
  "10"    => 10,
  "Jack"  => 10,
  "Queen" => 10,
  "King"  => 10,
  "Ace"   => 11
}.freeze

  # Automatically determines color based on the suit
  def color
    %w[hearts diamonds].include?(suit) ? "red" : "black"
  end

  def suit_symbol
    SUIT_SYMBOLS[suit.to_sym]
  end

  def self.generate_deck
    SUITS.flat_map do |suit_name|
      RANKS.map do |rank_name|
        card_value = VALUES[rank_name]

        new(rank: rank_name, suit: suit_name, value: card_value)
      end
    end
  end

  def to_s
    "#{rank} of #{suit}"
  end
end
