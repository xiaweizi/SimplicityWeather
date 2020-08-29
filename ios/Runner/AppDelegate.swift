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
    AMapServices.shared()?.apiKey = "9a313effeb3ba1be5dfdcc42308d7d07"
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

