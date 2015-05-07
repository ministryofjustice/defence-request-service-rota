class ProcurementArea < ActiveRecord::Base
  validates :name, presence: true

  def self.ordered_by_name
    order(name: :asc)
  end

  def destroy_membership!(member_uid)
    memberships.reject! do |member|
      member["uid"] == member_uid
    end

    save!
  end
end
