require 'httparty'
require 'dotenv'

Dotenv.load

USERNAME = ENV["MONITOR_USERNAME"]
TOKEN = ENV["MONITOR_TOKEN"]

class JenkinsClient
  def all_jobs_from pipeline
    auth = {username: USERNAME, password: TOKEN}
    jenkins_base_url = url(pipeline)
    puts jenkins_base_url

    response = HTTParty.get(jenkins_base_url, basic_auth: auth).body
    JSON.parse(response)
  end

  private

  def url pipeline
    if pipeline.fetch("folder") {false}
      root_url = "#{pipeline['root_url']}/job/#{pipeline.fetch("folder")}/api/json"
    else
      root_url = "#{pipeline['root_url']}/api/json"
    end
    URI.escape "#{root_url}?tree=jobs[name,upstreamProjects[name,nextBuildNumber],lastBuild[building],lastCompletedBuild[number,duration,timestamp,result]]"

  end

end
