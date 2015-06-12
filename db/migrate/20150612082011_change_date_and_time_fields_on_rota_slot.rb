class ChangeDateAndTimeFieldsOnRotaSlot < ActiveRecord::Migration
  def up
    remove_column :rota_slots, :date
    add_column :rota_slots, :starting_time, :datetime
    add_column :rota_slots, :ending_time, :datetime
  end

  def down
    remove_column :rota_slots, :starting_time
    remove_column :rota_slots, :ending_time
    add_column :rota_slots, :date, :date
  end
end
