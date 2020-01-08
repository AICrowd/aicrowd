class SubmissionGrade < ApplicationRecord
  belongs_to :submission
  after_save :update_submission
  default_scope { order('created_at DESC') }

  as_enum :grading_status, [:ready, :submitted, :graded, :failed, :initiated], map: :string, accessor: :whiny

  validates :submission_id, presence: true
  validates :grading_status, presence: true

  def update_submission
    Submission.update(
      self.submission_id,
      grading_status: self.grading_status,
      grading_message: self.grading_message,
      score: self.score,
      score_secondary: self.score_secondary)
  end
end
