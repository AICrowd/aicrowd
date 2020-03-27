require 'cgi'
require 'active_support'

class Api::HelperController < Api::BaseController
  respond_to :json

  def login_user
    result      = verify_and_decrypt_session_cookie(params[:aicrowd_session])
    participant = Participant.find_by(id: result["warden.user.participant.key"][0]) if result.present? && !result["warden.user.participant.key"].nil?

    if participant.present?
      render json: { message: "Participant #{participant.email} is login" }, status: :ok
    else
      render json: { message: 'Participant not present' }, status: :ok
    end
  end

  def verify_and_decrypt_session_cookie(cookie, secret_key_base = Rails.application.secret_key_base)
    cookie                  = CGI::unescape(cookie)
    salt                    = 'authenticated encrypted cookie'
    encrypted_cookie_cipher = 'aes-256-gcm'
    serializer              = JSON

    key_generator = ActiveSupport::KeyGenerator.new(secret_key_base, iterations: 1000)
    key_len       = ActiveSupport::MessageEncryptor.key_len(encrypted_cookie_cipher)
    secret        = key_generator.generate_key(salt, key_len)
    encryptor     = ActiveSupport::MessageEncryptor.new(secret, cipher: encrypted_cookie_cipher, serializer: serializer)

    begin
      encryptor.decrypt_and_verify(cookie)
    rescue => error
      nil
    end
  end
end
