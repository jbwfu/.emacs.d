;;; init-projects.el --- Project management -*- lexical-binding: t; -*-

;; Copyright (C) 2021-2025 Sthenno <sthenno@sthenno.com>

;; This file is not part of GNU Emacs.

;;; Commentary:
;;
;;

;;; Code:
;;

(use-package project
  :ensure nil
  :defer t
  :config
  ;; (setq project-mode-line t)
  (setq project-list-file (locate-user-emacs-var-file "project-list.eld"))
  (setq project-prompter #'project-prompt-project-name))

;;; Git client using Magit

(use-package magit
  :ensure t
  :config (setq magit-diff-refine-hunk t)
  :bind ("C-x g" . magit-status))

(use-package magit-delta
  :ensure t
  :if (executable-find "delta")
  :hook (magit-mode . magit-delta-mode)
  :config
  (setq magit-delta-delta-args
        `("--max-line-distance" "0.6"
          "--true-color" ,(if xterm-color--support-truecolor "always" "never")
          "--color-only"
          "--syntax-theme" "none")))

;;; Xref

(use-package xref
  :init (setq xref-search-program 'ripgrep)
  :bind (("M-/" . xref-find-references)))

(provide 'init-projects)

;;; init-projects.el ends here
