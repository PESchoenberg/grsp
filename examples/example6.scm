#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example6.scm
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
;;   guile example6.scm 
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
;; Sources:
;; - [1] This example is based on Youtube.com. 2022. [online] Available at:
;;   https://www.youtube.com/watch?v=FAnNBw7d0vg&list=TLPQMjYwNjIwMjKMd-cFx4S92Q&index=3
;;   [Accessed 29 June 2022].
;; 
(clear)

;; Create matrix and input elements.
(define A (grsp-matrix-create 0 2 2))
(array-set! A 1 0 0)
(array-set! A 3 0 1)
(array-set! A 1 1 0)
(array-set! A -1 1 1)

;; Calculate and display results.
(display "\n")
(display "LU decomposition (A = L*U):")
(define LU (grsp-matrix-decompose "#LUD" A))
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
(display "Equality check (A = L * U) passed? ")
(display (grsp-matrix-is-equal A LU2))
(newlines 1)




