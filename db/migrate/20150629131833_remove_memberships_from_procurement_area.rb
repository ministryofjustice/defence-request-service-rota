class RemoveMembershipsFromProcurementArea < ActiveRecord::Migration
  def change
    remove_column :procurement_areas, :memberships, :jsonb, default: []
  end
end
