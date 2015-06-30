class Organisation < ActiveRecord::Base
  ORGANISATION_TYPES = %w{
    court
    custody_suite
    law_firm
    law_office
  }

  MEMBER_TYPES = %w(law_firm law_office).freeze
  LOCATION_TYPES = %w(court custody_suite).freeze

  validates :name, :organisation_type, presence: true
  validates :organisation_type, inclusion: { in: ORGANISATION_TYPES }

  belongs_to :procurement_area
  has_many :shifts

  scope :by_name, -> { order(name: :asc) }
  scope :members, -> { where(organisation_type: MEMBER_TYPES) }
  scope :locations, -> { where(organisation_type: LOCATION_TYPES) }
end
