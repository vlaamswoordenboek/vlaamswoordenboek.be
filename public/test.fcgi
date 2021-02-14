#!/usr/bin/ruby
require 'cgi'
require 'rubygems'
require_gem 'fcgi'

FCGI.each_cgi do |cgi|
   content = ''
   env = []
   cgi.env_table.each do |k,v|
     env << [k,v]
   end
   env.sort!
   env.each do |k,v|
     content << %Q(#{k} => #{v}<br>\n)
   end
   cgi.out{content}
end
