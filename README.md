# Insider Swift Demo

<p align="center">
  <img src="https://github.com/user-attachments/assets/960512c5-9bcc-43ae-8918-71fd9f63858f" width="300">

  <table align="center">
    <tr>
      <td><a href="https://useinsider.com/">Insider</a></td>
      <td><a href="https://academy.useinsider.com/docs/ios-integration">InsiderAcademy</a></td>
    </tr>
  </table>
</p>  

## Description

This Demo contains simple methods that you can use with the Insider SDK.

Note: You can see the detailed usage of the methods used with the integration by examining the `AppDelegate.swift`, `ViewController.swift`, and `ViewController+UI` files.

## Preview

<table align="center">
  <tbody>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/65fc21b8-3ed7-4e15-96f1-6fdc750f9d95" width="400"></td>
    </tr>
  </tbody>
</table>

## Installation

- Run `pod install` command under project's directory at where `Podfile` is located.
- Double-click `SwiftDemo.xcworkspace`.
- Update value `INSIDER_PARTNER_NAME` with desired partner name in file `AppDelegate.swift`. 
- Update value `APP_GROUP` with desired app groups identifier in files `AppDelegate.swift` `NotificationService.swift.swift` and `NotificationViewController.swift`. 
- You should also update app groups identifier to same value for all targets `SwiftDemo`, `InsiderNotificationService` and `InsiderNotificationContent` through `Signing & Capabilities` tab.
- Go to `SwiftDemo` target's `Info` tab, expand `URL Types` section and, update the url scheme `insiderpartnername` to a valid value such as `insidermyapp`.