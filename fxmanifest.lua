fx_version 'cerulean'
game 'gta5'

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/**'
}

shared_script '@es_extended/imports.lua'

client_script {
    'utils.lua',
    'client.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

export 'GeneratePlate'

dependency 'es_extended'

lua54 'yes'