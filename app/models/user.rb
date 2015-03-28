class User
  attr_reader :id, :email, :name

  def initialize(args = {})
    args.slice(:id, :email, :name).each do |key, val|
      instance_variable_set "@#{key}", val
    end
  end 
end