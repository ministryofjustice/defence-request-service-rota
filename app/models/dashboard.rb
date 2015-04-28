class Dashboard
  attr_reader :organisations, :solicitors

  def initialize(organisations, solicitors)
    @organisations = organisations
    @solicitors = solicitors
  end
end
