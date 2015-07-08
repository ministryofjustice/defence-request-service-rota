class RemoveSolicitorNameAndRequestCountColumnsFromRotaSlot < ActiveRecord::Migration
  def change
    remove_column :rota_slots, :request_count, :integer, null: false, default: 0
    remove_column :rota_slots, :solicitor_name, :string
  end
end
