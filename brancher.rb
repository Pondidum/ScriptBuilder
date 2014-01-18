require 'yaml'

$config = YAML.load_file('config.yml')

def find_latest_deploy

	deploy_dir = File.join($config["generic"]["deploy_dir"], "")

	latest = Dir.entries(deploy_dir).sort.reverse[0]
	
	path = deploy_dir + latest

end

#Dir.entries(find_latest_deploy).each { |e| puts e }

def list_files_features

	deploy = find_latest_deploy + '/*.yml'

	Dir.glob(deploy) do |file|
		puts file
	end

end

list_files_features