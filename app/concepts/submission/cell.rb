class Submission::Cell < Template::Cell
  include LocalTimeHelper

  def entry
    model
  end

  def enable_links_in_raw_text(text)
    return if text.nil?

    sanitize(text.gsub(%r{(https?://[\S]+)}, "<a href='\\1'>\\1</a>"))
  end

  def formatted_value(value)
    if value.nil?
      "-"
    else
      value
    end
  end

  def grade_class
    if entry.grading_status_cd == "graded"
      "badge-success"
    elsif entry.grading_status_cd == "initiated"
      "badge-gold"
    elsif entry.grading_status_cd == "submitted"
      "badge-gold"
    elsif entry.grading_status_cd == "ready"
      "badge-silver"
    else
      "badge-warning"
    end
  end

  def challenge
    @challenge ||= model.challenge
  end

  def participant
    @participant ||= entry.participant
  end
end
