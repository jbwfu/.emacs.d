;;; early-init.el --- pre-initialisation config -*- no-byte-compile: t; -*- lexical-binding: t; -*-

;; Copyright (C) 2021-2024 Sthenno <sthenno@sthenno.com>

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Code loaded before the package system and GUI is initialized.
;; This file includes:
;;   - Init garbage-collection config
;;   - Native-Compilation specified config
;;   - Early file-loading behaviors
;;   - Init GUI frames config

;;; Code:

;; XXX: Correct PATH to fix homebrew-emacs-plus native-compile specific issues. This is
;; probably caused by the mismatching between version of `comp-libgccjit-version' and
;; GCC that macOS provides.
;;
;; Related issues:
;; - https://github.com/d12frosted/homebrew-emacs-plus/pull/687
;; - https://github.com/d12frosted/homebrew-emacs-plus/pull/492
;; - https://github.com/d12frosted/homebrew-emacs-plus/pull/542

(setenv "LIBRARY_PATH"
        (concat "/opt/homebrew/opt/gcc/lib/gcc/14:"
                "/opt/homebrew/opt/gcc/lib/gcc/14/gcc/aarch64-apple-darwin23/14:"
                "/opt/homebrew/opt/libgccjit/lib/gcc/14"))

;; Use a rather large GC threshold on startup, but revert back to sensible settings
;; afterwards.
;;
;; Stolen from: https://github.com/jwiegley/dot-emacs/blob/814345f/init.el
;; https://gitlab.com/slotThe/dotfiles/-/blob/master/emacs/early-init.el

(setq-default message-log-max 16384
              gc-cons-threshold 402653184
              gc-cons-percentage 0.6)
(add-hook 'after-init-hook #'(lambda ()
                               (setq gc-cons-threshold 16777216
                                     gc-cons-percentage 0.1)
                               (garbage-collect)))

;; Adjust display according to `file-name-handler-alist'.  13feb2024
;; https://github.com/karthink/.emacs.d/blob/master/early-init.el.

;; (let ((old-file-name-handler-alist file-name-handler-alist))
;;   ;; `file-name-handler-alist' is consulted on each `require', `load' and various
;;   ;; path/io functions. You get a minor speed up by insetting this.  Some warning,
;;   ;; however: this could cause problems on builds of Emacs where its site lisp files
;;   ;; aren't byte-compiled and we're forced to load the *.el.gz files (e.g. on Alpine).
;;   (setq-default file-name-handler-alist nil)
;;   ;; ...but restore `file-name-handler-alist' later, because it is needed for handling
;;   ;; encrypted or compressed files, among other things.
;;   (add-hook 'emacs-startup-hook
;;             #'(lambda ()
;;                 (setq file-name-handler-alist
;;                       ;; Merge instead of overwrite because there may have bene changes
;;                       ;; to `file-name-handler-alist' since startup we want to preserve.
;;                       (delete-dups (append file-name-handler-alist
;;                                            old-file-name-handler-alist))))
;;             101))

;; Do not eval this part isolately. `inhibit-redisplay' causes errors.
(unless (or (not (called-interactively-p))
            (daemonp)
            noninteractive)
  (prog1
      (setq-default inhibit-redisplay t
                    inhibit-message t)
    (add-hook 'window-setup-hook #'(lambda ()
                                     (setq-default inhibit-redisplay nil
                                                   inhibit-message nil)
                                     (redisplay)))))

(progn
  ;; Site files tend to use `load-file', which emits "Loading X..." messages in the echo
  ;; area, which in turn triggers a re-display. Re-displays can have a substantial
  ;; effect on startup times and in this case happens so early that Emacs may flash
  ;; white while starting up.
  (define-advice load-file (:override (file) silence)
    (load file nil 'nomessage))

  ;; Undo our `load-file' advice above, to limit the scope of any edge cases it may
  ;; introduce down the road.
  (define-advice startup--load-user-init-file (:before (&rest _) nomessage-remove)
    (advice-remove #'load-file #'load-file@silence)))


;; Customize Native-Compilation and caching
(defvar user-cache-directory "~/.cache/emacs/"
  "Location that files created by Emacs are placed.")

(setq native-comp-speed 3)

;; By default any warnings encountered during async native compilation pops up. As this
;; tends to happen rather frequently with a lot of packages, it can get annoying.
(setq native-comp-async-report-warnings-errors 'silent)

;; Perform drawing the frame when initialization
;;
;; NOTE: `menu-bar-lines' is forced to redrawn under macOS GUI, therefore it is helpless
;; by inhibiting it in the early stage. However, since I don't use the `menu-bar' under
;; macOS, `menu-bar-mode' is disabled later.

(push '(tool-bar-lines . 0)   default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; font. By inhibiting this, we halve startup times, particularly when we use
;; fonts that are larger than the system default (which would resize the frame)
(setq frame-inhibit-implied-resize t)

