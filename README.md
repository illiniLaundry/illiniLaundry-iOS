# IlliniLaundry - iOS version
The previous iOS dev team failed to deliver a final product so a team of new developers was assigned to this project.

## Requirements

1. Cocoapods 1.0 +
2. XCode 7.3 +
4. Swift3
5. iOS 9.0 +

## How to install

``` shell
$ cd /to/cloned/directory/IlliniLaundry
$ pod setup
$ Ctrl+C
$ cd ~/.cocoapods/repos
$ git clone --depth 1 https://github.com/CocoaPods/Specs.git master
$ cp -r ~/.cocoapods/repos/master ./master
$ pod install --no-repo-update
```

## Using Xcode

``` shell
$ cd /to/cloned/directory/IlliniLaundry
$ open IlliniLaundry.xcworkspace
```

## Pages

1. [AllDormsViewController] (#AllDormsViewController)
Display all dorms
2. [MyDormsViewController] (#MyDormsViewController)
Display my dorms
3. [GenericDormViewController] (#GenericDormViewController)
Display laundry status of one dorm

### AllDormsViewController
Displays all dorms in a scrollview, three dorms per row.
### MyDormsViewController
Displays all dorms that the user has favorited in a scrollview, one dorm per row.
### GenericDormViewController
Displays all laundry and dryer machines and their status in a scrollview.
This view is generic and programmatically populated during runtime as needed.

