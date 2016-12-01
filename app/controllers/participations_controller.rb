class ParticipationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :destroy]

  def destroy
    @participation = Participation.find(params[:id])
    if @participation.destroy
      flash[:success] = "You are no longer participating in the #{@participation.event.activity.name} session with #{@participation.user.first_name} on #{@participation.event.start_at.strftime('%d-%m-%Y')}"
    end
    redirect_to user_path(current_user)
  end
end

