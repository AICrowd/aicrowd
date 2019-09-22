class CrowdaiMigrationController < ApplicationController
  before_action :authenticate_participant!

  def index
    public_key_file = "/home/sphinx/.ssh/pem"
    @public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))

    private_key_file = "/home/sphinx/.ssh/id_rsa"
    @private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file))

    @data_1 = request.url.split("migrate_old_user?data=")[1].gsub("%20", " ").gsub("\\n", " ")

    # @data_2 = "YFPmHiNo0cTpQV4Skyl5tmnFXfZF8LeAZvm1+IV+BZfpOmPogI0bJsR+/Z+v\nBu7WbI/F1enL4+sargVQhM0iUk+RDVP7ounetffnfHQ9NVyz9dqt265K6Orf\nnvwIo7v1sK9aYcE2B5qbEgapCrGhufawmp53X0fTp7mAnu+iGATE2d7x/z81\n6DlX80qryL+5Y2uByVcHZZGU3KI1TLoV+BSqa/pct8HSXgEj7l/VoWa36A+W\nQpu9AyM3to5eLm7gxHwsawjmC2c/5AeTsr2kFXEPTF7YegbkM2WF/ejTwOGb\nWBeTurhR6oUjRQq2HYKpXheVV8nF0P+bg9R45zCUmA=="
    # string = MigrationMapping.first.crowdai_participant_id.to_s
    # @url = Addressable::URI.encode_component(@data_2)
    # @encrypted_string = Base64.encode64(@public_key.public_encrypt(string))
    @decrypted_string = @private_key.private_decrypt(Base64.decode64(@data_1))
    if MigrationMapping.where(crowdai_participant_id: @decrypted_string).empty?
      @error = "No participant exists with this id in crowdai"
    end
    unless MigrationLog.where(crowdai_participant_id: @decrypted_string).empty?
      @error = "Already migrated user"
    end
  end
end
