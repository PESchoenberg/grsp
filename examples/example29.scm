#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example29.scm
;;
;; A sample of grsp functions. Mini batch gradient descent.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example29.scm 
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

 
;;;; Init.

;; Increase or decrease i0, lr and mi for better results. Their default
;; values should produce observed theta parametes with about 1% deviation
;; from the theoretical ones.

;; Number of samples.
(define i0 1000)

;; Random state. Set to #t to renew seed and get a different state each time the
;; program runs, or #f if you want to preserve the rando-state system variable
;; as is and so, get the same pseudo.-random numbers.
(define b1 #t)

;; Number of cols (features and parameters).
(define j0 3)

;; Default parameter 0.
(define t0 4.0)

;; Default parameter 1.
(define t1 5.0)

;; Default parameter 2.
(define t2 2.0)

;; Features matrix.
(define X (grsp-matrix-create "#Ladder" i0 j0))

;; Parameters matrix.
(define T (grsp-matrix-create t0 i0 j0))

;; Results matrix.
(define Y (grsp-opt-xty X T))

;; Learning rate.
(define lr 0.001)

;; Learniong rate schedule.
(define sc "#step")

;; Learning rate decay.
(define de 0.001)

;; Max iterations.
(define mi 10000000)

;; Convergence value.
(define cv 0.00001)

;; Standard deviation.
(define sd 0.1)

;; Drop frequency.
(define df 10)

;; Drop rate.
(define dr 0.25)

;; Mini batch size
(define m1 100)

;; Results matrix.
(define res1 0)

;; Theoretical theta matrix.
(define res2 (grsp-matrix-create t0 1 j0))


;;;; Main program.

;; Prepare random state.
(grsp-random-state-set b1)

;; Set theoretical res2 values (without noise); these will be compared - as a
;; reference - to the calculated (optimized) theta values after processing.
(array-set! res2 t1 0 1)
(array-set! res2 t2 0 2)

;; Change some theta values.
(set! T (grsp-matrix-col-replacev "#=" T 1 t0 t1))
(set! T (grsp-matrix-col-replacev "#=" T 2 t0 t2))

;; Now add some noise.
(set! X (grsp-matrix-blur "#normal" X sd))
(set! T (grsp-matrix-blur "#normal" T sd))
(set! Y (grsp-matrix-blur "#normal" Y sd))

;; MBGD algorithm.
(set! res1 (grsp-opt-mbgd sc X T Y lr mi cv de df dr m1))

;; Show results.
(clear)
(grsp-ldl "example29.scm - A sample of grsp functions. Mini batch gradient descent." 1 0)
(grsp-ldvl "Learning rate:  " lr 1 0)
(grsp-ldvl "Max iterations: " mi 1 0) 
(grsp-ldvl "Convergence:    " cv 1 0)
(grsp-matrix-ldvl "MB Features X (noisy):" (list-ref res1 1) 1 1)
(grsp-matrix-ldvl "MB Parameters T (noisy):" (list-ref res1 2) 1 1)
(grsp-matrix-ldvl "MB Observed results Y (noisy):" (list-ref res1 3) 1 1)
(grsp-ldvl "Size of sample: " i0 1 0)
(grsp-ldvl "Size of mini batch: " m1 1 0)
(grsp-ldvl "Random state refresh:" b1 1 0)
(grsp-matrix-ldvl "Theoretical T: " res2 1 1)
(grsp-matrix-ldvl "T obtained from noisy data:" (list-ref res1 0) 1 1)

