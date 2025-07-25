;;; init-temp.el --- Modern template system -*- lexical-binding: t; -*-

;; Copyright (C) 2021-2025 Sthenno <sthenno@sthenno.com>

;; This file is not part of GNU Emacs.

;;; Commentary:

;;; Code:
;;

;;; Abbrevs

(use-package abbrev
  :diminish
  :init
  (setq abbrev-file-name (locate-user-emacs-var-file "abbrev.el"))

  ;; Do not ask before saving abbrevs
  (setq save-abbrevs 'silently)

  :hook ((text-mode prog-mode) . abbrev-mode)
  :bind (("C-x a e" . edit-abbrevs)
         ("C-x a a" . add-global-abbrev)))

;;; YASnippet

(use-package yasnippet
  :ensure t
  :hook (after-init . yas-global-mode)
  :diminish (yas-minor-mode)
  :config
  (setq yas-triggers-in-field t))

(provide 'init-temp)

;;; init-temp.el ends here
