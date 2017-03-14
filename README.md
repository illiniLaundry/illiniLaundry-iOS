# IlliniLaundry - iOS version
Tired of checking the laundryalert website? Try out IlliniLaundry!


Available on the Apple appstore soon.
## Requirements

1. Cocoapods 1.0 +
2. XCode 7.3 +
4. Swift3
5. iOS 9.0 +

## How to install
*Note: Ctrl+C command should be inputted about five seconds after pod setup*
``` shell
$ cd /to/cloned/directory/IlliniLaundry
$ pod setup
$ Ctrl+C
$ cd ~/.cocoapods/repos
$ git clone --depth 1 https://github.com/CocoaPods/Specs.git master
$ cd /to/cloned/directory/IlliniLaundry
$ cp -r ~/.cocoapods/repos/master ./master
$ pod install --no-repo-update
```

## Using Xcode

``` shell
$ cd /to/cloned/directory/IlliniLaundry
$ open IlliniLaundry.xcworkspace
```
## TODOs

1. Add fetching for single dorms
2. Optimize GenericDormViewController once fetching single dorm is supported
3. Increase spacing for collectionview cells in AllDormsViewController
4. Optimize shadow calculations for collectionview cells in AllDormsViewController
5. Writeup git tutorial for people who want to contribute
6. Change all fonts to reflect the android version of the app
7. Decrese perceived elevation distance for collectionview cells in AllDormsViewController
8. Update UI in MyDormsViewController
9. Set Statusbar theme to light for LaundryMachineViewController
10. Comment and refactor code more thoroughly

## Pages

1. [AllDormsViewController] (#AllDormsViewController)
2. [MyDormsViewController] (#MyDormsViewController)
3. [GenericDormViewController] (#GenericDormViewController)

### AllDormsViewController
>Displays all dorms in a collectionView, three dorms per row.

### MyDormsViewController
>Displays all dorms that the user has favorited in a collectionView, one dorm per row.

### GenericDormViewController
>Displays all laundry and dryer machines and their status in a scrollview.
This view is generic and programmatically populated during runtime as needed.

## Special Thanks
Everyone who helped our team along the way. Thank you for letting us bring to life something great.
