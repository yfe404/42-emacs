;;; init.el --- My custom Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;; This is my Emacs configuration for 42, including Flycheck, Norminette, etc.
;; It follows the standard Emacs Lisp file header conventions to silence
;; warnings about missing "Commentary" or "Summary" lines.

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1. Basic Emacs Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Disable startup screens and scratch message
(setq inhibit-startup-message t
      initial-scratch-message "")

;; Show line numbers, highlight current line, show column numbers
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)
(column-number-mode 1)

;; Highlight trailing whitespace in programming modes
(add-hook 'prog-mode-hook
          (lambda ()
            (setq show-trailing-whitespace t)))

;; Use spaces instead of tabs, default tab size = 4
(setq-default indent-tabs-mode nil
              tab-width 4)

;; Show matching parentheses
(show-paren-mode 1)

;; Auto-revert files changed outside Emacs
(global-auto-revert-mode 1)
;; (setq auto-revert-interval 1)  ; Uncomment to poll more frequently if needed

;; Keep backup files in a dedicated directory
(setq backup-directory-alist `(("." . "~/.emacs.d/backups"))
      make-backup-files t
      auto-save-default t
      auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-saves/" t)))

;; Minimalistic UI (hide toolbars, menubar, scrollbar)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2. Flycheck + Custom Norminette Checker
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; Install flycheck if not installed
(unless (package-installed-p 'flycheck)
  (package-refresh-contents)
  (package-install 'flycheck))

(require 'flycheck)
(global-flycheck-mode 1)

;; Define a custom checker for newer Norminette output
(flycheck-define-checker norminette
  "Use the newer norminette tool to check 42 coding style.

Parses lines like:
Error: CONSECUTIVE_SPC      (line:  14, col:   2): Two or more consecutives spaces
Warning: SPC_BEFORE_NL      (line:  20, col:   3): Space before newline
"
  :command ("norminette" source)
  ;; We match lines starting with either 'Error:' or 'Warning:'
  :error-patterns
  ((error line-start
          "Error:" (one-or-more space)
          (one-or-more (not space))    ;; e.g. CONSECUTIVE_SPC
          (one-or-more space)
          "(line:" (one-or-more space) line
          ", col:" (one-or-more space) column
          "):" (one-or-more space) (message) line-end)
   (warning line-start
            "Warning:" (one-or-more space)
            (one-or-more (not space))  ;; e.g. SPC_BEFORE_NL
            (one-or-more space)
            "(line:" (one-or-more space) line
            ", col:" (one-or-more space) column
            "):" (one-or-more space) (message) line-end))
  :modes (c-mode c++-mode))

;; Disable other C checkers so they don't overwrite or conflict
(setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-gcc))

;; Use Norminette checker for C files, enable Flycheck in c-mode
(add-hook 'c-mode-hook
          (lambda ()
            (flycheck-select-checker 'norminette)
            (flycheck-mode 1)))

;; Only check on save and idle-change (so we can still see errors without losing highlights)
(setq-default flycheck-check-syntax-automatically '(save idle-change mode-enabled))

;; Highlight entire lines for errors/warnings
(setq flycheck-highlighting-mode 'lines)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. 42 Header Insertion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun insert-42-header ()
  "Insert the 42 standard header at the top of the file."
  (interactive)
  (goto-char (point-min))
  (insert "/* ************************************************************************** */\n")
  (insert "/*                                                                            */\n")
  (insert "/*                                                        :::      ::::::::   */\n")
  (insert (format "/*   %s%s:+:      :+:    :+:   */\n"
                  (file-name-nondirectory (buffer-file-name))
                  (make-string
                   (max 0 (- 23 (length (file-name-nondirectory (buffer-file-name))))) ?\s)))
  (insert "/*                                                    +:+ +:+         +:+     */\n")
  (insert "/*   By: YOUR_LOGIN <YOUR_LOGIN@student.42.fr>      +#+  +:+       +#+        */\n")
  (insert "/*                                                +#+#+#+#+#+   +#+           */\n")
  (insert (format "/*   Created: %s by YOUR_LOGIN       #+#    #+#             */\n"
                  (format-time-string "%Y/%m/%d %H:%M:%S")))
  (insert (format "/*   Updated: %s by YOUR_LOGIN      ###   ########.fr       */\n"
                  (format-time-string "%Y/%m/%d %H:%M:%S")))
  (insert "/*                                                                            */\n")
  (insert "/* ************************************************************************** */\n\n"))

(provide 'init)
;;; init.el ends here
