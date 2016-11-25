require 'facebook/messenger'

include Facebook::Messenger

@bot_threads_controller = BotThreadsController.new
@bot_events_controller = BotEventsController.new
@bot_participations_controller = BotParticipationsController.new

@address_required = false

Facebook::Messenger::Thread.set({
  setting_type: 'call_to_actions',
  thread_state: 'existing_thread',
  call_to_actions: [
    {
      type: 'postback',
      title: 'Find an activity',
      payload: 'FIND'
    },
    {
      type: 'postback',
      title: 'Create an activity',
      payload: 'CREATE'
    },
    {
      type: 'web_url',
      title: 'View my dashboard',
      url: 'https://rails-spotter-app.herokuapp.com/users/#{params[:id]}'
    },
    {
      type: 'web_url',
      title: 'Visit the website',
      url: 'https://rails-spotter-app.herokuapp.com/'
    }
  ]
  }, access_token: ENV['ACCESS_TOKEN']
)

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

@start_hour_asked = false


Bot.on :message do |message|
  BOT_SESSION ||= {}
  timestamp = message.messaging['timestamp'].to_i / 1000
  date = DateTime.strptime(timestamp.to_s, '%s').strftime('%d-%m-%Y %H:%M')
  puts "Received '#{message.inspect}' from #{message.sender} at #{date}"

  if /hello/i.match(message.text)
    @bot_threads_controller.welcome(message)
    @bot_threads_controller.initial_choice(message)
  elsif message.text == "Start again"
    @bot_threads_controller.initial_choice(message)
  elsif /\A(?<day>\d+)\/(?<month>\d+)\/(?<year>\d+)\z/i.match(message.text)
    BOT_SESSION[:day] = $LAST_MATCH_INFO['day'].to_i
    BOT_SESSION[:month] = $LAST_MATCH_INFO['month'].to_i
    BOT_SESSION[:year] = $LAST_MATCH_INFO['year'].to_i
    # date = Date.new(@year, @month, @day)
    @bot_events_controller.gets_start_time(message)
    #@bot_events_controller.new_event(message, date: date)
  elsif @start_hour_asked == false && /(?<start_hour>\d+)\:(?<minute>\d+)/i.match(message.text)
    BOT_SESSION[:start_hour] = $LAST_MATCH_INFO['start_hour'].to_i
    BOT_SESSION[:start_minute] = $LAST_MATCH_INFO['minute'].to_i
    # start_time = Time.new(@year, @month, @day, @start_hour, minute)
    @start_hour_asked = true
    @bot_events_controller.gets_end_time(message)
  elsif /(?<end_hour>\d+)\:(?<minute>\d+)/i.match(message.text)
    BOT_SESSION[:end_hour] = $LAST_MATCH_INFO['end_hour'].to_i
    BOT_SESSION[:end_minute] = $LAST_MATCH_INFO['minute'].to_i
    #end_time = Time.new(@year, @month, @day, @start_hour, minute)
    @start_hour_asked = false
    #do something to stock time and date
    @bot_events_controller.gets_activity(message)
  else
    if @address_required
      @address_required = false
      @bot_events_controller.set_address(message)
      @bot_events_controller.index(message)
    else
      message.reply(
        text: "Say 'hello' to start"
      )
    end
  end
end

Bot.on :postback do |postback|

  case postback.payload
  when 'FIND'
    @bot_threads_controller.gets_day(postback)
  when 'CREATE'
    @bot_events_controller.gets_day(postback)
  when /date/i
    @bot_events_controller.set_date(postback)
    @bot_threads_controller.gets_activity(postback)
  when /activity/i
    @bot_events_controller.set_activity(postback)
    @bot_threads_controller.gets_location(postback)
  when 'around_me'
    @bot_events_controller.set_address_around_me(postback)
    @bot_events_controller.index(postback)
  when 'address'
    @address_required = true
    @bot_events_controller.gets_address(postback)
  when /choice/i
    @bot_events_controller.set_create_date(postback)
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
