namespace :ahoy_visits do
  desc "Add location info to existing Ahoy Visits"
  task update_location: :environment do
    Ahoy::Visit.all.each do |visit|
      next if visit.ip == '::'

      ip       = visit.ip
      location = Geocoder.search(ip).first
      next unless location && location.country.present?

      visit.update(
        country:     location.country,
        region:      location.try(:state).presence,
        city:        location.try(:city).presence,
        latitude:    location.try(:latitude).presence,
        longitude:   location.try(:longitude).presence
      )
    end
  end
end
