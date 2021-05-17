fx_version 'adamant'

game 'gta5'

name 'onesync gps system like a 8born'
author 'tq_store'

client_script 'client.lua'

server_scripts {
  'server.lua',
  '@mysql-async/lib/MySQL.lua',
}

ui_page('html/ui.html')

files {
  'html/ui.html',
  'html/js/script.js',
  'html/css/style.css',
  'html/img/cursor.png',
  'html/img/gps.png'
}
