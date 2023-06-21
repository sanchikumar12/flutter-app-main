# grocapp

A new Flutter project.

# flutter sdk
```
1.22.6
```
[Download link - Windows](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_1.22.6-stable.zip)
[Download link - Linux](https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_1.22.6-stable.tar.xz)
[Download link - Mac Os](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_1.22.6-stable.zip)

## Building for API Level >=31
We need to add [safer component exporting](https://developer.android.com/about/versions/12/behavior-changes-12#exported) declaration to all dependencies/old or new
for deploying to playstore.

here's a handy grep to identify and add those declarations to dependencies
```
cd /c/Apps/flutter/.pub-cache/hosted/pub.dartlang.org
 grep -inr 'intent-filter' . | grep -v 'example'
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
