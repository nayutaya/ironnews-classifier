
require "pure_nkf"

class BayesOneTokenizer
  def initialize
    # nop
  end

  def preprocess(doc)
    text = doc.dup

    # 改行/タブを空白に置換する
    text.gsub!(/\s+/u, " ")

    # 全角英数字を半角英数字に置換する（一部記号も含む）
    text = PureNKF.convert_Z1(text)

    # 記号を置換する
    text.gsub!(/[\(\)]/u, " ")
    text.gsub!(/[\[\]]/u, " ")
    text.gsub!(/[<>]/u, " ")
    text.gsub!(/[:;=]/u, " ")
    text.gsub!(/[、。]/u, " ")
    text.gsub!(/[・‥…]/u, " ")
    text.gsub!(/[〔〕]/u, " ")
    text.gsub!(/[〘〙]/u, " ")
    text.gsub!(/[《》]/u, " ")
    text.gsub!(/[「」]/u, " ")
    text.gsub!(/[『』]/u, " ")
    text.gsub!(/[【】]/u, " ")
    text.gsub!(/[〖〗]/u, " ")

    # 連続した空白を単一の空白に置換する
    text.gsub!(/ +/u, " ")

    # 行頭と行末の空白と削除する
    text.strip!

    # 英字を小文字に置換する
    text.downcase!

    # 行頭と行末に空白を追加する
    text = " " + text + " "

    return text
  end

  def tokenize(document)
    return preprocess(document).scan(/\d+(?:\.\d+)?|./u).
      enum_cons(2).
      map { |chars| chars.join("") }
  end
end

if $0 == __FILE__
  require "facets"
  lines  = File.foreach("../../../ironnews-data/news_title/rail_xx.txt").map(&:strip)
  lines += File.foreach("../../../ironnews-data/news_title/rest_xx.txt").map(&:strip)
  tokenizer = BayesOneTokenizer.new
  infile  = File.open("in.txt", "wb")
  outfile = File.open("out.txt", "wb")
  lines.each { |line|
    infile.puts(line)
    outfile.puts(tokenizer.tokenize(line).join("/"))
  }
end
