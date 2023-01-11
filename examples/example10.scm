#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example10.scm
;;
;; A sample of grsp functions. This program shows how function 
;; grsp-matrix-decompose works ("#SVD").
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example10.scm 
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
;; Sources:
;;
;; See code of functions used and their respective source files for more
;; credits and references.
;;
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
(display "SVD decomposition (A = U*W*V):")
(define UWV (grsp-matrix-decompose "#SVD" A))
(define U (car UWV))
(define W (cadr UWV))
(define V (caadr UWV))
(newlines 1)
(display "Martix U:")
(newlines 1)
(grsp-matrix-display U)
(newlines 2)
(display "Matrix W")
(newlines 1)
(grsp-matrix-display W)
(newlines 2)
(display "Matrix V")
(newlines 1)
(grsp-matrix-display V)
(newlines 2)
(display "U * W * V")
(newlines 1)
(define UWV2 (grsp-matrix-opmm "#*" U (grsp-matrix-opmm "#*" W V)))
(grsp-matrix-display UWV2)
(newlines 1)
(grsp-matrix-display A)
(newlines 1)
(display "Equality check (A = U * W * V) passed? ")
(display (grsp-matrix-is-equal A UWV2))
(newlines 1)




