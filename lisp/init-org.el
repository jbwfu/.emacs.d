;; init-org.el --- Org mode configuration  -*- lexical-binding: t -*-
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;;
;; Code:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq org-export-coding-system 'utf-8)
(setq org-fast-tag-selection-single-key 'expert)
(setq org-export-kill-product-buffer-when-displayed t)
(setq org-fontify-whole-heading-line t)
(setq org-directory "~/org-files/")
(setq org-startup-with-inline-images t)
(setq org-startup-with-latex-preview t)

(bind-keys :map org-mode-map
           ("C-c l" . org-store-link))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Modern Org Mode
(use-package org-modern
  :ensure t
  :after (org)
  :init
  (setq org-modern-star '("􀄩"))
  (setq org-modern-hide-stars "􀄩")
  (setq org-modern-list '((?- . "•")))
  (setq org-modern-checkbox '((?X . "􀃰") (?- . "􀃞") (?\s . "􀂒")))
  (setq org-modern-progress '("􀛪" "􀛩" "􀺶" "􀺸" "􀛨"))
  (setq org-modern-table-vertical 2)
  (setq org-modern-block-name nil)
  (setq org-modern-keyword nil)
  (setq org-modern-timestamp nil)
  :config (global-org-modern-mode 1))

(defun my-iconify-org-buffer ()
  (progn
    (push '(":PROPERTIES:" . ?􀈭) prettify-symbols-alist)
    (push '(":ID:      " . ?􀐚) prettify-symbols-alist)
    (push '(":ROAM_ALIASES:" . ?􀅷) prettify-symbols-alist)
    (push '(":END:" . ?􀅽) prettify-symbols-alist)
    (push '("#+TITLE:" . ?􀧵) prettify-symbols-alist)
    (push '("#+AUTHOR:" . ?􀉩) prettify-symbols-alist)
    (push '("#+RESULTS:" . ?􀎚) prettify-symbols-alist)
    (push '("#+ATTR_ORG:" . ?􀌞) prettify-symbols-alist)
    (push '("#+STARTUP: " . ?􀖆) prettify-symbols-alist))
  (prettify-symbols-mode 1))
(add-hook 'org-mode-hook #'my-iconify-org-buffer)

(setq org-ellipsis " 􀍠")
(setq org-hide-emphasis-markers t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Draw fringes in Org mode
(defun my-toggle-internal-fringes ()
  (setq left-margin-width 10)
  (setq right-margin-width 0)
  (set-window-buffer nil (current-buffer)))
(add-hook 'org-mode-hook #'my-toggle-internal-fringes)

;; Fold drawers by default
(setq org-hide-drawer-startup t)
(add-hook 'org-mode-hook #'org-hide-drawer-all)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Org fragments
(setq org-image-actual-width '(420))

(defun my-preview-org-fragments ()
  (interactive)
  (org-display-inline-images)
  (org-latex-preview))

(bind-keys :map org-mode-map
           ("C-x p" . my-preview-org-fragments))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Org links
(setq org-return-follows-link t)
(setq org-link-elisp-confirm-function nil)

(setq-default org-link-frame-setup ; Open files in current frame
              (cl-acons 'file #'find-file org-link-frame-setup))

;; Quick jump to link
(bind-keys :map org-mode-map
           ("s-<return>" . org-open-at-point))

;; Using shift-<arrow-keys> to select text
(setq org-support-shift-select t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Org mode text edition
(use-package org-roam
  :ensure t
  :after (org)
  :config
  (setq org-roam-directory org-directory)
  (setq org-roam-dailies-directory "dates/")
  (setq org-roam-completion-everywhere t)
  (setq org-roam-db-gc-threshold most-positive-fixnum)

  ;; Capture template for `org-roam-dailies'
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "\n* %?"
           :target (file+head
                    "%<%Y-%m-%d>.org"
                    "#+TITLE: %<%Y-%m-%d %A>\n")
           :empty-lines 1)))

  ;; Default capture template for notes
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head
                    "notes/${slug}.org"
                    "#+TITLE: ${title}\n")
           :empty-lines 1
           :unnarrowed t
           :immediate-finish t)))

  (org-roam-db-autosync-mode 1)
  :bind
  (("s-p" . org-roam-dailies-goto-today)
   :map org-mode-map
   (("s-i" . org-roam-node-insert)
    ("s-<up>" . org-roam-dailies-goto-previous-note)
    ("s-<down>" . org-roam-dailies-goto-next-note)))
  :hook
  (org-roam-dailies-find-file . (lambda ()                                  
                                  (save-buffer)
                                  (goto-char (point-max))))
  (after-init . org-roam-dailies-goto-today))

;; Org-roam meets Consult
(use-package consult-org-roam
  :ensure t
  :after (org-roam)
  :config
  (setq consult-org-roam-buffer-after-buffers t)
  :bind
  (:map org-mode-map
        (("s-f" . consult-org-roam-file-find)
         ("s-b" . consult-org-roam-backlinks))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Org LaTeX customizations
(setq org-latex-preview-default-process 'dvisvgm)
(setq org-latex-packages-alist
      '(("T1" "fontenc" t)
        ("" "amsmath" t)
        ("" "bm" t) ; Bold math required
        ("" "mathtools" t)
        ("" "siunitx" t)
        ("" "physics2" t)))

(setq org-latex-preview-preamble
      "\\documentclass{article}
[DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage{xcolor}
\\usephysicsmodule{ab,ab.braket,diagmat,xmat}%
")

(plist-put org-latex-preview-options :scale 2.20)
(plist-put org-latex-preview-options :zoom 1.15)

;; Use `CDLaTeX' to improve editing experiences
(use-package cdlatex
  :ensure t
  :diminish (org-cdlatex-mode)
  :config (add-hook 'org-mode-hook #'turn-on-org-cdlatex))

(add-hook 'org-mode-hook #'(lambda ()
                             (org-latex-preview-auto-mode 1)))

;; To display LaTeX symbols as unicode
(setq org-pretty-entities t)
(setq org-pretty-entities-include-sub-superscripts nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Load languages
;;
;; Org source code blocks
(setq-default org-confirm-babel-evaluate nil)
(setq-default org-src-preserve-indentation t)
(setq-default org-src-fontify-natively t)
(setq-default org-src-tab-acts-natively t)
(setq-default org-edit-src-content-indentation 0)

(org-babel-do-load-languages 'org-babel-load-languages
                             '((emacs-lisp . t)
                               (python . t)))

(provide 'init-org)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; init-org.el ends here
