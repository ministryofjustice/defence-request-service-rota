class CreateOrganisations < ActiveRecord::Migration
  def change
    create_table :organisations do |t|
      t.string  :name,              null: false
      t.string  :organisation_type, null: false
      t.string  :tel
      t.text    :address
      t.string  :postcode
      t.string  :email
      t.string  :mobile
      t.integer :procurement_area_id
    end
  end
end
