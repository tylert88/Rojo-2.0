# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# The code opens the config/local_env.yml file, reads each key/value pair,
# and sets environment variables.
config.before_configuration do
  env_file = File.join(Rails.root, 'config', 'local_env.yml')
  YAML.load(File.open(env_file)).each do |key, value|
    ENV[key.to_s] = value
  end if File.exists?(env_file)
end
