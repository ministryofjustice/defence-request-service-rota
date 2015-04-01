class Solicitor
  attr_reader :id, :name, :type

  def self.build_from(attrs)
    new(attrs)
  end

  def initialize(attrs)
    @id = attrs.fetch(:id)
    @name = attrs.fetch(:name)
    @type = attrs.fetch(:type)
  end

  def to_partial_path
    "solicitors/solicitor"
  end
end
