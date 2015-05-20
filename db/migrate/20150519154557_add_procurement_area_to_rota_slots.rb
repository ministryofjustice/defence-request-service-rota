class AddProcurementAreaToRotaSlots < ActiveRecord::Migration
  def change
    add_reference :rota_slots, :procurement_area, index: true, foreign_key: true
  end
end
