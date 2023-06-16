;; init-projects.el --- Project management in Emacs -*- lexical-binding: t -*-
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;;
;; Note this file should be loaded before loading `init-org-roam.el',
;; since package `magit.el' provides functions `org-roam.el' also needs.
;;
;; Code:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Git client Magit
(use-package magit
  :ensure t
  :defer t
  :config
  (setq magit-diff-refine-hunk t)
  (setq magit-section-visibility-indicator nil) ; Disable showing the bitmap indicators
  :bind ("C-x g" . magit-status))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Project management
(use-package projectile
  :ensure t
  :init
  (let ((local-project-path "~/Developer/")
        (project-path-list '()))
    (push local-project-path project-path-list)
    (setq projectile-project-search-path project-path-list))
  (setq-default projectile-generic-command "rg --files --hidden")
  :config
  (setq projectile-mode-line-prefix " 􀤞")
  (projectile-mode 1)
  :bind
  ((:map projectile-mode-map
         ("C-c p" . 'projectile-command-map))))


(provide 'init-projects)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; init-projects.el ends here
