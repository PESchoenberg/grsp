#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example11.scm
;;
;; A sample of grsp functions. This program shows how to calculate eigenvalues
;; using a Wilson matrix as testbed.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example11.scm 
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


; Reqired modules.
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
	     (grsp grsp15))


;; Main program
;;
;; Sources:
;; - See example8.scm, grsp3.scm.
;;
(clear)

;; Create matrix.
(define A (grsp-matrix-create-fix "#Wilson" 1))

;; Calculate and display results.
(display "\n")
(display "Wilson matrix:")
(newlines 1)
(grsp-matrix-display A)
(newlines 1)
(display "Eigenvalues:")
(newlines 1)
(define R (grsp-eigenval-qr "#QRMG" A 10000))  
(grsp-matrix-display R)
(newlines 1)




