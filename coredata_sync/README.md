na_ios/coredata_sync

na_ios/coredata_syncはRESTを介したデータベースの更新/同期システムです．サーバ-マルチデバイス構成でのデータベースの更新/同期はios環境においては、ニーズが高く、それに比例して難易度が高い問題です．マルチスレッドを有効利用することで、パフォーマンスを最大に担保するように気をつけて設計されています．

"更新"ではなく、"同期"とは、データの新旧を判断したり、コンフリクトの判断とその解消をすることにあります．na_ios/coredata_syncでは、単純なRESTによる更新に使うことも、同期処理を利用することも、どちらもできます．同期アルゴリズムの詳細については[SYNC.md](./SYNC.md)を参照してください．

na_ios/coredata_syncはna_ios/coredataと同じくNSManagedObjectのカテゴリAPIから利用します．違うのはAPIにsync_の接頭辞が付く、ということです．

例えば、サーバ側からname=="test"なデータを取ってくるには次のようにします．

```objective-c
[Object sync_filter:@{@"name": @"test"} options:nil complete:^(NSError *err) {
    // maincontextにマージされた後に呼び出される．
}];
```

sync_filter以外に以下のAPIがあります．

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

queryパラメタはNSDictionaryで指定し、@{key: val}においてkeyがname属性、valがvalue属性になります．つまりHTTP GETであれば、http://domain/endpoint?key=valに翻訳されることが期待されます．

気の利いたRESTフレームワークであれば、より複雑なフィルタリング処理を許されていることでしょう．たとえばs-cubism社内で開発しているDjango用RESTフレームワーク（現状非公開）では、DjangoのORマッパーにおけるフィルタ処理の多くを許容しています．例えば、@{@"name__icontains": @"test"}とすれば、testが含まれるものがjson形式で返ってきます．

ただ、na_ios/coredata_sync自体はNSDictionary形式でHTTPパラメタを渡すだけなので、サーバ側のRESTの形式については仮定をしていません．プロジェクトに合ったサーバサイドのRESTライブラリを使うと良いでしょう．詳しいREST接続のカスタマイズについては後述します．


これらのAPIは見て分かる通り、すべて非同期メソッドになっています．completeハンドラはna_ios/coredataと同じように、mainContextに変更がマージされてからmain thread上に返ってきます．そのため、直接completeハンドラ上でUIを触っても問題ありません．

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


