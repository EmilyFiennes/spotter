class BotThreadsView

  def welcome_message(message)
    message.reply(
      text: "Welcome to Spotter. Hurrah, and thanks for joining us!  We hope you're feeling energetic 🏃🏋 ⛹",
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
            { type: 'postback', title: 'Search around me', payload: 'find_around_me' },
            { type: 'postback', title: 'Type an address', payload: 'find_address' }
          ]
        }
      }
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
    postback.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "generic",
          elements: [
            {
            title: "Running",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'find_activity Running' }
            ]},
            {
            title: "Swimming",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'find_activity Swimming' }
            ]},
            {
            title: "Soccer",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'find_activity Soccer' }
            ]},
            {
            title: "Tennis",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'find_activity Tennis' }
            ]},
            {
            title: "Surprise me",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'find_activity  Surprise' }
            ]}
          ]
        }
      }
    )
  end
end
