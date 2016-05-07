;;; flycheck-typescript-tslint.el --- Typescript tslint error checker

;; Copyright (C) 2015 Saša Jovanić

;; Author: Saša Jovanić <info@simplify.ba>
;; URL: https://github.com/Simplify/flycheck-typescript-tslint/
;; Keywords: flycheck, Typescript, TSLint
;; Version: 0.40.0
;; Package-Version: 0.40.0
;; Package-Requires: ((flycheck "0.22") (emacs "24"))

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; This is extension for Flycheck.

;; This extension displays TSLint errors while working on Typescript project

;; TSLint:
;; https://github.com/palantir/tslint

;; Flycheck:
;; http://www.flycheck.org/
;; https://github.com/flycheck/flycheck

;; For more information about this Flycheck extension:
;; https://github.com/Simplify/flycheck-typescript-tslint


;;;; Setup

;; Install TSLint:
;; npm install -g tslint
;; npm install -g typescript
;;
;; Install flycheck-typescript-tslint using package.el.
;;
;; Add this into your init.el file:
;; (eval-after-load 'flycheck
;;   '(add-hook 'flycheck-mode-hook #'flycheck-typescript-tslint-setup))
;;
;; Make sure to have tslint.conf in your project directory!

;;; Code:

(require 'flycheck)
(require 'json)

(flycheck-def-config-file-var flycheck-typescript-tslint-config typescript-tslint "tslint.json"
  :safe #'stringp
  :package-version '(flycheck . "0.22"))

(flycheck-def-option-var flycheck-typescript-tslint-rulesdir nil typescript-tslint
  "The directory of custom rules for TSLint.

The value of this variable is either a string containing the path
to a directory with custom rules, or nil, to not give any custom
rules to TSLint.

Refer to the TSLint manual at URL
`http://palantir.github.io/tslint/usage/cli/'
for more information about the custom directory."
  :type '(choice (const :tag "No custom rules directory" nil)
                 (directory :tag "Custom rules directory"))
  :safe #'stringp)

(defun flycheck-parse-tslint (output checker buffer)
  "Parse TSLint errors from JSON OUTPUT.

CHECKER and BUFFER denoted the CHECKER that returned OUTPUT and
the BUFFER that was checked respectively.

See URL `https://palantir.github.io/tslint/' for more information
about TSLint."
  (let ((json-array-type 'list))
    (let ((errors)
          (tslint-json-output (json-read-from-string output)))
      (dolist (emessage tslint-json-output)
        (let-alist emessage
          (push (flycheck-error-new-at
                 (+ 1 .startPosition.line)
                 (+ 1 .startPosition.character)
                 'warning .failure
                 :id .ruleName
                 :checker checker
                 :buffer buffer
                 :filename .name) errors)))
      (nreverse errors))))

(flycheck-define-checker typescript-tslint
  "Typescript tslint error checker.

See URL
`https://github.com/palantir/tslint'."
  :command ("tslint"
            "--format" "json"
            (config-file "--config" flycheck-typescript-tslint-config)
            (option "--rules-dir" flycheck-typescript-tslint-rulesdir)
            source)
  :error-parser flycheck-parse-tslint
  :modes (typescript-mode))

(add-to-list 'flycheck-checkers 'typescript-tslint 'append)

;;;###autoload
(defun flycheck-typescript-tslint-setup ()
  "Setup flycheck-typescript-tslint."
  (interactive)
  (add-to-list 'flycheck-checkers 'typescript-tslint 'append)
  (if (bound-and-true-p tide-mode)
      (flycheck-add-next-checker 'typescript-tide 'typescript-tslint 'append)))

(provide 'flycheck-typescript-tslint)

;;; flycheck-typescript-tslint.el ends here
