class BotThreadsController
  def initialize
    @bot_threads_view = BotThreadsView.new
  end

  def welcome(response)
    @bot_threads_view.welcome_message(response)
  end

  def initial_choice(response)
    user = current_user(response)
    user.session = {
      step:"",
      find_event_data: {},
      create_event_data: {}
    }
    user.session["step"] = "welcome"
    user.save
    @bot_threads_view.initial_choice(response)
  end

  def gets_day(response)
    user = current_user(response)
    user.session["step"] = "choose_find_date"
    user.save
    @bot_threads_view.now_or_later(response)
  end

  def gets_activity(response)
    user = current_user(response)
    user.session["step"] = "choose_find_activity"
    user.save
    @bot_threads_view.activity_list(response)
  end

  def gets_location(response)
    user = current_user(response)
    user.session["step"] = "choose_find_my_location"
    user.save
    @bot_threads_view.location(response)
  end

  def gets_my_location(response)
    user = current_user(response)
    user.session["step"] = "enter_find_my_location"
    user.save
    @bot_threads_view.my_location(response)
  end

  def gets_address(response)
    user = current_user(response)
    user.session["step"] = "enter_find_address"
    user.save
    @bot_threads_view.address(response)
  end

  private

  def current_user(response)
    User.find_by(messenger_id: response.sender['id'])
  end

end


