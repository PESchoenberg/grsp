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

;; Set to #r to define a new random set eaxh time the program runs.
(define b1 #f) 

;; tm is the number of rows and cols that the dataset will contain.
(define tm1 10)
(define tn1 3)
(define mut 0)
(define ila 1)
(define tn2 tn1)
(define af 2)
(define nf 1)

;; Number of epochs to process (set to -1 in order to process all data in the dataset)
(define te -1)

;; Define the network.
(define L1 (grsp-ann-net-create-ffv #f mut tn1 ila tn2 af nf))

;;;; Main program.
(clear)
(grsp-ldl "Creating dataset" 1 1)

;; Dataset will contain random numbers.
(grsp-random-state-set b1)
(define dataset (grsp-ann-ds-create "#rprnd" "#+" tm1 tn1))

;; Show dataset
(grsp-matrix-ldvl "Dataset as it will be passed to the ANN"  dataset 1 1)
(set! L1 (grsp-ds2ann dataset 1 1 L1))
(grsp-ask-etc)

;; Set bias and weight values in nodes and conns to 1.
(set! L1 (grsp-ann-idata-bvw "nodes" "#bias" L1 1))
(set! L1 (grsp-ann-idata-bvw "nodes" "#weight" L1 1))
(set! L1 (grsp-ann-idata-bvw "conns" "#weight" L1 1))

;; Check limits for te. If value of te is negative or higher than the number
;; of rows in datai, then te will be set to the number of rows in datai. One
;; row represents one epoch in thsi case.
(cond ((<= te 0)
       (set! te tm1))
      ((> te tm1)
       (set! te tm1)))

(grsp-ldl "ANN with initial values for bias and weight passed" 1 1)
(grsp-ann-display L1)
(grsp-ldvl "Epochs to run: " te 1 1)
(grsp-ask-etc)

;; Loop
(let loop ((i1 1))
  (if (<= i1 te)

      (begin (set! L1 (grsp-datai2idata L1))

	     (clear)
	     (grsp-ldvl "Epoch number " i1 1 1)
	     
	     ;; Evaluate.
	     (set! L1 (grsp-ann-net-miter-omth #f #f #f #f "#no" L1 1 0))
	     
	     (grsp-ldl "ANN after epoch processing" 1 1)
	     (grsp-ann-display L1)
	     (grsp-ask-etc)	     
	     
	     (loop (+ i1 1)))))

;; Display.
(grsp-ldl "ANN, final results" 1 1)
(grsp-ann-display L1)

