class BotEventsController
  def initialize
    @bot_events_view = BotEventsView.new
  end

  # Find Event
  def set_find_date(response)
    user = current_user(response)
    if response.payload ==  'find_date_today'
      user.session['find_event_data']['today'] = true
    elsif response.payload ==  'find_date_later'
      user.session['find_event_data']['today'] = false
    end
    user.save
  end

  def set_find_activity(response)
    user = current_user(response)
    user.session['find_event_data']['activity_name'] = response.payload.split.last
    user.save
  end

  def set_location(response)
    user = current_user(response)
    user.session['find_event_data']['lat'] = response.attachments.first['payload']['coordinates']['lat']
    user.session['find_event_data']['long'] = response.attachments.first['payload']['coordinates']['long']
    user.save
  end

  def set_address(response)
    user = current_user(response)
    user.session['find_event_data']['address'] = response.text
    user.save
  end

  def index(response)
    user = current_user(response)
    unless user.session['find_event_data']['address'].nil?
      position = user.session['find_event_data']['address']
    else
      position = [user.session['find_event_data']['lat'], user.session['find_event_data']['long']]
    end
    midnight = Date.tomorrow.midnight
    if user.session['find_event_data']['activity_name'] == "Surprise"
      if user.session['find_event_data']['today']
        events = Event.where("start_at <= ? and available = ?", midnight, true).near(position, 10)
      else
        events = Event.where("start_at > ? and available = ?", midnight, true).near(position, 10)
      end
    else
      activity = Activity.find_by(name: user.session['find_event_data']['activity_name'])
      if user.session['find_event_data']['today']
        events = Event.where("start_at <= ? and activity_id = ? and available = ?", midnight, activity, true).near(position, 10)
      else
        events = Event.where("start_at > ? and activity_id = ? and available = ?", midnight, activity, true).near(position, 10)
      end
    end
    user.save
    @bot_events_view.show_list(events, response)
  end

  def show_participation(response)
    event = Event.find(response.payload.split.last.to_i)
    @bot_events_view.show_participation(response, event)
  end


  # Create Event

  def gets_day(response)
    user = current_user(response)
    user.session['step'] = "choose_create_date"
    user.save
    @bot_events_view.choose_now_or_later(response)
  end

  def set_date_today(response)
    user = current_user(response)
    user.session['create_event_data']['date'] = Date.today
    user.save
  end

  def gets_date(response)
    user = current_user(response)
    user.session['step'] = "enter_create_date"
    user.save
    @bot_events_view.choose_date(response)
  end

  def set_create_date(response)
    user = current_user(response)
    date = Time.parse(response.text)
    if date < Date.today
      @bot_events_view.choose_later_start_date(response)
      return false
    else
      user.session['create_event_data']['date'] = Date.parse(response.text)
      user.save
      return true
    end
  end

  def gets_start_time(response)
    user = current_user(response)
    user.session['step'] = "enter_start_time"
    user.save
    @bot_events_view.choose_start_time(response)
  end

  def set_start_time(response)
    user = current_user(response)
    user.session['create_event_data']['start_time'] = Time.parse(response.text)
    user.save
  end

  def gets_end_time(response)
    user = current_user(response)
    user.session['step'] = "enter_end_time"
    user.save
    @bot_events_view.choose_end_time(response)
  end

  def set_end_time(response)
    user = current_user(response)
    start_time = user.session['create_event_data']['start_time']
    end_time = Time.parse(response.text)
    if start_time >= end_time
      @bot_events_view.choose_later_end_time(response)
      return false
    else
      user.session['create_event_data']['end_time'] = Time.parse(response.text)
      user.save
      return true
    end
  end

  def gets_activity_1(response)
    user = current_user(response)
    user.session['step'] = "choose_create_activity"
    user.save
    @bot_events_view.full_list_1(response)
  end

  def gets_activity_2(response)
    @bot_events_view.full_list_2(response)
  end

  def gets_activity_3(response)
    @bot_events_view.full_list_3(response)
  end

  def gets_activity_4(response)
    @bot_events_view.full_list_4(response)
  end

  def gets_activity_5(response)
    @bot_events_view.full_list_5(response)
  end

  def set_create_activity(response)
    user = current_user(response)
    user.session['create_event_data']['activity_name'] = response.payload.split.last
    user.save
  end

  def gets_address(response)
    user = current_user(response)
    user.session['step'] = "enter_create_address"
    user.save
    @bot_events_view.enter_address(response)
  end

  def set_create_address(response)
    user = current_user(response)
    user.session['create_event_data']['address'] = response.text
    user.save
  end

  def gets_level(response)
    user = current_user(response)
    user.session['step'] = "choose_create_level"
    user.save
    @bot_events_view.choose_level(response)
  end

  def set_level(response)
    user = current_user(response)
    user.session['create_event_data']['level'] = response.payload.split.last
    user.save
  end

  def gets_max_participants(response)
    user = current_user(response)
    user.session['step'] = "enter_max_participants"
    user.save
    @bot_events_view.enter_max_participants(response)
  end

  def set_max_participants(response)
    user = current_user(response)
    user.session['create_event_data']['max_participants'] = response.text.to_i
    user.save
  end

  def gets_event_description(response)
    user = current_user(response)
    user.session['step'] = "enter_description"
    user.save
    @bot_events_view.enter_event_description(response)
  end

  def set_event_description(response)
    user = current_user(response)
    user.session['create_event_data']['description'] = response.text
    user.save
  end

  def create(response)
    user = current_user(response)
    d = DateTime.parse(user.session['create_event_data']['date'])
    st = DateTime.parse(user.session['create_event_data']['start_time'])
    et = DateTime.parse(user.session['create_event_data']['end_time'])
    start_at = DateTime.new(d.year, d.month, d.day, st.hour, st.min)
    end_at = DateTime.new(d.year, d.month, d.day, et.hour, et.min)
    activity = Activity.find_by(name: user.session['create_event_data']['activity_name'])
    Event.create(
      start_at: start_at,
      end_at: end_at,
      activity: activity,
      address: user.session['create_event_data']['address'],
      level: user.session['create_event_data']['level'],
      max_participants: user.session['create_event_data']['max_participants'],
      description: user.session['create_event_data']['description'],
      user: user
      )
  end

  def show_event(response)
# TO DO
  end

  private

  def current_user(response)
    User.find_by(messenger_id: response.sender['id'])
  end
end
