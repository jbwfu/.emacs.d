;;; init-fonts.el --- Configure the fonts -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(set-face-attribute 'default nil
	            :font "PragmataPro Mono"
	            :height 140)

(set-face-attribute 'variable-pitch nil
                    :font "Noto Serif CJK SC")

(set-fontset-font "fontset-default" 'unicode "PragmataPro")
(set-fontset-font "fontset-default" 'han "Noto Serif CJK SC")
(set-fontset-font "fontset-default" 'kana "Noto Serif CJK SC")


;; No gc for font caches
(setq inhibit-compacting-font-caches t)


(provide 'init-fonts)
;;; init-fonts.el ends here
