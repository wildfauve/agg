json.status :ok
json._links do
  json.self do
    json.href api_v1_event_url(@event_mgr.event)
  end
end