class FakeDataApi
  def initialize(token)
    @token = token
  end

  def organisations
    [
      OpenStruct.new(
        uid: "1234567890abcdef",
        name: "Tuckers",
        type: "law_firm",
        links: { "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3" }
      ),
      OpenStruct.new(
        uid: "0987654321fedcba",
        name: "Brighton",
        type: "custody_suite",
        links: { "profiles" => "/api/v1/profiles?uids[]=0f9e8d&uids[]=7c6b5a" }
      ),
    ]
  end
end
