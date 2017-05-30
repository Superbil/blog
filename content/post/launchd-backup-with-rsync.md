---
title: '使用 rsync 和 launchd 自動備份'
date: 2014-05-15T18:34:00+08:00
tags: ["rsync", "mac", "launchd", "launchctl"]
slug: launchd-backup-with-rsync
---
備份在現在是一件非常重要的事情，所以要把重要的東西備份，以免之後會哭哭

基於 rsync 可以細微的調整，而且擴充性好很多，所以就用 rsync 來當作主要備份工具

經過自己的需求和測試，目前自己使用的 rsync 大概會長這樣

``` bash
rsync -auzthv --exclude-from=rsync_exclude --delete-after project/ /volumes/backup/project/
```

在 Mac 上要能跑的東西目前有 cron 或是 launchd 這兩個方式，前面的是一般 unix 常用的方式，基於要試新的玩意，就小玩了一下 launchd。(launchctl 是用來操作 launchd 用的命令列工具)

依照[官方說明](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html)，我就做了一個這樣的 [plist](https://gist.github.com/Superbil/edb9701ef07df2e88091) 出來

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Debug</key>
	<true/>
	<key>Label</key>
	<string>org.superbil.rsync</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/bin/rsync</string>
		<string>-auzthv</string>
		<string>--delete-after</string>
		<string>--exclude-from=rsync_exclude</string>
		<string>project/</string>
		<string>/volumes/backup/project/</string>
	</array>
	<key>StandardErrorPath</key>
	<string>~/Library/Logs/rsync/project.log</string>
	<key>StandardOutPath</key>
	<string>~/Library/Logs/rsync/project_err.log</string>
	<key>StartCalendarInterval</key>
	<dict>
		<key>Hour</key>
		<integer>6</integer>
		<key>Minute</key>
		<integer>0</integer>
	</dict>
</dict>
</plist>
```
這個 plist，`ProgramArguments` 這項單行和多行都可以，launchd 會幫你組成一行。`StartCalendarInterval` 就是重復執行的時間間隔，這個跟 unix 習慣一樣，沒有輸入的值他會當通用批配值。

因為是使用者自己要用的，所以再把這個檔案放在 `~/Library/LaunchAgents`，名子就叫 `org.superbil.rsync`。

最後再把他 load 進列表中
``` bash
launchctl load -w org.superbil.rsync.plist
```

PS. 若是要用 `launchctl start` 後面帶的參數必需是 lable 的值，例:
``` bash
launchctl start org.superbil.rsync
```

相關連接：
- [Daemons and Services Programming Guide: About Daemons and Services](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/Introduction.html#//apple_ref/doc/uid/10000172i-SW1-SW1)
- [Launchctl - The iPhone Wiki](http://theiphonewiki.com/wiki/Launchctl)
