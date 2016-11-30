class UsersController < ApplicationController

  def show
    @user= User.find(params[:id])
    events = @user.events
    @user_participations = @user.participations.select do |participation|
      not events.include? participation.event
    end
  end

end


