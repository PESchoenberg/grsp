#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example28.scm
;;
;; A sample of grsp functions. Batch gradient descent.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example28.scm 
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

 
;;;; Init.

;; Vars.
(define X (grsp-matrix-create "#Ladder" 10 2))
(define T (grsp-matrix-create 4 10 2))
(define Y (grsp-opt-xty X T))
(define lr 0.0001) ;; Ref 0.001
(define mi 1000000)
(define cv 0.00000001)
(define res1 0)

;;;; Main program.

;; Create "noisy" data.
(set! Y (grsp-matrix-blur "#normal" Y 0.15))

;; BGD algorithm.
(set! res1 (grsp-opt-bgd X T Y lr mi cv))

;; Show results.
(clear)
(grsp-ldl "example28.scm - A sample of grsp functions. Batch gradient descent." 1 0)
(grsp-ldvl "Learning rate:  " lr 1 0)
(grsp-ldvl "Max iterations: " mi 1 0) 
(grsp-ldvl "Convergence:    " cv 1 0)
(grsp-matrix-ldvl "Features X:" X 1 1)
(grsp-matrix-ldvl "Parameters T:" T 1 1)
(grsp-matrix-ldvl "Obsered results Y:" Y 1 1)
(grsp-matrix-ldvl "Optimized T:" res1 1 1)

