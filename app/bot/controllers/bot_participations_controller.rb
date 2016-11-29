class BotParticipationsController

  def initialize
    @bot_events_view = BotEventsView.new
  end

  def confirm_participation(response)
    event = Event.find(response.payload.split.last.to_i)
    @bot_events_view.ask_confirm_participation(response, event)
  end


  def create_participation(response)
    user = current_user(response)
    event = Event.find(response.payload.split.last.to_i)
    Participation.create(user: user, event: event)
    event.available = false if event.participants.count >= event.max_participants
    event.save
  end

  private

  def current_user(response)
    User.find_by(messenger_id: response.sender['id'])
  end
end
