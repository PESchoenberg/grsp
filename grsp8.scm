;; =============================================================================
;;
;; grsp8.scm
;;
;; Neural networks.
;;
;; =============================================================================
;;
;; Copyright (C) 2018  Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;;   along with this program. If not, see <https://www.gnu.org/licenses/>.
;;
;; =============================================================================


;; Sources:
;; - [1] En.wikipedia.org. 2021. Artificial Neural Network. [online] Available
;;   at: https://en.wikipedia.org/wiki/Artificial_neural_network [Accessed 25
;;   January 2021].
;; - [2] En.wikipedia.org. 2021. Mathematics Of Artificial Neural Networks.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Mathematics_of_artificial_neural_networks
;;   [Accessed 25 January 2021].
;; - [3] En.wikipedia.org. 2021. Artificial Neuron. [online] Available at:
;;   https://en.wikipedia.org/wiki/Artificial_neuron [Accessed 25 January 2021].
;; - [4] En.wikipedia.org. 2021. Perceptron. [online] Available at:
;;   https://en.wikipedia.org/wiki/Perceptron [Accessed 25 January 2021].
;; - [5] En.wikipedia.org. 2021. Activation function. [online] Available at:
;;   https://en.wikipedia.org/wiki/Activation_function [Accessed 28 January
;    2021].  
;; - [6] Machine Learning From Scratch. 2021. Activation Functions Explained -
;;   GELU, SELU, ELU, ReLU and more. [online] Available at:
;;   https://mlfromscratch.com/activation-functions-explained/#/> [Accessed 28
;;   January 2021].


(define-module (grsp grsp8)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp4)
  #:use-module (grsp grsp5)  
  #:export (grsp-ann-net-create
	    grsp-ann-net-iter
	    grsp-ann-net-edit
	    grsp-ann-counter-upd
	    grsp-ann-node-create
	    grsp-ann-node-edit
	    grsp-ann-conn-create
	    grsp-ann-conn-edit
	    grsp-ann-neuron-calc))


;; grsp-ann-net-create - Create a base neural network.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Output:
;; - A list with three elements. The first is a matix for the definition
;;   of nodes. The second, a matrix for the definition of connections
;;   between those nodes, according to:
;;
;;   - nodes:
;;     - Col 0: id.
;;     - Col 1: status.
;;       - 0: dead.
;;       - 1: inactive.
;;       - 2: active.
;;     - Col 2: type.
;;       - 0: input.
;;       - 1: neuron.
;;       - 2: output.
;;     - Col 3: bias.
;;     - Col 4: output value.
;;     - Col 5: associated function.
;;     - Col 6: evol.
;;     - Col 7: weight.
;;     - Col 8: iter.
;;   - conns:
;;     - Col 0: id.
;;     - Col 1: status.
;;       - 0: dead.
;;       - 1: inactive.
;;       - 2: active.
;;     - Col 2: type.
;;       - 1: normal.
;;     - Col 3: from.
;;     - Col 4: output value.
;;     - Col 5: to.
;;     - Col 6: evol.
;;     - Col 7: weight.
;;     - Col 8: iter.
;;
;; and the third element is a 1x2 counter matrix that defines the id of
;; nods and conns elements according to:
;; - Col 0: nodes id counter.
;; - Col 1: conns id counter.
;;
(define (grsp-ann-net-create)
  (let ((nodes 0)
	(conns 0)
	(count 0)
	(res1 '()))

    ;; Create matrices with one row.
    (set! nodes (grsp-matrix-create 0 1 9))
    (set! conns (grsp-matrix-create 0 1 9))
    (set! count (grsp-matrix-create 0 1 2))

    ;; Add data corresponding to the new nodes in the ann.
    
    ;; Results.
    (set! res1 (list nodes conns count))
    
    res1))


;; grsp-ann-net-edit - Edit and modify an existing ann.
;;
;; Arguments:
;; p_l1: ann.
;; p_l2: edition plan.
;;
(define (grsp-ann-net-edit p_l1 p_l2)
  (let ((res1 '()))

    res1))


;; grsp-ann-net-iter - Run a network iteration.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l1: ann (list) created with grsp-ann-net-edit.
;;
;; Output:
;; - p_l1 updated.
;;
(define (grsp-ann-net-iter p_l1)
  (let ((res1 '())
	(nodes 0)
	(conns 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(i1 0)
	(j1 0)	
	(i2 0)
	(j2 0))

    ;; Extract matrices from list.
    (set! nodes (car p_l1))
    (set! conns (cadr p_l1))

    ;; Extract the boundaries of the nodes matrix.
    (set! lm1 (grsp-matrix-esi 1 nodes))
    (set! hm1 (grsp-matrix-esi 2 nodes))
    (set! ln1 (grsp-matrix-esi 3 nodes))
    (set! hn1 (grsp-matrix-esi 4 nodes))

    ;; Extract the boundaries of the comms matrix.
    (set! lm1 (grsp-matrix-esi 1 nodes))
    (set! hm1 (grsp-matrix-esi 2 nodes))
    (set! ln1 (grsp-matrix-esi 3 nodes))
    (set! hn1 (grsp-matrix-esi 4 nodes))

    ;; Eval row by row input nodes.
    (set! i1 ln1)
    (while (<= i1 hn1)

	   ;; If row (record) corresponds to an input
	   (cond ((= (array-ref nodes i1 2) 2)
		  ;; Eval row by row conns related to it.
		  (set! i1 ln2)
		  (while (<= i1 hn2)
			 
			 (set! i1 (+ i1 1)))))
	   
	   (set! i1 (+ i1 1)))
    

    res1))


;; grsp-ann-counter-upd - Updates the ann id counter.
;;
;; Arguments:
;; - p_a1: count matrix.
;; - p_n1: marix element to increment. 
;;
;; Output:
;; - Returns a new id number, either for nodes or conns.
;;
(define (grsp-ann-counter-upd p_a1 p_n1)
  (let ((res1 0))

    (set! res1 (+ (array-ref p_a1 0 p_n1) 1))
    (array-set! p_a1 res1 0 p_n1)

    res1))


;; grsp-ann-node-create - Create in ann p_l1 a node with argument list p_l2.
;;
;; Arguments:
;; p_l1: ann.
;; p_l2: edition plan.
;;
(define (grsp-ann-node-create p_l1 p_l2)
  (let ((res1 0)
	(nodes 0)
	(conns 0)
	(count 0))

    (set! nodes (list-ref p_l1 0))
    (set! conns (list-ref p_l1 1))
    (set! count (list-ref p_l1 2))
    

    res1))


;; grsp-ann-node-edit - Edit nodes for p_l1.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l1: ann (list).
;;
(define (grsp-ann-node-edit p_l1)
  (let ((res1 0))

    res1))


;; grsp-ann-conn-edit - Edit connections for p_l1.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l1: ann (list).
;;
(define (grsp-ann-conn-edit p_l1)
  (let ((res1 0))

    res1))


;; grsp-ann-neuron-calc - Process neurons.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l1: ann (list).
;;
(define (grsp-ann-neuron-calc p_l1)
  (let ((res1 0)
	(nodes 0)
	(conns 0))

    (set! nodes (car p_l1))
    (set! conns (cadr p_l1))

    res1))
