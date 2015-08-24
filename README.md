# GeoPackage MapCache iOS

#### MapCache iOS ####

The GeoPackage Libraries were developed at the National Geospatial-Intelligence Agency (NGA) in collaboration with [BIT Systems](https://www.bit-sys.com/index.jsp). The government has "unlimited rights" and is releasing this software to increase the impact of government investments by providing developers with the opportunity to take things in new directions. The software use, modification, and distribution rights are stipulated within the [MIT license](http://choosealicense.com/licenses/mit/).

### Pull Requests ###
If you'd like to contribute to this project, please make a pull request. We'll review the pull request and discuss the changes. All pull request contributions to this project will be released under the MIT license.

Software source code previously released under an open source license and then modified by NGA staff is considered a "joint work" (see 17 USC § 101); it is partially copyrighted, partially public domain, and as a whole is protected by the copyrights of the non-government authors and must be released according to the terms of the original open source license.

### About ###

GeoPackage MapCache is an app for iOS that utilizes and demonstrates the functionality in the [GeoPackage iOS](https://git.geointapps.org/geopackage/geopackage-ios) SDK.  The GeoPackage SDK is an iOS Objective-C library implementation of the Open Geospatial Consortium [GeoPackage](http://www.geopackage.org/) [spec](http://www.geopackage.org/spec/).

The MapCache app provides read and write access to GeoPackage files, including features and tiles. Features are visualized and editable on the map. Tiles are visualized on the map and can be loaded from a tile provider or WMS url.

### Screen Shots ###

Manager View with GeoPackages linked at Open Geospatial Consortium [GeoPackage] (http://www.geopackage.org/#sampledata)
 
* [Technology Test Data Set] (http://www.geopackage.org/data/gdal_sample.gpkg)
* [Geonames data for Belgium] (http://www.geopackage.org/data/geonames_belgium.gpkg)
* [Haiti OpenStreetMap tiles and point features] (http://www.geopackage.org/data/haiti-vectors-split.gpkg)
* [Simple Sewers test data set] (http://www.geopackage.org/data/simple_sewer_features.gpkg)

![Screenshot 1](screenshots/screenshot1.jpg)

[Haiti Polygon Features] (http://www.geopackage.org/data/haiti-vectors-split.gpkg)

![Screenshot 2](screenshots/screenshot2.jpg)

[Belgium Point Features] (http://www.geopackage.org/data/geonames_belgium.gpkg)

![Screenshot 3](screenshots/screenshot3.jpg)

Editing [Haiti Features] (http://www.geopackage.org/data/haiti-vectors-split.gpkg) with [OpenStreetMap] (http://www.openstreetmap.org) tiles

![Screenshot 4](screenshots/screenshot4.jpg)

[nowCOAST] (http://nowcoast.noaa.gov) tiles

![Screenshot 5](screenshots/screenshot5.jpg)

### Build ###

The following repositories must be built first:
* [GeoPackage WKB iOS] (https://git.geointapps.org/geopackage/wkb-ios)
* [GeoPackage iOS] (https://git.geointapps.org/geopackage/geopackage-ios)

### Icons ###

GeoPackage Icon is from Open Geospatial Consortium [GeoPackage](http://www.geopackage.org/).

App Icons are from [Icons8](https://icons8.com/), [Material Design Icons on GitHub](https://github.com/google/material-design-icons), or generated at [Android Asset Studio](http://romannurik.github.io/AndroidAssetStudio).

#### Map Button Colors ####
* Grey: #989898
* Yellow: #ffff00
* Green: #00ff00
* Red: #f44336

### Remote Dependencies ###

* [GeoPackage iOS](https://git.geointapps.org/geopackage/geopackage-ios) (The MIT License (MIT)) - GeoPackage Library