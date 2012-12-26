# na_ios

ios開発において基盤となるパターンをパッケージにしました．

***一つ目の特徴***は、パフォーマンス、バグの両方においてネックとなりやすいNetwork IOとDisc IO(coredata)における非同期プログラミングです．UIのスレッドをいかにしてブロックしないようにするか、は近年のクライアントサイドプログラムにおいて最も重要な課題の一つです．`na_ios`ではスレッド処理を隠蔽し、一環したmain thread上でのコールバックスタイルを取る事により、バグの混入しやすい部分をパッケージ側に任せることが出来ます．特にcoredataのマルチスレッドは難しい問題です．これらのデータをテーブルやフォームで扱うためのモジュールも含んでいます．

***二つ目の特徴***は、RESTを介したデータベースの同期システムです．サーバ-マルチデバイス構成でのデータベースの同期はios環境においては、ニーズが高く、それに比例して難易度が高い問題です．この部分をパターン化してモジュールに切り出しました．この部分についても、マルチスレッドを有効活用することで、パフォーマンスを最大に担保するように気をつけています．

具体的な使い方については、個々のモジュールのドキュメントを参考にして下さい．

 - [na_ios_network](https://github.com/nashibao/na_ios_network)
ネットワークを扱うためのモジュール
 - [na_ios_coredata](https://github.com/nashibao/na_ios_coredata)
コアデータを扱うためのモジュール
 - [na_ios_coredata_rest](https://github.com/nashibao/na_ios_coredata_rest)
RESTを介してサーバ側と通信するモジュール
 - [na_ios_coredata_sync](https://github.com/nashibao/na_ios_coredata_sync)
同期モジュール
 - [na_ios_table](https://github.com/nashibao/na_ios_table)
コアデータでテーブルを扱うモジュール
 - na_ios/form
フォーム用モジュール(作成中)
 - [na_ios_utils](https://github.com/nashibao/na_ios_utils)
各種カテゴリやマクロ
 - [na_ios_boilerplate](https://github.com/nashibao/na_ios_boilerplate)
汎用コンポーネント集

# setup

na_ios自体はcloneしてきて/test/ディレクトリ以外は単純にプロジェクトのターゲットに加えれば使用できます．
一部モジュールは[BlocksKit](https://github.com/zwaldowski/BlocksKit)や[SVProgressHUD](https://github.com/samvermette/SVProgressHUD)、[Reachability](https://github.com/tonymillion/Reachability)などに依存しています．[cocoapods](http://cocoapods.org/)用のインストールファイル（Podfile）が含まれているので、これをプロジェクトのルートディレクトリ(hoge.xcodeproが入っているディレクトリ)にコピーし、
```
> pod install
```
とすれば完了です．cocoapodsの使い方については、リンク先を参照して下さい．
