---
title: 'sort Xcode project'
date: 2013-11-07T11:47:00+08:00
tags: ["xcode","perl"]
---
I found this perl script can sort Xcode Project

[sort-Xcode-project-file](https://github.com/WebKit/webkit/blob/master/Tools/Scripts/sort-Xcode-project-file)

just download it and run it

```sh
$ curl -O https://raw.github.com/WebKit/webkit/master/Tools/Scripts/sort-Xcode-project-file
$ chmod +x sort-Xcode-project-file
$ ./sort-Xcode-project-file MyProject.xcodeproj/project.pbxproj
```

you need to change MyProject to you xcode project name
