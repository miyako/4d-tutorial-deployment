# 4d-tutorial-deployment
アプリケーションビルド（Mac編）

## 準備

#### プロジェクトを作成します。

<img width="778" alt="project" src="https://user-images.githubusercontent.com/1725068/187541919-85b2a1f7-b171-4966-a125-3dd609867563.png">

[`c7dbedd`](https://github.com/miyako/4d-tutorial-deployment/commit/c7dbeddb01c7ef2ee433eacd82951452b9dc4bba)

**ポイント**: ARM (Apple Silicon) ターゲットのコンパイルをするためには，プロジェクトモードでアプリケーションを開発する必要があります。バイナリモード（いわゆるストラクチャファイル）はインタープリターモード専用なので，ビルドすることができません。

---

## 参考: コンポーネントの管理（本題とは関係ありません）

コンポーネントは，プロジェクトと同階層の`Components`フォルダーにコンパイルされたファイル（.4DC/.4DZ）・パッケージ（.4dbase）・データベースフォルダーの形でインストールします。コンパイルは，大概，複数のプロジェクトで流用できる汎用的なモジュールなので，いろいろな場所にコピーをインストールするのではなく，一元的に管理したほうが便利です。そのためには，プロジェクトと同階層の`Components`フォルダーにエイリアスをインストールします。





## Xcodeのインストールとアップデート


## 資料/文献

* [v17とv18の4Dアプリケーションのビルドを公証する](https://4d-jp.github.io/tech_notes/20-02-25-notarization/) 

* [デフォルトのデータフォルダーを定義する](https://developer.4d.com/docs/ja/Desktop/building.html#デフォルトのデータフォルダーを定義する)

* [ユーザー設定の有効化](http://developer.4d.com/docs/ja/Desktop/user-settings.html#ユーザー設定の有効化)

* [データファイルの管理](https://developer.4d.com/docs/ja/Desktop/building.html#データファイルの管理)
