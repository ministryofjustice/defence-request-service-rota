module AuthService
  class UserInfo
    def initialize(strategy)
      @strategy = strategy
    end

    def get_user_info
      @strategy.raw_info
    end
  end
end
