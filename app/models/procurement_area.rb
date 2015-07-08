class ProcurementArea < ActiveRecord::Base

  validates :name, presence: true

  has_many :organisations
  has_many :rota_slots, dependent: :destroy
  has_many :rota_generation_log_entries

  def self.ordered_by_name
    order(name: :asc)
  end

  def members
    organisations.members
  end

  def locations
    organisations.locations
  end
end
