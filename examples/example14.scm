#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example14.scm
;;
;; A sample of grsp functions. This program creates a new .scm program file.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example14.scm 
;;
;; ==============================================================================
;;
;; Copyright (C) 2018 - 2022 Pablo Edronkin (pablo.edronkin at yahoo.com)
;;
;;   This program is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU Lesser General Public License as published by
;;   the Free Software Foundation, either version 3 of the License, or
;;   (at your option) any later version.
;;
;;   This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;   GNU Lesser General Public License for more details.
;;
;;   You should have received a copy of the GNU Lesser General Public License
;;   along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;
;; ==============================================================================


;; Required modules.
(use-modules (grsp grsp0)
	     (grsp grsp1)
	     (grsp grsp2)
	     (grsp grsp3)
	     (grsp grsp4)
	     (grsp grsp5)
	     (grsp grsp6)
	     (grsp grsp7)
	     (grsp grsp8)
	     (grsp grsp9)
	     (grsp grsp10)
	     (grsp grsp11)
	     (grsp grsp12)
	     (grsp grsp13)
	     (grsp grsp14)
	     (grsp grsp15)
	     (grsp grsp16))


;; Vars;
(define fname "example15.scm")
(define fdesc "This program file has been created using example14.scm.")
(define pname "Pablo Edronkin")
(define pmail "pablo.edronkin at yahoo.com")
(define years "2018 - 2022")
(define lmods (list (grsp-scm-pbp "" "grsp grsp0" "")
		    (grsp-scm-pbp "\n  " "grsp grsp1" "")
		    (grsp-scm-pbp "\n  " "grsp grsp2" "")
		    (grsp-scm-pbp "\n  " "grsp grsp3" "")
		    (grsp-scm-pbp "\n  " "grsp grsp4" "")
		    (grsp-scm-pbp "\n  " "grsp grsp5" "")
		    (grsp-scm-pbp "\n  " "grsp grsp6" "")
		    (grsp-scm-pbp "\n  " "grsp grsp7" "")
		    (grsp-scm-pbp "\n  " "grsp grsp8" "")
		    (grsp-scm-pbp "\n  " "grsp grsp9" "")
		    (grsp-scm-pbp "\n  " "grsp grsp10" "")
		    (grsp-scm-pbp "\n  " "grsp grsp11" "")
		    (grsp-scm-pbp "\n  " "grsp grsp12" "")
		    (grsp-scm-pbp "\n  " "grsp grsp13" "")
		    (grsp-scm-pbp "\n  " "grsp grsp14" "")
		    (grsp-scm-pbp "\n  " "grsp grsp15" "")		    
		    (grsp-scm-pbp "\n  " "grsp grsp16" "")))
(define lcode (list ";; Main program."
		    "(newlines 1)"
		    "(display \"Hello world!\")"
		    "(newlines 1)"))


;; Main program.
(grsp-scm-create-prg fname fdesc pname pmail years lmods lcode)

