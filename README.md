# Card Action Mobile — Android Alpha
Experimental Flutter prototype. This is **not** a complete implementation of SKYJO Action. The alpha supports local pass-and-play only. Multiplayer, special action cards, star rules, scoring and round completion are pending.

## Automated APK
GitHub Actions > Build Android APK > latest successful run > Artifacts > card-action-android-debug-apk. Unzip the artifact and install app-debug.apk on an Android device.

## Local
Install Flutter SDK and Android SDK, then run:
```sh
flutter create --platforms=android --project-name card_action_mobile .
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

## Rights
This prototype uses original UI, no copied card art or brand assets. Obtain appropriate permissions before publishing a branded reproduction.
