;;; init-system.el --- Configs specific to macOS -*- lexical-binding: t; -*-

;; Copyright (C) 2021-2025 Sthenno <sthenno@sthenno.com>

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This file provides macOS specific settings.

;;; Code:
;;

;; macOS specified key mapping
;;

(defun sthenno/platform-is-wsl ()
  "Return t if running in WSL, nil otherwise."
  (when (or (getenv "WSL_DISTRO_NAME")
            (getenv "WSL_INTEROP")
            (and (string-match-p "microsoft" operating-system-release)
                 (eq system-type 'gnu/linux)))
    t ))

;; Define a customizable variable to store the desired Linux super key event names
(defcustom sthenno/linux-super-key-event-names '("<menu>" "<XF86MenuKB>" "<MenuKB>")
  "List of key event name strings to be mapped to the 'super' modifier on GNU/Linux.
  Each string in the list should correspond to a key event name that Emacs
  recognizes when the physical key intended for 'super' is pressed.
  Use `C-h k` followed by pressing the key to find its exact Emacs name.
  Set this variable to an empty list '() to disable the remapping on Linux."
  :type '(repeat string)
  :group 'Keyboard)

;; Configure a physical key to act as the 'super' modifier across OSes.
;; For a consistent experience on Windows/WSL or Linux(Optional), it is recommended to
;; use an external tool to remap your physical keys as follows:
;;   - Left Alt      ->  Application/Menu
;;   - Left Windows  ->  Left Alt
;;   - Right Alt     ->  Left Windows
(cond
 ((eq system-type 'darwin)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super))
 ((sthenno/platform-is-wsl)
  (global-set-key (kbd "<menu>") nil)
  (define-key key-translation-map (kbd "<menu>") 'event-apply-super-modifier))
 ((eq system-type 'gnu/linux)
  (dolist (key-name-string sthenno/linux-super-key-event-names)
    (when (stringp key-name-string)
      (when-let* ((key-sequence (kbd key-name-string)))
        (global-set-key key-sequence nil)
        (define-key key-translation-map key-sequence 'event-apply-super-modifier)))))
 ((eq system-type 'windows-nt)
  (setq w32-apps-modifier 'super)))

;; macOS-styled keybindings
(keymap-global-set "s-a" #'mark-whole-buffer)
(keymap-global-set "s-c" #'kill-ring-save)
(keymap-global-set "s-v" #'yank)
(keymap-global-set "s-x" #'kill-region)
(keymap-global-set "s-q" #'save-buffers-kill-emacs)
(keymap-global-set "s-s" #'save-buffer)
(keymap-global-set "s-w" #'kill-current-buffer)
(keymap-global-set "s-e" #'delete-window)
(keymap-global-set "s-r" #'restart-emacs)
(keymap-global-set "s-z" #'undo)
(keymap-global-set "s-d" #'find-file)

(keymap-set emacs-lisp-mode-map "C-c C-c" #'(lambda ()
                                              (interactive)
                                              (let ((debug-on-error t))
                                                (elisp-eval-region-or-buffer))))

;; Set escape key binding
(keymap-global-set "<escape>" #'keyboard-escape-quit)

;; Unset pinch gesture and mouse scaling
(keymap-global-unset "<pinch>")
(keymap-global-unset "<mouse-1>")       ; F11
(keymap-global-unset "<mouse-3>")       ; F12
(keymap-global-unset "C-<wheel-up>")
(keymap-global-unset "C-<wheel-down>")

;;; Split windows
(defun split-window-below-focus ()
  "Like `split-window-below', but focus to the new window after execution."
  (interactive)
  (split-window-below)
  (windmove-down))

(defun split-window-right-focus ()
  "Like `split-window-right', but focus to the new window after execution."
  (interactive)
  (split-window-right)
  (windmove-right))

(defun delete-other-windows-reversible ()
  "Like `delete-other-windows', but can be reserved.
Activate again to undo this. If the window changes before then, the undo expires."
  (interactive)
  (if (and (one-window-p)
           (assq ?_ register-alist))
      (jump-to-register ?_)
    (window-configuration-to-register ?_)
    (delete-other-windows)))

(keymap-global-set "s-1" #'delete-other-windows-reversible)
(keymap-global-set "s-2" #'split-window-below-focus)
(keymap-global-set "s-3" #'split-window-right-focus)

;; Use C-Arrow keys to move around windows
(windmove-default-keybindings 'control)

;;; Locate position history
(use-package saveplace
  :hook (after-init . save-place-mode)
  :config
  (setq save-place-file (locate-user-emacs-var-file "save-place.eld")))

(use-package savehist
  :init
  (setq history-length 128)
  (setq history-delete-duplicates t)
  :hook (after-init . savehist-mode)
  :config
  (setq savehist-file (locate-user-emacs-var-file "savehist.eld"))
  (setq savehist-save-minibuffer-history t))

(use-package recentf
  :hook (after-init . recentf-mode)
  :config
  (setq recentf-save-file (locate-user-emacs-var-file "recentf-save.eld"))
  (setq recentf-max-saved-items 100)
  (setq recentf-save-file-modes nil)
  (setq recentf-keep nil)
  (setq recentf-auto-cleanup nil)
  (setq recentf-initialize-file-name-history nil)
  (setq recentf-show-file-shortcuts-flag nil))

(use-package autorevert
  :config
  (setopt auto-revert-use-notify nil)
  (global-auto-revert-mode 1))

;;; Misc options

(use-package emacs
  :demand t
  :init
  (setq use-short-answers t)

  (setq mark-even-if-inactive nil)
  (setq ring-bell-function 'ignore)
  (setq require-final-newline t)

  (setq-default fill-column 88)
  (setq-default tab-width 4)
  (setq-default indent-tabs-mode nil)

  ;; advice.el
  (setq ad-redefinition-action 'accept)

  ;; files.el
  (setq create-lockfiles nil)
  (setq make-backup-files nil)

  (setq delete-old-versions t)
  (setq trash-directory "~/.Trash")

  ;; simple.el
  (setq backward-delete-char-untabify-method 'hungry)
  (setq column-number-mode nil)
  (setq line-number-mode nil)

  (setq kill-do-not-save-duplicates t)
  (setq kill-ring-max 512)
  (setq kill-whole-line t)

  (setq next-line-add-newlines nil)
  (setq save-interprogram-paste-before-kill t)

  ;; paragraphs.el
  (setq sentence-end-double-space nil)

  ;; prog-mode.el
  (setq prettify-symbols-unprettify-at-point 'right-edge)

  ;; bytecomp.el
  (setq byte-compile-verbose nil)

  (setq warning-minimum-log-level :error)

  ;; enable all commands
  (setq disabled-command-function nil)

  ;; Disable auto copyings
  (setq mouse-drag-copy-region nil)
  (setq select-enable-primary nil)
  (setq select-enable-clipboard t)

  ;; Long lines
  (setq-default truncate-lines t)
  (setq auto-hscroll-mode 'current-line)
  (global-visual-wrap-prefix-mode 1)

  ;; dired.el
  (setq dired-auto-revert-buffer #'dired-directory-changed-p)
  (setq dired-kill-when-opening-new-dired-buffer t)
  (setq dired-free-space nil)
  (setq dired-clean-up-buffers-too nil)
  (setq dired-dwim-target t)
  (setq dired-hide-details-hide-information-lines nil)
  (setq dired-hide-details-hide-symlink-targets nil)
  (setq dired-listing-switches "-lah")
  (setq dired-mouse-drag-files t)
  (setq dired-no-confirm
        '(byte-compile chgrp chmod chown copy hardlink symlink touch))
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq dired-vc-rename-file t)
  (setq dired-movement-style 'cycle-files)
  (add-hook 'dired-mode-hook #'(lambda ()
                                 (dired-hide-details-mode 1)))

  ;; `gls' is preferred on macOS
  (if (eq system-type 'darwin)
      (let ((gls-path "/opt/homebrew/bin/gls"))
        (if (file-executable-p gls-path)
            (setq insert-directory-program gls-path))))

  :config (define-key input-decode-map [?\C-m] [C-m])) ; Default is RET

;;; Global functions for accessibility

;; Ignore temporary buffers
(defun sthenno/filtered-cycle-buffer (cycle-func)
  (let ((original-buffer (current-buffer)))
    (funcall cycle-func)
    (while (and (string-match-p "\\*.*\\*" (buffer-name))
                (not (eq original-buffer (current-buffer))))
      (funcall cycle-func))))

(defun sthenno/cycle-to-next-buffer ()
  (interactive)
  (sthenno/filtered-cycle-buffer 'next-buffer))

(defun sthenno/cycle-to-previous-buffer ()
  (interactive)
  (sthenno/filtered-cycle-buffer 'previous-buffer))

(keymap-global-set "s-<right>" #'sthenno/cycle-to-next-buffer)
(keymap-global-set "s-<left>"  #'sthenno/cycle-to-previous-buffer)

;; Mouse and scrolling
(use-package ultra-scroll
  :vc (:url "https://github.com/jdtsmith/ultra-scroll")
  :init (setq scroll-margin 0
              scroll-conservatively 105)
  :config (ultra-scroll-mode 1))

(provide 'init-system)

;;; init-system.el ends here
