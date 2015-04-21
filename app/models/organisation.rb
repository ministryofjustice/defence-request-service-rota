class Organisation < APIModel
  def self.all
    data_api.organisations.map { |attrs| build_from(attrs) }
  end

  def self.build_from(attrs)
    new(attrs)
  end

  attr_reader :uid, :name, :type, :profiles_link

  def initialize(attrs)
    @uid = attrs.fetch("uid")
    @name = attrs.fetch("name")
    @type = attrs.fetch("type")
    @profiles_link = attrs.fetch("links").fetch("profiles")
  end

  def to_partial_path
    "organisations/organisation"
  end
end
