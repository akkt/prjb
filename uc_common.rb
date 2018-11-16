require 'iconv'

module UcCommon
  def self.prepare_s9(bdata)
  	iconv = Iconv.new('utf8', 'IBM1390')
  	iconv2 = Iconv.new('IBM1390', 'utf8')


  	data = bdata.unpack('H*')[0]
  	delimiter = data[-2]
  	if delimiter == 'c'
  		data.gsub!(delimiter, 'f')
  		utfdata = iconv.iconv(bdata)
  		idata = utfdata.to_i
  		sdata = idata.to_s.rjust(10) # 空白文字埋めで右寄せ
  		ibmdata = iconv2.iconv(sdata)
  		ibmdata
  	elsif delimiter == 'd'
  		# マイナス
  		bdata
  	end
  end
end