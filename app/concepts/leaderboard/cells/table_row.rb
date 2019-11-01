class Leaderboard::Cell::TableRow < Leaderboard::Cell

  def show
    if entry.baseline
      render :baseline_row
    else
      render :table_row
    end
  end

  def entry
    model
  end

  def formatted_score
    format("%.#{challenge_round.score_precision}f", entry.score || 0)
  end

  def formatted_score_secondary
    format("%.#{challenge_round.score_precision}f", entry.score_secondary || 0)
  end

  def challenge
    @challenge ||= model.challenge
  end

  def other_scores_array
    other_scores = []
    challenge.other_scores_fieldnames_array.each do |fname|
      other_scores << if entry.meta && (entry.meta.key? fname)
                        (entry.meta[fname].nil? ? "-" : format("%.3f", entry.meta[fname].to_f))
                      else
                        '-'
                      end
    end
    other_scores
  end

  def participant
    @participant ||= entry.participant
  end

  def team
    @participant ||= entry.team
  end

  def participants
    @participants ||= begin
      case entry.try(:submitter_type) || 'Participant'
      when 'Participant'
        [entry.participant]
      when 'Team'
        entry.team.participants.to_a
      else
        []
      end
    end
  end

  def top_rows
    @top_rows ||= challenge_round.ranking_highlight
  end

  def leader_class
    return 'leader' if model.row_num <= top_rows
  end

end
