require 'iconv'
require 'nkf'

# 変換コード指定
iconv=Iconv.new('UTF-8', 'IBM1390')
data = []
#File.open('C2.B9K.B9KVSK') do |file|
File.open('TEST_SISO_U') do |file|
	puts "START Conv."

    file.each_line do |l|
    	begin
          # 改行コードを抜く
   	    str = iconv.iconv(l.chomp)
    	    data << str
#puts str.unpack('H*')
#puts l.unpack('H*')
    #        data = iconv.iconv(File.read('TEST_SISO_U'))

            #File.open('N', 'a') {|f| f.puts NKF.nkf('--ic=CP932 --oc=UTF-8', l)}
    	rescue Iconv::IllegalSequence => e
    		# 特定文字のエラー
    		#puts "Iconv::IllegalSequence -> #{file.lineno}"
    		puts "  message -> [#{e.message}]"
    	rescue => e
    		puts e.backtrace.join("\n")
    	end
    end
end
#
#File.write('iconvUC', data)

File.open('iconvUC', 'a') do |ff|
  #s = data.force_encoding('Shift_JIS')
  data.each do |l|
#puts l.unpack('H*')
ff.puts l
  end
  #ff.print "\r\n"
end

#iconv2 = Iconv.new('UTF-8', 'IBM943')
#res = iconv2.iconv(data)
#File.open("Test_s2",'a') do |f|
#	f.puts res
#end

