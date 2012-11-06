# `na_ios/network`

`na_ios/network`はnetworkアクセスに置けるスレッドプログラミングを隠蔽するモジュールです．
バックエンドにGCDを用いたものと、`NSOperation`を用いたものの二種類があります．

GCDを用いた、`NANetworkGCDHelper`のサンプルコードは次のようになります．

```objective-c
[NANetworkGCDHelper sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:NO successHandler:^(NSURLResponse *resp, id data) {
    // success
} errorHandler:^(NSURLResponse *resp, NSError *err) {
    // error
}];
```

また、jsonへのエンコードを行う次のAPIもあります．

```objective-c
+ (void)sendJsonAsynchronousRequest:(NSURLRequest *)request
                         jsonOption:(NSJSONReadingOptions)jsonOption
                     returnEncoding:(NSStringEncoding)returnEncoding
                         returnMain:(BOOL)returnMain
                     successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                       errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler;
```
`returnMain`をYESにするとバックエンドのスレッド内でstringのエンコードとjsonのエンコードを行ってからmain threadに結果を返してくれます．


`NANetworkGCDHelper`は単純なAPIのみで、キャンセルやネットワークコネクションの有無などを考慮しません．これらの機能を使うためには`NANetworkOperation`を使って下さい．

`NANetworkOperation`は次のように呼び出すことができます．


```objective-c
[NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testidentifier" identifierMaxCount:1 options:nil queueingOption:NANetworkOperationQueingOptionReturnOld successHandler:^(NANetworkOperation *op, id data) {
    // hoge
} errorHandler:^(NANetworkOperation *op, NSError *err) {
    // hoge
}];
```

`NANetworkGCDHelper`と比較して、`queue`、`identifier`、`identifierMaxCount`、`queueingOption`などの引数が追加されています

`queue`パラメタは処理を走らせるための`NSOperationQueue`です．`nil`に設定すると`[NSOperationQueue globalBackgroundQueue]`が利用されます．

`queueingOption`パラメタは`NANetworkOperationQueingOption`から選択します．

```objective-c
typedef enum NANetworkOperationQueingOption: NSInteger {
    //キャンセルしてからaddOperation
    NANetworkOperationQueingOptionCancel = 2,
    //古いのがあったら返すだけ
    NANetworkOperationQueingOptionReturnOld = 1,
    //先に入っているやつの終了を待つ
    NANetworkOperationQueingOptionJustAdd = 0,
    NANetworkOperationQueingOptionDefault = 0,
} NANetworkOperationQueingOption;
```

`identifier`パラメタは`queueingOption`における識別子です．またキャンセル処理もこの識別子を使ってまとめてキャンセル処理を行うことができます．
`identifiermaxCount`パラメタは`NANetworkOperationQueingOptionCancel`, `NANetworkOperationQueingOptionReturnOld`の時にだけ使われる最大値です．

キャンセル処理はidentifierを使って次のように行うことが出来ます．

```objective-c
[NANetworkOperation cancelByIdentifier:@"testidentifier" handler:^{
    // hoge
}];
```

また`NANetworkOperation`では内部に[tonymillion/Reachability](https://github.com/tonymillion/Reachability)を利用しています．ネットワークがないところでは一度アクセスをあきらめ、ネットワークが復帰したタイミングでもう一度処理を走らせます．ただし、アクセス途中でネットワークが遮断された場合はエラーハンドラに返ってきます．
