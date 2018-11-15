
data = []
File.open('BEFSISOV', 'rb') do |file|
  file.each_line do |l|
    #data << ud.byteslice(8,40)
    data << l.unpack('H*')
  end
end

data.each do |a|
  l = a[0]
  out = ''

  # 先頭から順に処理
  jyucd = l.slice!(0,4)
  kaicd = l.slice!(0,8)
  hojin = l.slice!(0,12)
  cardno = l.slice!(0,32)
  perno = l.slice!(0,20)
  meikbn = l.slice!(0,4)
  renno = l.slice!(0,10)
  ukedate = l.slice!(0,16)
  uc1 = l.slice!(0,24)
  seikbn = l.slice!(0,4)
  riyokbn = l.slice!(0,4)
  uc2 = l.slice!(0,4)
  henko = l.slice!(0,2)
  uricard = l.slice!(0,32)
  kjname = l.slice!(0,80)  # 漢字氏名
  kameino = l.slice!(0,20)
  kameinm = l.slice!(0,100) # 漢字加盟店
  buncd = l.slice!(0,6)
  riyodate = l.slice!(0,16)
  # S9
  urikin = l.slice!(0,18)
  zeikin = l.slice!(0,18)
  uritot = l.slice!(0,18)
  seikin1 = l.slice!(0,18)
  seizei = l.slice!(0,18)
  seitot1 = l.slice!(0,18)
  
  seidate1 = l.slice!(0,16)
  
  seikin2 = l.slice!(0,18)
  seizei2 = l.slice!(0,18)
  seitot2 = l.slice!(0,18)

  seidate2 = l.slice!(0,16)

  cskin = l.slice!(0,18)
  csrisok = l.slice!(0,18)
  cstesu = l.slice!(0,18)
  cstot = l.slice!(0,18)

  tuka = l.slice!(0,6)
  tukanm = l.slice!(0,6)
  
  tukakin = l.slice!(0,26)
  maskin = l.slice!(0,18)

  kansoba = l.slice!(0,18)
  kanritu = l.slice!(0,10)
  kamcd = l.slice!(0,6)
  kamadd = l.slice!(0,30)
  seidate = l.slice!(0,16)
  sohdate = l.slice!(0,16)
  kensu = l.slice!(0,18)

  sohtot = l.slice!(0,22)
  
  yobi = l.slice!(0,44)

  # SI/SO
  simei = kjname.unpack('a76')[0]
  simei.insert(0,'0e')
  simei << '0f'

  kameiten = kameinm.unpack('a96')[0]
  kameiten.insert(0,'0e')
  kameiten << '0f'

  # TODO あとでちゃんと
  out << jyucd << kaicd << hojin << cardno << perno << meikbn << renno << ukedate << uc1 << seikbn
  out << riyokbn << uc2 << henko << uricard 
  out << simei
  out << kameino
  out << kameiten
  out << buncd << riyodate << urikin
  out << zeikin << uritot << seikin1 << seizei << seitot1 << seidate1 << seikin2 << seizei2 << seitot2 << seidate2
  out << cskin << csrisok << cstesu << cstot << tuka << tukanm << tukakin << maskin << kansoba << kanritu
  out << kamcd << kamadd << seidate << sohdate << kensu << sohtot << yobi 


  File.open('TEST_SISO_U', 'a+b') do |f| 
    f.puts [out].pack('H*')
  end
end 
