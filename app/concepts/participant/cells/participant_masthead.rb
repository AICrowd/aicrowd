class Participant::Cell::ParticipantMasthead < Template::Cell
  inherit_views Participant::Cell

  def show
    render :participant_masthead
  end

  def participant
    model
  end

  def location_organization
    location_organization = []
    location_organization << participant.location << '·' if participant.location
    location_organization << participant.organizer.organizer if participant.organizer_id
    return nil if location_organization.empty?

    location_organization.join(' ')
  end

end
