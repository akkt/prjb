#require './v_common.rb'
require 'iconv'

class SisoV

  data = []
  File.open('BEFSISOV', 'rb') do |file|
    file.each_line do |l|
      data << l
    end
  end

  iconv = Iconv.new('utf8', 'IBM1390')

  # バイト区切りで取得
  data.each do |l|
    out = ''

    kubun = l.byteslice(0,1)
    datakbn = iconv.iconv(kubun)

    # データ区分「2」以外は処理しない
    if datakbn != '2'
      File.open('TEST_SISO_V', 'a+b') {|f| f.puts l }
      next
    end

    trkbn = l.byteslice(1,2)
    hojino = l.byteslice(3,4)
    hojinm = l.byteslice(7,20)
    mono = l.byteslice(27,4)
    monm = l.byteslice(31,20)
    siyono = l.byteslice(51,4)
    siyonm = l.byteslice(55,20)
    perno = l.byteslice(75,16)
    kaino = l.byteslice(91,16)
    kainm = l.byteslice(107,20)
    rkbn = l.byteslice(127,1)
    rdate = l.byteslice(128,8)
    fugo = l.byteslice(136,1)
    kingaku = l.byteslice(137,9)
    kameinm = l.byteslice(146,20)
    kameino = l.byteslice(166,9)
    isocd = l.byteslice(175,4)
    kbn = l.byteslice(179,1)
    malt = l.byteslice(180,60)
    kdate = l.byteslice(240,8)
    no = l.byteslice(248,5)
    yobi = l.byteslice(253,3)

    # 区分エリア
    kbn_area = iconv.iconv(kbn)
    if kbn_area == '0'
      # SISO
      # 加盟店名 漢字 20byte
      kameiten_knj = malt.byteslice(0,20)
      kameiten_knj = kameiten_knj.unpack('H*')[0]
      kameiten_knj.insert(0,'0e')
      kameiten_knj << '0f'
      malt_s = [kameiten_knj].pack('H*')
      malt_s = malt_s.ljust(60)
    elsif kbn_area == 'B'
      mkbn = malt.byteslice(0,1)
      # SISO
      kokuken_knj = malt.byteslice(1, 40)
      kokuken_knj = kokuken_knj.unpack('H*')[0]
      kokuken_knj.insert(0, '0e')
      kokuken_knj << '0f'
      malt_s = mkbn + [kokuken_knj].pack('H*')
      malt_s = malt_s.ljust(60)
    else
      # シフトコード付与なし
      malt_s = malt
    end

    out = kubun
    out << trkbn << hojino << hojinm << mono << monm << siyono << siyonm
    out << perno << kaino << kainm << rkbn << rdate
    out << fugo << kingaku << kameinm << kameino << isocd
    out << kbn << malt_s
    out << kdate << no << yobi

    File.open('TEST_SISO_V', 'a+b') do |f| 
      f.puts out
    end
  end 

end
