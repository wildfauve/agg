class Api::V1::EventsController < Api::ApplicationController
  
  
  def create
    @event_mgr = EventManager.new.handle_event(params.except!(:action, :controller))
    render status: :created, location: api_v1_event_path(@event_mgr)
  end
  
end