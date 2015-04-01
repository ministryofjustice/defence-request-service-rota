class User
  attr_reader :uid, :email, :name

  def self.build_from(auth_hash)
    new(
      uid: auth_hash.fetch(:uid),
      email: auth_hash.fetch(:info).fetch(:email),
      name: auth_hash.fetch(:info).fetch(:profile).fetch(:name),
    )
  end

  def initialize(uid:, email:, name:)
    @uid = uid
    @email = email
    @name = name
  end
end
