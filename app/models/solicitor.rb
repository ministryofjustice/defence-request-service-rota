class Solicitor < APIModel
  def self.all
    data_api.solicitors.map { |attrs| build_from(attrs) }
  end

  def self.build_from(attrs)
    new(attrs)
  end

  attr_reader :uid, :name, :type, :organisation_link

  def initialize(attrs)
    @uid = attrs.fetch("uid")
    @name = attrs.fetch("name")
    @type = attrs.fetch("type")
    @organisation_link = attrs.fetch("links").fetch("organisation")
  end

  def to_partial_path
    "solicitors/solicitor"
  end
end
