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
        text: 'No one has created an event that matches your criteria 😢. Please choose another activity from the list below, or why not create a new event? You can select "Create an event" from the menu to the left of the text-input field.',
      )
      @bot_threads_view.activity_list(postback)
    else
      event_elements << {
        title: "I didn't find what I'm looking for 😢 ",
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
          text: 'Do you want to create an event for today or a later date?',
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
      text: "Please enter the date of your event e.g. #{ Date.today.strftime('%d/%m/%Y') }"
      )
  end

  def choose_start_time(postback)
    postback.reply(
      text: "Please enter the time your activity will start at eg. 17:30"
      )
  end

  def choose_later_start_date(postback)
    postback.reply(
      text: "Oops, it looks like that date has come and gone. Try choosing a new date."
      )
  end


  def choose_end_time(postback)
    postback.reply(
      text: "Please enter the time your activity will end at e.g. 19:30"
      )
  end

  def enter_address(postback)
    postback.reply(
      text: "Please enter an address for your activity. This can be the meeting point. Alternatively, you'll be able to add specific details to the event description in just a jiffy. Be a specific as possible 😉."
      )
  end

  def full_list_1(postback)
    postback.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "list",
          top_element_style: "compact",
          elements: [
            {
              title: "Running",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Swimming",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Soccer",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Tennis",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            }
          ],
          buttons: [
            {
              title: "view more",
              type: "postback",
              payload: "view_more_activities_2"
            }
          ]
        }
      }
    )
  end

  def full_list_2(postback)
    postback.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "list",
          top_element_style: "compact",
          elements: [
            {
              title: "Bowling",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Rugby",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Petanque",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Badminton",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            }
          ],
          buttons: [
            {
              title: "view more",
              type: "postback",
              payload: "view_more_activities_3"
            }
          ]
        }
      }
    )
  end

  def full_list_3(postback)
    postback.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "list",
          top_element_style: "compact",
          elements: [
            {
              title: "Baksetball",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Biking",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Climbing",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Golf",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            }
          ],
          buttons: [
            {
              title: "view more",
              type: "postback",
              payload: "view_more_activities_4"
            }
          ]
        }
      }
    )
  end

  def full_list_4(postback)
    postback.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "list",
          top_element_style: "compact",
          elements: [
            {
              title: "Hiking",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Roller",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Squash",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Surfing",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            }
          ],
          buttons: [
            {
              title: "view more",
              type: "postback",
              payload: "view_more_activities_5"
            }
          ]
        }
      }
    )
  end

  def full_list_5(postback)
    postback.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "list",
          top_element_style: "compact",
          elements: [
            {
              title: "Skating",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Volley",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Workout",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            },
            {
              title: "Skiing",
              image_url: "https://conceptdraw.com/a2327c3/p13/preview/640/pict--running-man-people-pictograms---vector-stencils-library.png--diagram-flowchart-example.png",
              buttons: [
                { type: 'postback', title: "Select", payload: 'choose_activity Running' }
              ]
            }
          ],
          buttons: [
            {
              title: "See all sports again",
              type: "postback",
              payload: "view_more_activities_1"
            }
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

  # def testing(postback)
  #   postback.reply(
  #     attachment: {
  #       type: 'template',
  #       payload: {
  #         template_type: 'button',
  #         text: 'Would you like to enter a description?',
  #         buttons: [
  #           { type: 'postback', title: 'Yes', payload: 'yes' },
  #           { type: 'postback', title: 'No', payload: 'no' }
  #         ]
  #       }
  #     }
  #   )
  # end


end
