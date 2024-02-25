fx_version 'adamant'

game 'gta5'

client_scripts {
	"config.lua",
	"client/client.lua"
}

server_scripts {
	"config.lua",
	"server/server.lua",
	"@mysql-async/lib/MySQL.lua"
}

ui_page "html/app.html"

files {
	"html/app.html",
	"html/app.js",
	"html/style.css",
	"html/*.png"
}

shared_script '@es_extended/imports.lua'