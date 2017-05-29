+++
title = "在 emacs 中呼叫 clang 的自動完成"
date = 2013-11-19T18:15:00+08:00
slug = "emacs-uses-automatic-completion-of-clang"
tags = ["clang","Homebrew"]
+++
一開始是在 [homebrew](http://brew.sh/) 發現這個 [emacs-clang-complete-async](https://github.com/Golevka/emacs-clang-complete-async) 東西

安裝完之後，再參照 [github 上的說明](https://github.com/Golevka/emacs-clang-complete-async/blob/master/README.org)，在自己的 init.el 裡面放入以下的設定

``` cl
(require 'auto-complete-clang-async)
(defun ac-cc-mode-setup ()
  (setq ac-clang-complete-executable "/usr/local/opt/emacs-clang-complete-async/bin/clang-complete")
  (setq ac-sources '(ac-source-clang-async))
  (ac-clang-launch-completion-process))

(defun my-ac-config ()
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))

(my-ac-config)
```

`/usr/local/opt/emacs-clang-complete-async/bin/clang-complete` 這個是使用 [homebrew](http://brew.sh/) 安裝的預設路徑，只要把這個參數設對，就會正常的跑起來
PS. 也可以用`brew --prefix emacs-clang-complete-async`拿到路徑

不過目前只能當下的檔案，可以再使用 `M-x ac-clang-set-cflags` 來設定 cFlags，不過目前還沒有成功 XD
