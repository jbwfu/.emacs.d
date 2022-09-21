;;; init-utils.el --- Elisp helper functions & commands -*- lexical-binding: t -*-
;;; Commentary:

;; This file is inspired by https://github.com/purcell/emacs.d/.

;;; Code:

(define-obsolete-function-alias 'after-load 'with-eval-after-load "")


;; Handier way to add modes to auto-mode-alist
(defun add-auto-mode (mode &rest patterns)
  "Add entries to `auto-mode-alist' to use `MODE'
for all given file `PATTERNS'."
  (dolist (pattern patterns)
    (add-to-list 'auto-mode-alist (cons pattern mode))))

;; Like diminish, but for major modes
(defun my/set-major-mode-name (name)
  "Override the major mode NAME in this buffer."
  (setq-local mode-name name))
(defun my/major-mode-lighter (mode name)
  (add-hook (derived-mode-hook-name mode)
    (apply-partially 'my/set-major-mode-name name)))


;; String utilities missing from core emacs
(defun my/string-all-matches (regex str &optional group)
  "Find all matches for `REGEX' within `STR',
returning the full match string or group `GROUP'."
  (let ((result nil)
         (pos 0)
         (group (or group 0)))
    (while (string-match regex str pos)
      (push (match-string group str) result)
      (setq pos (match-end group)))
    result))


;; Delete the current file
(defun delete-this-file ()
  "Delete the current file, and kill the buffer."
  (interactive)
  (unless (buffer-file-name)
    (error "No file is currently being edited"))
  (when (yes-or-no-p (format "Really delete '%s'?"
                       (file-name-nondirectory buffer-file-name)))
    (delete-file (buffer-file-name))
    (kill-this-buffer)))


;; Rename the current file
(defun rename-this-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
         (filename (buffer-file-name)))
    (unless filename
      (error "Buffer '%s' is not visiting a file!" name))
    (progn
      (when (file-exists-p filename)
        (rename-file filename new-name 1))
      (set-visited-file-name new-name)
      (rename-buffer new-name))))


(provide 'init-utils)
;;; init-utils.el ends here
