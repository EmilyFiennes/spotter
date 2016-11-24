require 'facebook/messenger'

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
    @bot_threads_controller.initial_choice(message)
  when "Start again"
    @bot_threads_controller.initial_choice(message)
  else
    message.reply(
      text: "Say 'hello' to start"
    )
  end
end

Bot.on :postback do |postback|

  case postback.payload
  when 'FIND'
    @bot_threads_controller.gets_day(postback)
  # when 'CREATE'
  #   @bot_events_controller.new(postback)
  when /date/i
    @bot_events_controller.set_date(postback)
    @bot_threads_controller.gets_activity(postback)
  when /activity/i
    @bot_events_controller.set_activity(postback)
    @bot_events_controller.index(postback)
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
