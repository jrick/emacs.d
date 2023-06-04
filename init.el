(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file t)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(require 'package)
(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

(use-package which-key
  :config
  (which-key-mode))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :bind (:map lsp-mode-map
              ("C-c d" . lsp-describe-thing-at-point)
              ("C-c a" . lsp-execute-code-action))
  :config
  (lsp-enable-which-key-integration t))

(use-package company
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0))

(use-package go-mode
  :init
  (defun my-go-compile ()
    (set (make-local-variable 'compile-command)
         "go test"))
  (setq indent-tabs-mode t)
  :hook ((go-mode . lsp-deferred)
         (go-mode . my-go-compile)
         (before-save . gofmt-before-save)))

(use-package racket-mode)

(use-package slime)

(use-package vc-got)

(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; keybindings
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c C-t") (lambda ()
                                  (interactive)
                                  (ansi-term "/bin/ksh")))
(global-set-key (kbd "C-c C-v") 'flymake-goto-next-error)
(global-set-key (kbd "C-c m") 'man)
(global-set-key (kbd "M-z") 'zap-up-to-char)
(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "<f6>") 'recompile)

(blink-cursor-mode 0)
(column-number-mode 1)
(electric-pair-mode 1)
(setq show-paren-delay 0)
(show-paren-mode 1)
(global-display-line-numbers-mode 1)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(set-fringe-mode 5)
(tool-bar-mode 0)
(setq-default cursor-type 'bar
              fill-column 80
              indent-tabs-mode nil
              show-trailing-whitespace t
              word-wrap t)
(setq inhibit-startup-message t
      mouse-autoselect-window t
      mouse-wheel-scroll-amount '(10)
      x-select-enable-primary t
      x-select-enable-clipboard t
      mouse-drag-copy-region t
      mouse-yank-at-point t
      require-final-newline t
      select-active-regions t
      inferior-lisp-program "sbcl")

(dolist (hook '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                racket-repl-mode
                slime-repl-mode))
  (add-hook hook (lambda ()
                   (display-line-numbers-mode nil)
                   (setq show-trailing-whitespace nil))))

;; backups
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))

;; theme
(set-face-attribute 'default nil
                    :font "Go Mono"
                    :height 105
                    :background "#fff2ff"
                    :foreground "#180818")
(set-face-attribute 'mode-line nil :background "#edd8ed" :box nil)
(set-face-attribute 'mode-line-inactive nil :foreground "#680048" :box nil)
(custom-set-faces
 '(font-lock-comment-face ((t (:foreground "#680048"))))
 '(font-lock-string-face ((t (:foreground "#195519")))))
(defun boring-font-lock ()
  "Disable keyword highlighting"
  (interactive)
  (font-lock-mode)
  (setq-local font-lock-keywords nil))
(add-hook 'prog-mode-hook 'boring-font-lock)
