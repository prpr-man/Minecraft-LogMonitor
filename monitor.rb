# coding: utf-8
require 'yaml'
require 'net/https'
require 'watchr'

Process.daemon

begin
  path = File.expand_path(File.dirname(__FILE__))
  SETTINGS = YAML::load(open(path+"/info.conf"))
rescue
  puts "Config file load failed."
  exit
end

TOKEN = SETTINGS["token"]
USER = SETTINGS["user"]

url = URI.parse("https://api.pushover.net/1/messages.json")
req = Net::HTTP::Post.new(url.path)
res = Net::HTTP.new(url.host, url.port)
res.use_ssl = true
res.verify_mode = OpenSSL::SSL::VERIFY_PEER

previent = `cat #{path}/logs/latest.log`.chomp
# watchr 絶対パス読んでくれないっぽい
watch 'minecraft/logs/latest.log' do |m|
  current = `cat #{path}/logs/latest.log`.chomp
  if previent.length >= current.length then
    diff = current
  else
    diff = current.slice(previent.length, current.length-1)
  end
  previent = current  

  diff.each_line do |line|
    if line.include?("WARN") || line.include?("ERROR") then
      priority = line.include?("ERROR") ? 1 : -1
      line.slice!(0, line.rindex(":")+2)
      req.set_form_data({
        :token => TOKEN,
        :user => USER,
        :message => line,
        :title => "Minecraft Alert",
        :priority => priority,
        :device => "iPhone"
      })
      res.start {|http| http.request(req)}
    end
  end  
end

