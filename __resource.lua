server_scripts {
  '@async/async.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua'
}

client_scripts {
  'client/*.lua'
}

ui_page 'html/ui.html'
files {
  -- Page
  'html/ui.html',

  -- Style
  'html/*.css',

  -- Javascript
  'html/*.js',

  -- Images
  'html/*.png',
  'html/items/*.png',
}


