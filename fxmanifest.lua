fx_version 'cerulean'
games { 'gta5' }

author 'Tiger (lets_tiger)'
description 'Carwash Script'
version '1.1.0'

lua54 'yes'

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua',
    'server/version_check.lua'
}

shared_script {
	'config.lua',
	'locales.lua',
	'locales/*.lua'
}

files {
    'sounds/carwash.ogg'
}

data_file 'AUDIO_WAVEPACK' 'sounds/'

dependencies {
    'es_extended'
}