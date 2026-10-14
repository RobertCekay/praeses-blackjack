class Game < ApplicationRecord
  has_one :player_hand, -> { where(role: "player") }, class_name: "Hand"
  has_one :dealer_hand, -> { where(role: "dealer") }, class_name: "Hand"
  # has_many :cards, through: :hand

  after_initialize :setup_game, if: :new_record?

  def setup_game
    self.player_hand = Hand.new(role: "player")
    self.player_hand.cards << deck.sample
    self.player_hand.cards << deck.sample

    self.dealer_hand = Hand.new(role: "dealer")
    self.dealer_hand.cards << deck.sample

    facedown_card = deck.sample
    facedown_card.facedown = true
    self.dealer_hand.cards << facedown_card

    save!
  end

  def deck
    @deck ||= Card.generate_deck
  end

  def dealer_score
    dealer_hand.cards.where(facedown: false).sum(&:value)
  end

  def player_hit
    self.player_hand.cards << deck.sample
    check_player_bust
    check_for_player_win_or_tie
  end

  def player_stay
    flip_dealer_cards
    check_for_winner

    # Dealer hits until they have at least 17
  end

  def flip_dealer_cards
    dealer_hand.cards.where(facedown: true).update(facedown: false)
  end

  def check_player_bust
    if player_hand.cards.sum(&:value) > 21
      self.winner = "dealer"
      save
    end
  end

  def check_for_player_win_or_tie
    # Check if the player has 21
    if player_hand.cards.sum(&:value) == 21
      # If so, check if the dealer has 21
      if dealer_hand.cards.sum(&:value) == 21
        # If so the game is tied
        self.winner = "tie"
      else
        # If not, the player wins
        self.winner = "player"
      end
      save
    end
  end

  def check_for_winner
    player_sum = player_hand.cards.sum(&:value)
    dealer_sum = dealer_hand.cards.sum(&:value)

    if player_sum > 21
      self.winner = "dealer"
    elsif dealer_sum > 21
      self.winner = "player"
    elsif player_sum == dealer_sum
      self.winner = "tie"
    elsif player_sum > dealer_sum
      self.winner = "player"
    else
      self.winner = "dealer"
    end
    save
  end
end
