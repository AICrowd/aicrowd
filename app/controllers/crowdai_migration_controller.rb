class CrowdaiMigrationController < ApplicationController
  before_action :authenticate_participant!

  def index
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    @encrypted_data = crypt.encrypt_and_sign('701ewfwf4')
    @decrypted_data = crypt.decrypt(@encrypted_data)
  end
end
