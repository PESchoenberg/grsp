#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example30.scm
;;
;; A sample of grsp functions. ANN examples.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example30.scm 
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


;;;; Vars.
(define L1 (grsp-ann-net-create-ffv #f 0 2 1 2 2 1))
(define res1 0)

;; Set to #r to define a new random set eaxh time the program runs.
(define b1 #f) 

;; tm is the number of rows and cols that the dataset will contain.
(define tm 10)
(define tn 3)

;;;; Main program.
(clear)
(grsp-ldl "Creating dataset" 1 1)

;; Dataset will contain random numbers.
(grsp-random-state-set b1)
(define dataset (grsp-ann-ds-create "#rprnd" "#+" tm tn))

;; Show dataset
(grsp-matrix-ldvl "Dataset as it will be passed to the ANN"  dataset 1 1)
(grsp-ask-etc)

(set! L1 (grsp-ds2ann dataset 1 1 L1))
(grsp-ann-display L1)


