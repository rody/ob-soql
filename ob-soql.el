;;; ob-soql.el --- org babel functions for SOQL evaluation.
;; Copyright (C) Rodolphe Blancho

;; Author: Rodolphe Blancho
;; Keywords: soql, salesforce
;; Homepage: https://github.com/rody/ob-soql
;; Version: 0.01

;;; License:

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Commentary:

;; This extension uses the Salesforce DX cli (https://developer.salesforce.com/tools/sfdxcli) to execute the SOQL queries.

;;; Requirements:

;; ob-soql depends on sfdx-cli.

;;; Code:
(require 'ob)
(require 'org)

(defun org-babel-execute:soql (body params)
  "Execute soql in org mode."
	 
  (let* ((username (if (assoc :username params)
		       (cdr (assoc :username params))
		     nil))
	 (cmdline (format "sfdx force:data:soql:query -r csv --query \"%s\"" body))
	 (cmdline (if username (format "%s -u '%s'" cmdline username) cmdline))
	 (err-buff (get-buffer-create "*Org-Babel error*"))
	 (out-buff (get-buffer-create "*soql-result*")))
    (shell-command cmdline out-buff err-buff)
    (with-current-buffer out-buff
      (org-table-convert-region (point-min) (point-max) '(4))
      (org-ctrl-c-minus)
      (buffer-string))))

(provide 'ob-soql)
;;; ob-soql.el ends here
