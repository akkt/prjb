
data = []
File.open('BEFSISOV', 'rb') do |file|
  file.each_line do |l|
    #data << ud.byteslice(8,40)
    data << l.unpack('H*')
  end
end

data.each do |a|
  l = a[0]
  if l.byteslice(0, 2) == 'f2'
    l.insert(360, '0e')
    l.insert(466, '0f')

    File.open('TEST_SISO', 'a+b') do |f| 
      f.write [l].pack('H*')
    end
  end
end 
