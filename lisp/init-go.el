;;; init-go.el --- Initialize Golang configurations.    -*- lexical-binding: t -*-

;; Copyright (C) 2025 Sthenno <sthenno@sthenno.com>

;; This file is not part of GNU Emacs.

;;; Commentary:
;;
;;

;;; Code:
;;

;;; Golang

(use-package go-mode
  :ensure t
  :autoload (go-ensure-tools-installed)
  :hook ((go-mode go-ts-mode) . (lambda ()
                                  (add-hook 'before-save-hook #'gofmt-before-save nil t)))
  :bind (:map go-mode-map
              ("<f1>" . godoc)
              ("C-c <tab>" . go-fill-struct))
  :config
  (setq godoc-at-point-function #'godoc-gogetdoc)

  ;; Install tools
  (defconst go--tools
    '("golang.org/x/tools/gopls"
      "github.com/cweill/gotests/gotests"
      "github.com/fatih/gomodifytags"
      "github.com/josharian/impl"
      "github.com/haya14busa/goplay/cmd/goplay"
      "github.com/go-delve/delve/cmd/dlv"
      "honnef.co/go/tools/cmd/staticcheck"

      "golang.org/x/tools/cmd/goimports"
      "github.com/zmb3/gogetdoc")
    "All necessary go tools.")

  (defun go-ensure-tools-installed (&optional force-update-p)
    "Install or update go tools."
    (interactive)
    (unless (executable-find "go")
      (user-error "Unable to find `go' in `exec-path'!"))

    (dolist (pkg go--tools)
      (when (or force-update-p
                (not (executable-find (file-name-nondirectory pkg))))
        (set-process-sentinel
         (start-process "go-tools" "*Go Tools*"
                        "go" "install" "-v" "-x" (concat pkg "@latest"))
         (lambda (proc _)
           (let ((status (process-exit-status proc)))
             (if (= 0 status)
                 (message "Installed %s" pkg)
               (message "Failed to install %s: %d" pkg status))))))))

  ;; Env vars
  ;; (with-eval-after-load 'exec-path-from-shell
  ;;   (exec-path-from-shell-copy-envs '("GOPATH" "GO111MODULE" "GOPROXY")))

  (when (executable-find "go")
    (let ((gopath (string-trim (shell-command-to-string "go env GOPATH")))
          (gobin (string-trim (shell-command-to-string "go env GOBIN"))))
      (when (string-empty-p gobin)    ; Skip checking GOPATH, as it's always valid here.
        (setq gobin (expand-file-name "bin" gopath)))
      (setenv "GOBIN" gobin)
      (add-to-list 'exec-path gobin t)
      (setenv "PATH" (mapconcat #'identity exec-path ":"))))

  ;; Ensure go tools are installed
  (when (executable-find "go")
    (go-ensure-tools-installed))

  (defun sthenno/gofmt-before-save ()
    "Support 'go-ts-mode'."
    (interactive)
    (when (member major-mode '(go-mode go-ts-mode)) (gofmt)))
  (advice-add 'gofmt-before-save
              :override #'sthenno/gofmt-before-save)

  ;; Dont't replace tab to spaces
  (with-eval-after-load 'init-editing-utils
    (let ((go--modes '(go-mode go-dot-mod-mode go-dot-work-mode
                               go-ts-mode go-mod-ts-mode go-work-ts-mode)))
      (setq sthenno/buffer-format-excluded-modes
            (cl-remove-duplicates
             (append sthenno/buffer-format-excluded-modes go--modes)))))

  (defun go-fill-struct ()
    "Fill go struct at point.
Replace package 'go-fill-struct'"
    (interactive)
    (save-excursion
      (eglot-code-actions nil nil "refactor.rewrite" t)))

  (defalias 'go-code-rewrite #'go-fill-struct "Rewrite code."))

(use-package go-dlv :ensure t :defer t)

(use-package go-impl :ensure t :defer t)

(use-package go-tag
  :ensure t
  :bind (:map go-ts-mode-map
              ("C-c t a" . go-tag-add)
              ("C-c t r" . go-tag-remove))
  :init (setq go-tag-args (list "-transform" "camelcase")))

(use-package go-gen-test
  :ensure t
  :bind (:map go-ts-mode-map
              ("C-c t g" . go-gen-test-dwim)))

(use-package gotest
  :ensure t
  :bind (:map go-mode-map
              ("C-c t f" . go-test-current-file)
              ("C-c t t" . go-test-current-test)
              ("C-c t p" . go-test-current-project)
              ("C-c t b" . go-test-current-benchmark)
              ("C-c t c" . go-test-current-coverage)
              ("C-c t x" . go-run)))

(provide 'init-go)

;;; init-go.el ends here
