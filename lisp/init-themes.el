;;; init-themes.el --- Defaults for themes -*- lexical-binding: t -*-
;;; Commentary:

;; This file configured Emacs Themes.

;;; Code:


(require-theme 'modus-themes)

(setq modus-themes-common-palette-overrides
      modus-themes-preset-overrides-intense)

(setq modus-themes-disable-other-themes t)

(setq  modus-themes-headings
       '((1 . (1.50))
         (2 . (1.35))
         (3 . (1.30))
         (4 . (1.25))
         (5 . (1.20))
         (t . (1.15))))

(load-theme 'modus-vivendi t)


;; Customize faces
(set-face-attribute 'button nil
                    :underline "#959595"
                    :foreground nil)

(set-face-attribute 'fill-column-indicator nil
                    :height 0.15)

(set-face-attribute 'link nil
                    :foreground nil)

(set-face-background 'fringe (face-attribute 'default :background))

;; Cursor faces
(setq-default blink-cursor-mode nil)
(setq-default cursor-type '(bar . 1))
(set-cursor-color "#ff66ff")

;; Blink cursor with `beacon'
;; This also helps rendering frames
(use-package beacon
  :diminish
  :config
  (setq beacon-push-mark 35)
  (setq beacon-blink-duration 0.5)
  (setq beacon-color "#ff66ff")
  (beacon-mode 1))


;; Mode line settings
(setq-default mode-line-compact t)


(provide 'init-themes)
;;; init-themes.el ends here
