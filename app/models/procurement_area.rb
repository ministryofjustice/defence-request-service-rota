class ProcurementArea < ActiveRecord::Base
  MEMBER_TYPES = %w(law_firm law_office).freeze
  LOCATION_TYPES = %w(court custody_suite).freeze

  validates :name, presence: true

  has_many :rota_slots, dependent: :destroy

  def self.ordered_by_name
    order(name: :asc)
  end

  def membership_uids
    memberships.map { |membership| membership["uid"] }
  end

  def members
    memberships.find_all do |membership|
      MEMBER_TYPES.any? { |member_type| member_type == membership["type"] }
    end
  end

  def locations
    memberships.find_all do |membership|
      LOCATION_TYPES.any? { |member_type| member_type == membership["type"] }
    end
  end

  def destroy_membership!(member_uid)
    memberships.reject! { |member| member["uid"] == member_uid }
    save!
  end
end
