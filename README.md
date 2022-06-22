# hatty_app

```bash
$ git clone git@github.com:sotayamashita/hatty_app.git
$ cd hatty_app

$ flutter clean
$ flutter pub get
$ flutter pub run flutter_native_splash:create
```

### iOS

```bash
$ flutter devices
N connected devices:

iPhone (mobile) • <UDID>

$ flutter run -d <UDID>
```

### troubleshooting

```bash
$ flutter run -d <UDID>
Error: To set up CocoaPods for ARM macOS, run:
  arch -x86_64 sudo gem install ffi

# solution
$ sudo arch -x86_64 gem install ffi
```