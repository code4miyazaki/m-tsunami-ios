# 経度緯度情報を、Geo3x3に変換するサンプルコードです 2021.4.11
# 現在のところ、自治体から提供されるデータも、マップ上への描画も経度緯度を利用しているため、
# アプリケーションの中では使っていませんが、いずれはこの形でデータ連携した方がスッキリして分かりやすいかも？

require 'csv'
require './geo3x3'

L = 15  # 4.19m x 4.94m

fh = File.open("../iosapp/06-earthquake/shelters.csv","r")
CSV.foreach(fh) do |row|
  lng = row[5]
  lat = row[6]
  geo = Geo3x3.encode(lat,lng,L)
  puts [geo,row[1],row[2]].join(",")
end

# 以下のような出力が得られます
# E91237573584347,宮崎市立宮崎小学校,宮崎市旭1-4-1
# E91237573594447,宮崎地方裁判所（南棟）,宮崎市旭2-3-13
# E91237573857566,日本郵便株式会社宮崎中央郵便局,宮崎市高千穂通1-1-34
# E91237573483615,宮崎市役所（会議室棟）,宮崎市橘通西1-1-1
# E91237576242394,宮崎市立江平小学校,宮崎市橘通西5-6-37