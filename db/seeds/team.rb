require 'digest'

ContestTeam.create([
  {identifier: Digest::MD5.hexdigest('SNH48'), name: 'SNH48', phone: '13716988543', password: 'cntoplolicon', university: '北京大学', area: '中国赛区' },
  {identifier: Digest::MD5.hexdigest('AKB48'), name: 'AKB48', phone: '15221746710', password: 'jptoplolicon', university: '东京大学', area: '日本赛区' }
])
