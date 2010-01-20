#! ruby -Ku

require "open-uri"

HOST = "localhost:8080"
#HOST = "ironnews-classifier1.appspot.com"

url = "http://#{HOST}/bayes1/train"

20.times {
  begin
    open(url) { |io| p(io.read) }
  rescue OpenURI::HTTPError => e
    p(e)
  end
}
