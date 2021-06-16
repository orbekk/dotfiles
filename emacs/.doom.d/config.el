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

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(use-package! org
  :config
  (setq org-todo-keywords
        '((sequence
          "TODO(t)" "ACTIVE(a!)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))
  (setq org-refile-use-outline-path nil)
  (setq org-refile-targets '((nil . (:maxlevel . 2)))))

(setq org-log-into-drawer t)
(setq org-agenda-log-mode-items '(closed clock state))
(setq org-agenda-files '("~/org/roam/todo.org"))

(use-package! org-agenda
  :config
  (setq org-agenda-ndays 14)
  (setq org-agenda-include-diary 1)
  (setq org-agenda-todo-ignore-with-date 1)
  (setq org-agenda-todo-ignore-scheduled 1)
  (setq org-agenda-start-with-log-mode 1)
  (setq org-agenda-window-setup 'current-window)
  (setq org-agenda-custom-commands
        '(("g" "Google agenda"
           ((agenda "")
            (todo "ACTIVE")
            (alltodo))
           )))
  (setq org-capture-templates
        `(
          ("t" "Todo" entry (file+headline "~/org/roam/todo.org" "Inbox")
           "* TODO %?\n  %i\n  %a")
          ("d" "Daily review" entry (file+olp+datetree "~/org/review.org" "Daily")
           (file "~/org/templates/daily-review.org") :tree-type week :jump-to-captured t)
          ("w" "Weekly review" entry (file+olp+datetree "~/org/review.org" "Weekly")
           (file "~/org/templates/weekly-review.org") :tree-type week :jump-to-captured t)
          ("j" "Journal entry" entry (file+olp+datetree "~/org/journal.org" "Journal")
           "* Journal entry\n%t\n\n%?" :tree-type week :jump-to-captured t)
          )))

(use-package! org)
(use-package! org-roam
  :after org
  :init
  (setq org-roam-directory "~/org/roam")
  (setq org-roam-capture-templates
        '(
          ("d" "default" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "%<%Y%m%d%H%M%S>-${slug}"
           :head "#+TITLE: ${title}\n- tags :: [[file:%<%Y-W%W>.org][%<%Y-W%W>]]"
           :unnarrowed t)
          )))

(setq deft-directory "~/org/")
(setq deft-recursive t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(after! smartparens
  (smartparens-global-mode -1))

(after! mu4e-maildirs-extension
  (mu4e-maildirs-extension))
(after! mu4e
  (remove-hook 'mu4e-compose-mode-hook #'org-mu4e-compose-org-mode))

;; (setq hledger-jfile "~/.hledger.journal")

;; (use-package! hledger-mode
;;   :defer t
;;   :mode ("\\.journal\\'" "\\.hledger\\'")
;;   :commands hledger-enable-reporting
;;   :preface
;;   (defun hledger/next-entry ()
;;     "Move to next entry and pulse."
;;     (interactive)
;;     (hledger-next-or-new-entry)
;;     (hledger-pulse-momentary-current-entry))

;;   (defface hledger-warning-face
;;     '((((background dark))
;;        :background "Red" :foreground "White")
;;       (((background light))
;;        :background "Red" :foreground "White")
;;       (t :inverse-video t))
;;     "Face for warning"
;;     :group 'hledger)

;;   (defun hledger/prev-entry ()
;;     "Move to last entry and pulse."
;;     (interactive)
;;     (hledger-backward-entry)
;;     (hledger-pulse-momentary-current-entry))

;;   :config
;;   (set-company-backend! 'hledger-mode '(hledger-company))

;;   (map! :map hledger-mode-map
;;         "M-p" #'hledger/prev-entry
;;         "M-n" #'hledger/next-entry
;;         :localleader
;;         "e" #'hledger-jentry
;;         "j" #'hledger-run-command)
;;   )

(server-start)
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

(add-to-list 'auto-mode-alist '("\\.journal\\'" . ledger-mode))
(after! racket-mode
  (remove-hook! 'racket-mode #'racket-smart-open-bracket-mode))

(load "~/.doom.d/config.local.el" t)
