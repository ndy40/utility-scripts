# 1. Disable Apache
Disable default HTTP (Apache) server from running and using Port 80

`sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null`

you can also replace `unload` with `disable`
