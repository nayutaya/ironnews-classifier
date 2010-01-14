
# 2-gram解析器

require "nkf"

class BigramTokenizer
  def initialize
    # nop
  end

  def tokenize(document)
    text = document.dup

    # グリフの似たUnicode記号を置換する
    text.gsub!(/\xE2\x80\x94/, "-")  # EM DASH
    text.gsub!(/\xE3\x80\x9C/, "～") # WAVE DASH

    # 全角英数字を半角英数字に置換する（一部記号も含む）
    text = NKF.nkf("-W -w80 -m0 -Z1", text)

    # 英字を小文字に置換する
    text.downcase!

    # 文字種境界にスペースを挿入する
    text.gsub!(/([^a-z])([a-z])/,            '\1 \2') # 非アルファベット-アルファベット境界
    text.gsub!(/([a-z])([^a-z])/,            '\1 \2') # アルファベット-非アルファベット境界
    text.gsub!(/([^ァ-ヺー0-9])([ァ-ヺー])/, '\1 \2') # 非カタカナ-カタカナ境界
    text.gsub!(/([ァ-ヺー])([^ァ-ヺー])/,    '\1 \2') # 非カタカナ-カタカナ境界
    text.gsub!(/([^0-9])([0-9])/,            '\1 \2') # 非数字-数字境界

    # ひらがなをスペースに置換する
    text.gsub!(/[ぁ-ゞ]+/, " ")

    # 日本語記号をスペースに置換する
    text.gsub!(/[、。]/, " ")
    text.gsub!(/[・‥…]/, " ")
    text.gsub!(/[～]/, " ")
    text.gsub!(/[「」]/, " ")
    text.gsub!(/[【】]/, " ")
    text.gsub!(/[《》]/, " ")

    # ASCII記号をスペースに置換する（$%.は除く）
    text.gsub!(/[\x21-\x23]/, " ")
    text.gsub!(/[\x26-\x2D]/, " ")
    text.gsub!(/[\x2F]/,      " ")
    text.gsub!(/[\x3A-\x40]/, " ")
    text.gsub!(/[\x5B-\x60]/, " ")
    text.gsub!(/[\x7B-\x7E]/, " ")

    text.gsub!(/\s+/, " ")

    # 行頭と行末の空白文字を削除する
    text.strip!

    # 行頭と行末にスペースを付加する
    text = " #{text} "

    # 2-gramにより分割
    return text.scan(/\d+(?:\.\d+)?|./).
      enum_cons(2).
      map { |chars| chars.join("") }
  end
end
