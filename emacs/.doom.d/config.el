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
(setq doom-variable-pitch-font (font-spec :family "Noto Serif" :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dark+)
(when (equal "pincer" (system-name))
  (setq doom-theme 'doom-one-light))
(when (equal "orbekk" (system-name))
  (setq doom-theme 'doom-acario-light))

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
(setq org-agenda-files (list org-roam-directory))
(setq org-roam-directory (concat org-directory "/roam"))
(setq org-roam-db-location (concat org-roam-directory "/org-roam.db"))
(setq org-export-with-toc nil)
(setq deft-directory org-directory)
(setq deft-recursive t)
;; Org html export
(setq org-html-htmlize-output-type 'css)
;; Website publish settings.
(defvar kj/publish-tag "publish")
(defvar kj/publish-directory "/ssh:orbekk@dragon.orbekk.com:/storage/srv/kj.orbekk.com")

;; Allow more keys when navigating with avy.
(setq avy-keys '(?a ?o ?e ?u ?d ?h ?n ?s ?l ?, ?. ?p ?r))
(setq avy-timeout-seconds 0.3)

;; Low menu delay.
(setq which-key-idle-delay 0.15)

;; Replace values in an alist from a list of replacements.
;;
;; Example:
;;   (kj/assq-replace '((:a . 1)) '((:a . 2)))
(defun kj/assq-replace (replacements alist)
  (let ((replace1 (lambda (aelem alist)
                    (cons aelem (assq-delete-all (car aelem) alist)))))
    (if replacements
        (assq-replace (cdr replacements)
                      (funcall replace1 (car replacements) alist))
      alist)))

(server-start)
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)
(add-to-list 'auto-mode-alist '("\\.journal\\'" . ledger-mode))
(after! racket-mode
  (remove-hook! 'racket-mode #'racket-smart-open-bracket-mode))

(after! org
  (add-hook 'org-mode-hook 'mixed-pitch-mode)
  (setq org-roam-mode-section-functions
        (list #'org-roam-backlinks-section
              #'org-roam-reflinks-section
              #'org-roam-unlinked-references-section))

  (defun kj/find-agenda-files-containing-tag (tag)
    (let ((candidates (org-agenda-files nil 'ifmode))
          (matcher (cdr (org-make-tags-matcher tag)))
          (files))
      (message "Results:")
      (dolist (file candidates files)
        (org-check-agenda-file file)
        (with-current-buffer (org-get-agenda-file-buffer file)
          (message "%S" (org-scan-tags 'agenda matcher nil))

           (when (org-scan-tags 'agenda matcher nil)
             (push file files))))))

  (defun kj/org-publish (&optional project force)
    (interactive)
    (setq project (or project "all"))
    (setq force (or force current-prefix-arg))
    (let* ((static-files-re (string-join '("css" "txt" "jpg" "png" "gif" "svg") "\\|"))
           (files-to-include (kj/find-agenda-files-containing-tag kj/publish-tag))
           (org-babel-default-header-args
            (kj/assq-replace '((:exports . "both") (:eval . "never-export"))
                             org-babel-default-header-args))
           (org-publish-project-alist
            `(
              ("static"
              :base-directory ,(concat org-roam-directory "/static")
              :base-extension ,static-files-re
              :recursive t
              :publishing-directory ,(concat kj/publish-directory "/static")
              :publishing-function org-publish-attachment)
              ("source"
              :base-directory ,org-roam-directory
              :base-extension "org"
              :exclude ".*"
              :include ,files-to-include
              :recursive t
              :publishing-directory ,kj/publish-directory
              :publishing-function org-publish-attachment)
              ("html"
              :base-directory ,org-roam-directory
              :base-extension "org"
              :recursive t
              :exclude ".*"
              :include ,files-to-include
              :publishing-directory ,kj/publish-directory
              :publishing-function org-html-publish-to-html

              :with-toc nil
              :with-latex t
              :with-drawers t
              :with-title t
              :section-numbers nil

              ;; HTML options
              :html-toplevel-hlevel 2
              :html-preamble ""
              :html-postamble ""
              :html-html5-fancy t
              :html-doctype "html5"
              :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"static/org.css\"/>"
              :html-head-include-scripts nil
              :html-head-include-default-style nil
              :html-container article
              )
              ("all" :components ("static" "source" "html"))
             )))
      (org-publish project force))))

;;; Keybindings
(map! (:after evil-org
       :leader "n P" #'kj/org-publish))

(load-file "~/.doom.d/config.local.el")
