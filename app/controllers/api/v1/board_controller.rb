class Api::V1::BoardController < ApplicationController
  before_action :authenticate_user!

  def show
    lists = current_user.lists
                        .includes(:cards)
                        .order(:position)

    render json: {
      lists: lists.map do |list|
        {
          id: list.id,
          title: list.title,
          position: list.position,
          cards: list.cards.sort_by(&:position).map do |card|
            {
              id: card.id,
              title: card.title,
              memo: card.memo,
              position: card.position
            }
          end
        }
      end
    }
  end
end
