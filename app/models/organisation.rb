class Organisation
  attr_reader :id, :name, :type, :profile_ids

  def self.build_from(attrs)
    new(attrs)
  end

  def initialize(attrs)
    @id = attrs.fetch(:id)
    @name = attrs.fetch(:name)
    @type = attrs.fetch(:type)
    @profile_ids = attrs.fetch(:profile_ids)
  end

  def to_partial_path
    "organisations/organisation"
  end
end
