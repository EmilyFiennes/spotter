class BotEventsView
  def initialize
    @bot_threads_view = BotThreadsView.new
  end

  def show_list(events, postback)
    event_elements = [];
    events.each do |event|
      event_elements << {
        title: "#{event.activity.name} with #{event.user.first_name}",
        subtitle: "#{event.description}, starting on #{event.start_at.strftime('%d-%m-%Y')} at #{event.start_at.strftime('%H:%M')}",
        # item_url: "",
        # image_url: "",
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

    if event_elements.present?
      postback.reply(
          text: "I didn't find what I'm looking for :-(",
          quick_replies: [
            content_type: "text",
            title: "Start again",
            payload:"start_again"
          ]
      )
    end
  end

  def create_now_or_later(postback)
    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: 'Do you want to create an event for today or later?',
          buttons: [
            { type: 'postback', title: 'Today', payload: 'choice_today' },
            { type: 'postback', title: 'Later', payload: 'choice_later' }
          ]
        }
      }
    )
  end

  def enter_date(postback)
    postback.reply(
      text: "Please enter the date of your activity e.g. 24/11/2016"
      )
  end

  def enter_start_time(postback)
    postback.reply(
      text: "Please enter the time your activity will start at eg. 17h30"
      )
  end

  def enter_end_time(postback)
    postback.reply(
      text: "Please enter the time your activity will end at e.g. 19h30")
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
              { type: 'postback', title: "Select", payload: 'activity_running' }
            ]},
            {
            title: "Swimming",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'activity_swimming' }
            ]},
            {
            title: "Soccer",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'activity_soccer' }
            ]},
            {
            title: "Tennis",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'activity_tennis' }
            ]},
            {
            title: "Surprise me",
            image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
            buttons: [
              { type: 'postback', title: "Select", payload: 'activity_suprise' }
            ]}
          ]
        }
      }
    )
  end
end
