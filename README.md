# na_ios

ios開発において基盤となるパターンをパッケージにしました．

***一つ目の特徴***は、パフォーマンス、バグの両方においてネックとなりやすいNetwork IOとDisc IO(coredata)における非同期プログラミングです．UIのスレッドをいかにしてブロックしないようにするか、は近年のクライアントサイドプログラムにおいて最も重要な課題の一つです．`na_ios`ではスレッド処理を隠蔽し、一環したmain thread上でのコールバックスタイルを取る事により、バグの混入しやすい部分をパッケージ側に任せることが出来ます．特にcoredataのマルチスレッドは難しい問題です．これらのデータをテーブルやフォームで扱うためのモジュールも含んでいます．

***二つ目の特徴***は、RESTを介したデータベースの同期システムです．サーバ-マルチデバイス構成でのデータベースの同期はios環境においては、ニーズが高く、それに比例して難易度が高い問題です．この部分をパターン化してモジュールに切り出しました．この部分についても、マルチスレッドを有効活用することで、パフォーマンスを最大に担保するように気をつけています．

具体的な使い方については、個々のモジュールのドキュメントを参考にして下さい．

 - [na_ios/network](https://github.com/nashibao/na_ios/tree/master/network)
ネットワークを扱うためのモジュール
 - [na_ios/coredata](https://github.com/nashibao/na_ios/tree/master/coredata)
コアデータを扱うためのモジュール
 - [na_ios/coredata_ui](https://github.com/nashibao/na_ios/tree/master/coredata_ui)
コアデータをUI上で扱うためのモジュール
 - [na_ios/coredata_sync](https://github.com/nashibao/na_ios/tree/master/coredata_sync)
RESTを介してサーバ側と通信するモジュール
 - na_ios/ui
UI用モジュール
 - na_ios/form
フォーム用モジュール
 - na_ios/macros
各種マクロを入れておくモジュール
 - na_ios/ocunit
非同期でocunitで単体テストするためのモジュール
