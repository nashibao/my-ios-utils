na_ios/coredata_sync

na_ios/coredata_syncはRESTを介したデータベースの同期システムです．サーバ-マルチデバイス構成でのデータベースの同期はios環境においては、ニーズが高く、それに比例して難易度が高い問題です．マルチスレッドを有効利用することで、パフォーマンスを最大に担保するように気をつけて設計されています．


同期アルゴリズムの詳細については[SYNC.md](./SYNC.md)を参照してください．

na_ios/coredata_syncはna_ios/coredataと同じくNSManagedObjectのカテゴリAPIから利用します．違うのはAPIにsync_の接頭辞が付く、ということです．

```objective-c
```