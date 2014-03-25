# Rails.application.config.middleware.use OmniAuth::Builder do
#   require 'openid/store/filesystem'
#   provider :github, ENV['40bbd64bef2e9cc37d18'], ENV['df4487e1d19746cbe669acf8acf0b6e033637327']
# end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '40bbd64bef2e9cc37d18', 'df4487e1d19746cbe669acf8acf0b6e033637327'
end