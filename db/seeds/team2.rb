require 'digest'

teams = [
  {university: "江西财经大学", province: "江西", name: "“经略纵横”队", contacts: "滕飞", email: "18702600655,1176625106@qq.com"},
  {university: "江西财经大学", province: "江西", name: "flying", contacts: "卢海涛", email: "18702602669,2232291095@qq.com"},
  {university: "江西财经大学", province: "江西", name: "剪刀手", contacts: "刘思聪", email: "18702600340,1019553592@qq.com"},
  {university: "江西财经大学", province: "江西", name: "木柚", contacts: "李天艳", email: "1361708426,1151540228@qq.com"},
  {university: "江西财经大学", province: "江西", name: "越青春，越未来", contacts: "刘丽玲", email: "18702603845,1159764787@qq.com"},
  {university: "江西财经大学", province: "江西", name: "Unique", contacts: "蒋红艳", email: "13576030550,510959333@qq.com"},
  {university: "江西财经大学", province: "江西", name: "创飞梦翼", contacts: "孙培耘", email: "18702602875,578805081@qq.com"},
  {university: "江西财经大学", province: "江西", name: "王好好平衡车俱乐部", contacts: "蒋萍", email: "18702600526,1032056438@qq.com"},
  {university: "江西财经大学", province: "江西", name: "开拓五人组", contacts: "翁玲玲", email: "18702601930,1538963471@qq.com"},
  {university: "江西财经大学", province: "江西", name: "江财挖掘机", contacts: "李怡睿", email: "15717915870,15717915870@qq.com"}
]

teams.each do |team|
  team[:identifier] = Digest::MD5.hexdigest(team[:phone])
end

ContestTeam.transaction do
  ContestTeam.create(teams)
end
