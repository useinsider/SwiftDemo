# Insider iOS SDKs Example

[![CocoaPods compatible](https://img.shields.io/cocoapods/v/InsiderMobile.svg?label=InsiderMobile)](https://cocoapods.org/pods/InsiderMobile) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/InsiderMobileAdvancedNotification.svg?label=InsiderMobileAdvancedNotification)](https://cocoapods.org/pods/InsiderMobileAdvancedNotification) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/InsiderGeofence.svg?label=InsiderGeofence)](https://cocoapods.org/pods/InsiderGeofence) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/InsiderWebView.svg?label=InsiderWebView)](https://cocoapods.org/pods/InsiderWebView) [![Swift Package Manager](https://img.shields.io/github/v/release/useinsider/Insider-iOS-SDK?label=SwiftPM&sort=semver&color=red)](https://github.com/useinsider/Insider-iOS-SDK/releases/latest) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

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

The project ships **two flavors** of the example app — one for the classic native SDK (`InsiderMobile` + `InsiderGeofence`), and one for the `InsiderWebView` SDK — each provided as three schemes (SPM, CocoaPods, Carthage). Shared code is split into per-flavor directories that are wired into every target via Xcode's *file-system synchronized groups*.

```
Shared/                              # Used by every app target
├── Sources/
│   ├── AppDelegate.swift            # SDK initialization & callbacks
│   ├── SceneDelegate.swift          # Deep link handling
│   ├── NotificationService.swift    # Rich push (Service Extension)
│   └── NotificationViewController.swift  # Interactive push (Content Extension)
└── Resources/
    ├── Assets.xcassets
    └── Base.lproj/LaunchScreen.storyboard

Native/                              # Used by Example{SPM,Pods,Carthage}
├── Sources/
│   ├── Actions/                     # SDK feature implementations
│   ├── ViewControllers/             # UI
│   ├── Views/, Utilities/, Design/, Additions/
└── Resources/
    ├── Colors.xcassets, Images.xcassets
    └── Fonts/{Figtree,RedHatDisplay}

WebView/                             # Used by ExampleWebView{SPM,Pods,Carthage}
├── Sources/MainViewController.swift
└── Resources/{index.html, WebView.storyboard}

Example{SPM,Pods,Carthage}/          # Per-target Info.plist + entitlements
ExampleWebView{SPM,Pods,Carthage}/   # Per-target Info.plist + entitlements
InsiderNotificationService{SPM,Pods,Carthage}/
InsiderNotificationContent{SPM,Pods,Carthage}/
```

| Scheme | Dependency Manager | Flavor | SDKs |
|---|---|---|---|
| `ExampleSPM` | Swift Package Manager | Native | InsiderMobile, InsiderGeofence, InsiderMobileAdvancedNotification |
| `ExamplePods` | CocoaPods | Native | InsiderMobile, InsiderGeofence, InsiderMobileAdvancedNotification |
| `ExampleCarthage` | Carthage | Native | InsiderMobile, InsiderGeofence, InsiderMobileAdvancedNotification |
| `ExampleWebViewSPM` | Swift Package Manager | WebView | InsiderMobile, InsiderWebView |
| `ExampleWebViewPods` | CocoaPods | WebView | InsiderMobile, InsiderWebView |
| `ExampleWebViewCarthage` | Carthage | WebView | InsiderMobile, InsiderWebView |

All targets live in `Example.xcworkspace`. Each native scheme has its own **Notification Service** and **Notification Content** extension targets.

| Feature | Native | WebView |
|---|:---:|:---:|
| **Reinit** | 🟢 | 🔴 |
| Event tracking (`tagEvent`, custom events) | 🟢 | 🟢 |
| Page-visit events (home, listing, PDP, cart, wishlist) | 🟢 | 🟢 |
| User identifiers (login, logout) | 🟢 | 🟢 |
| User attributes & opt-ins (email, SMS, push, location, ...) | 🟢 | 🟢 |
| Product, cart, wishlist, purchase events | 🟢 | 🟢 |
| In-app messaging (enable / disable) | 🟢 | 🟢 |
| **Smart Recommender** | 🟢 | 🔴 |
| **Content Optimizer** (A/B testing) | 🟢 | 🔴 |
| Push notifications | 🟢 | 🟢 |
| Geofencing | 🟢 | 🟢 |
| GDPR (carrier, IP, location, ...) | 🟢 | 🟢 |
| **App Cards** (campaign messaging) | 🟢 | 🔴 |

If your use case depends on any row in **bold**, pick a `Example{SPM,Pods,Carthage}` scheme. Otherwise either flavor works.


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
end

target 'ExampleWebViewPods' do
  pod 'InsiderMobile'
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
binary "https://mobilesdk.useinsider.com/carthage/InsiderMobile/15.0.3/InsiderMobile.json"
binary "InsiderMobileAdvancedNotification.json"
```

After building, link the frameworks from `Carthage/Build/` in your target's **Frameworks, Libraries, and Embedded Content** section.

</details>

### 3. Configure Your App

Before running, update the following values with your own:

1. **Partner Name** in [`Shared/Sources/AppDelegate.swift`](Shared/Sources/AppDelegate.swift):

```swift
Insider.initWithLaunchOptions(
    launchOptions,
    partnerName: "YOUR_PARTNER_NAME",
    appGroup: "YOUR_APP_GROUP"
)
```

2. **App Group** identifier in all three files:
   - [`Shared/Sources/AppDelegate.swift`](Shared/Sources/AppDelegate.swift)
   - [`Shared/Sources/NotificationService.swift`](Shared/Sources/NotificationService.swift)
   - [`Shared/Sources/NotificationViewController.swift`](Shared/Sources/NotificationViewController.swift)

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
import UIKit

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
        Insider.initWithLaunchOptions(
            launchOptions, 
            partnerName: "YOUR_PARTNER_NAME", 
            appGroup: "YOUR_APP_GROUP"
        )

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
import UIKit

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

- **Notification Service Extension** — Intercepts incoming push notifications to download rich media (images, videos) before display. See `Shared/Sources/NotificationService.swift`.
- **Notification Content Extension** — Provides an interactive carousel UI for expanded push notifications. See `Shared/Sources/NotificationViewController.swift`.

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

## InsiderWebView

The `ExampleWebView{SPM,Pods,Carthage}` schemes demonstrate the `InsiderWebView` SDK. The whole demo lives in `WebView/`:

```
WebView/
├── Sources/MainViewController.swift  # Hosts a WKWebView and wires up the SDK
└── Resources/
    ├── WebView.storyboard            # @IBOutlet for the WKWebView
    └── index.html                    # Demo page that talks to the SDK
```

`MainViewController` hands the `WKWebView` to the SDK via a single call, then loads the demo page:

```swift
import InsiderMobile
import InsiderWebView
import UIKit
import WebKit

public final class MainViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!

    public override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        Insider.setupWebViewSDK(on: webView)

        // ...load the page (see below)
    }
}
```

The demo ships two ways of feeding `index.html` to the web view — pick whichever fits your workflow.

### Loading the page from the app bundle

The `WebView/Resources` folder is copied into the app bundle at build time, so `index.html` is available via `Bundle.main`:

```swift
if let htmlPath = Bundle.main.path(forResource: "index", ofType: "html") {
    let url = URL(fileURLWithPath: htmlPath)
    webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
}
```

This is the default in `MainViewController.viewDidLoad()`. Use it when you want the page to ship with the app and work offline.

### Loading the page from a local HTTP server

While iterating on `index.html`, it is faster to serve the file over HTTP so you can edit and refresh without rebuilding the app. From the repository root, run:

```bash
python3 -m http.server 8080 --directory WebView/Resources
```

Then replace the bundle-loading block in `MainViewController.viewDidLoad()` with:

```swift
if let url = URL(string: "http://localhost:8080/index.html") {
    webView.load(URLRequest(url: url))
}
```

> **Note:** iOS blocks plaintext HTTP traffic by default. To load `http://localhost:...` you must either set `NSAllowsLocalNetworking` (or `NSAllowsArbitraryLoads`) under `NSAppTransportSecurity` in the target's `Info.plist`, or serve `index.html` over HTTPS. When testing on a physical device, replace `localhost` with the host machine's LAN IP and make sure both devices are on the same network.

### Using the SDK from TypeScript

When the page loaded in the WebView is part of a TypeScript codebase, you can get full type-safety and autocompletion for the JavaScript bridge that `Insider.setupWebViewSDK(on:)` injects. The [`InsiderWebViewScript.d.ts`](WebView/Resources/InsiderWebViewScript.d.ts) file in this repository ships the ambient type declarations for that bridge — there is no runtime code in it; it only describes the API that the native SDK exposes at runtime as `window.insider`.

It declares:

- A global `window.insider` of type `Insider` (the bridge entry point).
- Classes / enums you can construct in TypeScript: `InsiderEvent`, `InsiderProduct`, `InsiderIdentifiers`, `InsiderUser`, `CloseButtonPosition`.
- Supporting types: `Insider`, `InsiderIDListener`, `InsiderListenerRegistration`, `MessageCenterMessage`, `ParameterMap`.

#### Wire it into your project

Copy [`InsiderWebViewScript.d.ts`](WebView/Resources/InsiderWebViewScript.d.ts) into your web app's source tree (e.g. `src/types/`) and reference it in `tsconfig.json`:

```json
{
  "include": ["src/**/*", "src/types/InsiderWebViewScript.d.ts"]
}
```

Alternatively, put a triple-slash reference at the top of your entry file:

```ts
/// <reference path="./types/InsiderWebViewScript.d.ts" />
```

That is enough to make `window.insider` strongly typed everywhere — no `import` needed because the file augments the global `Window` interface.

#### Use the typed bridge

All calls are checked at compile time — wrong parameter shapes or types will fail `tsc` before they ever reach the device. Note that event and parameter keys are typed as plain `string`, so they are not constrained at compile time; follow the SDK's naming rules (lowercase, starts with a letter, only `a–z`, `0–9`, `_`).

```ts
async function onPurchase() {
    const product = window.insider
        .createNewProduct(
          'prod-123',
          'Headphones', 
          ['Audio', 'Headphones'], 
          'https://cdn.example.com/p/123.jpg',
          199.99,
          'USD'
        )
        .setBrand('Acme')
        .setSalePrice(149.99)
        .setStock(42);

    await window.insider.itemPurchased('sale-789', product, { campaign: 'spring_sale' });
}
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
