;;; init-gui-frames.el --- Behaviours of GUI frames -*- lexical-binding: t -*-

;; Copyright (C) 2021-2024 Sthenno

;; This file is not part of GNU Emacs.

;;; Commentary:
;;; Code:

;;;
;;
;; Modus Themes
;;
;; Load the built-in theme before customization
(require-theme 'modus-themes)

(setopt modus-themes-common-palette-overrides
        '(
          ;; Make the mode line borderless
          (border-mode-line-active bg-mode-line-active)
          (border-mode-line-inactive bg-mode-line-inactive)
          
          ;; Set color faces for `display-line-numbers-mode'
          (fg-line-number-inactive "gray50")
          (fg-line-number-active fg-main)
          (bg-line-number-inactive unspecified)
          (bg-line-number-active unspecified)

          ;; Make the fringe invisible
          (fringe unspecified)

          ;; Subtle underlines
          (underline-link border)
          (underline-link-visited border)
          (underline-link-symbolic border)

          ;; Completions
          (fg-completion-match-0 fg-main)
          (bg-completion-match-0 bg-red-intense)

          (bg-paren-match bg-red-intense)
          (underline-paren-match fg-main)

          ;; Make DONE less intense
          (prose-done fg-dim)

          ;; Custom region colors 
          (bg-region bg-red-intense)
          (fg-region unspecified)))

(setopt modus-themes-prompts '(extrabold))
(setopt modus-themes-completions '((t . (extrabold))))

;; diable other themes before loading Modus Themes
(mapc #'disable-theme custom-enabled-themes)
(load-theme 'modus-vivendi :no-confirm)

;; Make `fill-column-indicator' thinner
(set-face-attribute 'fill-column-indicator nil :height 0.15)

;; Clean up the title bar content
(setq-default frame-title-format nil)
(setq-default ns-use-proxy-icon nil)

;; Cursor faces
(setopt cursor-type '(bar . 1))
(setopt blink-cursor-mode nil)

;; highlight current line
(add-hook 'after-init-hook #'(lambda ()
                               (global-hl-line-mode 1)))

;; Turn on `prettify-symbols-mode' in all supported buffers
(add-hook 'after-init-hook #'(lambda ()
                               (global-prettify-symbols-mode 1)))

(setopt prettify-symbols-unprettify-at-point 'right-edge)

;;
;; Custom font
;;
(set-face-attribute 'default nil :family "PragmataPro" :height 140)

(defconst pragmatapro-prettify-symbols-alist
  (mapcar (lambda (s)
            `(,(car s)
              .
              ,(vconcat
                (apply 'vconcat
                       (make-list
                        (- (length (car s)) 1)
                        (vector (decode-char 'ucs #X0020) '(Br . Bl))))
                (vector (decode-char 'ucs (cadr s))))))
          '(("[INFO ]"    #XE280)
            ("[WARN ]"    #XE281)
            ("[PASS ]"    #XE282)
            ("[VERBOSE]"  #XE283)
            ("[KO]"       #XE284)
            ("[OK]"       #XE285)
            ("[PASS]"     #XE286)
            ("[ERROR]"    #XE2C0)
            ("[DEBUG]"    #XE2C1)
            ("[INFO]"     #XE2C2)
            ("[WARN]"     #XE2C3)
            ("[WARNING]"  #XE2C4)
            ("[ERR]"      #XE2C5)
            ("[FATAL]"    #XE2C6)
            ("[TRACE]"    #XE2C7)
            ("[FIXME]"    #XE2C8)
            ("[TODO]"     #XE2C9)
            ("[BUG]"      #XE2CA)
            ("[NOTE]"     #XE2CB)
            ("[HACK]"     #XE2CC)
            ("[MARK]"     #XE2CD)
            ("[FAIL]"     #XE2CE)
            ("# ERROR"    #XE2F0)
            ("# DEBUG"    #XE2F1)
            ("# INFO"     #XE2F2)
            ("# WARN"     #XE2F3)
            ("# WARNING"  #XE2F4)
            ("# ERR"      #XE2F5)
            ("# FATAL"    #XE2F6)
            ("# TRACE"    #XE2F7)
            ("# FIXME"    #XE2F8)
            ("# TODO"     #XE2F9)
            ("# BUG"      #XE2FA)
            ("# NOTE"     #XE2FB)
            ("# HACK"     #XE2FC)
            ("# MARK"     #XE2FD)
            ("# FAIL"     #XE2FE)
            ("// ERROR"   #XE2E0)
            ("// DEBUG"   #XE2E1)
            ("// INFO"    #XE2E2)
            ("// WARN"    #XE2E3)
            ("// WARNING" #XE2E4)
            ("// ERR"     #XE2E5)
            ("// FATAL"   #XE2E6)
            ("// TRACE"   #XE2E7)
            ("// FIXME"   #XE2E8)
            ("// TODO"    #XE2E9)
            ("// BUG"     #XE2EA)
            ("// NOTE"    #XE2EB)
            ("// HACK"    #XE2EC)
            ("// MARK"    #XE2ED)
            ("// FAIL"    #XE2EE)
            ("!="         #X100140)
            ("!=="        #X100141)
            ("!=="        #X100142)
            ("!≡"         #X100143)
            ("!≡≡"        #X100144)
            ("#("         #X10014C)
            ("#_"         #X10014D)
            ("#{"         #X10014E)
            ("#?"         #X10014F)
            ("##"         #X100150)
            ("#_("        #X100151)
            ("#["         #X100152)
            ("%="         #X100160)
            ("&%"         #X10016C)
            ("&&"         #X10016D)
            ("&+"         #X10016E)
            ("&-"         #X10016F)
            ("&/"         #X100170)
            ("&="         #X100171)
            ("&&&"        #X100172)
            ("$>"         #X10017A)
            ("(|"         #X100180)
            ("*>"         #X100186)
            ("++"         #X10018C)
            ("+++"        #X10018D)
            ("+="         #X10018E)
            ("+>"         #X10018F)
            ("++="        #X100190)
            ("--"         #X1001A0)
            ("-<"         #X1001A1)
            ("-<<"        #X1001A2)
            ("-="         #X1001A3)
            ("->"         #X1001A4)
            ("->>"        #X1001A5)
            ("---"        #X1001A6)
            ("-->"        #X1001A7)
            ("-+-"        #X1001A8)
            ("-\\/"       #X1001A9)
            ("-|>"        #X1001AA)
            ("-<|"        #X1001AB)
            ("->-"        #X1001AC)
            ("-<-"        #X1001AD)
            ("-|"         #X1001AE)
            ("-||"        #X1001AF)
            ("-|:"        #X1001B0)
            (".="         #X1001B9)
            ("//="        #X1001D4)
            ("/="         #X1001D5)
            ("/=="        #X1001D6)
            ("/-\\"       #X1001D7)
            ("/-:"        #X1001D8)
            ("/->"        #X1001D9)
            ("/=>"        #X1001DA)
            ("/-<"        #X1001DB)
            ("/=<"        #X1001DC)
            ("/=:"        #X1001DD)
            (":="         #X1001EC)
            (":≡"         #X1001ED)
            (":=>"        #X1001EE)
            (":-\\"       #X1001EF)
            (":=\\"       #X1001F0)
            (":-/"        #X1001F1)
            (":=/"        #X1001F2)
            (":-|"        #X1001F3)
            (":=|"        #X1001F4)
            (":|-"        #X1001F5)
            (":|="        #X1001F6)
            ("<$>"        #X100200)
            ("<*"         #X100201)
            ("<*>"        #X100202)
            ("<+>"        #X100203)
            ("<-"         #X100204)
            ("<<="        #X100205)
            ("<=>"        #X100207)
            ("<>"         #X100208)
            ("<|>"        #X100209)
            ("<<-"        #X10020A)
            ("<|"         #X10020B)
            ("<=<"        #X10020C)
            ("<~"         #X10020D)
            ("<~~"        #X10020E)
            ("<<~"        #X10020F)
            ("<$"         #X100210)
            ("<+"         #X100211)
            ("<!>"        #X100212)
            ("<@>"        #X100213)
            ("<#>"        #X100214)
            ("<%>"        #X100215)
            ("<^>"        #X100216)
            ("<&>"        #X100217)
            ("<?>"        #X100218)
            ("<.>"        #X100219)
            ("</>"        #X10021A)
            ("<\\>"       #X10021B)
            ("<\">"       #X10021C)
            ("<:>"        #X10021D)
            ("<~>"        #X10021E)
            ("<**>"       #X10021F)
            ("<<^"        #X100220)
            ("<="         #X100221)
            ("<->"        #X100222)
            ("<!--"       #X100223)
            ("<--"        #X100224)
            ("<~<"        #X100225)
            ("<==>"       #X100226)
            ("<|-"        #X100227)
            ("<||"        #X100228)
            ("<<|"        #X100229)
            ("<-<"        #X10022A)
            ("<-->"       #X10022B)
            ("<<=="       #X10022C)
            ("<=="        #X10022D)
            ("<-\\"       #X10022E)
            ("<-/"        #X10022F)
            ("<=\\"       #X100230)
            ("<=/"        #X100231)
            ("=<<"        #X100240)
            ("=="         #X100241)
            ("==="        #X100242)
            ("==>"        #X100243)
            ("=>"         #X100244)
            ("=~"         #X100245)
            ("=>>"        #X100246)
            ("=~="        #X100247)
            ("==>>"       #X100248)
            ("=>="        #X100249)
            ("=<="        #X10024A)
            ("=<"         #X10024B)
            ("==<"        #X10024C)
            ("=<|"        #X10024D)
            ("=/="        #X10024F)
            ("=/<"        #X100250)
            ("=|"         #X100251)
            ("=||"        #X100252)
            ("=|:"        #X100253)
            (">-"         #X100260)
            (">>-"        #X100262)
            (">>="        #X100263)
            (">=>"        #X100264)
            (">>^"        #X100265)
            (">>|"        #X100266)
            (">!="        #X100267)
            (">->"        #X100268)
            (">=="        #X100269)            
            (">="         #X10026A)
            (">/="        #X10026B)
            (">-|"        #X10026C)
            (">=|"        #X10026D)
            (">-\\"       #X10026E)
            (">=\\"       #X10026F)
            (">-/"        #X100270)
            (">=/"        #X100271)
            (">λ="        #X100272)
            ("?."         #X10027F)
            ("^="         #X100283)
            ("^<<"        #X100288)
            ("^>>"        #X100289)
            ("\\="        #X100294)
            ("\\=="       #X100295)
            ("\\/="       #X100296)
            ("\\-/"       #X100297)
            ("\\-:"       #X100298)
            ("\\->"       #X100299)
            ("\\=>"       #X10029A)
            ("\\-<"       #X10029B)
            ("\\=<"       #X10029C)
            ("\\=:"       #X10029D)
            ("|="         #X1002A9)
            ("|>="        #X1002AA)
            ("|>"         #X1002AB)
            ("|+|"        #X1002AC)
            ("|->"        #X1002AD)
            ("|-->"       #X1002AE)
            ("|=>"        #X1002AF)
            ("|==>"       #X1002B0)
            ("|>-"        #X1002B1)
            ("|<<"        #X1002B2)
            ("||>"        #X1002B3)
            ("|>>"        #X1002B4)
            ("|-"         #X1002B5)
            ("||-"        #X1002B6)
            ("||="        #X1002B7)
            ("|)"         #X1002B8)
            ("|]"         #X1002B9)
            ("|-:"        #X1002BA)
            ("|=:"        #X1002BB)
            ("|-<"        #X1002BC)
            ("|=<"        #X1002BD)
            ("|--<"       #X1002BE)
            ("|==<"       #X1002BF)
            ("~="         #X1002CA)
            ("~>"         #X1002CB)
            ("~~>"        #X1002CC)
            ("~>>"        #X1002CD)
            ("[["         #X1002CF)
            ("[|"         #X1002D0)
            ("_|_"        #X1002D7)
            ("]]"         #X1002E0)
            ("≡≡"         #X1002F3)
            ("≡≡≡"        #X1002F4)
            ("≡:≡"        #X1002F5)
            ("≡/"         #X1002F6)
            ("≡/≡"        #X1002F7))))

;; enable prettified symbols on comments
(defun pragmatapro-setup-compose-predicate ()
  (setq prettify-symbols-compose-predicate
        (defun my-prettify-symbols-default-compose-p (start end _match)
          "Same as `prettify-symbols-default-compose-p', except compose symbols in comments as well."
          (let* ((syntaxes-beg (if (memq (char-syntax (char-after start)) '(?w ?_))
                                   '(?w ?_) '(?. ?\\)))
                 (syntaxes-end (if (memq (char-syntax (char-before end)) '(?w ?_))
                                   '(?w ?_) '(?. ?\\))))
            (not (or (memq (char-syntax (or (char-before start) ?\s)) syntaxes-beg)
                     (memq (char-syntax (or (char-after end) ?\s)) syntaxes-end)
                     (nth 3 (syntax-ppss))))))))

;; main hook fn, just add to text-mode/prog-mode
(defun pragmatapro-prettify-setup ()
  (setq prettify-symbols-alist pragmatapro-prettify-symbols-alist)
  (pragmatapro-setup-compose-predicate))

(add-hook 'text-mode-hook #'pragmatapro-prettify-setup)
(add-hook 'prog-mode-hook #'pragmatapro-prettify-setup)

;; Set up font for unicode fontset
(set-fontset-font "fontset-default" 'han "Noto Sans CJK SC")

;; Note this make all italic font style disabled
(set-face-attribute 'italic nil :slant 'normal)

;; Stop showing fringe bitmaps
(setf (cdr (assq 'continuation fringe-indicator-alist)) '(nil nil))

;;
;; Mode Line settings
;;
(setopt mode-line-compact t)
(setopt line-number-mode nil)

(provide 'init-gui-frames)
;;;
;; coding: utf-8
;; no-byte-compile: t
;; End:
;;
