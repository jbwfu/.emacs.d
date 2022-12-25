;;; init-minibuff.el --- Config for minibuffer completion -*- lexical-binding: t -*-
;;; Commentary:

;; This file is inspired by https://github.com/purcell/emacs.d/.

;;; Code:

(use-package vertico
  :straight (:files (:defaults "extensions/*.el"))
  :custom
  (vertico-count 12) ; Number of candidates to display
  (vertico-cycle t)
  (vertico-resize t)
  :config
  (vertico-mode 1)
  (use-package vertico-directory
    :straight nil
    :after vertico
    :bind
    ((:map vertico-map
           ("<tab>" . vertico-insert)
	   ("RET" . vertico-directory-enter)
           ("DEL" . vertico-directory-delete-char)
           ("S-DEL" . vertico-directory-delete-word)))
    :hook ;; Correct file path when changed
    (rfn-eshadow-update-overlay . vertico-directory-tidy))

  ;; Persist history over Emacs restarts.
  (use-package savehist
    :init
    (savehist-mode 1)))

(use-package consult
  :defer t
  :config
  (global-set-key [remap switch-to-buffer] 'consult-buffer)
  (global-set-key [remap switch-to-buffer-other-window] 'consult-buffer-other-window)
  (global-set-key [remap switch-to-buffer-other-frame] 'consult-buffer-other-frame)
  (global-set-key [remap goto-line] 'consult-goto-line)
  :bind
  (("C-s" . consult-line)
   ("M-s" . consult-ripgrep)))


(use-package embark
  :defer t
  :bind
  (("C-." . embark-act)
   ("M-." . embark-dwim)
   ("C-h B" . embark-bindings))
  :init ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :after (embark consult)
  :demand t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))


;; Enable rich annotations
(use-package marginalia
  :init
  (marginalia-mode 1))


(provide 'init-minibuff)
;;; init-minibuff.el ends here
