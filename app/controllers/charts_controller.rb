class ChartsController < ApplicationController
  before_action :set_challenge
  before_action :set_challenge_rounds, only: :index
  before_action :set_vote, only: :index
  before_action :set_follow, only: :index
  before_action :set_current_round
  before_action :set_collection, except: [:index]

  def index
  end

  def submissions_vs_time
    render json: @collection.group_by_day(:created_at).count
  end

  def top_score_vs_time
    # Calculate running maximum hash for dates
    top_score_hash = {}
    current_max    = 0
    @collection.group_by_day(:created_at).maximum(:score).each do |k, v|
      current_max       = [current_max, v.to_f.round(@challenge.active_round.score_precision)].max
      top_score_hash[k] = current_max
    end
    render json: top_score_hash
  end

  private

  def set_challenge
    @challenge = Challenge.friendly.find(params[:challenge_id])
  end

  def set_current_round
    @current_round = if params[:challenge_round_id].present?
                       @challenge.challenge_rounds.find(params[:challenge_round_id].to_i)
                     else
                       @challenge.active_round
                     end
  end

  def set_collection
    @collection = @challenge.submissions
    @collection = @current_round.submissions if @current_round.present?
  end

  def set_challenge_rounds
    @challenge_rounds = @challenge.challenge_rounds.started
  end

  def set_vote
    @vote = @challenge.votes.where(participant_id: current_participant.id).first if current_participant.present?
  end

  def set_follow
    @follow = @challenge.follows.where(participant_id: current_participant.id).first if current_participant.present?
  end
end
