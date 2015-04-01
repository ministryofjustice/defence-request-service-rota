module AuthService
  class Strategy
    def initialize(session_token, token_builder)
      @session_token = session_token
      @token_builder = token_builder
    end

    def with_token
      defence_request_strategy_strategy_with_token
    end

    private

    attr_reader :session_token, :token_builder

    def defence_request_strategy
      @_strategy ||= OmniAuth::Strategies::DefenceRequest.new(
        Settings.authentication.application_id,
        Settings.authentication.application_secret
      )
    end

    def defence_request_strategy_strategy_with_token
      defence_request_strategy.access_token =
        token_builder.call(defence_request_strategy.client, session_token)
      defence_request_strategy
    end
  end
end
