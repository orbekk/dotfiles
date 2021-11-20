;;; test.el --- Description -*- lexical-binding: t; -*-
;;; Commentary:
;;  Description
;;; Code:

(defun test (&optional arg)
  (let ((msg (or arg "World")))
    (message "Hello %s\n" msg)))

(test)

(provide 'test)
;;; test.el ends here
