require 'yaml'
require 'pp'

$config = YAML.load_file('config.yml')

def find_latest_deploy

  deploy_dir = File.join($config["generic"]["deploy_dir"], "")

  latest = Dir.entries(deploy_dir)
              .select { |e| File.directory?(File.join(deploy_dir, e)) }
              .sort
              .reverse
              .first

  path = deploy_dir + latest

end

def combine_feature_files(path)

  deploy = File.join(path, '*.yml')
  files = Dir.glob(deploy)

  combined = Hash.new

  combined[:pre] = Array.new
  combined[:sprocs] = Array.new
  combined[:post] = Array.new

  files.each do |e|

    feature = YAML.load_file(e).to_hash

    combined[:pre] += feature["pre"] if feature["pre"]
    combined[:sprocs] += feature["sprocs"] if feature["sprocs"]
    combined[:post] += feature["post"] if feature["post"]

  end

  return combined

end

def build_sql_file(masterfeature)

  db = $config["db"]

  base = db["root"]
  preRoot = File.join(base, db["pre_dir"])
  postRoot = File.join(base, db["post_dir"])

  output = StringIO.new
  output << "--Pre Scripts:\n"
  output << "--------------------------------------------------------------------------------\n"

  masterfeature[:pre].each { |file|

    output << IO.read(File.join(preRoot, file))
    output << "\n"

  }

  output << "--Sprocs Scripts:\n"
  output << "--------------------------------------------------------------------------------\n"

  masterfeature[:sprocs].each { |file|

    output << IO.read(File.join(base, file))
    output << "\n"

  }

  output << "--Post Scripts:\n"
  output << "--------------------------------------------------------------------------------\n"

  masterfeature[:post].each { |file|

    output << IO.read(File.join(postRoot, file))
    output << "\n"

  }

  return output.string

end

def write_to_output(path, contents)

  File.open(path + ".sql", "w") { |file|
    file.write(contents)
  }

end

latestDeploy = find_latest_deploy
masterfeature = combine_feature_files(latestDeploy)

contents = build_sql_file(masterfeature)

write_to_output(latestDeploy, contents)
