class BotThreadsView

  def welcome_message(message)
    message.reply(
      text: "Welcome to Spotter. Hurrah, and thanks for joining us!  We hope you're feeling energetic 🏃🏋 ⛹"
    )

    message.type
  end

  def initial_choice(message)
    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: 'Are you looking to find an event, or to create a new one?',
          buttons: [
            { type: 'postback', title: 'Find an event', payload: 'FIND' },
            { type: 'postback', title: 'Create an event', payload: 'CREATE' }
          ]
        }
      }
    )
  end

  def location(postback)
    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: 'Where should your playground be?',
          buttons: [
            { type: 'postback', title: 'Send location', payload: 'find_location' },
            { type: 'postback', title: 'Type an address', payload: 'find_address' }
          ]
        }
      }
    )
  end

  def my_location(postback)
    postback.reply(
      text: 'Indicate your location',
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def address(postback)
    postback.reply(
      text: 'Please enter an address. To find the best spots, try to be a specific as possible 👍',
    )
  end

  def now_or_later(postback)
    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: 'When are you free?',
          buttons: [
            { type: 'postback', title: 'Today', payload: 'find_date_today' },
            { type: 'postback', title: 'Later', payload: 'find_date_later' }
          ]
        }
      }
    )
  end

  def activity_list(postback)
    postback.type
    postback.reply(
    text: "Choose an activity from the list below, or choose 'surprise me' if you're feeling adventurous..."
    )
    postback.type
    postback.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "generic",
          elements: [
            {
            title: "Running",
            image_url: "http://res.cloudinary.com/dcutvpvia/image/upload/v1480597493/running_bpszwu.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'find_activity Running' }
            ]},
            {
            title: "Swimming",
            image_url: "http://res.cloudinary.com/dcutvpvia/image/upload/v1480499835/swimming_dlditb.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'find_activity Swimming' }
            ]},
            {
            title: "Soccer",
            image_url: "http://res.cloudinary.com/dcutvpvia/image/upload/v1480454934/soccer_dmfmyq.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'find_activity Soccer' }
            ]},
            {
            title: "Tennis",
            image_url: "http://res.cloudinary.com/dcutvpvia/image/upload/v1480454973/tennis_qiusvb.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'find_activity Tennis' }
            ]},
            {
            title: "Surprise me",
            image_url: "http://res.cloudinary.com/dcutvpvia/image/upload/v1480454968/surprise-me_unlwon.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'find_activity  Surprise' }
            ]}
          ]
        }
      }
    )
  end
end
