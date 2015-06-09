FactoryGirl.define do
  factory :admin_user, class: Omniauth::Dsds::User do
    roles ["admin"]

    to_create { |instance| instance }

    initialize_with {
      new(
        uid: SecureRandom.uuid,
        name: "Example User",
        email: "user@example.com",
        roles: roles,
        organisation_uids: []
      )
    }
  end

  factory :procurement_area do
    name "Outlands"

    trait :with_members do
      memberships { [] }
    end

    trait :with_locations do
      locations { [] }
    end
  end

  factory :rota_slot do
    date { Date.today }
    shift
    organisation_uid { SecureRandom.uuid }
    procurement_area
  end

  factory :shift do
    location_uid { SecureRandom.uuid }
    starting_time { Time.parse("09:00") }
    allocation_requirements_per_weekday {
      Shift::WEEKDAYS.inject({}) do |result, key|
        result[key] = 0
        result
      end
    }
  end
end
