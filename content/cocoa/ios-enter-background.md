---
title: 'iOS enter background'
date: 2013-09-05T17:40:00+08:00
tags: [iOS, cocoa]
---
If yout want to do something in background...

```objc
__block UIBackgroundTaskIdentifier backgroundId =
[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    [[UIApplication sharedApplication] endBackgroundTask:backgroundId];
    backgroundId = UIBackgroundTaskInvalid;
}];

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^{
    // do some thing you want to ...
});
```
