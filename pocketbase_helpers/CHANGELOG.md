## 0.9.1

- Added static api health check method to the `PocketBaseConnection` class.
- Added auth refresh method to the `AuthHelper` class.
- Added token to `RecordAuthResult`.

## 0.9.0

- Changed `HelperUtils.cleanMap` to also remove map entries containing empty maps.

## 0.8.0

- Added `RealtimeHelper` to manage the realtime api.

## 0.7.0

- Removed `fields` and `additionalExpansions` parameters from all `CollectionHelper` and `AuthHelper` methods to enforce mapping consistency.
- Moved build file url from `BaseHelper` and `CollectionHelper` into `HelperUtils`, this means the `Helpers` really only serve to access the pocketbase api.
- Added `getRecordJson` method to `HelperUtils`.

## 0.6.0

- Added PocketBaseConnection singleton to manage the connection to pocketbase.
- Changed the pocketbase instance in helper from positioned required to named optional.
- Added `AuthHelper`.

## 0.5.2

- Added class for the GeoPoint field

## 0.5.1

- Added documentation about the new [pocketbase_helpers_cli](https://github.com/Yoeri-z/pocketbase_helpers/tree/stable/pocketbase_helpers_cli) to this package

## 0.5.0

- Removed testing tools as it clashes with clean design principles.
- Added precreation and preupdate hooks at the helper level.

## 0.4.1

- Completed documentation (published with half complete docs oops)
- Made `MockHandler` methods throw Unimplemented error by default.

## 0.4.0

- Added testing utilities (see docs)
- Removed unused positional parameter on `FileHelper`s `removeMany` and `removeAll` methods.

## 0.3.1

- Fixed a breaking bug where `helper.getMultiple` would return a full batch of records if no ids were supplied

## 0.3.0

- Changed implementation of `helper.getMultiple` call to use only one api call instead of a seperate call for each id.
- Reworked the `baseHelper.update` method to take id and map instead of an object that implements the `PocketbaseRecord` interface,
  this was done to improve consistency between the methods and allow the basehelper to be more flexible.
  The `collectionHelper.update` method stays the same.

## 0.2.0

- added getMultiple method on helpers.
- removed file related methods from `BaseHelper` and `CollectionHelper` and moved them to `FileHelper`.
- `FileHelper` is now available on `BaseHelper` and `CollectionHelper` through the `fileField` method
- change fileUrl method be named `buildFileUrl`

## 0.1.0

- made getSingleOrNull method take an expression and parameters instead of a single id.

## 0.0.11

- added `count` method to the `CollectionHelper` and `BaseHelper`
- add `getNameFromFileUrl` to `HelperUtils`
- changed the search method to take a list of keywords instead of a string
  where the words are seperated by commas. This gives more flexibility

## 0.0.10

- made clean map work recursively on maps inside other maps

## 0.0.9

- fixed breaking bug in getFileUrl method of collection helper

## 0.0.8

- fixed mistake in readme
- added `body` field to the `delete` methods

## 0.0.7

- Renamed `getSingle` to `getOne` and `getMaybeSingle` to `getOneOrNull`, this should be more in line
  with general naming conventions

## 0.0.6

- Renamed `baseExpansions` to just `expansions` on the `CollectionHelper` class
- Added a getter for the raw `RecordService` object to `CollectionHelper`
- added a new getMaybeSingle() method to `CollectionHelper` and `BaseHelper`
- renamed `otherFilters` to `additionalExpressions` on search methods,
- renamed `otherParams` to `additionalParams` on search methods
- removed `SearchParams` class and put its fields directly into the search method.
  This was done to make the method more intuitive to use
- added `fields` parameter to all methods, takes a list of fields to be included in the returning record
  if not given all fields are returned
- Fixed an issue where expansions would not propegate in `addFiles` and `removeFiles` methods
- added queryParameters optionalfields to the getFileUrl method
- renamed `creationHook` and `updateHook` to `preCreationHook` and `preUpdateHook`
- updated readme and inline docs

## 0.0.5

- Fixed breaking bug with filtering in fullList fetch

## 0.0.4

- Fixed breaking bugs related to expansions when creating or updating a record

## 0.0.3

- added expansion merge utilities
- changed fileUrls to fileNames in the removeFiles methods
- changed filePaths to files in the addFiles methods, the expected input is now a map with filenames as keys and filedata as values.
  This change was done to add support for web.
- added buildExpansionString, mergeExpansions and getNamesFromUrls utilityMethods.
- added io_only method support, and added io only method: pathsToFiles

## 0.0.2

- Updated Readme

## 0.0.1

- Initial version.
