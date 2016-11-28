class BotParticipationsController

  def create_participation(response)
    user = current_user(response)
    user.session[:step] = "participation"
    event = Event.find(response.payload.split.last.to_i)
    Participation.create(user: user, event: event)
    event.available = false if event.participants.count >= max_participants
  end

  private

  def current_user(response)
    User.find_by(messenger_id: response.sender['id'])
  end
end
