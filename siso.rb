require './common_logic.rb'

module Siso

  # for UC
  def self.for_uc(target, out_filename)
		data = []
		File.open(target, 'rb') do |file|
			file.each_line do |l|
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
			urikin = UcLogic.prepare_s9(l.byteslice(199,9))
			zeikin = UcLogic.prepare_s9(l.byteslice(208,9))
			uritot = UcLogic.prepare_s9(l.byteslice(217,9))
			seikin1 = UcLogic.prepare_s9(l.byteslice(226,9))
			seizei = UcLogic.prepare_s9(l.byteslice(235,9))
			seitot1 = UcLogic.prepare_s9(l.byteslice(244,9))

			seidate1 = l.byteslice(253,8)

			seikin2 = UcLogic.prepare_s9(l.byteslice(261,9))
			seizei2 = UcLogic.prepare_s9(l.byteslice(270,9))
			seitot2 = UcLogic.prepare_s9(l.byteslice(279,9))

			seidate2 = l.byteslice(288,8)

			cskin = UcLogic.prepare_s9(l.byteslice(296,9))
			csrisok = UcLogic.prepare_s9(l.byteslice(305,9))
			cstesu = UcLogic.prepare_s9(l.byteslice(314,9))
			cstot = UcLogic.prepare_s9(l.byteslice(323,9))

			tuka = l.byteslice(332,3)
			tukanm = l.byteslice(335,3)

			tukakin = UcLogic.prepare_s9(l.byteslice(338,13), 14)
			maskin = UcLogic.prepare_s9(l.byteslice(351,9))

			kansoba = l.byteslice(360,9)
			kanritu = l.byteslice(369,5)
			kamcd = l.byteslice(374,3)
			kamadd = l.byteslice(377,15)
			seidate = l.byteslice(392,8)
			sohdate = l.byteslice(400,8)
			kensu = l.byteslice(408,9)

			sohtot = UcLogic.prepare_s9(l.byteslice(417,11), 12)

			yobi = l.byteslice(428,22)

			# SI/SO
			simei = kjname.unpack('H*')[0]
			simei.insert(0,'0e')
			simei << '0f'
			simei_s = [simei].pack('H*')

			kameiten = kameinm.unpack('H*')[0]
			kameiten.insert(0,'0e')
			kameiten << '0f'
			kameiten_s = [kameiten].pack('H*')

			# TODO あとでちゃんと
			out << jyucd << kaicd << hojin << cardno << perno << meikbn << renno << ukedate << uc1 << seikbn
			out << riyokbn << uc2 << henko << uricard 
			out << simei_s
			out << kameino
			out << kameiten_s
			out << buncd << riyodate << urikin
			out << zeikin << uritot << seikin1 << seizei << seitot1 << seidate1 << seikin2 << seizei2 << seitot2 << seidate2
			out << cskin << csrisok << cstesu << cstot << tuka << tukanm << tukakin << maskin << kansoba << kanritu
			out << kamcd << kamadd << seidate << sohdate << kensu << sohtot << yobi 

			File.open("#{out_filename}", 'a+b') do |f| 
			  f.puts out
			end
		end
	end

	# for VISA
	def self.for_visa(target, out_filename)
		data = []
		File.open(target, 'rb') do |file|
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

			File.open("#{out_filename}", 'a+b') do |f| 
			  f.puts out
			end
		end
	end
end