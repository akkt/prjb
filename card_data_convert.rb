require './siso.rb'
require './conv.rb'

class CardDataConvert

  # UC
  # 特定のフォルダ配下のファイルを処理
  Dir.glob('./UC/*').each do |target|
  	siso_out = target.gsub(/D/, /K/)
#  	siso_out = target.gsub(/D\d+/, "K#{target[-2,2]}")
    Siso.for_uc(target, siso_out)

    out = siso_out.gsub(/./, '')
    Conv.convert(siso_out, out)
  end

  # VISA
  Dir.glob('./VISA/*').each do |target|
  	siso_out = target.gsub(/D/, /K/)
    Siso.for_visa(target, siso_out)

    out = siso_out.gsub(/./, '')
    Conv.convert(siso_out, out)
  end
end