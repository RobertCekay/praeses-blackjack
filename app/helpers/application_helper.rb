module ApplicationHelper
  def card_color_class(card)
    case card&.color.to_s.downcase
    when "red"
      "text-danger"
    when "black"
      "text-dark"
    else
      "text-muted"
    end
  end
end
