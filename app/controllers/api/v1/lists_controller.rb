class Api::V1::ListsController < ApplicationController
  before_action :authenticate_user!

  def index
    lists = current_user.lists.order(:position)
    render json: {
      lists: lists.as_json(only: %i[id title position])
    }
  end

  def reorder
    list_ids = params.require(:list_ids)
    allowed_ids = current_user.lists.where(id: list_ids).ids
    ordered_ids = list_ids.map(&:to_i).select { |id| allowed_ids.include?(id) }

    if ordered_ids.length != list_ids.length
      return render json: { error: { message: "invalid list_ids" } }, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      ordered_ids.each_with_index do |id, pos|
        current_user.lists.where(id: id).update_all(position: pos + 1)
      end
    end
    render json: { ok: true }, status: :ok
  end
end
