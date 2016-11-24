class BotThreadsController
  def initialize
    @bot_threads_view = BotThreadsView.new
  end

  def welcome(message)
    @bot_threads_view.welcome_message(message)
  end

  def initial_choice(message)
    @bot_threads_view.initial_choice(message)
  end

  def gets_location(postback)
    @bot_threads_view.location(postback)
  end

  def gets_day(postback)
    @bot_threads_view.now_or_later(postback)
  end

  def gets_activity(postback)
    @bot_threads_view.activity_list(postback)
  end

end


