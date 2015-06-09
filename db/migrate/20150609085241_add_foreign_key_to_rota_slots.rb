class AddForeignKeyToRotaSlots < ActiveRecord::Migration
  def up
    remove_foreign_key :rota_slots, :procurement_areas
    add_foreign_key :rota_slots, :procurement_areas, on_delete: :cascade
  end

  def down
    remove_foreign_key :rota_slots, :procurement_areas
    add_foreign_key :rota_slots, :procurement_areas
  end
end
