# Insider Swift Demo

<p align="center">
  <img src="https://github.com/user-attachments/assets/960512c5-9bcc-43ae-8918-71fd9f63858f" width="300">

  <table align="center">
    <tr>
      <td><a href="https://useinsider.com/"> Insider </a></td>
      <td><a href="https://academy.useinsider.com/docs/ios-integration"> InsiderAcademy </a></td>
    </tr>
  </table>
</p>  

## Description

This Demo contains simple methods that you can use with the Insider SDK.

Note: You Can see the detailed usage of the methods used with the integration by examining the `AppDelegate.swift`, `ViewController.swift`, and `ViewController+UI` files.

## Preview

<table align="center">
  <tbody>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/65fc21b8-3ed7-4e15-96f1-6fdc750f9d95" width="400"></td>
    </tr>
  </tbody>
</table>

## Installation

`pod install` command in the home directory.

Replace partner name and app group value in `AppDelegate.swift` with your info.
Replace `insider` URL type in main target Info -> URL Types with your partner name. (This step is important to add test device with QR or Email in the panel.)
Change App Groups for `InsiderNotificationService` and `InsiderNotificationContent` files on targets.
Open the .xcworkspace file in Xcode.
Select a valid simulator or connected device.
Run the project.
