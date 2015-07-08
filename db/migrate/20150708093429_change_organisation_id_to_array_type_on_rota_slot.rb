class ChangeOrganisationIdToArrayTypeOnRotaSlot < ActiveRecord::Migration
  def change
    add_column :rota_slots, :organisation_ids, :integer, array: true, null: false, default: []
    remove_column :rota_slots, :organisation_id, :integer
  end
end
