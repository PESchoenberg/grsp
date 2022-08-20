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
;; - Read sources for limitations on function parameters.


(define-module (grsp grsp16)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp2)
  #:use-module (ice-9 textual-ports)
  #:export (grsp-scm-head
	    grsp-scm-descript
	    grsp-scm-license-gpl3
	    grsp-scm-reqmod
	    grsp-scm-defmod
	    grsp-scm-create-prg
	    grsp-scm-create-lib
	    grsp-scm-pbp))


;;;; grsp-guile-prg-head - GNU Guile program head.
;;
;; Keywords:
;; lisp, guile, program, edition. 
;;
(define (grsp-scm-head)
  (display "#! /usr/local/bin/guile -s")
  (newline)
  (display "!#")
  (newlines 2))  


;;;; grsp-scm-descript - Program description.
;;
;; Keywords:
;; lisp, guile, program, edition. 
;;
;; Arguments:
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
  

;;;; grsp-scm-license-gpl3 - Text that corresponds to the GPL 3.
;;
;; Keywords:
;; lisp, guile, program, edition. 
;;
;; Arguments:
;; - p_s1: string. License holder name.
;; - p_s2: string. License holder email.
;; . p_s3; string. Copyright interval years.
;;
(define (grsp-scm-license-gpl3 p_s1 p_s2 p_s3)
  (grsp-dline)
  (grsp-dsc)
  (display (strings-append (list " Copyright (C) " p_s3 " " p_s1 " (" p_s2 ")") 0))
  (newline)
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


;;;; grsp-scm-reqmod - Required modules section.
;;
;; Keywords:
;; lisp, guile, program, edition. 
;;
;; Arguments:
;; - p_l1: list of the required modules as strings, i.e "(grsp grsp0)" "(grsp grsp1)"...
;;
(define (grsp-scm-reqmod p_l1)
  (grsp-dtext "Required modules.")
  (display "(use-modules")
  (displayl " " p_l1)    
  (display ")")
  (newlines 2))


;;;; grsp-scm-defmod - Module definition section for scm libraries.
;;
;; Keywords:
;; lisp, guile, program, edition. 
;;
;; Arguments:
;; - p_s1: string. Module definition.
;; - p_l1: list of the used modules as strings, i.e "(grsp grsp0)" "(grsp grsp1)"...
;; - p_l2: list of the exported functions as strings, i.e "grsp-reqmod" "grsp-defmod"...
;;
(define (grsp-scm-defmod p_s1 p_l1 p_l2)
  (let ((j2 1))
    
    (display "(define-module ")
    (display p_s1)
    (displayl "\n  #:use-module " p_l1)
    (display "\n  #:export ")
    (display (list-ref p_l2 0))
    
    (while (< j2 (length p_l2))

	   (display "\n  ")
	   (display (list-ref p_l2 j2))
	   
	   (set! j2 (in j2)))
    
    (display "))")
    
    (newlines 2)))
  

;;;; grsp-scm-create-prg - Creates an .scm program file according to user
;; specifications..
;;
;; Keywords:
;; lisp, guile, program, edition. 
;;
;; Arguments:
;; - p_s1: string. Program name, i.e. "program.scm".
;; - p_s2: string. Program description.
;; - p_s3: string. License holder name.
;; - p_s4: string. License holder email.
;; . p_s5: string. Copyright interval years.
;; - p_l1: list of the required modules as strings, i.e "(grsp grsp0)" "(grsp grsp1)"...
;; - p_l2: list of code lines , i.e. "(newline)" ";; Main program"...
;;
;; Notes:
;; - See grsp-scm-create-lib.
;;
(define (grsp-scm-create-prg p_s1 p_s2 p_s3 p_s4 p_s5 p_l1 p_l2)
  (let ((port1 (current-output-port))
	(port2 (open-output-file p_s1)))

    ;; Open and configure file port.
    (set-port-encoding! port2 "UTF-8")
    (set-current-output-port port2)
    
    (grsp-scm-head)
    (grsp-scm-descript p_s1 p_s2)
    (grsp-scm-license-gpl3 p_s3 p_s4 p_s5)
    (grsp-scm-reqmod p_l1)
    (displayl "\n" p_l2)

    ;; Close file port and return to previous port.
    (set-current-output-port port1)
    (close port2)))


;;;; grsp-save-to-file - Saves a string to file p_f1.   
;;
;; Keywords:
;; - console, strings.
;;
;; Arguments: 
;; - p_s1: string to save.
;; - p_f1: file.
;; - p_m1: save mode.
;;  - "w": open for input. Rewrite if exists.
;;  - "a": open for append. Create if does not exist.
;;
;; Sources;
;; - [2].
;;
;;(define (grsp-save-to-file p_s1 p_f1 p_m1)

    
    (newlines 1))


;;;; grsp-scm-create-lib - Creates an empty .scm library file.
;;
;; Keywords:
;; lisp, guile, program, edition. 
;;
;; Arguments:
;; - p_s1: string. Program name. 
;; - p_s2: string. Program description.
;; - p_s3: string. License holder name.
;; - p_s4: string. License holder email.
;; . p_s5; string. Copyright interval years.
;; - p_l1: list of the used modules as strings, i.e "(grsp grsp0)" "(grsp grsp1)"...
;; - p_l2: list of the exported functions as strings, i.e "grsp-reqmod" "grsp-defmod"...
;;
;; Notes:
;; - See grsp-scm-create-lib.
;;
(define (grsp-scm-create-lib p_s1 p_s2 p_s3 p_s4 p_s5 p_s6 p_l1 p_l2)

    (grsp-scm-descript p_s1 p_s2)
    (grsp-scm-license-gpl3 p_s3 p_s4 p_s5)
    (grsp-scm-defmod p_s6 p_l1 p_l2))


;;;; grsp-scm-pbp - Creates a string appending p_s1, opening parenthesis, p_s2,
;; closing parenthesis and p_s3.
;; Keywords:
;; lisp, guile, program, edition. 
;;
;; Arguments:
;; p_s1: string.
;; p_s2: string.
;; p_s3: string-
;;
(define (grsp-scm-pbp p_s1 p_s2 p_s3)
  (let ((res1 ""))

    (set! res1 (strings-append (list p_s1 "(" p_s2 ")" p_s3) 0))

    res1))
