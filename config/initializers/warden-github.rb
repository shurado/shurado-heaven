require 'warden/github/rails'

Warden::GitHub::Rails.setup do |config|
  config.add_scope :user,  :client_id     => ENV['GITHUB_CLIENT_ID'],
                           :client_secret => ENV['GITHUB_CLIENT_SECRET'],
                           :scope         => ["read:org"]

  config.add_team :employees, ENV['GITHUB_TEAM_ID'] if ENV['GITHUB_TEAM_ID'].present?

  config.default_scope = :user
end
