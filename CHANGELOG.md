## [0.1.17-bloc] -  better log on transition and check function for blocking progress dialog shown

## [0.1.16-bloc] -  option for multipart request without file (please don't laugh)

## [0.1.15-bloc] -  check real internet connection

## [0.1.14-bloc] -  CallMethod.UPLOAD_UPDATE is PUT and you can make a multipart request without sending a file, just
 file fields (server's weird requirement)

## [0.1.13-bloc] -  add params as fields to multipart file

## [0.1.12-bloc] -  Support to have locales per flavors, each flavor has its custom strings in "locales" and similar
## strings are added in "globalLocales". This way if you have 2 flavors that has differences only in appName and a few other strings those will be in "locales", while all other will be in "globalLocales". This is better for translation and adding new Strings in multi flavor apps. When the app searches for a String will check first in "locales" and if is not there will check in "globalLocales".

## [0.1.11-bloc] - updated bloc to 6.0.1 breaking change on blocs

## [0.1.11] - added OnUploadProgressCallback to upload file service, example how to upload image and log progress

## [0.1.10] - number input formatter, added utils , updated SingleScrollView to have also maxHeight

## [0.1.9] - Forcing the http requests to have utf8 data as much as possible

## [0.1.8] - fixed snackbar scrim

## [0.1.7] - Option to validate phone with regex

## [0.1.6] - SingleScrollView with minHeight option
 
## [0.1.5] - Dialogs showSnackBar customizations, set position 

## [0.1.3] - Base bloc with local and remote repositories
New Log.s method to print secrets in console only in debug and not to the reporters

## [0.1.2] - Base state with local and remote repository

## [0.1.1] - InstanceProvider with remote and local repository
    cleared some code

## [0.1.0] - migrate to bloc 4.0.0
    updated the other libraries to latest

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

