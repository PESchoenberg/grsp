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
  #:export (grsp-scm-head
	    grsp-scm-descript
	    grsp-scm-license-gpl3
	    grsp-scm-reqmod
	    grsp-scm-defmod))


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
  (grsp-dsc)
  (newlines 2))
  

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
  (newlines 2))


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
  (let ((j1 0)
	(j2 0))
    ;;
    (newlines 2)))
  
