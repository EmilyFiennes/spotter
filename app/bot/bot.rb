require 'facebook/messenger'
require_relative 'controllers/bot_threads_controller'
require_relative 'controllers/bot_events_controller'
require_relative 'controllers/bot_participations_controller'

include Facebook::Messenger

@bot_threads_controller = BotThreadsController.new
@bot_events_controller = BotEventsController.new
@bot_participations_controller = BotParticipationsController.new

# Facebook::Messenger::Thread.set(
#   {
#     setting_type: 'greeting',
#     greeting: {
#       text: 'Welcome to Spotter! Ready to rumble?!'
#     }
#   },
#   access_token: ENV["ACCESS_TOKEN"]
# )

# Facebook::Messenger::Thread.set(
#   {
#     setting_type: 'call_to_actions',
#     thread_state: 'new_thread',
#     call_to_actions: [
#       {
#         payload: 'GET_STARTED'
#       }
#     ]
#   },
#   access_token: ENV["ACCESS_TOKEN"]
# )


Bot.on :message do |message|
  timestamp = message.messaging['timestamp'].to_i / 1000
  date = DateTime.strptime(timestamp.to_s, '%s').strftime('%d-%m-%Y %H:%M')
  puts "Received '#{message.inspect}' from #{message.sender} at #{date}"

  case message.text
  when /hello/i
    @bot_threads_controller.welcome(message)

  else
    message.reply(
      text: 'You are now marked for extermination.'
    )

    message.reply(
      text: 'Have a nice day.'
    )
  end
end

Bot.on :postback do |postback|

  # case postback.payload
  # when 'FIND'
  #   @bot_events_controller.index
  # when 'CREATE'
  #   @bot_events_controller.new
  # end

end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
