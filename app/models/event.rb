class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, type: Symbol
  field :party_url, type: String
  
  include Flex::ModelIndexer
  
  flex.sync self
  flex.index = "kb_event_#{Rails.env}"
  flex.type = "event"
  
  def self.create_event(name: nil, party_url: nil, event: nil)
    e = Event.new
    e.create_event(name: name, party_url: party_url, event: event)
    e
  end
  
  def create_event(name: nil, party_url: nil, event: nil)
    @event = event
    self.type = name.to_sym
    self.party_url = party_url
    self.save
    self
  end
  
  def flex_source
    @event
  end
  

end