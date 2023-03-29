#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example25.scm
;;
;; A sample of grsp functions. Samples of matrix partition functions.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example25.scm 
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
;; - Read sources for limitations on function parameters.
;;
;; See code of functions used and their respective source files for more
;; credits and references.
;;
;; Sources:
;;
;; - [grsp3.37][grsp3.69].


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
(define A (grsp-matrix-create "#Ladder" 7 7))
(define res1 0)


;; Main program.
(clear)

;; Calculate and show.
(grsp-ldl "Matrix A" 2 1)
(grsp-matrix-display A)

(grsp-ldl "Results of #row (column partitions)" 2 1)
(set! res1 (grsp-matrix-part-create "#col" A 0 0))
(grsp-matrix-display res1)

(grsp-ldl "Results of #col (column partitions)" 2 1)
(set! res1 (grsp-matrix-part-create "#row" A 0 0))
(grsp-matrix-display res1)

(grsp-ldl "Results of #mat 2 2" 2 1)
(set! res1 (grsp-matrix-part-create "#mat" A 2 2))
(grsp-matrix-display res1)


(grsp-ldl " " 2 1)
