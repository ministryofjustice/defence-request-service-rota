RSpec.shared_context "valid client token" do
  let!(:valid_token) { "abc123" }

  def api_request_headers
    stub_request(:get, "http://app.example.com/token_info").
      with(headers: {"Authorization" => "Bearer #{valid_token}"}).
      to_return(status: 200, body: "", headers: {})

    {
      "Authorization": "Bearer #{valid_token}",
      "Content-Type": "application/json"
    }
  end
end

RSpec.shared_examples "a protected endpoint" do |url|
  it "returns a 401 response with an error message for unauthenticated requests" do
    invalid_token = "invalid-token"

    stub_request(:get, "http://app.example.com/token_info").
      with(headers: { "Authorization" => "Bearer #{invalid_token}" }).
      to_return(status: 401, body: "", headers: {})

    get url, nil,
      {
        "Authorization": "Bearer #{invalid_token}",
        "Content-Type": "application/json"
      }

    expect(response.status).to eq(401)
    expect(response_json).to eq(
      {
        "errors" => ["Not authorized, please provide a valid client token"]
      }
    )
  end
end
