require 'iconv'

module UcLogic
  def self.prepare_s9(bdata, digit=10)
    iconv = Iconv.new('utf8', 'IBM1390')
    iconv2 = Iconv.new('IBM1390', 'utf8')

    hexdata = bdata.unpack('H*')[0]
    delimiter = hexdata[-2]
    sin = delimiter == 'd' ? -1 : 1

    hexdata.gsub!(delimiter, 'f')
    bidata = [hexdata].pack('H*')
    utfdata = iconv.iconv(bidata)
    idata = utfdata.to_i * sin
    sdata = idata.to_s.rjust(digit) # 空白文字埋めで右寄せ
    ibmdata = iconv2.iconv(sdata)
    ibmdata
  end

  # -----------9V99 などの場合に使用。
  def self.prepare_s9_with_v9(bdata, digit=10, after_decimal_point_digit=2)
    iconv = Iconv.new('utf8', 'IBM1390')
    iconv2 = Iconv.new('IBM1390', 'utf8')

    utfdata = iconv.iconv(bdata)
    # 小数点前後に分割
    sint = utfdata.slice(0, (utfdata.length - after_decimal_point_digit)) # 整数部分
    saft = utfdata.slice((digit*-1), digit) # 小数点以下

    # 整数部分を整形
    idata_ibm = prepare_s9(bdata, digit - after_decimal_point_digit)
    # 小数点以下部分
    aft_ibm = iconv2.iconv(saft)

    idata_ibm + aft_ibm
  end

  # 定義が9V99 などの場合に使用。小数点以下を返す
  # def self.get_after_decimal_point(bdata, digit=2)
  #   iconv = Iconv.new('utf8', 'IBM1390')
  #   iconv2 = Iconv.new('IBM1390', 'utf8')

  #   utfdata = iconv.iconv(bdata)
  #   sdata = utfdata.slice((digit*-1), digit)
  #   ibmdata = iconv2.iconv(sdata)
  #   ibmdata
  # end
end

module VisaLogic
  def self.prepare_multiarea(data, size=60)
    iconv = Iconv.new('utf8', 'IBM1390')
    iconv2 = Iconv.new('IBM1390', 'utf8')

    utfdata = iconv.iconv(data)
    sdata = utfdata.ljust(size)
    ibmdata = iconv2.iconv(sdata)
    ibmdata
  end

  def mb_ljust(width, padding=' ')
    output_width = each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
    padding_size = [0, width - output_width].max
    self + padding * padding_size
  end
end