class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @event = Event.find(params[:id])
    @start_at = Date.parse("#{@event.start_at}").strftime("%d %b %Y at %H:%m")
    @end_at = Date.parse("#{@event.end_at}").strftime("%d %b %Y at %H:%m")
  end
end
