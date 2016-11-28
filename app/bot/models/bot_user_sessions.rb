class BotUserSession
  attr_accessor :find_event_data, :create_event_data, :find_address_required,
                :create_date_required, :create_start_time_required,
                :create_end_time_required, :create_address_required,
                :create_max_participants_required, :create_event_description_required

  def initialize(message)
    user_identification(message)

    @find_event_data = {}
    @create_event_data = {}

    # Find event variables
    @find_address_required = false

    # Create event variable
    @create_date_required = false
    @create_start_time_required = false
    @create_end_time_required = false
    @create_address_required = false
    @create_max_participants_required = false
    @create_event_description_required = false
  end

  private

  def user_identification(message)
    user = User.find_by(messenger_id: message.sender['id'])
    if user.nil?
      user_data_file = RestClient.get "https://graph.facebook.com/v2.6/#{message.sender['id']}?access_token=#{ENV['ACCESS_TOKEN']}"
      user_data = JSON.parse(user_data_file)
      picture_stamp = user_data['profile_pic'].scan(/\d{8,}/).second
      user = User.where(picture_stamp: picture_stamp)
      if user.present?
        user.update(messenger_id: message.sender['id'])
      else
        user = User.new(
          first_name: user_data['first_name'],
          last_name: user_data['last_name'],
          gender: user_data['gender'],
          messenger_id: message.sender['id'],
          picture_stamp: picture_stamp
        )
        user.email = "#{message.sender['id']}@facebook.com"
        user.password = Devise.friendly_token[0,20]  # Fake password for validation
        user.save
      end
    end
  end

end
