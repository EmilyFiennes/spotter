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
        image_url: "https://maps.googleapis.com/maps/api/staticmap?zoom=13&size=600x300&maptype=roadmap
          &markers=color:red%7C#{event.latitude},#{event.longitude}
          &key=#{ENV['GOOGLE_API_BROWSER_KEY']}",
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
end
