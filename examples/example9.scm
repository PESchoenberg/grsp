#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example6.scm
;;
;; A sample of grsp functions. This program shows how function 
;; grsp-matrix-decompose works ("#QRH").
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example8.scm 
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
;; - See example8.scm.
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
(display "QR decomposition (A = Q*R):")
(define QR (grsp-matrix-decompose "#QRH" A))
(define Q (car QR))
(define R (car (cdr QR)))
(newlines 1)
(display "Martix A:")
(newlines 1)
(grsp-matrix-display A)
(newlines 2)
(display "Matrix Q")
(newlines 1)
(grsp-matrix-display Q)
(newlines 2)
(display "Matrix R")
(newlines 1)
(grsp-matrix-display R)
(newlines 2)
(display "Q * R")
(newlines 1)
(define QR2 (grsp-matrix-opmm "#*" Q R))
(grsp-matrix-display QR2)
(newlines 1)
(grsp-matrix-display A)
(newlines 1)
(display "Equality check (A = Q * R) passed? ")
(display (grsp-matrix-is-equal A QR2))
(newlines 1)




