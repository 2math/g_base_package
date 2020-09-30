## [0.0.21] - add action to snackbar

## [0.0.20] - better log on transition and check function for blocking progress dialog shown

## [0.0.19] - Check real internet and let multipart request execute without a file

## [0.0.18] - CallMethod.UPLOAD_UPDATE is PUT and you can make a multipart request without sending a file, just file fields (server's weird requirement)

## [0.0.17] - add params as fields to multipart file

## [0.0.16] -  Support to have locales per flavors, each flavor has its custom strings in "locales" and similar
## strings are added in "globalLocales". This way if you have 2 flavors that has differences only in appName and a few other strings those will be in "locales", while all other will be in "globalLocales". This is better for translation and adding new Strings in multi flavor apps. When the app searches for a String will check first in "locales" and if is not there will check in "globalLocales".

## If your app does not care about multi flavors, can omit the "globalLocales" and send it's "locales" only

## [0.0.15] - same updates as till master-0.1.11

## [0.0.9] - versioning with FL servers. It has ready for use service request, response and logic for status. Example in
 the app how to use it.

## [0.0.8] - fix on logging error instead of info

## [0.0.7] - helper function to get status bar height

## [0.0.6] - SingleScrollView which has full parent height and will keep it on show keyboard.
This way you can design your screen and make sure on keyboard visible will keep the same layout and will be
scrollable

## [0.0.5] - helper function to detect keyboard is visible

## [0.0.4] - Log error with any data that will be converted to Error if is not instance of it

## [0.0.3] - better logs

## [0.0.2] - refresh session

* added ability to refresh session on 401
* added timestamp in logs

## [0.0.1] - initial release

