class FakeDataApi
  def solicitors
    solicitors_endpoint["profiles"]
  end

  def organisations
    organisations_endpoint["organisations"]
  end

  private

  def solicitors_endpoint
    {
      "profiles" => [
        {
          "uid" => "1a2b3c",
          "name" => "Bob Smith",
          "type" => "solicitor",
          "links" => {
            "organisation" => "/api/v1/organisations/1234567890abcdef"
          }
        },
        {
          "uid" => "4d5e6f",
          "name" => "Andy Brown",
          "type" => "agent",
          "links" => {
            "organisation" => "/api/v1/organisations/2345678901bcdefa"
          }
        }
      ],
      "links" => {
        "first" => "/api/v1/profiles",
        "previous" => "/api/v1/profiles?page=1",
        "next" => "/api/v1/profiles?page=2",
        "last" => "/api/v1/profiles?page=3"
      }
    }
  end

  def organisations_endpoint
    {
      "organisations" => [
        {
          "uid" => "1234567890abcdef",
          "name" => "Tuckers",
          "type" => "law_firm",
          "links" => {
            "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3"
          }
        },
        {
          "uid" => "0987654321fedcba",
          "name" => "Brighton",
          "type" => "custody_suite",
          "links" => {
            "profiles" => "/api/v1/profiles?uids[]=0f9e8d&uids[]=7c6b5a"
          }
        }
      ],
      "links" => {
        "first" => "/api/v1/organisations",
        "previous" => "/api/v1/organisations?page=1",
        "next" => "/api/v1/organisations?page=2",
        "last" => "/api/v1/organisations?page=3"
      }
    }
  end
end
