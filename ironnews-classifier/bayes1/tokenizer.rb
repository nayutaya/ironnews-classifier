
require "pure_nkf"

class BayesOneTokenizer
  def initialize
    # nop
  end

  def preprocess(doc)
    text = doc.dup

    # 改行/タブを空白に置換する
    text.gsub!(/[\r\n\t]/u, " ")

    # 全角英数字を半角英数字に置換する（一部記号も含む）
    #text = NKF.nkf("-W -w80 -m0 -Z1", text)
    text = PureNKF.convert_Z1(text)

    # 連続した空白を単一の空白に置換する
    text.gsub!(/ {2,}/u, " ")

    # 行頭と行末の空白と削除する
    text.strip!

    # 英字を小文字に置換する
    text.downcase!

    # 記号を置換する
    text.gsub!(/【/u, "<")
    text.gsub!(/】/u, ">")
    text.gsub!(/《/u, "<")
    text.gsub!(/》/u, ">")

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
