require 'rails_helper'

RSpec.describe DatasetFilesController, type: :controller do
  render_views

  let!(:challenge) { create :challenge, :running }
  let!(:challenge_rules) {
    create :challenge_rules,
    challenge: challenge
  }
  let!(:participation_terms) {
    create :participation_terms
  }
  let!(:file1) {
    create :dataset_file, challenge: challenge, title: 'file1' }
  let!(:file2) {
    create :dataset_file, challenge: challenge, title: 'file2' }
  let!(:participant) { create :participant }
  let!(:challenge_participant) {
    create :challenge_participant,
    challenge: challenge,
    participant: participant
  }

  context 'participant' do
    before do
      sign_in participant
    end

    describe 'GET #index' do
      before { get :index, params: { challenge_id: challenge.id } }
      it { expect(response).to render_template :index }
    end

    describe "GET #new" do
      it "assigns a new dataset_file as @dataset_file" do
        get :new, params: { challenge_id: challenge.id }
        expect(assigns(:dataset_file)).to be_a_new(DatasetFile)
      end
    end
  end
end
