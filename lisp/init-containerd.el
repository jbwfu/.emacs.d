;;; init-containerd.el --- Container management -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Sthenno <sthenno@sthenno.com>

;; This file is not part of GNU Emacs.

;;; Commentary:
;;
;;

;;; Code:
;;

;;; Docker

(use-package docker
  :ensure t
  :defer t
  :config
  (setq docker-inspect-view-mode 'json-ts-mode))

(provide 'init-containerd)

;;; init-containerd.el ends here
