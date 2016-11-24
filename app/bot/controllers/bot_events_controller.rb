class BotEventsController
  def initialize
    @bot_events_view = BotEventsView.new
  end

   def index(postback)
    if @events_activity == "All"
      if @event_today
        events = Event.where("start_at <= ?", Date.tomorrow.midnight).near(@events_address, 10)
      else
        events = Event.where("start_at > ?", Date.tomorrow.midnight).near(@events_address, 10)
      end
    else
      activity = Activity.find_by(name: @events_activity)
      if @event_today
        events = Event.where("start_at <= ? and activity_id =?", Date.today.midnight, activity).near(@events_address, 10)
      else
        events = Event.where("start_at > ? and activity_id =?", Date.today.midnight, activity).near(@events_address, 10)
      end
    end
    @bot_events_view.show_list(events, postback)
  end

  def new(postback)
  end

  def gets_address(postback)
    @bot_events_view.address(postback)
  end

  def set_address_around_me(message)
    @events_address = "Bordeaux, France"
  end

  def set_address(message)
    @events_address = message.text
  end

  def set_date(postback)
    if postback.payload ==  'date_today'
      @event_today = true
    elsif postback.payload ==  'date_later'
      @event_today = false
    end
  end

  def set_activity(postback)
    case postback.payload
    when 'activity_running'
      @events_activity = "Running"
    when 'activity_swimming'
      @events_activity = "Swimming"
    when 'activity_soccer'
      @events_activity = "Soccer"
    when 'activity_tennis'
      @events_activity = "Tennis"
    when 'activity_suprise'
      @events_activity = "All"
    end
  end

  def gets_day(postback)
    @bot_events_view.create_now_or_later(postback)
  end

  def set_create_date(postback)
    if postback.payload == 'choice_today'
      @new_event_date = Date.today
    elsif postback.payload == 'choice_later'
      @bot_events_view.enter_date(postback)
    end
  end

  def gets_start_time(message)
    @bot_events_view.enter_start_time(message)
  end

  def gets_end_time(message)
    @bot_events_view.enter_end_time(message)
  end

  def gets_activity(message)
    @bot_events_view.full_activity_list(message)
  end
end
