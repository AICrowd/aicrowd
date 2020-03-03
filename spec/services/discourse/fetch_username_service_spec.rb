require 'rails_helper'

describe Discourse::FetchUsernameService do
  subject { described_class.new(participant: participant) }

  describe '#call' do
    context 'when user with provided e-mail does not exist in Discord' do
      let(:participant) { create(:participant, email: 'does-not-exist@example.com') }

      it 'returns failure with error message' do
        result = VCR.use_cassette('discourse_api/fetch_username/failure') do
          subject.call
        end

        expect(result.success).to eq false
        expect(result.value).to eq ''
      end
    end

    context 'when user with provided e-mail exists in Discord', focus: true do
      let(:participant) { create(:participant, email: 'oussama.zouaghia@gmail.com') }

      it 'returns success with username value' do
        result = VCR.use_cassette('discourse_api/fetch_username/success') do
          subject.call
        end

        expect(result.success).to eq true
        expect(result.value).to eq 'username'
      end
    end
  end
end
