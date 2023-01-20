# Flutter Amplify Quickstart

This repo demonstrates how to get up and running with Flutter for cross-platform development, and AWS Amplify for rapid backend infrastructure provisioning.

![App Screenshot](/readme/app-screenshot.png)

## Prerequisites

* Flutter and dependent tools (XCode, Android Studio etc.)
* An AWS Account and AWS Amplify CLI installed

## Demoed Features

* MFA Authentication with pre-canned UI and AWS Cognito authz
* Profile Picture storage and upload functionality using AWS S3
* API interaction using AWS AppSync and GraphQL
## Getting Started

Check out this repository

Run the following commands to get started:

 `amplify init` to setup your local environment. Specify the AWS credentials you'd like to use

`amplify push` to provision the Auth, Storage and API features in your AWS Account

`dart pub get` to install all Dart dependencies.

`flutter run` to launch the app in the iOS emulator (if you're on Mac, otherwise it's an Android AVD if you have one set up)

If you see "No supported devices connected", you'll need to launch either an iOS or Android emulator. 

If you want to run an iOS emulator, you can use `open -a Simulator` to launch an iOS device emulator. If you want to launch an Android emulator you'll need to open Android Studio and create a new device in the AVD window.

Then run `flutter devices` in your console to ensure at least one of the above emulators is available. Try run `flutter run` again.

Taken from https://docs.flutter.dev/get-started/install/macos

If you have both iOS and Android emulators running and you want to specify which to target, you can use `flutter run -d <device-id>`

Open the project in your Flutter IDE of choice (VSCode for me)

Pick your mobile emulator of choice, then hit F5 to run the application.

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
