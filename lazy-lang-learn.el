;;; lazy-lang-learn.el --- A global minor-mode to periodically display an item to learn
;;
;; maintained in lazy-lang-learn.org
;;
;; Copyright (C) 2010-2021 rileyrg
;;
;; Author: rileyrg <rileyrg@gmx.de>
;; Created: 13th May 2021
;; Keywords: games
;; Version : 1.0
;; Package-Requires: ((emacs "24.3")(google-translate "0.12.0") (alert "1.2"))
;; URL: https://github.com/rileyrg/lazy-lang-learn
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;;

;;; commentary:
;;
;; Enable `lazy-lang-learn-mode' to be prompted occasionally with things to revise/learn.
;;
;; Usage example:
;;  (use-package lazy-lang-learn
;;    :straight (lazy-lang-learn :local-repo "~/development/projects/emacs/lazy-lang-learn" :type git :host github :repo "rileyrg/lazy-lang-learn" )
;;    :bind ("C-c L" . lazy-lang-learn-translate))
;;; code:

(defgroup lazy-lang-learn nil "`lazy-lang-learn-mode' configuration options." :group 'rgr)

(defcustom lazy-lang-learn--lighter " LLL" "Modeline indicator for `lazy-lang-learn-mode'." :type 'string)
(defcustom lazy-lang-learn--function 'lazy-lang-learn--german-fortune "Function to fetch a learn." :type 'boolean )

(require 'alert)
(defcustom lazy-lang-learn--display-function 'alert "Function to display a new learn called from `lazy-lang-learn-new'." :type 'function )

(defcustom lazy-lang-learn--period 120 "How many seconds before another learn is displayed when idle." :type 'integer )
(defcustom lazy-lang-learn--set-focus nil "Whether to set focus to a translated learn." :type 'boolean )

(defvar lazy-lang-learn--history  nil "The list of learns in `lazy-lang-learn-mode'.")

(defcustom lazy-lang-learn--history-file  (if (featurep 'no-littering) (no-littering-expand-var-file-name "lazy-lang-learn/learns.txt" ) (expand-file-name "lazy-lang-learn.alist" user-emacs-directory)) "The filename in which to save learns." :type 'file)

(defcustom lazy-lang-learn--history-length 200 "How many learns to store in history." :type 'integer)

(defvar lazy-lang-learn--timer nil "The timer object for `lazy-lang-learn-mode'.")
(defcustom lazy-lang-learn--fade-time 120 "Period of laziness before next learn via `lazy-lang-learn'." :type 'integer)

(defun lazy-lang-learn--history-save()
  "Store `lazy-lang-learn--history' in `lazy-lang-learn--history-file'."
  (condition-case nil
      (let ((dir (file-name-directory lazy-lang-learn--history-file)))
        (unless (file-exists-p dir)
          (make-directory dir))
        (with-temp-file lazy-lang-learn--history-file
          (prin1
           (butlast lazy-lang-learn--history (- (length lazy-lang-learn--history) lazy-lang-learn--history-length))
           (current-buffer))))
    ('error (message "Couldn't save %s " lazy-lang-learn--history-file))))

(defun lazy-lang-learn--history-load()
  "Load `lazy-lang-learn--history-file' into `lazy-lang-learn--history'."
  (setq lazy-lang-learn--history
        (if (file-exists-p lazy-lang-learn--history-file)
            (with-temp-buffer
              (insert-file-contents lazy-lang-learn--history-file)
              (cl-assert (eq (point) (point-min)))
              (read (current-buffer)))
          nil)))

(require 'alert)

;;;###autoload
(defun lazy-lang-learn-new()
  "Create a new snippet with `lazy-lang-learn--function'.
Display with `lazy-lang-learn--display-function' and
save it in `lazy-lang-learn--history-file'."
  (interactive)
  (let ((alert-fade-time lazy-lang-learn--fade-time)
        (learn (funcall lazy-lang-learn--function)))
    (when learn
      (funcall lazy-lang-learn--display-function learn)
      (add-to-list 'lazy-lang-learn--history learn)
      (lazy-lang-learn--history-save))
    nil))

;;;###autoload
(defun lazy-lang-learn-swap-languages()
  (interactive)
  (setq google-translate-default-source-language  (prog1 google-translate-default-target-language (setq google-translate-default-target-language  google-translate-default-source-language))))

(require 'google-translate)
(require 'google-translate-core-ui)

;;;###autoload
(defun lazy-lang-learn-translate(&optional learn)
  "Translate LEARN or if PREFIX then random element in `lazy-lang-learn--history'."
  (interactive)
  (let ((learn (if learn learn
                 (if current-prefix-arg (seq-random-elt lazy-lang-learn--history)
                   (car lazy-lang-learn--history)))))
    (if learn
        (progn
          (setq lazy-lang-learn--history (cons learn (remove learn lazy-lang-learn--history)))
          (lazy-lang-learn--history-save)
          (google-translate-translate google-translate-default-source-language google-translate-default-target-language learn)
          (if lazy-lang-learn--set-focus
              (select-window (display-buffer "*Google Translate*"))))
      (message "No learn to translate"))))

;;;###autoload
(defun lazy-lang-learn-translate-random()
  "Translate  random element in `lazy-lang-learn--history'."
  (interactive)
  (let ((current-prefix-arg 1))
    (call-interactively 'lazy-lang-learn-translate)))

;;;###autoload
(defun lazy-lang-learn-translate-from-history()
  "Prompt for a learn item from history.  Stick it as the first entry."
  (interactive)
  (if lazy-lang-learn--history ;; select from old ones by bubbling one to top
      (let ((learn (completing-read "Select learn:" lazy-lang-learn--history)))
        (when learn
          (lazy-lang-learn-translate learn))
    (message "No previous learns."))))

(defun lazy-lang-learn--german-fortune()
  "Return a german fortune string."
  (shell-command-to-string "fortune de"))

;;;###autoload
(define-minor-mode lazy-lang-learn-mode
  "A global minor-mode to periodically fetch something to learn using `lazy-lang-learn-new'."
  :global t
  :init-value nil
  :lighter lazy-lang-learn--lighter
  (if lazy-lang-learn-mode
      (progn
        (unless lazy-lang-learn--history
          (lazy-lang-learn--history-load))
        (lazy-lang-learn-new)
        (setq  lazy-lang-learn--timer
               (run-with-idle-timer
                lazy-lang-learn--period t
                'lazy-lang-learn-new)))
    (when lazy-lang-learn--timer
      (cancel-timer lazy-lang-learn--timer)
      (setq lazy-lang-learn--timer nil))))

(provide 'lazy-lang-learn)
;;; lazy-lang-learn.el ends here
