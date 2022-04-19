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
(define cnode 0)
(define nconn 0)

;; Main.
(clear)

;; Create data matrix. These steps produce a matrix of rows equal to data_samples
;; and 3 columns, then places a copy of the values of the first column into the
;; second one and then sums those values and puts the results in the third
;; column.
(define data (grsp-matrix-create "#n0[-m:+m]" data_samples 3))
(set! data (grsp-matrix-opewc "#=" data 0 data 0 data 1))
(set! data (grsp-matrix-opewc "#+" data 0 data 1 data 2))

;; Create ann.
(define L1 (grsp-ann-net-create-ffv basic_ann
				    mutations_desired
				    nodes_in_first_layer
				    intermediate_layers
				    nodes_in_intermediate_layers
				    activation_function
				    nodes_in_last_layer))

;; Display ann data before processing (L1).
(grsp-ldl (strings-append (list s1 "A)- Configuring ANN.") 1) 2 1)
(display "\n Initial state of ann (L1):\n")
(grsp-lal-dev #t L1)

;; Update ann with new datai matrix created from matrix data.
(set! L1 (grsp-ann-datai-update data L1 0))

;; Show X.
(display "\n")
(display "\n Data matrix data (Will be used to update matrix datai).\n")
(display "Matrix data contains raw input data (i.e from an external \n")
(display "source or linke in this case, procedurally generated.\n\n")
(display data)
(display "\n")

;; Display ann after datai has been updated with matrix data.
(display "\n")
(display "\n ANN after matrix datai has been updated with matrix data.\n")
(display "datai matrix contains input data in the format used by the ann\n")
(display "to receive all sorts of data.\n")
(grsp-ann-devt #t L1)
(display "\n")

;; Make a copy of the original list so that it will be possible to compare
;; th initial and final states.
(set! L2 (list-copy L1)) 

;; Evaluate.
(grsp-ldl (strings-append (list s1 "B)- Processing ANN.") 1) 2 1)
(set! L2 (grsp-ann-net-miter-omth verbosity
				  mth
				  "#no"
				  L2
				  iterations_desired
				  mutations_desired))

;; Show ann data after evaluation.
(grsp-ldl (strings-append (list s1 "C)- ANN results.") 1) 2 1)
(grsp-ann-devt #t L2)

;; Find differences.
(set! L3 (grsp-ann-fdif L1 L2))

;; Show data differences between original and processed networks.
(grsp-ldl "Datao diff map (L1 -L2)." 2 0)
(grsp-ann-devt #t L3)

;; Extract datao from both lists.
(define datao1 (grsp-ann-get-matrix "datao" L1))
(define datao2 (grsp-ann-get-matrix "datao" L2))

;; Show values of output nodes.
(grsp-ldl "Datao of initial state (L1)" 2 0)
(grsp-ldl datao1 0 1)
(grsp-ldl "Datao of final state (L1)" 1 0)
(grsp-ldl datao2 0 1)

;; Show network properties.
(grsp-ldl (strings-append (list s1 "D)- ANN properties") 1) 2 1)
(set! size (grsp-ann-net-size L2))
(grsp-ldl "Size (L2)" 2 0)
(grsp-ldl size 0 1)

(set! degree (grsp-ann-node-degree L2))
(grsp-ldl "Degree (L2)" 2 0)
(grsp-ldl degree 0 1)

(set! adegree (grsp-ann-net-adegree L2))
(grsp-ldl "Average degree (L2)" 2 0)
(grsp-ldl adegree 0 1)

(set! density (grsp-ann-net-density L2))
(grsp-ldl "Density (L2)" 2 0)
(grsp-ldl density 0 1)

(set! pdensity (grsp-ann-net-pdensity L2))
(grsp-ldl "Planar density (L2)" 2 0)
(grsp-ldl pdensity 0 1)

(set! cnode (grsp-ann-nodes-conns L2))
(grsp-ldl "Connections per node (L2)" 2 0)
(grsp-lal-dev #t cnode)

(set! nconn (grsp-ann-conns-nodes L2))
(grsp-ldl "Nodes per connection (L2)" 2 0)
(grsp-lal-dev #t nconn)

;;(grsp-ann-devn #t L2 0)
;;(grsp-ann-devn #t L2 1)
;;(grsp-ann-devn #t L2 2)

;;(grsp-ann-devc #t L2 0)
;;(grsp-ann-devc #t L2 1)


(grsp-ann-devnc #t L2 2 0)
