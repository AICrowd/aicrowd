module LandingPageHelper
  def users_group(index)
    if index < 4
      "users-group-1"
    else
      "users-group-#{index - 2}"
    end
  end
end
