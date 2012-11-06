# `na_ios/coredata_ui`

`na_ios/coredata_ui`では、NSFetchedResultsControllerを簡単に扱えるようなUITableViewControllerのサブクラスを提供します．

NAFRCTableViewControllerを継承して、初期化の部分でfrcをアタッチして下さい．

```objective-c
#import "NAFRCTableViewController.h"
@interface EventFRCTableViewController : NAFRCTableViewController
@end

#import "EventFRCTableViewController.h"
#import "NSManagedObject+na.h"
#import "Event.h"
@implementation EventFRCTableViewController

- (void)initialize{
    [super initialize];
    
//    frcの設定
    NSFetchedResultsController *frc = [Event controllerWithEqualProps:@{}
                                                                sorts:@[@"date"]
                                                              context:nil o
                                                               ptions:nil];
    [frc performFetch:nil];
    self.fetchedResultsController = frc;
}

@end

```

たったこれだけです！
コアデータに変更を加えた場合は、FRCとtableviewを更新して下さい．

```objective-c

@implementation EventFRCTableViewController

…
…

- (IBAction)addEvent:(id)sender{
    //    dataの更新
    [Event create:@{@"date": [NSDate date]} options:nil complete:^(id mo) {
        
        //        ここで更新(メインスレッド)
        [self.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
    }];
}

@end

```
