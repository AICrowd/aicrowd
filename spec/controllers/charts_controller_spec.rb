require 'rails_helper'

RSpec.describe ChartsController, type: :controller do
  describe '#index' do
    let!(:challenge) { create(:challenge, :completed) }

    context 'when user is not logged in' do
      it 'renders leaderboards listing' do
        visit challenge_charts_path(challenge)

        expect(page).to have_http_status 200
        expect(page).to have_current_path challenge_charts_path(challenge)
        expect(page).to have_content('SUBMISSIONS VS TIME')
        expect(page).to have_content('BEST SCORE VS TIME')
        expect(page).to have_content('GEO CHART')
      end
    end
  end
end
