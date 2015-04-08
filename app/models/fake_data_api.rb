class FakeDataApi
  def solicitors
    solicitors_endpoint[:profiles]
  end

  def organisations
    organisations_endpoint[:organisations]
  end

  private

  def solicitors_endpoint
    {
      "profiles": [
        {
          "id": 1,
          "name": "Bob Smith",
          "type": "solicitor"
        },
        {
          "id": 2,
          "name": "Andy Brown",
          "type": "agent"
        }
      ],
      "links": {
        "first": "/api/v1/profiles",
        "previous": "/api/v1/profiles?page=1",
        "next": "/api/v1/profiles?page=2",
        "last": "/api/v1/profiles?page=3"
      }
    }
  end

  def organisations_endpoint
    {
      "organisations": [
        {
          "id": 1,
          "name": "Tuckers",
          "type": "law_firm",
          "profile_ids": [1,2,3,5,6,7]
        },
        {
          "id": 2,
          "name": "Brighton",
          "type": "custody_suite",
          "profile_ids": [5,8,9]
        }
      ],
      "links": {
        "first": "/api/v1/organisations",
        "previous": "/api/v1/organisations?page=1",
        "next": "/api/v1/organisations?page=2",
        "last": "/api/v1/organisations?page=3"
      }
    }
  end
end
