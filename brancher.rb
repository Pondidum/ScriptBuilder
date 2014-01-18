require 'yaml'

$config = YAML.load_file('config.yml')

def find_latest_deploy

	deploy_dir = $config["generic"]["deploy_dir"] + '/'

	latest = Dir.entries(deploy_dir).sort.reverse[0]
	
	path = deploy_dir + latest

end
