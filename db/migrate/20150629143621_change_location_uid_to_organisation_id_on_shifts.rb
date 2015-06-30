class ChangeLocationUidToOrganisationIdOnShifts < ActiveRecord::Migration
  def change
    remove_column :shifts, :location_uid, :uuid
    add_column :shifts, :organisation_id, :integer
  end
end
