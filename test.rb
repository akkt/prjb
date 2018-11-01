File.open('BBB') do |file|
    file.each_line do |l|
    	begin
    		# 行ごとに処理
    		# まず普通にバイナリに書き出す

    	    # 書き出し
    	    File.open("Test_SISO",'a') do |f|
    	    	f.puts l.unpack('H*')
    	    end
    	rescue => e
    		puts "ERROR -> #{file.lineno}"
    		puts e.backtrace.join("\n")
    	end
    end
end
