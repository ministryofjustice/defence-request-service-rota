FactoryGirl.define do  factory :procurement_area do
    name "MyString"
  end

  factory :admin_user, class: Omniauth::Dsds::User do
    to_create { |instance| instance }

    initialize_with {
      new(
        uid: SecureRandom.uuid,
        name: "Example User",
        email: "user@example.com",
        roles: ["admin"],
        organisation_uids: []
      )
    }
  end
end
