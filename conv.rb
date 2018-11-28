require 'iconv'

class Conv

  def self.convert(filename, out_filename)
    # 変換コード指定
    iconv=Iconv.new('UTF-8', 'IBM1390')

    data = []
    File.open(filename) do |file|
      puts "START Conv."

      file.each_line do |l|
        begin
          # 改行コードを抜く
          str = iconv.iconv(l.chomp)
          data << str
        rescue Iconv::IllegalSequence => e
          # 特定文字のエラー
          #puts "Iconv::IllegalSequence -> #{file.lineno}"
          puts "  message -> [#{e.message}]"
        rescue => e
          puts e.backtrace.join("\n")
        end
      end
    end

    File.open(out_filename, 'a') do |ff|
      data.each do |l|
        ff.puts l
      end
    end
  end
end

