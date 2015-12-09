;;; flycheck-typescript-tslint.el --- Typescript tslint error checker

;; Copyright (C) 2015 Saša Jovanić

;; Author: Saša Jovanić <info@simplify.ba>
;; URL: https://github.com/Simplify/flycheck-typescript-tslint/
;; Keywords: flycheck, Typescript, TSLint
;; Version: 0.20.0
;; Package-Version: 0.20.0
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

;;; Code:

(require 'flycheck)

(flycheck-def-config-file-var flycheck-typescript-tslint-config typescript-tslint "tslint.json"
  :safe #'stringp
	:package-version '(flycheck . "0.22"))

;;; TSLint output:
;; sample.ts[4, 5]: misplaced opening brace

(flycheck-define-checker typescript-tslint
  "Typescript tslint error checker.

See URL
`https://github.com/palantir/tslint'."
  :command ("tslint"
						"--format" "prose"
            (config-file "--config" flycheck-typescript-tslint-config)
            source)
  :error-patterns
  ((warning line-start (one-or-more not-newline) "[" line ", " column "]: " (message) line-end))
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
