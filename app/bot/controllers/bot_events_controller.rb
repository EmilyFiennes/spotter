class BotEventsController
  def initialize
    @bot_events_view = BotEventsView.new
    @find_event_data = {}
    @create_event_data = {}
  end


  # Find Event

  def set_address_around_me(message)
    @find_event_data[:address] = "Bordeaux, France"
  end

  def set_address(message)
    @find_event_data[:address] = message.text
  end

  def set_find_date(postback)
    if postback.payload ==  'find_date_today'
      @find_event_data[:today] = true
    elsif postback.payload ==  'find_date_later'
      @find_event_data[:today] = false
    end
  end

  def set_find_activity(postback)
    @find_event_data[:activity] = postback.payload.split.last
  end

  def index(postback)
    if @find_event_data[:activity] == "Surprise"
      if @find_event_data[:today]
        events = Event.where("start_at <= ?", Date.tomorrow.midnight).near(@find_event_data[:address], 10)
      else
        events = Event.where("start_at > ?", Date.tomorrow.midnight).near(@find_event_data[:address], 10)
      end
    else
      activity = Activity.find_by(name: @find_event_data[:activity])
      if @find_event_data[:today]
        events = Event.where("start_at <= ? and activity_id =?", Date.today.midnight, activity).near(@find_event_data[:address], 10)
      else
        events = Event.where("start_at > ? and activity_id =?", Date.today.midnight, activity).near(@find_event_data[:address], 10)
      end
    end
    @bot_events_view.show_list(events, postback)
  end


  # Create Event

  def gets_day(postback)
    @bot_events_view.choose_now_or_later(postback)
  end

  def set_date_today(postback)
    @create_event_data[:date] = Date.today
  end

  def gets_date(postback)
    @bot_events_view.choose_date(postback)
  end

  def set_create_date(message)
    @create_event_data[:date] = Date.parse(message.text)
  end

  def gets_start_time(postback)
    @bot_events_view.choose_start_time(postback)
  end

  def set_start_time(message)
    @create_event_data[:start_time] = Time.parse(message.text)
  end

  def gets_end_time(message)
    @bot_events_view.choose_end_time(message)
  end

  def set_end_time(message)
    @create_event_data[:end_time] = Time.parse(message.text)
  end

  def gets_activity(message)
    @bot_events_view.full_activity_list(message)
  end

  def set_create_activity(postback)
    @create_event_data[:activity] = postback.payload.split.last
  end

  def gets_address(message)
    @bot_events_view.enter_address(message)
  end

  def set_create_address(message)
    @create_event_data[:address] = message.text
  end

  def create(message)
    d = @create_event_data[:date]
    st = @create_event_data[:start_time]
    et = @create_event_data[:end_time]
    @create_event_data[:start_at] = DateTime.new(d.year, d.month, d.day, st.hour, st.min)
    @create_event_data[:end_at] = DateTime.new(d.year, d.month, d.day, et.hour, et.min)
    activity = Activity.find_by(name: @create_event_data[:activity])
    Event.create(
      start_at: @create_event_data[:start_at],
      end_at: @create_event_data[:end_at],
      activity: activity,
      address: @create_event_data[:address],
      user: User.last
      )
  end
end
