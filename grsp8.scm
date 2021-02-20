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


;; General notes:
;; - Read sources for limitations on function parameters.
;;
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
;;   https://mlfromscratch.com/activation-functions-explained [Accessed 28
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
	    grsp-ann-net-preb
	    grsp-ann-counter-upd
	    grsp-ann-id-create
	    grsp-ann-item-create))


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
;;     - Col 3: layer.
;;     - Col 4: layer pos.
;;     - Col 5: bias.
;;     - Col 6: output value.
;;     - Col 7: associated function.
;;     - Col 8: evol.
;;     - Col 9: weight.
;;     - Col 10: iter.
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
;; nodes and conns elements according to:
;; - Col 0: nodes id counter.
;; - Col 1: conns id counter.
;;
(define (grsp-ann-net-create)
  (let ((res1 '())
	(res2 '())
	(nodes 0)
	(conns 0)
	(count 0))

    ;; Create matrices with just one row.
    (set! nodes (grsp-matrix-create 0 1 11))
    (set! conns (grsp-matrix-create 0 1 9))
    (set! count (grsp-matrix-create -1 1 2))
   
    ;; Add data corresponding to the new nodes in the basic ann.
    (set! nodes (grsp-ann-item-create nodes conns count 0 (list 0 2 0 0 1 0 0 1 0 1 0))) ;; Input node.
    (set! nodes (grsp-ann-item-create nodes conns count 0 (list 0 2 1 0 1 0 1 1 0 1 0))) ;; Neuron.
    (set! nodes (grsp-ann-item-create nodes conns count 0 (list 0 2 2 0 1 0 0 1 0 1 0))) ;; Output node.

    ;; Add data corresponding to the new connections in basic ann.
    (set! conns (grsp-ann-item-create nodes conns count 1 (list 0 2 1 0 1 0 1 1 0))) ;; Input node to neuron.
    (set! conns (grsp-ann-item-create nodes conns count 1 (list 0 2 1 1 2 0 1 1 0))) ;; Neuron to output node.    
    
    ;; Results.
    (set! res1 (grsp-ann-net-preb nodes conns count))
    
    res1))


;; grsp-ann-net-iter - Run a network iteration.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l1: ann (list).
;;
;; Output:
;; - p_l1 updated.
;;
(define (grsp-ann-net-iter p_l1)
  (let ((res1 '())
	(nodes 0)
	(conns 0)
	(count 0)
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
    (set! nodes (list-ref p_l1 0))
    (set! conns (list-ref p_l1 1))
    (set! count (list-ref p_l1 2))

    ;; Extract the boundaries of the nodes matrix.
    (set! lm1 (grsp-matrix-esi 1 nodes))
    (set! hm1 (grsp-matrix-esi 2 nodes))
    (set! ln1 (grsp-matrix-esi 3 nodes))
    (set! hn1 (grsp-matrix-esi 4 nodes))

    ;; Extract the boundaries of the comms matrix.
    (set! lm2 (grsp-matrix-esi 1 conns))
    (set! hm2 (grsp-matrix-esi 2 conns))
    (set! ln2 (grsp-matrix-esi 3 conns))
    (set! hn2 (grsp-matrix-esi 4 conns))

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

    ;; Results.
    (set! res1 (grsp-ann-net-preb nodes conns count))

    res1))


;; grsp-ann-net-preb - Purges and rebuilds the net from discarded connections
;; and nodes.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; p_a1: nodes matrix.
;; p_a2: conns matrix.
;; p_a3: count matrix.
;;
(define (grsp-ann-net-preb p_a1 p_a2 p_a3)
  (let ((res1 '()))

    ;; Delete rows where the value of col 1 is zero, meaning that connections
    ;; and nodes are dead.
    (set! p_a2 (grsp-matrix-subdcn "#=" p_a2 1 0))
    (set! p_a1 (grsp-matrix-subdcn "#=" p_a1 1 0))	  

    ;; Rebuild the list.
    (set! res1 (list p_a1 p_a2 p_a3))

    res1))


;; grsp-ann-counter-upd - Updates the ann id counter.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_a3: count matrix.
;; - p_n1: matrix element to increment. 
;;
;; Output:
;; - Returns a new id number, either for nodes or conns.
;;
(define (grsp-ann-counter-upd p_a3 p_n1)
  (let ((res1 0))

    (set! res1 (+ (array-ref p_a3 0 p_n1) 1))
    (array-set! p_a3 res1 0 p_n1)

    res1))


;; grsp-ann-id-create - Created a new id number for a row in nodes or conns and
;; updates the corresponding matrix element.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_a1: nodes.
;; - p_a2: conns.
;; - p_a3: count.
;; - p_n1:
;;   - 0: new id for nodes.
;;   - 1: new id for conns.
;;
(define (grsp-ann-id-create p_a1 p_a3 p_n1)
  (let ((res1 p_a1)
	(hm1 1))

    ;; Extract the boundaries of the matrix.
    (set! hm1 (grsp-matrix-esi 2 res1))
    
    (array-set! res1 (grsp-ann-counter-upd p_a3 p_n1) hm1 0)
   
    res1))


;; grsp-ann-item-create - Create in p_l1 a node or connection with argument
;; list p_l2.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;, - p_l1: ann.
;; - p_n1:
;;   - 0: for nodes.
;;   - 1: for conns
;; - p_l2: list containing the values for the matrix row.
;;
(define (grsp-ann-item-create p_a1 p_a2 p_a3 p_n1 p_l2) 
  (let ((res1 0)
	(res2 0)
	(ln1 0)
	(hm1 0)	
	(nodes p_a1)
	(conns p_a2)
	(count p_a3)) 
  
    ;; Select matrix.
    (set! res1 (grsp-matrix-select nodes conns p_n1))
    
    ;; Add row in selected matrix.
    (set! res1 (grsp-matrix-subexp res1 1 0))

    ;; Vectorize list.
    (set! res2 (grsp-l2m p_l2))
	  
    ;; Extract required boundaries of the ann matrix selected.
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))

    ;; Add vector to matrix.
    (set! res1 (grsp-matrix-subrep res1 res2 hm1 ln1))

    ;; Update matrix id counter and set new id on the new row in matrix.
    (set! res1 (grsp-ann-id-create res1 count p_n1))
    
    res1))


