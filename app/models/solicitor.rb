class Solicitor < APIModel
  def self.all
    data_api.solicitors.map { |attrs| build_from(attrs) }
  end

  def self.build_from(attrs)
    new(attrs)
  end

  attr_reader :id, :name, :type

  def initialize(attrs)
    @id = attrs.fetch(:id)
    @name = attrs.fetch(:name)
    @type = attrs.fetch(:type)
  end

  def to_partial_path
    "solicitors/solicitor"
  end
end
