;; init-org.el --- Org mode configuration  -*- lexical-binding: t -*-
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;;
;; Code:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; output_org-config
;; org-value
(setq org-export-coding-system 'utf-8)
(setq org-fast-tag-selection-single-key 'expert)
(setq org-export-kill-product-buffer-when-displayed t)
(setq org-fontify-whole-heading-line t)
(setq org-directory "~/org-files/")
(setq org-startup-with-inline-images t)
(setq org-startup-with-latex-preview t)
(setq org-startup-folded 'content)
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
(setq org-insert-mode-line-in-empty-file t)

;; org-key/map
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Quick jump to link
(bind-keys :map org-mode-map
           ("s-<return>" . org-open-at-point))

;; package_org-modern
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

(setq org-ellipsis " 􀍠")
(setq org-hide-emphasis-markers t)

;; prettify-symbols-alist
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
;; (add-hook 'org-mode-hook #'my-iconify-org-buffer)

;; org-mode-hook
;; Draw fringes in Org mode
(defun my-toggle-internal-fringes ()
  (setq left-margin-width 10)
  (setq right-margin-width 0)
  (set-window-buffer nil (current-buffer)))
(add-hook 'org-mode-hook #'my-toggle-internal-fringes)

;; Fold drawers by default
(setq org-hide-drawer-startup t)
(add-hook 'org-mode-hook #'org-hide-drawer-all)

;; org-image
(setq org-image-actual-width '(420))

(defun my-preview-org-fragments ()
  (interactive)
  (org-display-inline-images)
  (org-latex-preview))

(bind-keys :map org-mode-map
           ("C-x p" . my-preview-org-fragments))

;; org-link
(setq org-return-follows-link t)
(setq org-link-elisp-confirm-function nil)

(setq-default org-link-frame-setup ; Open files in current frame
              (cl-acons 'file #'find-file org-link-frame-setup))

;; Quick jump to link
(bind-keys :map org-mode-map
           ("s-<return>" . org-open-at-point))

;; package_org-roam
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

;; package_consult-org-roam
(use-package consult-org-roam
  :ensure t
  :after (org-roam)
  :config
  (setq consult-org-roam-buffer-after-buffers t)
  :bind
  (:map org-mode-map
        (("s-f" . consult-org-roam-file-find)
         ("s-b" . consult-org-roam-backlinks))))

;; org-latex-customizations
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
;; output_org-todo-config
;; org-tag-value
; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)

;; org-todo-keywords
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "|" "DONE(d)")
              (sequence "LEARNING(l)" "SUSPEND(s@/!)" "|" "FINISHED" "CANCELLED(c@/!)")
              (sequence "CONSTRUCTING" "BUG(b@/!)" "|" "FIXED(f@/!)"))))

;; org-todo-keyword-faces


;; org-todo-state-tags-triggers
(setq org-todo-state-tags-triggers
      (quote (("SUSPEND" ("SUSPEND" . t))
              ("FINISHED" ("FINISHED" . t))
              ("BUG" ("FIXED") ("BUG" . t))
              ("FIXED" ("BUG") ("FIXED" . t))
              ("LEARNING" ("WAITING") ("CANCELLED") ("LEARNING" . t))
              ("SUSPEND" ("LEARNING") ("CANCELLED") ("SUSPEND" . t))
              ("WAITING" ("WAITING" . t))
              ("CANCELLED" ("LEARNING") ("WAITING") ("CANCELLED" . t))
              ("TODO" ("LEARNING") ("SUSPEND") ("FINISHED") ("CANCELLED") ("FIXED"))
              ("NEXT" ("LEARNING") ("SUSPEND") ("FINISHED") ("CANCELLED"))
              ("DONE" ("LEARNING") ("SUSPEND") ("CANCELLED") ("BUG"))
              (done ("SUSPEND") ("BUG") ("LEARNING") ("WAITING")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; output_org-todo-config
;; org-tag-value
; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)

;; org-todo-keywords
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "|" "DONE(d)")
              (sequence "LEARNING(l)" "SUSPEND(s@/!)" "|" "FINISHED" "CANCELLED(c@/!)")
              (sequence "CONSTRUCTING" "BUG(b@/!)" "|" "FIXED(f@/!)"))))

;; org-todo-keyword-faces


;; org-todo-state-tags-triggers
(setq org-todo-state-tags-triggers
      (quote (("SUSPEND" ("SUSPEND" . t))
              ("FINISHED" ("FINISHED" . t))
              ("BUG" ("FIXED") ("BUG" . t))
              ("FIXED" ("BUG") ("FIXED" . t))
              ("LEARNING" ("WAITING") ("CANCELLED") ("LEARNING" . t))
              ("SUSPEND" ("LEARNING") ("CANCELLED") ("SUSPEND" . t))
              ("WAITING" ("WAITING" . t))
              ("CANCELLED" ("LEARNING") ("WAITING") ("CANCELLED" . t))
              ("TODO" ("LEARNING") ("SUSPEND") ("FINISHED") ("CANCELLED") ("FIXED"))
              ("NEXT" ("LEARNING") ("SUSPEND") ("FINISHED") ("CANCELLED"))
              ("DONE" ("LEARNING") ("SUSPEND") ("CANCELLED") ("BUG"))
              (done ("SUSPEND") ("BUG") ("LEARNING") ("WAITING")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; output_org-agenda-config
;; org-agenda-value
;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

;; Keep tasks with dates on the global todo lists
(setq org-agenda-todo-ignore-with-date nil)

;; Keep tasks with deadlines on the global todo lists
(setq org-agenda-todo-ignore-deadlines nil)

;; Keep tasks with scheduled dates on the global todo lists
(setq org-agenda-todo-ignore-scheduled nil)

;; Keep tasks with timestamps on the global todo lists
(setq org-agenda-todo-ignore-timestamp nil)

;; Remove completed deadline tasks from the agenda view
(setq org-agenda-skip-deadline-if-done t)

;; Remove completed scheduled tasks from the agenda view
(setq org-agenda-skip-scheduled-if-done t)

;; Remove completed items from search results
(setq org-agenda-skip-timestamp-if-done t)

;; org-agenda-custom-commands
(setq org-agenda-custom-commands
      '(("n" "Agenda and all TODOs"
         ((agenda #1="")
          (alltodo #1#)
          (tags "REFILE"
                ((org-agenda-overriding-header "Tasks to Refile")
                 (org-tags-match-list-sublevels nil)))))
        ("h" "test"
         ((agenda "" nil)
          (tags "elisp"
                ((org-agenda-overriding-header "Tasks to elisp")
                 (org-tags-match-list-sublevels nil)))
          (tags "BUG"
                ((org-agenda-overriding-header "Tasks to bug")
                 (org-tags-match-list-sublevels nil)))))
        ("o" . "orgmode + type tag searches") ; describe prefix "h"
        ("oc" tags "+orgmode+config")
        ("oe" tags "+orgmode+elisp")
        ("ot" tags "+orgmode+tutoraila")))

;; org-agenda-auto-exclude-function
(defun bh/org-auto-exclude-function (tag)
  "Automatic task exclusion in the agenda with / RET"
  (and (cond
        ((string= tag "docker")
         t)
        ((string= tag "bug")
         t))
       (concat "-" tag)))

(setq org-agenda-auto-exclude-function 'bh/org-auto-exclude-function)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; output_init-org-capture
;; org-capture-value
(setq org-default-notes-file "~/org-files/capture/refile.org")

;; org-capture-templates
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/org-files/capture/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/org-files/capture/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/org-files/capture/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/org-files/capture/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/org-files/capture/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/org-files/capture/refile.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/org-files/capture/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/org-files/capture/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))


;; org-clock-out-hook
;; Remove empty LOGBOOK drawers on clock out
(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "LOGBOOK" (point))))

(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; output_org-refile-config
;; org-refile-value
; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps t)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use the current window when visiting files and buffers with ido
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)
; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)

;; org-refile-target-verify-function
;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; output_org-clock-config
;; org-clock-value
;;
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)
;; Removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; org-agenda-custom-commands
(setq org-agenda-custom-commands
      '(("n" "Agenda and all TODOs"
         ((agenda #1="")
          (alltodo #1#)
          (tags "REFILE"
                ((org-agenda-overriding-header "Tasks to Refile")
                 (org-tags-match-list-sublevels nil)))))
        ("h" "test"
         ((agenda "" nil)
          (tags "elisp"
                ((org-agenda-overriding-header "Tasks to elisp")
                 (org-tags-match-list-sublevels nil)))
          (tags "BUG"
                ((org-agenda-overriding-header "Tasks to bug")
                 (org-tags-match-list-sublevels nil)))))
        ("o" . "orgmode + type tag searches") ; describe prefix "h"
        ("oc" tags "+orgmode+config")
        ("oe" tags "+orgmode+elisp")
        ("ot" tags "+orgmode+tutoraila")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; output_org-clock-config
;; org-clock-value
;;
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)
;; Removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; org-agenda-custom-commands
(setq org-agenda-custom-commands
      '(("n" "Agenda and all TODOs"
         ((agenda #1="")
          (alltodo #1#)
          (tags "REFILE"
                ((org-agenda-overriding-header "Tasks to Refile")
                 (org-tags-match-list-sublevels nil)))))
        ("h" "test"
         ((agenda "" nil)
          (tags "elisp"
                ((org-agenda-overriding-header "Tasks to elisp")
                 (org-tags-match-list-sublevels nil)))
          (tags "BUG"
                ((org-agenda-overriding-header "Tasks to bug")
                 (org-tags-match-list-sublevels nil)))))
        ("o" . "orgmode + type tag searches") ; describe prefix "h"
        ("oc" tags "+orgmode+config")
        ("oe" tags "+orgmode+elisp")
        ("ot" tags "+orgmode+tutoraila")))

(provide 'init-org)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; init-org.el ends here
