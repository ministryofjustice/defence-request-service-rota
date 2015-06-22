class AddRequestCountToRotaSlot < ActiveRecord::Migration
  def change
    add_column :rota_slots, :request_count, :integer, null: false, default: 0
  end
end
