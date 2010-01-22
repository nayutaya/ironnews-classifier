#! ruby -Ku

# Google App Engine上の単純ベイズ分類器で学習を行う

require "uri"
require "net/http"

uri = URI.parse("http://ironnews-classifier1.appspot.com/bayes1/train")

Net::HTTP.start(uri.host, uri.port) { |http|
  loop {
    response = http.get(uri.path)
    STDERR.puts(Time.now.strftime("%H:%M:%S") + " " + response.code)
    sleep(2)
  }
}
