#! ruby -Ku

require "yaml"
require "thread"
require "open-uri"
require "rubygems"
require "wsse"
require "json"

CREDENTIALS = YAML.load_file("ironnews.id")
USERNAME = "hatena_area"
PASSWORD = CREDENTIALS[USERNAME]

def get_area_untagged_articles(page)
  url  = "http://ironnews.nayutaya.jp/api/get_area_untagged_articles"
  url += "?per_page=100"
  url += "&page=#{page}"
  token = Wsse::UsernameToken.build(USERNAME, PASSWORD).format
  json = open(url, {"X-WSSE" => token}) { |io| io.read }
  return JSON.parse(json)
end

Thread.abort_on_exception = true
log_q = Queue.new

logging_thread = Thread.start {
  while message = log_q.pop
    STDERR.printf("[%s] %s\n", Time.now.strftime("%Y-%m-%d %H:%M:%S"), message)
  end
}

get_articles_thread = Thread.start {
  p get_area_untagged_articles(1)
}


gets
