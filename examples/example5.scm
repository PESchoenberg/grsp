#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example5.scm
;;
;; A sample of grsp functions. This program shows how function 
;; grsp-matrix-decompose works.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example5.scm 
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
;; - [1] This example is based on #linearalgebra, 2019. LU decomposition - An
;;   Example. [video] Available at:
;;   https://www.youtube.com/watch?v=BFYFkn-eOQk&list=TLPQMDkwNjIwMjJXvv49HK93tw&index=3
;;   [Accessed 14 June 2022].
;; 
(clear)

;; Create matrix and input elements.
(define A (grsp-matrix-create 0 4 4))
(array-set! A 2 0 0)
(array-set! A 4 0 1)
(array-set! A 3 0 2)
(array-set! A 5 0 3)
(array-set! A -4 1 0)
(array-set! A -7 1 1)
(array-set! A -5 1 2)
(array-set! A -8 1 3)
(array-set! A 6 2 0)
(array-set! A 8 2 1)
(array-set! A 2 2 2)
(array-set! A 9 2 3)
(array-set! A 4 3 0)
(array-set! A 9 3 1)
(array-set! A -2 3 2)
(array-set! A 14 3 3)


;; Calculate and display results.
(display "\n")
(display "LU decomposition (A = L*U):")
(define LU (grsp-matrix-decompose "#LU" A))
(define L (car LU))
(define U (car (cdr LU)))
(newlines 1)
(display "Martix A:")
(newlines 1)
(grsp-matrix-display A)
(newlines 2)
(display "Matrix L")
(newlines 1)
(grsp-matrix-display L)
(newlines 2)
(display "Matrix U")
(newlines 1)
(grsp-matrix-display U)
(newlines 2)
(display "L * U")
(newlines 1)
(define LU2 (grsp-matrix-opmm "#*" L U))
(grsp-matrix-display LU2)
(newlines 1)
(grsp-matrix-display A)
(newlines 1)
(display "Equality check passed? ")
(display (grsp-matrix-is-equal A LU2))
(newlines 1)




