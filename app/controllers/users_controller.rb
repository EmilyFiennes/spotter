class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
    @user= User.find(params[:id])
    # @date= Date.parse("#{event.start_at}").strftime("%d %b %Y")
    # @start_time= Date.parse("#{event.start_at}").strftime("%H:%m")
    # @end_time= Date.parse("#{event.end_at}").strftime("%H:%m")
  end

end


