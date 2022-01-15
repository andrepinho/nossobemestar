# Be sure to restart your server when you modify this file.

if Rails.env.production?
  Portal::Application.config.session_store :cookie_store, key: '_Portal_session', domain: "arquvinossobemestar.com"
else
  Portal::Application.config.session_store :cookie_store, key: '_Portal_session', domain: "lvh.me"
end
