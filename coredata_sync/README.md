# `na_ios/coredata_rest` / `na_ios/coredata_sync`

`na_ios/coredata_rest(sync)`はRESTを介したデータベースの更新/同期システムです．サーバ-マルチデバイス構成でのデータベースの更新/同期はios環境においては、ニーズが高く、それに比例して難易度が高い問題です．マルチスレッドを有効利用することで、パフォーマンスを最大に担保するように気をつけて設計されています．


`na_ios/coredata_sync`は`na_ios/coredata_rest`に依存しています．`coredata_rest`はRESTを介したデータの更新のみを行い、同期には対応しません．`coredata_sync`は`coredata_rest`に”同期”の機能を付加したものです．


## 使い方

使い方に置いては、`coredata_sync`も`coredata_rest`も完全に同じです．設定で同期を有効にしておけば、同期は自動で行われます．

`na_ios/coredata`と同じく`NSManagedObject`のカテゴリAPIから利用します．違うのはAPIに`sync_`の接頭辞が付く、ということです．

例えば、サーバ側から`name=="test"`なデータを取ってくるには次のようにします．

```objective-c
[Object sync_filter:@{@"name": @"test"} options:nil complete:^(NSError *err) {
    // maincontextにマージされた後に呼び出される．
}];
```

`sync_filter`以外に以下のAPIがあります．

```objective-c
+ (void)sync_filter:(NSDictionary *)query
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
+ (void)sync_get:(NSInteger)pk
         options:(NSDictionary *)options
        complete:(void(^)(NSError *err))complete;
+ (void)sync_create:(NSDictionary *)query
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
+ (void)sync_update:(NSInteger)pk
              query:(NSDictionary *)query
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
+ (void)sync_delete:(NSInteger)pk
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
```

`query`パラメタは`NSDictionary`で指定し、`@{key: val}`において`key`がname属性、`val`がvalue属性になります．つまりHTTP GETであれば、`http://domain/endpoint?key=val`に翻訳されることが期待されます．

気の利いたRESTフレームワークであれば、より複雑なフィルタリング処理を許されていることでしょう．たとえばs-cubism社内で開発しているDjango用RESTフレームワーク（現状非公開）では、DjangoのORマッパーにおけるフィルタ処理の多くを許容しています．例えば、`@{@"name__icontains": @"test"}`とすれば、testが含まれるものがjson形式で返ってきます．

ただ、`coredata_rest`自体は`NSDictionary`形式でHTTPパラメタを渡しているだけなので、サーバ側のRESTの形式については仮定をしていません．プロジェクトに合ったサーバサイドのRESTライブラリを使うと良いでしょう．詳しいREST接続のカスタマイズについては後述します．

これらのAPIは見て分かる通り、すべて非同期メソッドになっています．`complete`ハンドラは`na_ios/coredata`と同じように、`mainContext`に変更がマージされてからmain thread上に返ってきます．そのため、直接`complete`ハンドラ上でUIを触っても問題ありません．

また、すでにCoreData上にあるデータの更新にはクラス関数ではなくインスタンス関数を使う事も出来ます．

```objective-c
- (void)sync_get:(NSDictionary *)options
        complete:(void(^)(NSError *err))complete;
- (void)sync_create:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
- (void)sync_update:(NSDictionary *)query
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
- (void)sync_update:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
- (void)sync_delete:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
```

この場合は、インスタンスが持つGlobal Unique ID(pk)を利用することになります．

## 同期処理について

”同期”とは"更新"に加えて次を可能とすることを言っています．

 - データの新旧、変更のコンフリクトを自動で判断し、処理する

iosのようなモバイルでのネィティブ環境がウェブブラウザと異なるのは、アプリを立ち上げたままマルチタスクのバックグランドに移し、3日後、1週間後にフォアグラウンドに移してきて、もう一度使われることがあることです．また、ウェブブラウザではページ遷移によってデータのほとんどが捨てられて新しく取得され直すのに対して、オフラインでの使用が想定されるモバイル環境では、多くのデータがキャッシュされることが期待されています．このような状況では、サーバ側とローカル側でのデータの不整合が置きやすくなるでしょう．さて、データの不整合を起きづらくするには、例えば、

 1. フォアグラウンドに戻ってきた時に、必ず新規データの取得を行う．
 - ローカルでの変更データは揮発性として保持し、サーバ側のデータだけをディスクに保持する．
 - （フォームなどのデータはRequest/Response込みで反映したことにし、ローカルには持たない）
 - ページの移動時には必ずデータの更新を行う．
 - データの更新に（オフラインなどで）失敗した場合にはエラー表示をする．
 - または強制的に画面を変える．（戻る．見えないようにする．など）

などが考えられます．これらはどれも不整合が起きる可能性を下げる効果があるでしょう．しかし、「サーバ側のデータでローカルの未コミットデータを上書きしてしまう」「ローカルに取り込んでいないサーバ側の新データをローカルの編集で上書きしてしまう」というような危険な可能性が0になるわけではありません．
上記の方策の多くはUIレベルで不整合を制御しようとしていますが、`coredata_sync`での”同期”はモデルレベルで行われるため、より安全です．
（とはいえ、上記の方策の多くは`coredata_sync`とも併用されるべきです．）

`coredata_rest`のみを用いるべきか、`coredata_sync`も導入するべきか、はアプリケーションの性質によります．下に主なメリット、デメリットを上げます．

 - `coredata_rest`のみのメリット
	- サーバ側に仮定される必要条件が少ない
	- 設定が少ない
 - `coredata_sync`のメリット
	- データの不整合が起きない
 - `coredata_sync`のデメリット
 	- コンフリクト時のユーザへの負荷が上がる

`coredata_sync`を入れる時の最大の難所はサーバ側APIに仮定される必要条件が増えることです．とは言え、`coredata_rest`ではアイテムにGUID: Global Unique ID（データベースで言うところのPrimary Key）のみを仮定しているのに対して、`coredata_sync`を使う場合は、アイテムにModified Date(編集日時）があることと、レスポンスにサーバ側でのコンフリクトを検知したかどうかのフラグが含まれているかどうか、の二点が増えるだけです．

同期アルゴリズムの詳細については[SYNC.md](./SYNC.md)を参照してください．


## クライアント側(ios)の設定

まず`coredata_rest.h`をインポートします．

```objective-c
import "coredata_rest.h"
```

まずREST接続用ドライバを設定して下さい．

```objective-c
@implementation NADefaultRestDriver
+ (NSString *)domain{
	return @"http://hogedomain.com"
}
@end
```

次にNSManagedObjectクラスを作成して下さい．`restmodel.xcdatamodeld`や`syncmodel.xcdatamodeld`からコピーして作成すると良いでしょう．ただし、自分で好きなように書き換えることも出来ます．全て`NSManagedObject`クラスのカテゴリでカスタムすることが出来ます．

次に使いたい`NSManagedObject`クラスのカテゴリに次の項目を設定して下さい．

```objective-c
@implementation Event (sync)
+ (id<NARestDriverProtocol>) restDriver{
	// singletonについてはmacros参照のこと
    return [NADefaultRestDriver sharedDriver];
}
+ (NSString *)restName{
    return @"event";
}
+ (NSString *)restEndpoint{
    return @"/api/v1.0/"
}
+ (NSString *)restCallbackName{
	return @"results";
}
@end
```

このようにした時、たとえば標準では、

```objective-c
[event sync_filter:@{@"name": @"test"} options:nil complete:nil];
```

は、`http://hogedomain.com/api/v1.0/filter/?name=test`
に翻訳されます．この形式を修正するには`NADefaultRestDriver`において、以下を上書きしてください．

```objective-c
- (NSString *)URLByType:(NARestType)type
                  model:(NSString*)modelname
               endpoint:(NSString *)endpoint
                     pk:(NSInteger)pk
                 option:(NSDictionary *)option;
- (NANetworkProtocol)ProtocolByType:(NARestType)type
                              model:(NSString*)modelname;
```

また返り値はjson形式で、次のような形を期待します．

```javascript
{"results":[
	{
		"id": 1,
		"name": "test"
	},
	{
		"id": 2,
		"name": "test"
	}
]}
```

primary keyに当たる`"id"`についてはカテゴリにおいて、次の関数を上書きすれば変更する事が出来ます．

```javascript
+ (NSInteger)primaryKeyInServerItemData:(id)itemData{
    return [itemData[@"id"] integerValue];
}
```

最後に`coredata_sync`の設定方法ですが、

```objective-c
import "coredata_sync.h"
```

とインポートしたら、該当の`NSManagedObject`のカテゴリに

```objective-c
+ (Class)restMapperClass{
    return [NARestSyncMapper class];
}
```

を書き加えて下さい．これで標準の同期設定は終了です．

また、同期にはいくつか戦略があり、それらを選ぶ事が出来ます．

```objective-c
/*
 コンフリクト時の戦略
 */
typedef enum NASyncModelConflictOption: NSUInteger{
	// サーバ優先
    NASyncModelConflictOptionServerPriority,
	// ローカル優先
    NASyncModelConflictOptionLocalPriority,
	// ユーザによる選択（サーバ優先かローカル優先か）
	// デフォルト
    NASyncModelConflictOptionUserAlert,
	// 自動マージ（testing)
    NASyncModelConflictOptionAutoMerge,
} NASyncModelConflictOption;

/*
 エラー時の戦略
 */
typedef enum NASyncModelErrorOption: NSUInteger{
	// 放置
    NASyncModelErrorOptionLeave,
	// あきらめる．POSTならローカル時のデータを破棄
    NASyncModelErrorOptionResign,
	// リトライ
    NASyncModelErrorOptionRetry,
	// ユーザによる選択(リトライか破棄か放置）
	// デフォルト
    NASyncModelErrorOptionUserAlert,
} NASyncModelErrorOption;

```

“ユーザによる選択“戦略は現状では`UIAlertView`を用いたものです．将来的にはカスタム出来るようにする予定です．
これらはクラスごとや、`sync_`APIの`options`で指定することが可能です．

## サーバ側の設定

`coredata_sync`を使わない場合、(ほとんどの場合含まれていると思いますが)primary keyが含まれたjsonを返すREST APIがあれば良いだけです．
`coredata_sync`を使う場合には、`modified_date`によるコンフリクト検知と返り値のjson内に`is_conflict`フラグが必要になります．
詳しくは[SYNC.md](./SYNC.md)を参考にして下さい．
