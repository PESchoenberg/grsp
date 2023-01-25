#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example20.scm
;;
;; A sample of grsp functions. Forward substitution.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example20.scm 
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
(define L (grsp-matrix-create "#LT" 4 4))
(define B (grsp-matrix-create "#Ladder" 4 1))
(define res1 0)

;; Main program.
(clear)

;; Define specific matrix elements.
(array-set! B 2 0 0)
(array-set! B 3 1 0)
(array-set! B 4 2 0)
(array-set! B 5 3 0)

;; Calculate.
(set! res1 (grsp-matrix-fsubst L B))

;; Show results.
(grsp-ldl "Matrix L" 1 2)
(grsp-matrix-display L)
(grsp-ldl "Matrix B" 1 2)
(grsp-matrix-display B)
(grsp-ldl "Results" 1 2)
(grsp-matrix-display res1)

