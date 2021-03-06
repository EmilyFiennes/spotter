class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show ]

  def show
    @user = current_user
    @event = Event.find(params[:id])
    @date = @event.start_at.strftime("%d %b %Y")
    @start_time = @event.start_at.strftime("%H:%M")
    @end_time = @event.end_at.strftime("%H:%M")
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      flash[:success] = "Your event #{@event.activity.name} on #{@event.start_at.strftime('%d-%m-%Y')} has been successfully deleted."
    end
    redirect_to user_path(@event.user)
  end
end
