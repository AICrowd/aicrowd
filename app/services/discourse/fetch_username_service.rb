module Discourse
  class FetchUsernameService < ::Discourse::BaseService
    DISCOURSE_ENDPOINT_URL = "#{ENV['DISCOURSE_DOMAIN_NAME']}/admin/users/list.json?".freeze

    def initialize(participant:)
      @participant = participant
    end

    def call
      # uri      = URI.parse("#{DISCOURSE_ENDPOINT_URL}?#{email_query_parameter}")
      # http     = prepare_http_client(uri)
      # response = http.request(Net::HTTP::Get.new(uri))

      # binding.pry

      success('test')
    rescue *BaseService::CONNECTION_ERRORS => error
      failure(error.message)
    end

    private

    attr_reader :participant

    def email_query_parameter
      { email: participant.email }.to_query
    end
  end
end
