# na_ios/coredata モジュール
coredataを扱いやすくするモジュール．
特に非同期アクセス周りを隠蔽するのが目的．

一番重要なのは`categories/NSManagedObjectContext+na`．

tableなどに使う時はna_ios/coredata_uiモジュールもあわせて使うこと．

依存元：**なし**  
依存先: **na_ios/coredata_ui**, **na_ios/coredata_sync**

# categoriesパッケージ
各種コアデータに関わるクラスのカテゴリが入っている．ヘルパー的な扱い．
APIを生やしているだけのものがほとんど．

NSFetchRequest, NSManagedObjectContext, NSPredicate, NSManagedObjectの4種類．
#### categories/NSPredicate+na
NSDictionaryか、NSArrayからPredicateを作成する．
NSDictionaryの方は`@"%K == %@", key, val`で評価
NSPredicateは直接は使わず、下記の3つを使ってアクセスするのが良い．

#### categories/NSManagedObjectContext+na

contextにCRUD操作を生やしているだけ．
こちらも出来るだけ下のmoのAPIから呼び出すのが良い．

#### categories/NSManagedObject+na

moにCRUD操作を生やしているだけ．ただし、blockによるcallbackを引数に持つものは非同期．またメインスレッドで返ってくる．．

#### categories/NSFetchRequest+na
fetchRequestをupdateする．
（検索時に有用）

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


# サンプル

`categories/NSManagedObjectContext+na`の使用例．`TestObject`というMOのクラスがあった場合、


同期メソッドは以下のようになる．

```objective-c

	TestObject *obj = [TestObject create:@{@"name": @"test"} options:nil];
	NSArray *objs = [TestObject filter:@{@"name": @"test"} options:nil];
	TestObject *obj2 = [TestObject get_or_create:@{@"name": @"test"} options:nil];
	Bool bl = (obj == obj2) => YES

```

それに対して、非同期メソッドは次のようになる．

```objective-c

    [TestObject create:@{@"name": @"test2"} options:nil complete:^(id mo) {
        TestObject *pa = (TestObject *)mo;
    }];
    
    [TestObject filter:nil options:nil complete:^(NSArray *mos) {
        NSLog(@"%s|%d", __PRETTY_FUNCTION__, [mos count]);
    }];
    
    [TestObject get_or_create:@{@"name": @"test"} options:nil complete:^(id mo) {
        TestParent *pa = (TestParent *)mo;
    }];

```

また、自前でコンテキストを作成する場合は、

```objective-c

    NSManagedObjectContext *mainContext = [ModelController sharedController].mainContext;
    NSPersistenceStoreCoordinator *coordinator = mainContext.persistentStoreCoordinator;
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:coordinator];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:context queue:nil usingBlock:^(NSNotification *note) {
        [mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                    withObject:note
                                 waitUntilDone:YES];
    }];

    [context performBlock:^{
        // !!!!!!ここでいろいろと変更を加える!!!!!!
        [context save:nil];
    }];

```

となり、けっこう面倒．ここはもう少し単純化すべきか．．



