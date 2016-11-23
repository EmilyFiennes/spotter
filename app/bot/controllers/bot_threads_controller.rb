require_relative '../views/bot_threads_view.rb'

class BotThreadsController
  def initialize
    @bot_threads_view = BotThreadsView.new
  end

  def welcome(message)
    @bot_threads_view.welcome_message(message)
    @bot_threads_view.initial_choice(message)
  end

end


