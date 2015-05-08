class AddDayRequirementsToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :allocation_requirements_per_weekday, :jsonb, default: "{}"
    add_index :shifts, :allocation_requirements_per_weekday, using: :gin
  end
end
