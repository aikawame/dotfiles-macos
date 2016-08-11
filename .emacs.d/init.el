;;; システム
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ロードパスを設定する
(setq load-path (cons "~/.emacs.d/elisp" load-path))

;; 日本語環境を設定する
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(when (eq window-system 'w32)
  (set-file-name-coding-system 'cp932)
  (setq locale-coding-system 'cp932))
(when (eq window-system 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))


;;; 外観と挙動
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 起動画面を表示しない
(setq inhibit-startup-message t)

;; *scratch*のメッセージを表示しない
(setq initial-scratch-message "")

;; モードラインに改行コード・ファイルサイズ・列番号を表示する
(setq eol-mnemonic-dos "[CRLF]")
(setq eol-mnemonic-mac "[CR]")
(setq eol-mnemonic-unix "[LF]")
(setq eol-mnemonic-undecided "[?]")
(size-indication-mode t)
(column-number-mode t)

;; モードラインにリージョン内の行数と文字数を表示する
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines, %d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning))) ""))
(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))

;; C-tでウィンドウの切り替えを行えるようにする
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p) (split-window-horizontally))
  (other-window 1))
(define-key global-map (kbd "C-t") 'other-window-or-split)

;; M-rで文字列置換を行えるようにする
(define-key global-map (kbd "M-r") 'replace-string)

;; M-gでgrepを行えるようにする
(define-key global-map (kbd "M-g") 'rgrep)

;; ediffを1ウィンドウにする
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; grepを対話式にする
(setq grep-host-defaults-alist nil)
(setq grep-find-template "rgrep <C> -n <R> <F> <N>")
(setq grep-find-template "find . <X> -type f <F> -print0 | xargs -0 lgrep <C> -nk -Au8 -Ia +i <R> <N>")

;; yesを入力する箇所をyにする
(defalias 'yes-or-no-p 'y-or-n-p)

;; root所有ファイルの開き方を選択式にする
(require 'file-root)

;; 大きいファイルを開こうとした時に警告する
(setq large-file-warning-threshold (* 50 1024 1024))


;;; 編集
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; タブ文字の表示幅を4にする
(setq-default tab-width 4)

;; タブインデントを使用しない
(setq-default indent-tabs-mode nil)

;; 1行づつスクロールする
(require 'sane-line)

;; CUAモードを有効にする
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; 対応する括弧を表示する
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'mixed)

;; アンドゥ・リドゥを設定する
(require 'redo+)
(setq undo-no-redo t)
(define-key global-map (kbd "M-/") 'redo)
(define-key global-map (kbd "C-M-/") 'redo)

;; Cモードを設定する
(add-hook 'c-mode-common-hook
          '(lambda ()
             (setq c-basic-offset 4)
             (setq indent-tabs-mode nil)
             (setq tab-width 4)

             (c-set-style "stroustrup")
             (c-set-offset 'case-label' 4)
             (c-set-offset 'arglist-intro' 4)
             (c-set-offset 'arglist-cont-nonempty' 4)
             (c-set-offset 'arglist-close' 0)))

;; gzファイルも編集できるようにする
(auto-compression-mode t)


;;; バックアップ・履歴
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 自動保存ファイルを一箇所に纏める
(setq auto-save-file-name-transforms
      `(("*", temporary-file-directory t)))

;; バックアップファイルを一箇所に纏める
(setq make-backup-files t)
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
            backup-directory-alist))

;; 複数世代のバックアップファイルを残す
(setq version-control t)
(setq kept-new-versions 2)
(setq kept-old-versions 2)
(setq delete-old-versions t)
(setq vc-make-backup-files t)

;; ミニバッファの履歴を保存する
(savehist-mode 1)
