class Challenge::Cell::ChallengesSubnav < Challenge::Cell

  def show
    render :challenges_subnav
  end

  def challenges
    model
  end

  def categories_choices
    %w[some categories feteched from controllers]
  end

  def status_choices
    %w[All Active Completed Draft]
  end

  def prizes_choices
    ['Cash prizes', 'Travel grants', 'Academic papers', 'Misc prizes']
  end

  def status_filter
    options[:status_filter] || 'Completed'
  end

  def category_filter
    options[:category_filter]
  end

  def prizes_filter
    options[:prizes_filter]
  end

end
