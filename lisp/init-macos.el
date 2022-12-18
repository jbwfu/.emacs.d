;;; init-macos.el --- Configure keys specific to macOS -*- lexical-binding: t -*-
;;; Commentary:

;; This file provides `macOS' system specific settings.

;;; Code:


;; macOS specified key mapping
(setq mac-command-modifier 'super)
(setq mac-option-modifier 'meta)


;;; Mouse scrolling
;; Smoother and nicer scrolling
(setq scroll-margin 15)
(setq next-line-add-newlines nil)
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq mouse-wheel-follow-mouse t)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq-default scroll-preserve-screen-position t)

;; Enable `pixel-scroll-precision-mode'
(pixel-scroll-precision-mode 1)

;; Disable auto copying
(setq mouse-drag-copy-region nil)

;; Disabe default key for scaling text
(global-unset-key (kbd "C-<wheel-up>"))
(global-unset-key (kbd "C-<wheel-down>"))


;;; macOS styled keybindings
;; Editing specified
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

;; Buffer specified
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-q") 'save-buffers-kill-emacs)
(global-set-key (kbd "s-e") 'delete-window)
(global-set-key (kbd "s-w") (lambda ()
			      (interactive)
			      (kill-buffer (current-buffer))))
(global-set-key (kbd "<s-right>") 'switch-to-next-buffer)
(global-set-key (kbd "<s-left>") 'switch-to-prev-buffer)

;; File management specified
(global-set-key (kbd "s-n") 'find-file)

;; Window specified
;; Go to other windows easily with one keystroke `cmd-'
(global-set-key (kbd "s-1") (kbd "C-x 1")) ; cmd-1 kill other windows (keep 1)
(global-set-key (kbd "s-2") (kbd "C-x 2")) ; cmd-2 split horizontally
(global-set-key (kbd "s-3") (kbd "C-x 3")) ; cmd-3 split vertically


;; Compiling emacs lisp code
(define-key emacs-lisp-mode-map [f9] (lambda ()
                                       (interactive)
                                       (eval-buffer)))


;; Disable these keys
(global-unset-key [swipe-left])
(global-unset-key [swipe-right])
(global-unset-key (kbd "C-z"))


(when (string= system-type "darwin")
  (setq dired-use-ls-dired nil))


;; Speedup `regexp' searching
(setq xref-search-program 'ripgrep)


;; System specified path
(defvar my-home-path "/Users/ilyaw39/")
(defvar my-git-repo-path (expand-file-name "myProjects/" my-home-path))

;; Homebrew specified path
(defvar my-hb-bin-path "/opt/homebrew/bin/")
(defvar my-python-exec-path (expand-file-name "python3" my-hb-bin-path))


(provide 'init-macos)
;;; init-macos.el ends here
