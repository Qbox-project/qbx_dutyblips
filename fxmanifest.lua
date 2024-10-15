fx_version 'cerulean'
game 'gta5'

name 'qbx_dutyblip'
description 'Duty blips for Qbox'
repository 'https://github.com/Qbox-project/qbx_dutyblips'
version '1.0.0'

shared_script '@ox_lib/init.lua'

client_script 'client/main.lua'

server_script 'server/main.lua'

file 'config/shared.lua'

lua54 'yes'
use_experimental_fxv2_oal 'yes'