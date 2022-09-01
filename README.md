# 4d-tutorial-deployment
アプリケーションビルド（Mac編）

## 概要

Apple Silicon/Intelネイティブのハイブリッドアーキテクチャ（Universal Binary 2）アプリをビルドし，ネットワーク経由で配付できるようにコード署名と公証に対応するための手順を説明します。アプリケーションフォルダーにインストールすることができ，ファイルシステムやネットワークにアクセスしてもクラッシュしないようなアプリをビルドするためには，こうした手順を踏む必要があります。

## 準備

#### プロジェクトを作成します。

<img width="778" alt="project" src="https://user-images.githubusercontent.com/1725068/187541919-85b2a1f7-b171-4966-a125-3dd609867563.png">

[`c7dbedd`](https://github.com/miyako/4d-tutorial-deployment/commit/c7dbeddb01c7ef2ee433eacd82951452b9dc4bba)

**ポイント**: ARM (Apple Silicon) ターゲットのコンパイルをするためには，プロジェクトモードでアプリケーションを開発する必要があります。バイナリモード（いわゆるストラクチャファイル）はインタープリターモード専用なので，ビルドすることができません。

## コンパイル

* 設定＞ストラクチャ設定
 
**コンパイラー**ページを開き，**コンパイル対象CPU**を**全てのプロセッサ**に設定します。

<img width="860" alt="スクリーンショット 2022-08-31 13 22 28" src="https://user-images.githubusercontent.com/1725068/187593957-89e9991d-e69c-4af3-ab34-3d5153fa9ee7.png">

## Xcodeのインストール

ARM (Apple Silicon) ターゲットのコンパイルをするためには，[Xcode](https://apps.apple.com/us/app/xcode/id497799835)がインストールされていなければなりません。

<img width="530" alt="xcode" src="https://user-images.githubusercontent.com/1725068/187549852-104612a0-fb07-4035-bd73-6e970795aa46.png">

インストール後，最初の起動時にコマンドラインツール（追加コンポーネント）のインストールが始まるはずです。コマンドラインツールがインストールされてない場合，``xcode-select --install``でダウンロードしてください。

<img width="573" alt="スクリーンショット 2019-11-12 23 49 09" src="https://user-images.githubusercontent.com/1725068/68681678-28c68e80-05a7-11ea-9a01-e1f93b939886.png">

ARM (Apple Silicon) ターゲットのコンパイルをするためにXcodeのアップデートが必要な場合，下記のメッセージが表示されます。

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
* `(Data file=Folder(Get 4D folder(Database folder);fk platform path).folder("Default Data").file("default.4DD").platformPath)`
* `(Is data file locked)`

上記の条件が満たされたなら，`OPEN DATA FILE`または`CREATE DATA FILE`で運用データファイルを作成または使用します。これらのコマンドはアプリケーション再起動前に実行される最後のコマンドであるべきです。既存のスタートアップコードとは相互に排他的な処理になるようにプログラムする必要があります。

* ユーザー設定ファイルもデフォルトデータフォルダーから運用データファイルにコピーします。

## ログファイル

* デザイン＞設定＞データファイル用のユーザー設定

**バックアップ**ページを開き，**ログを使用**を解除します。

<img width="860" alt="スクリーンショット 2022-08-31 11 59 49" src="https://user-images.githubusercontent.com/1725068/187584635-05db6dab-0a98-4027-9f7e-392b5fa63634.png">

デフォルトデータファイルを使用している間は，データベースが書き込み保護されており，まだログファイルを有効にすることはできません。運用データファイルに切り替わった後，ログファイルを使用する条件が満たされているかチェックするコードをスタートアップで実行します。

* `(Version type ?? Merged application)`
* `(Application type=4D Volume desktop) | (Application type=4D Server)`
* `(Log file="")`
* `(Not(Is data file locked))`

`SELECT LOG FILE`でログファイルを作成する場所を決定します。ログファイルは次回のバックアップ完了後から使用されるようになります。

## アイコンファイル

アプリのアイコンをカスタマイズするには，Finderの「情報を見る」ダイアログではなく，ビルドプロジェクトの``ServerIconMacPath`` ``RuntimeVLIconMacPath`` ``ClientMacIconForMacPath``を使用し，``icns``ファイルのパスを指定します。``icns``ファイルを作成するには，必要なサイズの``.png``画像を``.iconset``という拡張子のフォルダーに入れ，下記のコマンドラインを実行します。

```
iconutil -c <path>
```

単一フレームの``icns``画像では，カスタムアイコンが表示されません。``.png``画像は，``sips``でリサイズすることができます。

```
sips -z <pixelsH> <pixelsW> <path>
```

c.f. [Macアプリの.icnsを作るときのメモ](https://qiita.com/Jacminik/items/a4c8fe20a4cba62f428b)

## コード署名と公証

初期のMac OS Xでは，作成したアプリを``.zip`` ``.pkg`` ``.dmg``などのファイル形式に圧縮し，ユーザーのマシンにダウンロードしてインストールすることができました。Mac OS X 10.7 Lion以降，ユーザーがインターネットからダウンロードしたアプリは，システムに統合された防御機構（[GateKeeper](https://support.apple.com/ja-jp/HT202491)）が初回の起動時にセキュリティのチェックを実施します。GateKeeperの設定は，システム環境設定の「セキュリティとプライバシー（一般）」で確認および変更することができます。

10.8 Mountain Lion以降，デフォルトの設定は「App Storeと確認済みの開発元からのアプリケーションを許可」です。App Storeではない場所からダウンロードしたアプリは，[Apple Developer Program](https://developer.apple.com) に登録された開発元の有効な**コード署名**が確認できない場合，GateKeeperは起動をブロックします。

10.15 Catalina以降，コード署名に加え，**公証**（[**ノータリゼーション**](https://developer.apple.com/documentation/xcode/notarizing_your_app_before_distribution?language=objc)）が確認できないアプリは，デフォルトで起動を許可しない設定になりました。公証とは，プログラムがマルウェアのように自己を改竄したりしないことを保証するために，Appleが運営している申告・判定・登録システムのことです。GateKeeperは，初回の起動でアプリが公証にパスしたことを証明する電子的なチケット（ステープル）の存在をチェックします。チケットが確認できない場合，Appleのサーバーにアクセスし，そのアプリが公証にパスしたものかどうか，公証データベースに問い合わせます。

4Dおよび4D Serverは署名されていますが，ビルドしたアプリは，4Dから派生した「別アプリ」に該当するため，デベロッパー各自が署名や公証を実施しなければなりません。具体的には，下記のリソースに署名を実施し，公証のチケットを発行してもらうことが必要です。

* ビルドアプリ（本体）
* 4Dに標準で付属しているアプリ（``Updater`` ``InstallTool`` [17r5以降]）
* 4Dに標準で付属している実行ファイル（``php-fcgi-4d`` ``HelperTool`` ``InstallTool`` [17r4以前]）
* その他の実行バンドル（フレームワーク・プラグイン）
* その他の実行ファイル（``.js`` ``.html`` ``.json`` ``LAUNCH EXTERNAL PROCESS``で起動する外部プログラム）

コード署名が確認できた場合，下記のようなメッセージが初回の起動時にだけ表示されます。

```
…はインターネットからダウンロードされたアプリケーションです。開いてもよろしいですか?
このファイルは"Safari"により…ダウンロードされました。
```

コード署名が確認できない場合，下記のような警告メッセージが表示されます。

```
…は，開発元を検証できないため開けません。
このアプリケーションにマルウェアが含まれていないことを検証できません。
```

ユーザーは，開発元が信頼できると判断できる場合，``control``キーを押しながらアプリをクリックし，「Mac のセキュリティ設定を一時的に無視して」アプリを起動することができます。また，インターネット経由ではなく，接続した外部ドライブ等からコピーしたファイルであれば，そのまま開くことができます。ですから，**4Dで開発したアプリを配付するために，署名と公証が絶対に必要というわけではありません**。それでも，利便性とユーザーエクスペリンスの観点から，実施することが勧められています。

* [Mac で App を安全に開く](https://support.apple.com/ja-jp/HT202491)

コード署名に問題がある場合，下記のような警告メッセージが表示されます。このようなアプリを開くことはできません。

```
…は，壊れているため開けません。ゴミ箱に入れる必要があります。
このファイルは"Safari"により…ダウンロードされました。
```

下記のようなコマンドをターミナルに入力し検疫フラグ（アプリがネットワーク経由でダウンロードされたという印）や問題のあるコード署名を取り除くことができます。

```
xattr -cr {application_path}
codesign --remove-signature {application_path}
```

署名と公証を実施するために必要なものは下記のとおりです。

* [macOS 10.14.5以降](https://developer.apple.com/jp/news/?id=04102019a)がインストールされたMac
* [Apple ID の２ファクタ認証](https://support.apple.com/ja-jp/HT204915)
* [App用パスワード](https://support.apple.com/ja-jp/HT204397)
* [Apple Developer Program](https://developer.apple.com/jp/programs/)の有効なメンバーシップ（無料メンバーはNG）
* [Xcode 10以降](https://developer.apple.com/jp/xcode/)
* Developer ID 証明書

#### Apple Developer Program

Apple Developer Programには，[無料のプログラム](https://developer.apple.com/jp/support/compare-memberships/)も用意されていますが，「App StoreでのApp配信」および「Mac App Store以外でのソフトウェア配信」が特典に含まれていません。無料のメンバーシップでは，Developer ID 証明書の発行ができないためです。署名と公証には，Developer ID 証明書が必要です。

#### Apple ID

Apple IDは，Mac，iOSデバイス，アプリ，オンラインいずれかの方法で作成することができます。Macユーザーであれば，すでに保有しているかもしれません。

* [デバイスの設定時に作成した](https://support.apple.com/ja-jp/HT204316#setup)
* [App Storeで作成した](https://support.apple.com/ja-jp/HT204316#appstore)
* [iTunesで作成した](https://support.apple.com/ja-jp/HT204316#itunes)
* [Webで作成した](https://support.apple.com/ja-jp/HT204316#web)

アプリ開発用に新しいアカウントを作成することもできますが，**２ファクタ認証**を有効にする必要があり，原則的に２台以上のApple機器で同じApple IDを使用していることが想定されているので，個人のApple IDをそのまま使用したほうが簡単かもしれません。

**注記**: Apple機器が１台だけの場合，電話で２ファクタ認証を完了することができます。

#### ２ファクタ認証

２ファクタ認証は，古典的なユーザー名とパスワードの組み合わせを知っていること（第１ファクター：知識）に加え，当該ユーザーの個人的な電子機器を持っていること（第２ファクター：デバイス）を本人確認の根拠にするという仕組みです。具体的には，６桁の**確認コード**を電話などに送信し，入力させることにより，ユーザーを認証します。Apple IDの場合，２ファクターは任意ですが，Apple Developer IDの場合，２ファクターは必須となっています。

Apple IDでログインして，Apple Developer Programに加入の手続きを開始します。２ファクタ認証が有効にされていなければ，このとき設定を済ませるよう案内されます。支払いが完了すると，数時間後に手続き完了の通知メールが送られるはずです。

最新版のmacOSおよびXcodeは，App Storeから入手することができます。古いバージョンのXcodeがアプリケーションフォルダーにインストールされている場合，アプリケーションは上書きされます。以前のXcodeを残しておきたいのであれば，サブフォルダーなど，あらかじめ別の場所に退避してください。

**注記**: [Apple Developer](https://developer.apple.com/download/)にログインすると，開発中（ベータ版）および旧バージョンのソフトウェアがダウンロードできます。

#### コマンドラインツール

4Dアプリの署名と公証は，Xcodeアプリではなく，コマンドラインツール経由で実施します。Xcodeのコマンドラインツールは，``xcrun``コマンドを介して実行します。``xcrun``はデフォルトの場所にインストールされているXcodeの内部にあるプログラムを実行するようになっています。デフォルトのパスは下記のコマンドラインで確認することができます。

```
xcode-select -p
```

複数のXcodeがインストールされている場合，あるいは標準的ではない場所にXcodeがインストールされている場合，

```
xcode-select --switch <path>
```

ただし，他の開発ツールに影響を与える恐れがあるので，環境変数の``DEVELOPER_DIR``で一時的にパスを変更したほうが無難かもしれません。

#### 電子証明書

Xcodeを起動し，アプリケーションメニューの「Preferences」から「Accounts」のページを開きます。Developer IDを入力し，ログインします。

<img width="400" alt="スクリーンショット 2019-10-17 17 00 06" src="https://user-images.githubusercontent.com/1725068/66989622-abbb0d00-f0ff-11e9-88df-0fa4d2669863.png">

「Manage Certificates」をクリックし，画面の左下にある「＋」アイコンをクリックして，「Developer ID Application」および「Developer ID Installer」証明書を作成します。

**注記**: 無料のApple Developer IDでログインしている場合，Developer ID系の証明書は作成できません。「Mac Developer」証明書は作成できますが，これは個人のデバイスでアプリをテストするための証明書であり，アプリを配付する目的では使用できないものです。

<img width="400" alt="スクリーンショット 2019-10-17 17 06 07" src="https://user-images.githubusercontent.com/1725068/66990143-9d212580-f100-11e9-8ecf-df83a1fb2a7a.png">

#### [App用パスワード](https://support.apple.com/ja-jp/HT204397)

配付用アプリの公証は，ビルド毎に実行する必要があるので，自動化しておくと便利です。その場合，パスワードの入力を自動化するために，**App用パスワード**を作成しておきます。パスワードは，Apple IDのアカウントページにログインし，「セキュリティ」セクションの「App 用パスワード」の下の「パスワードを生成」をクリックすれば自動的に作成されます。「このパスワードのラベルを入力」には，後で参照できる簡単な文字列（例：``abcde``）を入力します。

[appleid.apple.com](https://appleid.apple.com/#!&page=signin)にログインします。

<img width="515" alt="スクリーンショット 2019-11-07 16 50 34" src="https://user-images.githubusercontent.com/1725068/68369989-d9cfc200-017e-11ea-8e2c-22e4c0339ab0.png">

２ファクタ認証のサインインを許可します。

<img width="480" alt="スクリーンショット 2019-11-07 16 52 07" src="https://user-images.githubusercontent.com/1725068/68370104-0daae780-017f-11ea-8655-5f7529fb7c10.png">

<img width="490" alt="スクリーンショット 2019-11-07 16 53 00" src="https://user-images.githubusercontent.com/1725068/68370127-1ac7d680-017f-11ea-947c-5d116a06c14c.png">

<img width="515" alt="スクリーンショット 2019-11-07 16 53 32" src="https://user-images.githubusercontent.com/1725068/68370173-36cb7800-017f-11ea-9d4f-6da0a61722dc.png">

**セキュリティ**に移動します。

<img width="515" alt="スクリーンショット 2019-11-07 16 57 07" src="https://user-images.githubusercontent.com/1725068/68370363-a9d4ee80-017f-11ea-815c-3ea98bdaf336.png">

**パスワードを生成…**をクリックします。

**パスワードのラベル**には任意の英数字（空白はOK，記号はNG）を入力します。

<img width="646" alt="スクリーンショット 2019-11-12 23 57 55" src="https://user-images.githubusercontent.com/1725068/68682309-48aa8200-05a8-11ea-9ff7-accc4de93bc3.png">

App用パスワードは``25``まで作成することができます。

**セキュリティ**の「**編集**」ボタンをクリックすると，App用パスワードの**履歴を表示**することができ，削除することもできます。ラベルは，この画面でパスワードを管理するためのものです。同じラベルを使用しても，毎回，違うパスワードが発行されます。

<img width="515" alt="スクリーンショット 2019-11-07 17 19 32" src="https://user-images.githubusercontent.com/1725068/68371901-0ab1f600-0183-11ea-8130-4cf725a12f6a.png">

#### コード署名ツール

コード署名には下記いずれかのツールを使用します。

* `altool`（旧）
* `notarytool`（新）

署名には，前述の手順で作成したpp用パスワードが必要です。そのままパラメーターに渡すこともできますが，できればパスワードを**キーチェーン**に保存し，登録名で参照することが勧められています。

* altool

```
xcrun altool --store-password-in-keychain-item <item_name> -u <apple_developer_id> -p <secret_password>
```

これにより，キーチェーンにアプリ用のパスワードが保存され，下記のようなコマンドラインでパスワードが参照できるようになります。

```
xcrun altool --notarize-app -u <apple_developer_id> -p "@keychain:<item_name>"
```

* notarytool

```
xcrun notarytool store-credentials <item_name> --apple-id <apple_developer_id> --team-id <apple_developer_team_id> --password <secret_password>
```

これにより，キーチェーンにアプリ用のパスワードが保存され，下記のようなコマンドラインでパスワードが参照できるようになります。

```
xcrun notarytool --keychain-profile <item_name>
```
#### エンタイトルメント

アプリのコード署名には，アプリの実行に必要な**エンタイトルメント**が組み込まれることになっています。エンタイトルメントは，XML形式のプロパティリスト（``.plist``）で編集します。XML形式の``.plist``をそのままコード署名に使用することはできません。バイナリ形式の``.plist``に変換する必要があります。ファイル形式を変換するには，下記のようなコマンドラインを実行します。

```
plutil -convert xml1 <path>
```

エンタイトルメントを必要とするようなアプリは，マルウェアではないことを保証するため，書き込みが禁止された実行環境（**Hardened Runtime**）で動作することが求められています。

4Dの場合，アプリ本体に加え，``php-fcgi-4d`` ``HelperTool`` ``Updater`` ``InstallTool``といった実行ファイルが組み込まれているため，それぞれに対し，Hardened Runtimeオプションを付けてコード署名を実施する必要があります。

```
codesign --options=runtime --entitlements <path>
```

プラグイン・フレームワーク・ライブラリなど，実行ファイルがロードする個別のファイルにHardened Runtimeオプションを付ける必要はありません。

#### タイムスタンプ

公証アプリは，セキュアなタイムスタンプを付けて署名されていなければなりません。そのためには，インターネットに接続された状態で``codesign``を実行し，下記のオプションを指定する必要があります。

```
codesign --timestamp
```

#### プラットフォームSDK

公証アプリは，macOS 10.9 SDK以降で開発されていなければなりません。4D本体は，この条件をクリアしていますが，個別のプラグイン・フレームワーク・ライブラリはそうではないかもしれません。そのような場合，macOS 10.9 SDK以降で再コンパイルする必要があります。

アプリ・プラグイン・フレームワークなどの「バンドル」フォルダーは，再帰的にコード署名を実施することができます。

```
codesign --deep
```

``--deep``オプションは，すでに署名されているリソースの署名は上書きしません。コード署名は，原則的にフォルダー構造の中から外に向かって実施します。4Dの場合，プリインストールされたアプリや実行ファイルにはエンタイトルメントとHardened Runtimeオプションを指定して署名します。プラグイン・フレームワーク・ライブラリなどのリソースは，エンタイトルメントを指定せずにコード署名を実施します。最後に外殻のアプリ本体を署名しますが，このとき``--force``（強制的に署名）オプションを指定してしまうと，内部リソースの署名が無効になってしまうので，すでに署名が済んでいるリソースの外部では``--force``オプションを指定はしないでください。

#### バンドル識別子

4Dプラグインには，歴史的な経緯により，``4DCB``というバンドル識別子（``CFBundlePackageType``）が設定されていました。Appleの公証は，``BNDL`` ``APPL`` ``FMWK``のような標準バンドル識別子でなければ，包括的なチェックを実施しないようです。プラグインのバンドル識別子は，``BNDL``に設定する必要があります。

アプリ・プラグイン・フレームワークなどの「バンドル」の内部には，``Info.plist``という名称のカタログファイルが存在します。このファイルには，バンドルの基本的な情報が辞書形式（キー/値ペア）で書き込まれていますが，``CFBundleName`` ``CFBundleExecutable`` 等のキー値が実際のファイル名と完全に一致しない場合，たとえば小文字の代わりに大文字が使用されている場合，コード署名エラーになります。

```
invalid Info.plist (plist or signature have been modified)
```

コード署名に使用する証明書が署名のアイデンティーとなります。アプリに署名するのであれば，``Developer ID Application:…``証明書，インストーラーに署名するのであれば，``Developer ID Installer:…``証明書をアイデンティーとして使用します。

キーチェーンに登録されている証明書は，下記のコマンドラインでリストアップすることができます。

```
security find-identity -p basic -v
```

#### ステープル

ユーザーがアプリをダウンロードした後，初回の起動でアプリが公証にパスしたことを証明する電子的なチケット（ステープル）の存在をチェックします。チケットが確認できない場合，Appleのサーバーにアクセスし，そのアプリが公証にパスしたものかどうか，公証データベースに問い合わせます。

下記のコマンドラインでチケットをアプリに紐付ける（ステープルする）ことができます。アプリが公証にパスした後でなければ，ステープルはできません。紐付けは，ディスクイメージやインストーラーではなく，アプリ自体に対して実行します。コマンドは，インターネットに接続された状態で実行する必要があります。

```
xcrun stapler staple <path>
```

サンプルプログラムにインストールされている*builder*コンポーネントの`SignApp`クラスには，コード署名や公証に必要なコマンドラインツールが実装されています。

* altool - 公証
* notarytool - 公証
* stapler - ステープル
* codesign - コード署名
* ditto - .zipを作成
* hdiutil - .dmgを作成
* install_name_tool - ダイナミックリンクライブラリの参照パスを書き換え
* pkgbuild - .pkgの作成
* productsign - .pkgの署名
* xcode-select - Xcodeの管理
* security - キーチェーンの検索
* plutil - プロパティリストの編集

コンポーネントを使用すれば，オブジェクト指向のシンプルなAPIでコード署名と公証を済ませることができます。[例題](https://github.com/miyako/4d-tutorial-deployment/blob/main/README.md#例題)

## ビルド

デザインモードの**アプリケーションビルド**画面を使用すれば，基本的な項目が設定できます。より細かくビルド過程を制御するためには，作成したビルド設定XMLファイルと`BUILD APPLICATION`コマンドを使用し，ログファイルを解析することが求められます。

サンプルプログラムにインストールされている*builder*コンポーネントの`BuildApp`クラスには，`BUILD APPLICATION`コマンドの全オプションが実装されています。

コンポーネントを使用すれば，オブジェクト指向のシンプルなAPIでビルドを済ませることができます。[例題](https://github.com/miyako/4d-tutorial-deployment/blob/main/README.md#例題)

## 例題

*build*コンポーネント`test_build`メソッド

```4d
/*
	
	* ビルド
	
*/

$buildApp:=cs.BuildApp.new()

$buildApp.findLicenses(New collection("4DOE"; "4UOE"; "4DDP"; "4UUD"))
$isOEM:=($buildApp.settings.Licenses.ArrayLicenseMac.Item.indexOf("@:4DOE@")#-1)

$buildApp.settings.BuildApplicationName:=Folder(fk database folder).name
$buildApp.settings.BuildApplicationSerialized:=True
$buildApp.settings.BuildMacDestFolder:=Temporary folder+Generate UUID
$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt:=True
$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=$buildApp.getAppFolderForVersion().folder("4D Volume Desktop.app").platformPath
$buildApp.settings.SourcesFiles.RuntimeVL.IsOEM:=$isOEM
$buildApp.settings.SignApplication.MacSignature:=False
$buildApp.settings.SignApplication.AdHocSign:=False

$status:=$buildApp.build()

/*
	
	署名
	
*/

$credentials:=New object
$credentials.username:="keisuke.miyako@4d.com"
$credentials.password:="@keychain:altool"
$credentials.keychainProfile:="notarytool"
$credentials.certificateName:="Developer ID Application: keisuke miyako (Y69CWUC25B)"

$signApp:=cs.SignApp.new($credentials)

$app:=Folder($buildApp.settings.BuildMacDestFolder; fk platform path).folder("Final Application").folder($buildApp.settings.BuildApplicationName+".app")

$status.sign:=$signApp.sign($app)

/*
	
	公証 
	
*/

$status.archive:=$signApp.archive($app; ".pkg")

$status.notarize:=$signApp.notarize($status.archive.file)
```

## サンプルビルド

`test_build_app`メソッドを実行して`.pkg`または`.dmg`形式の署名/公証アーカイブを作成しました。[`0.0.20`](https://github.com/miyako/4d-tutorial-deployment/releases/tag/0.0.20)

```4d
If ($status.build.success)
	If ($status.archive.success)
		If ($status.notarize.success)
			SHOW ON DISK($status.app.platformPath)
		End if 
	End if 
End if 
```

[`505bca8`](https://github.com/miyako/4d-tutorial-deployment/commit/505bca8adeabbeec6ede7f9e381a28f37027e167)

* `updatePatch()`: パッチ番号をインクリメントします。このバージョンコードが`Info.plist`に書き込まれます。
* `buildDesktop()`: ビルド/署名/アーカイブ/公証まで一連の処理を実行します。

## 資料/文献

* [v17とv18の4Dアプリケーションのビルドを公証する](https://4d-jp.github.io/tech_notes/20-02-25-notarization/)

* [デフォルトのデータフォルダーを定義する](https://developer.4d.com/docs/ja/Desktop/building.html#デフォルトのデータフォルダーを定義する)

* [ユーザー設定の有効化](http://developer.4d.com/docs/ja/Desktop/user-settings.html#ユーザー設定の有効化)

* [データファイルの管理](https://developer.4d.com/docs/ja/Desktop/building.html#データファイルの管理)

* [macOS Sierraとビルドアプリケーションの配付について](https://4djug.forumjap.com/t65-topic)

* [Mac版アプリケーションの仕上げと配付に関する情報](https://miyako.github.io/2019/10/16/notarization.html)
