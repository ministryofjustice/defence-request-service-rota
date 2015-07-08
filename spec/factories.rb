FactoryGirl.define do
  factory :admin_user, class: User do
    name         { Faker::Name.name }
    email        { Faker::Internet.free_email }
    password     "password"
  end

  factory :procurement_area do
    name "Outlands"
  end

  factory :organisation do
    name              { Faker::Company.name }
    organisation_type "law_firm"
  end

  factory :rota_generation_log_entry do
    procurement_area
    association :user, factory: :admin_user
    total_slots       100
    start_time        { Time.now }
    end_time          { Time.now + 10.seconds }
    status            RotaGenerationLogEntry::SUCCESSFUL

    trait :failed do
      status    RotaGenerationLogEntry::FAILED
    end

    trait :running do
      status    RotaGenerationLogEntry::RUNNING
    end
  end

  factory :rota_slot do
    starting_time { Time.now }
    shift
    organisation
    procurement_area
  end

  factory :shift do
    organisation
    starting_time { Time.parse("2014-01-01 00:00") }
    allocation_requirements_per_weekday {
      Shift::WEEKDAYS.inject({}) do |result, key|
        result[key] = 0
        result
      end
    }
  end
end
