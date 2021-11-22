;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "KJ Orbekk"
      user-mail-address "kj@orbekk.com")

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
(setq doom-font (font-spec :family "iosevka" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dark+)
(when (equal "pincer" (system-name))
  (setq doom-theme 'doom-one-light))
(when (equal "orbekk" (system-name))
  (setq doom-themer 'doom-acario-light))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org")
(setq org-todo-keywords
      '((sequence
         "TODO(t)" "ACTIVE(a!)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))
(setq org-refile-use-outline-path nil)
(setq org-refile-targets '((nil . (:maxlevel . 2))))
(setq org-log-into-drawer t)
(setq org-agenda-log-mode-items '(closed clock state))
(setq org-agenda-files '("~/org/roam/todo.org"))
(setq org-roam-directory (concat org-directory "/roam"))
(setq org-roam-db-location (concat org-roam-directory "/org-roam.db"))
(setq org-export-with-toc nil)
(setq deft-directory org-directory)
(setq deft-recursive t)

;; Allow more keys when navigating with avy.
(setq avy-keys (number-sequence ?a ?z))

(server-start)
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)
(add-to-list 'auto-mode-alist '("\\.journal\\'" . ledger-mode))
(after! racket-mode
  (remove-hook! 'racket-mode #'racket-smart-open-bracket-mode))

(load-file "~/.doom.d/config.local.el")
