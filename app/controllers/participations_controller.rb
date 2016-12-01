class ParticipationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :destroy]

  def destroy
    @participation = Participation.find(params[:id])
    if @participation.destroy
      flash[:success] = "You are no longer participating in the #{@participation.event.activity.name} session with #{@participation.user.name} on #{@participation.event.start_at.strftime('%d-%m-%Y')}"
    end
    redirect_to user_path(@participation.user)
  end
end

