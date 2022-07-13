#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example9.scm
;;
;; A sample of grsp functions. This program shows how function 
;; grsp-matrix-decompose works ("#LL").
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example9.scm 
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

;; Create matrix and input elements.
(define A (grsp-matrix-create 0 3 3))
(array-set! A 4 0 0)
(array-set! A 12 0 1)
(array-set! A -16 0 2)

(array-set! A 12 1 0)
(array-set! A 37 1 1)
(array-set! A -43 1 2)

(array-set! A -16 2 0)
(array-set! A -43 2 1)
(array-set! A 98 2 2)


;; Calculate and display results.
(display "\n")
(display "QR decomposition (A = L*Lct):")
(define LL (grsp-matrix-decompose "#LL" A))
(define L (car LL))
(define Lct (car (cdr LL)))
(newlines 1)
(display "Martix A:")
(newlines 1)
(grsp-matrix-display A)
(newlines 2)
(display "Matrix L")
(newlines 1)
(grsp-matrix-display L)
(newlines 2)
(display "Matrix Lct")
(newlines 1)
(grsp-matrix-display Lct)
(newlines 2)
(display "L * Lct")
(newlines 1)
(define LL2 (grsp-matrix-opmm "#*" L Lct))
(grsp-matrix-display LL2)
(newlines 1)
(grsp-matrix-display A)
(newlines 1)
(display "Equality check (A = L * Lct) passed? ")
(display (grsp-matrix-is-equal A LL2))
(newlines 1)




