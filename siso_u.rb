require './uc_common.rb'

class SisoU

  data = []
  File.open('BEFSISOU', 'rb') do |file|
    file.each_line do |l|
      # data << l.unpack('H*')
      data << l
    end
  end

  # バイト区切りで取得
  data.each do |l|
    out = ''

    jyucd = l.byteslice(0,2)
    kaicd = l.byteslice(2,4)
    hojin = l.byteslice(6,6)
    cardno = l.byteslice(12,16)
    perno = l.byteslice(28,10)
    meikbn = l.byteslice(38,2)
    renno = l.byteslice(40,5)
    ukedate = l.byteslice(45,8)
    uc1 = l.byteslice(53,12)
    seikbn = l.byteslice(65,2)
    riyokbn = l.byteslice(67,2)
    uc2 = l.byteslice(69,2)
    henko = l.byteslice(71,1)
    uricard = l.byteslice(72,16)
    kjname = l.byteslice(88,40)  # 漢字氏名
    kameino = l.byteslice(128,10)
    kameinm = l.byteslice(138,50) # 漢字加盟店
    buncd = l.byteslice(188,3)
    riyodate = l.byteslice(191,8)
    # S9
    urikin = UcCommon.prepare_s9(l.byteslice(199,9))
    zeikin = UcCommon.prepare_s9(l.byteslice(208,9))
    uritot = UcCommon.prepare_s9(l.byteslice(217,9))
    seikin1 = UcCommon.prepare_s9(l.byteslice(226,9))
    seizei = UcCommon.prepare_s9(l.byteslice(235,9))
    seitot1 = UcCommon.prepare_s9(l.byteslice(244,9))
    
    seidate1 = l.byteslice(253,8)
    
    seikin2 = UcCommon.prepare_s9(l.byteslice(261,9))
    seizei2 = UcCommon.prepare_s9(l.byteslice(270,9))
    seitot2 = UcCommon.prepare_s9(l.byteslice(279,9))

    seidate2 = l.byteslice(288,8)

    cskin = UcCommon.prepare_s9(l.byteslice(296,9))
    csrisok = UcCommon.prepare_s9(l.byteslice(305,9))
    cstesu = UcCommon.prepare_s9(l.byteslice(314,9))
    cstot = UcCommon.prepare_s9(l.byteslice(323,9))

    tuka = l.byteslice(332,3)
    tukanm = l.byteslice(335,3)
    
    tukakin = UcCommon.prepare_s9(l.byteslice(338,13), 14)
    maskin = UcCommon.prepare_s9(l.byteslice(351,9))

    kansoba = l.byteslice(360,9)
    kanritu = l.byteslice(369,5)
    kamcd = l.byteslice(374,3)
    kamadd = l.byteslice(377,15)
    seidate = l.byteslice(392,8)
    sohdate = l.byteslice(400,8)
    kensu = l.byteslice(408,9)

    sohtot = UcCommon.prepare_s9(l.byteslice(417,11), 12)
    
    yobi = l.byteslice(428,22)
    
    # SI/SO
#    simei = kjname.unpack('H76')[0]
    simei = kjname.unpack('H*')[0]
    simei.insert(0,'0e')
    simei << '0f'
    simei_s = [simei].pack('H*')

#    kameiten = kameinm.unpack('H96')[0]
    kameiten = kameinm.unpack('H*')[0]
    kameiten.insert(0,'0e')
    kameiten << '0f'
    kameiten_s = [kameiten].pack('H*')

      #   # TODO あとでちゃんと
    out << jyucd << kaicd << hojin << cardno << perno << meikbn << renno << ukedate << uc1 << seikbn
    out << riyokbn << uc2 << henko << uricard 
    out << simei_s
    out << kameino
    out << kameiten_s
    out << buncd << riyodate << urikin
    out << zeikin << uritot << seikin1 << seizei << seitot1 << seidate1 << seikin2 << seizei2 << seitot2 << seidate2
    out << cskin << csrisok << cstesu << cstot << tuka << tukanm << tukakin << maskin << kansoba << kanritu
    out << kamcd << kamadd << seidate << sohdate << kensu << sohtot << yobi 
    #out << ["0a"].pack('H*')[0] #<< ["0a"].pack('H*')[0]
#puts out.unpack('H*')
    File.open('TEST_SISO_U', 'a+b') do |f| 
      #f.puts [out].pack('H*')
      f.puts out
    end
  end 



  # data.each do |a|
  #   l = a[0]
  #   out = ''

  #   # 先頭から順に処理
  #   jyucd = l.slice!(0,4)
  #   kaicd = l.slice!(0,8)
  #   hojin = l.slice!(0,12)
  #   cardno = l.slice!(0,32)
  #   perno = l.slice!(0,20)
  #   meikbn = l.slice!(0,4)
  #   renno = l.slice!(0,10)
  #   ukedate = l.slice!(0,16)
  #   uc1 = l.slice!(0,24)
  #   seikbn = l.slice!(0,4)
  #   riyokbn = l.slice!(0,4)
  #   uc2 = l.slice!(0,4)
  #   henko = l.slice!(0,2)
  #   uricard = l.slice!(0,32)
  #   kjname = l.slice!(0,80)  # 漢字氏名
  #   kameino = l.slice!(0,20)
  #   kameinm = l.slice!(0,100) # 漢字加盟店
  #   buncd = l.slice!(0,6)
  #   riyodate = l.slice!(0,16)
  #   # S9
  #   urikin = l.slice!(0,18)
  #   zeikin = l.slice!(0,18)
  #   uritot = l.slice!(0,18)
  #   seikin1 = l.slice!(0,18)
  #   seizei = l.slice!(0,18)
  #   seitot1 = l.slice!(0,18)
    
  #   seidate1 = l.slice!(0,16)
    
  #   seikin2 = l.slice!(0,18)
  #   seizei2 = l.slice!(0,18)
  #   seitot2 = l.slice!(0,18)

  #   seidate2 = l.slice!(0,16)

  #   cskin = l.slice!(0,18)
  #   csrisok = l.slice!(0,18)
  #   cstesu = l.slice!(0,18)
  #   cstot = l.slice!(0,18)

  #   tuka = l.slice!(0,6)
  #   tukanm = l.slice!(0,6)
    
  #   tukakin = l.slice!(0,26)
  #   maskin = l.slice!(0,18)

  #   kansoba = l.slice!(0,18)
  #   kanritu = l.slice!(0,10)
  #   kamcd = l.slice!(0,6)
  #   kamadd = l.slice!(0,30)
  #   seidate = l.slice!(0,16)
  #   sohdate = l.slice!(0,16)
  #   kensu = l.slice!(0,18)

  #   sohtot = l.slice!(0,22)
    
  #   yobi = l.slice!(0,44)

  #   # SI/SO
  #   simei = kjname.unpack('a76')[0]
  #   simei.insert(0,'0e')
  #   simei << '0f'

  #   kameiten = kameinm.unpack('a96')[0]
  #   kameiten.insert(0,'0e')
  #   kameiten << '0f'

  #   # TODO あとでちゃんと
  #   out << jyucd << kaicd << hojin << cardno << perno << meikbn << renno << ukedate << uc1 << seikbn
  #   out << riyokbn << uc2 << henko << uricard 
  #   out << simei
  #   out << kameino
  #   out << kameiten
  #   out << buncd << riyodate << urikin
  #   out << zeikin << uritot << seikin1 << seizei << seitot1 << seidate1 << seikin2 << seizei2 << seitot2 << seidate2
  #   out << cskin << csrisok << cstesu << cstot << tuka << tukanm << tukakin << maskin << kansoba << kanritu
  #   out << kamcd << kamadd << seidate << sohdate << kensu << sohtot << yobi 


  #   File.open('TEST_SISO_U', 'a+b') do |f| 
  #     f.puts [out].pack('H*')
  #   end
  # end 
end
