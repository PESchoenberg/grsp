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
(define mth #f)
(define nodes_in_first_layer 2)
(define intermediate_layers 1)
(define nodes_in_intermediate_layers 2)
(define activation_function 2)
(define nodes_in_last_layer 1)
(define iterations_desired 1)
(define mutations_desired 0)
(define data_samples 10)
(define verbosity #t)
(define L2 '())
(define L3 '())
(define res1 0)
(define s1 "--------------------------------------------")
(define size 0)
(define degree 0)
(define adegree 0)
(define density 0)
(define pdensity 0)

;; Main.
(clear)

;; Create data matrix. These steps produce a matrix of rows equal to data_samples
;; and 3 columns, then places a copy of the values of the first column into the
;; second one and then sums those values and puts the results in the third
;; column.
(define X (grsp-matrix-create "#n0[-m:+m]" data_samples 3))
(set! X (grsp-matrix-opewc "#=" X 0 X 0 X 1))
(set! X (grsp-matrix-opewc "#+" X 0 X 1 X 2))

;; Create ann.
(define L1 (grsp-ann-net-create-ffv basic_ann
				    mutations_desired
				    nodes_in_first_layer
				    intermediate_layers
				    nodes_in_intermediate_layers
				    activation_function
				    nodes_in_last_layer))

;; Update ann with new datai matrix created from matrix X.
(set! L1 (grsp-ann-datai-update X L1 0))

;; Display ann data (initial state).
(grsp-ldl (strings-append (list s1 "Initial state (L1)") 1) 2 1)

(grsp-lal-dev #t L1)

;; Make a copy of the original list so that it will be possible to compare
;; th initial and final states.
(set! L2 (list-copy L1)) 

;; Evaluate.
(set! L2 (grsp-ann-net-miter-omth verbosity
				  mth
				  "#no"
				  L2
				  iterations_desired
				  mutations_desired))

;; Show ann data after evaluation.
(grsp-ld "State after eval (L2):")
(grsp-lal-dev #t L2)

;; Find differences.
(set! L3 (grsp-ann-fdif L1 L2))

;; Show data differences between original and processed networks.
(grsp-ldl (strings-append (list s1 "Diff map (L1 - L2)") 1) 2 1)
(grsp-lal-dev #t L3)

;; Extract datao from both lists.
(define datao1 (grsp-ann-get-matrix "datao" L1))
(define datao2 (grsp-ann-get-matrix "datao" L2))

;; Show values of output nodes.
(grsp-ldl (strings-append (list s1 "Comparative results") 1) 2 1)
(display "\n Datao of initial state (L1)\n")
(display datao1)
(display "\n Datao of final state (L2)\n")
(display datao2)
(display "\n")

;; Show network properties.
(grsp-ldl (strings-append (list s1 "Network properties") 1) 2 1)
(display "\n Size (L2)\n")
(set! size (grsp-ann-net-size L2))
(display size)
(display "\n")
(display "\n Degree (L2)\n")
(set! degree (grsp-ann-node-degree L2))
(display degree)
(display "\n")
(display "\n Average degree (L2)\n")
(set! adegree (grsp-ann-net-adegree L2))
(display adegree)
(display "\n")
(display "\n Density (L2)\n")
(set! density (grsp-ann-net-density L2))
(display density)
(display "\n")
(display "\n Planar density (L2)\n")
(set! pdensity (grsp-ann-net-pdensity L2))
(display pdensity)
(display "\n")
