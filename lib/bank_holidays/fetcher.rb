module BankHolidays
  class Fetcher
    def initialize(url:)
      @url = url
    end

    def fetch
      response.body
    end

    private

    attr_reader :url

    def response
      resp_obj = HTTParty.get(url)

      raise "File could not be retrieved" if resp_obj.code != 200

      resp_obj
    end
  end
end
