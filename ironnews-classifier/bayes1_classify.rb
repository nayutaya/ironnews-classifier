#! ruby -Ku

require "cgi"
require "open-uri"
require "rubygems"
require "json"

HOST = "localhost:8080"
#HOST = "ironnews-classifier1.appspot.com"

url  = "http://#{HOST}/bayes1/classify"
url += "?body=" + CGI.escape("「ＪＲ西歴代３社長起訴を」　脱線事故遺族、検察審に申し立て")

open(url) { |io| p(JSON.parse(io.read)) }
