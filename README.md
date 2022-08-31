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

コンポーネントは，プロジェクトフォルダーの`Components`フォルダーにインストールします。下記いずれかのファイル形式がサポートされています。

1. .4DB
2. .4DC
3. .4DZ
4. .4dbase
5. プロジェクトフォルダー

.4DZは`Project`フォルダーをzip圧縮したファイル形式です。コンパイルされているとは限りません。

`Resources`などの関連フォルダーを含めるのであれば，.4dbaseまたはプロジェクトフォルダーをインストールする必要があります。

通常，コンポーネントには複数のプロジェクトに共通の汎用的なモジュールとして開発します。それぞれのプロジェクトのコンポーネントのソースコードをインストールするのでは管理が大変です。それで`Components`フォルダーにエイリアスをインストールすることが推奨されています。下記のように整理できるかもしれません。

* Components: エイリアス
* Components - Releases: コンパイル版のコンポーネント
* Components - Sources: コンポーネントのソースコード

<img width="778" alt="components" src="https://user-images.githubusercontent.com/1725068/187552949-2f206567-38bb-48f0-8014-cbaa2b394b42.png">

サンプルプロジェクトの*On Startup*には，依存コンポーネントのエイリアスを作成するコードが記述されています。

```4d
cs.Startup.new().linkComponents().restartIfNecessary()
```

サンプルプロジェクトのコンポーネントは，下記の要領でコンパイル→ビルド→インストールができるようになっています。

```4d
BuildApp.buildComponent()
```

## サンプルアプリケーション

ダイアログに現在時刻を表示するだけの簡単なプログラムです。

<img width="470" alt="dialog" src="https://user-images.githubusercontent.com/1725068/187561994-1b0650ee-b0e6-4f05-93a1-29956b5de9ca.png">

ちなみにフォームはアプリケーションプロセスで表示し，バックグラウンド処理はプリエンプティブモードのワーカーで実行しています。*On Timer*は使用していません。

<img width="852" alt="runtime" src="https://user-images.githubusercontent.com/1725068/187562171-dc37a323-01f5-4d33-91a3-9fcf58a04f1d.png">

[`55f2066`](https://github.com/miyako/4d-tutorial-deployment/commit/55f20667ded832cf4f358f49bec22ef5f392dd78)

## ユーザー設定

アプリケーションをビルドすると，データベースフォルダーの`Settings`フォルダーは読み書きができなくなります。設定ファイルを外部ファイルで管理するため，[ユーザー設定](http://developer.4d.com/docs/ja/Desktop/user-settings.html#ユーザー設定の有効化)を有効にする必要があります。

* データベース設定＞セキュリティ＞外部ファイルのユーザー設定を有効にする

<img width="860" alt="スクリーンショット 2022-08-31 13 22 28" src="https://user-images.githubusercontent.com/1725068/187592229-0537c20f-ae08-4e45-8696-f2814669bd8c.png">

* デザイン＞設定＞ユーザー設定

が管理できるようになります。

データファイルがストラクチャファイルとは別の場所にあれば，

* デザイン＞設定＞データファイル用のユーザー設定

も管理できるようになります。

* 設定＞ストラクチャ設定

**一般**ページを開き，**起動時モード**を**アプリケーション**に設定します。この項目はストラクチャレベルで設定する必要があります。

<img width="860" alt="スクリーンショット 2022-08-31 10 53 17" src="https://user-images.githubusercontent.com/1725068/187575383-b525e813-87de-4bfa-ab17-9ca1e8828968.png">

アプリケーションモードのスプラッシュ画面が不要であれば，**インタフェース**ページを開き，**ウィンドウの表示**の**スプラッシュスクリーン**を解除します。

<img width="860" alt="スクリーンショット 2022-08-31 13 20 12" src="https://user-images.githubusercontent.com/1725068/187592045-1922b71f-7e8c-4e59-9dd3-b117df20af19.png">

[`eec39b1`](https://github.com/miyako/4d-tutorial-deployment/commit/eec39b14c18b8721d296acb113327ccd1abb4b6e)

* ツールボックス＞メニュー

**モード**メニューを削除します。

<img width="762" alt="スクリーンショット 2022-08-31 13 21 06" src="https://user-images.githubusercontent.com/1725068/187592117-e046d1c2-c25c-4a13-8aa6-8c2686697b39.png">

**注記**: デザインモードには*option*+*command*+右クリックで移動できます。

## アバウト画面

`SET ABOUT`を使用し，「4Dについて」画面をカスタマイズします。

<img width="470" alt="スクリーンショット 2022-08-31 11 31 32" src="https://user-images.githubusercontent.com/1725068/187580368-d06f95e8-b56d-432f-977d-d0b78320a897.png">

## ログファイル

* デザイン＞設定＞データファイル用のユーザー設定

**バックアップ**ページを開き，**ログを使用**を解除します。

<img width="860" alt="スクリーンショット 2022-08-31 11 59 49" src="https://user-images.githubusercontent.com/1725068/187584635-05db6dab-0a98-4027-9f7e-392b5fa63634.png">

ログファイルはデフォルトデータファイルから運用データファイルに切り替えるタイミングで作成します（`SELECt LOG FILE`）。

## デフォルトデータファイル

プロジェクトフォルダーに`Default Data/default.4DD`というフォルダーが存在する場合，内容がビルドアプリケーション内にコピーされ，デフォルトのデータファイルとしてリードオンリーモードで使用されるようになっています。

* `Default Data`フォルダーを作成し，下記の項目をコピーします。

* データファイル `default.4DD` `default.Match` 
* インデックスファイル `default.4DIndx`
* 設定フォルダー `Settings`

<img width="778" alt="スクリーンショット 2022-08-31 12 35 33" src="https://user-images.githubusercontent.com/1725068/187587162-18c28b2d-02e8-4ef9-ae37-7f14331ce104.png">


データファイルを切り替える条件が満たされているかチェックするコードをスタートアップで実行します。

* `(Version type ?? Merged application)`
* `(Application type=4D Volume desktop) | (Application type=4D Server)`
* `(Data file=Folder(fk database folder).folder("Default Data").file("default.4DD").platformPath)`
* `(Is data file locked)`

## アイコンファイル

c.f. Macアプリの.icnsを作るときのメモ

## コンパイル

* 設定＞ストラクチャ設定
 
**コンパイラー**ページを開き，**コンパイル対象CPU**を**全てのプロセッサ**に設定します。

<img width="860" alt="スクリーンショット 2022-08-31 13 22 28" src="https://user-images.githubusercontent.com/1725068/187593957-89e9991d-e69c-4af3-ab34-3d5153fa9ee7.png">

## Apple Developer Program

T.B.C.

## ビルド

T.B.C.

## 署名と公証

T.B.C.

## 資料/文献

* [v17とv18の4Dアプリケーションのビルドを公証する](https://4d-jp.github.io/tech_notes/20-02-25-notarization/)

* [デフォルトのデータフォルダーを定義する](https://developer.4d.com/docs/ja/Desktop/building.html#デフォルトのデータフォルダーを定義する)

* [ユーザー設定の有効化](http://developer.4d.com/docs/ja/Desktop/user-settings.html#ユーザー設定の有効化)

* [データファイルの管理](https://developer.4d.com/docs/ja/Desktop/building.html#データファイルの管理)
