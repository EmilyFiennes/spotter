class BotThreadsView
  def welcome_message(message)
    message.reply(
      text: 'Welcome to Spotter.',
    )
    message.type
  end

  def initial_choice(message)
    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: 'What do you want to do?',
          buttons: [
            { type: 'postback', title: 'Find an event', payload: 'FIND' },
            { type: 'postback', title: 'Create an event', payload: 'CREATE' }
          ]
        }
      }
    )
  end
end
