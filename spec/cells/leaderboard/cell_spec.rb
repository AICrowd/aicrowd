RSpec.describe Leaderboard::Cell, type: :cell do
  describe 'cell can be instantiated' do
    subject { cell(described_class, challenge, current_participant: participant) }

    let!(:challenge)   { create :challenge }
    let!(:participant) { create :participant }

    it { expect(subject).to be_a Leaderboard::Cell }
  end
end
