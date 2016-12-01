class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :events
  has_many :participations, dependent: :destroy
  has_many :participating_events, through: :participations, source: :event # les évènements auxquels tu t'es inscrit
  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.find_for_facebook_oauth(auth)
    user_params = auth.to_h.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at) rescue Time.now + 1000.days
    user_params[:gender] = auth.extra.raw_info.gender
    raise

    user_data_file = RestClient.get "https://graph.facebook.com/v2.8/me?fields=picture&access_token=#{ENV['FB_GRAPH_ACCESS_TOKEN']}"
    user_data = JSON.parse(user_data_file)
    user_params[:picture_stamp] = user_data['picture']['data']['url'].scan(/\d{8,}/).second


    user = User.where(provider: auth.provider, uid: auth.uid).first
    user = User.where(picture_stamp: user_params[:picture_stamp]).first
    user ||= User.where(email: auth.info.email).first # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end

    return user
  end

  def self.messenger_identification(message)
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
    user
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def display_name
    full_name.gsub(/\s+.+\s+/, " ").sub(/(?<=\s\S).+/, ".")
  end
end
