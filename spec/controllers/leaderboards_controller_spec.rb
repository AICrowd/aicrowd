require 'rails_helper'

RSpec.describe LeaderboardsController, type: :controller do
  render_views

  context 'current round' do
    3.times do |i|
      let!("submission_#{i + 1}") {
        create :submission,
          challenge: challenge,
          participant: participant,
          grading_status_cd: 'graded' }
    end
    let(:challenge)   { create :challenge, :running }
    let(:participant) { create :participant }
    let(:user)        { create :participant }

    before do
      sign_in user
    end

    describe 'GET #index' do
      before { get :index, params: { challenge_id: submission_1.challenge_id } }

      it { expect(response).to render_template :index }
    end
  end
end
