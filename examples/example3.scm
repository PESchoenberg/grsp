#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example3.scm
;;
;; A sample of grsp ann functions. This program constructs a simple neural
;; nwtwork that sums its inputs.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example3.scm 
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
	     (grsp grsp13))


;; Vars.
(define basic_ann #f) ;; #t to return a network list only composed by nodes, conns and count.
(define mutations_desired 1)
(define nodes_in_first_layer 2)
(define intermediate_layers 1)
(define nodes_in_intermediate_layers 1)
(define activation_function 2)
(define nodes_in_last_layer 1)

;; Main.
(clear)

;; Create ann.
(define N (grsp-ann-net-create-ffv basic_ann
				   mutations_desired
				   nodes_in_first_layer
				   intermediate_layers
				   nodes_in_intermediate_layers
				   activation_function
				   nodes_in_last_layer))

;; Number of evaluation iterations.
(define iters 1)

;; Define nodes.
(define nodes (grsp-ann-get-matrix "nodes" N))

;; Define conns.
(define conns (grsp-ann-get-matrix "conns" N))

;; Define count.
(define count (grsp-ann-get-matrix "count" N))

;; Define idata and update values.
(define idata (grsp-ann-idata-create "#rprnd" 2))
(array-set! idata 0 0 0) ;; Provides input for conn id = 0.
(array-set! idata 1 1 0) ;; Provides input for conn id = 1.

;; Define odata.
(define odata (grsp-ann-get-matrix "odata" N))

;; Define datai.

;; Define datao.

; Define input matrix.

;; Update ann.
(cond ((equal? basic_ann #t)
       (set! N (list nodes conns count odata)))
      (else (set! N (list nodes conns count idata odata))))

;; Display ann data.
(grsp-ld "State init:")
(grsp-lal-dev #t N)

;; Evaluate.
(set! N (grsp-ann-net-miter "#no" N iters))

;; Show ann after evaluation.
(grsp-ld "State after eval:")
(grsp-lal-dev #t N)
	 
	 

