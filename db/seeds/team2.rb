require 'digest'

teams = [
  {university: "江西财经大学", province: "江西", name: "“经略纵横”队", contacts: "滕飞", phone: "18702600655", email: "1176625106@qq.com"},
  {university: "江西财经大学", province: "江西", name: "flying", contacts: "卢海涛", phone: "18702602669", email: "2232291095@qq.com"},
  {university: "江西财经大学", province: "江西", name: "剪刀手", contacts: "刘思聪", phone: "18702600340", email: "1019553592@qq.com"},
  {university: "江西财经大学", province: "江西", name: "木柚", contacts: "李天艳", phone: "1361708426", email: "1151540228@qq.com"},
  {university: "江西财经大学", province: "江西", name: "越青春，越未来", contacts: "刘丽玲", phone: "18702603845", email: "1159764787@qq.com"},
  {university: "江西财经大学", province: "江西", name: "Unique", contacts: "蒋红艳", phone: "13576030550", email: "510959333@qq.com"},
  {university: "江西财经大学", province: "江西", name: "创飞梦翼", contacts: "孙培耘", phone: "18702602875", email: "578805081@qq.com"},
  {university: "江西财经大学", province: "江西", name: "王好好平衡车俱乐部", contacts: "蒋萍", phone: "18702600526", email: "1032056438@qq.com"},
  {university: "江西财经大学", province: "江西", name: "开拓五人组", contacts: "翁玲玲", phone: "18702601930", email: "1538963471@qq.com"},
  {university: "江西财经大学", province: "江西", name: "江财挖掘机", contacts: "李怡睿", phone: "15717915870", email: "15717915870@qq.com"}
]

teams.each do |team|
  team[:identifier] = Digest::MD5.hexdigest(team[:phone])
end

ContestTeam.transaction do
  ContestTeam.create(teams)
end
