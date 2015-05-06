class AddLocationsToProcurementAreas < ActiveRecord::Migration
  def change
    add_column :procurement_areas, :locations, :jsonb, default: "[]"
    add_index :procurement_areas, :locations, using: :gin
  end
end
