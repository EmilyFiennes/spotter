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

    user_data_file = RestClient.get "https://graph.facebook.com/v2.6/me?fields=picture&access_token=#{ENV['FB-GRAPH-ACCESS-TOKEN']}"
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
end
