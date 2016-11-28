class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @user = current_user
    @event = Event.find(params[:id])
    @date = Date.parse("#{@event.start_at}").strftime("%d %b %Y")
    @start_time = Date.parse("#{@event.start_at}").strftime("%H:%m")
    @end_time = Date.parse("#{@event.end_at}").strftime("%H:%m")
  end
end
