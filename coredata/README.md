# na_ios/coredata モジュール
coredataを扱いやすくするモジュール．
特に非同期アクセス周りを隠蔽するのが目的．

tableなどに使う時はna_ios/coredata_uiモジュールもあわせて使うこと．

依存元：**なし**  
依存先: **na_ios/coredata_ui**, **na_ios/coredata_sync**

# categoriesパッケージ
各種コアデータに関わるクラスのカテゴリが入っている．ヘルパー的な扱い．
APIを生やしているだけのものがほとんど．

NSFetchRequest, NSManagedObjectContext, NSPredicate, NSManagedObjectの4種類．
#### categories/NSFetchRequest+na
fetchRequestをupdateする．
（検索時に利用）
#### categories/NSPredicate+na
NSDictionaryか、NSArrayからPredicateを作成する．
NSDictionaryの方は`@"%K == %@", key, val`で評価

#### categories/NSManagedObjectContext+na

contextにCRUD操作を生やしているだけ．

#### categories/NSManagedObject+na

moにCRUD操作を生やしているだけ．ただし、blockによるcallbackを引数に持つものは非同期．またメインスレッドで返ってくる．．

# controllersパッケージ

#### controllers/NAModelController  
modeldファイル(`hoge.modeld`)の名前(`hoge`)を`name`に設定して、`setup()`を呼べば、以下のことをやってくれる  
 - coordinatorの作成  
 - bundleからの初期コピー（bundle内に`hoge.sqlite`ファイルを入れておけば、初期状態としてそちらを使う．でかいデータの時に便利）  
 - mainthread上のcontextの作成

また`destroyAndSetup`を呼ぶと、sqliteファイルを削除して、もう一度最初からやり直す．

# modelsパッケージ

#### models/NSDictionaryTransformer

dictionaryとsqlite内のバイナリを自動変換するクラス

