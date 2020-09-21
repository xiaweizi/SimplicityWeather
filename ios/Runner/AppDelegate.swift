import UIKit
import Flutter
import AMapFoundationKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    AMapServices.shared()?.apiKey = "1acd2fca2d9361152f3e77d0d7807043"
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

