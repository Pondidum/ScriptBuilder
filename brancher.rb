require 'yaml'
require 'pp'

$config = YAML.load_file('config.yml')

def find_latest_deploy

  deploy_dir = File.join($config["generic"]["deploy_dir"], "")

  latest = Dir.entries(deploy_dir).sort.reverse[0]

  path = deploy_dir + latest

end

def combine_config_files(path)

  deploy = File.join(path, '*.yml')
  files = Dir.glob(deploy)

  combined = Hash.new

  combined[:pre] = Array.new
  combined[:sprocs] = Array.new
  combined[:post] = Array.new

  files.each do |e|

    feature = YAML.load_file(e).to_hash

    combined[:pre] += feature["pre"]
    combined[:sprocs] += feature["sprocs"]
    combined[:post] += feature["post"] unless feature["post"] == nil

  end

  pp combined

end

combine_config_files(find_latest_deploy)
