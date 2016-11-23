class BotEventsView
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
