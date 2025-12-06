class ListController < ApplicationController
  before_action :set_list, only: %i[edit update destroy]

  def new
    @list = List.new
  end

  def edit
    set_positions
  end

  def create
    @list = List.new(list_params)
    if @list.save
      redirect_to :root
    else
      render action: :new
    end
  end

  def update
    if @list.update_with_sort(list_params)
      redirect_to :root
    else
      set_positions
      render action: :edit
    end
  end

  def destroy
    @list.destroy_with_sort
    redirect_to :root
  end

  private

  def list_params
    if params[:list][:position].blank?
      position = List.where(user_id: current_user).maximum(:position)
      position = position.nil? ? 1 : position + 1
      params.require(:list).permit(:title).merge(user: current_user, position: position)
    else
      params.require(:list).permit(:title, :position).merge(user: current_user)
    end
  end

  def set_list
    @list = List.find_by(id: params[:id])
  end

  def set_positions
    @positions = List.where(user_id: current_user).select('position as `key`, position as value').order(:position)
  end
end
