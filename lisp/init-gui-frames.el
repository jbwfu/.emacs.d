;;; init-gui-frames.el --- Behaviours of GUI frames -*- lexical-binding: t; -*-

;; Copyright (C) 2021-2024 Sthenno <sthenno@sthenno.com>

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This file mainly includes an Emacs UI design optimized for GUI mode. This file mainly
;; configures `modus-themes', fonts, some global `face' and `mode-line' styles. For
;; those feature-specific `faces', their configuration code is isolated. A typical
;; example is `prettify-symbols-mode'. See also: `init-editing-utils', `init-org'.
;;

;;; Code:

;;; Modus Themes
(use-package modus-themes
  :ensure t
  :config

  ;; Less is more.
  (setopt modus-themes-bold-constructs t)

  ;; "On a page of text, nothing draws the eye more powerfully than a contrast between
  ;; light and dark colors."

  ;; "The horse may be long out of the barn on this one, but on the web, the same rule
  ;; of restraint applies: less color is more effective. When everything is emphasized,
  ;; nothing is emphasized."

  ;; See https://practicaltypography.com/color.html

  ;; Mapping colors
  (setq modus-themes-common-palette-overrides
        `((bg-main bg-dim)

          ;; Make the mode-line borderless and stand out less
          (bg-mode-line-active unspecified)
          (fg-mode-line-active fg-dim)
          (bg-mode-line-inactive unspecified)
          (fg-mode-line-inactive fg-dim)

          ;; Make the mode line borderless
          (border-mode-line-active unspecified)
          (border-mode-line-inactive unspecified)

          ;; Set color faces for `display-line-numbers-mode'
          (fg-line-number-active fg-dim)
          (bg-line-number-active unspecified)
          (fg-line-number-inactive "#c4c4c4")
          (bg-line-number-inactive unspecified)

          ;; Make the fringe invisible
          (fringe unspecified)

          ;; No underlines
          (underline-link unspecified)
          (underline-link-visited unspecified)
          (underline-link-symbolic unspecified)

          ;; Make links the same color as `fg-main'
          ;; This also affects `button' faces in Modus Themes
          (fg-link unspecified)
          (fg-link-visited unspecified)

          ;; Prose colors
          (prose-todo info)
          (prose-done fg-dim)

          ;; Matching parenthesis
          (fg-paren-match green-intense)
          (bg-paren-match unspecified)

          ;; Make code blocks more minimal
          (bg-prose-block-contents unspecified)

          ;; Completions (see also `init-comp')
          (bg-completion bg-hl-line)

          ;; Code syntax
          (docstring comment)
          (docmarkup comment)

          ;; Apply the presets
          ,@modus-themes-preset-overrides-faint))

  ;; Load the enable the theme
  (modus-themes-load-theme 'modus-operandi))

;; Do not extend `region' background past the end of the line
(custom-set-faces
 '(region ((t :extend nil))))

;;; Parentheses

(use-package paren
  :config
  (setopt show-paren-delay 0.125)
  (custom-set-faces
   '(show-paren-match ((t :inherit 'bold))))
  (show-paren-mode 1))

;; Dim parenthesis for s-expressions
(use-package paren-face
  :ensure t
  :config
  (defun sthenno/paren-face (&rest _)
    (modus-themes-with-colors
      (custom-set-faces

       ;; Why why why why don't I dim you a lot, forever?
       `(parenthesis ((t (:foreground "#c4c4c4"))))))
    (global-paren-face-mode 1))
  (add-hook 'after-init-hook #'sthenno/paren-face))

;; Hightlight parentheses dynamically surrounding point
(use-package highlight-parentheses
  :ensure t
  :diminish
  :config
  (setopt highlight-parentheses-delay 0.125)

  (defun sthenno/highlight-parentheses (&rest _)
    (modus-themes-with-colors
      (setq highlight-parentheses-colors `(,fg-completion-match-0
                                           ,fg-completion-match-1
                                           ,fg-completion-match-2
                                           ,fg-completion-match-3)))
    ;; (custom-set-faces
    ;;  '(highlight-parentheses-highlight ((t :inherit 'bold))))
    (global-highlight-parentheses-mode 1))
  (add-hook 'after-init-hook #'sthenno/highlight-parentheses))

;;; Cursor faces

(setopt cursor-type '(bar . 1))

(blink-cursor-mode -1)

;;; Increase the padding/spacing of Emacs frames
(use-package spacious-padding
  :ensure t
  :config
  (plist-put spacious-padding-widths :fringe-width 20)
  (plist-put spacious-padding-widths :mode-line-width 5)
  (plist-put spacious-padding-widths :internal-border-width 10)
  (plist-put spacious-padding-widths :right-divider-width 0)
  (plist-put spacious-padding-widths :header-line-width 0)
  (plist-put spacious-padding-widths :scroll-bar-width 0)
  (setq spacious-padding-subtle-mode-line '(:mode-line-active "#c4c4c4"))
  (spacious-padding-mode 1))

;; Clean up the title bar content
(setq-default frame-title-format nil)
(setq-default ns-use-proxy-icon nil)

;;; Encodings
;;
;; Contrary to what many Emacs users have in their configs, you don't need more
;; than this to make UTF-8 the default coding system:
(set-language-environment "UTF-8")
;; ...but `set-language-environment' also sets `default-input-method', which is
;; a step too opinionated.
(setq default-input-method nil)

;;; Font settings
(set-face-attribute 'default nil :family "Triplicate A Code" :height 150)

;; Set up font for non-ascii fontset
(set-fontset-font t 'big5                (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'big5-hkscs          (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'chinese-cns11643-1  (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'chinese-cns11643-15 (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'chinese-cns11643-2  (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'chinese-cns11643-3  (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'chinese-cns11643-4  (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'chinese-cns11643-5  (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'chinese-cns11643-6  (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'chinese-cns11643-7  (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'chinese-gb2312      (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'chinese-gbk         (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'kanbun              (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'bopomofo            (font-spec :family "Noto Serif CJK SC"))
(set-fontset-font t 'han                 (font-spec :family "Noto Serif CJK SC"))

(set-fontset-font t 'japanese-jisx0208        (font-spec :family "Noto Serif CJK JP"))
(set-fontset-font t 'japanese-jisx0208-1978   (font-spec :family "Noto Serif CJK JP"))
(set-fontset-font t 'japanese-jisx0212        (font-spec :family "Noto Serif CJK JP"))
(set-fontset-font t 'japanese-jisx0213-1      (font-spec :family "Noto Serif CJK JP"))
(set-fontset-font t 'japanese-jisx0213-2      (font-spec :family "Noto Serif CJK JP"))
(set-fontset-font t 'japanese-jisx0213.2004-1 (font-spec :family "Noto Serif CJK JP"))
(set-fontset-font t 'jisx0201                 (font-spec :family "Noto Serif CJK JP"))
(set-fontset-font t 'kana                     (font-spec :family "Noto Serif CJK JP"))

(set-fontset-font t 'emoji (font-spec :family "Apple Color Emoji"))
(set-fontset-font t 'ucs   (font-spec :family "SF Pro") nil 'prepend)

;; Make `fill-column-indicator' thinner
(set-face-attribute 'fill-column-indicator nil :height 0.1)

;; Ellipsis symbol
(setq truncate-string-ellipsis " …")

;;; Text quoting
(setq text-quoting-style 'straight)

;;; Mode Line settings
(setopt mode-line-compact t)

(provide 'init-gui-frames)
