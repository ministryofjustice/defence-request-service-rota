class AddSolicitorNameToRotaSlots < ActiveRecord::Migration
  def change
    add_column :rota_slots, :solicitor_name, :string
  end
end
