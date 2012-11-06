# na_ios/coredata モジュール
na_ios/coredataは、扱うのに経験が必要なcoredataを、簡単に扱えるようにするモジュールです．

データの正しさとパフォーマンスの良さを両立するため、多くのAPIの内部ではスレッドを使い、なおかつ、それを隠蔽しています．

例えば、`TestObject`という`NSManagedObject`のクラスがあった場合、

```
[TestObject filter:@{@"name": @"test"} options:nil complete:^(NSArray *mos) {
    // 色々処理
}];
```

このように非同期メソッドの`complete`ハンドラに結果が渡されます．また`complete`ハンドラはmain threadで返ってくるため、ハンドラ内でUIの処理をしても、問題が無いようになっています．
非同期メソッドには`filter`の他に、`create`、`get`、`get_ore_create`などのAPIがあります．

```
[TestObject create:@{@"name": @"test2"} options:nil complete:^(id mo) {
	// hogehoge
}];

[TestObject get_or_create:@{@"name": @"test"} options:nil complete:^(id mo) {
	// hogehoge
}];
```

また、同じようにして、ハンドラを渡さない同期メソッドもあります．

```objective-c

	TestObject *obj = [TestObject create:@{@"name": @"test"} options:nil];
	NSArray *objs = [TestObject filter:@{@"name": @"test"} options:nil];
	TestObject *obj2 = [TestObject get_or_create:@{@"name": @"test"} options:nil];
	Bool bl = (obj == obj2); => YES
```

最後に、独自にcoredata上でスレッドを作成したい上級者向けには、次のようなメソッドがあります．

```objective-c

    [mainContext performBlockOutOfOwnThread:^(NSManagedObjectContext *context){
        // !!!!!!ここでいろいろと変更を加える!!!!!!
        [context save:nil];
    } afterSaveOnMainThread:^(NSNotification *note) {
        // !!!!!!終了処理!!!!!!
    }];
```

これは次の処理のラッパーになっています．


```objective-c

    NSManagedObjectContext *mainContext = [ModelController sharedController].mainContext;
    NSPersistentStoreCoordinator *coordinator = mainContext.persistentStoreCoordinator;
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:coordinator];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:context queue:nil usingBlock:^(NSNotification *note) {
        [mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                      withObject:note
                                   waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            // !!!!!!終了処理!!!!!!
        });
    }];
    
    [context performBlock:^{
        // !!!!!!ここでいろいろと変更を加える!!!!!!
        [context save:nil];
    }];


```


# パッケージ

# coredata/categories
コアデータに関わる各種クラスのカテゴリが入っているパッケージになります．

`NSFetchRequest`, `NSManagedObjectContext`, `NSPredicate`, `NSManagedObject`の4種類に対応しています．まずは`NSManagedObject`だけを使うのが良いでしょう．

#### `categories/NSManagedObject+na`

moにCRUD操作を生やすためのカテゴリ．blockによるcallbackを引数に持つものは非同期で、メインスレッドに返ってくきます．

#### `categories/NSFetchRequest+na`

#### `categories/NSManagedObjectContext+na`

contextにCRUD操作を生やすためのカテゴリ．`categories/NSManagedObject+na`で利用しています．

#### `categories/NSPredicate+na`

NSDictionaryか、NSArrayからPredicateを作成するもので、NSDictionaryの方は`@"%K == %@", key, val`で評価し、NSArrayの方は、評価式を順番に入れておくショートカットを持っています．基本的には上記の3つのクラスを用いてNSPredicateを直接は触らないようにするのが得策です．

# coredata/controllers

#### `controllers/NAModelController`  

modeldファイル(`hoge.modeld`)の名前(`hoge`)を`name`に設定して、`setup()`を呼べば、以下のことをやってくれます． 
 - coordinatorの作成  
 - bundleからの初期コピー（bundle内に`hoge.sqlite`ファイルを入れておけば、初期状態としてそちらを使う．でかいデータの時に便利）  
 - mainthread上のcontextの作成

また`destroyAndSetup`を呼ぶと、sqliteファイルを削除して、もう一度最初からやり直すことができます．

# coredata/models

#### `models/NSDictionaryTransformer`

dictionaryとsqlite内のバイナリを自動変換するクラス


# その他の情報

tableなどに使う時はna_ios/coredata_uiモジュールもあわせて使うこと．

依存元：**なし**  
依存先: **na_ios/coredata_ui**, **na_ios/coredata_sync**



