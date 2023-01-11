#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example12.scm
;;
;; A sample of grsp functions. This program shows how to apply the Jacobi
;; method.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example12.scm 
;;
;; ==============================================================================
;;
;; Copyright (C) 2018 - 2023 Pablo Edronkin (pablo.edronkin at yahoo.com)
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


; Required modules.
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
(clear)

;; Create strictly row diagonally dominant matrix with random values.
(newlines 1)
(display "Creating srdd matrix set...")
(define L (grsp-matrix-create-set "#srdd" 0 0 3 3))
(define A (car L))
(define X (cadr L))
(define B (caddr L))

;; Calculate and display results.
(newlines 1)
(display "Matrix A:")
(newlines 1)
(grsp-matrix-display A)
(newlines 1)
(display "Matrix X:")
(newlines 1)
(grsp-matrix-display X)
(newlines 1)
(display "Matrix B:")
(newlines 1)
(grsp-matrix-display B)
(newlines 1)
(display "Sol:")
(newlines 1)
(display "Matrix A:")
(newlines 1)
(grsp-matrix-display A)
(newlines 1)
(display "Matrix X2:")
(newlines 1)
(define X2 (grsp-matrix-jacobim "#QRMG" A X B 1000))  
(grsp-matrix-display X2)
(newlines 1)




