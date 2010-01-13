#! ruby -Ku

require "nkf"

File.open("out.txt", "wb") { |file|
  File.foreach("in.txt") { |line|
    line.chomp
#line.gsub!(/\xE2\x80\x94/, "-")  # EM DASH
#line.gsub!(/\xE3\x80\x9C/, "～") # WAVE DASH
#line = NKF.nkf("-W -w80 -m0 -Z1", line)

#line.gsub!(/([^A-Za-z])([A-Za-z])/, '\1 \2') # 非アルファベット-アルファベット境界にスペースを挿入
#line.gsub!(/([A-Za-z])([^A-Za-z])/, '\1 \2') # アルファベット-非アルファベット境界にスペースを挿入

line.gsub!(/([^ァ-ヺー])([ァ-ヺー])/, '\1 \2') # 非カタカナ-カタカナ境界にスペースを挿入
line.gsub!(/([ァ-ヺー])([^ァ-ヺー])/, '\1 \2') # 非カタカナ-カタカナ境界にスペースを挿入

#line.gsub!(/[ぁ-ゞ]+/, " ")
#line.gsub!(/[、。]/, " ")
#line.gsub!(/[「」]/, " ")
#line.gsub!(/[【】]/, " ")

line.gsub!(/ +/, " ")
line.strip!
    file.puts(line)
  }
}
