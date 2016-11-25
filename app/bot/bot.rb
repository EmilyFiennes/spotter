require 'facebook/messenger'

include Facebook::Messenger

@bot_threads_controller = BotThreadsController.new
@bot_events_controller = BotEventsController.new
@bot_participations_controller = BotParticipationsController.new

# Find event variables
@find_address_required = false

# Create event variable
@create_date_required = false
@create_start_time_required = false
@create_end_time_required = false
@create_address_required = false

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
      @bot_events_controller.set_date(message)
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
      @bot_events_controller.gets_activity(message)
    elsif @create_address_required
      @create_address_required = false
      @bot_events_controller.set_create_address(message)
      @bot_events_controller.create(message)
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
  when /find_date/
    @bot_events_controller.set_date(postback)
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
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
