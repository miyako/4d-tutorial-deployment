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

CEFを削除して署名と公証をすればサンドボックス環境でクラッシュしない。

ただし，*WebViewerCEF.bundle* だけでなく，シンボリックリンクも削除する必要がある。

## セキュリティグループを設定すれば良い?

メインアプリケーションとCEFのヘルパーアプリケーションは同一のセキュリティグループに属する必要がある。

* `com.apple.security.application-groups`をメインアプリケーションの`CFBundleIdentifier`に合わせる

* 4D Helper, 4D Helper (GPU), 4D Helper (Plugin), 4D Helper (Renderer)の`CFBundleIdentifier`の接頭辞にメインアプリケーションの`CFBundleIdentifier`を追加する

* 各ヘルパーの*entitlements* は`com.apple.security.app-sandbox`と`com.apple.security.inherit`だけにする

**解説**: 本体とヘルパーはプロセス間通信をするので，これがセキュリティホールとならないように対策を講じる必要がある。

## 自動アップグレードサーバーは?

サンドボックスを有効にすると，下記ファイルにアクセスできないため，エラーになる。

```
ファイル "info.json" を開くことができません: 

* Server.app:Contents:Upgrade4DClient:info.json)

xtoolbox
task -4, name: 'クライアントマネージャー'
Error code: 1 (POSX)
Operation not permitted
```

当該ファイルを署名しても問題はエラーは解消されない。

## その他

`Application Support`は*Containers* 経由でアクセスするため

```
/Library/Containers/{appName}/Data/Library/Application Support/{appName}
```

`{appName}`（クライアントであれば`{appName} Client`）以外はアクセスできない。

`LAUNCH EXTERNAL PROCESS`経由で`diskutil`などのコマンドが実行できない。

クライアントは*Caches* にライブラリをダウンロードするのでブロックされる。

```
~/Library/Caches/{appName} Client/{appPublishName}_100_64_1_98_19813_488/Libraries/lib4d-arm64.dylib' not valid for use in process: library load disallowed by system policy)
```

## 結論

* クライアント/サーバーのサンドボックスは極めて困難。

* デスクトップはサンドボックスできる。

