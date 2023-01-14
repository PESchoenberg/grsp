#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example19.scm
;;
;; A sample of grsp functions. Eigenvalues and eigenvectors.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example19.scm 
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
(define A (grsp-matrix-create 1 3 3)) ;; [1].
(define lambda 0) ;; eigenvalues.
(define lambdap (grsp-matrix-create 0 1 3)) ;; [1], predicted eigenvalues.
(define lambdat 0) ;; transposed lambda.
(define res3 0)


;; Main program.
(clear)

;; Define specific matrix elements.
(array-set! A 2 0 0)
(array-set! A 3 1 1)
(array-set! A 4 1 2)
(array-set! A 4 2 1)
(array-set! A 9 2 2)

;; Load predicted results.
(array-set! lambdap 2.0 0 0)
(array-set! lambdap 1.0 0 1)
(array-set! lambdap 11.0 0 2)

;; Calculate and show.
(grsp-ldl "Matrix A" 1 1)
(grsp-matrix-display A)
(grsp-ldl "1---" 1 1)

;; Calculate the eigenvalues using QR decomposition iterated n1 times.
(set! lambda (grsp-eigenval-qr "#QRMG" A n1))
(set! lambdat (grsp-matrix-transpose lambda))

;; Show results.
(grsp-ldl "Matrix lambdap (predicted eigenvalues): " 1 1)
(grsp-matrix-display lambdap)

(grsp-ldl "Matrix lambda (calculated eigenvalues): " 1 1)
(grsp-matrix-display lambda)

;; Calculate eigenvectors.
(set! res3 (grsp-eigenvec A lambdat))

;; Show results
(grsp-ldl "Matrix res3 (calculated eigenvectors): " 1 1)
;;(grsp-matrix-display res3)
;;(display res3)
(displayl "\n" res3)

