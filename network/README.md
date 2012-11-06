# na_ios/network

na_ios/networkはnetworkアクセスに置けるスレッドプログラミングを隠蔽するモジュールです．
バックエンドにGCDを用いたものと、NSOperationを用いたものの二種類があります．

GCDを用いた、NANetworkGCDHelperのサンプルコードは次のようになります．

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
returnManinをYESにするとバックエンドのスレッド内でstringのエンコードとjsonのエンコードを行ってからmain threadに結果を返してくれます．


NANetworkGCDHelperは単純なAPIのみで、キャンセルやネットワークコネクションの有無などを考慮しません．これらの機能を使うためにはNANetworkOperationを使って下さい．

NANetworkOperationは次のように呼び出すことができます．


```objective-c
[NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testidentifier" identifierMaxCount:1 options:nil queueingOption:NANetworkOperationQueingOptionReturnOld successHandler:^(NANetworkOperation *op, id data) {
    // hoge
} errorHandler:^(NANetworkOperation *op, NSError *err) {
    // hoge
}];
```

NANetworkGCDHelperと比較して、queue、identifier、identifierMaxCount、queueingOptionなどの引数が追加されています

queueパラメタは処理を走らせるためのNSOperationQueueです．nilに設定すると[NSOperationQueue globalBackgroundQueue]が利用されます．

queueingOptionパラメタはNANetworkOperationQueingOptionから選択します．

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

identifierパラメタはqueueingOptionにおける識別子です．またキャンセル処理もこの識別子を使ってまとめてキャンセル処理を行うことができます．
identifiermaxCountパラメタはNANetworkOperationQueingOptionCancel, NANetworkOperationQueingOptionReturnOldの時にだけ使われる最大値です．

キャンセル処理はidentifierを使って次のように行うことが出来ます．

```objective-c
[NANetworkOperation cancelByIdentifier:@"testidentifier" handler:^{
    // hoge
}];
```

またNANetworkOperationでは内部にtonymillion/Reachabilityを利用しています．ネットワークがないところでは一度アクセスをあきらめ、ネットワークが復帰したタイミングでもう一度処理を走らせます．ただし、アクセス途中でネットワークが遮断された場合はエラーハンドラに返ってきます．
