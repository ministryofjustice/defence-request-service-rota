class CreateOrganisationDetails < ActiveRecord::Migration
  def change
    create_table :organisation_details do |t|
      t.string :organisation_uid
      t.jsonb :data, default: "{}"

      t.timestamps null: false
    end
    add_index :organisation_details, :organisation_uid, unique: true
    add_index :organisation_details, :data, using: :gin
  end
end
