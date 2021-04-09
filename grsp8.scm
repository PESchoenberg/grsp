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


;;;; General notes:
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
;;   2021].  
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
  #:use-module (grsp grsp9)
  #:use-module (grsp grsp10)    
  #:export (grsp-ann-net-create
	    grsp-ann-net-iter
	    grsp-ann-net-miter
	    grsp-ann-net-reconf
	    grsp-ann-net-preb
	    grsp-ann-counter-upd
	    grsp-ann-id-create
	    grsp-ann-item-create
	    grsp-ann-nodes-eval
	    grsp-ann-conns-eval
	    grsp-ann-layer-create))


;;;; grsp-ann-net-create - Create a base neural network.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Output:
;; - A list with three elements. The first is a matrix for the definition
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
;;     - Col 4: to.
;;     - Col 5: value.
;;     - Col 6: evol.
;;     - Col 7: weight.
;;     - Col 8: iter.
;;
;; and the third element is a 1x4 counter matrix that defines the id of
;; nodes and conns elements, as well as the iteration  and layer counters
;; according to:
;; - Col 0: nodes id counter.
;; - Col 1: conns id counter.
;; - Col 2: iteration counter.
;; - Col 3: layer counter.
;;
(define (grsp-ann-net-create)
  (let ((res1 '())
	(res2 '())
	(n1 0)
	(nodes 0)
	(conns 0)
	(count 0))

    ;; Create matrices with just one row.
    (set! nodes (grsp-matrix-create 0 1 11))
    (set! conns (grsp-matrix-create 0 1 9))
    (set! count (grsp-matrix-create -1 1 4))
   
    ;; Add data corresponding to the new nodes in the basic ann.
    (set! nodes (grsp-ann-item-create nodes conns count 0 (list 0 2 0 0 1 1 1 1 0 1 0))) ;; Input node.
    (set! nodes (grsp-ann-item-create nodes conns count 0 (list 0 2 1 1 1 1 0 1 0 1 0))) ;; Neuron.
    (set! nodes (grsp-ann-item-create nodes conns count 0 (list 0 2 2 2 1 1 0 1 0 1 0))) ;; Output node.

    ;; Add data corresponding to the new connections in basic ann.
    (set! conns (grsp-ann-item-create nodes conns count 1 (list 0 2 1 0 1 0 1 1 0))) ;; Input node to neuron.
    (set! conns (grsp-ann-item-create nodes conns count 1 (list 0 2 1 1 2 0 1 1 0))) ;; Neuron to output node.    

   ;; Set the yaer counter to 2, since we have generated three layers in practice.
    (array-set! count  2 0 3)
    
    ;; Set the session counter to zero.
    (set! n1 (grsp-ann-counter-upd count 2))
    
    ;; Results.
    (set! res1 (grsp-ann-net-preb nodes conns count))
    
    res1))


;;;; grsp-ann-net-iter - Run a single iteration of the network.
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
  (let ((res1 p_l1)
	(n1 0)
	(nodes 0)
	(conns 0)
	(count 0))

    ;; Extract matrices from list.
    (set! nodes (list-ref res1 0))
    (set! conns (list-ref res1 1))
    (set! count (list-ref res1 2))	

    ;; Update iteration counter.
    (set! n1 (grsp-ann-counter-upd count 2))

    ;; Rebuild the list representing the ann.
    (set! res1 (list nodes conns count))
        
    ;; Eval input nodes and conns.
    (set! res1 (grsp-ann-nodes-eval "#input" res1 n1))
    
    ;; Eval intermediate nodes and conns.
    (set! res1 (grsp-ann-nodes-eval "#intermediate" res1 n1))
    
    ;; Eval output nodes.
    (set! res1 (grsp-ann-nodes-eval "#output" res1 n1))

    res1))


;;;; grsp-ann-net-reconf - Reconfigure the the network.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_s1: reconfiguration method.
;;   - "#bp": backpropagation.
;; - p_l1: ann (list).
;;
;; Output:
;; - p_l1 updated.
;;
(define (grsp-ann-net-reconf p_s1 p_l1)
  (let ((res1 '()))

    ;; Results.
    (set! res1 p_l1)
    
    res1))


;;;; grsp-ann-net-iter - Iterate evaluations the network p_n1 times.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_s1: reconfiguration method. See grsp-ann-net-reconf for details.
;; - p_l1: ann (list).
;; - p_n1: iterations.
;;
;; Output:
;; - p_l1 updated.
;;
(define (grsp-ann-net-miter p_s1 p_l1 p_n1)
  (let ((res1 '())
	(i1 0))

    ;; Eval.
    (while (< i1 p_n1)
	   (set! p_l1 (grsp-ann-net-iter p_l1))
	   (set! p_l1 (grsp-ann-net-reconf p_s1 p_l1))
	   (set! i1 (+ i1 1)))
    
    ;; Results.
    (set! res1 p_l1)
    
    res1))


;;;; grsp-ann-net-preb - Purges and rebuilds the net from discarded connections
;; and nodes. While the network can survive and reman useful even if its entropy
;; increases, purging it should  be done in order to keep it to its minimum
; possible size for efficiency reasons.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_a1: nodes matrix.
;; - p_a2: conns matrix.
;; - p_a3: count matrix.
;;
(define (grsp-ann-net-preb p_a1 p_a2 p_a3)
  (let ((res1 '())
	(s1 "#="))

    ;; Delete rows where the value of col 1 is zero, meaning that connections
    ;; and nodes are dead.
    ;;(set! p_a2 (grsp-matrix-subdcn "#=" p_a2 1 0))
    ;;(set! p_a1 (grsp-matrix-subdcn "#=" p_a1 1 0))	  
    (set! p_a2 (grsp-matrix-row-delete s1 p_a2 1 0))
    (set! p_a1 (grsp-matrix-row-delete s1 p_a1 1 0))
    
    ;; Rebuild the list.
    (set! res1 (list p_a1 p_a2 p_a3))

    res1))


;;;; grsp-ann-counter-upd - Updates the ann id and iteration counters.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_a3: count matrix.
;; - p_n1: matrix element to increment.
;;   - 0: updates nodes counter.
;;   - 1: updates conns counter.
;;   - 2: updates iteration counter.
;;   - 3: updates layer counter.
;;
;; Output:
;; - Returns a new id number, either for nodes, conns, iteration or layer
;;   number.
;;
(define (grsp-ann-counter-upd p_a3 p_n1)
  (let ((res1 0))

    (set! res1 (+ (array-ref p_a3 0 p_n1) 1))
    (array-set! p_a3 res1 0 p_n1)

    res1))


;;;; grsp-ann-id-create - Created a new id number for a row in nodes or conns
;; and updates the corresponding matrix element.
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


;;;; grsp-ann-item-create - Create in p_l1 a node or connection with argument
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


;;;; grsp-ann-nodes-eval - Evaulates nodes of type p_s1 in network p_l1.
;;
;; Arguments:
;; - p_s1: node type:
;;   - "#input": input nodes.
;;   - "#intermediate": intermediate nodes.
;;   - "#output": output nodes.
;; - p_l1: ann.
;; - p_n1: number (iteration id).
;;
(define (grsp-ann-nodes-eval p_s1 p_l1 p_n1)
  (let ((res1 '())
	(res2 0)
	(res3 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0) ;; Lowest layer pos number per layer in nodes.
	(hn2 0) ;; Highest layer pos number per layer in nodes.
	(ln3 0) ;; Lowest layer number in nodes.
	(hn3 0) ;; Highest layer nunber in nodes.
	(nodes 0)
	(conns 0)
	(count 0)
	(c0 0)
	(c1 2) ;; Nodes must be active.
	(c2 0)
	(c3 0)
	(c4 0)
	(c5 0)
	(c6 0)
	(c7 0)
	(c8 0)
	(c9 0)
	(c10 0)
	(i1 0)
	(i2 0)
	(i3 0))
	
    ;; Extract matrices from list.
    (set! nodes (list-ref p_l1 0))
    (set! conns (list-ref p_l1 1))
    (set! count (list-ref p_l1 2))	

    ;; Extract the boundaries of the nodes matrix.
    (set! lm1 (grsp-matrix-esi 1 nodes))
    (set! hm1 (grsp-matrix-esi 2 nodes))
    (set! ln1 (grsp-matrix-esi 3 nodes))
    (set! hn1 (grsp-matrix-esi 4 nodes))

    ;; Extract the boundaries of the conns matrix.
    (set! lm2 (grsp-matrix-esi 1 conns))
    (set! hm2 (grsp-matrix-esi 2 conns))
    (set! ln2 (grsp-matrix-esi 3 conns))
    (set! hn2 (grsp-matrix-esi 4 conns))    

    (set! i1 lm1)
    (cond ((equal? p_s1 "#input")
	   (while (<= i1 hm1)

		  ;; Perform if row corresponds to:
		  ;; - An active node (col 1 = 2).
		  ;; - An input node (col 2 = 0).		  
		  (cond ((and (= (array-ref nodes i1 1) 2)
			      (= (array-ref nodes i1 2) 0))
			      
			 ;; In the case of input nodes, there is no
			 ;; processing by means of an activation function,
			 ;; thus the input value is passed directly to
			 ;; the connections.
			 (set! c0 (array-ref nodes i1 0)) ;; Id.
			 (set! c6 (array-ref nodes i1 6)) ;; Value.
			 (array-set! nodes p_n1 i1 10)    ;; Iter id.
			 (set! i2 lm2)
			 (while (<= i2 hm2)

				;; Perform if row corresponds to:
				;; - An active conn (col 1 = 2).
				;; - An conn coming from node c3 (col 3 = 3).		  
				(cond ((and (= (array-ref conns i2 1) 2)
					    (= (array-ref conns i2 3) c3))
				       (array-set! conns p_n1 i2 8) ;; iter id.
				       (array-set! conns c6 i2 5)))				
				(set! i2 (+ i2 1)))))
		  (set! i1 (+ i1 1))))
	  ((equal? p_s1 "#intermediate")

	   ;; Find out how many layers does the network has at the beginning of
	   ;; the iteration by finding the highest and lower layer numbers.
	   (set! res2 (grsp-matrix-subcpy nodes lm1 hm1 3 3)) ;; Extracts layer info in a col.
	   (set! res3 (grsp-matrix-minmax res2))

	   ;; Extract min and max layer values.
	   (set! ln3 (grsp-matrix-esi 1 res3))
	   (set! hn3 (grsp-matrix-esi 2 res3))
	   
	   ;; Go  over nodes table 
	   (while (<= i1 hm1)
		  ;;
		  (set! i1 (+ i1 0))))

	   
	  ((equal? p_s1 "#output")
	   (while (<= i1 hm1)

		  ;; Perform if row corresponds to:
		  ;; - An active node (col 1 = 2).
		  ;; - An output node (col 2 = 2).		  
		  (cond ((and (= (array-ref nodes i1 1) 2)
			      (= (array-ref nodes i1 2) 2))
			 (set! c0 (array-ref nodes i1 0)) ;; Id.
			 (array-set! nodes p_n1 i1 10)    ;; Iter id.
			 (while (<= i2 hm2)

				;; Perform if row corresponds to:
				;; - An active conn (col 1 = 2).
				;; - An conn coming to node c0 (col 5 = c0).		  
				(cond ((and (= (array-ref conns i2 1) 2)
					    (= (array-ref conns i2 5) c0))
				       (array-set! conns p_n1 i2 8) ;; iter id.
				       (array-set! nodes (+ (array-ref nodes i1 6)
							    (* (array-ref conns i2 5)
							       (array-ref conns i2 7))) i1 6))) ;; Summation of all incoming vals.
				(set! i2 (+ i2 1)))))
		  (set! i1 (+ i1 1)))))			   
 
    ;; Rebuild the list representing the ann.
    (set! res1 (list nodes conns count))
    
    res1))


;;;; grsp-ann-layer-create - Creates layer of type p_s1 in ann p_l accordng to
;; archetypal values contained in arguments p_l1.
;;
;; Arguments:
;; - p_s1: node type:
;;   - "#input": input nodes.
;;   - "#intermediate": intermediate nodes.
;;   - "#output": output nodes.
;; - p_l1: ann.
;; - p_n2: number of nodes for the new layer.
;; - p_l1: archetypal values for nodes in the layer.
;;
(define (grsp-ann-layer-create p_s1 p_n2 p_l1 p_l2)
  (let ((res1 '())
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
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
	(i2 0)
	(l1 '())
	(l2 '())
	(create #f)
	(n3 0)
	(n4 0)
	(n5 0)
	(n6 0)
	(n7 0))

    ;; Copy ann list.
    (set! l1 p_l1)
    (set! l2 p_l2)    
    
    ;; Extract matrices.
    (set! nodes (list-ref l1 0))
    (set! conns (list-ref l1 1))
    (set! count (list-ref l1 2))		

    ;; Extract boundaries from nodes.
    (set! lm1 (grsp-matrix-esi 1 nodes))
    (set! hm1 (grsp-matrix-esi 2 nodes))
    (set! ln1 (grsp-matrix-esi 3 nodes))
    (set! hn1 (grsp-matrix-esi 4 nodes)) 

    ;; Extract boundaries from conns.
    (set! lm2 (grsp-matrix-esi 1 conns))
    (set! hm2 (grsp-matrix-esi 2 conns))
    (set! ln2 (grsp-matrix-esi 3 conns))
    (set! hn2 (grsp-matrix-esi 4 conns)) 
    
    ;; Get layer number from list.
    (set! n3 (list-ref l2 3))
    
    ;; Get initial layer pos number from list.
    (set! n4 (list-ref l2 4))    
    
    ;; Check if exists a layer with the same number. If there is one, then n4,
    ;; which is the variable containing the layer pos within a layer should be
    ;; updated from zero to the highest value of the layer plus one. In this
    ;; regard, the use of this function produces:
    ;; - If no layer with number n3 exists: a new laye with number n3.
    ;; - If a layer with number n3 exists: the expansion of layer n3.
    (cond ((> (grsp-matrix-col-total-element "#=" nodes 3 n3) 0)

	   ;; Select all rows that correspond to nodes of the existing layer.
	   (set! res2 (grsp-matrix-row-select p_s1 nodes 3 n3))

	   ;; Find the max  layer pos number and increase it by one unit.
	   (set! res3 (grsp-matrix-row-minmax "#max" res2 4))
	   ;;(set! n4 (+ n4 (array-ref res2 0 4) 1))
	   (set! n4 (+ n4 (array-ref res3 0 4) 1))

	   ;; Find the number of the prior layer.
	   
	   ;; Update l1 with the new values.
	   (list-set! l2 4 n4)

	   ;; Authorize the creation of nodes for the layer.
	   (set! create #t))
	  (else (set! create #t)))

    ;; At this point we have updated values for n3 (layer number) and n4 (layer
    ;; pos). So the function will start creating p_n2 nodes for layer n3 
    ;; starting with an element whose layer pos number will be n4.
    (cond ((equal? create #t)
	   (while ((<= i1 p_n2)

		   ;; Create a node. If the node is an input type, no connections
		   ;; should be created. If it is intermediate or output type,
		   ;; connections to the prior layer should be created.
		   
		   ;;(set! nodes (grsp-ann-item-create nodes conns count 0 (list 0 2 1 1 1 1 0 1 0 1 0)))
		   (set! nodes (grsp-ann-item-create nodes conns count 0 l2))

		   ;; Create connections to the new layer from all elements of
		   ;; the prior layer to the new element, if applicable.
		   (set! res4 (grsp-matrix-row-select "#<" nodes 3 n3))

		   ;; The max value for layer in res4 will be the number of the
		   ;; prior layer.
		   (set! res5 (grsp-matrix-row-minmax "#max" res4 4))
		   (set! n5 (array-ref res4 0 4))
		   
		   ;;Number of conns from the prior layer.
		   (set! n6 (grsp-matrix-col-total-element "#=" conns 3 n5))
			 
		   (cond ((> (list-ref l2 2 ) 0)			  
			  ;; Find out the details of the prior layer.
		   
			  ;; Cycle over.  The cycle should be repeated for the 
			  ;; prsent node, for each node in the prior layer.
			  (set! i2 0)
			  (while (<= i2 n5)

				 (set! i2 (+ i2 1)))))		   
		   
		   ;; Update list values.
		   (set! n4 (+ n4 1))
		   (list-set! l2 4 n4)
			 
		   (set! i1 (+ i1 1))))))
   
    ;; Rebuild the list representing the ann.
    (set! res1 (list nodes conns count))
    
    res1))
