class BotThreadsController
  def initialize
    @bot_threads_view = BotThreadsView.new
  end

  def welcome(response)
    @bot_threads_view.welcome_message(response)
  end

  def initial_choice(response)
    user = current_user(response)
    user.session = {}
    user.session[:step] = "welcome"
    @bot_threads_view.initial_choice(response)
  end

  def gets_day(response)
    user = current_user(response)
    user.session[:step] = "choose_find_date"
    @bot_threads_view.now_or_later(response)
  end

  def gets_activity(response)
    user = current_user(response)
    user.session[:step] = "choose_find_activity"
    @bot_threads_view.activity_list(response)
  end

  def gets_location(response)
    user = current_user(response)
    user.session[:step] = "choose_find_address"
    @bot_threads_view.location(postback)
  end

  def gets_address(response)
    user = current_user(response)
    user.session[:step] = "enter_find_address"
    @bot_threads_view.address(postback)
  end

  private

  def current_user(response)
    User.find_by(messenger_id: response.sender['id'])
  end

end


