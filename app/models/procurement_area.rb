class ProcurementArea < ActiveRecord::Base
  validates :name, presence: true

  def self.ordered_by_name
    order(name: :asc)
  end
end
