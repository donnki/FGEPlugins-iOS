Integrate Steps:
* Add FGEPlugins.xcodeproj to your xcode Project.
* update project "Build Settings": add "FGEPlugins/FGEPlugins" and "FGEPlugins/ext" into "User Header Search Paths", 
* Build Phases->Link Binary With Libraries, add libraries below:
** libFGEPlugins.a
** StoreKit.framework
** GameKit.framework
** EventKit.framework
** EventKitUI.framework
** CoreMedia.framework
** MessageUI.framework
** GoogleMobileAds.framework (manually)
