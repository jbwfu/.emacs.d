;; init-custom.el --- Behaviours of GUI frames -*- lexical-binding: t -*-
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;;
;; Code:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; set a key to open the init.el
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "<f2>") 'open-init-file)

; set eshell
;(setq eshell-modules-list
;      (cons 'eshell-xtra eshell-modules-list))
;(setq eshell-prefer-lisp-variables t)

; translate
(defun beginner-translate-main (content_start content_end)
  "translate use the bash function \"trans2zh\" from ~/.functions"
  (interactive "r")
  (message (shell-command-to-string
                                        ; (format "trans -b :zh '%s'"
	        (format "source ~/.functions && trans2zh '%s'"
		            (buffer-substring content_start content_end))))
  )

(global-set-key (kbd "C-c t") 'beginner-translate-main)
(bind-keys :map help-mode-map
	       ("t" . beginner-translate-main))



(provide 'init-custom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; init-gui-framescustom.el ends her
