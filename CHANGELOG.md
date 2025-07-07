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
