class ParticipationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :destroy]

  def destroy
    @participation = Participation.find(params[:id])
    if @participation.destroy
      flash[:alert] = "Your participation #{@participation.event.activity.name} has been successfully deleted."
    end
    redirect_to user_path(@participation.user)
  end
end

