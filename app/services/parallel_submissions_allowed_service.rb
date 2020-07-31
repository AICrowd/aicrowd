class ParallelSubmissionsAllowedService
  def initialize(challenge, participant)
    @challenge   = challenge
    @participant = participant
    # TODO: add parallel_submissions to views.
    @round       = challenge.active_round
  end

  def call
    return true if @round.parallel_submissions == 0

    parallel_submissions = @challenge.submissions
                                     .where(
                                       participant_id:    @participant.id,
                                       grading_status_cd: 'submitted'
                                     )
                                     .count
    !(parallel_submissions >= @round.parallel_submissions)
  end
end
