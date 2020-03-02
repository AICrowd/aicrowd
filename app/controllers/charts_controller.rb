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

    score              = params[:score].presence || 'score'
    sort_order         = if score == 'score'
                           @current_round["primary_sort_order_cd"]
                         else
                           @current_round["secondary_sort_order_cd"]
                         end
    grouped_collection = @collection.group_by_day(:created_at)

    return_hash = if sort_order == "descending"
                    get_running_min_hash(grouped_collection, score)
                  else
                    # sort_order == "ascending" or "not_used"
                    get_running_max_hash(grouped_collection, score)
                  end

    render json: return_hash
  end

  private

  def get_running_min_hash(collection, score)
    running_min_hash = {}
    current_min      = 100000000000000000000
    collection.minimum(score).each do |k, v|
      current_min         = [current_min, v.to_f.round(@challenge.active_round.score_precision)].min
      running_min_hash[k] = current_min
    end
    running_min_hash
  end

  def get_running_max_hash(collection, score)
    running_max_hash = {}
    current_max      = 0
    collection.maximum(score).each do |k, v|
      current_max         = [current_max, v.to_f.round(@challenge.active_round.score_precision)].max
      running_max_hash[k] = current_max
    end
    running_max_hash
  end

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
