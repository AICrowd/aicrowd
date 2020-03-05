module Discourse
  class FetchUsernameService < ::Discourse::BaseService
    def initialize(participant:)
      @client      = prepare_http_client
      @participant = participant
    end

    def call
      return success(participant.discourse_username) if participant.discourse_username.present?
      return failure('DiscourseApi client couldn\'t be properly initialized.') if client.nil?

      response = client.get(fetch_username_path)

      binding.pry
    rescue Discourse::Error => e
      Logger.new(::Discourse::BaseService::LOGGER_URL).error("##{challenge.id} - Unable to retrieve username - #{e.message}")

      failure('Discourse API is unavailable')
    end

    private

    attr_reader :client, :participant

    def fetch_username_path
      "/admin/users/list.json?#{email_query_parameter}"
    end

    def email_query_parameter
      { email: participant.email }.to_query
    end
  end
end
