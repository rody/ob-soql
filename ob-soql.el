;;; ob-soql.el --- org babel functions for SOQL evaluation.
;; Copyright (C) your name here

;; Author: your name here
;; Keywords: literate programming, reproducible research
;; Homepage: http://orgmode.org
;; Version: 0.01

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This file is not intended to ever be loaded by org-babel, rather it
;; is a template for use in adding new language support to Org-babel.
;; Good first steps are to copy this file to a file named by the
;; language you are adding, and then use `query-replace' to replace
;; all strings of "template" in this file with the name of your new
;; language.
;;
;; If you have questions as to any of the portions of the file defined
;; below please look to existing language support for guidance.
;;
;; If you are planning on adding a language to org-babel we would ask
;; that if possible you fill out the FSF copyright assignment form
;; available at http://orgmode.org/request-assign-future.txt as this
;; will simplify the eventual inclusion of your addition into
;; org-babel and possibly at some point into org-mode and Emacs
;; proper.

;;; Requirements:

;; ob-soql depends on sfdx-cli.

;;; Code:
(require 'ob)
(require 'org)

(defun org-babel-execute:soql (body params)
  "Execute soql in org mode."
	 
  (let* ((username (if (assoc :username params) (cdr (assoc :username params)) nil))
	 (cmdline (format "sfdx force:data:soql:query -r csv --query \"%s\"" body))
	 (cmdline (if username (format "%s -u '%s'" cmdline username)))
	 (err-buff (get-buffer-create "*Org-Babel error*"))
	 (out-buff (get-buffer-create "*soql-result*")))
    (shell-command cmdline out-buff err-buff)
    (with-current-buffer out-buff
      (org-table-convert-region (point-min) (point-max) '(4))
      (org-ctrl-c-minus)
      (buffer-string))))


;;<<allow-scheme-execution>>
(provide 'ob-soql)
;;; ob-soql.el ends here
