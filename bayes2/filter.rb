#! ruby -Ku

require "nkf"

File.open("out.txt", "wb") { |file|
  File.foreach("in.txt") { |line|
    line.chomp

    line.gsub!(/\xE2\x80\x94/, "-")  # EM DASH
    line.gsub!(/\xE3\x80\x9C/, "～") # WAVE DASH

    line = NKF.nkf("-W -w80 -m0 -Z1", line)
    line.downcase!

    line.gsub!(/([^a-z])([a-z])/, '\1 \2') # 非アルファベット-アルファベット境界にスペースを挿入
    line.gsub!(/([a-z])([^a-z])/, '\1 \2') # アルファベット-非アルファベット境界にスペースを挿入
    line.gsub!(/([^ァ-ヺー0-9])([ァ-ヺー])/, '\1 \2') # 非カタカナ-カタカナ境界にスペースを挿入
    line.gsub!(/([ァ-ヺー])([^ァ-ヺー])/, '\1 \2')    # 非カタカナ-カタカナ境界にスペースを挿入
    line.gsub!(/([^0-9])([0-9])/, '\1 \2') # 非数字-数字境界にスペースを挿入

    line.gsub!(/[ぁ-ゞ]+/, " ")
    line.gsub!(/[、。]/, " ")
    line.gsub!(/[・‥…]/, " ")
    line.gsub!(/[～]/, " ")
    line.gsub!(/[「」]/, " ")
    line.gsub!(/[【】]/, " ")
    line.gsub!(/[\x21-\x23]/, " ")
    line.gsub!(/[\x26-\x2F]/, " ")
    line.gsub!(/[\x3A-\x40]/, " ")
    line.gsub!(/[\x5C-\x60]/, " ")
    line.gsub!(/[\x7B-\x7E]/, " ")

    line.gsub!(/ +/, " ")
    line.strip!
    line = line.split(/ /).select { |str| str.scan(/./).size >= 2 }.join(" ")

    file.puts(line)
  }
}
