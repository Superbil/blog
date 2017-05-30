---
title: '產生 lame for iOS'
date: 2013-12-10T17:05:00+08:00
tags: [build, XCode5, iOS, lipo, bash]
---
lame 官方沒有提供 iOS 的版本只能自己動手做，但是網路上的都是 XCode 4 和用 gcc 編譯的方式

修正一些編譯上會遇到的問題，只要先去抓 [lame](http://lame.sourceforge.net/) 官方的程式碼 ，然後把以下的 script 放在解壓縮出來的資料夾中，再執行即可

東西會產生在 build 這個資料夾之下

PS.本來想用別的語言實作的，但是後來覺得 bash 的普及性比較高，所以就不再用其他語言實作

目前已經 fork 到我的 [Github project build-lame-for-iOS](https://github.com/Superbil/build-lame-for-iOS)，可以直接 fork 使用
