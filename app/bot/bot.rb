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

# Find event variables
@find_address_required = false

# Create event variable
@create_date_required = false
@create_start_time_required = false
@create_end_time_required = false
@create_address_required = false
@create_max_participants_required = false
@create_event_description_required = false

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
    if @find_address_required
      @find_address_required = false
      @bot_events_controller.set_address(message)
      @bot_events_controller.index(message)
    elsif @create_date_required
      @create_date_required = false
      @bot_events_controller.set_create_date(message)
      @bot_events_controller.gets_start_time(message)
      @create_start_time_required = true
    elsif @create_start_time_required
      @create_start_time_required = false
      @bot_events_controller.set_start_time(message)
      @bot_events_controller.gets_end_time(message)
      @create_end_time_required = true
    elsif @create_end_time_required
      @create_end_time_required = false
      @bot_events_controller.set_end_time(message)
      @bot_events_controller.gets_activity_1(message)
    elsif @create_address_required
      @create_address_required = false
      @bot_events_controller.set_create_address(message)
      @bot_events_controller.gets_level(message)
    elsif @create_max_participants_required
      @create_max_participants_required = false
      @bot_events_controller.set_max_participants(message)
      @bot_events_controller.gets_event_description(message)
      @create_event_description_required = true
    elsif @create_event_description_required
      @create_event_description_required = false
      @bot_events_controller.set_event_description(message)
      @bot_events_controller.create(message)
    else
      message.reply(
        text: "Now where are your manners? Say 'hello' to start 😎"
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
  when /find_date/
    @bot_events_controller.set_find_date(postback)
    @bot_threads_controller.gets_activity(postback)
  when /find_activity/
    @bot_events_controller.set_find_activity(postback)
    @bot_threads_controller.gets_location(postback)
  when 'find_around_me'
    @bot_events_controller.set_address_around_me(postback)
    @bot_events_controller.index(postback)
  when 'find_address'
    @find_address_required = true
    @bot_threads_controller.gets_address(postback)
  when /choose_date_today/
    @bot_events_controller.set_date_today(postback)
    @create_start_time_required = true
    @bot_events_controller.gets_start_time(postback)
  when /choose_date_later/
    @create_date_required = true
    @bot_events_controller.gets_date(postback)
  when /choose_activity/
    @bot_events_controller.set_create_activity(postback)
    @create_address_required = true
    @bot_events_controller.gets_address(postback)
  when /choose_level/
    @bot_events_controller.set_level(postback)
    @create_max_participants_required = true
    @bot_events_controller.gets_max_participants(postback)
  when /view_more_activities_2/
    @bot_events_controller.gets_activity_2(postback)
  when /view_more_activities_3/
    @bot_events_controller.gets_activity_3(postback)
  when /view_more_activities_4/
    @bot_events_controller.gets_activity_4(postback)
  when /view_more_activities_5/
    @bot_events_controller.gets_activity_5(postback)
  when /view_more_activities_1/
    @bot_events_controller.gets_activity_1(postback)
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
