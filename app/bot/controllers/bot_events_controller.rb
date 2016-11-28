class BotEventsController
  def initialize
    @bot_events_view = BotEventsView.new
  end

  # Find Event
  def set_address_around_me(session, message)
    session.find_event_data[:address] = "Bordeaux, France"
  end

  def set_address(session, message)
    session.find_event_data[:address] = message.text
  end

  def set_find_date(session, postback)
    if postback.payload ==  'find_date_today'
      session.find_event_data[:today] = true
    elsif postback.payload ==  'find_date_later'
      session.find_event_data[:today] = false
    end
  end

  def set_find_activity(session, postback)
    session.find_event_data[:activity] = postback.payload.split.last
  end

  def index(session, postback)
    if session.find_event_data[:activity] == "Surprise"
      if session.find_event_data[:today]
        events = Event.where("start_at <= ?", Date.tomorrow.midnight).near(session.find_event_data[:address], 10)
      else
        events = Event.where("start_at > ?", Date.tomorrow.midnight).near(session.find_event_data[:address], 10)
      end
    else
      activity = Activity.find_by(name: session.find_event_data[:activity])
      if session.find_event_data[:today]
        events = Event.where("start_at <= ? and activity_id =?", Date.today.midnight, activity).near(session.find_event_data[:address], 10)
      else
        events = Event.where("start_at > ? and activity_id =?", Date.today.midnight, activity).near(session.find_event_data[:address], 10)
      end
    end
    @bot_events_view.show_list(events, postback)
  end


  # Create Event

  def gets_day(session, postback)
    @bot_events_view.choose_now_or_later(postback)
  end

  def set_date_today(session, postback)
    session.create_event_data[:date] = Date.today
  end

  def gets_date(session, postback)
    @bot_events_view.choose_date(postback)
  end

  def set_create_date(session, message)
    date = Time.parse(message.text)
    if date < Date.today
      @bot_events_view.choose_later_start_date(message)
      return false
    else
      session.create_event_data[:date] = Date.parse(message.text)
      return true
    end
  end

  def gets_start_time(session, postback)
    @bot_events_view.choose_start_time(postback)
  end

  def set_start_time(session, message)
    session.create_event_data[:start_time] = Time.parse(message.text)
  end

  def gets_end_time(session, message)
    @bot_events_view.choose_end_time(message)
  end

  def set_end_time(session, message)
    start_time = session.create_event_data[:start_time]
    end_time = Time.parse(message.text)
    if start_time <= end_time
      @bot_events_view.choose_later_end_time(message)
      return false
    else
      session.create_event_data[:end_time] = Time.parse(message.text)
      return true
    end
  end

  def gets_activity_1(session, message)
    @bot_events_view.full_list_1(message)
  end

  def gets_activity_2(session, postback)
    @bot_events_view.full_list_2(postback)
  end

  def gets_activity_3(session, postback)
    @bot_events_view.full_list_3(postback)
  end

  def gets_activity_4(session, postback)
    @bot_events_view.full_list_4(postback)
  end

  def gets_activity_5(session, postback)
    @bot_events_view.full_list_5(postback)
  end

  def set_create_activity(session, postback)
    session.create_event_data[:activity] = postback.payload.split.last
  end

  def gets_address(session, message)
    @bot_events_view.enter_address(message)
  end

  def set_create_address(session, message)
    session.create_event_data[:address] = message.text
  end

  def gets_level(session, message)
    @bot_events_view.choose_level(message)
  end

  def set_level(session, postback)
    session.create_event_data[:level] = postback.payload.split.last
  end

  def gets_max_participants(session, postback)
    @bot_events_view.enter_max_participants(postback)
  end

  def set_max_participants(session, message)
    session.create_event_data[:max_participants] = message.text
  end

  def gets_event_description(session, postback)
    @bot_events_view.enter_event_description(postback)
  end

  def set_event_description(session, message)
    session.create_event_data[:description] = message.text
  end

  def create(session, message)
    d = session.create_event_data[:date]
    st = session.create_event_data[:start_time]
    et = session.create_event_data[:end_time]
    session.create_event_data[:start_at] = DateTime.new(d.year, d.month, d.day, st.hour, st.min)
    session.create_event_data[:end_at] = DateTime.new(d.year, d.month, d.day, et.hour, et.min)
    activity = Activity.find_by(name: session.create_event_data[:activity])
    user = User.find_by(messenger_id: message.sender['id'])
    Event.create(
      start_at: session.create_event_data[:start_at],
      end_at: session.create_event_data[:end_at],
      activity: activity,
      address: session.create_event_data[:address],
      level: session.create_event_data[:level],
      max_participants: session.create_event_data[:max_participants],
      description: session.create_event_data[:description],
      user: user
      )
  end
end
