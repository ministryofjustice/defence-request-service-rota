class ChangeStartAndEndTimeFieldsOnShiftToDatetime < ActiveRecord::Migration
  def up
    remove_column :shifts, :starting_time, :time
    remove_column :shifts, :ending_time, :time
    add_column :shifts, :starting_time, :datetime
    add_column :shifts, :ending_time, :datetime
  end

  def down
    remove_column :shifts, :starting_tame, :datetime
    remove_column :shifts, :ending_time, :datetime
    add_column :shifts, :starting_time, :time
    add_column :shifts, :ending_time, :time
  end
end
