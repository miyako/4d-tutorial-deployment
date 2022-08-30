# 4d-tutorial-deployment
アプリケーションビルド（Mac編）

## 準備

#### プロジェクトを作成します。

<img width="778" alt="project" src="https://user-images.githubusercontent.com/1725068/187541919-85b2a1f7-b171-4966-a125-3dd609867563.png">

[`c7dbedd`](https://github.com/miyako/4d-tutorial-deployment/commit/c7dbeddb01c7ef2ee433eacd82951452b9dc4bba)

**ポイント**: ARM (Apple Silicon) ターゲットのコンパイルをするためには，プロジェクトモードでアプリケーションを開発する必要があります。バイナリモード（いわゆるストラクチャファイル）はインタープリターモード専用なので，ビルドすることができません。

## Xcodeのインストールとアップデート

ARM (Apple Silicon) ターゲットのコンパイルをするためには，[Xcode](https://apps.apple.com/us/app/xcode/id497799835)がインストールされていなければなりません。

<img width="530" alt="xcode" src="https://user-images.githubusercontent.com/1725068/187549852-104612a0-fb07-4035-bd73-6e970795aa46.png">

Xcodeのアップデートが必要な場合，下記のメッセージが表示されます。

<img width="708" alt="update" src="https://user-images.githubusercontent.com/1725068/187550580-9900eeb6-ff7f-4236-ac51-977e63ca073c.png">

HelperToolのインストールに失敗した，というメッセージが表示されることがあります。

<img width="480" alt="fail" src="https://user-images.githubusercontent.com/1725068/187550631-77d592b3-e03a-44c0-b6e9-d8051d340fa3.png">

コンパイルが途中まで進んでいた場合，その回は失敗に終わるかもしれません。

<img width="708" alt="error" src="https://user-images.githubusercontent.com/1725068/187550774-217ed7e4-7db4-4e4e-880b-9d95475fafa1.png">

**コンパイルコードを削除**して再コンパイルすれば成功するはずです。

## 【参考】コンポーネントの管理

<img width="708" alt="components" src="https://user-images.githubusercontent.com/1725068/187552850-eef85f20-abc4-43b6-8f72-2d0d4860c809.png">

## 資料/文献

* [v17とv18の4Dアプリケーションのビルドを公証する](https://4d-jp.github.io/tech_notes/20-02-25-notarization/)

* [デフォルトのデータフォルダーを定義する](https://developer.4d.com/docs/ja/Desktop/building.html#デフォルトのデータフォルダーを定義する)

* [ユーザー設定の有効化](http://developer.4d.com/docs/ja/Desktop/user-settings.html#ユーザー設定の有効化)

* [データファイルの管理](https://developer.4d.com/docs/ja/Desktop/building.html#データファイルの管理)
