# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_seo_metaspring_session',
  :secret      => '8b9728846caeb68102892529663319f72f7b253e73a32ebeff447f10ca73678d7bc04c36f25040fdf4e157913a73ecd3c138e120d43a49f6acbdb5933f290039'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
