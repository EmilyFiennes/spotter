class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :delete ]

  def show
    @user = current_user
    @event = Event.find(params[:id])
    @date = @event.start_at.strftime("%d %b %Y")
    @start_time = @event.start_at.strftime("%H:%m")
    @end_time = @event.end_at.strftime("%H:%m")
  end

  def destroy
    user = current_user
    @event = Event.find(params[:id])
    if @event.destroy
      flash[:alert] = "Your event #{@event.activity.name} on #{@event.start_at} has been successfully deleted."
    end
    redirect_to user_path(user)
  end
end
