require 'yaml'

config = YAML.load_file('config.yml')

puts config.inspect
