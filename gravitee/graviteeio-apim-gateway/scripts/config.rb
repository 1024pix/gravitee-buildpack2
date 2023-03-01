#!/usr/bin/env ruby
#
require 'uri'
require 'erb'
require 'fileutils'
require 'net/http'

install_dir="#{ENV["HOME"]}/#{ENV["GRAVITEE_MODULE"]}"
config_dir="#{ENV["HOME"]}/config"

if ENV["ELASTICSEARCH_URL"].nil?
  puts " !     ELASTICSEARCH_URL is required, have your provisioned an ElasticSeach addon?"
  exit 1
end

if ENV["MONGO_URL"].nil?
  puts " !     MONGO_URL is required, have your provisioned an MongoDB addon?"
  exit 1
end

@elasticsearch_url = URI(ENV["ELASTICSEARCH_URL"])

@jdbc_url = ENV["JDBC_URL"]
@jdbc_username = ENV["JDBC_USERNAME"]
@jdbc_password = ENV["JDBC_PASSWORD"]

# Optional configuration to enable gateway heartbeat
@heartbeat_enabled = ENV.fetch("GRAVITEE_HEARTBEAT_ENABLED", "false") == "true"

gravitee_config_template = "#{config_dir}/gravitee.yml.erb"
gravitee_config_install = "#{install_dir}/config/gravitee.yml"
if File.exists? gravitee_config_template
  erb = ERB.new(File.read(gravitee_config_template))
  File.write(gravitee_config_install, erb.result)
end

logback_config = "#{config_dir}/logback.xml"
logback_config_install = "#{install_dir}/config/logback.xml"
FileUtils.cp logback_config, logback_config_install

def es_put(uri, body, &block)
  Net::HTTP.start(uri.host, uri.port) do |http|
    request = Net::HTTP::Put.new(uri)
    request.basic_auth uri.user, uri.password
    request['Content-Type'] = 'application/json'
    http.request(request, body, &block)
  end
end

elastic_search_ilm_policies = Dir.glob("#{config_dir}/elasticsearch_ilm_policies/*.json")
elastic_search_ilm_policies.each do |policy_path|
  policy_name = File.basename(policy_path, ".json")
  puts "Uploading ILM policy to ElasticSearch #{policy_name}"
  uri = URI("#{ENV["ELASTICSEARCH_URL"]}/_ilm/policy/#{policy_name}")
  es_put(uri, File.read(policy_path)) do |response|
    if response.code == "200"
      puts "Policy #{policy_name} updated"
    else
      puts "Policy #{policy_name} error #{response.code} #{response.body}"
      exit 1
    end
  end
end
