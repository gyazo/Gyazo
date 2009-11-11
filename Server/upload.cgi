#!/usr/bin/env ruby
# -*- ruby -*-
#
# $Date$
# $Rev$
#
require 'cgi'
require 'digest/md5'
require 'sdbm'

cgi = CGI.new("html3")

id = cgi.params['id'][0].read
imagedata = cgi.params['imagedata'][0].read
hash = Digest::MD5.new(imagedata).to_s

dbm = SDBM.open('db/id',0644)
dbm[hash] = id
dbm.close

File.open("data/#{hash}.png","w").print(imagedata)

cgi.out { "http://gyazo.com/#{hash}.png" }
