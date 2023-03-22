#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example25.scm
;;
;; A sample of grsp functions. Tracy-Singh product.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example25.scm 
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
;; - [grsp3.37][grsp3.69].


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
(define A (grsp-matrix-create "#Ladder" 3 3))
(define B (grsp-matrix-transpose A))
(define Am (grsp-matrix-create-fix "#part" 3))
(define Bm (grsp-matrix-create-fix "#part" 3))
(define res1 0)

;; Partition matrix for A (columnar).
(array-set! Am (grsp-lm A) 0 0)
(array-set! Am (grsp-hm A) 0 1)
(array-set! Am (grsp-ln A) 0 2)
(array-set! Am (grsp-hn A) 0 3)
(array-set! Am 0 0 4)
(array-set! Am 0 0 5)

(array-set! Am (grsp-lm A) 1 0)
(array-set! Am (grsp-hm A) 1 1)
(array-set! Am (+ (grsp-ln A) 1) 1 2)
(array-set! Am (grsp-hn A) 1 3)
(array-set! Am 0 1 4)
(array-set! Am 1 1 5)

(array-set! Am (grsp-lm A) 2 0)
(array-set! Am (grsp-hm A) 2 1)
(array-set! Am (+ (grsp-ln A) 2) 2 2)
(array-set! Am (grsp-hn A) 2 3)
(array-set! Am 0 2 4)
(array-set! Am 2 2 5)

;; Partition matrix for B.
(set! Bm (grsp-matrix-cpy Am))

;; Main program.
(clear)

;; Calculate and show.
(grsp-ldl "Matrix A" 2 1)
(grsp-matrix-display A)

(grsp-ldl "Matrix Am" 2 1)
(grsp-matrix-display Am)

(grsp-ldl "Matrix B" 2 1)
(grsp-matrix-display B)

(grsp-ldl "Matrix Bm" 2 1)
(grsp-matrix-display Bm)

(grsp-ldl "Results" 2 1)
(set! res1 (grsp-matrix-opmmp "#*ts" A Am B Bm))
(grsp-matrix-display (list-ref res1 0))

(grsp-ldl "Partition" 2 1)
(grsp-matrix-display (list-ref res1 1))

(grsp-ldl " " 2 1)
