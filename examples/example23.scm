#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example23.scm
;;
;; A sample of grsp functions. Frobenius inner product (real matrices).
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example23.scm 
;;
;; =============================================================================
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
;; =============================================================================


;;;; General notes:
;;
;; - Read sources for limitations on function parameters.
;;
;; See code of functions used and their respective source files for more
;; credits and references.
;;
;; Sources:
;;
;; - [grsp3.68]


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
	     (grsp grsp16)
	     (grsp grsp17))

 
;; Vars.
(define A (grsp-matrix-create 0 2 3))
(define B (grsp-matrix-create 0 2 3))
(define res1 0)

;; Fill matrices.
(array-set! A 2 0 0)
(array-set! A 0 0 1)
(array-set! A 6 0 2)
(array-set! A 1 1 0)
(array-set! A -1 1 1)
(array-set! A 2 1 2)

(array-set! B 8 0 0)
(array-set! B -3 0 1)
(array-set! B 2 0 2)
(array-set! B 4 1 0)
(array-set! B 1 1 1)
(array-set! B -5 1 2)


;; Main program.
(clear)

;; Calculate and show.
(grsp-ldl "Matrix A" 2 1)
(grsp-matrix-display A)

(grsp-ldl "Matrix B" 2 1)
(grsp-matrix-display A)

(grsp-ldl "Result" 2 1)
(set! res1 (grsp-matrix-opmsc "#*f" A B))
(grsp-ld res1)

(grsp-ldl " " 2 1)
