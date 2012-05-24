Rails.application.config.middleware.use OmniAuth::Builder do
  
  provider :facebook, FB_APP_ID, FB_APP_SECRET, :scope => 'publish_actions, user_actions.music, friends_actions.music, user_actions.news, friends_actions.news, user_actions.video, friends_actions.video, user_actions:lightyrs_cygni, friends_actions:lightyrs_cygni, publish_stream, offline_access, email, read_friendlists, read_mailbox, read_requests, read_stream, manage_notifications, rsvp_event, publish_checkins, manage_pages, ads_management, read_insights', :display => 'page'
  
  provider :twitter, TWITTER_KEY, TWITTER_SECRET
  
  provider :google_oauth2, GOOGLE_KEY, GOOGLE_SECRET, { access_type: 'online', approval_prompt: '' }

  provider :rdio, RDIO_KEY, RDIO_SECRET

  provider :github, GITHUB_KEY, GITHUB_SECRET

  provider :foursquare, FOURSQUARE_KEY, FOURSQUARE_SECRET

  provider :dropbox, DROPBOX_KEY, DROPBOX_SECRET

  provider :instagram, INSTAGRAM_KEY, INSTAGRAM_SECRET
end

OmniAuth.config.logger = Rails.logger
