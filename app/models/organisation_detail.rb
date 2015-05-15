class OrganisationDetail < ActiveRecord::Base
  belongs_to :organisation

  store_accessor :data, :supplier_number
end
