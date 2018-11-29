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
end

module VisaLogic
  def self.prepare_multiarea(data, size=60)
    iconv = Iconv.new('utf8', 'IBM1390')
    iconv2 = Iconv.new('IBM1390', 'utf8')

    utfdata = iconv.iconv(data)
    sdata = utfdata.ljust(60)
    ibmdata = iconv2.iconv(sdata)
    ibmdata
  end

  def mb_ljust(width, padding=' ')
    output_width = each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
    padding_size = [0, width - output_width].max
    self + padding * padding_size
  end
end