module UtilityMethods
  def update_with_sort(params)
    # get original params
    @position_was = position
    @list_id_was = list_id if instance_of?(Card)
    result = update(params)
    # get updated params
    @position = position
    @target_id = id
    @list_id = list_id if instance_of?(Card)
    change_order if result
    result
  end

  def destroy_with_sort
    @position_was = position
    @position = self.class.where(reset_target).maximum(:position) + 1
    @target_id = id
    if instance_of?(Card)
      @list_id_was = list_id
      @list_id = list_id
    end
    destroy
    result = destroyed?
    change_order if result
    result
  end

  private

  def change_order
    position_from = @position_was
    position_to = @position
    # Change order of List or Card, if position was changed in the same group.
    if instance_of?(List) or @list_id_was == @list_id
      if position_to != position_from
        if position_to > position_from
          # Remove, move to the other list or move to the end
          position_max = self.class.where(reset_target).maximum(:position)
          if position_max && position_to >= position_max
            self.class.where("id <> ? and position > ?#{extra_condition}", @target_id, position_from).each do |pos|
              pos.decrement!(:position)
            end
          # Move backward
          else
            self.class.where("id <> ? and position > ? and position <= ?#{extra_condition}", @target_id, position_from,
                             position_to).each do |pos|
              pos.decrement!(:position)
            end
          end
        elsif position_to < position_from
          # Move to the top
          if position_to == self.class.where(reset_target).minimum(:position)
            self.class.where("id <> ? and position < ?#{extra_condition}", @target_id, position_from).each do |pos|
              pos.increment!(:position)
            end
          # Move forward
          else
            self.class.where("id <> ? and position >= ? and position < ?#{extra_condition}", @target_id, position_to,
                             position_from).each do |pos|
              pos.increment!(:position)
            end
          end
        end
      end

    elsif instance_of?(Card) && @list_id_was != @list_id
      # Reset original list's order if move to the other list
      self.class.where("position > ?#{extra_condition}", position_from).each { |pos| pos.decrement!(:position) }
      position_max = self.class.where(reset_target).count
      if position > position_max
        self.position = position_max
        save
      else
        # Reset the list's order in a destination
        self.class.where("id <> ? and position > ?#{extra_condition_new_destination}", @target_id,
                         position_to.to_i - 1).each do |pos|
          pos.increment!(:position)
        end
      end
    end
  end

  def reset_target
    if instance_of?(Card)
      "list_id = #{list_id}"
    else
      "user_id = #{user_id}"
    end
  end

  def extra_condition
    " and list_id = #{@list_id_was}" if instance_of?(Card)
  end

  def extra_condition_new_destination
    " and list_id = #{@list_id}" if instance_of?(Card)
  end
end
