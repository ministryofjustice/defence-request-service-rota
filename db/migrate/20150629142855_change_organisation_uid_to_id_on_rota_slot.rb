class ChangeOrganisationUidToIdOnRotaSlot < ActiveRecord::Migration
  def change
    remove_column :rota_slots, :organisation_uid, :uuid
    add_column :rota_slots, :organisation_id, :integer
  end
end
