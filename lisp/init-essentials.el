;;; init-essentials.el --- Essential configurations -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; This file is not part of GNU Emacs.

;;; Commentary:

;;; Code:
;;

(setq auto-save-list-file-prefix (locate-user-emacs-var-file "auto-save-list/"))

(use-package url
  :ensure nil
  :config
  (setq url-configuration-directory (locate-user-emacs-var-file "url/"))
  ;; (setq url-cache-directory (locate-user-emacs-var-file "url/cache"))
  (setq url-cookie-file (locate-user-emacs-var-file "url/cookies.el"))
  (setq url-history-file (locate-user-emacs-var-file "url/history.el")))

(use-package tramp
  :ensure nil
  :config
  (setq tramp-persistency-file-name
        (locate-user-emacs-var-file "tramp/persistency.eld")))

(use-package bookmark
  :ensure nil
  :config
  (setq bookmark-default-file (locate-user-emacs-var-file "bookmark-default.eld")))

(use-package eshell
  :ensure nil
  :config
  (setq eshell-directory-name (locate-user-emacs-var-file "eshell/")))

(provide 'init-essentials)

;;; init-essentials.el ends here
