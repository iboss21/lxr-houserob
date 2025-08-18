fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'
this_is_a_map "yes"

description 'y0-houserobbery'
version '1.0.0'

author 'younNGG97'



shared_scripts {
    '@jo_libs/init.lua',
    '@ox_lib/init.lua',
    'config.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua',
}


files {
    'locales/*.json',
}

dependencies {
    'rsg-core',
    'ox_lib',
}

lua54 'yes'

escrow_ignore {
    'client/*.lua',
    'config.lua',
    'server/*.lua'
}

dependency '/assetpacks'