class Game < ApplicationRecord
  has_one :player_hand, -> { where(role: "player") }, class_name: "Hand"
  has_one :dealer_hand, -> { where(role: "dealer") }, class_name: "Hand"
  # has_many :cards, through: :hand

  after_initialize :setup_game, if: :new_record?

  def setup_game
    self.player_hand = Hand.new(role: "player")

    self.player_hand.cards << deck.shift
    self.player_hand.cards << deck.shift

    self.dealer_hand = Hand.new(role: "dealer")
    self.dealer_hand.cards << deck.shift

    facedown_card = deck.shift
    facedown_card.facedown = true
    self.dealer_hand.cards << facedown_card

    save!

    check_for_player_win_or_tie
  end

  def deck
    @deck ||= Card.generate_deck.shuffle
  end

  def player_hit
    self.player_hand.cards << deck.shift
    check_player_bust
    check_for_player_win_or_tie

    save
  end

  def player_stay
    flip_dealer_cards
    dealer_hits_until_17
    check_for_end_of_game_winner

    save
  end

  def flip_dealer_cards
    dealer_hand.cards.where(facedown: true).update(facedown: false)
  end

  def check_player_bust
    if player_hand.calculated_score > 21
      self.winner = "dealer"
    end
  end

  def check_for_player_win_or_tie
    if player_hand.calculated_score == 21
      if dealer_hand.calculated_score == 21
        # If so the game is tied
        self.winner = "tie"
      else
        # If not, the player wins
        self.winner = "player"
      end
    end
  end

  def dealer_hits_until_17
    while dealer_hand.calculated_score < 17
      self.dealer_hand.cards << deck.pop
    end
  end

  def check_for_end_of_game_winner
    player_sum = player_hand.calculated_score
    dealer_sum = dealer_hand.calculated_score

    if dealer_sum > 21
      self.winner = "player"
    elsif player_sum == dealer_sum
      self.winner = "tie"
    elsif player_sum > dealer_sum
      self.winner = "player"
    elsif player_sum < dealer_sum
      self.winner = "dealer"
    end
  end
end
