class EventsController < ApplicationController

  def show
    @user = current_user
    @event = Event.find(params[:id])
    @date = @event.start_at.strftime("%d %b %Y")
    @start_time = @event.start_at.strftime("%H:%m")
    @end_time = @event.end_at.strftime("%H:%m")
  end
end
