# Insider iOS SDK Example

<p align="center">
  <img src="https://github.com/user-attachments/assets/47c3c8d8-9d33-40dd-938f-bc276ea7d560" width="400">
</p>

<p align="center">
  <a href="https://insiderone.com/">Insider</a> &bull;
  <a href="https://academy.insiderone.com/docs/ios-integration">Documentation</a> &bull;
  <a href="LICENSE">MIT License</a>
</p>

This project demonstrates how to integrate the [Insider iOS SDK](https://academy.insiderone.com/docs/ios-integration) into a Swift application using **Swift Package Manager**, **CocoaPods**, or **Carthage**. It includes a fully working example with push notification extensions and all major SDK features.

## Requirements

| Requirement | Minimum |
|---|---|
| iOS | 12.0 (SPM) / 13.0 (CocoaPods) |
| Swift | 5.3+ |
| Xcode | 14.0+ |

## Project Structure

The project contains three build schemes, one for each dependency manager. All schemes share the same source code located in the `Base/` directory.

```
Base/
├── AppDelegate.swift                 # SDK initialization & callbacks
├── SceneDelegate.swift               # Deep link handling
├── NotificationService.swift         # Rich push (Service Extension)
├── NotificationViewController.swift  # Interactive push (Content Extension)
└── Sources/
    ├── Actions/                      # SDK feature implementations
    ├── ViewControllers/              # UI
    └── ...
```

| Scheme | Dependency Manager | Workspace |
|---|---|---|
| `ExampleSPM` | Swift Package Manager | `Example.xcworkspace` |
| `ExamplePods` | CocoaPods | `Example.xcworkspace` |
| `ExampleCarthage` | Carthage | `Example.xcworkspace` |

Each scheme has its own **Notification Service** and **Notification Content** extension targets.

## Getting Started

### 1. Clone the Repository

```bash
git clone git@github.com:useinsider/SwiftDemo.git
cd SwiftDemo
```

### 2. Install Dependencies

Choose one of the following methods:

<details>
<summary><strong>Swift Package Manager</strong></summary>

No extra steps required. Open `Example.xcworkspace` and select the **ExampleSPM** scheme. Xcode resolves packages automatically.

If you are integrating the SDK into your own project, add the package in Xcode as follows:

1. Go to **File → Add Package Dependencies...**
2. Enter the repository URL:

   ```
   https://github.com/useinsider/Insider-iOS-SDK
   ```

3. Select your project under **Add to Project** and click **Add Package**.

<img width="600" src="https://github.com/user-attachments/assets/49f47611-dbf6-44e0-8208-4a2097e0e688" />

> **Important:** When adding the **Insider-iOS-SDK** package, you must add **all SDKs** (including `InsiderMobileAdvancedNotification`) to the **main app target** (e.g. `ExampleSPM`), not to the service or content extension targets.
>
> <img width="600" src="https://github.com/user-attachments/assets/25df038d-cbed-4169-8d4d-134b558ddded" />

</details>

<details>
<summary><strong>CocoaPods</strong></summary>

```bash
pod install
```

Open `Example.xcworkspace` and select the **ExamplePods** scheme.

The `Podfile` includes:

```ruby
platform :ios, '13.0'
use_frameworks!

target 'ExamplePods' do
  pod 'InsiderMobile'
  pod 'InsiderGeofence'
  pod 'InsiderWebView'
end

target 'InsiderNotificationServicePods' do
  pod 'InsiderMobileAdvancedNotification'
end

target 'InsiderNotificationContentPods' do
  pod 'InsiderMobileAdvancedNotification'
end
```

</details>

<details>
<summary><strong>Carthage</strong></summary>

```bash
carthage update --use-xcframeworks --platform iOS
```

Open `Example.xcworkspace` and select the **ExampleCarthage** scheme.

The `Cartfile` includes:

```
binary "https://mobilesdk.useinsider.com/carthage/InsiderWebView/1.0.0/InsiderWebView.json"
binary "https://mobilesdk.useinsider.com/carthage/InsiderGeofence/1.2.4/InsiderGeofence.json"
binary "https://mobilesdk.useinsider.com/carthage/InsiderMobile/14.3.1/InsiderMobile.json"
binary "InsiderMobileAdvancedNotification.json"
```

After building, link the frameworks from `Carthage/Build/` in your target's **Frameworks, Libraries, and Embedded Content** section.

</details>

### 3. Configure Your App

Before running, update the following values with your own:

1. **Partner Name** in `Base/AppDelegate.swift`:

```swift
Insider.initWithLaunchOptions(
    nil,
    partnerName: "YOUR_PARTNER_NAME",
    appGroup: "YOUR_APP_GROUP"
)
```

2. **App Group** identifier in all three files:
   - `Base/AppDelegate.swift`
   - `Base/NotificationService.swift`
   - `Base/NotificationViewController.swift`

3. **Signing & Capabilities** for every target (app + both extensions):
   - Set your development team
   - Enable **Push Notifications**
   - Add an **App Groups** capability with the same identifier used above
   - Enable **Background Modes**: Remote notifications, Location updates, Background processing

> **Important:** The App Group identifier must be identical across the main app target and both notification extension targets.
> 
> Verify that the `com.apple.security.application-groups` value in each target's `.entitlements` file matches the `appGroup` parameter passed to `Insider.initWithLaunchOptions`. 
> 
> A mismatch will prevent the SDK from sharing data between the app and its extensions.

4. **URL Scheme**: In target's **Info** tab under **URL Types**, set the scheme to match your partner name (e.g., `insideryourpartnername`).

## SDK Initialization

The SDK is initialized in `AppDelegate.swift`:

```swift
import InsiderMobile
import InsiderGeofence
import InsiderWebView

@main
public final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        // Register callback handler for SDK events
        Insider.registerCallback(with: #selector(insiderCallback(_:)), sender: self)

        // Initialize with your partner name and app group
        Insider.initWithLaunchOptions(nil, partnerName: "YOUR_PARTNER_NAME", appGroup: "YOUR_APP_GROUP")

        // Show push notifications while app is in foreground
        Insider.setActiveForegroundPushView()

        return true
    }
}
```

### Deep Link Handling

Deep links are handled in `SceneDelegate.swift`:

```swift
import InsiderMobile

public final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    public var window: UIWindow?

    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        for urlContext in connectionOptions.urlContexts {
            Insider.handle(urlContext.url)
        }
    }
}
```

### SDK Callback Handler

```swift
@objc public func insiderCallback(_ dict: [String: Any]) {
    if let typeAsInt = dict["type"] as? Int,
       let type = InsiderCallbackType(rawValue: typeAsInt) {
        switch type {
        case .notificationOpen:
            // Handle push notification tap
            break
        case .inAppSeen:
            // Handle in-app message impression
            break
        case .inappButtonClick:
            // Handle in-app button interaction
            break
        case .sessionStarted:
            // Handle session start
            break
        case .tempStoreAddedToCart, .tempStorePurchase, .tempStoreCustomAction:
            // Handle e-commerce events
            break
        }
    }
}
```

## Push Notification Extensions

The SDK requires two notification extensions for full push notification support:

- **Notification Service Extension** — Intercepts incoming push notifications to download rich media (images, videos) before display. See `Base/NotificationService.swift`.
- **Notification Content Extension** — Provides an interactive carousel UI for expanded push notifications. See `Base/NotificationViewController.swift`.

Both extensions must share the same **App Group** identifier as the main app target. Refer to the source files for the complete implementation.

The Notification Content Extension's `Info.plist` must include the following entries:

```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionAttributes</key>
    <dict>
        <key>UNNotificationExtensionCategory</key>
        <string>insider_int_push</string>
        <key>UNNotificationExtensionDefaultContentHidden</key>
        <false/>
        <key>UNNotificationExtensionInitialContentSizeRatio</key>
        <real>0.5</real>
    </dict>
    <key>NSExtensionMainStoryboard</key>
    <string>InsiderInterface</string>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.usernotifications.content-extension</string>
</dict>
```

### Notification Content Extension - Storyboard Setup

#### CocoaPods

CocoaPods copies `InsiderInterface.storyboard` from the SDK into your build automatically. However, the storyboard's view controller does not have a **Module** set by default, which means the `NotificationViewController` class will not be resolved at runtime.

After running `pod install`, you need to configure it manually:

1. Open `Pods/InsiderMobileAdvancedNotification/Resources/InsiderInterface.storyboard` in Xcode:

   <img width="292" height="354" src="https://github.com/user-attachments/assets/ca016c1f-0fb2-4403-b67f-bd676eaebff0" />

2. Select the **Notification View Controller** scene.
3. In the **Identity Inspector**, set:
   - **Class**: `NotificationViewController`
   - **Module**: Your Notification Content Extension target name (e.g. `InsiderNotificationContentPods`)
   - Keep **Inherit Module From Target** unchecked

> **Important:** Running `pod install` may reset the storyboard to its original state. You may need to re-apply this change after each `pod install`.

#### Swift Package Manager & Carthage

Unlike CocoaPods, SPM and Carthage do not automatically provide the `InsiderInterface.storyboard` file. You need to create it manually in your Notification Content Extension target.

Copy the `InsiderInterface.storyboard` from this project (e.g. `InsiderNotificationContentSPM/InsiderInterface.storyboard`) into your Notification Content Extension target, then open it in Xcode and check the **Inherit Module From Target** box field in the **Identity Inspector** to match your target name.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
