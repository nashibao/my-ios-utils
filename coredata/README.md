# na_ios/coredata
coredataを扱いやすくするモジュール．
特に非同期アクセス周りを隠蔽する．
## categories
各種カテゴリが入っている．ヘルパー的な扱い．
NSFetchRequest, NSManagedObjectContext, NSPredicate, NSManagedObject
### categories/NSFetchRequest+na
fetchRequestをupdateする．検索などに便利
### categories/NSPredicate+na
dictionaryからPredicateを作成する．

`+ (NSPredicate *)predicateForEqualProps:(NSDictionary *)equalProps;`  
`+ (NSPredicate *)predicateForProps:(NSArray *)props;`  
`(NSDictionary*)equalProps`のほうは`==`による評価のみ．
（具体的には`@"%K == %@", key, val`で評価する．）
`(NSArray*)props`の方は自由．

### categories/NSManagedObjectContext+na

contextにCRUD操作を生やしているだけ．

### categories/NSManagedObject+na

moにCRUD操作を生やしているだけ．ただし、blockによるcallbackを引数に持つものは非同期．またメインスレッドで返ってくる．．

## controllers

### controllers/NAModelController  
modeldファイル(`hoge.modeld`)の名前(`hoge`)を`name`に設定して、`setup()`を呼べば、以下のことをやってくれる
 - coordinatorの作成
 - bundleからの初期コピー（bundle内に`hoge.sqlite`ファイルを入れておけば、初期状態としてそちらを使う．でかいデータの時に便利）
 - mainthread上のcontextの作成

また`destroyAndSetup`を呼ぶと、sqliteファイルを削除して、もう一度最初からやり直す．

## models

### models/NSDictionaryTransformer

dictionaryとsqlite内のバイナリを自動変換するクラス

