fx_version 'cerulean'
game 'gta5'

author 'AnishBplayz'
description 'Rentals Script'
version '2.5'

shared_scripts {
    '@qb-core/shared/locale.lua',
    '@ox_lib/init.lua',
    'locales/en.lua',
    'config.lua',
}

client_script {
    'client/cl_*.lua'
}

server_script {
    'server/sv_main.lua'
}

lua54 'yes'