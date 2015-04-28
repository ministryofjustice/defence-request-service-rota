class CreateProcurementAreas < ActiveRecord::Migration
  def change
    create_table :procurement_areas do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
