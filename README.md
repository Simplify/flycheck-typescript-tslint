# flycheck-typescript-tslint

[![License GPL 3](https://img.shields.io/badge/license-GPL_3-green.svg?dummy)](https://github.com/Simplify/flycheck-typescript-tslint/blob/master/COPYING)
[![MELPA](http://melpa.org/packages/flycheck-typescript-tslint-badge.svg)](http://melpa.org/#/flycheck-typescript-tslint)

This is extension for [Flycheck](http://www.flycheck.org/).
It uses [TSLint](https://github.com/palantir/tslint) - a linter for the TypeScript language and
warns you about stylistic and programming errors.

![flycheck-typescript-tslint screenshot](screenshot-flycheck-typescript-tslint.png)

## Installation

### Melpa

Package in available on [Melpa](https://melpa.org/#/flycheck-typescript-tslint).

### Manual install

Just place flycheck-typescript-tslint.el somewhere on your system and load it.
You'll need to have flycheck and typescript-mode installed.

```cl
;; Replace ~/Projects/elisp/flycheck-typescript-tslint/ with your location.
(add-to-list 'load-path "~/Projects/elisp/flycheck-typescript-tslint/")
(load-library "flycheck-typescript-tslint")
```

## Usage

Add to your `init.el`:

```cl
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-typescript-tslint-setup))
```

### TSLint installation

Make sure that you have TSLint installed:

```
npm install -g tslint
npm instell -g typescript
```

If you can't install TSLint globally or can't put executable in $PATH:

```cl
(custom-set-variables
 '(flycheck-typescript-tslint-executable "~/my_executables/tslint"))')
```

### Options

You can specify config file for tslint:

```cl
(custom-set-variables
 '(flycheck-typescript-tslint-config "~/tslint.json"))
```

## License

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see http://www.gnu.org/licenses/.
