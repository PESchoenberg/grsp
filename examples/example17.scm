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
(define A (grsp-matrix-create 0 4 2))
(define S 0)
(define V 0)
(define U 0)
(define L '())


;; Main program.
(clear)

;; Define specific matrix elements.
(array-set! A 2 0 0)
(array-set! A 4 0 1)
(array-set! A 1 1 0)
(array-set! A 3 1 1)

;; Calculate and show.
(grsp-ldl "Matrix A" 2 1)
(grsp-matrix-display A)
(grsp-ldl "1 ---" 2 1)

(set! L (grsp-matrix-decompose "#SVD" A))

(grsp-ldl "List L" 2 1)
(displayl " " L)

(grsp-ldl "2 ---" 2 1)

(set! U (list-ref L 0))
(grsp-ldl "Matrix U" 2 1)
(displayl " " U)

(set! S (list-ref L 2))
(grsp-ldl "Matrix S" 2 1)
(displayl " " S)

(set! V (list-ref L 1))
(grsp-ldl "Matrix Vt" 2 1)
(grsp-matrix-display V)

(grsp-ldl " " 2 1)
