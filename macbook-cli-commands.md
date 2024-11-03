# 1. Disable Apache
Disable default HTTP (Apache) server from running and using Port 80

`sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null`

you can also replace `unload` with `disable`

# 2. Send Desktop notification from CLI OSX
```
osascript -e 'display notification "{{Message}}"  with title "{{Title}}"'
```
