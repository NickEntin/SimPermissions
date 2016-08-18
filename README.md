# SimPermissions

[![Version 0.1.0](https://img.shields.io/badge/version-0.1.0-green.svg)](https://github.com/NickEntin/SimPermissions/releases)
[![Issues](https://img.shields.io/github/issues/nickentin/simpermissions.svg?maxAge=2592000)](https://github.com/NickEntin/SimPermissions/issues)
[![MIT License](https://img.shields.io/badge/license-MIT-lightgray.svg)](https://github.com/NickEntin/SimPermissions/blob/master/LICENSE)

SimPermissions is a macOS menu bar app that lets you manage individual app permissions on the iOS simulator. First, select a simulator. You will then see a list of permissions that have been set on that simulator. Each item has an option to grant/revoke that permission, or clear it completely.

The app is currently in beta and has a lot of UI issues.

### Capabilities

SimPermissions can modify a range of permission settings, with more coming soon. Currently it can change or clear permissions for:

* Contacts
* Calendar
* Reminders
* Photos
* Camera
* Media Library

### How do I get set up?

* Download the latest binary from the [releases](https://github.com/NickEntin/SimPermissions/releases/) page

-- OR --

* Clone the repo
* Run `pod install`
* Open `SimPermissions.xcworkspace`
* Run the app from Xcode

### Contributing

Find a bug?  Have a feature you'd like to see added?  Submit an [issue](https://github.com/NickEntin/SimPermissions/issues/new) and/or [pull request](https://github.com/NickEntin/SimPermissions/compare).

### Open Source Libraries

* [SQLite.swift](https://github.com/stephencelis/SQLite.swift)
* [SwiftFSWatcher](https://github.com/gurinderhans/SwiftFSWatcher)
* [LetsMove](https://github.com/potionfactory/LetsMove)
