class BotEventsView

  def initialize
    @bot_threads_view = BotThreadsView.new
  end

  # Find an event

  def show_list(events, postback)
    event_elements = [];
    events.each do |event|
      event_elements << {
        title: "#{event.activity.name} with #{event.user.first_name}",
        subtitle: "#{event.description}, starting on #{event.start_at.strftime('%d-%m-%Y')} at #{event.start_at.strftime('%H:%M')}",
        image_url: "https://maps.googleapis.com/maps/api/staticmap?&zoom=13&size=500x300&maptype=roadmap&markers=color:red%7Clabel:C%7C#{event.latitude},#{event.longitude}&key=#{ENV['GOOGLE_API_BROWSER_KEY']}",
        buttons: [
          { type: 'postback', title: "Participate", payload: "PARTICIPATE_#{event.id}" }
        ]
      }
    end

    if event_elements.empty?
      postback.reply(
        text: 'No event found. Please choose again',
      )
      @bot_threads_view.activity_list(postback)
    else
      event_elements << {
        title: "I didn't find what I'm looking for :-(",
        buttons: [
          { type: 'postback', title: "Start again", payload: "start_again" }
        ]
      }

      postback.reply(
        attachment: {
          type: "template",
          payload: {
            template_type: "generic",
            elements: event_elements
          }
        }
      )
    end
  end


  # Create an event

  def choose_now_or_later(postback)
    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: 'Do you want to create an event for today or later?',
          buttons: [
            { type: 'postback', title: 'Today', payload: 'choose_date_today' },
            { type: 'postback', title: 'Later', payload: 'choose_date_later' }
          ]
        }
      }
    )
  end

  def choose_date(postback)
    postback.reply(
      text: "Please enter the date of your activity e.g. 24/11/2016"
      )
  end

  def choose_start_time(postback)
    postback.reply(
      text: "Please enter the time your activity will start at eg. 17:30"
      )
  end

  def choose_end_time(postback)
    postback.reply(
      text: "Please enter the time your activity will end at e.g. 19:30"
      )
  end

  def enter_address(postback)
    postback.reply(
      text: "Please enter an address for your activity"
      )
  end

  def full_activity_list(postback)
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
              { type: 'postback', title: "Select", payload: 'choose_activity Running' }
            ]},
            {
            title: "Swimming",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'choose_activity Swimming' }
            ]},
            {
            title: "Soccer",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'choose_activity Soccer' }
            ]},
            {
            title: "Tennis",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'choose_activity Tennis' }
            ]},
            {
            title: "Bowling",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'choose_activity Bowling' }
            ]},
            {
            title: "Rugby",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'choose_activity Rugby' }
            ]},
            {
            title: "Bowling",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'choose_activity Bowling' }
            ]},
            {
            title: "Petanque",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'choose_activity Petanque' }
            ]},
            {
            title: "Badminton",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'choose_activity Badminton' }
            ]},
            # {
            # title: "Basketball",
            # image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            # buttons: [
            #   { type: 'postback', title: "Select", payload: 'choose_activity Basketball' }
            # ]},
            # {
            # title: "Biking",
            # image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            # buttons: [
            #   { type: 'postback', title: "Select", payload: 'choose_activity Biking' }
            # ]},
            # {
            # title: "Climbing",
            # image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            # buttons: [
            #   { type: 'postback', title: "Select", payload: 'choose_activity Climbing' }
            # ]},
            # {
            # title: "Golf",
            # image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            # buttons: [
            #   { type: 'postback', title: "Select", payload: 'choose_activity Golf' }
            # ]},
            # {
            # title: "Hiking",
            # image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            # buttons: [
            #   { type: 'postback', title: "Select", payload: 'choose_activity Hiking' }
            # ]},
            # {
            # title: "Roller",
            # image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            # buttons: [
            #   { type: 'postback', title: "Select", payload: 'choose_activity Roller' }
            # ]},
            # {
            # title: "Squash",
            # image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            # buttons: [
            #   { type: 'postback', title: "Select", payload: 'choose_activity Squash' }
            # ]},
            # {
            # title: "Surfing",
            # image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            # buttons: [
            #   { type: 'postback', title: "Select", payload: 'choose_activity Surfing' }
            # ]},
            # {
            # title: "Skating",
            # image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            # buttons: [
            #   { type: 'postback', title: "Select", payload: 'choose_activity Skating' }
            # ]},
            # {
            # title: "Volley",
            # image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            # buttons: [
            #   { type: 'postback', title: "Select", payload: 'choose_activity Volley' }
            # ]},
            # {
            # title: "Workout",
            # image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            # buttons: [
            #   { type: 'postback', title: "Select", payload: 'choose_activity Workout' }
            # ]},
            # {
            # title: "Skiing",
            # image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            # buttons: [
            #   { type: 'postback', title: "Select", payload: 'choose_activity Skiing' }
            # ]}
          ]
        }
      }
    )
  end

  def choose_level(postback)
    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: 'Who is this event for?',
          buttons: [
            { type: 'postback', title: 'Newbies', payload: 'choose_level Newbie' },
            { type: 'postback', title: 'Intermediates', payload: 'choose_level Intermediate' },
            { type: 'postback', title: 'Champions', payload: 'choose_level Champion' }
          ]
        }
      }
    )
  end

  def enter_max_participants(postback)
    postback.reply(
      text: "How many spots are there?"
      )
  end

  def enter_event_description(postback)
    postback.reply(
      text: "Give your event a great tagline and get filling those spots!"
      )
  end
end
