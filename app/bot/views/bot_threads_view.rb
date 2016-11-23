class BotThreadsView
  include ActionView::Helpers
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::AssetUrlHelper

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

  def now_or_later(postback)
    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: 'Are you looking for an event today or later?',
          buttons: [
            { type: 'postback', title: 'Today', payload: 'date_today' },
            { type: 'postback', title: 'Later', payload: 'date_later' }
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
