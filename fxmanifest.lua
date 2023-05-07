fx_version 'cerulean'
game 'gta5'

author 'DuncanEll'
description 'Vehicle Rentals'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    'server/sv_main.lua'
}
client_scripts{
    'client/cl_main.lua',
} 