#!/usr/bin/env ruby

require 'uri'
require 'erb'
require 'bcrypt'
require 'fileutils'

install_dir="#{ENV["HOME"]}/#{ENV["GRAVITEE_MODULE"]}"
config_dir="#{ENV["HOME"]}/config"

if ENV["ELASTICSEARCH_URL"].nil?
  puts " !     ELASTICSEARCH_URL is required, have your provisioned an ElasticSeach addon?"
  exit 1
end

if ENV["POSTGRESQL_URL"].nil?
  puts " !     POSTGRESQL_URL is required, have your provisioned an PostgreSQL addon?"
  exit 1
end

@elasticsearch_url = URI(ENV["ELASTICSEARCH_URL"])

# jdbc:postgresql://localhost/test?user=fred&password=secret&ssl=true
# postgres://<user>:<password>@<host>:<port>/<database>?sslmode=prefer
uri = URI.parse(ENV["POSTGRESQL_URL"])

# see https://docs.ruby-lang.org/en/2.1.0/URI.html
@jdbc_url = "jdbc:postgresql://#{uri.host}:#{uri.port}#{uri.path}?#{uri.query}"
@jdbc_user = uri.user
@jdbc_pass = uri.password
@jdbc_max_size = ENV["POSTGRESQL_POOL_MAX_SIZE"].nil? ? 10 : ENV["POSTGRESQL_POOL_MAX_SIZE"]

@admin_password = BCrypt::Password.create(ENV["GRAVITEE_ADMIN_PASSWORD"])

# Optional configuration to send emails
@mail_url = URI(ENV["MAIL_URL"]) if ENV["MAIL_URL"]

logback_config = "#{config_dir}/logback.xml"
logback_config_install = "#{install_dir}/config/logback.xml"
FileUtils.cp logback_config, logback_config_install

gravitee_config_template = "#{config_dir}/gravitee.yml.erb"
gravitee_config_install = "#{install_dir}/config/gravitee.yml"
if File.exists? gravitee_config_template
  erb = ERB.new(File.read(gravitee_config_template))
  File.write(gravitee_config_install, erb.result)
end

if Dir.exists? "#{config_dir}/themes"
  puts "-----> Copying themes…"
  FileUtils.cp_r "#{config_dir}/themes", install_dir
end

if Dir.exists? "#{config_dir}/templates"
  puts "-----> Copying templates…"
  FileUtils.cp_r "#{config_dir}/templates", install_dir
end
