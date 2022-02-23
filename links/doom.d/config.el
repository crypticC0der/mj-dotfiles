;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "MJ Ponsonby"
      user-mail-address "mj@biosmp.co.uk")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; lol
(setq display-line-numbers `relative)
(setq display-line-numbers-type `visual)
(setq doom-font (font-spec :family "hack" :size 12))
(load-theme 'doom-tokyo-night t)
(setq global-whitespace-mode `t)
(setq whitespace-style `trailing)
(setq whitespace-mode `t)
(setq evil-motion-trainer-threshold 5)
(global-evil-motion-trainer-mode 1)
(load! "~/.doom.d/slack.el")
(setq slack-render-image-p `t)
(load-file "~/.emacs.d/.local/straight/repos/discord-emacs.el/discord-emacs.el")
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-buffer-state-icon t)
(setq doom-modeline-enable-word-count t)
(setq doom-modeline-indent-info t)
(setq doom-modeline-buffer-encoding t)
(setq doom-modeline-lsp t)
(setq doom-modeline-modal-icon nil)
(discord-emacs-run "384815451978334208")
(setq-default major-mode 'org-mode)

(evil-define-key 'visual evil-mc-key-map
  "A" #'evil-mc-make-cursor-in-visual-selection-end
  "I" #'evil-mc-make-cursor-in-visual-selection-beg)

(after! org
  ;; Import ox-latex to get org-latex-classes and other funcitonality
  ;; for exporting to LaTeX from org
  (use-package! ox-latex
    :init
    ;; code here will run immediately
    :config
    ;; code here will run after the package is loaded
    (setq org-latex-pdf-process
          '("pdflatex -interaction nonstopmode -output-directory %o %f"
            "bibtex %b"
            "pdflatex -interaction nonstopmode -output-directory %o %f"
            "pdflatex -interaction nonstopmode -output-directory %o %f"))
    (setq org-latex-with-hyperref nil) ;; stop org adding hypersetup{author..} to latex export
    ;; (setq org-latex-prefer-user-labels t)

    ;; deleted unwanted file extensions after latexMK
    (setq org-latex-logfiles-extensions
          (quote ("lof" "lot" "tex~" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl" "xmpi" "run.xml" "bcf" "acn" "acr" "alg" "glg" "gls" "ist")))

    (unless (boundp 'org-latex-classes)
      (setq org-latex-classes nil)))
)
;;;###autoload
(defun mk-project (type name)
    (interactive "*sEnter project type: \nsEnter project name: ")
    (cd "~/Documents/Programming")
    (cd type)
    (mkdir name)
    (cd name))

(defun conf (item)
  (interactive "*sWhat are you configuring: ")
  (cd "~/.config")
  (find-file item))

(map! :desc "function keys"
      "<f5>" #'minimap-mode
      "<f8>" #'treemacs)

(map! :desc "resize"
     "C-S-k" #'evil-window-increase-height
     "C-S-j" #'evil-window-decrease-height
     "C-S-l" #'evil-window-increase-width
     "C-S-h" #'evil-window-decrease-width)
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
;; optional keyboard short-cut
(global-set-key "\C-xm" 'browse-url-at-point)


(setq deft-directory "~/Documents/University/"
      deft-extensions '("txt" "org")
      deft-recursive t)

(use-package kak)
(map!
  :v "|" #'kak-exec-shell-command
  :v "s" (lambda (beg end) (interactive "r") (kak-select beg end nil))
  :v "S" (lambda (beg end) (interactive "r") (kak-select beg end t))
  :v "M-s" #'kak-split-lines
  :v "M-k" (lambda () (interactive) (kak-filter t))
  :v "M-K" (lambda () (interactive) (kak-filter nil))
  :v ". #" #'kak-insert-index)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! org
  (setq org-hide-emphasis-markers t))
