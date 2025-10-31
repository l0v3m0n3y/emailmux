# emailmux
temp mail nim-lang library emailmux.com
# Example
```nim
import asyncdispatch, emailmux, json
let data = waitFor generate_email()
echo data["email"].getStr
```
# Launch (your script)
```
nim c -d:ssl -r  your_app.nim
```
