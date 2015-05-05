class AddMembershipsToProcurementAreas < ActiveRecord::Migration
  def change
    add_column :procurement_areas, :memberships, :jsonb, default: "[]"
    add_index :procurement_areas, :memberships, using: :gin
  end
end
