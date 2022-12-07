;; =============================================================================
;;
;; grsp16.scm 
;;
;; Program creation related functions.
;;
;; =============================================================================
;;
;; Copyright (C) 2021 - 2022 Pablo Edronkin (pablo.edronkin at yahoo.com)
;;
;;   This program is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU Lesser General Public License as published by
;;   the Free Software Foundation, either version 3 of the License, or
;;   (at your option) any later version.
;;
;;   This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;   GNU Lesser General Public License for more details.
;;
;;   You should have received a copy of the GNU Lesser General Public License
;;   along with this program. If not, see <https://www.gnu.org/licenses/>.
;;
;; =============================================================================


;;;; General notes:
;;
;; - Read sources for limitations on function parameters.
;; - These functions were developed to save some time when creating new code,
;;   but they might also be useful for automatic code creation and self-
;;   editing files.
;; - You may want to check if copyright and license info has been updated by
;;   means of other sources before using the texts provided here. Consider
;;   the info provided here regarding this issue as advisory but not
;;   final. The user is responsible for obtaining and using updated and
;;   appropriate license and copyright info whenever using these functions
;;   and procedures.
;; - As a general note, be careful when constructing self-programmable systems.


(define-module (grsp grsp16)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp2)
  #:use-module (ice-9 textual-ports)
  #:export (grsp-scm-head
	    grsp-scm-descript
	    grsp-scm-copyright
	    grsp-scm-license-gpl3
	    grsp-scm-reqmod
	    grsp-scm-defmod
	    grsp-scm-create-prg
	    grsp-scm-create-prg-gpl3
	    grsp-scm.create-lib
	    grsp-scm-create-lib-gpl3
	    grsp-scm-pbp))


;;;; grsp-guile-prg-head - GNU Guile program head writer.
;;
;; Keywords:
;;
;; - lisp, guile, program, edition, programming
;;
(define (grsp-scm-head)
  (display "#! /usr/local/bin/guile -s")
  (newline)
  (display "!#")
  (newlines 2))  


;;;; grsp-scm-descript - GNU Guile program description writer.
;;
;; Keywords:
;;
;; - lisp, guile, program, edition, programming, scheme
;;
;; Parameters:
;;
;; - p_s1: string. Program name. 
;; - p_s2: string. Program description.
;;
(define (grsp-scm-descript p_s1 p_s2)
  (grsp-dline)
  (grsp-dscn)
  (grsp-dtext p_s1)
  (grsp-dscn)
  (grsp-dtext p_s2)
  (grsp-dscn))


;;;; grsp-scm-copyright - Displays a copyright notice.
;;
;; Keywords:
;;
;; - lisp, guile, program, edition, programming, scheme
;;
;; Parameters:
;;
;; - p_s1: string. License holder name.
;; - p_s2: string. License holder email.
;; . p_s3; string. Copyright interval years.
;;
(define (grsp-scm-copyright p_s1 p_s2 p_s3)
  (display (strings-append (list " Copyright (C) "
				 p_s3
				 " "
				 p_s1
				 " ("
				 p_s2
				 ")") 0))
  (newline))


;;;; grsp-scm-license-gpl3 - GNU Guile text that corresponds to the GPL 3.
;;
;; Keywords:
;;
;; - lisp, guile, program, edition, programming, scheme
;;
;; Parameters:
;;
;; - p_s1: string. License holder name.
;; - p_s2: string. License holder email.
;; - p_s3: string. Copyright interval years.
;;
;; Notes:
;;
;; - See the general notes section on top of this file regarding the use
;;   of licence texts and information.
;;
(define (grsp-scm-license-gpl3 p_s1 p_s2 p_s3)
  (grsp-dline)
  (grsp-dsc)
  (grsp-scm-copyright p_s1 p_s2 p_s3)
  (grsp-dscn)
  (grsp-dtext " This program is free software: you can redistribute it and/or modify")
  (grsp-dtext " it under the terms of the GNU Lesser General Public License as published by")  
  (grsp-dtext " the Free Software Foundation, either version 3 of the License, or")
  (grsp-dtext " (at your option) any later version")
  (grsp-dscn)
  (grsp-dtext " This program is distributed in the hope that it will be useful,")
  (grsp-dtext " but WITHOUT ANY WARRANTY; without even the implied warranty of")  
  (grsp-dtext " MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the")
  (grsp-dtext " GNU Lesser General Public License for more details")
  (grsp-dscn)
  (grsp-dtext " You should have received a copy of the GNU Lesser General Public License")
  (grsp-dtext " along with this program.  If not, see <https://www.gnu.org/licenses/>.")
  (grsp-dscn)
  (grsp-dline)
  (newlines 1))


;;;; grsp-scm-reqmod - GNU Guile required modules section writer.
;;
;; Keywords:
;;
;; - lisp, guile, program, edition, programming
;;
;; Parameters:
;;
;; - p_l1: list of the required modules as strings, i.e "(grsp grsp0)" "
;;   (grsp grsp1)"...
;;
(define (grsp-scm-reqmod p_l1)
  (grsp-dtext "Required modules.")
  (display "(use-modules")
  (displayl " " p_l1)    
  (display ")")
  (newlines 2))


;;;; grsp-scm-defmod - GNU Guile module definition section for scm libraries
;; writer.
;;
;; Keywords:
;;
;; - lisp, guile, program, edition, programming, scheme
;;
;; Parameters:
;;
;; - p_s1: string. Module definition.
;; - p_l1: list of the used modules as strings, i.e "(grsp grsp0)"
;;   "(grsp grsp1)"...
;; - p_l2: list of the exported functions as strings, i.e "grsp-reqmod"
;;   "grsp-defmod"...
;;
(define (grsp-scm-defmod p_s1 p_l1 p_l2)  
  (display "(define-module ")
  (display p_s1)
  (displayl "\n  #:use-module " p_l1)
  (display "\n  #:export ")
  (display (list-ref p_l2 0))
  
  (let loop ((j2 1))
    (if (< j2 (length p_l2))
	(begin (display "\n  ")
	       (display (list-ref p_l2 j2))
	       (loop (+ j2 1)))))    
  
  
  (display "))")    
  (newline))


;;;; grsp-scm-create-prg - Creates an .scm program file according to user
;; specifications with license info provided as a text file.
;;
;; Keywords:
;;
;; - lisp, guile, program, edition, programming, scheme
;;
;; Parameters:
;;
;; - p_s1: string. Program name, i.e. "program.scm".
;; - p_s2: string. Program description.
;; - p_f1: text file containing license info.
;; - p_l1: list of the required modules as strings, i.e "(grsp grsp0)"
;;   "(grsp grsp1)"...
;; - p_l2: list of code lines , i.e. "(newline)" ";; Main program"...
;;
;; Notes:
;;
;; - See grsp-scm-create-lib.
;;
(define (grsp-scm-create-prg p_s1 p_s2 p_f1 p_l1 p_l2)
  (let ((port1 (current-output-port))
	(port2 (open-output-file p_s1)))

    ;; Open and configure file port.
    (set-port-encoding! port2 "UTF-8")
    (set-current-output-port port2)

    ;; Write to file.
    (grsp-scm-head)
    (grsp-scm-descript p_s1 p_s2)
    (displayf p_f1)
    (grsp-scm-reqmod p_l1)
    (displayl "\n" p_l2)
    (newlines 2)

    ;; Close file port and return to previous port.
    (set-current-output-port port1)
    (close port2)))


;;;; grsp-scm-create-prg-gpl3 - Creates an .scm program file according to user
;; specifications under gpl3 license.
;;
;; Keywords:
;;
;; - lisp, guile, program, edition, programming, scheme
;;
;; Parameters:
;;
;; - p_s1: string. Program name, i.e. "program.scm".
;; - p_s2: string. Program description.
;; - p_s3: string. License holder name.
;; - p_s4: string. License holder email.
;; . p_s5: string. Copyright interval years.
;; - p_l1: list of the required modules as strings, i.e "(grsp grsp0)"
;;   "(grsp grsp1)"...
;; - p_l2: list of code lines, i.e. "(newline)" ";; Main program"...
;;
;; Notes:
;;
;; - See grsp-scm-create-lib.
;;
(define (grsp-scm-create-prg-gpl3 p_s1 p_s2 p_s3 p_s4 p_s5 p_l1 p_l2)
  (let ((port1 (current-output-port))
	(port2 (open-output-file p_s1)))

    ;; Open and configure file port.
    (set-port-encoding! port2 "UTF-8")
    (set-current-output-port port2)

    ;; Write to file.
    (grsp-scm-head)
    (grsp-scm-descript p_s1 p_s2)
    (grsp-scm-license-gpl3 p_s3 p_s4 p_s5)
    (grsp-scm-reqmod p_l1)
    (displayl "\n" p_l2)
    (newlines 2)

    ;; Close file port and return to previous port.
    (set-current-output-port port1)
    (close port2)))


;;;; grsp-scm-create-lib - Creates an empty .scm library file  with license
;; info provided as a text file.
;;
;; Keywords:
;;
;; - lisp, guile, program, edition, programming, scheme
;;
;; Parameters:
;;
;; - p_s1: string. Program name. 
;; - p_s2: string. Program description.
;; - p_s6: string. Module definition.
;; - p_f1: text file containing license info.
;; - p_l1: list of the used modules as strings, i.e "(grsp grsp0)"
;;   "(grsp grsp1)"...
;; - p_l2: list of the exported function names as strings, i.e "grsp-reqmod"
;;   "grsp-defmod"...
;; - p_l3: list of code of exported functions, i.e.
;;   (define grsp-fun1 p_s1 p_s2)...
;;
;; Notes:
;;
;; - See grsp-scm-create-lib.
;;
(define (grsp-scm-create-lib p_s1 p_s2 p_s6 p_f1 p_l1 p_l2 p_l3)
  (let ((port1 (current-output-port))
	(port2 (open-output-file p_s1)))

    ;; Open and configure file port.
    (set-port-encoding! port2 "UTF-8")
    (set-current-output-port port2)
    
    (grsp-scm-descript p_s1 p_s2)
    (display p_f1)
    (grsp-scm-defmod p_s6 p_l1 p_l2)
    (displayl "\n\n\n" p_l3)
    (newlines 2)
    
    ;; Close file port and return to previous port.
    (set-current-output-port port1)
    (close port2)))


;;;; grsp-scm-create-lib-gpl3 - Creates an empty .scm library file under gpl3
;; license.
;;
;; Keywords:
;;
;; - lisp, guile, program, edition, programming, scheme
;;
;; Parameters:
;;
;; - p_s1: string. Program name. 
;; - p_s2: string. Program description.
;; - p_s3: string. License holder name.
;; - p_s4: string. License holder email.
;; . p_s5: string. Copyright interval years.
;; - p_s6: string. Module definition.
;; - p_l1: list of the used modules as strings, i.e "(grsp grsp0)" "(grsp
;;   grsp1)"...
;; - p_l2: list of the exported function names as strings, i.e "grsp-reqmod"
;;   "grsp-defmod"...
;; - p_l3: list of code of exported functions, i.e.
;;   (define grsp-fun1 p_s1 p_s2)...
;;
;; Notes:
;;
;; - See grsp-scm-create-lib.
;;
(define (grsp-scm-create-lib-gpl3 p_s1 p_s2 p_s3 p_s4 p_s5 p_s6 p_l1 p_l2 p_l3)
  (let ((port1 (current-output-port))
	(port2 (open-output-file p_s1)))

    ;; Open and configure file port.
    (set-port-encoding! port2 "UTF-8")
    (set-current-output-port port2)
    
    (grsp-scm-descript p_s1 p_s2)
    (grsp-scm-license-gpl3 p_s3 p_s4 p_s5)
    (grsp-scm-defmod p_s6 p_l1 p_l2)
    (displayl "\n\n\n" p_l3)
    (newlines 2)
    
    ;; Close file port and return to previous port.
    (set-current-output-port port1)
    (close port2)))
  

;;;; grsp-scm-pbp - Creates a string appending p_s1, opening parenthesis, p_s2,
;; closing parenthesis and p_s3. For example " " "(" "clear" ")" "\n", which
;; leads to " (clear)\n".
;;
;; Keywords:
;;
;; - lisp, guile, program, edition, programming, scheme
;;
;; Parameters:
;;
;; - p_s1: string.
;; - p_s2: string.
;; - p_s3: string-
;;
(define (grsp-scm-pbp p_s1 p_s2 p_s3)
  (let ((res1 ""))

    (set! res1 (strings-append (list p_s1 "(" p_s2 ")" p_s3) 0))

    res1))
