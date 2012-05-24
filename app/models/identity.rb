class Identity < ActiveRecord::Base

  belongs_to :user

  validates :provider, :presence => true
  validates :uid, :uniqueness => { :scope => :provider }, :presence => true

  attr_accessor :auth

  class << self

    def find_or_create_with_omniauth(auth)
      Rails.logger.debug(auth.inspect.cyan)
      if identity = Identity.find_with_omniauth(auth)
        identity.auth = auth
        identity.refresh_provider_data
      else
        identity = Identity.create_with_omniauth(auth)
      end

      identity
    end

    def find_with_omniauth(auth)
      Identity.find_by_provider_and_uid(auth['provider'], auth['uid'])
    end

    def create_with_omniauth(auth)
      identity = Identity.new(auth: auth, uid: auth['uid'], provider: auth['provider'])
      Rails.logger.debug(identity.inspect.cyan)
      if identity.set_provider_data!
        identity.save
        identity
      else
        identity.destroy
        false
      end
    end
  end

  def process_login(datetime)
    self.login_count = self.login_count += 1
    self.logged_in_at = datetime
    save
  end
  # handle_asynchronously :process_login

  def refresh_provider_data
    self.save if self.set_provider_data!
  end
  # handle_asynchronously :refresh_provider_data

  def set_provider_data!
    case auth['provider']
      when "facebook"
        facebook
      when "twitter"
        twitter
      when "google_oauth2"
        google
      when "rdio"
        rdio
      when "github"
        github
      when "dropbox"
        dropbox
      when "foursquare"
        foursquare
      when "instagram"
        instagram
      else
        false
    end
  end

  def facebook
    self.username = auth['info']['nickname'] rescue nil
    self.email = auth['info']['email'] rescue nil
    self.avatar = auth['info']['image'] rescue nil
    self.profile_url = auth['extra']['raw_info']['link'] rescue nil
    self.location = auth['info']['location'] rescue nil
    self.token = auth['credentials']['token'] rescue nil
  end

  def twitter
    self.username = auth['info']['nickname'] rescue nil
    self.avatar = auth['info']['image'] rescue nil
    self.profile_url = auth['info']['urls']['Twitter'] rescue nil
    self.location = auth['info']['location'] rescue nil
    self.bio = auth['info']['description'] rescue nil
  end

  def google
    self.email = auth['info']['email'] rescue nil
    self.avatar = auth['info']['image'] rescue nil
    self.profile_url = auth['extra']['raw_info']['link'] rescue nil
    google_plus
  end

  def google_plus
    profile = Curl::Easy.perform("https://www.googleapis.com/plus/v1/people/me?access_token=#{auth['credentials']['token']}")
    profile = JSON.parse(profile.body_str)

    self.username = profile['displayName'] rescue nil
    self.bio = profile['aboutMe'] rescue nil

    self.location = profile['placesLived'].select do |place|
      place.has_key?("primary") && place["primary"].to_s == "true"
    end.first["value"] rescue nil

  rescue StandardError => ex
    logger.error ex.message
    nil
  end

  def rdio
    self.username = auth['info']['nickname'] rescue nil
    self.avatar = auth['info']['image'] rescue nil
    self.profile_url = auth['info']['urls']['User']
  end

  def github
    self.username = auth['info']['nickname'] rescue nil
    self.avatar = auth['extra']['raw_info']['avatar_url'] rescue nil
    self.email = auth['info']['email'] rescue nil
    self.bio = auth['extra']['raw_info']['bio'] rescue nil
    self.profile_url = auth['info']['urls']['GitHub'] rescue nil
  end

  def dropbox
    self.email = auth['info']['email'] rescue nil
    self.location = auth['extra']['raw_info']['country'] rescue nil
  end

  def foursquare
    self.email = auth['info']['email'] rescue nil
    self.location = auth['info']['location'] rescue nil
    self.avatar = auth['info']['image'] rescue nil
  end

  def instagram
    self.username = auth['info']['nickname'] rescue nil
    self.avatar = auth['info']['image'] rescue nil
    self.bio = auth['info']['bio'] rescue nil
  end
end
