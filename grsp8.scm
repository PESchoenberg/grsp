;; =============================================================================
;;
;; grsp8.scm
;;
;; Neural networks.
;;
;; =============================================================================
;;
;; Copyright (C) 2018 - 2021 Pablo Edronkin (pablo.edronkin at yahoo.com)
;;
;;   This program is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU Lesser General Public License as published by
;;   the Free Software Foundation, either version 3 of the License, or
;;   (at your option) any later version.
;;
;;   This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
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
;; - [7] En.wikipedia.org. 2021. Evolutionary algorithm - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Evolutionary_algorithm
;;   [Accessed 29 September 2021].


(define-module (grsp grsp8)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp4)
  #:use-module (grsp grsp5)
  #:use-module (grsp grsp9)
  #:use-module (grsp grsp10)
  #:use-module (ice-9 threads)  
  #:export (grsp-ann-net-create-000
	    grsp-ann-net-create-ffv
	    grsp-ann-net-miter
	    grsp-ann-net-reconf
	    grsp-ann-net-preb
	    grsp-ann-counter-upd
	    grsp-ann-id-create
	    grsp-ann-item-create
	    grsp-ann-nodes-create
	    grsp-ann2dbc
	    grsp-dbc2ann
	    grsp-ann-net-create-ffn
	    grsp-ann-net-spec-ffn
	    grsp-ann-net-mutate
	    grsp-ann-net-mutate-mth
	    grsp-ann-deletes
	    grsp-ann-row-updatei
	    grsp-ann-conns-of-node
	    grsp-ann-node-eval
	    grsp-ann-actifun
	    grsp-ann-nodes-eval
	    grsp-ann-idata-create
	    grsp-ann-net-nmutate-omth
	    grsp-ann-idata-update
	    grsp-ann-odata-update
	    grsp-odata2idata
	    grsp-ann-get-matrix))


;;;; grsp-ann-net-create-000 - Creates an empty neural network.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_b1:
;;   - #t: to return lists with one element with zeros as values.
;;   - #f: for empty lists.
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
;;     - Col 9: to layer pos.
;;
;; and the third element is a 1x4 counter matrix that defines the id of
;; nodes and conns elements, as well as the iteration  and layer counters
;; according to:
;; - Col 0: nodes id counter.
;; - Col 1: conns id counter.
;; - Col 2: iteration counter.
;; - Col 3: layer counter.
;;
(define (grsp-ann-net-create-000 p_b1)
  (let ((res1 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0))

    ;; Create matrices with just one row.
    (set! nodes (grsp-matrix-create 0 1 11))
    (set! conns (grsp-matrix-create 0 1 10))
    (set! count (grsp-matrix-create 0 1 4))
    (set! idata (grsp-matrix-create 0 1 1))
    (set! odata (grsp-matrix-create 0 1 1))    
    
    ;; Rebuild the list.
    (cond ((equal? p_b1 #t)
	   (set! res1 (list nodes conns count)))
	  (else (set! res1 (grsp-ann-net-preb nodes conns count idata odata))))
    
    res1))


;;;; grsp-ann-net-create-ffv - A convenience function that combines
;; grsp-ann-net-create-ffn and grsp-ann-net-create-ffn to create a forward
;; feed network of a variable number of layers and elements contained in each
;; layer.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_b1:
;;   - #t if you want to return only the base ann list composed of matrices
;;     nodes, conns, count, idata and odata.
;;   - #f if you want to return also the associated matrix created during the
;;     process as the sixth of the ann list, meaning that this option returns
;;     nodes, conns, count, idata, odata and specs matrices.
;; - p_n2: number of mutation iterations desired.
;; - p_nl: number of nodes in layer 0.
;; - p_nm: number of intermediate layers.
;; - p_nn: number of nodes in intermediate layers.
;; - p_af: activation function for intermediate nodes.
;; - p_nh: number of nodes in final layer.
;;
;; Notes:
;; - See also grsp-ann-net-spec-ffn, grsp-ann-net-create-ffn and
;;   grsp-ann-net-mutate on how these functions operate.
;; - Mean and standard deviation for grsp-ann-net-mutate are 0.0 and 0.15
;;   respectively.
;; - A standard distribution is used for grsp-ann-net-mutate also.
;;
;; Output:
;; - A list with two elements combining the results provided by:
;;   - grsp-ann-net-spec-ffn.
;;   - grsp-ann-net-create-ffn.
;;   - grsp-ann-net-mutate.
;;
(define (grsp-ann-net-create-ffv p_b1 p_n2 p_nl p_nm p_nn p_af p_nh)
  (let ((res1 '())
	(res2 0)
	(res3 0)
	(l1 '(5 9))
	(l3 '(5 7))
	(i1 1))

    ;; Create the ann.
    (set! res2 (grsp-ann-net-spec-ffn p_nl p_nm p_nn p_af p_nh))
    (set! res3 (grsp-ann-net-create-ffn res2))
    
    ;; Mutate in order to randomize values, as many tumes as defined by argument
    ;; p_n2. In order not t mutate the network, set p_n2 = 0 so that the following
    ;; cycle gets ignored entirely.
    (while (<= i1 p_n2)
	   (set! res3 (grsp-ann-net-mutate res3 1 "#normal" 0.0 0.15 "#normal" 0.0 0.15 l1 l3))
	   (set! i1 (in i1)))

    ;; Compose results depending on p_b1.
    (cond ((equal? p_b1 #f)	   
	   (set! res1 (list (grsp-ann-get-matrix "nodes" res3)
			    (grsp-ann-get-matrix "conns" res3)
			    (grsp-ann-get-matrix "count" res3)
			    (grsp-ann-get-matrix "idata" res3)
			    (grsp-ann-get-matrix "odata" res3)
			    res2)))
	  (else (set! res1 res3)))
    
    res1))


;;;; grsp-ann-net-reconf - Reconfigure a neural network.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_s1: reconfiguration method.
;;   - "#no": none.
;;   - "#bp": backpropagation.
;; - p_l1: ann (list).
;;
;; Output:
;; - p_l1 updated.
;;
(define (grsp-ann-net-reconf p_s1 p_l1)
  (let ((res1 '())
	(l1 '()))

    (set! l1 p_l1)

    ;; Delete dead elements.
    (set! l1 (grsp-ann-deletes l1))

    ;; Callibrate.
    (cond ((equal? p_s1 "#bp")
	   (grsp-placebo " "))
	  (else (grsp-placebo " ")))
    
    ;; Compose results.
    (set! res1 l1)
    
    res1))


;;;; grsp-ann-net-miter - Iterate evaluations of the network p_n1 times.
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
	   ;;(set! p_l1 (grsp-ann-net-iter p_l1))
	   ;;(set! p_l1 (grsp-ann-net-reconf p_s1 p_l1))
	   (set! i1 (in i1)))
    
    ;; Compose results.
    (set! res1 p_l1)
    
    res1))


;;;; grsp-ann-net-preb - Purges and rebuilds the net from discarded connections
;; and nodes. While the network can survive and remain useful even if its
;; entropy increases, purging it should be done in order to keep it to its
;; minimum possible size for efficiency reasons.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_a1: nodes.
;; - p_a2: conns.
;; - p_a3: countx.
;; - p_a4: idata.
;; - p_a5: odata.
;;
;; Notes:
;; - In this case, matrices must be passed as separate arguments, not as a list
;;   of matrices like in most grsp8 functions.
;;
(define (grsp-ann-net-preb p_a1 p_a2 p_a3 p_a4 p_a5)
  (let ((res1 '())
	(s1 "#="))

    ;; Delete rows where the value of col 1 is zero, meaning that connections
    ;; and nodes are dead.	  
    (set! p_a2 (grsp-matrix-row-delete s1 p_a2 1 0))
    (set! p_a1 (grsp-matrix-row-delete s1 p_a1 1 0))
    
    ;; Compose results.
    (set! res1 (list p_a1 p_a2 p_a3 p_a4 p_a5))

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


;;;; grsp-ann-id-create - Creates a new id number for a row in nodes or conns
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


;;;; grsp-ann-item-create - Creates in the ann a node or connection with
;; argument list p_l2.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_a1: nodes matrix.
;; - p_a2: conns matrix.
;; - p_a3: count matrix.
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


;;;; grsp-ann-nodes-create - Creates node p_l2 connected according to p_l3 in
;; ann p_l1.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l1: list, ann.
;; - p_l2: list, node definition.
;; - p_l3: list of connections for p_l1.
;;
;; Output:
;; - Updated ann in list format.
;;
(define (grsp-ann-nodes-create p_l1 p_l2 p_l3)
  (let ((res1 '())
	(l2 '())
	(l3 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(hn 0)
	(i1 0)
	(cn 0)
	(cc 0))

    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))    
    (set! l2 p_l2)

    ;; Update node count in counter and l2.
    (set! cn (array-ref count 0 0))

    ;; Update id value in l2.
    (list-set! l2 0 cn)
    
    ;; Create one node per cycle with updated id.
    (set! nodes (grsp-ann-item-create nodes conns count 0 l2))
    (grsp-ann-counter-upd count 0)
    
    ;; Create connections only of node is not initial.
    (cond ((equal? (equal? (list-ref l2 2) 0) #f)
	   
	   ;; Create connections. There might be several connections per node
	   ;; in p_l3 each list element is in itself a list representing one
	   ;; connection.
	   (set! hn (length p_l3))
	   (while (< i1 hn)

		  ;; Update connection count in counter and l3.
		  (set! l3 (list-ref p_l3 i1))
		  (set! cc (array-ref count 0 1))	  

		  ;; Update id and to values in the list corresponding to the
		  ;; connection to be created.
		  (list-set! l3 0 cn)
		  (list-set! l3 4 cc)
		  
		  ;;(set! conns (grsp-ann-item-create nodes conns count 1 (list-ref p_l3 i1)))
		  (set! conns (grsp-ann-item-create nodes conns count 1 l3))
		  (set! i1 (in i1)))))
    
    ;; Compose results.
    (set! res1 (list nodes conns count idata odata))
    
    res1))


;;;; grsp-ann2dbc - Saves a neural network to a csv database.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_d1: database name
;; - p_l1: ann.
;;
;; Output:
;; - The ann will be saved to csv files stored in a folder called p_d1.
;;
(define (grsp-ann2dbc p_d1 p_l1)
  (let ((res1 0)
	(l1 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0))

    (set! l1 p_l1)
    
    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" l1))
    (set! conns (grsp-ann-get-matrix "conns" l1))
    (set! count (grsp-ann-get-matrix "count" l1))
    (set! idata (grsp-ann-get-matrix "idata" l1))
    (set! odata (grsp-ann-get-matrix "odata" l1))    

    ;; Save to database.
    (grsp-mc2dbc-csv p_d1 nodes "nodes.csv")
    (grsp-mc2dbc-csv p_d1 conns "conns.csv")
    (grsp-mc2dbc-csv p_d1 count "count.csv")
    (grsp-mc2dbc-csv p_d1 idata "idata.csv")
    (grsp-mc2dbc-csv p_d1 odata "odata.csv")))
    

;;;; grsp-dbc2ann - Retrieves an ann from a csv database.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_d1: database name
;; - p_l1: ann.
;;
;; Output:
;; - The csv files from folder p_d1 will be extracted into a list.
;;
(define (grsp-dbc2ann p_d1)
  (let ((res1 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)	
	(odata 0))

    (set! nodes (grsp-dbc2mc-csv p_d1 "nodes.csv"))
    (set! conns (grsp-dbc2mc-csv p_d1 "conns.csv"))
    (set! count (grsp-dbc2mc-csv p_d1 "count.csv"))
    (set! idata (grsp-dbc2mc-csv p_d1 "idata.csv"))
    (set! odata (grsp-dbc2mc-csv p_d1 "odata.csv"))    

    ;; Compose results.
    (set! res1 (list nodes conns count idata odata))
    
    res1))


;;;; grsp-ann-net-create-ffn - Creates an ann by matrix data. Each row of the
;; matrix should contain data for the creation of one layer of the ann.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_a1: matrix of format:
;;   - Col 0: layer number.
;;   - Col 1: number of nodes for present layer.
;;   - Col 2: type of node.
;;     - 0: input.
;;     - 1: neuron.
;;     - 2: output.
;;   - Col 3: activation function.
;;
;; Notes:
;; - See also grsp-ann-net-spec-ffn.
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
;;     - Col 9: to layer pos.
;;
;; and the third element is a 1x4 counter matrix that defines the id of
;; nodes and conns elements, as well as the iteration  and layer counters
;; according to:
;; - Col 0: nodes id counter.
;; - Col 1: conns id counter.
;; - Col 2: iteration counter.
;; - Col 3: layer counter.
;;
(define (grsp-ann-net-create-ffn p_a1)
  (let ((res1 '())
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(res6 0)
	(l1 '())
	(l2 '())
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm3 0)
	(hm3 0)
	(ln3 0)
	(hn3 0)
	(lm5 0)
	(hm5 0)
	(ln5 0)
	(hn5 0)	
	(i1 0)
	(i2 1)
	(i3 0)
	(i4 0)
	(i5 0)
	(j3 0)
	(j4 0)
	(j5 0)
	(c0 0)
	(c1 0)
	(c2 0)
	(a0 0)
	(a1 0)
	(a2 0)
	(a3 0)
	(w1 0)
	(n1 2)
	(b1 #t)
	(y1 0)
	(y2 0)
	(y3 0)
	(y4 0)
	(y5 0)
	(o0 0)
	(o3 0)
	(o4 0)
	(t0 0)
	(t3 0)
	(t4 0)	
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0))

    ;; Copy argument matrix.
    (set! res2 (grsp-matrix-cpy p_a1))

    ;; Create matrices with just one row.
    (set! nodes (grsp-matrix-create 0 1 11))
    (set! conns (grsp-matrix-create 0 1 10))
    (set! count (grsp-matrix-create -1 1 4))
    (set! idata (grsp-matrix-create 0 1 1))
    (set! odata (grsp-matrix-create 0 1 1))    
    
    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 res2))
    (set! hm1 (grsp-matrix-esi 2 res2))
    (set! ln1 (grsp-matrix-esi 3 res2))
    (set! hn1 (grsp-matrix-esi 4 res2))

    ;; Extract counter values and update.
    (set! c1 (array-ref count 0 1))
    (set! c2 (array-ref count 0 2))    
    (set! c0 (in c0))
    (set! c0 (array-ref count 0 0))
    (set! c2 (array-ref count 0 3))

    ;; Create nodes.
    (set! i1 lm1)
    (while (<= i1 hm1)

	   ;; Extract data from row i1 of res2.
	   (set! a0 (array-ref res2 i1 0))
	   (set! a1 (array-ref res2 i1 1))
	   (set! a2 (array-ref res2 i1 2))
	   (set! a3 (array-ref res2 i1 3))	   
	   
	   ;; Per each row of res2, repeat this cycle as many times as nodes per
	   ;; layer are required.
	   (set! i2 0)
	   (while (< i2 a1)		   		   
		   (cond ((= a2 0) ; Input node.
			  (set! l1 (list c0 n1 0 a0 i2 0 0 a3 0 w1 i2))
			  (set! nodes (grsp-ann-item-create nodes conns count 0 l1)))
			 ((= a2 1) ; Neuron.
			  (set! l1 (list c0 n1 1 a0 i2 0 0 a3 0 w1 i2))
			  (set! nodes (grsp-ann-item-create nodes conns count 0 l1)))
			 ((= a2 2) ; Output node.
			  (set! l1 (list c0 n1 2 a0 i2 0 0 a3 0 w1 i2))
			  (set! nodes (grsp-ann-item-create nodes conns count 0 l1))))
		   
		   ;;(grsp-ann-counter-upd count 0)
		   (set! c0 (array-ref count 0 0))
		   
		   (set! i2 (in i2)))
	   (set! i1 (in i1)))

    ;; Purge nodes table; this is necessary since on creation a single row is
    ;; added with all elements set on zero. Normally this would not mean trouble
    ;; and such tables can be purged later, but in this case we need to do so
    ;; because otherwise creation of connections from nodes of the first layer
    ;, could cause trouble.
    (set! nodes (grsp-matrix-row-delete "#=" nodes 1 0))
    
    ;; Create connections (connect every node of a layer to all nodes of the
    ;; prior layer). Repeat for every layer.
    (set! res4 (grsp-matrix-cpy nodes))
    (set! res4 (grsp-matrix-row-sort "#des" res4 3))
    (while (equal? b1 #t)
	   ;;(set! res4 (grsp-matrix-row-sort "#des" res4 3))
	   (set! y1 (array-ref res4 0 3))
	   
	   ;; If the layer number is zero, it means that we are dealing with the
	   ;; initial one and hence, no connections gong to this layer will be
	   ;; created. Othewise, every node of the layer will be connected to
	   ;; every node of the prior layer.
	   (cond ((> y1 0)
		  ;; Separate the corrent res4 into two parts:
		  ;; - One will contain the rows (nodes) whose column 3 (layer)
		  ;;   equals y1. This will be table res3.
		  ;; - The second part contains everything else. That is, given
		  ;;   the row sort and selectc ops performed, res4 from now on
		  ;;   will contain what would be processed in the next
		  ;;   iteration, excluding what will be processed on this one.
		  (set! l2 (grsp-matrix-row-selectc "#=" res4 3 y1))
		  (set! res3 (list-ref l2 0))
		  (set! res4 (list-ref l2 1))
		  
		  ;; Get the layer numbers from the first rows of the target
		  ;; layer matrix (res3) as well as from the remainder matrix
		  ;; which represents the layer number of the origin layer (the
		  ;; layer with the layer number immediately lower than the
		  ;; number of the target layer.
		  (set! y3 (array-ref res3 0 3))
		  (set! y4 (array-ref res4 0 3))

		  ;; Select all rows from the origin layer.
		  (set! res5 (grsp-matrix-row-select "#=" res4 3 y4))
		  (set! y5 (array-ref res5 0 3))
		  
		  ;; Extract the boundaries of res3 (target layer); it contains
		  ;; only rows corresponding to nodes of the target layer.
		  (set! lm3 (grsp-matrix-esi 1 res3))
		  (set! hm3 (grsp-matrix-esi 2 res3))
		  (set! ln3 (grsp-matrix-esi 3 res3))
		  (set! hn3 (grsp-matrix-esi 4 res3))

		  ;; Extract the boundaries of res5.
		  (set! lm5 (grsp-matrix-esi 1 res5))
		  (set! hm5 (grsp-matrix-esi 2 res5))
		  (set! ln5 (grsp-matrix-esi 3 res5))
		  (set! hn5 (grsp-matrix-esi 4 res5))

		  ;; So, right now:
		  ;; - res3 has the nodes of the target layer.
		  ;; - res4 has all the nodes of the ann except those of the
		  ;;   target layer.
		  ;; - res5 has the nodes of the origin layer.
		  ;; Now we cycle over the target layer, and for each node we
		  ;; will create connections coming from each node of the
		  ;; origin layer.	  
		  (set! i3 lm3)
		  (while (<= i3 hm3)

			 (set! t0 (array-ref res3 i3 0)) ;; Node id.
			 (set! t3 (array-ref res3 i3 3)) ;; Layer.
			 (set! t4 (array-ref res3 i3 4)) ;; Layer pos.
			 
			 ;; Cycle over the prior layer.
			 (set! i5 lm5)
			 (while (<= i5 hm5)

				(set! o0 (array-ref res5 i5 0)) ;; Node id.
				(set! o3 (array-ref res5 i5 3)) ;; Layer.
				(set! o4 (array-ref res5 i5 4)) ;; Layer pos.
				(set! conns (grsp-ann-item-create nodes conns count 1 (list 0 2 1 o0 t0 0 0 0 0 t4)))
				
				(set! i5 (in i5)))
			 
			 (set! i3 (in i3))))			
		 (else (set! b1 #f))))
	    
    ;; Compose results.
    (set! res1 (grsp-ann-net-preb nodes conns count idata odata))
    
    res1))


;;;; grsp-ann-net-spec-ffn - Creates the specification matrix for
;; grsp-ann-net-spec-ffn in order to create a forward feed neural network.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_nl: number of nodes in layer 0.
;; - p_nm: number of intermediate layers.
;; - p_nn: number of nodes in intermediate layers.
;; - p_af: activation function for intermediate nodes.
;; - p_nh: number of nodes in final layer.
;;
;; Notes:
;; - See also grsp-ann-net-create-ffn.
;;
;; Output:
;; - A matrix with the following structure:
;;   - Col 0: layer number.
;;   - Col 1: number of nodes for present layer.
;;   - Col 2: type of node.
;;     - 0: input.
;;     - 1: neuron.
;;     - 2: output.
;;   - Col 3: activation function.
;;
(define (grsp-ann-net-spec-ffn p_nl p_nm p_nn p_af p_nh)
  (let ((res1 0)
	(i1 0)
	(lm1 0)
	(hm1 0)
	(m1 0)  ; Number of rows.
	(n1 4)) ; Number of cols.

    ;; Calculate number of rows based on total number of ann layers. 
    (set! m1 (+ 2 p_nm))

    ;; Find id number of activation function.
    
    ;; Create empty matrix
    (set! res1 (grsp-matrix-create 0 m1 n1))

    ;; Extract the boundaries of the matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))

    ;; Cycle.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (array-set! res1 i1 i1 0)
	   (cond ((= i1 lm1)
		  ;; Set values for first row.		  
		  (array-set! res1 p_nl i1 1)
		  (array-set! res1 0 i1 2)
		  (array-set! res1 0 i1 3))
		 ((= i1 hm1)
		  ;; Set values for last row.
		  (array-set! res1 p_nh i1 1)
		  (array-set! res1 2 i1 2)
		  (array-set! res1 0 i1 3))
		 (else (array-set! res1 p_nn i1 1)
		       (array-set! res1 1 i1 2)
		       (array-set! res1 p_af i1 3)))

	   (set! i1 (in i1)))
	   
    res1))


;;;; grsp-ann-net-mutate - Mutates and randomizes ann p_l1.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l2: ann.
;; - p_n1: mutation rate, [0, 1].
;; - p_s1: type of distribution.
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;; - p_u1: mean for mutation rate.
;; - p_v1: standard deviation for mutation rate.
;; - p_s2: type of distribution.
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;; - p_u2: mean for element random value.
;; - p_v2: standard deviation for element random value.
;; - p_l1: list of elements (cols) of nodes to mutate. Usually values sould be:
;;   - 5: bias.
;;   - 9: weight.
;; - p_l3: list of elements (cols) of conns to mutate. Usually values sould be:
;;   - 5: value.
;;   - 7: weight.
;;
;; Notes:
;; - See grsp-matrix-col-lmutation.
;; - You can mutate any element that corresponds to the ann, passed via arguments
;;   p_l1 and p_l3 but be careful, since modifying random elements other than
;;   those mentioned above could yield unexpected results.
;;
(define (grsp-ann-net-mutate p_l2 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2 p_l1 p_l3)
  (let ((res1 '())
	(l1 '())
	(l2 '())
	(l3 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0))

    (set! l2 p_l2)
    
    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" l2))
    (set! conns (grsp-ann-get-matrix "conns" l2))
    (set! count (grsp-ann-get-matrix "count" l2))
    (set! idata (grsp-ann-get-matrix "idata" l2))
    (set! odata (grsp-ann-get-matrix "odata" l2))    
    
    ;; Mutate nodes.
    (set! l1 p_l1)
    (set! nodes (grsp-matrix-col-lmutation nodes p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2 l1))

    ;; Mutate conns.
    (set! l3 p_l3)
    (set! conns (grsp-matrix-col-lmutation conns p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2 l3))

    ;; Compose results.
    (set! res1 (list nodes conns count idata odata))    

    res1))


;;;; grsp-ann-net-mutate-mth - Multithreaded variant of grsp-ann-net-mutate.
;; Mutate and randomize ann p_l1.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l2: ann.
;; - p_n1: mutation rate, [0, 1].
;; - p_s1: type of distribution.
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;; - p_u1: mean for mutation rate.
;; - p_v1: standard deviation for mutation rate.
;; - p_s2: type of distribution.
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;; - p_u2: mean for element random value.
;; - p_v2: standard deviation for element random value.
;; - p_l1: list of elements (cols) of nodes to mutate. Usually values sould be:
;;   - 5: bias.
;;   - 9: weight.
;; - p_l3: list of elements (cols) of conns to mutate. Usually values sould be:
;;   - 5: value.
;;   - 7: weight.
;;
;; Notes:
;; - See grsp-matrix-col-lmutation.
;; - You can mutate any element of a neural network passed via arguments p_l1
;;   and p_l3 but be careful, since modifying randomly elements other than
;;   those mentioned above could yield unexpected results, even altering the
;;   structure of the network iteslf or render it unusable. Always backup your
;;   ANN before toying with this function.
;;
(define (grsp-ann-net-mutate-mth p_l2 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2 p_l1 p_l3)
  (let ((res1 '())
	(l1 '())
	(l2 '())
	(l3 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0))

    (set! l2 p_l2)
    
    ;; Extract matrices and lists.
    (parallel (set! nodes (grsp-ann-get-matrix "nodes" l2))
	      (set! conns (grsp-ann-get-matrix "conns" l2))
	      (set! count (grsp-ann-get-matrix "count" l2))
	      (set! idata (grsp-ann-get-matrix "idata" l2))
	      (set! odata (grsp-ann-get-matrix "odata" l2)))	      
    
    (parallel ((set! l1 p_l1)
	       (set! nodes (grsp-matrix-col-lmutation nodes p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2 l1)))
	      ((set! l3 p_l3)
	       (set! conns (grsp-matrix-col-lmutation conns p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2 l3))))

    ;; Compose results.
    (set! res1 (list nodes conns count idata odata))    
    
    res1))


;;;; grsp-ann-deletes - Deletes from ann p_l1 all elements with status (col 1)
;; equal to zero.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l1: list, ann.
;;
;; Notes:
;; - This function is agnostic regarding connections and how they depend from
;;   nodes, meaning that in ordenr not to leave orphaned connectins once
;;   dead nodes have been deleted, the status of the dependent nodes should
;;   be set to zero before using this function.
;; - By setting row 1 to 0 at will and applying this function you can
;;   essentially delete any component of a neural network, following any
;;   schedule.
;;
(define (grsp-ann-deletes p_l1)
  (let ((res1 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0))

    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))    
    
    (set! nodes (grsp-matrix-row-delete "#=" nodes 1 0))
    (set! conns (grsp-matrix-row-delete "#=" conns 1 0))

    ;; Compose results.
    (set! res1 (list nodes conns count idata odata))

    res1))


;;;; grsp-ann-row-updatei - Updates col p_j2 with value p_n2 of element with id
;; p_id of table p_a1 (nodes or conns).
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_a1: matrix (nodes or conns).
;; - p_id: id (col 0).
;; - p_j2: column.
;; - p_n2: value.
;;
(define (grsp-ann-row-updatei p_a1 p_id p_j2 p_n2)
  (let ((res1 0))

    (set! p_a1 (grsp-matrix-row-update "#=" p_a1 0 p_id p_j2 p_n2))

    (set! res1 p_a1)
    
    res1))


;;;; grsp-ann-conns-of-node - Finds the connections that reach node with id p_id
;; aacording to p_s1 in p_a1.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_s1: type of connection:
;;   - "#fr": those going out of node p_id.
;;   - "#to": those reaching node p_id.
;; - P_a1: matrix (conns).
;; - p_id: node id.
;;
(define (grsp-ann-conns-of-node p_s1 p_a1 p_id)
  (let ((res1 0)
	(j1 3))

    (cond ((equal? p_s1 "#to")
	   (set! j1 4)))
	  
    (set! res1 (grsp-matrix-row-select "#=" p_a1 j1 p_id))
    
    res1))


;;;; grsp-ann-node-eval - Evaluates node p_id and its related connections. It
;; reads the input connections, applies the specified functon and exports the
;; result to the output connections.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_id: node id.
;; - p_a1: matrix (nodes).
;; - p_a2: matrix (conns).
;; - p_a3: matrix (count).
;;
;; Notes:
;; -  Keep in mind TL0 and TL1 while using this function.
;;
(define (grsp-ann-node-eval p_id p_a1 p_a2 p_a3)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(l1 '())
	(b1 #f)
	(b2 #f)
	(n1 0)
	(n2 0)
	(n5 0)
	(n6 0)
	(n7 0)
	(n9 0)
	(m5 0))

    ;; First check if the node exists.
    ;; - If it does exist, then process.
    ;; - If it does not exist then kill any leftover connection (set status
    ;;   to zero).
    (set! res1 (grsp-matrix-row-select "#=" p_a1 0 p_id))
    (set! b1 (grsp-matrix-is-empty res1))
    (cond ((equal? b1 #t) ;; If node exists.

	   ;; If the node has incoming connections then we need to process them.
	   (set! res2 (grsp-ann-conns-of-node "#to" p_a2 p_id))
	   (set! b2 (grsp-matrix-is-empty res2))
	   (cond ((equal? b2 #f)
		  (set! n1 (grsp-matrix-opio "#+c" res2 5))
		  (set! n2 (grsp-matrix-opio "#+c" res2 7))
		  (set! n6 (+ n1 n2))
		  (array-set! res1 n6 0 6))) ;; Value.
	   
	   ;; Apply activation function.
	   (set! n5 (array-ref res1 0 5)) ;; Bias.
	   (set! n7 (array-ref res1 0 7)) ;; Associated function.
	   (set! n9 (array-ref res1 0 7)) ;; Weight.
	   
	   ;; Set value.
	   (set! n6 (* (+ n6 n9) n5))
	   
	   ;; Select activation function and calculate.
	   (set! l1 (list n6))
	   (set! m5 (grsp-ann-actifun n7 l1))
	   
	   ;; Process output connections. These receive the output value of the
	   ;; node as it is.
	   (set! p_a2 (grsp-matrix-row-update "#=" p_a2 0 p_id 5 m5))

	   ;; Reset element 5 of the input nodes going to node p_id to zero once
	   ;; the data has been passed to the output connections.
	   (set! p_a2 (grsp-matrix-row-update "#=" p_a2 4 p_id 5 0))
	   
	   ;; Reset element 6 of the corresponding node to zero once the data
	   ;; has been passed to the output connections.
	   (set! p_a1 (grsp-matrix-row-update "#=" p_a1 0 p_id 6 0)))
	  
	  ;; Commit.
	  ((equal? b1 #f) ;; If node does not exist.
	   (set! p_a2 (grsp-matrix-row-update "#=" p_a2 3 p_id 1 0))
	   (set! p_a2 (grsp-matrix-row-update "#=" p_a2 4 p_id 1 0))))
	   
    res4))


;;;; grsp-ann-actifun - Selects function p_n1 passing argument p_n2.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_n1: activation function [0,17].
;;   - 0: identity.
;;   - 1: binary step.
;;   - 2: sigmoid.
;;   - 3: tanh.
;;   - 4: relu.
;;   - 5: softplus.
;;   - 6: elu.
;;   - 7: lrelu.
;;   - 8: selu.
;;   - 9: gelu.
;;   - 10: prelu.
;;   - 11: softsign.
;;   - 12: sqnl.
;;   - 13: bent identity.
;;   - 14: silu.
;;   - 15: srelu.
;;   - 16: gaussian.
;;   - 17: sqrbf.
;; - p_l1: list of applicable input values. See grsp10.scm.
;;
(define (grsp-ann-actifun p_n1 p_l1)
  (let ((res1 0)
	(l1 '()))

    (set! l1 p_l1)
    (cond ((= p_n1 0)
	   (set! res1 (grsp-identity l1)))
	  ((= p_n1 1)
	   (set! res1 (grsp-binary-step l1)))
	  ((= p_n1 2)
	   (set! res1 (grsp-sigmoid l1)))
	  ((= p_n1 3)
	   (set! res1 (grsp-tanh l1)))
	  ((= p_n1 4)
	   (set! res1 (grsp-relu l1)))
	  ((= p_n1 5)
	   (set! res1 (grsp-softplus l1)))		 
	  ((= p_n1 6)
	   (set! res1 (grsp-elu l1)))
	  ((= p_n1 7)
	   (set! res1 (grsp-lrelu l1)))
	  ((= p_n1 8)
	   (set! res1 (grsp-selu l1)))
	  ((= p_n1 9)
	   (set! res1 (grsp-gelu l1)))		 
	  ((= p_n1 10)
	   (set! res1 (grsp-prelu l1)))
	  ((= p_n1 11)
	   (set! res1 (grsp-softsign l1)))
	  ((= p_n1 12)
	   (set! res1 (grsp-sqnl l1)))
	  ((= p_n1 13)
	   (set! res1 (grsp-bent-identity l1)))
	  ((= p_n1 14)
	   (set! res1 (grsp-silu l1)))
	  ((= p_n1 15)
	   (set! res1 (grsp-srelu l1)))
	  ((= p_n1 16)
	   (set! res1 (grsp-gaussian l1)))		 
	  ((= p_n1 17)
	   (set! res1 (grsp-sqrbf l1)))
	  ((= p_n1 18)
	   (set! res1 (grsp-ifrprnd-num l1)))
	  ((= p_n1 19)
	   (set! res1 (grsp-trcrnd l1))))
    
    res1))


;;;; grsp-ann-nodes-eval - Performs one iteration of evaluation of all nodes
;; in ann p_l1 using idata.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l1: ann with the following elements:
;;   - nodes.
;;   - conns.
;;   - count.
;;   - idata.
;;   - odata.
;;
;; Notes:
;; - Use grsp-ann-idata-update before this function to pass actual data to the
;;   ann.
;;
;; Output:
;; - Updated ann.
;;
(define (grsp-ann-nodes-eval p_l1)
  (let ((res1 '())
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)	
	(id 0)
	(i1 0)
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0))

    (set! res1 p_l1)
    
    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" res1))
    (set! conns (grsp-ann-get-matrix "conns" res1))
    (set! count (grsp-ann-get-matrix "count" res1))
    (set! idata (grsp-ann-get-matrix "idata" res1))
    (set! odata (grsp-ann-get-matrix "odata" res1))    
    
    ;; Sort nodes by layer number.
    (set! nodes (grsp-matrix-row-sort "#asc" nodes 3))

    ;; Extract boundaries of nodes.
    (set! lm1 (grsp-matrix-esi 1 nodes))
    (set! hm1 (grsp-matrix-esi 2 nodes))
    (set! ln1 (grsp-matrix-esi 3 nodes))
    (set! hn1 (grsp-matrix-esi 4 nodes)) 
    
    ;; Evaluate nodes and its input and output connections.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   
	   (set! id (array-ref nodes i1 0))
	   (grsp-ann-node-eval id nodes conns count)
	   
	   (set! i1 (in i1)))
	   
    ;; Update iteration counter.
    (grsp-ann-counter-upd count 2)
    
    ;; Compose results.
    (set! res1 (list nodes conns count idata odata))

    res1))    

    
;;;; grsp-ann-idata-create - Creates an empty idata matrix of p_m1 rows to
;; provide input for nodes and conns.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_s1: matrix type or element that will fill it initially.
;;   - "#I": Identity matrix.
;;   - "#AI": Anti Identity matrix (anti diagonal).
;;   - "#Q": Quincunx matrix.
;;   - "#Test1": Test matrix 1 (LU decomposable)[1].
;;   - "#Test2": Test matrix 2 (LU decomposable)[2].
;;   - "#Ladder": Ladder matrix.
;;   - "#Arrow": Arrowhead matrix.
;;   - "#Hilbert": Hilbert matrix.
;;   - "#Lehmer": Lehmer matrix.
;;   - "#Pascal": Pascal matrix.
;;   - "#CH": 0-1 checkerboard pattern matrix.
;;   - "#CHR": 0-1 checerboard pattern matrix, randomized.
;;   - "#+IJ": matrix containing the sum of i and j values.
;;   - "#-IJ": matrix containing the substraction of i and j values.
;;   - "#+IJ": matrix containing the product of i and j values.
;;   - "#-IJ": matrix containing the quotient of i and j values.
;;   - "#US": upper shift matrix.
;;   - "#LS": lower shift matrix.
;;   - "#rprnd": pseduo random values, normal distribution, sd = 0.15.
;; - p_m1: number of rows.
;;
;; Notes:
;; - See grsp-matrix-create fo detals on argument p_s1. Some configurations might
;;   require a symmetric matrix (3 x 3) to work.
;; - Column 0 will be set to zero. You should set the values  of this col
;;   acording to the id of each node to be evaluated with the given data.
;; - You might have to modify the elements of columns 0 and 1 in order to provide
;;   useful values for different nodes.
;;
(define (grsp-ann-idata-create p_s1 p_m1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-create p_s1 p_m1 4))
    (set! res1 (grsp-matrix-col-aupdate res1 0 0))
    (set! res1 (grsp-matrix-col-aupdate res1 1 5))
    (set! res1 (grsp-matrix-col-aupdate res1 1 6))
    (set! res1 (grsp-matrix-col-aupdate res1 3 0))
    
    res1))


;;;; grsp-ann-net-nmutate-omth - Safely mutates and randomizes ann p_l2 using a
;; standard normal distribution.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_b1: select threading mode.
;;   - #t: multi-threaded.
;;   - #f: single-threaded.
;; - p_l2: ann.
;;
(define (grsp-ann-net-nmutate-omth p_b1 p_l2)
  (let ((res1 '())
	(l1 '())
	(l3 '())
	(b1 #f))

    (set! res1 p_l2)

    ;; Set mutation lists.
    (set! l1 (list 5 9))
    (set! l3 (list 5 7))

    ;; Apply mutation.
    (cond ((equal? b1 #f)
	   (set! res1 (grsp-ann-net-mutate res1 0.5 "#normal" 0.0 0.15 "#normal" 0.0 0.15 l1 l3)))
	  ((equal? b1 #t)
	   (set! res1 (grsp-ann-net-mutate-mth res1 0.5 "#normal" 0.0 0.15 "#normal" 0.0 0.15 l1 l3))))

    res1))


;;;; grsp-ann-idata-update - Inputs data of idata into matrices nodes and conns
;; of ann p_l1.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l1: ann list with the following elements:
;;   - nodes.
;;   - conns.
;;   - count.
;;   - idata: matrix, idata. An m x 4 matrix containing the data for the input
;;     nodes of the neural network according to the following format:
;;     - Col 0: id of the receptive node.
;;     - Col 1: number that corresponds to the column in the nodes matrix in
;;       which for the row whose col 0 is equal to the id value passed in col 0
;;       of the idata matrix the input value will be stored.
;;     - Col 2: number.
;;     - Col 3: type, the kind of element that will receive this data.
;;       - 0: for node.
;;       - 1: for connection.
;;
;; Notes:
;; - While normally idata would be used to pass data to input nodes, the matrix
;;   could be used to pass other values to the nodes matrix.
;; - Use this function before calling grsp-ann-nodes-eval in order to provide
;;   input data to the nn.
;;
;; Output:
;; - Updated ann p_l1.
;;
(define (grsp-ann-idata-update p_l1)
  (let ((res1 '())
	(res2 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)	
	(lm4 0)
	(hm4 0)
	(ln4 0)
	(hn4 0)
	(id 0)
	(i1 0)
	(i4 0)
	(j2 0)
	(n2 0)
	(n3 0)
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0))

    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))    
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))    
        
    ;; Extract boundaries of idata.
    (set! lm4 (grsp-matrix-esi 1 idata))
    (set! hm4 (grsp-matrix-esi 2 idata))
    (set! ln4 (grsp-matrix-esi 3 idata))
    (set! hn4 (grsp-matrix-esi 4 idata)) 	  

    ;; Pass idata data to the ann.
    (set! i4 lm4)
    (while (<= i4 hm4)

	   (set! id (array-ref idata i4 0))
	   (set! j2 (array-ref idata i4 1))
	   (set! n2 (array-ref idata i4 2))
	   (set! n3 (array-ref idata i4 3))

	   ;; Update either the nodes or conns matrix.
	   (cond ((= n3 0)
		  (set! nodes (grsp-matrix-row-update "#=" nodes 0 id j2 n2)))
		 ((= n3 1)
		  (set! conns (grsp-matrix-row-update "#=" conns 0 id j2 n2))))
	   
	   (set! i4 (in i4)))

    ;; Compose results.
    (set! res1 (list nodes conns count idata odata))
    
    res1))


;;;; grsp-ann-odata-update - Provides a current output data matrix for ann p_l1.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l1: ann.
;;
;; Output:
;; - Matrix, odata. An m x 4 matrix containing the data from the output
;;   nodes of the neural network according to the following format:
;;   - Col 0: id of each output node.
;;   - Col 1: layer.
;;   - Col 2: layer pos.
;;   - Col 3: number (result).
;;
(define (grsp-ann-odata-update p_l1)
  (let ((res1 0)
	(res2 0)
	(nodes 0))

    ;; Extract matrices.
    (set! nodes (list-ref p_l1 0))

    ;; Select output nodes.
    (set! res2 (grsp-matrix-row-select "#=" nodes 2 2))
    (set! res1 (grsp-matrix-col-selectn res2 (list 0 3 4 6)))
					
    res1))


;;;; grsp-odata2idata - Provides feedback by transfer of data from from odata to
;; idata matrices. Transforms data from the output layer of an ann into data for
;; the input layer of the same or a different network.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_a5: odata.
;; - p_a6: odata to idata conversion table. An m x 2 matrix with the following
;;   format:
;;   - Col 0: input idata layer pos (pos input).
;;   - Col 1: output odata layer pos (pos output).
;;
;; Notes:
;; - The function delivers an idata table based on the odata pand conversion
;;   table provided.
;; - See grsp-ann-idata-update for a description of the idata format.
;;   - Col 0: id of the receptive node.
;;   - Col 1: number that corresponds to the column in the nodes matrix in which
;;   - For the row whose col 0 is equal to the id value passed in col 0 of the
;;     idata matrix the input value will be stored.
;;   - Col 2: number.
;;   - Col 3: type, the kind of element that will receive this data.
;;     - 0: for node.
;;     - 1: for connection.	
;; - See grsp-ann-odata-update for a description of the odata format.
;;   - Col 0: id of each output node.
;;   - Col 1: layer.
;;   - Col 2: layer pos.
;;   - Col 3: number (result).
;;
;; Output:
;; - A matrix in idata table that can take the place of that table or be
;;   appended to it.
;;
(define (grsp-odata2idata p_a5 p_a6)
  (let ((res1 0)
	(res2 0)
	(idata 0)
	(odata 0)
	(conv 0)
	(lm6 0)
	(hm6 0)
	(ln6 0)
	(hn6 0)
	(m5 0)
	(m6 0)
	(i6 0)
	(j6 0)
	(id0 0)
	(id1 0)
	(id2 0)
	(id3 0)
	(od0 0)
	(od1 0)
	(od2 0)
	(od3 0)
	(cd0 0)
	(cd1 0))

    ;; Make safe copies of arguments.
    (set! odata p_a5)
    (set! conv p_a6)
    
    ;; Extract boundaries of conversion table.
    (set! lm6 (grsp-matrix-esi 1 conv))
    (set! hm6 (grsp-matrix-esi 2 conv))
    (set! ln6 (grsp-matrix-esi 3 conv))
    (set! hn6 (grsp-matrix-esi 4 conv))

    ;; Find how many things should be converted.
    (set! m6 (grsp-matrix-te1 lm6 hm6))
    
    ;; Create idata.
    (set! idata (grsp-ann-idata-create 0 m6))
    
    (while (<= i6 hm6)

	   ;; Get row from conversion table.
	   (set! cd0 (array-ref conv i6 0))
	   (set! cd1 (array-ref conv i6 1))

	   (set! res2 (grsp-matrix-row-select "#=" odata 1 cd1))
	   (cond ((equal? (grsp-matrix-is-empty res2) #f)
		  (array-set! idata (array-ref odata cd1 3) i6 2)
		  (array-set! idata 0 i6 3)))
	   
	   ;; Set col 0 (id) of idata.

	   (set! i6 (in i6)))

    ;; Compose results.
    (set! res1 idata)
	  
    res1))


;;;; grsp-ann-get-matrix - Get matrix p_s1 from ann p_l1.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_l1: ann.
;;
;; Output:
;; - Matrix.
;;
(define (grsp-ann-get-matrix p_s1 p_l1)
  (let ((res1 '())
	(n1 0)
	(n2 0))

    ;; Find the number of elements in the list.
    (set! n2 (length p_l1))

    ;; Find the element number that corresponds to p_s1. Elements
    ;; within the ann should always follow the order stated below.
    (cond ((equal? p_s1 "nodes")
	   (set! n1 0))
	  ((equal? p_s1 "conns")
	   (set! n1 1))	  
	  ((equal? p_s1 "count")
	   (set! n1 2))
	  ((equal? p_s1 "specs")
	   (set! n1 3))	  
	  ((equal? p_s1 "idata")
	   (set! n1 4))
	  ((equal? p_s1 "odata")
	   (set! n1 5)))

    ;; n1 starts from 0. n2 is counted from 1.
    (cond ((< n1 n2)
	   (set! res1 (list-ref p_l1 n1))))
    
    res1))  

