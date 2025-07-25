;;; init-org.el --- Org Mode -*- lexical-binding: t; -*-

;; Copyright (C) 2021-2025 Sthenno <sthenno@sthenno.com>

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This config is currently for a patched version of Org that is under development.
;; See https://code.tecosaur.net/tec/org-mode for more details.
;;
;; This file includes:
;;
;; - Org Mode basics
;; - TEC's `org-latex-preview' specific configurations
;; - Modern Org Mode
;; - Note-taking system using `denote'

;;; Code:

(use-package org
  :ensure t
  :defer t
  :preface (progn
             (assq-delete-all 'org package--builtins)
             (assq-delete-all 'org package--builtin-versions))
  :vc (org
       :url "https://code.tecosaur.net/tec/org-mode.git"
       :branch "dev"
       :lisp-dir "lisp"))

(use-package org
  :ensure nil
  :hook ((org-mode . org-fold-hide-drawer-all))
  :config
  ;; Setup default directory
  (setq org-directory "~/org/")

  (let ((target-directory (locate-user-emacs-var-file "org/")))
    (unless (file-directory-p target-directory)
      (make-directory target-directory t))
    (setq org-persist-directory (concat target-directory "persist/")))

  ;; Org Mode buffer init behaviors
  (setq org-startup-with-link-previews t
        org-startup-with-latex-preview t)

  ;; Fold titles by default
  ;; (setq org-startup-folded 'content)

  ;; External settings for `org-modern'
  (setq org-ellipsis " …")
  (setq org-use-property-inheritance t)
  (setq org-auto-align-tags nil)
  (setq org-tags-column 0)
  (setq org-hide-emphasis-markers t)

  ;; Use this with "C-<return>"
  (setq org-insert-heading-respect-content t)

  ;; Use this with "C-S-<return>"
  (setq org-treat-insert-todo-heading-as-state-change t)

  ;; Better experiences jumping through headlines
  (setq org-special-ctrl-a/e t)

  ;; Fold drawers by default
  (setq org-cycle-hide-drawer-startup t)

  ;; Org images
  (setq org-image-align 'left
        org-image-actual-width '(420)
        org-image-max-width 'fill-column)
  (setq org-yank-dnd-method 'file-link)
  (setq org-yank-image-save-method (expand-file-name "images/" org-directory))

  ;; Org Hyperlinks
  (setq org-return-follows-link t)

  ;; Open file links in current window
  (setf (cdr (assoc 'file org-link-frame-setup)) 'find-file)

  ;; Using shift-<arrow-keys> to select text
  (setq org-support-shift-select 'always) ; Everywhere except timestamps
  (setq org-use-fast-todo-selection 'expert)


  ;; Do not ask for confirmation before executing
  (setq org-link-elisp-confirm-function nil
        org-link-shell-confirm-function nil)

  (setq org-use-sub-superscripts '{})
  (setq org-pretty-entities t
        org-pretty-entities-include-sub-superscripts nil))

;;; Load languages for Org Babel

(use-package org
  :ensure nil
  :bind
  (:map org-mode-map
        ("C-'" . org-edit-special)
        ("S-<return>" . org-babel-execute-maybe)
        :map org-src-mode-map
        ("C-'" . org-edit-src-exit))
  :config
  ;; Org code blocks
  (setq org-confirm-babel-evaluate nil)

  (setq org-src-preserve-indentation t
        org-edit-src-content-indentation 0
        org-edit-src-persistent-message nil
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-src-window-setup 'current-window
        org-src-ask-before-returning-to-edit-buffer nil)

  ;; In addition to `org-src-fontify-natively'
  (add-to-list 'org-src-lang-modes (cons "python" 'python))
  (add-to-list 'org-src-lang-modes (cons "dockerfile" 'dockerfile-ts))

  (setq org-edit-src-turn-on-auto-save t)

  ;; Prefer lower-case drawers
  (setq org-babel-results-keyword "results")

  ;; Using `S-<return>' instead
  (setq org-babel-no-eval-on-ctrl-c-ctrl-c t)

  ;; Enable these languages for Org-Babel
  (org-babel-do-load-languages 'org-babel-load-languages '((emacs-lisp . t)
                                                           (python . t)))

  ;; Specific `org-babel-python-command'
  (setq org-babel-python-command
        (expand-file-name "functions/.venv/bin/python" org-directory)))

;;; latex

;; Install AUCTeX
(use-package tex :ensure auctex :defer t)

;; ;; Use CDLaTeX to improve editing experiences

;; (use-package cdlatex
;;   :ensure t
;;   :diminish (org-cdlatex-mode)
;;   :config (add-hook 'org-mode-hook #'turn-on-org-cdlatex))

(use-package org
  :ensure nil
  :defer t
  :init
  ;; Default LaTeX preview image directory
  (setq org-preview-latex-image-directory (locate-user-emacs-var-file "org/ltximg/"))

  (setq org-highlight-latex-and-related '(native)) ; Highlight inline LaTeX code

  (setopt org-latex-packages-alist '(("" "siunitx"   t)
                                     ("" "mlmodern" t)

                                     ;; Load this after all math to give access to bold math
                                     ;; See https://ctan.org/pkg/newtx
                                     ("" "bm" t)

                                     ;; Package physics2 requires to be loaded after font
                                     ;; packages. See https://ctan.org/pkg/physics2
                                     ("" "physics2" t))))


;; only for https://code.tecosaur.net/tec/org-mode
(use-package org
  :ensure nil
  :if (fboundp 'org-latex-preview-auto-mode)
  :hook (org-mode . org-latex-preview-auto-mode)
  :bind (:map org-mode-map ("C-p" . sthenno/org-preview-fragments))
  :config
  ;; Preview functions
  (defun sthenno/org-preview-fragments ()
    (interactive)
    (call-interactively 'org-latex-preview-clear-cache)
    (org-latex-preview 'buffer)
    (org-link-preview-refresh))

  ;; Add additional modules required by LaTeX packages like physics2 to the preamble
  (cl-flet ((format-modules (m)
              (let ((options (car  m))
                    (module  (cadr m)))
                (if (string= options "")
                    (format "\\usephysicsmodule{%s}" module)
                  (format "\\usephysicsmodule[%s]{%s}" options module)))))

    (let* ((physics2-modules '(("" "ab")
                               ("" "diagmat")
                               ("" "xmat")))
           (physics2-preamble (mapconcat #'format-modules physics2-modules "\n"))
           (default-preamble (mapconcat #'identity
                                        '("\\documentclass{article}"
                                          "\\[DEFAULT-PACKAGES]"
                                          "\\[PACKAGES]"
                                          "\\usepackage{xcolor}")
                                        "\n")))
      ;; (setopt org-latex-preview-preamble
      (concat default-preamble "\n"
              physics2-preamble "\n"
              "\\DeclareMathOperator*{\\argmax}{arg\\,max}\n"
              "\\DeclareMathOperator*{\\argmin}{arg\\,min}"))))

;; (let ((factor (- (/ (face-attribute 'default :height)
;;                     100.0)
;;                  0.025)))
;;   (plist-put org-latex-preview-appearance-options :scale factor)
;;   (plist-put org-latex-preview-appearance-options :zoom  factor))

;; (setq org-latex-preview-process-default 'dvisvgm)
;; (let ((dvisvgm (alist-get 'dvisvgm org-latex-preview-process-alist))
;;       (libgs "/opt/homebrew/opt/ghostscript/lib/libgs.dylib"))
;;   (plist-put dvisvgm :image-converter
;;              `(,(concat "dvisvgm --page=1- --optimize --clipjoin --relative --no-fonts"
;;                         " --libgs=" libgs
;;                         " --bbox=preview -v3 -o %B-%%9p.svg %f"))))

;;; Modern Org mode theme
(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star 'replace)
  (let ((stars "􀄩"))
    (setq org-modern-replace-stars stars
          org-modern-hide-stars stars))
  (setq org-modern-list '((?- . "•")))
  (setq org-modern-checkbox '((?X  . "􀃰")
                              (?-  . "􀃞")
                              (?\s . "􀂒")))
  (setq org-modern-timestamp '(" %Y-%m-%d " . " %H:%M "))
  (setq org-modern-block-name
        '(("src"   . ("􀃥" "􀃥"))
          ("quote" . ("􁈏" "􁈐"))
          (t . t)))
  (setq org-modern-keyword '(("title"   . "􁓔")
                             ("results" . "􀎛")
                             (t . t))))

;;; The Zettlekasten note-taking system by Denote
(use-package denote
  :ensure t
  :after org
  :hook ((dired-mode . denote-dired-mode)
         (org-mode . denote-rename-buffer-mode))
  :bind (("s-o" . denote-open-or-create)
         :map org-mode-map
         ("s-i" . denote-link-or-create)
         ("s-l" . denote-insert-link)
         ("s-<up>" . sthenno/denote-open-previous-file)
         ("s-<down>" . sthenno/denote-open-next-file))
  :config
  (setq denote-directory org-directory)
  (setq denote-file-type 'org)
  (setq denote-known-keywords '("silos" "papers" "production" "statics" "marked")
        denote-infer-keywords t)
  (setq denote-save-buffers t
        denote-kill-buffers t)
  (setq denote-open-link-function #'find-file)

  ;; Automatically rename Denote buffers when opening them so that instead of their long
  ;; file name they have a literal "[D]" followed by the file's title.  Read the doc
  ;; string of `denote-rename-buffer-format' for how to modify this.
  ;; (denote-rename-buffer-mode 1)

  (setq denote-buffer-name-prefix   "􁓯 ")
  (setq denote-rename-buffer-format "%D%b")

  ;; The `denote-rename-buffer-mode' can now show if a file has backlinks
  (setq denote-rename-buffer-backlinks-indicator " ↔ ")

  ;; Do not issue any extra prompts. Always sort by the `title' file name component and
  ;; never do a reverse sort.
  (setq denote-sort-dired-extra-prompts nil)
  (setq denote-sort-dired-default-sort-component 'title)
  (setq denote-sort-dired-default-reverse-sort t)

  ;; Helper functions
  (defun sthenno/denote-get-sorted-note-files (directory)
    "Return a list of note files in DIRECTORY, sorted by name."
    (sort (seq-filter 'denote-file-is-note-p
                      (directory-files directory t "\\`[^.]"))
          'string<))

  (defun sthenno/denote-open-stages-file (direction)
    "Open the denote note file in the given DIRECTION."
    (let* ((current-file (buffer-file-name))
           (directory (file-name-directory current-file))
           (sorted-files (sthenno/denote-get-sorted-note-files directory))
           (current-file-index (cl-position current-file sorted-files :test 'string=)))
      (if (null current-file-index)
          (message "Current file is not a note file.")
        (let ((idx (+ current-file-index direction)))
          (if (or (< idx 0)
                  (>= idx (length sorted-files)))
              (message "No denote note file.")
            (find-file (nth idx sorted-files)))))))

  (defun sthenno/denote-open-previous-file ()
    "Open the previous note file in the current directory."
    (interactive)
    (sthenno/denote-open-stages-file -1))

  (defun sthenno/denote-open-next-file ()
    "Open the next note file in the current directory."
    (interactive)
    (sthenno/denote-open-stages-file 1)))

(use-package denote-journal
  :ensure t
  :bind ("C-c d" . denote-journal-new-or-existing-entry)
  :config
  (setq denote-journal-title-format "%Y-%m-%d") ; Format yyyy-mm-dd
  (setq denote-journal-directory (expand-file-name "stages/" denote-directory))
  (setq denote-journal-keyword '("stages")) ; Stages are journals

  ;; Do not include date, tags and ids in note files
  (advice-add 'denote-journal-new-entry :around
              (lambda (orig-fun &rest args)
                (let ((denote-org-front-matter "#+title: %1$s\n\n"))
                  (apply orig-fun args)))))

(use-package denote-org
  :ensure t
  :defer t
  :init (setq denote-org-store-link-to-heading 'context))

(provide 'init-org)

;;; init-org.el ends here
