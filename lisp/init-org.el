;;; init-org.el --- Org mode configuration  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'org)

;; Org default directory
(setq-default org-directory
              (expand-file-name "PLEASE/" my-dev-path))

;; Open Org files with previewing
(setq org-startup-with-inline-images t)
(setq org-startup-with-latex-preview t)


;; Org Modern
(use-package org-modern
  :init
  (setq org-modern-star '("􀄩"))
  (setq org-modern-hide-stars "􀄩")
  (setq org-modern-list '((?- . "•")))
  (setq org-modern-checkbox '((?X . "􀃠")
                              (?- . "􀃞")
                              (?\s . "􀂒")))
  (setq org-modern-block-name '(("src" . ("􀓪" "􀅽"))))
  (setq org-modern-keyword nil)
  (setq org-modern-block-fringe nil)
  (global-org-modern-mode 1))


;; Symbols in Org mode
(add-hook 'prog-mode-hook #'prettify-symbols-mode)
(add-hook 'org-mode-hook #'(lambda ()
                             (setq prettify-symbols-alist
                                   '((":PROPERTIES:" . ?􀈣)
                                     (":ID:" . ?􀅳)
                                     (":END:" . ?􀅽)
                                     ("#+TITLE:" . ?􀎞)
                                     ("#+RESULTS:" . ?􀆀)
                                     ("#+ATTR_ORG:" . ?􀣋)
                                     ("SCHEDULED:" . ?􀧞)
                                     ("CLOSED:" .?􁜒)))
                             (prettify-symbols-mode 1)))

(setq org-ellipsis " 􀍠")
(setq org-hide-emphasis-markers t)

;; Setup pretty entities for unicode math symbols
;; (setq org-pretty-entities t)
;; (setq org-pretty-entities-include-sub-superscripts nil)
;;
;; Draw fringes in Org mode
(defun my/toggle-internal-fringes ()
  (setq left-margin-width 5)
  (setq right-margin-width 5)
  (set-window-buffer nil (current-buffer)))

(add-hook 'org-mode-hook #'my/toggle-internal-fringes)


;; Fold drawers by default
(setq org-hide-drawer-startup t)
(add-hook 'org-mode-hook #'org-hide-drawer-all)


;; Org images
(with-eval-after-load 'org
  (setq org-image-actual-width '(300)) ; Fallback to `300'
  (define-key org-mode-map (kbd "s-p") (lambda ()
                                         (interactive)
                                         (org-latex-preview)
                                         (org-display-inline-images))))


;; Org links
(setq org-return-follows-link t)
(setq org-link-elisp-confirm-function nil)

(setq-default org-link-frame-setup ; Open files in current frame
              (cl-acons 'file #'find-file org-link-frame-setup))

;; Using shift-<arrow-keys> to select text
(setq org-support-shift-select t)

;; Load languages
(with-eval-after-load 'org

  ;; Org source code blocks
  (setq-default org-confirm-babel-evaluate nil)
  (setq-default org-src-preserve-indentation t)
  (setq-default org-src-fontify-natively t)
  (setq-default org-src-tab-acts-natively t)
  (setq-default org-edit-src-content-indentation 0)

  (org-babel-do-load-languages 'org-babel-load-languages
                               '((emacs-lisp . t)
                                 (python . t))))


;; Org mode text edition
;; Number of empty lines needed to keep an empty line between collapsed trees
(setq-default org-cycle-separator-lines 2)


(use-package emacsql-sqlite-builtin)

(use-package org-roam
  :straight (
             :host github
             :repo "org-roam/org-roam")
  :init
  (global-unset-key (kbd "s-n"))
  :bind
  (("s-n j" . org-roam-dailies-goto-today)
   (:map org-mode-map
         ("s-n n" . org-id-get-create)
         ("s-n a" . org-roam-alias-add)
         ("s-n f" . org-roam-node-find)
         ("s-n i" . org-roam-node-insert)
         ("s-n l" . org-roam-buffer-toggle)))

  ;; Key-bindings for `org-roam-dailies'
  (:map org-mode-map
        ("<s-up>" . org-roam-dailies-goto-previous-note)
        ("<s-down>" . org-roam-dailies-goto-next-note))

  ;; Open link from Org Roam window with mouse click
  (:map org-roam-mode-map
        ("<mouse-1>" . org-roam-preview-visit))
  :config
  (setq org-roam-database-connector 'sqlite-builtin)
  (setq org-roam-db-location (expand-file-name "org-roam.db" org-directory))
  (setq org-roam-directory org-directory)
  (setq org-roam-dailies-directory "dates/")
  (setq org-roam-completion-everywhere t)
  (setq org-roam-db-gc-threshold most-positive-fixnum)

  (org-roam-db-autosync-mode 1)

  ;; Capture template for `org-roam-dailies'
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "\n* %?"
           :target (file+head "%<%Y-%m-%d>.org"
                              "#+TITLE: %<%Y-%m-%d • %A>\n")
           :empty-lines 1)))

  ;; Default capture template for notes
  (setq org-roam-capture-templates
	'(("d" "default" plain "%?"
           :target (file+head "notes/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+TITLE: ${title}\n")
           :empty-lines 1
           :unnarrowed t
           :immediate-finish t
           :kill-buffer t))))


;; Open today's note when startup
(add-hook 'after-init-hook #'(lambda ()
                               (interactive)
                               (org-roam-dailies-goto-today)
                               (save-buffer)))


;; Org Agenda
(define-key global-map (kbd "C-c a") #'org-agenda)

(setq org-agenda-files '("~/Developer/PLEASE/dates/"
                         "~/Developer/PLEASE/notes/"))

(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)

(setq org-edit-timestamp-down-means-later t)
(setq org-export-coding-system 'utf-8)
(setq org-export-kill-product-buffer-when-displayed t)
(setq org-html-validation-link nil)
(setq org-fast-tag-selection-single-key 'expert)

;; Appearances
(setq org-auto-align-tags nil)
(setq org-catch-invisible-edits 'show-and-error)
(setq org-agenda-block-separator ?─)
(setq org-agenda-time-grid
      '((daily today require-timed)
        (800 1000 1200 1400 1600 1800 2000)
        " ───── " "───────────────"))
(setq org-agenda-current-time-string
      "⭠ now ─────────────────────────────────────────────────")
(setq org-agenda-block-separator nil)
(setq org-tags-colum 0)


(provide 'init-org)
;;; init-org.el ends here
