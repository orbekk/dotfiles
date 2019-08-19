; Some workarounds for broken spacemacs.
(autoload 'org-mks "org-macs")
(autoload 'org-show-all "org")
(autoload 'org-line-number-display-width "org-compat")
(autoload 'org-babel-execute:emacs-lisp "ob-emacs-lisp")

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . nil)
     (R . t)))

  (setq
   org-todo-keywords '(
                       (sequence
                        "TODO(t)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)"))

   org-refile-use-outline-path nil
   org-refile-targets '((nil . (:maxlevel . 2)))

   org-agenda-files '("~/org/todo.org")
   org-agenda-ndays 14
   org-agenda-include-diary 1
   ;; org-agenda-todo-ignore-deadlines 1
   org-agenda-todo-ignore-with-date 1
   org-agenda-todo-ignore-scheduled 1
   org-agenda-start-with-log-mode 1

   org-agenda-custom-commands
   '(("g" "Google agenda"
      ((agenda "")
       (alltodo))
      ))

   org-capture-templates `(
                           ("t" "Todo" entry (file+headline "~/org/todo.org" "Inbox")
                            "* TODO %?\n  %i\n  %a")
                           ("d" "Daily review" entry (file+olp+datetree "~/org/review.org" "Daily")
                            (file "~/org/templates/daily-review.org") :tree-type week)
                           )

   )
)
