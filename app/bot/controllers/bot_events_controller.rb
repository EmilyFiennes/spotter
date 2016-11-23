class BotEventsController
  def initialize
    @bot_events_view = BotEventsView.new
  end

  # def index(postback)
  #   if @events_activity == "All"
  #     if @event_today
  #       events = Event.where(start_at = DateToday)
  #     else
  #       events = Event.where(start_at > DateToday)
  #     end
  #   else
  #     activity = Activity.find_by(name: @events_activity)
  #     if @event_today
  #       events = Event.where(activity: activity, start_at = DateToday)
  #     else
  #       events = Event.where(activity: activity, start_at > DateToday)
  #     end
  #   end
  #   @bot_events_view.show_list(events, postback)
  # end

  def new(postback)
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
end
