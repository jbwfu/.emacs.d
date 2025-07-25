;;; init-comp.el --- Modern completion system  -*- lexical-binding: t; -*-

;; Copyright (C) 2021-2025 Sthenno <sthenno@sthenno.com>

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This file includes:
;; - completion styles enhancement using `orderless'
;; - minibuffer enhancement using `vertico' and `consult'
;; - pop-up completions by `corfu' as frontend and `cape' as backend
;;
;; NOTE: Package `embark' is not included in this config due to my personal preferences.
;; Template's setups such as that for `abbrev' are placed separately in `init-temp' but
;; `dabbrev' is configured in this file under current decision.

;;; Code:

;;; Build the completion framework
;;
;; Completion and minibuffer basics
;;

;; Prevent auto-composition of characters around point
;; (setq composition-break-at-point t)

;; Completion basics. See also `orderless'
;;

;; TAB cycle if there are only few candidates
(setq completion-cycle-threshold nil)   ; Always show candidates in menu

;; Emacs 30: `cape-dict' is used instead.
;; NOTE: `setopt' is necessary.
(setopt text-mode-ispell-word-completion nil)

;; Do not use the TAB key for `completion-at-point'.
(setq tab-always-indent 'complete)
(setq tab-first-completion nil)

;; minibuffer
(setq echo-keystrokes 0.05)             ; Display the key pressed immediately
(setq resize-mini-windows t)

;; Help buffer
(setq help-window-select t)

;; Support opening new minibuffers from inside existing minibuffers
(setq enable-recursive-minibuffers t)
(setq read-minibuffer-restore-windows nil)

;; Hide undefined commands in M-x
(setq read-extended-command-predicate #'command-completion-default-include-p)
(setq minibuffer-default-prompt-format " [%s]"
      minibuffer-completion-auto-choose t
      minibuffer-visible-completions nil)

;; Do not allow the cursor in the minibuffer prompt
(setopt minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
(setq crm-prompt (format "%s %%p" (propertize "[%d]" 'face 'shadow)))
(file-name-shadow-mode 1)

;;; Use the `orderless' completion style
(use-package orderless
  :ensure t
  :init
  (setq completion-pcm-leading-wildcard t) ; Emacs 31: make `partial-completion' behave like `substring'

  ;; The basic completion style is specified as fallback in addition to orderless in
  ;; order to ensure that completion commands rely on dynamic completion tables
  (setq-default completion-styles '(orderless basic)
                completion-category-defaults nil
                completion-category-overrides '((file (styles partial-completion))

                                                ;; There is further configuration for
                                                ;; better `eglot' support. See also
                                                ;; `init-eglot'
                                                (eglot      (styles orderless))
                                                (eglot-capf (styles orderless))))
  :config
  (orderless-define-completion-style orderless-literal-only
    (orderless-style-dispatchers nil)
    (orderless-matching-styles '(orderless-literal)))
  (setq-default orderless-matching-styles
                '(orderless-literal orderless-prefixes)))

;; Sort candidates by `minibuffer-sort-by-history'
(setq completions-sort 'historical
      completion-auto-help nil
      completion-show-help nil
      completion-show-inline-help nil)

;; Ignore cases for completions
(setq-default completion-ignore-case t)
(setq-default read-file-name-completion-ignore-case t
              read-buffer-completion-ignore-case t)

;;; Completions in minibuffers
(use-package vertico
  :ensure t
  :hook ((after-init . vertico-mode)
         (rfn-eshadow-update-overlay . vertico-directory-tidy))
  :bind ((:map vertico-map
               ("<tab>"       . vertico-insert)
               ("<return>"    . vertico-directory-enter)
               ("<backspace>" . vertico-directory-delete-char)))
  :init
  (advice-add #'tmm-add-prompt :after #'minibuffer-hide-completions)

  ;; Disable showing the *Completions* buffer that conflicts with `vertico' if using
  ;; `ffap-menu'
  (advice-add #'ffap-menu-ask :around
              (lambda (&rest args)
                (cl-letf (((symbol-function #'minibuffer-completion-help)
                           #'ignore))
                  (apply args))))

  ;; Use `consult-completion-in-region' if `vertico' is enabled.
  (setq completion-in-region-function (lambda (&rest args)
                                        (apply (if vertico-mode
                                                   #'consult-completion-in-region
                                                 #'completion--in-region)
                                               args)))

  :config
  ;; Add some simple indicator symbols here to make things clear
  ;; (setq vertico-count-format (cons "[ %-6s ] " "%s of %s"))

  (setq vertico-count 15)
  (setq vertico-resize t)
  (setq vertico-scroll-margin 4)
  (setq vertico-cycle nil)

  :custom-face
  ;; Do not render italic fonts
  (vertico-group-title ((t (:slant normal)))))

;;; Rich annotations for minibuffer
(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode)
  :init
  (setq marginalia-field-width 50)
  (setq marginalia-separator " ")
  (setq marginalia-align 'left)
  (setq marginalia-align-offset 4))

;;; Consult is useful previewing current content in buffer
(use-package consult
  :ensure t
  :bind ((:map global-map
               ("s-b" . consult-buffer)
               ("C-x b" . consult-buffer)
               ("C-s" . consult-line)
               ("s-;" . consult-goto-line)
               ("C-v" . consult-yank-pop)
               ("s-m" . consult-imenu-multi)
               ("s-n" . consult-recent-file)
               ("M-i" . consult-info)
               ("M-s" . consult-ripgrep))
         (:map consult-narrow-map
               ("?" . consult-narrow-help)))
  :init
  (setq register-preview-delay 0.125
        register-preview-function #'consult-register-format)

  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  (setq completion-in-region-function #'consult-completion-in-region)
  (setq consult-async-min-input 3
        consult-async-input-debounce 0.50
        consult-async-input-throttle 0.75)
  (setq consult-narrow-key nil)

  ;; Use `consult-ripgrep' instead of `project-find-regexp' in `project'
  (with-eval-after-load 'project
    (keymap-substitute project-prefix-map #'project-find-regexp #'consult-ripgrep)
    (cl-nsubstitute-if '(consult-ripgrep "Find regexp")
                       (pcase-lambda (`(,cmd _))
                         (eq cmd #'project-find-regexp))
                       project-switch-commands))

  ;; Customize `consult' minibuffer prompts
  (setq consult-buffer-sources '(consult--source-modified-buffer
                                 consult--source-buffer
                                 consult--source-recent-file))

  (consult-customize consult-buffer
                     :prompt "Buffer → ")

  ;; Shorten recent files in `consult-buffer'
  (defun sthenno/consult--source-recentf-items ()
    (let ((ht (consult--buffer-file-hash))
          file-name-handler-alist
          items)
      (dolist (file recentf-list (nreverse items))
        (unless (eq (aref file 0) ?/)
          (setq file (expand-file-name file)))
        (unless (gethash file ht)
          (push (propertize
                 (file-name-nondirectory file)
                 'multi-category `(file . ,file))
                items)))))
  (plist-put consult--source-recent-file
             :items #'sthenno/consult--source-recentf-items))

;;; Dabbrev settings
(use-package dabbrev
  :config

  ;; Better letter cases
  (setq dabbrev-case-distinction 'case-replace
        dabbrev-case-replace 'case-replace
        dabbrev-case-fold-search nil
        dabbrev-upcase-means-case-search t)

  (defun sthenno/dabbrev-elisp ()
    "Setup `dabbrev' for `emacs-lisp-mode'."
    (setq-local dabbrev-case-fold-search nil)
    (setq-local dabbrev-case-replace nil))
  (add-hook 'emacs-lisp-mode-hook #'sthenno/dabbrev-elisp)

  ;; Ignore these for `dabbrev'
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\` ")
  (add-to-list 'dabbrev-ignored-buffer-modes 'authinfo-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode))

;; Add extensions for the completion backend
(use-package cape
  :ensure t
  :init

  ;; Dict
  (setq cape-dict-case-fold t
        cape-dict-case-replace t)
  (setq cape-dict-limit 40)

  ;; Setup Capfs
  (defun sthenno/capf-eglot ()
    (setq-local completion-at-point-functions
                `(,(cape-capf-super
                    (cape-capf-buster #'eglot-completion-at-point)
                    #'cape-dabbrev)
                  cape-file)
                cape-dabbrev-min-length 4))
  (add-hook 'eglot-managed-mode-hook #'sthenno/capf-eglot)

  (defun sthenno/capf-elisp ()
    (setq-local completion-at-point-functions
                `(,(cape-capf-super
                    (cape-capf-predicate
                     #'elisp-completion-at-point
                     #'(lambda (cand)
                         (or (not (keywordp cand))
                             (eq (char-after (car completion-in-region--data)) ?:))))
                    #'cape-dabbrev)
                  cape-file)
                cape-dabbrev-min-length 2))
  (add-hook 'emacs-lisp-mode-hook #'sthenno/capf-elisp)

  (defun sthenno/capf-text ()
    (setq-local completion-at-point-functions
                `(,(cape-capf-super
                    (cape-capf-prefix-length #'cape-dict 4)
                    #'cape-dabbrev
                    #'cape-keyword)
                  cape-elisp-block
                  cape-file)
                cape-dabbrev-min-length 3))
  (add-hook 'text-mode-hook #'sthenno/capf-text)

  :config
  (defun sthenno/cape--symbol-annotation (sym)
    "Return kind of SYM with customized annotations."
    (setq sym (intern-soft sym))
    (cond ((special-form-p sym)    " <s>")
          ((macrop sym)            " <macro>")
          ((commandp sym)          " <cmd>")
          ((fboundp sym)           " <func>")
          ((custom-variable-p sym) " <custom>")
          ((boundp sym)            " <v>")
          ((featurep sym)          " <feat>")
          ((facep sym)             " <face>")
          (t " <sym>")))
  (define-advice cape--symbol-annotation (:override (sym)
                                                    sthenno/cape--symbol-annotation)
    "Modify the annotation for boundp symbols."
    (sthenno/cape--symbol-annotation sym))

  (setq cape--dabbrev-properties (list :annotation-function (lambda (_)
                                                              ;; FIXME: how to avoid
                                                              ;; parsing this as a
                                                              ;; docstring?
                                                              ""
                                                              " <dab>")
                                       :company-kind (lambda (_) 'text)
                                       :exclusive 'no)))

;;; The main completion frontend by Corfu
(use-package corfu
  :ensure t
  :hook (after-init . global-corfu-mode)
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.05           ; Making this to 0 is too expensive
        corfu-auto-prefix 2)
  (setq corfu-count 8
        corfu-scroll-margin 4)
  (setq corfu-min-width 20
        corfu-max-width 40)
  (setq corfu-quit-at-boundary 'separator
        corfu-separator ?\s             ; Use space
        corfu-quit-no-match 'separator  ; Don't quit if there is `corfu-separator'
                                        ; inserted
        corfu-preview-current 'insert   ; Preview first candidate. Insert on input if
                                        ; only one
        corfu-on-exact-match 'insert)
  (setq corfu-cycle t)
  (setq corfu-preselect 'directory)

  ;; Performance optimization
  ;;
  (defun sthenno/corfu-eshell-setup ()
    (setq-local corfu-auto nil)
    (corfu-mode 1)
    (keymap-set corfu-map "RET" #'corfu-send))
  (add-hook 'eshell-mode-hook #'sthenno/corfu-eshell-setup)

  (defun sthenno/completion-style-corfu ()
    (interactive)
    (setq-local completion-styles '(orderless-literal-only basic)
                completion-category-overrides nil
                completion-category-defaults nil))
  (add-hook 'corfu-mode-hook #'sthenno/completion-style-corfu)

  ;; Combined sorting
  (defun sthenno/corfu-combined-sort (candidates)
    "Sort CANDIDATES using both display-sort-function and corfu-sort-function."
    (let ((candidates
           (let ((display-sort-func (corfu--metadata-get 'display-sort-function)))
             (if display-sort-func
                 (funcall display-sort-func candidates)
               candidates))))
      (if corfu-sort-function
          (funcall corfu-sort-function candidates)
        candidates)))
  (setq corfu-sort-override-function #'sthenno/corfu-combined-sort)

  :bind (:map corfu-map
              ("<escape>" . corfu-quit)
              ("RET" . corfu-insert)))

(use-package corfu-history
  :hook (corfu-mode . corfu-history-mode)
  :config
  (with-eval-after-load 'savehist
    (add-to-list 'savehist-additional-variables 'corfu-history)))

(use-package corfu-popupinfo
  :hook (prog-mode . corfu-popupinfo-mode)
  :config
  (setq corfu-popupinfo-delay '(0.5 . 0.25))
  (setq corfu-popupinfo-hide nil)
  (setq corfu-popupinfo-max-width 80
        corfu-popupinfo-min-width 20))

(provide 'init-comp)

;;; init-comp.el ends here
