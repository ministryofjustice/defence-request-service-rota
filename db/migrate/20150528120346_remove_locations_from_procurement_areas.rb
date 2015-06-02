class RemoveLocationsFromProcurementAreas < ActiveRecord::Migration
  def change
    remove_column :procurement_areas, :locations, :jsonb
  end
end
