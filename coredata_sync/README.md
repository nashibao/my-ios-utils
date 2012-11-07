`na_ios/coredata_sync`

`na_ios/coredata_sync`はRESTを介したデータベースの更新/同期システムです．サーバ-マルチデバイス構成でのデータベースの更新/同期はios環境においては、ニーズが高く、それに比例して難易度が高い問題です．マルチスレッドを有効利用することで、パフォーマンスを最大に担保するように気をつけて設計されています．

`na_ios/coredata_sync`は`na_ios/coredata_rest`に依存しています．`coredata_rest`はRESTを介したデータの更新のみを行い、同期には対応しません．`coredata_sync`は`coredata_rest`に”同期”の機能を付加したものです．ここでいう”同期”とは"更新"に加えて次を可能とすることを言っています．

 - データの新旧、変更のコンフリクトを自動で判断し、処理する

iosのようなモバイルでのネィティブ環境がウェブブラウザと異なるのは、アプリを立ち上げたままマルチタスクのバックグランドに移し、3日後、1週間後にフォアグラウンドに移してきて、もう一度使ったりすることです．または、ウェブブラウザではページ遷移によってデータのほとんどが捨てられ、新しく取得されるのに対して、オフラインでの使用が想定されるモバイル環境では多くのデータがキャッシュされることが期待されています．このような状況では、サーバ側とローカル側でのデータの不整合が置きやすくなるでしょう．さて、データの不整合を起きなくするには、

 1. フォアグラウンドに戻ってきた時に、必ず新規データの取得を行う．
 - ローカルでの変更データは揮発性として保持し、サーバ側のデータだけをディスクに保持する．
 - （フォームなどのデータはRequest/Response込みで反映したことにし、ローカルには持たない）
 - ページの移動時には必ずデータの更新を行う．
 - データの更新に（オフラインなどで）失敗した場合にはエラー表示をする．
 - または強制的に画面を変える．（戻る．見えないようにする．など）

などが考えられます．これらはどれも不整合が起きる可能性を下げる効果があるでしょう．しかし、「サーバ側のデータでローカルの未コミットデータを上書きしてしまう」「ローカルに取り込んでいないサーバ側の新データをローカルの編集で上書きしてしまう」という危険な可能性が0になったわけではありません．
上記の方策の多くはUIレベルで不整合を制御しようとしていますが、`coredata_sync`での”同期”はモデルレベルで行われるため、より安全です．
（とはいえ、上記の方策の多くは`coredata_sync`とも併用されるべきです．）

`coredata_rest`のみを用いるべきか、`coredata_sync`も導入するべきか、はアプリケーションの性質によります．下に主なメリット、デメリットを上げます．

 - `coredata_rest`のみのメリット
	- サーバ側に仮定される必要条件が少ない
	- 設定が少ない
 - `coredata_sync`のメリット
	- データの不整合が起きない
 - `coredata_sync`のデメリット
 	- コンフリクト時のリクエストが増える

`coredata_sync`を入れる時の難所はサーバ側APIに仮定される必要条件が増えることです．とは言え、`coredata_rest`ではアイテムにGUID: Global Unique ID（データベースで言うところのPrimary Key）のみを仮定しているのに対して、`coredata_sync`を使う場合は、アイテムにModified Date(編集日時）があることと、レスポンスにサーバ側でのコンフリクトを検知したかどうかのフラグが含まれているかどうか、の二点が増えるだけです．

同期アルゴリズムの詳細については[SYNC.md](./SYNC.md)を参照してください．

## 使い方

使い方に置いては、`coredata_sync`も`coredata_rest`もほぼ同じです．設定で同期を有効にしておけば、同期は自動で行われます．

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

ただ、`coredata_rest/sync`自体は`NSDictionary`形式でHTTPパラメタを渡すだけなので、サーバ側のRESTの形式については仮定をしていません．プロジェクトに合ったサーバサイドのRESTライブラリを使うと良いでしょう．詳しいREST接続のカスタマイズについては後述します．

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

## クライアント側(ios)の設定

クライアント側では、主に3点設定するべきことがあります．

1. NSManagedObjectの拡張（restカテゴリとsyncカテゴリのimport）
2. queryからHTTPリクエスへの翻訳の書式
3. サーバからの返り値のパージングの書式

## 1. queryからHTTPリクエスへの翻訳の書式

REST
```objective-c
```
## 2. サーバからの返り値のパージングの書式

## サーバ側の設定


