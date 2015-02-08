#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
require 'net/http'
require 'net/https'
require 'tmpdir'
require 'uri'

GEMSERVER = "http://rubygems.org"

# inspect Gemfile.lock
lockfile = Bundler::LockfileParser.new(Bundler.read_file("Gemfile.lock"))

to_mirror = {}

uri = URI(GEMSERVER)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = uri.scheme == 'https'

requirements = []

lockfile.specs.each do |s|
  possible_gem_name = "#{s.name}-#{s.version.to_s}.gem"
  Dir.mktmpdir do |tmpdir|
    Dir.chdir tmpdir do
      filename = `gem fetch #{s.name} -v #{s.version.to_s}`.split()[1]
      sha256 = `sha256sum #{filename}.gem`
      url = "#{GEMSERVER}/downloads/#{filename}.gem"
      puts url
      requirements << {
        :name => s.name,
        :version => s.version.to_s,
        :sha256 => sha256.split().first,
        :url => url,
      }
    end
  end
end

File.open('Gemfile.nix', 'w') do |file|
  file.puts '['
  requirements.each do |r|
    file.puts <<-EOF
  {
    name = "#{r[:name]}";
    version = "#{r[:version]}";
    url = "#{r[:url]}";
    sha256 = "#{r[:sha256]}";
  }
    EOF
  end
  file.puts ']'
end
