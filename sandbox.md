# com.apple.security.app-sandbox
おぼえがき

## 概要

CEFアプリにサンドボックスのエンタイトルメントを付与してコード署名すると，*ThreadPoolSingleThreadForegroundBlocking0*スレッドがクラッシュする。

CEFを使用したアプリケーションで，サンドボックスされている事例が存在するか調べてみた。

```
codesign -dvvv --entitlements - {app}
```

#### [Applications using CEF](https://en.wikipedia.org/wiki/Chromium_Embedded_Framework#Applications_using_CEF)

|App|Sandbox|
|:-|:-|
|QQ|YES|
|Slack|NO|
|zoom.us|NO|
|Spotify|NO|
|Google Chrome|NO|

* Slack, zoom.usなどは，サンドボックスのエンタイトルメントがないまま，App Storeに出品されている。下記のルールがあるが，何らかの理由で例外扱いになっているものと思われる。

> To distribute a macOS app through the Mac App Store, you must enable the App Sandbox capability.
https://developer.apple.com/documentation/security/app_sandbox

* Google Chrome, Spotifyは，サンドボックスのエンタイトルメントがなく，App Storeに出品されていない。

* QQは，成功しているようだが，Appleの証明書で署名されているなど，不明な点がある。

## CEFを削除すれば良い?

CEFを削除して署名と公証をすればサンドボックス環境でクラッシュしないことが確認できた。

[0.0.26](https://github.com/miyako/4d-tutorial-deployment/releases/tag/0.0.26)

## アプリケーショングループを設定すれば良い?

メインアプリケーションとCEFのヘルパーアプリケーションは同一のセキュリティグループに属する必要がある。

#### app

* `CFBundleIdentifier`: org.fourd.SAMPLE
* `com.apple.security.app-sandbox`: true
* `com.apple.security.application-groups`: Y69CWUC25B.org.fourd

#### 4D Helper, 4D Helper (GPU), 4D Helper (Plugin), 4D Helper (Renderer)

* `CFBundleIdentifier`: Y69CWUC25B.org.fourd.com.4d.cefProcessHandler
* `com.apple.security.app-sandbox`: true
* `com.apple.security.inherit`: true

