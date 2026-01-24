# Last FM Data

This is macOS native app written in SwiftUI, where a [Last.fm](https://www.last.fm/) user can render his/her top albums and save it as a PNG file inside the downloads folder.

- Built using Xcode Version 26.2 (17C52)

![Top Albums Screenshot](Assets/lastfmdata.png)


### How to setup Secrets.xcconfig

- Create a file called Secrets.xcconfig, File - New - File from Template
- Inside the Secrets.xcconfig, add your last.fm API key
```
LASTFM_API_KEY = your_real_key_here
```
- In Xcode: Select your project, and then go to Info → Configurations and Assign Secrets.xcconfig to Debug/Release
- Then, in Info.plist, add the key:
```
LastFMAPIKey = $(LASTFM_API_KEY)
```
