;;; init-reader.el --- Initialize readers. -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Sthenno <sthenno@sthenno.com>

;; This file is not part of GNU Emacs.

;;; Commentary:
;;
;;

;;; Code:
;;

;; PDF reader
(use-package pdf-tools
  :ensure t
  :mode ("\\.[pP][dD][fF]\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :bind (:map pdf-view-mode-map
              ("o" . #'pdf-outline)
              ("q" . #'kill-current-buffer))
  :config
  (setq pdf-view-display-size 'fit-page)

  (let ((target-directory (locate-user-emacs-var-file "pdf-tools/"))
        (executable (concat "epdfinfo" (when (eq system-type 'windows-nt) ".exe"))))
    (unless (file-directory-p target-directory)
      (make-directory target-directory t))
    (setq pdf-info-epdfinfo-program (concat target-directory executable)))


  (use-package pdf-outline
    :bind (:map pdf-outline-buffer-mode-map
                ("<escape>" . #'pdf-outline-quit)))

  (use-package saveplace-pdf-view :ensure t))

;; Epub reader
(use-package nov
  :ensure t
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-save-place-file (locate-user-emacs-var-file "nov-save-place.eld")))

(provide 'init-reader)

;;; init-reader.el ends here
