---
title: "從 XIB 建立 UITableViewCell 的問題"
date: 2014-11-05T11:25:00+08:00
tags: [iOS, XIB, UITableView]
---

自己試著使用 XIB 把不同東西切割出來，像是 UITableViewCell

在 UITableView 的 `viewDidLoad` 裡面建立好相關的參照

``` objc
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:cellIdentifier];
}
```

再建立 cell 時候，大概像這樣使用

``` objc
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    // do cell things ...
    return cell;
}
```

然後執行之後會出錯，大概會看到像這樣的錯誤
```
*** Assertion failure in -[UITableView dequeueReusableCellWithIdentifier:forIndexPath:], /SourceCache/UIKit_Sim/UIKit-3318.16.14/UITableView.m:6116
*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'unable to dequeue a cell with identifier MyTableViewCell - must register a nib or a class for the identifier or connect a prototype cell in a storyboard'
```

原因是使用 `dequeueReusableCellWithIdentifier:forIndexPath:` 會去 UITableView 查用把 XIB 裡面要的東西建立起來，這個動作會順便檢查 XIB 裡面的 View 是不是 UITableViewCell，若不是的話會吐 `NSInternalInconsistencyException`

回頭發現自己的 XIB 的最頂層有兩個 View ，一個是正常的 UITableViewCell，另一個就只是 View，把另一 View 加到 UITableViewCell 裡面(或是刪除)就可以。

另一種解決辦法就是不要使用 `[UITableView registerNib:forCellReuseIdentifier:]`, 用 `[UITableView dequeueReusableCellWithIdentifier:]` 來做資源的重用，然而建立 cell 的方式就換成 `[NSBundle loadNibNamed:owner:options:]`，把 XIB 建立起來之後，再檢查是不是自己想要的那個再丟出來

```objc
@interface UIView (Nib)
+ (instancetype)viewWithOwner:(id)owner;
@end

@implementation UIView (Nib)
+ (instancetype)viewWithOwner:(id)owner {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:owner options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:self]) {
            return view;
        }
    }
    return nil;
}
@end
```

然而，本來的 `tableView:cellForRowAtIndexPath` 就需要加上檢查 cell 是否有建立成功，若沒有就自己**手動**建立

``` objc
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
   		cell = [MyCell viewWithOwner:self];
    }
    // do cell things ...
    return cell;
}
```

補充：

使用自己從 XIB 建立 View 的方式，並不會呼叫 `initWithStyle:reuseIdentifier:` 這個，然後有些行為就會不正常，因此最好的辦法是把 XIB 修正正確。
