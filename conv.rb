require 'iconv'

#$KCODE='UTF8'

# EBCDICファイルオープン
#fstr = File.read("C2B9KEUD27")

['CP932', 'EBCDIC-JP-E'].each do |str_encode|
  
    # 変換コード指定
	iconv=Iconv.new('UTF8', str_encode)

	File.open('C2B9KEUD27') do |file|
		puts "START Conv [#{str_encode}]."

	    file.each_line do |l|
	    	begin
	    	    str = iconv.iconv(l)
	    	    # 書き出し
	    	    File.open("Test_#{str_encode}",'a') do |f|
	    	    	f.puts str
	    	    end
	    	rescue Iconv::IllegalSequence => e
	    		# 特定文字のエラー
	    		puts "Iconv::IllegalSequence -> #{file.lineno}"
	    		puts "  message -> [#{e.message}]"
	    	rescue => e
	    		puts e.backtrace.join("\n")
	    	end
	    end
	end
end
