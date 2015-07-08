class AddUniqueIndexOnRotaSlot < ActiveRecord::Migration
  def change
    add_index :rota_slots, [:shift_id, :starting_time], unique: true
  end
end
