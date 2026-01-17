fx_version 'cerulean'
game 'gta5'

author 'Milan'
description 'Speler Fouilleren Script'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory'

}
