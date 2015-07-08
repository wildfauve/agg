json.kind "event"
json.events @events do |event|
  json.type event.type
  json.created_at event.created_at
  json.party_url event.party_url
end