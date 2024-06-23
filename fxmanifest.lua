fx_version 'cerulean'
games { 'gta5' }

author 'Tiger (Lets_Tiger#4159)'
description 'Carwash Script'
version '1.0'

lua54 'yes'

client_scripts {
    'client/main.lua',
    'config.lua'
}

server_scripts {
    'server/main.lua',
    'server/version_check.lua',
    'config.lua'
}

dependencies {
    'es_extended'
}