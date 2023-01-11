#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example18.scm
;;
;; A sample of grsp functions. Eigenvalues and eigenvectors.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example18.scm 
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


;; Sources:
;;
;; See code of functions used and their respective source files for more
;; credits and references.
;;
;; - [1] Eigenvalues and eigenvectors (2022) Wikipedia. Wikimedia Foundation.
;;   Available at: https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors
;;   (Accessed: January 4, 2023). 


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
(define n1 1000)
(define A (grsp-matrix-create 1 2 2)) ;; [1].
(define res1 0)
(define res2 (grsp-matrix-create 0 1 2)) ;; [1].


;; Main program.
(clear)

;; Define specific matrix elements.
(array-set! A 2 0 0)
(array-set! A 2 1 1)

;; Load predicted results.
(array-set! res2 3.0 0 0)
(array-set! res2 1.0 0 1)

;; Calculate and show.
(grsp-ldl "Matrix A" 1 1)
(grsp-matrix-display A)
(grsp-ldl "1---" 1 1)

;; Calculate the eigenvalues using QR decomposition iterated n1 times.
(set! res1 (grsp-eigenval-qr "#QRMG" A n1))

;; Show results.
(grsp-ldl "Matrix res1 (calculate eigenvalues of A): " 1 1)
(grsp-matrix-display res1)

(grsp-ldl "Matrix res2 (predicted eigenvalues A): " 1 1)
(grsp-matrix-display res2)

(grsp-ldl "EOT---" 1 1)
