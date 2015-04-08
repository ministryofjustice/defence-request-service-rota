class FakeDataApi
  def self.start
    new
  end

  def solicitors
    solicitors_endpoint[:profiles]
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
end
