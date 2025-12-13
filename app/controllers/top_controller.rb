class TopController < ApplicationController
  def index
    @lists = List.where(user: current_user).order(:position)
  end
end
