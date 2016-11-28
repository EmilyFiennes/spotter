class BotUserSessionRepository
  @@sessions = {}

  def self.find_or_create(message)
    unless @@sessions.has_key?(message.sender['id'])
      @@sessions[message.sender['id']] = BotUserSession.new(message)
    end
    @@sessions[message.sender['id']]
  end

  def self.create(message)
    @@sessions[message.sender['id']] = BotUserSession.new(message)
  end


end
