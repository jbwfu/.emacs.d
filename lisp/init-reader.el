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
  (setopt pdf-view-display-size 'fit-page)

  (use-package pdf-outline
    :bind (:map pdf-outline-buffer-mode-map
                ("<escape>" . #'pdf-outline-quit)))

  (use-package saveplace-pdf-view :ensure t))

;; Epub reader
(use-package nov
  :ensure t
  :mode ("\\.epub\\'" . nov-mode))

(provide 'init-reader)

;;; init-reader.el ends here
