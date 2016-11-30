require 'facebook/messenger'

include Facebook::Messenger

@bot_threads_controller = BotThreadsController.new
@bot_events_controller = BotEventsController.new
@bot_participations_controller = BotParticipationsController.new

Facebook::Messenger::Thread.set({
  setting_type: 'greeting',
  greeting: {
    text: "Don't be shy...go ahead and say hello to get started!"
  },
}, access_token: ENV['ACCESS_TOKEN'])

Facebook::Messenger::Thread.set({
  setting_type: 'call_to_actions',
  thread_state: 'existing_thread',
  call_to_actions: [
    {
      type: 'postback',
      title: 'Start again',
      payload: 'start_again'
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
  # timestamp = message.messaging['timestamp'].to_i / 1000
  # date = DateTime.strptime(timestamp.to_s, '%s').strftime('%d-%m-%Y %H:%M')
  # puts "Received '#{message.inspect}' from #{message.sender} at #{date}"

  case message.text
  when /hello/i
    @bot_threads_controller.welcome(message)
    User.messenger_identification(message)
    @bot_threads_controller.initial_choice(message)
  when /start again/i
    @bot_threads_controller.initial_choice(message)
  else
    user = current_user(message)
    case user.session['step']
    when "enter_find_my_location"
      @bot_events_controller.set_location(message)
      @bot_events_controller.index(message)
    when "enter_find_address"
      @bot_events_controller.set_address(message)
      @bot_events_controller.index(message)
    when "enter_create_date"
      if @bot_events_controller.set_create_date(message)
        @bot_events_controller.gets_start_time(message)
      end
    when "enter_start_time"
      if @bot_events_controller.set_start_time(message)
         @bot_events_controller.gets_end_time(message)
      end
    when "enter_end_time"
      if @bot_events_controller.set_end_time(message)
        @bot_events_controller.gets_activity_1(message)
      end
    when "enter_create_address"
      @bot_events_controller.set_create_address(message)
      @bot_events_controller.gets_level(message)
    when "enter_max_participants"
      @bot_events_controller.set_max_participants(message)
      @bot_events_controller.gets_event_description(message)
    when "enter_description"
      @bot_events_controller.set_event_description(message)
      @bot_events_controller.create(message)
      @bot_events_controller.show_event(message)
    # when "confirmation"
    #   @bot_events_view.show_participation_confirmation(response)
    #   @bot_events_controller.confirm_participation(response, event)
    # else
      message.reply(
        text: "Now where are your manners? Say 'hello' to start 😎"
      )
    end
  end
end

Bot.on :postback do |postback|
  puts "Received '#{postback.inspect}' from #{postback.sender}"

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
  when 'find_location'
    @bot_threads_controller.gets_my_location(postback)
  when 'find_address'
    @bot_threads_controller.gets_address(postback)
  when /participate/
    @bot_participations_controller.confirm_participation(postback)
  when /choose_date_today/
    @bot_events_controller.set_date_today(postback)
    @bot_events_controller.gets_start_time(postback)
  when /choose_date_later/
    @bot_events_controller.gets_date(postback)
  when /choose_activity/
    @bot_events_controller.set_create_activity(postback)
    @bot_events_controller.gets_address(postback)
  when /view_more_activities_2/
    @bot_events_controller.gets_activity_2(postback)
  when /view_more_activities_3/
    @bot_events_controller.gets_activity_3(postback)
  when /view_more_activities_1/
    @bot_events_controller.gets_activity_1(postback)
  when /choose_level/
    @bot_events_controller.set_level(postback)
    @bot_events_controller.gets_max_participants(postback)
  when "start_again"
    @bot_threads_controller.initial_choice(postback)
  when /confirm/
    @bot_participations_controller.create_participation(postback)
    @bot_events_controller.show_participation(postback)
  end
end

def current_user(response)
  User.find_by(messenger_id: response.sender['id'])
end

