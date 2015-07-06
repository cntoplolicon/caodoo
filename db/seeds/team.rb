require 'digest'

ContestTeam.create([
  {identifier: Digest::MD5.hexdigest('草垛网'), name: '草垛网', phone: '草垛网', password: 'caodoo', university: nil, area: nil },
  {identifier: Digest::MD5.hexdigest('SNH48'), name: 'SNH48', phone: 'SNH48', password: 'cntoplolicon', university: '北京大学', area: '中国赛区' },
  {identifier: Digest::MD5.hexdigest('AKB48'), name: 'AKB48', phone: 'AKB48', password: 'jptoplolicon', university: '东京大学', area: '日本赛区' }
])
