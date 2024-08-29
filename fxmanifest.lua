fx_version 'cerulean'
game 'gta5'

name 'qbx_dutyblip'
description 'Duty blips for Qbox'
repository 'https://github.com/Qbox-project/qbx_dutyblips'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua'
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/main.lua'
}

server_script 'server/main.lua'

lua54 'yes'
use_experimental_fxv2_oal 'yes'