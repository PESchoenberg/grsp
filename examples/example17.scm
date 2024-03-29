#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example17.scm
;;
;; A sample of grsp functions. SVD decomposition.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example17.scm 
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
;; - See example22.scm.
;;


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
(define A (grsp-matrix-create "#Ex2SVD" 4 2)) ;; Change this to test another matrix.
;;(define A (grsp-matrix-create "#Ex1SVD" 4 5))
(define B 0)
(define C)
(define S 0)
(define V 0)
(define Vt 0)
(define U 0)
(define L '())


;; Main program.
(clear)

;; Calculate and show.
(grsp-ldl "Matrix A" 2 1)
(grsp-matrix-display A)

(set! L (grsp-matrix-decompose "#SVD" A))

(set! U (list-ref L 0))
(grsp-ldl "Matrix U" 2 1)
(grsp-matrix-display U)

(set! S (list-ref L 1))
(grsp-ldl "Matrix S" 2 1)
(grsp-matrix-display S)

(set! Vt (list-ref L 2))
(grsp-ldl "Matrix Vt" 2 1)
(grsp-matrix-display Vt)

(grsp-ldl "Reconstructing natrix A as C" 2 1)
(set! B (grsp-matrix-opmm "#*" U S))
(set! C (grsp-matrix-opmm "#*" B Vt))
(grsp-matrix-display C)

(grsp-ldl " " 2 1)
