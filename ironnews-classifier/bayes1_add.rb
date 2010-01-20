#! ruby -Ku

require "cgi"
require "open-uri"

url  = "http://localhost:8080/bayes1/add"
url += "?category=" + CGI.escape("鉄道")
url += "&body=" + CGI.escape("abAB")

open(url) { |io|
  p(io.read)
}
