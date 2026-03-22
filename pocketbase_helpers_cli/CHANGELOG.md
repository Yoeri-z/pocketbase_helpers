## 0.7.0

- Added support for json fields.

## 0.6.0

- Made number fields take type int if "onlyInt" is true.

## 0.5.0

- Fixed a breaking bug where fromMap wouldnt generate as static.
- Added realtime generator static method.

## 0.4.0

- Changed internal implementation to use code_builder
- Fixed edge cases and added more tests to catch edgecases
- Added `PocketBaseCollection` and `PocketBaseField` classes to improve testability, readability and use of this package as a dependency.
- Added collections static class to the generated library and also added collectionname static to each helper class.
- Added static authentication methods to auth collection generated entity models.

## 0.3.0

- Changed the generator to match the new [pocketbase_helpers] api.

## 0.2.0

- Restructured files to follow standard package format
- Removed the output dir field from the generator since it was not used internally anyway.
- Added exaustive tests
- Added GeoPoint
- fixed various edgecases

## 0.1.0

- Initial version.
