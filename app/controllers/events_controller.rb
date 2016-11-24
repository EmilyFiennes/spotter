class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @event = Event.find(params[:id])
    @start_at = Date.parse("#{@event.start_at}").strftime("%a, %d %b %Y")
  end
end
