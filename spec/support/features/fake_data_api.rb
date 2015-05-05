module FakeDataApis
  def set_data_api_to(data_api)
    DefenceRequestServiceRota.register_service(:auth_api, data_api)
  end

  class FakeLawFirmsApi
    def initialize(token)
      @token = token
    end

    def organisations(options = {})
      [
        OpenStruct.new(
          uid: "1234567890abcdef",
          name: "Guilded Groom & Groom",
          type: "law_firm",
          links: { "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3" }
        ),
        OpenStruct.new(
          uid: "0987654321fedcba",
          name: "The Impecably Suited Co.",
          type: "custody_suite",
          links: { "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3" }
        ),
      ]
    end
  end
end
