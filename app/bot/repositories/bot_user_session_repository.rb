class BotUserSessionRepository
  @@sessions = {}

  def self.find_or_create(session_id)
    unless @@sessions.has_key?(session_id)
      @@sessions[session_id] = BotUserSession.new
    end
    @@sessions[session_id]
  end

  def self.create(session_id)
    @@sessions[session_id] = BotUserSession.new
  end
end
