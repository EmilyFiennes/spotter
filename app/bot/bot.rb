require 'facebook/messenger'

include Facebook::Messenger

@bot_threads_controller = BotThreadsController.new
@bot_events_controller = BotEventsController.new
@bot_participations_controller = BotParticipationsController.new

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

Bot.on :message do |message|
  timestamp = message.messaging['timestamp'].to_i / 1000
  date = DateTime.strptime(timestamp.to_s, '%s').strftime('%d-%m-%Y %H:%M')
  puts "Received '#{message.inspect}' from #{message.sender} at #{date}"
  session = BotUserSessionRepository.find_or_create(message)
  puts session.inspect

  case message.text
  when /hello/i
    user_identification(message)
    @bot_threads_controller.welcome(session, message)
    @bot_threads_controller.initial_choice(session, message)
  when "Start again"
    session = BotUserSessionRepository.create(message)
    @bot_threads_controller.initial_choice(session, message)
  else
    if session.find_address_required
      session.find_address_required = false
      @bot_events_controller.set_address(session, message)
      @bot_events_controller.index(session, message)
    elsif session.create_date_required
      if @bot_events_controller.set_create_date(session, message)
        @bot_events_controller.gets_start_time(session, message)
        session.create_date_required = false
        session.create_start_time_required = true
      end
    elsif session.create_start_time_required
      session.create_start_time_required = false
      @bot_events_controller.set_start_time(session, message)
      @bot_events_controller.gets_end_time(session, message)
      session.create_end_time_required = true
    elsif session.create_end_time_required
      session.create_end_time_required = false
      @bot_events_controller.set_end_time(session, message)
      @bot_events_controller.gets_activity_1(session, message)
    elsif session.create_address_required
      session.create_address_required = false
      @bot_events_controller.set_create_address(session, message)
      @bot_events_controller.gets_level(session, message)
    elsif session.create_max_participants_required
      session.create_max_participants_required = false
      @bot_events_controller.set_max_participants(session, message)
      @bot_events_controller.gets_event_description(session, message)
      session.create_event_description_required = true
    elsif session.create_event_description_required
      session.create_event_description_required = false
      @bot_events_controller.set_event_description(session, message)
      @bot_events_controller.create(session, message)
    else
      message.reply(
        text: "Now where are your manners? Say 'hello' to start 😎"
      )
    end
  end
end

Bot.on :postback do |postback|
  puts "Received '#{postback.inspect}' from #{postback.sender}"
  session = BotUserSessionRepository.find_or_create(postback)
  puts session.inspect

  case postback.payload
  when 'FIND'
    @bot_threads_controller.gets_day(session, postback)
  when 'CREATE'
    @bot_events_controller.gets_day(session, postback)
  when /find_date/
    @bot_events_controller.set_find_date(session, postback)
    @bot_threads_controller.gets_activity(session, postback)
  when /find_activity/
    @bot_events_controller.set_find_activity(session, postback)
    @bot_threads_controller.gets_location(session, postback)
  when 'find_around_me'
    @bot_events_controller.set_address_around_me(session, postback)
    @bot_events_controller.index(session, postback)
  when 'find_address'
    session.find_address_required = true
    @bot_threads_controller.gets_address(session, postback)
  when /choose_date_today/
    @bot_events_controller.set_date_today(session, postback)
    session.create_start_time_required = true
    @bot_events_controller.gets_start_time(session, postback)
  when /choose_date_later/
    session.create_date_required = true
    @bot_events_controller.gets_date(session, postback)
  when /choose_activity/
    @bot_events_controller.set_create_activity(session, postback)
    session.create_address_required = true
    @bot_events_controller.gets_address(session, postback)
  when /choose_level/
    @bot_events_controller.set_level(session, postback)
    session.create_max_participants_required = true
    @bot_events_controller.gets_max_participants(session, postback)
  when /view_more_activities_2/
    @bot_events_controller.gets_activity_2(session, postback)
  when /view_more_activities_3/
    @bot_events_controller.gets_activity_3(session, postback)
  when /view_more_activities_4/
    @bot_events_controller.gets_activity_4(session, postback)
  when /view_more_activities_5/
    @bot_events_controller.gets_activity_5(session, postback)
  when /view_more_activities_1/
    @bot_events_controller.gets_activity_1(session, postback)
  when "start_again"
    session = BotUserSessionRepository.create(postback)
    @bot_threads_controller.initial_choice(session, postback)
  end
end

# API request with messenger_id >> https://scontent.xx.fbcdn.net/v/t1.0-1/13707549_        10153613412591046  _47027652010636828_n.jpg?oh=82af0fc733f6ff004fb5a792a35c61b2&oe=58C3425D
# facebook_picture_url          >> https://graph.facebook.com/v2.6/                        10153922001001046  /picture?type=square
# API request with me           >> https://scontent.xx.fbcdn.net/v/t1.0-1/p50x50/13707549_ 10153613412591046  _47027652010636828_n.jpg?oh=21f43a15129adfc8d95db5a98c9af850&oe=58B95A67"


