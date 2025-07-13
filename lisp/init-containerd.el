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
  :vc (docker
       :url "https://github.com/jbwfu/docker.el"
       :branch "support-custom-inspect-view-function")
  :ensure t
  :config
  (setq docker-inspect-view-function #'(lambda ()
                                         (cond
                                          ((fboundp 'json-ts-mode) (json-ts-mode))
                                          ((fboundp 'json-mode) (json-mode))
                                          ((fboundp 'js-mode) (js-mode))))))


(provide 'init-containerd)

;;; init-containerd.el ends here
