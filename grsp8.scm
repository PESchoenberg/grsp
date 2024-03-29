;; =========================================================================
;;
;; grsp8.scm
;;
;; Neural networks and network functions in general.
;;
;; =========================================================================
;;
;; Copyright (C) 2018 - 2024 Pablo Edronkin (pablo.edronkin at yahoo.com)
;;
;;   This program is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU Lesser General Public License as
;;   published by the Free Software Foundation, either version 3 of the
;;   License, or (at your option) any later version.
;;
;;   This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;   GNU Lesser General Public License for more details.
;;
;;   You should have received a copy of the GNU Lesser General Public
;;   License along with this program. If not, see
;;   <https://www.gnu.org/licenses/>.
;;
;; =========================================================================


;;;; General notes:
;;
;; - Read sources for limitations on function parameters.
;;
;; - A grsp neural network is essentially a list of matrices that
;;   constitute a database in itself according to the developments of file
;;   grsp3. The format and structure of the matrices used in grsp8
;;   (contained in the list data structure just mentioned) is as follows:
;;
;;   - Elem 0: nodes. Matrix. Each row of this matrix contains data
;;     representing the properties and processes of a specific node of a
;;     neural network.
;;
;;     - Col 0: id.
;;     - Col 1: status.
;;
;;       - 0: dead.
;;       - 1: inactive.
;;       - 2: active.
;;
;;     - Col 2: type.
;;
;;       - 0: input.
;;       - 1: neuron.
;;       - 2: output.
;;
;;     - Col 3: layer.
;;     - Col 4: layer pos.
;;     - Col 5: bias.
;;     - Col 6: output value.
;;     - Col 7: associated function.
;;     - Col 8: evol.
;;     - Col 9: weight.
;;     - Col 10: iter.
;;
;;   - Elem 1: conns. Matrix. Each row contains data representing the
;;     properties and processes of a specific connection between nodes.
;;
;;     - Col 0: id.
;;     - Col 1: status.
;;
;;       - 0: dead.
;;       - 1: inactive.
;;       - 2: active.
;;
;;     - Col 2: type.
;;
;;       - 1: normal.
;;
;;     - Col 3: from.
;;     - Col 4: to.
;;     - Col 5: value.
;;     - Col 6: evol.
;;     - Col 7: weight.
;;     - Col 8: iter.
;;     - Col 9: to layer pos.
;;
;;   - Elem 2: count. Matrix. Each element of this table is a counter
;;     related to a specific ann aspect.
;;
;;     - Col 0: nodes id counter.
;;     - Col 1: conns id counter.
;;     - Col 2: epoch counter.
;;     - Col 3: layer counter.
;;
;;   - Elem 3: idata. Matrix. Contains an instance of input data. This is
;;     how the data should be passed to the network. Using this format it
;;     is possible to modify the number of nodes interactively if and when
;;     an evolving neural network is used. It is also possible to pass
;;     data interactively to the network that does not go directly to the
;;     input nodes but modifies the behavior of existing nodes.
;;
;;     - Col 0: id of the receptive node or connection.
;;     - Col 1: number that corresponds to the column in the nodes or conns
;;       matrix in which for the row whose col 0 is equal to the id value
;;       passed in col 0 of the idata matrix the input value will be
;;       stored.
;;     - Col 2: number.
;;     - Col 3: type, the kind of element that will receive this data.
;;       This means
;;       that based on any given idata row, a row in nodes or conns
;;       matrices will be updated.
;;
;;       - 0: for node.
;;       - 1: for connection.
;;
;;     - Col 4: control.
;;
;;       - 0: default.
;;       - 1: epoch end.
;;       - 2: delete node or conn.
;;
;;   - Elem 4: odata. Matrix. Contains am instance of data originated in
;;     the output nodes of a neural network. I.e. this matrix contains the
;;     results of a network epoch.
;;
;;     - Col 0: id of each output node.
;;     - Col 1: layer.
;;     - Col 2: layer pos.
;;     - Col 3: number (result).
;;     - Col 4: control.
;;
;;       - 0: default.
;;       - 1: epoch end.
;;       - 2: delete.
;;
;;   - Elem 5: specs. Matrix. Each row contains specifications for a neural
;;     network layer. This is a recipe for ann construction.
;;
;;     - Col 0: layer number.
;;     - Col 1: number of nodes for present layer.
;;     - Col 2: type of node.
;;
;;       - 0: input.
;;       - 1: neuron.
;;       - 2: output.
;;
;;     - Col 3: activation function.
;;
;;   - Elem 6: odtid. Matrix. Establishes a correlation between the data
;;     found on each epoch n on the output nodes of a neural network and
;;     the input data that will be found on the input nodes during epoch
;;     (+ n 1), in the case that the network works by means of a feedback
;;     loop.
;;
;;     - Col 0: input idata layer pos (pos input).
;;     - Col 1: output odata layer pos (pos output).
;;
;;   - Elem 7: datai. Contains data that should be passed to the input
;;     stream (idata), coming from either the output stream (odata) or
;;     from a dataset.
;;
;;     - Col 0: id of the receptive node.
;;     - Col 1: number that corresponds to the column in the nodes matrix in
;;       which for the row whose col 0 is equal to the id value passed in
;;       col 0 of the idata matrix the input value will be stored.
;;     - Col 2: number; value to be passed.
;;     - Col 3: type, the kind of element that will receive this data.
;;
;;       - 0: for node.
;;       - 1: for connection.
;;
;;     - Col 4: record control.
;;
;;       - 0: default.
;;       - 1: epoch end.
;;
;;     - Col 5: classifier.
;;
;;       - 0: regular data.
;;       - 1: training data.
;;       - 2: control data.
;;
;;   - Elem 8: datao. Obtained values from each iteration or forward feed
;;     of the network.
;;
;;     - Col 0: id of each output node.
;;     - Col 1: layer.
;;     - Col 2: layer pos.
;;     - Col 3: number (obtained result).
;;     - Col 4: record control.
;;
;;       - 0: default.
;;       - 1: epoch end.
;;
;;     - Col 5: classifier.
;;
;;       - 0: regular data.
;;       - 1: training data.
;;       - 2: control data.
;;
;;   - Elem 9: datae. Expected and delta values. Expected values must be
;;     provided along input training data in order to train the newtwork.
;;
;;     - Col 0: number (expected result).
;;     - Col 1: number (obtained result).
;;     - Col 2: delta.
;;
;; Sources:
;;
;; See code of functions used and their respective source files for more
;; credits and references.
;;
;; - [1] En.wikipedia.org. 2021. Artificial Neural Network. [online]
;;   Available at: https://en.wikipedia.org/wiki/Artificial_neural_network
;;   [Accessed 25 January 2021].
;; - [2] En.wikipedia.org. 2021. Mathematics Of Artificial Neural Networks.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Mathematics_of_artificial_neural_networks
;;   [Accessed 25 January 2021].
;; - [3] En.wikipedia.org. 2021. Artificial Neuron. [online] Available at:
;;   https://en.wikipedia.org/wiki/Artificial_neuron [Accessed 25
;;   January 2021].
;; - [4] En.wikipedia.org. 2021. Perceptron. [online] Available at:
;;   https://en.wikipedia.org/wiki/Perceptron [Accessed 25 January 2021].
;; - [5] En.wikipedia.org. 2021. Activation function. [online] Available
;;   at: https://en.wikipedia.org/wiki/Activation_function [Accessed 28
;;   January 2021].  
;; - [6] Machine Learning From Scratch. 2021. Activation Functions
;;   Explained - GELU, SELU, ELU, ReLU and more. [online] Available at:
;;   https://mlfromscratch.com/activation-functions-explained [Accessed 28
;;   January 2021].
;; - [7] En.wikipedia.org. 2021. Evolutionary algorithm - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Evolutionary_algorithm
;;   [Accessed 29 September 2021].
;; - [8] En.wikipedia.org. 2021. Karger's algorithm - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Karger%27s_algorithm
;;   [Accessed 7 December 2021].
;; - [9] En.wikipedia.org. 2021. Las Vegas algorithm - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Las_Vegas_algorithm
;;   [Accessed 7 December 2021].
;; - [10] Es.wikipedia.org. 2022. Teoría de grafos - Wikipedia, la
;;   enciclopedia libre. [online] Available at:
;;   https://es.wikipedia.org/wiki/Teor%C3%ADa_de_grafos
;;   [Accessed 21 February 2022].
;; - [11] En.wikipedia.org. 2022. Network science - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Network_science
;;   [Accessed 21 February 2022].
;; - [12] En.wikipedia.org. 2022. Barabási–Albert model - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Barab%C3%A1si%E2%80%93Albert_model
;;   [Accessed 2 March 2022].
;; - [13] En.wikipedia.org. 2022. Link analysis - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Link_analysis
;;   [Accessed 2 March 2022].
;; - [16] En.wikipedia.org. 2022. Evolving network - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Evolving_network
;;   [Accessed 9 March 2022].
;; - [17] En.wikipedia.org. 2022. Integrated information theory -
;;   Wikipedia. [online] Available at:
;;   https://en.wikipedia.org/wiki/Integrated_information_theory
;;   [Accessed 20 September 2022].
;; - [18] Evolutionary acquisition of Neural Topologies. (2022a). Retrieved
;;   from
;;   https://en.wikipedia.org/wiki/Evolutionary_acquisition_of_neural_topologies 
;; - [19] Neuroevolution of augmenting topologies. (2023, March 20).
;;   https://en.wikipedia.org/wiki/Neuroevolution_of_augmenting_topologies 
;; - [20] Wikimedia Foundation. (2023b, April 17). Catastrophic
;;   interference. Wikipedia.
;;   https://en.wikipedia.org/wiki/Catastrophic_interference 
;; - [21] Wikimedia Foundation. (2022a, September 6). Online machine
;;   learning. Wikipedia.
;;   https://en.wikipedia.org/wiki/Online_machine_learning 
;; - [22] Wikimedia Foundation. (2022a, July 10). Propagación hacia atrás.
;;   Wikipedia.
;;   https://es.wikipedia.org/wiki/Propagaci%C3%B3n_hacia_atr%C3%A1s 


(define-module (grsp grsp8)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp4)
  #:use-module (grsp grsp5)
  #:use-module (grsp grsp9)
  #:use-module (grsp grsp10)
  #:use-module (grsp grsp11)
  #:use-module (ice-9 threads)  
  #:export (grsp-ann-net-create-000
	    grsp-ann-net-create-ffv
	    grsp-ann-net-miter-omth
	    grsp-ann-net-reconf
	    grsp-ann-net-preb
	    grsp-ann-counter-upd
	    grsp-ann-id-create
	    grsp-ann-item-create
	    grsp-ann-nodes-create
	    grsp-ann2dbc
	    grsp-dbc2ann
	    grsp-ann-net-create-ffn
	    grsp-ann-net-specs-ffn
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
	    grsp-ann-get-matrix
	    grsp-ann-matrix-create
	    grsp-ann-idata-atlorpn
	    grsp-ann-odata-atlorpn
	    grsp-ann-odtid-atlorpn
	    grsp-m2datai
	    grsp-ann-datai-update
	    grsp-datai2idata
	    grsp-ann-fdifm
	    grsp-ann-fdif
	    grsp-ann-updatem
	    grsp-nodes2odata
	    grsp-odata2datao
	    grsp-ann-net-size
	    grsp-ann-node-degree
	    grsp-ann-net-adegree
	    grsp-ann-net-density
	    grsp-ann-net-pdensity
	    grsp-ann-node-conns
	    grsp-ann-nodes-conns
	    grsp-ann-conn-nodes
	    grsp-ann-conns-nodes
	    grsp-ann-devt
	    grsp-ann-devn
	    grsp-ann-devc
	    grsp-ann-devcl
	    grsp-ann-devnc
	    grsp-ann-devnca
	    grsp-ann-stats
	    grsp-ann-display
	    grsp-ann-updater
	    grsp-ann-element-number
	    grsp-ann-get-element
	    grsp-ann-conns-opmm
	    grsp-ann-idata-bvw
	    grsp-ann-delta
	    grsp-ann-bp
	    grsp-m2datae
	    grsp-ds2ann
	    grsp-ann-ds-create
	    grsp-ann-nodes-select-linked
	    grsp-ann-nodes-select-layer
	    grsp-ann-nodes-select-st
	    grsp-ann-id-update
	    grsp-ann-node-info))


;;;; grsp-ann-net-create-000 - Creates an empty neural network as a list
;; data structure with basic, empty matrices as its elements.
;;
;; Keywords:
;;
;; - functions, ann, neural network, matrices, matrix, element, list,
;;   skeletal
;;
;; Parameters:
;;
;; - p_b1:
;;
;;   - #t: to return lists with one element with zeros as values.
;;   - #f: for empty lists.
;;
;; Output:
;;
;; - A list with ten elements, in this order.
;;
;;   - Elem 0: nodes, a matrix for the definition of nodes.
;;   - Elem 1: conns, a matrix for the definition of connections between
;;     those nodes.
;;   - Elem 2: count, a 1x4 counter matrix that defines the id of nodes amd
;;     conns elements, as well as the epoch and layer counters.
;;   - Elem 3: idata, a data input matrix. This is what goes into an ann.
;;   - Elem 4: odata, an output matrix. This is what comes out of the
;;     output nodes of the ann.
;;   - Elem 5: specs, a matrix that contains the structural specifications
;;     of an ann.
;;   - Elem 6: odtid, a matrix that provides feedback structure from odata
;;     to idata.
;;   - Elem 7; datai, results to be transfered to idata.
;;   - Elem 8: datao, obtained results.
;;   - Elem 9: datae, expected results, delta values.
;;
;; - In the case of active networs, these matrices will be filled with non-
;;   trivial data. In this case, only trivial data will be placed inside
;;   those matrices. This means that this fouction actually produces the
;;   structure of a neural network, but not a network per se.
;; - See grsp-ann-net-create-ffv in order to create a non-trivial or empty
;;   network.
;;
;; - For more details on thse matrices, see "Format of matrices used in
;;   grsp8" above.
;;
(define (grsp-ann-net-create-000 p_b1)
  (let ((res1 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)
	(datae 0))

    ;; Create matrices with just one row.
    (set! nodes (grsp-ann-matrix-create "nodes" 1))
    (set! conns (grsp-ann-matrix-create "conns" 1))
    (set! count (grsp-ann-matrix-create "count" 1))
    (set! idata (grsp-ann-matrix-create "idata" 1))
    (set! odata (grsp-ann-matrix-create "odata" 1))
    (set! specs (grsp-ann-matrix-create "specs" 1))
    (set! odtid (grsp-ann-matrix-create "odtid" 1))
    (set! datai (grsp-ann-matrix-create "datai" 1))
    (set! datao (grsp-ann-matrix-create "datao" 1))
    (set! datae (grsp-ann-matrix-create "datae" 1))
    
    ;; Rebuild the list and compose results.
    (cond ((equal? p_b1 #t)
	   (set! res1 (list nodes
			    conns
			    count
			    idata
			    odata
			    specs)))
	  (else (set! res1 (grsp-ann-net-preb nodes
					      conns
					      count
					      idata
					      odata
					      specs
					      odtid
					      datai
					      datao
					      datae))))
    
    res1))


;;;; grsp-ann-net-create-ffv - A convenience function that creates a
;; forward feed network of a variable number of layers and elements
;; contained in each layer.
;;
;; Keywords:
;;
;; - functions, ann, neural, network, ffn
;;
;; Parameters:
;;
;; - p_b1:
;;
;;   - #t if you want to return only the base ann list composed of matrices
;;     nodes, conns, count, idata, odata and empty specs.
;;   - #f if you want to return also the associated matrix created during
;;     the process as the sixth of the ann list, meaning that this option
;;     returns full matrices:
;;
;;     - Elem 0: nodes.
;;     - Elem 1: conns.
;;     - Elem 2: count.
;;     - Elem 3: idata.
;;     - Elem 4: odata.
;;     - Elem 5: specs.
;;     - Elem 6: odtid.
;;     - Elem 7: datai.
;;     - Elem 8: datao.
;;     - Elem 9: datae.
;;
;; - p_n2: number of mutation iterations desired.
;; - p_nl: number of nodes in layer 0.
;; - p_nm: number of intermediate layers.
;; - p_nn: number of nodes in intermediate layers.
;; - p_af: activation function for intermediate nodes.
;; - p_nh: number of nodes in final layer.
;;
;; Notes:
;;
;; - This function creates a network with all its associated values as
;;   defined by the arguments passed to it.
;; - See also grsp-ann-net-specs-ffn, grsp-ann-net-create-ffn and
;;   grsp-ann-net-mutate on how these functions operate.
;; - Mean and standard deviation for grsp-ann-net-mutate are 0.0 and 0.15
;;   respectively.
;; - See "Format of matrices used in grsp8" on top of this file for details
;;   on each matrix used.
;; - A standard distribution is used for grsp-ann-net-mutate also.
;; - Further configuration of the ann might have to be done after using
;;   this function to change parameters such as activation functions per
;;   node, weights, etc.
;; - A network created by this function might be used as si or it could be
;;   modified later by adding or deleting nodes, connections, etc.
;; - See grsp-ann-net-create-000 to create a trivial network.
;;
;; Examples:
;;
;; - example3.scm.
;;
;; Output:
;;
;; - A list with elements combining the results provided by:
;;
;;   - grsp-ann-net-specs-ffn.
;;   - grsp-ann-net-create-ffn.
;;   - grsp-ann-net-mutate.
;;
(define (grsp-ann-net-create-ffv p_b1 p_n2 p_nl p_nm p_nn p_af p_nh)
  (let ((res1 '())
	(specs 0)
	(odtid 0)
	(res3 0)
	(l1 '(5 9))
	(l3 '(5 7)))

    ;; Create the ann.
    (set! specs (grsp-ann-net-specs-ffn p_nl p_nm p_nn p_af p_nh))
    (set! res3 (grsp-ann-net-create-ffn specs))
    (set! odtid (grsp-ann-matrix-create "odtid" 1))
    
    ;; Mutate in order to randomize values as many tumes as defined by
    ;; parameter p_n2. In order not t mutate the network, set p_n2 = 0 so
    ;; that the following cycle gets ignored entirely.
    (let loop ((i1 1))
      (if (<= i1 p_n2)
	  (begin (set! res3 (grsp-ann-net-mutate res3
						 1
						 "#normal"
						 0.0
						 0.15
						 "#normal"
						 0.0
						 0.15
						 l1
						 l3))
		 (loop (+ i1 1)))))
    
    ;; Compose results depending on p_b1.
    (cond ((equal? p_b1 #f)	   
	   (set! res1 (list (grsp-ann-get-matrix "nodes" res3)
			    (grsp-ann-get-matrix "conns" res3)
			    (grsp-ann-get-matrix "count" res3)
			    (grsp-ann-get-matrix "idata" res3)
			    (grsp-ann-get-matrix "odata" res3)
			    specs
			    odtid
			    (grsp-ann-get-matrix "datai" res3)
			    (grsp-ann-get-matrix "datao" res3)
			    (grsp-ann-get-matrix "datae" res3))))
	  
	  (else (set! res1 res3)))

    ;; Update idata, odata and odtid tables.
    (set! res1 (grsp-ann-idata-atlorpn res1))
    (set! res1 (grsp-ann-odata-atlorpn res1))
    (set! res1 (grsp-ann-odtid-atlorpn res1))
    
    res1))


;;;; grsp-ann-net-reconf - Reconfigure a neural network.
;;
;; Keywords:
;;
;; - functions, ann, neural, network, config, configuration, adjust
;;
;; Parameters:
;;
;; - p_s1: reconfiguration method.
;;
;;   - "#no": none.
;;   - "#bp": backpropagation.
;;
;; - p_l1: ann (list).
;;
;; Notes:
;;
;; - TODO: according to (Open Assistant), these algorithms could be used
;;   for optimization: genetic algorithms, simulated annealing, particle
;;   swarm optimization, evolutionary computation, stochastic gradient
;;   descent, batch gradient descent, online gradient descent, and
;;   Adaboost. 
;;
;; Output:
;;
;; - List p_l1 updated.
;;
(define (grsp-ann-net-reconf p_s1 p_l1)
  (let ((res1 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))
	
    ;; Safety copy.
    (set! res1 p_l1)
       
    ;; Delete dead elements.
    (set! res1 (grsp-ann-deletes res1))

    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" res1))
    (set! conns (grsp-ann-get-matrix "conns" res1))
    (set! count (grsp-ann-get-matrix "count" res1))    
    (set! idata (grsp-ann-get-matrix "idata" res1))
    (set! odata (grsp-ann-get-matrix "odata" res1))
    (set! specs (grsp-ann-get-matrix "specs" res1))
    (set! odtid (grsp-ann-get-matrix "odtid" res1))
    (set! datai (grsp-ann-get-matrix "datai" res1))
    (set! datao (grsp-ann-get-matrix "datao" res1))
    (set! datae (grsp-ann-get-matrix "datae" res1))    

    ;; Callibrate.
    (cond ((equal? p_s1 "#bp")
	   (grsp-ann-bp res1)))

    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))
    
    res1))


;;;; grsp-ann-net-miter-omth - Perform evaluations of the network p_n1
;; times (epochs).
;;
;; Keywords:
;;
;; - functions, ann, neural, network, eval, epochal
;;
;; Parameters:
;;
;; - p_b3: #t for verbosity (iterator level).
;; - p_b2: #t for verbosity (nodes eval level).
;; - p_b4: #t for verbosity (node eval level).
;; - p_b1:
;;
;;   - #t: use mutithreading.
;;   - #f: do not use multithreading.
;;
;; - p_s1: reconfiguration method. See grsp-ann-net-reconf for details.
;; - p_l1: ann (list).
;; - p_n1: desired iterations per epoch.
;; - p_n2: mutation cycles desired after each iteration.
;;
;; Examples:
;;
;; - example3.scm, example26.scm.
;;
;; Output:
;;
;; - List p_l1 updated.
;;
(define (grsp-ann-net-miter-omth p_b3 p_b2 p_b4 p_b1 p_s1 p_l1 p_n1 p_n2)
  (let ((res1 '())
	(b1 #f)
	(idata 0)
	(s1 (strings-append (list "\n" (gconsts "En")) 0))
	(s2 (strings-append (list "\n" (gconsts "Mi")) 0))
	(s3 (strings-append (list "\n" (gconsts "Isoe")) 0))
	(i1 0)
	(i2 0))

    (set! res1 p_l1)

    ;; Eval loop, go for p_n1 epochs.
    (while (< i1 p_n1)

	   ;; If verbosity is on, present iteration data.
	   (cond ((equal? p_b3 #t)
		  (display s1)
		  (display i1)
		  (display "\n")))

	   ;; Mutate ann if required.
	   (set! i2 0)
	   (while (< i2 p_n2)

		  ;; If verbosity is on, present mutation data.
		  (cond ((equal? p_b3 #t)
			 (display s2)
			 (display i2)
			 (display "\n")))
		  
		  (set! res1 (grsp-ann-net-nmutate-omth p_b1 res1))
		  (set! i2 (in i2)))
	   
	   ;; Pass idata info. This means that new idata rows might be
	   ;; added to the said matrix and eventually passed to the neural
	   ;; network on each new iteration.
	   (set! idata (grsp-ann-get-matrix "idata" res1))

	   ;; If verbosity is on, present epoch data.
	   (cond ((equal? p_b3 #t)
		  (display s3)
		  (display "\n\n")
		  (grsp-matrix-display idata)
		  (display "\n")))
	   
	   (set! b1 (grsp-matrix-is-empty idata))
	   (cond ((equal? b1 #f)
		  (set! res1 (grsp-ann-idata-update #t res1))))
	   
	   ;; Evaluate nodes.
	   (set! res1 (grsp-ann-nodes-eval p_b2 p_b4 res1))
	   
	   ;; Reconfigure ann.
	   (set! res1 (grsp-ann-net-reconf p_s1 res1))
	   
	   (set! i1 (in i1)))

    res1))


;;;; grsp-ann-net-preb - Purges and rebuilds the net from discarded
;; connections and nodes. While the network can survive and remain useful
;; even if its entropy increases, purging it should be done in order to
;; keep it to its minimum possible size for efficiency reasons.
;;
;; Keywords:
;;
;; - functions, ann, neural, network, clean, simplify, cut, renew
;;
;; Parameters:
;;
;; - p_a1: nodes.
;; - p_a2: conns.
;; - p_a3: countx.
;; - p_a4: idata.
;; - p_a5: odata.
;; - p_a6: specs.
;; - p_a7: odtid.
;; - p_a8: datai.
;; - p_a9: datao.
;; - p_a10: datae.
;;
;; Notes:
;;
;; - In this case, matrices must be passed as separate parameters, not as
;;   a list of matrices like in most grsp8 functions.
;; - See "Format of matrices used in grsp8" on top of this file for details
;;   on each matrix used.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-ann-net-preb p_a1 p_a2 p_a3 p_a4 p_a5 p_a6 p_a7 p_a8 p_a9 p_a10)
  (let ((res1 '())
	(s1 "#="))

    ;; Delete rows where the value of col 1 is zero, meaning that
    ;; connections and nodes are dead.	  
    (set! p_a2 (grsp-matrix-row-delete s1 p_a2 1 0))
    (set! p_a1 (grsp-matrix-row-delete s1 p_a1 1 0))
    
    ;; Compose results.
    (set! res1 (list p_a1 p_a2 p_a3 p_a4 p_a5 p_a6 p_a7 p_a8 p_a9 p_a10))

    res1))


;;;; grsp-ann-counter-upd - Updates the ann id and epoch counters.
;;
;; Keywords:
;;
;; - functions, ann, neural, network, counting, count
;;
;; Parameters:
;;
;; - p_a3: count matrix.
;; - p_n1: matrix element to increment.
;;
;;   - 0: updates nodes counter.
;;   - 1: updates conns counter.
;;   - 2: updates epoch counter.
;;   - 3: updates layer counter.
;;
;; Notes:
;;
;; - See "Format of matrices used in grsp8" on top of this file for details
;;   on each matrix used.
;;
;; Output:
;;
;; - Numeric. Returns a new id number, either for nodes, conns, epoch or
;;   layer number.
;;
(define (grsp-ann-counter-upd p_a3 p_n1)
  (let ((res1 0))

    (set! res1 (+ (array-ref p_a3 0 p_n1) 1))
    (array-set! p_a3 res1 0 p_n1)

    res1))


;;;; grsp-ann-id-create - Creates a new id number for a row in nodes or
;; conns and updates the corresponding matrix element.
;;
;; Keywords:
;;
;; - functions, ann, neural, network, primary, key
;;
;; Parameters:
;;
;; - p_a1: nodes.
;; - p_a2: conns.
;; - p_a3: count.
;; - p_n1: 
;;
;;   - 0: new id for nodes.
;;   - 1: new id for conns.
;;
;; Notes:
;;
;; - See "Format of matrices used in grsp8" on top of this file for details
;;   on each matrix used.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-ann-id-create p_a1 p_a3 p_n1)
  (let ((res1 p_a1)
	(hm1 1))

    ;; Extract the boundaries of the matrix.
    (set! hm1 (grsp-matrix-esi 2 res1))
    
    (array-set! res1 (grsp-ann-counter-upd p_a3 p_n1) hm1 0)
   
    res1))


;;;; grsp-ann-item-create - Creates in the ann a node or connection with
;; parameter list p_l2.
;;
;; Keywords:
;;
;; - functions, ann, neural, network, connections, edges, links
;;
;; Parameters:
;;
;; - p_a1: nodes matrix.
;; - p_a2: conns matrix.
;; - p_a3: count matrix.
;; - p_n1:
;;
;;   - 0: for nodes.
;;   - 1: for conns.
;;
;; - p_l2: list containing the values for the matrix row.
;;
;; Notes:
;;
;; - See "Format of matrices used in grsp8" on top of this file for details
;;   on each matrix used.
;;
;; Output:
;;
;; - Matrix.
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


;;;; grsp-ann-nodes-create - Creates node p_l2 connected according to p_l3
;; in ann p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network, update, add
;;
;; Parameters:
;;
;; - p_l1: list, ann.
;; - p_l2: list, node definition.
;; - p_l3: list of connections for p_l1.
;;
;; Notes:
;;
;; - See "Format of matrices used in grsp8" on top of this file for details
;;   on each matrix used.
;;
;; Output:
;;
;; - List. Updated ann.
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
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0)
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
    (set! specs (grsp-ann-get-matrix "specs" p_l1))
    (set! odtid (grsp-ann-get-matrix "odtid" p_l1))
    (set! datai (grsp-ann-get-matrix "datai" p_l1))
    (set! datao (grsp-ann-get-matrix "datao" p_l1))
    (set! datae (grsp-ann-get-matrix "datae" p_l1))    
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
	   
	   ;; Create connections. There might be several connections per
	   ;; node in p_l3 each list element is in itself a list
	   ;; representing one connection.
	   (set! hn (length p_l3))
	   (while (< i1 hn)

		  ;; Update connection count in counter and l3.
		  (set! l3 (list-ref p_l3 i1))
		  (set! cc (array-ref count 0 1))	  

		  ;; Update id and to values in the list corresponding to
		  ;; the connection to be created.
		  (list-set! l3 0 cn)
		  (list-set! l3 4 cc)
		  (set! conns (grsp-ann-item-create nodes
						    conns
						    count
						    1
						    l3))
		  
		  (set! i1 (in i1)))))
    
    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))
    
    res1))


;;;; grsp-ann2dbc - Saves a neural network to a csv database.
;;
;; Keywords:
;;
;; - functions, ann, neural, network, comma, separated, csv
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_l1: ann.
;;
;; Output:
;;
;; - Gatabase. The ann will be saved to csv files stored in a folder
;;   called  p_d1.
;;
(define (grsp-ann2dbc p_d1 p_l1)
  (let ((res1 0)
	(l1 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))

    (set! l1 p_l1)
    
    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" l1))
    (set! conns (grsp-ann-get-matrix "conns" l1))
    (set! count (grsp-ann-get-matrix "count" l1))
    (set! idata (grsp-ann-get-matrix "idata" l1))
    (set! odata (grsp-ann-get-matrix "odata" l1))
    (set! specs (grsp-ann-get-matrix "specs" l1))
    (set! odtid (grsp-ann-get-matrix "odtid" l1))
    (set! datai (grsp-ann-get-matrix "datai" l1))
    (set! datao (grsp-ann-get-matrix "datao" l1))
    (set! datae (grsp-ann-get-matrix "datae" l1))     

    ;; Save to database.
    (grsp-mc2dbc-csv p_d1 nodes "nodes.csv")
    (grsp-mc2dbc-csv p_d1 conns "conns.csv")
    (grsp-mc2dbc-csv p_d1 count "count.csv")
    (grsp-mc2dbc-csv p_d1 idata "idata.csv")
    (grsp-mc2dbc-csv p_d1 odata "odata.csv")
    (grsp-mc2dbc-csv p_d1 specs "specs.csv")
    (grsp-mc2dbc-csv p_d1 odtid "odtid.csv")
    (grsp-mc2dbc-csv p_d1 datai "datai.csv")
    (grsp-mc2dbc-csv p_d1 datao "datao.csv")
    (grsp-mc2dbc-csv p_d1 datae "datae.csv")))    
    

;;;; grsp-dbc2ann - Retrieves ann from a csv database.
;;
;; Keywords:
;;
;; - functions, ann, neural, network, cooma, separated, csv
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_l1: ann.
;;
;; Output:
;;
;; - The csv files from folder p_d1 will be extracted into a list.
;;
(define (grsp-dbc2ann p_d1)
  (let ((res1 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)	
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))

    (set! nodes (grsp-dbc2mc-csv p_d1 "nodes.csv"))
    (set! conns (grsp-dbc2mc-csv p_d1 "conns.csv"))
    (set! count (grsp-dbc2mc-csv p_d1 "count.csv"))
    (set! idata (grsp-dbc2mc-csv p_d1 "idata.csv"))
    (set! odata (grsp-dbc2mc-csv p_d1 "odata.csv"))
    (set! specs (grsp-dbc2mc-csv p_d1 "specs.csv"))
    (set! odtid (grsp-dbc2mc-csv p_d1 "odtid.csv"))    
    (set! datai (grsp-dbc2mc-csv p_d1 "datai.csv"))
    (set! datao (grsp-dbc2mc-csv p_d1 "datao.csv"))
    (set! datae (grsp-dbc2mc-csv p_d1 "datae.csv"))    
    
    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))
    
    res1))


;;;; grsp-ann-net-create-ffn - Creates ann by matrix data. Each row of the
;; matrix should contain data for the creation of one layer of the ann.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_a1: specs matrix:
;;
;; Notes:
;;
;; - See "Format of matrices used in grsp8" on top of this file for
;;   details on each matrix used.
;; - See also grsp-ann-net-specs-ffn.
;;
;; Output:
;;
;; - List; ann with its component matrices.
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
	(w1 1)
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
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))

    ;; Safe copy of argument matrix.
    (set! res2 (grsp-matrix-cpy p_a1))

    ;; Create matrices with just one row.
    (set! nodes (grsp-ann-matrix-create "nodes" 1))
    (set! conns (grsp-ann-matrix-create "conns" 1))
    (set! count (grsp-matrix-create -1 1 4))
    (set! idata (grsp-ann-matrix-create "idata" 1))
    (set! odata (grsp-ann-matrix-create "odata" 1))
    (set! specs (grsp-ann-matrix-create "specs" 1))
    (set! odtid (grsp-ann-matrix-create "odtid" 1))
    (set! datai (grsp-ann-matrix-create "datai" 1))
    (set! datao (grsp-ann-matrix-create "datao" 1))
    (set! datae (grsp-ann-matrix-create "datae" 1))    
    
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
	   
	   ;; Per each row of res2, repeat this cycle as many times as
	   ;; nodes per layer are required. Bias set to 1 (elem 5 on l1).
	   (set! i2 0)
	   (while (< i2 a1)

		  (cond ((= a2 0) ; Input node.
			 (set! l1 (list c0 n1 0 a0 i2 1 0 a3 0 w1 i2))
			 (set! nodes (grsp-ann-item-create nodes
							   conns
							   count
							   0
							   l1)))
			((= a2 1) ; Neuron.
			 (set! l1 (list c0 n1 1 a0 i2 1 0 a3 0 w1 i2))
			 (set! nodes (grsp-ann-item-create nodes
							   conns
							   count
							   0
							   l1)))
			((= a2 2) ; Output node.
			 (set! l1 (list c0 n1 2 a0 i2 1 0 a3 0 w1 i2))
			 (set! nodes (grsp-ann-item-create nodes
							   conns
							   count
							   0
							   l1))))
		   
		   (set! c0 (array-ref count 0 0))
		   
		   (set! i2 (in i2)))
	   
	   (set! i1 (in i1)))

    ;; Purge nodes table; this is necessary since on creation a single
    ;; row is added with all elements set on zero. Normally this would
    ;; not mean trouble and such tables can be purged later, but in this
    ;; case we need to do so because otherwise creation of connections
    ;; from nodes of the first layer could cause trouble.
    (set! nodes (grsp-matrix-row-delete "#=" nodes 1 0))
    
    ;; Create connections (connect every node of a layer to all nodes of
    ;; the prior layer). Repeat for every layer.
    (set! res4 (grsp-matrix-cpy nodes))
    (set! res4 (grsp-matrix-row-sort "#des" res4 3))
    (while (equal? b1 #t)

	   (set! y1 (array-ref res4 0 3))

	   ;; If the layer number is zero, it means that we are dealing
	   ;; with the initial one and hence, no connections going to
	   ;; this layer will be created. Othewise, every node of the
	   ;; layer will be connected to every node of the prior layer.
	   (cond ((> y1 0)
		  
		  ;; Separate the corrent res4 into two parts:
		  ;;
		  ;; - One will contain the rows (nodes) whose column 3
		  ;;   (layer) equals y1. This will be table res3.
		  ;; - The second part contains everything else. That is,
		  ;;   given the row sort and selectc ops performed,
		  ;;   res4 from now on will contain what would be
		  ;;   processed in the next iteration, excluding what
		  ;;   will be processed on this one.
		  (set! l2 (grsp-matrix-row-selectc "#=" res4 3 y1))
		  (set! res3 (list-ref l2 0))
		  (set! res4 (list-ref l2 1))
		  
		  ;; Get the layer numbers from the first rows of the
		  ;; target layer matrix (res3) as well as from the
		  ;; remainder matrix which represents the layer number
		  ;; of the origin layer (the layer with the layer
		  ;; number immediately lower than the number of the
		  ;; target layer.
		  (set! y3 (array-ref res3 0 3))
		  (set! y4 (array-ref res4 0 3))

		  ;; Select all rows from the origin layer.
		  (set! res5 (grsp-matrix-row-select "#=" res4 3 y4))
		  (set! y5 (array-ref res5 0 3))
		  
		  ;; Extract the boundaries of res3 (target layer); it
		  ;; contains only rows corresponding to nodes of the
		  ;; target layer.
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
		  ;;
		  ;; - res3 has the nodes of the target layer.
		  ;; - res4 has all the nodes of the ann except those of
		  ;;   the target layer.
		  ;; - res5 has the nodes of the origin layer.
		  ;;
		  ;; Now we cycle over the target layer, and for each
		  ;; node we will create connections coming from each
		  ;; node of the origin layer.
		  (set! i3 lm3)
		  (while (<= i3 hm3)

			 (set! t0 (array-ref res3 i3 0)) ;; Node id.
			 (set! t3 (array-ref res3 i3 3)) ;; Layer.
			 (set! t4 (array-ref res3 i3 4)) ;; Layer pos.
			 
			 ;; Cycle over the prior layer.
			 (set! i5 lm5)
			 (while (<= i5 hm5)

				(set! o0 (array-ref res5 i5 0)) ;; Node.
				(set! o3 (array-ref res5 i5 3)) ;; Layer.
				(set! o4 (array-ref res5 i5 4)) ;; L pos.
				(set! conns (grsp-ann-item-create nodes
								  conns
								  count
								  1
								  (list 0 2 1 o0 t0 0 0 0 0 t4)))
				
				(set! i5 (in i5)))
			 
			 (set! i3 (in i3))))
		 
		 (else (set! b1 #f))))
	    
    ;; Compose results.
    (set! res1 (grsp-ann-net-preb nodes
				  conns
				  count
				  idata
				  odata
				  specs
				  odtid
				  datai
				  datao
				  datae))
    
    res1))


;;;; grsp-ann-net-specs-ffn - Creates the specification matrix in order to
;; create a forward feed neural network.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_nl: number of nodes in layer 0.
;; - p_nm: number of intermediate layers.
;; - p_nn: number of nodes in intermediate layers.
;; - p_af: activation function for intermediate nodes.
;; - p_nh: number of nodes in final layer.
;;
;; Notes:
;;
;; - See "Format of matrices used in grsp8" on top of this file for
;;   details on each matrix used.
;; - See also grsp-ann-net-create-ffn.
;;
;; Output:
;;
;; - specs matrix.
;;
(define (grsp-ann-net-specs-ffn p_nl p_nm p_nn p_af p_nh)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(m1 0)  ; Number of rows.
	(n1 4)) ; Number of cols.

    ;; Calculate number of rows based on total number of ann layers. 
    (set! m1 (+ 2 p_nm))
    
    ;; Create empty matrix.
    (set! res1 (grsp-matrix-create 0 m1 n1))

    ;; Extract the boundaries of the matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))

    ;; Cycle.
    (let loop ((i1 lm1))
      (if (<= i1 hm1)
	  (begin (array-set! res1 i1 i1 0)
	   
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
		 (loop (+ i1 1)))))    
    
    res1))


;;;; grsp-ann-net-mutate - Mutates and randomizes ann p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l2: ann.
;; - p_n1: mutation rate, [0, 1].
;; - p_s1: type of distribution.
;;
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;;
;; - p_u1: mean for mutation rate.
;; - p_v1: standard deviation for mutation rate.
;; - p_s2: type of distribution.
;;
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;;
;; - p_u2: mean for element random value.
;; - p_v2: standard deviation for element random value.
;; - p_l1: list of elements (cols) of nodes to mutate. Usually values
;;   should be:
;;
;;   - 5: bias.
;;   - 9: weight.
;;
;; - p_l3: list of elements (cols) of conns to mutate. Usually values
;;   should be:
;;
;;   - 5: value.
;;   - 7: weight.
;;
;; Notes:
;;
;; - See grsp-matrix-col-lmutation.
;; - You can mutate any element that corresponds to the ann, passed via 
;;   parameters p_l1 and p_l3 but be careful, since modifying random
;;   elements other than those mentioned above could yield unexpected
;;   results
;; - See "Format of matrices used in grsp8" on top of this file for
;;   details
;;   on each matrix used.
;;
;; Output:
;;
;; - List.
;;
;; Sources:
;;
;; - [16].
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
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))

    (set! l2 p_l2)
    
    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" l2))
    (set! conns (grsp-ann-get-matrix "conns" l2))
    (set! count (grsp-ann-get-matrix "count" l2))
    (set! idata (grsp-ann-get-matrix "idata" l2))
    (set! odata (grsp-ann-get-matrix "odata" l2))
    (set! specs (grsp-ann-get-matrix "specs" l2))
    (set! odtid (grsp-ann-get-matrix "odtid" l2))    
    (set! datai (grsp-ann-get-matrix "datai" l2))
    (set! datao (grsp-ann-get-matrix "datao" l2))
    (set! datae (grsp-ann-get-matrix "datae" l2))    
    
    ;; Mutate nodes.
    (set! l1 p_l1)
    (set! nodes (grsp-matrix-col-lmutation nodes
					   p_n1
					   p_s1
					   p_u1
					   p_v1
					   p_s2
					   p_u2
					   p_v2
					   l1))

    ;; Mutate conns.
    (set! l3 p_l3)
    (set! conns (grsp-matrix-col-lmutation conns
					   p_n1
					   p_s1
					   p_u1
					   p_v1
					   p_s2
					   p_u2
					   p_v2
					   l3))

    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))

    res1))


;;;; grsp-ann-net-mutate-mth - Multithreaded variant of grsp-ann-net-
;; mutate. Mutate and randomize ann p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l2: ann.
;; - p_n1: mutation rate, [0, 1].
;; - p_s1: type of distribution.
;;
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;;
;; - p_u1: mean for mutation rate.
;; - p_v1: standard deviation for mutation rate.
;; - p_s2: type of distribution.
;;
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;;
;; - p_u2: mean for element random value.
;; - p_v2: standard deviation for element random value.
;; - p_l1: list of elements (cols) of nodes to mutate. Usually values
;;   should be:
;;
;;   - 5: bias.
;;   - 9: weight.
;;
;; - p_l3: list of elements (cols) of conns to mutate. Usually values
;;   should be:
;;
;;   - 5: value.
;;   - 7: weight.
;;
;; Notes:
;;
;; - See grsp-matrix-col-lmutation.
;; - You can mutate any element of a neural network passed via parameters
;;   p_l1 and p_l3 but be careful, since modifying randomly elements
;;   other than those mentioned above could yield unexpected results,
;;   even altering the structure of the network iteslf or render it
;;   unusable. Always backup your
;;   ANN before toying with this function.
;; - See "Format of matrices used in grsp8" on top of this file for
;;   details on each matrix used.
;;
;; Output:
;;
;; - List.
;;
;; Sources:
;;
;; - [16].
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
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))

    (set! l2 p_l2)
    
    ;; Extract matrices and lists.
    (parallel (set! nodes (grsp-ann-get-matrix "nodes" l2))
	      (set! conns (grsp-ann-get-matrix "conns" l2))
	      (set! count (grsp-ann-get-matrix "count" l2))
	      (set! idata (grsp-ann-get-matrix "idata" l2))
	      (set! odata (grsp-ann-get-matrix "odata" l2))
	      (set! specs (grsp-ann-get-matrix "specs" l2))
	      (set! odtid (grsp-ann-get-matrix "odtid" l2))    
	      (set! datai (grsp-ann-get-matrix "datai" l2))
	      (set! datao (grsp-ann-get-matrix "datao" l2))
	      (set! datae (grsp-ann-get-matrix "datae" l2)))	      
    
    (parallel ((set! l1 p_l1)
	       (set! nodes (grsp-matrix-col-lmutation nodes
						      p_n1
						      p_s1
						      p_u1
						      p_v1
						      p_s2
						      p_u2
						      p_v2
						      l1)))
	      ((set! l3 p_l3)
	       (set! conns (grsp-matrix-col-lmutation conns
						      p_n1
						      p_s1
						      p_u1
						      p_v1
						      p_s2
						      p_u2
						      p_v2
						      l3))))

    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))
    
    res1))


;;;; grsp-ann-deletes - Deletes from ann p_l1 all elements with status
;; (col 1) equal to zero.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: list, ann.
;;
;; Notes:
;;
;; - This function is agnostic regarding connections and how they depend
;;   from nodes, meaning that in ordenr not to leave orphaned connectins
;;   once dead nodes have been deleted, the status of the dependent
;;   nodes should be set to zero before using this function.
;; - By setting row 1 to 0 at will and applying this function you can
;;   essentially delete any component of a neural network, following any
;;   schedule.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-ann-deletes p_l1)
  (let ((res1 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))

    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))
    (set! specs (grsp-ann-get-matrix "specs" p_l1))
    (set! odtid (grsp-ann-get-matrix "odtid" p_l1))
    (set! datai (grsp-ann-get-matrix "datai" p_l1))
    (set! datao (grsp-ann-get-matrix "datao" p_l1))
    (set! datae (grsp-ann-get-matrix "datae" p_l1))    
    
    (set! nodes (grsp-matrix-row-delete "#=" nodes 1 0))
    (set! conns (grsp-matrix-row-delete "#=" conns 1 0))

    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))

    res1))


;;;; grsp-ann-row-updatei - Updates col p_j2 with value p_n2 of element
;; with id p_id of table p_a1 (nodes or conns).
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_a1: matrix (nodes or conns).
;; - p_id: id (col 0).
;; - p_j2: column.
;; - p_n2: value.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-ann-row-updatei p_a1 p_id p_j2 p_n2)
  (let ((res1 0))

    (set! p_a1 (grsp-matrix-row-update "#=" p_a1 0 p_id p_j2 p_n2))

    (set! res1 p_a1)
    
    res1))


;;;; grsp-ann-conns-of-node - Finds the connections that reach or go out
;; from node with id p_id according to p_s1 in p_a1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_s1: type of connection:
;;
;;   - "#fr": those going out of node p_id.
;;   - "#to": those reaching node p_id.
;;
;; - p_a1: matrix (conns).
;; - p_id: node id.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-ann-conns-of-node p_s1 p_a1 p_id)
  (let ((res1 0)
	(j1 3))

    (cond ((equal? p_s1 "#to")
	   (set! j1 4)))
	  
    (set! res1 (grsp-matrix-row-select "#=" p_a1 j1 p_id))
    
    res1))


;;;; grsp-ann-node-eval - Evaluates node p_id and its related
;; connections. It reads the input connections, applies the specified
;; activation function and exports the result to the output connections.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_b3:
;;
;;   - #t for verbosity.
;;   - #f otherwise.
;;
;; - p_id: node id.
;; - p_a1: matrix (nodes).
;; - p_a2: matrix (conns).
;; - p_a3: matrix (count).
;;
;; Notes:
;;
;; -  Keep in mind TL0 and TL1 while using this function.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-ann-node-eval p_b3 p_id p_a1 p_a2 p_a3)
  (let ((res1 '())
	(a1 0)
	(a2 0)
	(a3 0)
	(a11 0)
	(a21 0)
	(a22 0)
	(b1 #f)
	(b2 #f)
	(i2 0)
	(id 0)
	(idf 0)
	(l1 '())
	(n5 0)
	(n6 0)
	(n7 0)
	(n9 0)
	(m5 0))

    ;; Safety copies.
    (set! a1 (grsp-matrix-cpy p_a1))
    (set! a2 (grsp-matrix-cpy p_a2))
    (set! a3 (grsp-matrix-cpy p_a3))
    (set! id p_id)
    
    ;; First check if the node exists.
    ;;
    ;; - If it does exist, then evaluate.
    ;; - If it does not exist then kill any leftover connection (set
    ;;   status to zero).
    ;;
    (set! a11 (grsp-matrix-row-select "#=" a1 0 id))
    (set! b1 (grsp-matrix-is-empty a11))

    ;; If verbosity is on present node data.
    (cond ((equal? p_b3 #t)
	   (display (strings-append (list "\n +++ 1.1.1.1 "
					  (gconsts
					   "Nr")
					  "\n")
				    0))
	   (grsp-matrix-display a11)
	   (display "\n")))

    ;; If node exists, evaluate.
    (cond ((equal? b1 #f)

	   ;; If verbosity is on tell that the node will be evaluated.
	   (cond ((equal? p_b3 #t)
		  (display (strings-append (list "\n +++ 1.1.1.3 "
						 (gconsts "Ev")
						 "\n")
					   0))
		  (grsp-matrix-display a11)
		  (display "\n")))

	   ;; If the node has incoming connections then we need to
	   ;; process them first.
	   (set! a21 (grsp-ann-conns-of-node "#to" a2 id))
	   (set! b2 (grsp-matrix-is-empty a21))

	   ;; Show if verbosity is on.
	   (cond ((equal? p_b3 #t)
		  (display (strings-append (list "\n +++ 1.1.1.4 "
						 (gconsts "Ib")
						 "\n")
					   0))
		  (grsp-matrix-display a21)
		  (display "\n")
		  (display (strings-append (list "\n +++ 1.1.1.5 "
						 (gconsts "rrpp")
						 "\n")
					   0))
		  (grsp-matrix-display a11)
		  (display "\n")
		  (grsp-matrix-display a21)
		  (display "\n")))	   

	   ;; Summation of input data from TO connections. The resulting
	   ;; value is passed to the node being evaluated (represented
	   ;; by row matrix a11).
	   (cond ((equal? b2 #f)
		  (set! a11 (grsp-ann-conns-opmm "#+*" a11 a21))))

	   (cond ((equal? p_b3 #t)
		  (display (strings-append (list "\n +++ 1.1.1.5 "
						 (gconsts "rrop")
						 ".\n")
					   0))
		  (grsp-matrix-display a11)
		  (display "\n")
		  (grsp-matrix-display a21)		  
		  (display "\n")))

	   ;; Bias.
	   (set! n5 (array-ref a1 0 5))

	   ;; Associated function.
	   (set! n7 (array-ref a1 0 7))

	   ;; Weight (was elem 7).
	   (set! n9 (array-ref a1 0 9)) 
	   
	   ;; Set activation function input value.
	   (set! n6 (* (+ n6 n9) n5))

	   ;; Select activation function and calculate.
	   (set! l1 (list n6))
	   (set! m5 (grsp-ann-actifun n7 l1))

	   (cond ((equal? p_b3 #t)
		  (display (strings-append (list "\n +++ 1.1.1.6 "
						 (gconsts "Raf")
						 "\n")
					   0))
		  (display m5)
		  (display "\n")))

	   ;; Update a1 with a11. (find the row in a1 based on a11 id and
	   ;; replace the whole row in a1 with a11. 	   
	   (set! a1 (grsp-matrix-row-subrepf a1 a11 0 id))

	   ;; If the node has outgoing connections then we need to
	   ;; process them once the input summation has been done and
	   ;; the node value has been calculated.
	   (set! a22 (grsp-ann-conns-of-node "#from" a2 id))
	   (set! b2 (grsp-matrix-is-empty a22))

	   ;; Cycle thorough connections and update values (col 5) with
	   ;; the value coming from the node being evaluated (row 6 of
	   ;; a11).
	   (set! i2 (grsp-lm a2))
	   (while (<= i2 (grsp-hm a2))

		  ;; Find if the conn comes from the node being evaluated.
		  (set! idf (array-ref a2 i2 5))
		  (cond ((= idf id)
			 
			 ;; Set value col 5 from node col 6.
			 (array-set! a2 (array-ref a11 0 6) i2 5)))

		  (set! i2 (in i2)))

	   ;; These reports should show p_a1 and p_a2 with all updates.
	   (cond ((equal? p_b3 #t)
		  (display (strings-append (list "\n +++ 1.1.1.7 "
						 (gconsts "Afvpc"))
					   0))
		  (display id)
		  (display "\n")
		  (grsp-matrix-display a2)
		  (display (strings-append (list "\n\n +++ 1.1.1.9 "
						 (gconsts "Upa1")
						 "\n")
					   0))
		  (grsp-matrix-display a1)
		  (display "\n"))))
	  
	  ;; if Node dos not exist. 
	  ((equal? b1 #t) 
	    
	    (set! a2 (grsp-matrix-row-update "#=" a2 3 id 1 0))
	    (set! a2 (grsp-matrix-row-update "#=" a2 4 id 1 0))
	    
	    ;; If node does not exist and verbosity is on, tell that the
	    ;; node was not processed.	   
	    (cond ((equal? p_b3 #t)
		   (display (strings-append (list "\n +++ 1.1.1.2 "
						  (gconsts "Ndne")
						  "\n")
					    0))
		   (grsp-matrix-display a11)
		   (display "\n")))))

    ;; Compose results.    
    (cond ((equal? p_b3 #t)
	   (display (strings-append (list "\n +++ 1.1.1.11 "
					  (gconsts "Vpa2ae")
					  "\n")
				    0))
	   (grsp-matrix-display a2)
	   (display (strings-append (list "\n\n "
					  (gconsts "Fin")
					  "\n\n") 0))))
    
    (set! res1 (list a1 a2 a3))
    
    res1))


;;;; grsp-ann-actifun - Selects function p_n1 passing parameter p_n2.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_n1: activation function [0,17].
;;
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
;;
;; - p_l1: list of applicable input values. See grsp10.scm.
;;
;; Output:
;;
;; - Numeric.
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


;;;; grsp-ann-nodes-eval - Evaluates all nodes in ann p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network, eval, evaluation, epoch, iterate
;;
;; Parameters:
;;
;; - p_b3: #t for verbosity (nodes eval level).
;; - p_b2: #t for verbosity (node eval level).
;;
;; - p_l1: ann.
;;
;; Notes:
;;
;; - See "Format of matrices used in grsp8" on top of this file for
;;   details on each matrix used.
;; - Use grsp-ann-idata-update before this function to pass actual data
;;   to the ann.
;;
;; Output:
;;
;; - List. Updated ann.
;;
(define (grsp-ann-nodes-eval p_b3 p_b2 p_l1)
  (let ((res1 '())
	(res2 0)
	(res3 '())
	(id 0)
	(i1 0)
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))

    (set! res1 p_l1)   
    
    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" res1))
    (set! conns (grsp-ann-get-matrix "conns" res1))
    (set! count (grsp-ann-get-matrix "count" res1))
    (set! idata (grsp-ann-get-matrix "idata" res1))
    (set! odata (grsp-ann-get-matrix "odata" res1))
    (set! specs (grsp-ann-get-matrix "specs" res1))
    (set! odtid (grsp-ann-get-matrix "odtid" res1))
    (set! datai (grsp-ann-get-matrix "datai" res1))
    (set! datao (grsp-ann-get-matrix "datao" res1))
    (set! datae (grsp-ann-get-matrix "datae" res1))     
    
    ;; Sort nodes by layer number.
    (set! nodes (grsp-matrix-row-sort "#asc" nodes 3))
    
    ;; Evaluate nodes and their input and output connections.
    (cond ((equal? p_b3 #t)
	   (display (strings-append (list "\n + 1. "
					  (gconsts "Pro")
					  "\n")
				    0))
	   (display "\n")))
    
    (set! i1 (grsp-lm nodes))
    (while (<= i1 (grsp-hm nodes))
	   (set! id (array-ref nodes i1 0))

	   ;; nodes table comparison.
	   (cond ((equal? p_b3 #t)
		  (display (strings-append (list "\n ++ 1.1 "
						 (gconsts
						  "Node"))
					   0))
		  (display id)
		  (display "\n")
		  (display (strings-append (list "\n +++ 1.1.1 "
						 (gconsts "Bef"))
					   0))
		  (display "\n")
		  (grsp-matrix-display (grsp-matrix-row-selectrn nodes i1))
		  (display "\n")))

	   ;; Actual eval call.
	   (set! res3 (grsp-ann-node-eval p_b2 id nodes conns count))

	   ;; Update nodes.
	   (set! nodes (list-ref res3 0))
	   
	   (cond ((equal? p_b3 #t)
		  (display (strings-append (list "\n +++ 1.1.2 "
						 (gconsts "Aft"))
					   0))
		  (display "\n")
		  (grsp-matrix-display (grsp-matrix-row-selectrn nodes i1))
		  (display "\n")))
	   
	   ;; Eval of connections related to the node being processed.
	   (cond ((equal? p_b3 #t)
		  (display (strings-append (list "\n +++ 1.1.3 "
						 (gconsts "RTb"))
					   0))
		  (display "\n")
		  (grsp-matrix-display (grsp-matrix-row-select "#="
							       conns
							       4
							       id))
		  (display "\n")
		  (display (strings-append (list "\n +++ 1.1.4 "
						 (gconsts "RFb"))
					   0))
		  (display "\n")
		  (grsp-matrix-display (grsp-matrix-row-select "#="
							       conns
							       3
							       id))
		  (display "\n")))

	   ;; Update conns.
	   (set! conns (list-ref res3 1))
	   
	   (cond ((equal? p_b3 #t)
		  (display (strings-append (list "\n +++ 1.1.5 "
						 (gconsts "RTa"))
					   0))
		  (display "\n")
		  (grsp-matrix-display (grsp-matrix-row-select "#="
							       conns
							       4
							       id))
		  (display "\n")
		  (display (strings-append (list "\n +++ 1.1.6 "
						 (gconsts "RFa"))
					   0))
		  (display "\n")
		  (grsp-matrix-display (grsp-matrix-row-select "#="
							       conns
							       3
							       id))
		  (display "\n")))

	   ;; *** Test. Make conditional?
	   ;; Pass output to odata. 
	   (set! odata (grsp-nodes2odata nodes odata))

	   ;; Add newest odata to datao. This should produce an
	   ;; incremental datao table or matrix containing the results
	   ;; of each ann epoch.	   
	   (set! datao (grsp-odata2datao odata datao))
	   
	   (set! i1 (in i1)))
	   
    ;; Update counter.
    (grsp-ann-counter-upd count 2)   

    (cond ((equal? p_b3 #t)
	   (display (strings-append (list "\n" (gconst "Fin") "\n") 0))
	   (display "\n")))
    
    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))
    
    res1))    

    
;;;; grsp-ann-idata-create - Creates an empty idata matrix of p_m1 rows to
;; provide input for nodes and conns.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_s1: matrix type or element that will fill it initially.
;;
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
;;
;; - p_m1: number of rows.
;;
;; Notes:
;;
;; - See grsp-matrix-create fo detals on paramter p_s1. Some
;;   configurations might require a symmetric matrix (3 x 3) to work.
;; - Column 0 will be set to zero. You should set the values  of this col
;;   acording to the id of each node to be evaluated with the given data.
;; - You might have to modify the elements of columns 0 and 1 in order to
;;   provide useful values for different nodes.
;; - See "Format of matrices used in grsp8" on top of this file for
;;   details on each matrix used.
;; - See grsp0.grsp-random-state-set.
;;
;; Output:
;;
;; - Matrix. idata.
;;
(define (grsp-ann-idata-create p_s1 p_m1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-create p_s1 p_m1 4))
    (set! res1 (grsp-matrix-col-aupdate res1 0 0))
    (set! res1 (grsp-matrix-col-aupdate res1 1 5))
    (set! res1 (grsp-matrix-col-aupdate res1 1 6))
    (set! res1 (grsp-matrix-col-aupdate res1 3 0))
    
    res1))


;;;; grsp-ann-net-nmutate-omth - Safely mutates and randomizes ann p_l2
;; using a standard normal distribution.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_b1: select threading mode.
;;
;;   - #t: multi-threaded.
;;   - #f: single-threaded.
;;
;; - p_l2: ann.
;;
;; Output:
;;
;; - List.
;;
;; Sources:
;;
;; - [16].
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

    ;; Perform mutation.
    (cond ((equal? b1 #f)
	   (set! res1 (grsp-ann-net-mutate res1
					   0.5
					   "#normal"
					   0.0
					   0.15
					   "#normal"
					   0.0
					   0.15
					   l1
					   l3)))
	  ((equal? b1 #t)
	   (set! res1 (grsp-ann-net-mutate-mth res1
					       0.5
					       "#normal"
					       0.0
					       0.15
					       "#normal"
					       0.0
					       0.15
					       l1
					       l3))))

    res1))


;;;; grsp-ann-idata-update - Inputs data of idata into matrices nodes
;; and conns of ann p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: to replace idata matrix with a new one after passing rows.
;;   - #f: to keep idata as is after passing all rows to the ann.
;;
;; - p_l1: ann.
;;
;; Notes:
;;
;; - While normally idata would be used to pass data to input nodes, the
;;   matrix could be used to pass other values to the nodes matrix.
;; - Use this function before calling grsp-ann-nodes-eval in order to
;;   provide input data to the nn.
;; - See "Format of matrices used in grsp8" on top of this file for
;;   details on each matrix used.
;;
;; Output:
;;
;; - List. Updated ann p_l1.
;;
(define (grsp-ann-idata-update p_b1 p_l1)
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
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))

    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))    
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))
    (set! specs (grsp-ann-get-matrix "specs" p_l1))
    (set! odtid (grsp-ann-get-matrix "odtid" p_l1))
    (set! datai (grsp-ann-get-matrix "datai" p_l1))
    (set! datao (grsp-ann-get-matrix "datao" p_l1))
    (set! datae (grsp-ann-get-matrix "datae" p_l1))    
        
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
		  (set! nodes (grsp-matrix-row-update "#="
						      nodes
						      0
						      id
						      j2
						      n2)))
		 ((= n3 1)
		  (set! conns (grsp-matrix-row-update "#="
						      conns
						      0
						      id
						      j2
						      n2))))
	   
	   (set! i4 (in i4)))

    ;; Replace current idata with a brand new one in order to prevent
    ;; passing the same data twice to tbe ann.    
    (cond ((equal? p_b1 #t)
	   (set! idata (grsp-ann-idata-create 0 1))))
    
    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))
    
    res1))


;;;; grsp-ann-odata-update - Provides a current output data matrix for
;; ann p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Notes:
;;
;; - See "Format of matrices used in grsp8" on top of this file for
;; details on each matrix used.
;;
;; Output:
;;
;; - odata. An m x 4 matrix containing the data from the output nodes of
;; the neural network.
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


;;;; grsp-odata2idata - Provides feedback by transfer of data from from
;; odata to idata matrices. Transforms data from the output layer of an
;; ann into data for the input layer of the same or a different network.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_a5: odata.
;; - p_a6: odtid; data conversion table.
;;
;; Notes:
;;
;; - See "Format of matrices used in grsp8" on top of this file for
;;   details on each matrix used.
;; - The function delivers an idata table based on the odata pand
;;   conversion table provided.
;;
;; Output:
;;
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
	   
	   (set! i6 (in i6)))

    ;; Compose results.
    (set! res1 idata)
	  
    res1))


;;;; grsp-ann-get-matrix - Get matrix p_s1 from ann p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_s1: selected:
;;
;;   - "nodes".
;;   - "conns".
;;   - "count".
;;   - "idata".
;;   - "odata".
;;   - "specs".
;;   - "odtid".
;;   - "datai".
;;   - "datao".
;;   - "datae".
;;
;; - p_l1: ann.
;;
;; Examples:
;;
;; - example3.scm
;;
;; Notes:
;;
;; - See grsp-ann-get-element.
;;
;; Output:
;;
;; - One of the elements (matrix) of ann p_l1, as specified by p_s1.
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
	  ((equal? p_s1 "idata")
	   (set! n1 3))
	  ((equal? p_s1 "odata")
	   (set! n1 4))
	  ((equal? p_s1 "specs")
	   (set! n1 5))
	  ((equal? p_s1 "odtid")
	   (set! n1 6))    
	  ((equal? p_s1 "datai")
	   (set! n1 7))
	  ((equal? p_s1 "datao")
	   (set! n1 8))
	  ((equal? p_s1 "datae")
	   (set! n1 9)))	  
    
    ;; n1 starts from 0. n2 is counted from 1.
    (cond ((< n1 n2)
	   (set! res1 (list-ref p_l1 n1))))
    
    res1))  


;;;; grsp-ann-matrix-create - Creates a zero-filled matrix of type
;; p_s1 (for anns) with p_m1 rows.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_s1: matrix to create:
;;
;;   - "nodes".
;;   - "conns".
;;   - "count".
;;   - "idata".
;;   - "odata".
;;   - "specs".
;;   - "odtid".
;;   - "datai".
;;   - "datao".
;;   - "datae".
;;
;; - p_m1: number of rows.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-ann-matrix-create p_s1 p_m1)
  (let ((res1 '())
	(n1 1))

    (cond ((equal? p_s1 "nodes")
	   (set! n1 11))
	  ((equal? p_s1 "conns")
	   (set! n1 10))	  
	  ((equal? p_s1 "count")
	   (set! n1 4)) 
	  ((equal? p_s1 "idata")
	   (set! n1 5))
	  ((equal? p_s1 "odata")
	   (set! n1 5))
	  ((equal? p_s1 "specs")
	   (set! n1 4))
	  ((equal? p_s1 "odtid")
	   (set! n1 2))
	  ((equal? p_s1 "datai")
	   (set! n1 6))
	  ((equal? p_s1 "datao")
	   (set! n1 6))
	  ((equal? p_s1 "datae")
	   (set! n1 3)))	  

    (set! res1 (grsp-matrix-create 0 p_m1 n1))    
    
    res1))


;;;; grsp-ann-idata-atlorpn - Basic data for all input nodes. Provides an
;; idata table that contains at least one row per input node.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-ann-idata-atlorpn p_l1)
  (let ((res1 '())
	(res2 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(hm3 0)
	(lm4 0)
	(hm4 0)
	(m3 0)
	(m4 0)
	(i2 0)
	(j2 0)
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))

    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))    
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))
    (set! specs (grsp-ann-get-matrix "specs" p_l1))
    (set! odtid (grsp-ann-get-matrix "odtid" p_l1))
    (set! datai (grsp-ann-get-matrix "datai" p_l1))
    (set! datao (grsp-ann-get-matrix "datao" p_l1))
    (set! datae (grsp-ann-get-matrix "datae" p_l1))     

    ;; Create safety matrix. 
    (set! res2 (grsp-matrix-cpy nodes))
    
    ;; Make a row in idata per input in nodes.
    (set! res2 (grsp-matrix-row-select "#=" res2 2 0))

    ;; Extract boundaries of the selected rows.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))

    (set! lm4 (grsp-matrix-esi 1 idata))
    (set! hm4 (grsp-matrix-esi 2 idata))
    (set! m4 (- hm4 lm4))
    
    ;; Cycle.
    (set! i2 lm2)
    (while (<= i2 hm2)

	   ;; Create new row.
	   (set! hm3 (grsp-matrix-esi 2 idata))
	   (set! m3 (+ hm3 1))
	   (set! idata (grsp-matrix-row-subrepal idata m3 (list 0 0 0 0)))

	   ;; Fill data.
	   (array-set! idata (array-ref res2 i2 0) m3 0) ;; id.
	   (array-set! idata 6 m3 1) ;; output value col.
	   (array-set! idata 0 m3 2) ;; number, 0 for now.
	   (array-set! idata 0 m3 3) ;; for node.	   
	   
	   (set! i2 (in i2)))

    ;; Put the iter end mark on the control column of the last row.
    (array-set! idata 1 m3 4)
    
    ;; Purge.
    (set! idata (grsp-matrix-subdell idata 0 (list 0 0 0 0)))
    
    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))

    res1))


;;;; grsp-ann-odata-atlorpn - Basic data for all output nodes. Provides an
;; odata table that contains at least one row per output node.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-ann-odata-atlorpn p_l1)
  (let ((res1 '())
	(res2 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(hm3 0)
	(lm4 0)
	(hm4 0)
	(m3 0)
	(m4 0)
	(i2 0)
	(j2 0)
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))

    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))    
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))
    (set! specs (grsp-ann-get-matrix "specs" p_l1))
    (set! odtid (grsp-ann-get-matrix "odtid" p_l1))
    (set! datai (grsp-ann-get-matrix "datai" p_l1))
    (set! datao (grsp-ann-get-matrix "datao" p_l1))
    (set! datae (grsp-ann-get-matrix "datae" p_l1))     

    ;; Create safety matrix. 
    (set! res2 (grsp-matrix-cpy nodes))
    
    ;; Make a row in odata per output in nodes.
    (set! res2 (grsp-matrix-row-select "#=" res2 2 2))

    ;; Extract boundaries of the selected rows.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))

    (set! lm4 (grsp-matrix-esi 1 odata))
    (set! hm4 (grsp-matrix-esi 2 odata))
    (set! m4 (- hm4 lm4))
    
    ;; Cycle.
    (set! i2 lm2)
    (while (<= i2 hm2)

	   ;; Create new row.
	   (set! hm3 (grsp-matrix-esi 2 odata))
	   (set! m3 (+ hm3 1))
	   (set! odata (grsp-matrix-row-subrepal odata m3 (list 0 0 0 0)))

	   ;; Fill data.
	   (array-set! odata (array-ref res2 i2 0) m3 0) ;; id.
	   (array-set! odata (array-ref res2 i2 3) m3 1) ;; layer.
	   (array-set! odata (array-ref res2 i2 4) m3 2) ;; layer pos.
	   (array-set! odata (array-ref res2 i2 6) m3 3) ;; output col.
	   
	   (set! i2 (in i2)))

    ;; Put the iter end mark on the control column of the last row.
    (array-set! odata 1 m3 4)
    
    ;; Purge.
    (set! odata (grsp-matrix-subdell odata 0 (list 0 0 0 0)))
    
    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))

    res1))


;;;; grsp-ann-odtid-atlorpn - Basic data for output to input (odata to
;; idata) feedback. This function builds a table that correlates each
;; output node to one input node for direct feedback loops. It requires
;; that both matrices should have the same number of rows in order to
;; establish a node-to-node relationship.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-ann-odtid-atlorpn p_l1)
  (let ((res1 '())
	(res2 0)
	(i1 0)
	(j1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))

    ;; Create safety matrix.   
    (set! res2 p_l1)
    
    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" res2))
    (set! conns (grsp-ann-get-matrix "conns" res2))
    (set! count (grsp-ann-get-matrix "count" res2))    
    (set! idata (grsp-ann-get-matrix "idata" res2))
    (set! odata (grsp-ann-get-matrix "odata" res2))
    (set! specs (grsp-ann-get-matrix "specs" res2))
    (set! odtid (grsp-ann-get-matrix "odtid" res2))
    (set! datai (grsp-ann-get-matrix "datai" res2))
    (set! datao (grsp-ann-get-matrix "datao" res2))
    (set! datae (grsp-ann-get-matrix "datae" res2))    

    (cond ((equal? (grsp-matrix-is-samedim idata odata) #t)
    
	   ;; Extract boundaries.
	   (set! lm1 (grsp-matrix-esi 1 idata))
	   (set! hm1 (grsp-matrix-esi 2 idata))
	   (set! ln1 (grsp-matrix-esi 3 idata))
	   (set! hn1 (grsp-matrix-esi 4 idata))

	   (set! odtid (grsp-matrix-create 0 (+ (- hm1 lm1) 1) 2))
	   
	   ;; Loop and update odtid.
	   (set! i1 lm1)
	   (while (<= i1 hm1)
		  (array-set! odtid (array-ref idata i1 0) i1 0)
		  (array-set! odtid (array-ref odata i1 0) i1 1)
		  (set! i1 (in i1)))))
	   
    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae)) 

    res1))


;;;; grsp-m2datai - Casts the data of a grsp3 matrix as datai format. 
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_a1: data matrix.
;; - p_id: idata.
;; - p_di: datai.
;; - p_n1: classifier.
;;
;;   - 0: regular data.
;;   - 1: training data.
;;   - 2: control data.
;;
;; Notes: 
;;
;; - See grsp-ann-datai-update, grsp-m2datae.
;;
;; Output:
;;
;; - Updated grsp8 ann datai table.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-m2datai p_a1 p_id p_di p_n1)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(lm3 0)
	(hm3 0)
	(ln3 0)
	(hn3 0)	
	(i3 0)
	(j3 0)
	(j4 0)
	(idata 0)
	(datai 0))

    ;; Create safety matrices. 
    (set! idata p_id)
    (set! datai p_di)

    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 idata))
    (set! hm1 (grsp-matrix-esi 2 idata))
    (set! ln1 (grsp-matrix-esi 3 idata))
    (set! hn1 (grsp-matrix-esi 4 idata))

    (set! lm2 (grsp-matrix-esi 1 datai))
    (set! hm2 (grsp-matrix-esi 2 datai))
    (set! ln2 (grsp-matrix-esi 3 datai))
    (set! hn2 (grsp-matrix-esi 4 datai))    

    (set! lm3 (grsp-matrix-esi 1 p_a1))
    (set! hm3 (grsp-matrix-esi 2 p_a1))
    (set! ln3 (grsp-matrix-esi 3 p_a1))
    (set! hn3 (grsp-matrix-esi 4 p_a1))  
    
    ;; Cycle thorough p_a1 row by row.
    (set! i3 lm3)
    (set! j4 lm1)
    (while (<= i3 hm3)

	   ;; Read as many columns from p_a1 as there are rows in idata.
	   (set! j3 lm1)
	   (while (<= j3 hm1)

		  ;; Start by creating a new row in datai that will hold
		  ;; the data from one element of p_a1 of the row being
		  ;; read from idata.
		  (set! datai (grsp-matrix-subexp datai 1 0))

		  ;; Update datai m-size data.
		  (set! hn2 (grsp-matrix-esi 4 datai))
		  
		  ;; Read row j3 from idata to get data to construct a new
		  ;; datai row and  create new datai row.

		  ;; Id of the receptive node.
		  (array-set! datai (array-ref idata j3 0) j4 0)

		  ;; Column to input data in.
		  (array-set! datai (array-ref idata j3 1) j4 1)

		  ;; Value to input.
		  (array-set! datai (array-ref p_a1 i3 j3) j4 2)

		  ;; Type (in this case, input node).
		  (array-set! datai 0 j4 3)

		  ;; Record contro.
		  (array-set! datai (array-ref idata j3 4) j4 4)

		  ;; User-provided classifier.
		  (array-set! datai p_n1 j4 5)

		  (set! j4 (in j4))
		  (set! j3 (in j3)))
	   
	   (set! i3 (in i3)))

    ;; Purge datai.
    (set! hm2 (grsp-matrix-esi 2 datai))    
    (set! datai (grsp-matrix-subdell datai hm2 (list 0 0 0 0 0)))    

    ;; Compose results.
    (set! res1 datai)
    
    res1))


;;;; grsp-ann-datai-update - Black box update of datai table using
;; grsp-m2datai.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_a1: data matrix.
;; - p_l1: ann.
;; - p_n1: classifier.
;;
;;   - 0: regular data.
;;   - 1: training data.
;;   - 2: control data.
;;
;; Notes:
;;
;; - See grsp-m2datai.
;;
;; Examples:
;;
;; - example3.scm.
;;
;; Output:
;;
;; - p_l1 with an updated datai table.
;;
(define (grsp-ann-datai-update p_a1 p_l1 p_n1)
  (let ((res1 '())
	(res2 0)
	(i1 0)
	(j1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))

    ;; Create safety matrix. 
    (set! res2 p_l1)
    
    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" res2))
    (set! conns (grsp-ann-get-matrix "conns" res2))
    (set! count (grsp-ann-get-matrix "count" res2))    
    (set! idata (grsp-ann-get-matrix "idata" res2))
    (set! odata (grsp-ann-get-matrix "odata" res2))
    (set! specs (grsp-ann-get-matrix "specs" res2))
    (set! odtid (grsp-ann-get-matrix "odtid" res2))
    (set! datai (grsp-ann-get-matrix "datai" res2))
    (set! datao (grsp-ann-get-matrix "datao" res2))
    (set! datae (grsp-ann-get-matrix "datae" res2))    

    ;; Cast p_a1 as datai.
    (set! datai (grsp-m2datai p_a1 idata datai p_n1))

    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae)) 
    
    res1))


;;;; grsp-datai2idata - Passes the first input group of a datai table to
;; the input nodes of the ann and then deletes the group.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-datai2idata p_l1)
  (let ((res1 '())
	(res2 0)
	(i1 0)
	(b1 #f)
	(n0 0)
	(n3 0)
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))
   
    ;; Extract matrices.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))    
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))
    (set! specs (grsp-ann-get-matrix "specs" p_l1))
    (set! odtid (grsp-ann-get-matrix "odtid" p_l1))
    (set! datai (grsp-ann-get-matrix "datai" p_l1))
    (set! datao (grsp-ann-get-matrix "datao" p_l1))
    (set! datae (grsp-ann-get-matrix "datae" p_l1))    

    ;; Cycle.
    (set! i1 (grsp-lm datai))
    (while (equal? b1 #f)

	    ;; Find id of target.
	    (set! n0 (array-ref datai i1 0)) 
	    
	    ;; Find what kind of target we have at col 3.
	    ;;
	    ;; - 0: for node.
	    ;; - 1: for connection.
	    ;;
	    (set! n3 (array-ref datai i1 3))
	    
	    ;; Check control element. If epoch ends, according to the
	    ;; value contained in col 4 of current datai row, set b1 to
	    ;; true.
	    ;;
	    ;; - 0: default.
	    ;; - 1: epoch end.
	    ;;
	    (cond ((= (array-ref datai i1 4) 1)
		   (set! b1 #t)))
	    
	    ;; Depending on the kind of target, select the rows from one
	    ;; table or another whose id number (col 0) is equal to n0.
	    (cond ((= n3 0) ;; Node.
		   (set! res2 (grsp-matrix-row-select "#=" nodes 0 n0)))
		  ((= n3 1) ;; Connection.
		   (set! res2 (grsp-matrix-row-select "#=" conns 0 n0))))

	    ;; Update res2. Note that essentially there will be on row
	    ;; selected in res2 since each node or connection has its
	    ;; own id.
	    (array-set! res2
			(array-ref datai i1 2)
			0
			(array-ref datai i1 1)) ;; ***

	    ;; Mark datai record just passed to idata for deletion.
	    (array-set! datai 2 i1 2)
	    
	    ;; Commit.
	    (cond ((= n3 0)
		   (set! nodes (grsp-matrix-commit nodes res2 0)))
		  ((= n3 1)
		   (set! conns (grsp-matrix-commit conns res2 0))))
	    
	    (set! i1 (in i1)))

    ;; Update datai (batch delete what has been just copied).
    (set! datai (grsp-matrix-row-delete "#=" datai 2 2))
        
    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))
	
    res1))


;;;; grsp-ann-fdifm - Applies grsp-matrix-fdif to matrix p_s1 of ann
;; p_l1 and p_l2 to find differences between their matrices. This is
;; useful to study the behaviour of your ann.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_s1: selected:
;;
;;   - "nodes".
;;   - "conns".
;;   - "count".
;;   - "idata".
;;   - "odata".
;;   - "specs".
;;   - "odtid".
;;   - "datai".
;;   - "datao".
;;   - "datae".
;;
;; - p_l1: ann.
;; - p_l2: ann.
;;
;; Notes:
;;
;; - See grsp3.grsp-matrix-fdif, grsp-ann-fdif.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-ann-fdifm p_s1 p_l1 p_l2)
  (let ((res1 0))
  
    (set! res1 (grsp-matrix-create 0 1 1))
    (set! res1 (grsp-matrix-fdif (grsp-ann-get-matrix p_s1 p_l1)
				 (grsp-ann-get-matrix p_s1 p_l2)))

    res1))


;; grsp-ann-fdif - Appies grsp-ann-fdifm to all matrices of a neural
;; network. This shows changes on all ann components (diff map).
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann, first state.
;; - p_l2: ann, second state.
;;
;; Notes:
;;
;; - See grsp3.grsp-matrix-fdifm, grsp-ann-fdifm.
;;
;; Examples:
;;
;; - example3.scm.
;;
;; Output:
;;
;; - A list containing difference maps (matrices) for each pair of ann
;;   matrices; this list is a representation of the differences between
;;   two networks.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-ann-fdif p_l1 p_l2)
  (let ((res1 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))	

    (set! nodes (grsp-ann-fdifm "nodes" p_l1 p_l2))
    (set! conns (grsp-ann-fdifm "conns" p_l1 p_l2))		    
    (set! count (grsp-ann-fdifm "count" p_l1 p_l2))
    (set! idata (grsp-ann-fdifm "idata" p_l1 p_l2))
    (set! odata (grsp-ann-fdifm "odata" p_l1 p_l2))
    (set! specs (grsp-ann-fdifm "specs" p_l1 p_l2))
    (set! odtid (grsp-ann-fdifm "odtid" p_l1 p_l2))
    (set! datai (grsp-ann-fdifm "datai" p_l1 p_l2))
    (set! datao (grsp-ann-fdifm "datao" p_l1 p_l2))
    (set! datae (grsp-ann-fdifm "datae" p_l1 p_l2))    

    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))
    
    res1))


;;;; grsp-ann-updatem - Updates ann p_l1 one matrix at a time.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_s1: selected:
;;
;;   - "nodes".
;;   - "conns".
;;   - "count".
;;   - "idata".
;;   - "odata".
;;   - "specs".
;;   - "odtid".
;;   - "datai".
;;   - "datao".
;;   - "datae".
;;
;; - p_a1 matrix to replace the one selected by p_s1.
;; - p_l1: ann.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-ann-updatem p_s1 p_a1 p_l1)
  (let ((res1 '())
	(n1 0)
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))	

    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))    
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))
    (set! specs (grsp-ann-get-matrix "specs" p_l1))
    (set! odtid (grsp-ann-get-matrix "odtid" p_l1))
    (set! datai (grsp-ann-get-matrix "datai" p_l1))
    (set! datao (grsp-ann-get-matrix "datao" p_l1))
    (set! datae (grsp-ann-get-matrix "datae" p_l1))    

    ;; Update matrix.
    (cond ((equal? p_s1 "nodes")
	   (set! nodes p_a1))
	  ((equal? p_s1 "conns")
	   (set! conns p_a1))	  
	  ((equal? p_s1 "count")
	   (set! count p_a1)) 
	  ((equal? p_s1 "idata")
	   (set! idata p_a1))
	  ((equal? p_s1 "odata")
	   (set! odata p_a1))
	  ((equal? p_s1 "specs")
	   (set! specs p_a1))
	  ((equal? p_s1 "odtid")
	   (set! odtid p_a1))
	  ((equal? p_s1 "datai")
	   (set! datai p_a1))
	  ((equal? p_s1 "datao")
	   (set! datao p_a1))
	  ((equal? p_s1 "datae")
	   (set! datae p_a1)))
    
    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))
    
    res1))


;;;; grsp-nodes2odata - Casts the data contained in output nodes to
;; odata table.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_a1: nodes table.
;; - p_a2: odata table.
;;
;; Output:
;;
;; - odata table with output data.
;;
(define (grsp-nodes2odata p_a1 p_a2)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(n2 0)
	(i1 0)
	(i2 0))

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))
      
    (set! res1 (grsp-matrix-row-select "#=" res1 2 2))

    ;; Loop over res2 and pass relevant data from each row to odata.
    (set! i1 (grsp-lm res1))
    (set! i2 (grsp-lm res2))
    (while (<= i2 (grsp-hm res2))

	   ;; On iteration end, change the control value to 1.
	   (cond ((= i1 (grsp-hm res1))
		  (set! n2 1))
		 (else (set! n2 0)))		  

	   ;; Id of output node.
	   (array-set! res2 (array-ref res1 i1 0) i2 0)

	   ;; Layer.
	   (array-set! res2 (array-ref res1 i1 3) i2 1)

	   ;; Layer pos.
	   (array-set! res2 (array-ref res1 i1 4) i2 2)

	   ;; Result.
	   (array-set! res2 (array-ref res1 i1 6) i2 3)

	   ;; Control.
	   (array-set! res2 n2 i2 4)

	   (set! i2 (in i2))
	   (set! i1 (in i1)))
    
    res2))


;;;; grsp-odata2datao - Adds the most recent data from odata (one row or
;; record obtained from the evaluation of the nodes) to datao (table
;; containing the results of all evaluations performed so far.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_a1: odata table.
;; - p_a2: datao table.
;;
;; Output:
;;
;; - datao table with additional rows.
;;
(define (grsp-odata2datao p_a1 p_a2)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(n2 0)
	(i1 0)
	(i2 0))

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))

    (set! i1 (grsp-lm res1))
    (set! i2 (grsp-lm res2))
    (while (<= i1 (grsp-hm res1))

	   ;; See if the last row of res2 (datao) is filled with zeros:
	   ;;
	   ;; - If it is, then do not add a new row.
	   ;; - If it is not filled with zeros, add a new row.
	   ;;
	   (set! res4 (grsp-matrix-subcpy res2
					  (grsp-hm res2)
					  (grsp-hm res2)
					  (grsp-ln res2)
					  (grsp-hn res2)))

	   (cond ((equal? (grsp-matrix-is-filled-with res2 0) #f)
		  (set! res2 (grsp-matrix-subexp res2 1 0))))

	   ;; Copy data from res1.
	   (array-set! res2 (array-ref res1 i1 0) i2 0)
	   (array-set! res2 (array-ref res1 i1 1) i2 1)
	   (array-set! res2 (array-ref res1 i1 2) i2 2)
	   (array-set! res2 (array-ref res1 i1 3) i2 3)
	   (array-set! res2 (array-ref res1 i1 4) i2 4)

	   (set! i2 (in i2))
	   (set! i1 (in i1)))
    
    res2))


;; grsp-ann-net-size - Calculates the size of a neural network.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Output:
;;
;; - List:
;;
;;   - Elem 0: number of nodes.
;;   - Elem 1: number of connections (edges).
;;
;; Sources:
;;
;; - [11][13].
;;
(define (grsp-ann-net-size p_l1)
  (let ((res1 '())
	(nodes 0)
	(conns 0)	
	(lm1 0)
	(hm1 0)
	(lm2 0)
	(hm2 0))

    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))  
    
    ;; Extract matrix boundaries.
    (set! lm1 (grsp-matrix-esi 1 nodes))
    (set! hm1 (grsp-matrix-esi 2 nodes))
    (set! lm2 (grsp-matrix-esi 1 conns))
    (set! hm2 (grsp-matrix-esi 2 conns))    

    ;; Compose results.
    (set! res1 (list (grsp-matrix-te1 lm1 hm1) (grsp-matrix-te1 lm2 hm2)))
    
    res1))


;; grsp-ann-node-degree - Calculates the degree of each node of ann p_l1,
;; considering the degree to be the number of edges (conns) connected to
;; said node.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Output:
;;
;; - Matrix:
;;
;;   - Col 0: node id.
;;   - Col 1: input degree.
;;   - Col 2: output degree.
;;   - Col 3: total degree (sum of input and output degrees).
;;
;; Notes:
;;
;; - See grsp-ann-net-adegree.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [11][13].
;;
(define (grsp-ann-node-degree p_l1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(nodes 0)
	(conns 0)	
	(lm1 0)
	(hm1 0)
	(i1 0)
	(m1 0)
	(m2 0)
	(m3 0))

    ;; Extract matrices.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))

    ;; Extract matrix boundaries.
    (set! lm1 (grsp-matrix-esi 1 nodes))
    (set! hm1 (grsp-matrix-esi 2 nodes))

    ;; Set matrix res1 to have a number of rows equal to the number of
    ;; rows found in matrix nodes, and two columns.    
    (set! m1 (grsp-matrix-te1 lm1 hm1))
    (set! res1 (grsp-matrix-create 0 m1 4))

    ;;Evaluate each node and sum the number of conns reaching it and the
    ;; number of conns leaving the node. Then sum both numbers and get
    ;; the total for each node.
    (set! i1 lm1)
    (while (<= i1 hm1)

	   ;; Select the node's id.
	   (array-set! res1 i1 i1 0)
	   
	   ;; Select nodes coming from current node (conns col 3).
	   (set! res3 (grsp-matrix-row-select "#=" conns 3 i1))
	   (set! res2 (grsp-matrix-te2 res3))
	   (array-set! res1 (array-ref res2 0 0) i1 1)
	   
	   ;; Select nodes going to the current node (conns col 4).
	   (set! res4 (grsp-matrix-row-select "#=" conns 4 i1))
	   (set! res2 (grsp-matrix-te2 res4))
	   (array-set! res1 (array-ref res2 0 0) i1 2)	   

	   ;; Calculate total size.
	   (array-set! res1
		       (+ (array-ref res1 i1 1)
			  (array-ref res1 i1 2))
		       i1
		       3)
	   
	   (set! i1 (in i1)))	   
    
    res1))


;; grsp-ann-net-adegree - Average degrees (directed, undirected) of
;; network p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Output:
;;
;; - List:
;;
;;   - Elem 0: undirected average.
;;   - Elem 1: directed average.
;;
;; Notes:
;;
;; - See grsp-ann-node-degree.
;;
;; Sources:
;;
;; - [11].
;;
(define (grsp-ann-net-adegree p_l1)
  (let ((res1 (list 0 0))
	(res2 (list 0 0))
	(n1 0)
	(e1 0)
	(m1 0))

    (set! res2 (grsp-ann-net-size p_l1))
    (set! n1 (list-ref res2 0))
    (set! e1 (list-ref res2 1))
    (set! m1 (/ e1 n1))
    (set! m1 (grsp-opz m1))
    (list-set! res1 0 m1)
    (list-set! res1 1 (* 2 m1))
    
    res1))


;; grsp-ann-net-density - Density of network p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [11].
;;
(define (grsp-ann-net-density p_l1)
  (let ((res1 0)
	(res2 '())
	(e1 0)
	(n1 0)
	(n2 0))

    ;; Extract ann properties (number of nodes and edges).
    (set! res2 (grsp-ann-net-size p_l1))
    (set! n1 (car res2))
    (set! e1 (cadr res2))

    ;; Calculate network density.
    (set! n2 (* -1 n1))
    (set! res1 (/ (* 2 (+ e1 n2 1)) (+ (* n1 (- n1 3)) 2)))
    (set! res1 (grsp-opz res1))
    
    res1))


;; grsp-ann-net-density - Planar density of network p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [11].
;;
(define (grsp-ann-net-pdensity p_l1)
  (let ((res1 0)
	(res2 '())
	(e1 0)
	(n1 0))

    ;; Extract ann properties (number of nodes and edges).
    (set! res2 (grsp-ann-net-size p_l1))
    (set! n1 (car res2))
    (set! e1 (cadr res2))

    ;; Calculate network pdensity.
    (set! res1 (/ (+ (- e1 n1) 1) (- (* 2 n1) 5)))
    (set! res1 (grsp-opz res1))
    
    res1))


;;;; grsp-ann-node-conns - Finds the connections (edges) linking to node
;; p_n1 of network p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;; - p_n1: node id.
;;
;; Output:
;;
;; - List.
;;
;;   - Elem 0: matrix of selected edges reaching node p_n1 (TO).
;;   - Elem 1: matrix of selected edges going out of node p_n1 (FROM).
;;
(define (grsp-ann-node-conns p_l1 p_n1)
  (let ((res1 '())
	(to 0)
	(fr 0)
	(conns 0))

    ;; Extract matrix.
    (set! conns (grsp-ann-get-matrix "conns" p_l1))

    ;; Select edges going to p_n1 (TO).
    (set! to (grsp-matrix-row-select "#=" conns 4 p_n1))

    ;; Select edges going out of p_n1 (FROM).
    (set! fr (grsp-matrix-row-select "#=" conns 3 p_n1))

    ;; Compose results.
    (set! res1 (list to fr))
    
    res1))


;;;; grsp-ann-nodes-conns - Find the connections (edges) connected to
;; each node of ann p_l1
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Output:
;;
;; - List of grsp-ann-node-conns results applied to each node of p_l1.
;;
(define (grsp-ann-nodes-conns p_l1)
  (let ((res1 '())
	(res2 '())
	(nodes 0)
	(conns 0)
	(i1 0)
	(i2 0)
	(id 0)
	(lm1 0)
	(hm1 0))

    ;; Extract matrices.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))

    ;; Extract matrix boundaries.
    (set! lm1 (grsp-matrix-esi 1 nodes))
    (set! hm1 (grsp-matrix-esi 2 nodes))

    ;; Define res1 as a list with a number of elements equal to the
    ;; number of nodes.
    (set! i2 (grsp-matrix-te1 lm1 hm1))
    (set! res1 (make-list i2))
    
    ;; Cycle and compose results.
    (set! i1 lm1)
    (while (<= i1 hm1)

	   ;; Extract node id.
	   (set! id (array-ref nodes i1 0))
	   (set! res2 (grsp-ann-node-conns p_l1 id))
	   
	   ;; Add list res2 to res1, which contains final results.
	   (list-set! res1 i1 res2)
	   
	   (set! i1 (in i1)))
    
    res1))
  

;;;; grsp-ann-conn-nodes - Finds the FROM and TO nodes linked by
;; connection p_n1 of network p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;; - p_n1: connection (edge) id.
;;
;; Notes:
;;
;; -  See grsp-ann-conns-nodes.
;;
;; Output:
;;
;; - List.
;;
;;   - Elem 0: TO node.
;;   - Elem 1: FROM node.
;;
(define (grsp-ann-conn-nodes p_l1 p_n1)
  (let ((res1 '())
	(res2 '())
	(res3 '())
	(res4 0)
	(res5 0)
	(res6 0)
	(to 0)
	(fr 0)
	(b1 #f)
	(b2 #f)
	(nodes 0)
	(conns 0))

    ;; (1) Create empty matrix.
    (set! res6 (grsp-matrix-create 0 0 0))
    (set! res4 res6)
    (set! res5 res6)
    
    ;; Extract matrix.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))    
    (set! conns (grsp-ann-get-matrix "conns" p_l1))

    ;; Select node id to which p_n1 connects (TO).
    (set! res4 (grsp-matrix-row-select "#=" conns 4 p_n1))
    
    (cond ((> (grsp-matrix-col-total-element "#>=" res4 0 1) 0)
	   (set! b1 #t)
	   (set! to (array-ref res4 0 0))))

    ;; Select node id from which p_n1 goes out (FROM).
    (set! res5 (grsp-matrix-row-select "#=" conns 3 p_n1))
    
    (cond ((> (grsp-matrix-col-total-element "#>=" res5 0 1) 0)
	   (set! b2 #t)    
	   (set! fr (array-ref res5 0 0))))    

    ;; (2) and (3) help guarantee that the correct type (matrix) will be
    ;; returned as result considering how res6 was configured at (1).
    
    ;; (2) Select node record (row) from matrix nodes which p_n1 goes
    ;; (TO).
    (cond ((equal? b1 #t)
	   (set! res2 (grsp-matrix-row-select "#=" nodes 0 to))))

    ;; (3) Select node record (row) from matrix nodes which p_n1 comes
    ;; (FROM).
    (cond ((equal? b2 #t)    
	   (set! res3 (grsp-matrix-row-select "#=" nodes 0 fr))))

    ;; Compose results.
    (set! res1 (list res2 res3))
	
    res1))


;;;; grsp-ann-conns-nodes - Finds the FROM and TO nodes linked by
;; connections (edges) of network p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Notes:
;;
;; - See grsp-ann-conn-nodes.
;;
;; Output:
;;
;; - grsp-ann-conn-nodes results as a matrix for each and all nodes
;;   of p_l1. Note that connection ID is not providred in a separated
;;   column.
;;
;;   - Col 0: TO nodes.
;;   - Col 1: FROM nodes.
;;
(define (grsp-ann-conns-nodes p_l1)
  (let ((res1 '())
	(res2 '())
	(nodes 0)
	(conns 0)
	(i1 0)
	(i2 0)
	(id 0)
	(lm1 0)
	(hm1 0))

    ;; Extract matrices.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))

    ;; Extract matrix boundaries.
    (set! lm1 (grsp-matrix-esi 1 conns))
    (set! hm1 (grsp-matrix-esi 2 conns))

    ;; Define res1 as a list with a number of elements equal to the
    ;; number of connections.
    (set! i2 (grsp-matrix-te1 lm1 hm1))
    (set! res1 (make-list i2))
    
    ;; Cycle and compose results.
    (set! i1 lm1)
    (while (<= i1 hm1)

	   ;; Extract connection id.
	   (set! id (array-ref conns i1 0))
	   (set! res2 (grsp-ann-conn-nodes p_l1 id))
	   
	   ;; Add list res2 to res1, which contains final results.
	   (list-set! res1 i1 res2)
	   
	   (set! i1 (in i1)))
    
    res1))
  

;;;; grsp-ann-devt - Displays all matrices of the ann with labels.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: shows element names.
;;   - #f: does not show names.
;;
;; - p_l1: ann.
;;
;; Examples:
;;
;; - example3.scm.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ann-devt p_b1 p_l1)
  (let ((l2 '()))
    
    (set! l2 (list "nodes"
		   "conns"
		   "count"
		   "idata"
		   "odata"
		   "specs"
		   "odtid"
		   "datai"
		   "datao"
		   "datae"))
    (grsp-lal-devt p_b1 p_l1 l2)))


;;;; grsp-ann-devn - Describes node with id p_n1 from network p_l1.
;;
;; Keywords:
;;
;; - function, ann, neural, network
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: shows element names.
;;   - #f: does not show names.
;;
;; - p_l1: ann.
;; - p_n1: node id.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ann-devn p_b1 p_l1 p_n1)
  (let ((l2 '())
	(l3 '())
	(a2 0)
	(nodes 0))

    ;; Extract matrix nodes.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! a2 (grsp-matrix-row-select "#=" nodes 0 p_n1))
    (set! l2 (grsp-m2l a2))

    ;; Describe node row cas as a list.
    (display (strings-append (list "\n --- " (gconsts "Node")) 0))
    (display p_n1)
    (display " val \n")
    (set! l3 (list "id"
		   "status"
		   "type"
		   "layer"
		   "layer pos"
		   "bias"
		   "output value"
		   "assoc fun"
		   "evol"
		   "weight"
		   "iter"))
    (grsp-lal-devt p_b1 l2 l3)))


;;;; grsp-ann-devc - Describes connection with id p_n1 from network p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: shows element names.
;;   - #f: does not show names.
;;
;; - p_l1: ann.
;; - p_n1: connection id.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ann-devc p_b1 p_l1 p_n1)
  (let ((l2 '())
	(l3 '())
	(a2 0)
	(conns 0))

    ;; Extract matrix conns.
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! a2 (grsp-matrix-row-select "#=" conns 0 p_n1))
    (set! l2 (grsp-m2l a2))

    ;; Describe conns row cas as a list.
    (display (strings-append (list "\n ------- " (gconsts "Cv") "\n") 0))
    (set! l3 (list "id"
		   "status"
		   "type"
		   "from"
		   "to"
		   "value"
		   "evol"
		   "weight"
		   "iter"
		   "to layer pos"))
    (grsp-lal-devt p_b1 l2 l3)))


;;;; grsp-ann-devcl - Describes connections from conns matrix.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: shows element names.
;;   - #f: does not show names.
;;
;; - p_a2: conns.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ann-devcl p_b1 p_a2)
  (let ((l2 '())
	(l3 '())
	(a2 0))

    ;; Cast input matrix as list.
    (set! l2 (grsp-m2l p_a2))

    ;; Describe conns row which was cast as a list. grsp-lal-devt takes
    ;; the list cast from the original matrix and a list with as many
    ;; labels as the first list has elements, and shows the combination
    ;; of each pair of list elements.
    (display (strings-append (list "\n ------- " (gconsts "Cv") "\n") 0))
    (set! l3 (list "id"
		   "status"
		   "type"
		   "from"
		   "to"
		   "value"
		   "evol"
		   "weight"
		   "iter"
		   "to layer pos"))
    (grsp-lal-devt p_b1 l2 l3)))


;;;; grsp-ann-devnc - Describes node with id p_n1 from network p_l1 and
;; its connections.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: shows element names.
;;   - #f: does not show names.
;;
;; - p_l1: ann.
;; - p_n1: node id.
;; - p_n2: connection description mode.
;;
;;   - 0: describe input and output connections.
;;   - 1: describe only input connections.
;;   - 2: describe only output connections.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ann-devnc p_b1 p_l1 p_n1 p_n2)
  (let ((n2 0)
	(s1 "")    
	(nodes 0)
	(node 0)
	(conns 0)
	(connst 0)
	(connsf 0)
	(b2 #f)
	(bt #t)
	(bf #t))

    (set! s1 (strings-append (list "\n ----- " (gconsts "IOc") "\n") 0))
    (display s1)
    
    ;; Check for valid p_n2 values N [0..2].
    (cond ((> p_n2 2)
	   (set! n2 0))
	  ((< p_n2 0)
	   (set! n2 0)))

    ;; Change title, if applicable.
    (cond ((= n2 1)
	   (set! s1 (strings-append (list "\n ----- " (gconsts "Ic") "\n")
				    0))
	  ((= n2 2)
	   (set! s1 (strings-append (list "\n ----- " (gconsts "Oc") "\n")
				    0)))))

    ;; Find if node exists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))  
    (set! node (grsp-matrix-row-select "#=" nodes 0 p_n1))
    (set! b2 (grsp-matrix-is-empty node))
    
    (cond ((equal? b2 #f)
	   
	   (grsp-ann-devn p_b1 p_l1 p_n1)
	   
	   ;; Extract matrices.
	   (set! conns (grsp-ann-get-matrix "conns" p_l1))    
	   (set! connsf (grsp-matrix-row-select "#=" conns 3 p_n1))
	   (set! connst (grsp-matrix-row-select "#=" conns 4 p_n1))

	   ;; See if matrices are empty. Some nodes might not have either
	   ;; input or output connections.
	   (set! bt (grsp-matrix-is-empty connst))
	   (set! bf (grsp-matrix-is-empty connsf))    
	   
	   ;; Describe.
	   (display s1)
	   
	   (cond ((= n2 0)
		  (display (strings-append (list "\n ------ "
						 (gconsts "Ic")
						 "\n")
					   0))
		  
		  (cond ((equal? bt #f)
			 (grsp-ann-devcl p_b1 connst))
			((equal? bt #t)
			 (display (strings-append (list "\n "
							(gconsts "Nocon")
							"\n")
						  0))))
		  
		  (display (strings-append (list "\n ------ "
						 (gconsts "Oc")
						 "\n")
					   0))

		  (cond ((equal? bf #f)
			 (grsp-ann-devcl p_b1 connsf))
			((equal? bf #t)
			 (display (strings-append (list "\n "
							(gconsts "Nocon")
							"\n")
						  0)))))
		 ((= n2 1)
		  (display (strings-append (list "\n ------ "
						 (gconsts "Ic")
						 "\n")
					   0))

		  (cond ((equal? bt #f)
			 (grsp-ann-devcl p_b1 connst))
			((equal? bt #t)
			 (display (strings-append (list "\n "
							(gconsts "Nocon")
							"\n")
						  0)))))
		 
		 ((= n2 2)
		  (display (strings-append (list "\n ------ "
						 (gconsts "Oc")
						 "\n")
					   0))

		  (cond ((equal? bf #f)
			 (grsp-ann-devcl p_b1 connsf))
			((equal? bf #t)
			 (display (strings-append (list "\n "
							(gconsts "Nocon")
							"\n")
						  0))))))))))
    

;;;; grsp-ann-devnca - Describes all nodes from network p_l1 and their
;; connections by applying grsp-ann-devnc to each node.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: shows element names.
;;   - #f: does not show names.
;;
;; - p_b3: boolean.
;;
;;   - #t: stops after analyzing each node and its connections.
;;   - #f: does not stop on each connection.
;;
;; - p_l1: ann.
;; - p_n2: connection description mode.
;;
;;   - 0: describe input and output connections.
;;   - 1: describe only input connections.
;;   - 2: describe only output connections.
;;
;; Notes:
;;
;; - See grsp-ann-devnc.
;;
;; Examples:
;;
;; - example3.scm.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ann-devnca p_b1 p_b3 p_l1 p_n2)
  (let ((i1 0)
	(nodes 0)
	(b2 #f))
    
    ;; Extract matrix.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))

    ;; Find if results matrix is empty; empty would mean no nodes
    ;; present in the network.
    (set! b2 (grsp-matrix-is-empty nodes))
    
    ;; Cycle if results matrix is not empty. If it is empty, it means
    ;; that there are no nodes and thus, no valid connections. A network
    ;; with connections but no nodes would not be functional.
    (cond ((equal? b2 #f)
	   
	   (set! i1 (grsp-lm nodes))
	   (while (<= i1 (grsp-hm nodes))
		  (grsp-ann-devnc p_b1 p_l1 (array-ref nodes i1 0) p_n2)

		  (cond ((equal? p_b3 #t)
			 (grsp-ask (gconsts "pec"))
			 (clear)))
		  
		  (set! i1 (in i1)))))))


;;;; grsp-ann-stats - Provides basic network info and statistics on ann
;; p_a1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_s1: string, title or identifier.
;; - p_l1: ann.
;;
;; Examples:
;;
;; - example3.scm.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ann-stats p_s1 p_l1)
  (let ((size 0)
	(degree 0)
	(adegree 0)
	(density 0)
	(pdensity 0)
	(cnode 0)
	(nconn 0))
	
    (grsp-ldl (strings-append (list p_s1 (gconsts "ANNp")) 1) 2 1)
    (set! size (grsp-ann-net-size p_l1))
    (grsp-ldl "Dim " 2 0)
    (grsp-ldl size 0 1)

    (set! degree (grsp-ann-node-degree p_l1))
    (grsp-ldl "Deg " 2 0)
    (grsp-ldl degree 0 1)

    (set! adegree (grsp-ann-net-adegree p_l1))
    (grsp-ldl "u deg " 2 0)
    (grsp-ldl adegree 0 1)

    (set! density (grsp-ann-net-density p_l1))
    (grsp-ldl "Den " 2 0)
    (grsp-ldl density 0 1)

    (set! pdensity (grsp-ann-net-pdensity p_l1))
    (grsp-ldl "Planar den " 2 0)
    (grsp-ldl pdensity 0 1)

    (set! cnode (grsp-ann-nodes-conns p_l1))
    (grsp-ldl "C x n " 2 0)
    (grsp-lal-dev #t cnode)

    (set! nconn (grsp-ann-conns-nodes p_l1))
    (grsp-ldl "N x c " 2 0)
    (grsp-lal-dev #t nconn)))


;;;; grsp-ann-display - SHows each matrix of an ANN.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_l1: ann.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ann-display p_l1)
  (let ((res1 0))

    ;; Extract matrices and lists.
    (grsp-ldl "nodes" 2 1)
    (grsp-matrix-display (grsp-ann-get-matrix "nodes" p_l1))

    (grsp-ldl "conns" 2 1)
    (grsp-matrix-display (grsp-ann-get-matrix "conns" p_l1))

    (grsp-ldl "count" 2 1)
    (grsp-matrix-display (grsp-ann-get-matrix "count" p_l1))

    (grsp-ldl "idata" 2 1)
    (grsp-matrix-display (grsp-ann-get-matrix "idata" p_l1))
    
    (grsp-ldl "odata" 2 1)
    (grsp-matrix-display (grsp-ann-get-matrix "odata" p_l1))    
   
    (grsp-ldl "specs" 2 1)
    (grsp-matrix-display (grsp-ann-get-matrix "specs" p_l1))
    
    (grsp-ldl "odtid" 2 1)
    (grsp-matrix-display (grsp-ann-get-matrix "odtid" p_l1))
    
    (grsp-ldl "datai" 2 1)
    (grsp-matrix-display (grsp-ann-get-matrix "datai" p_l1))
    
    (grsp-ldl "datao" 2 1)
    (grsp-matrix-display (grsp-ann-get-matrix "datao" p_l1))    

    (grsp-ldl "datae" 2 1)
    (grsp-matrix-display (grsp-ann-get-matrix "datae" p_l1))
    
    res1))

       
;;;; grsp-ann-updater - Update row p_m1 of matrix p_s1 of ann p_l1 with
;; the values contained in p_l2.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_s1: string, matrix name.
;;
;;   - "nodes".
;;   - "conns".
;;   - "count".
;;   - "idata".
;;   - "odata".
;;   - "specs".
;;   - "datai".
;;   - "datao".
;;   - "datae".
;;
;; - p_l1: ann.
;; - p_m1: row number.
;; - p_l2: list of values.
;;
;; Output:
;;
;; - ann (list).
;;
(define (grsp-ann-updater p_s1 p_l1 p_m1 p_l2)
  (let ((res1 '())
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))
   
    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))    
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))
    (set! specs (grsp-ann-get-matrix "specs" p_l1))
    (set! odtid (grsp-ann-get-matrix "odtid" p_l1))
    (set! datai (grsp-ann-get-matrix "datai" p_l1))
    (set! datao (grsp-ann-get-matrix "datao" p_l1))
    (set! datae (grsp-ann-get-matrix "datae" p_l1))    

    ;; Update row of selected matrix.
    (cond ((equal? p_s1 "nodes")
	   (set! nodes (grsp-l2mr nodes p_l2 p_m1 (grsp-ln nodes))))
	  ((equal? p_s1 "conns")
	   (set! conns (grsp-l2mr conns p_l2 p_m1 (grsp-ln conns))))
	  ((equal? p_s1 "count")
	   (set! count (grsp-l2mr count p_l2 p_m1 (grsp-ln count))))
	  ((equal? p_s1 "idata")
	   (set! idata (grsp-l2mr idata p_l2 p_m1 (grsp-ln idata))))
	  ((equal? p_s1 "odata")
	   (set! odata (grsp-l2mr odata p_l2 p_m1 (grsp-ln odata))))
	  ((equal? p_s1 "specs")
	   (set! specs (grsp-l2mr specs p_l2 p_m1 (grsp-ln specs))))
	  ((equal? p_s1 "odtid")
	   (set! odtid (grsp-l2mr odtid p_l2 p_m1 (grsp-ln odtid))))
	  ((equal? p_s1 "datai")
	   (set! datai (grsp-l2mr datai p_l2 p_m1 (grsp-ln datai))))
	  ((equal? p_s1 "datao")
	   (set! datao (grsp-l2mr datao p_l2 p_m1 (grsp-ln datao))))
	  ((equal? p_s1 "datae")
	   (set! datao (grsp-l2mr datao p_l2 p_m1 (grsp-ln datae)))))	  
    
    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))
    
    res1))


;;;; grsp-ann-element-number - Returns the element number of matrix p_s1
;; in ann list p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_s1: string, matrix name.
;;
;;   - "nodes".
;;   - "conns".
;;   - "count".
;;   - "idata".
;;   - "odata".
;;   - "specs".
;;   - "datai".
;;   - "datao".
;;   - "datae"
;;
;; - p_l1: ann.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-ann-element-number p_s1 p_l1)
  (let ((res1 0))

    (cond ((equal? p_s1 "nodes")
	   (set! res1 0))
	  ((equal? p_s1 "conns")
	   (set! res1 1))	  
	  ((equal? p_s1 "count")
	   (set! res1 2)) 
	  ((equal? p_s1 "idata")
	   (set! res1 3))
	  ((equal? p_s1 "odata")
	   (set! res1 4))
	  ((equal? p_s1 "specs")
	   (set! res1 5))
	  ((equal? p_s1 "odtid")
	   (set! res1 6))
	  ((equal? p_s1 "datai")
	   (set! res1 7))
	  ((equal? p_s1 "datao")
	   (set! res1 8))
	  ((equal? p_s1 "datae")
	   (set! res1 9)))	  
    
    res1))

;;;; grsp-ann-get-element - Get element number p_n1 from ann p_l1, which
;; is a list of matrices.
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_n1: element number.
;; - p_l1; ann, list.
;;
;; Notes:
;;
;; - See grsp-ann-get-matrix.
;;
;; Output:
;;
;; - One of the elements (matrix) of ann p_l1, as specified by p_n1.
;;
(define (grsp-ann-get-element p_n1 p_l1)
  (let ((res1 0))

    (set! res1 (list-ref p_l1 p_n1))
    
    res1))

;;;; grsp-ann-conns-opmm - Performs operation p_s1 on values and biases
;; of p_a2 and returns results in matrix p_a1 (element 6).
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#++"; result is the summation of the sum of each value per its
;;      bias.
;;   - "#+*": result is the summation of the product of each value per
;;     its bias.
;;   - "#*+": result is the production of the sum of each value per its
;;     bias.
;;   - "#**": result is the production of the product of each value per
;;     its bias.
;;
;; - p_a1: matrix. Data Subset in nodes format.
;; - p_a2: matrix. Data Subset in conns.
;;
;; Output;
;;
;; - Matrix (p_a1).
;;
(define (grsp-ann-conns-opmm p_s1 p_a1 p_a2)
  (let ((res1 0)
	(res2 0)
	(i1 0)
	(n1 0))

    ;; Safety copies.
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))
    
    ;; Cycle conns.
    (let loop ((i1 (grsp-lm res2)))
      (if (<= i1 (grsp-hm res2))

	  (begin (cond ((equal? p_s1 "#++")
			(set! n1 (+ n1
				    (+ (array-ref res2 i1 5)
				       (array-ref res2 i1 7)))))
		       ((equal? p_s1 "#+*")
			(set! n1 (+ n1
				    (* (array-ref res2 i1 5)
				       (array-ref res2 i1 7)))))
		       ((equal? p_s1 "#*+")
			(set! n1 (* n1
				    (+ (array-ref res2 i1 5)
				       (array-ref res2 i1 7)))))
		       ((equal? p_s1 "#**")
			(set! n1 (* n1
				    (* (array-ref res2 i1 5)
				       (array-ref res2 i1 7))))))

		 (display "\n n1 \n")
		 (display n1)
		 (display "\n")
		 
		 (loop (+ i1 1)))))

  ;; Place n6 as the value of the node.
  (array-set! res1 n1 0 6)

  res1))


;;;; grsp-ann-row-idata-bvw - Updates the idata matrix of ann p_l1 by
;; adding rows for matrices nodes and conns in which values for bias,
;; value or weight according to p_s1 are set to value p_n1.
;;
;; - functions, ann, neural, network, idata, configuration, block, batch
;;
;; Parameters:
;;
;; - p_s1: string. For which matrix is this intended.
;;
;;   - "nodes".
;;   - "conns".
;;
;; - p_s2: string. What value of is going to be updated.
;;
;;  - "#bias".
;;  - "#value".
;;  - "#weight".
;;
;; - p_l1: ann. The neural network in question.
;; - p_n1: numeric. New value that will be set.
;;
;; Notes:
;;
;; - "#bias" applies to "nodes" only.
;; - Should be used AFTER using grsp-ds2ann.
;;
(define (grsp-ann-idata-bvw p_s1 p_s2 p_l1 p_n1)
  (let ((res1 '())
	(i1 0)
	(a1 0)
	(a2 0)
	(ii 0)
	(in 0)
	(iv 0)
	(it 0)
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))
   
    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))    
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))
    (set! specs (grsp-ann-get-matrix "specs" p_l1))
    (set! odtid (grsp-ann-get-matrix "odtid" p_l1))
    (set! datai (grsp-ann-get-matrix "datai" p_l1))
    (set! datao (grsp-ann-get-matrix "datao" p_l1))
    (set! datae (grsp-ann-get-matrix "datae" p_l1))    

    (set! a2 (grsp-matrix-cpy idata))
   
    ;; Find the applicable col number.
    (cond ((equal? p_s1 "nodes")
	   (set! a1 (grsp-matrix-cpy nodes))
	   
	   (cond ((equal? p_s2 "#bias")
		  (set! in 5))
		 ((equal? p_s2 "#value")
		  (set! in 6))
		 ((equal? p_s2 "#weight")
		  (set! in 9))))

	  ((equal? p_s1 "conns")
	   (set! a1 (grsp-matrix-cpy conns))
	   
	   (cond ((equal? p_s2 "#value")
		  (set! in 5))
		 ((equal? p_s2 "#weight")
		  (set! in 7)))))
    
    ;; Update rows in the corresponding matrix.
    (set! iv p_n1)

    (cond ((equal? p_s1 "nodes")		 
	   (set! it 0))		 
	  ((equal? p_s1 "conns")
	   (set! it 1)))
    
    (let loop ((i1 (grsp-lm a1)))
      (if (<= i1 (grsp-hm a1))
	   
	  ;Read id.
	  (begin (set! ii (array-ref a1 i1 0))
	  
		 ;; Create idata row (idata should be sorted afterwards).
		 (set! a2 (grsp-matrix-subexp a2 1 0))
		 
		 ;; Update new idata row.
		 (array-set! a2 ii (grsp-hm a2) 0)
		 (array-set! a2 in (grsp-hm a2) 1)
		 (array-set! a2 iv (grsp-hm a2) 2)
		 (array-set! a2 it (grsp-hm a2) 3)	  

	  (loop (+ i1 1)))))
	  
    ;; Compose results.
    (set! idata (grsp-matrix-cpy a2))
    
    (cond ((equal? p_s1 "nodes")
	   (set! nodes (grsp-matrix-cpy a1)))
	  ((equal? p_s1 "conns")
	   (set! conns (grsp-matrix-cpy a1))))

    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))    
    
    res1))


;;;; grsp-ann-delta -Calculates the error signal delta for output p_a1 and
;; expected values p_a2.
;;
;; Keywords:
;;
;; - error, difference, output, delta
;;
;; Parameters;
;;
;; - p_a1: real output data in odata format.
;; - p_a2: expected value per odata register or row in odata format.
;;
;; Output:
;;
;; - Error signal values of output layer in odata format.
;;
(define (grsp-ann-delta p_a1 p_a2)
  (let ((res1 0)
	(n1 0)
	(n2 0))

    ;; Create results matrix.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Go over p_a1 and calculate delta as the difference between
    ;; p_a1 and p_a2 values. Set results in res1.
    (let loop (( i1 (grsp-ln p_a1)))
      (if (<= i1 (grsp-hn p_a1))

	  (begin (set! n1 (array-ref p_a1 i1 3))
		 (set! n2 (array-ref p_a2 i1 3))
		 (array-set! res1 (- n2 n1) i1 3))
		 
		 (loop (+ i1 1))))
    
    res1))


;;;; grsp-ann-bp - Backpropagation algorithm.
;;
;; Keywords:
;;
;; - backpropagation
;;
;; Parameters:
;;
;; - p_l1: list, ann.
;;
;; Output:
;;
;; - List, updated ann.
;;
(define (grsp-ann-bp p_l1)
  (let ((res1 '()))

    res1))


;;;; grsp-m2datae - Casts the last p_j1 columns of a grsp3 matrix as datae
;; format. 
;;
;; Keywords:
;;
;; - functions, ann, neural, network
;;
;; Parameters:
;;
;; - p_a1: data matrix.
;; - p_j1; number of columns assigned to results.
;;
;; Notes: 
;;
;; - See grsp-m2datai.
;; - p_a1 should contain th following columns:
;;
;;   - Col 0 ... Col j-1: training data.
;;   - Col j ... Col j+p_j1: expected results for col 0 ... col j-1.
;;
;; Output:
;;
;; - List containing:
;;
;;   - Elem 0: matrix p_a1 sans the last p_n1 columns, ready to be
;;     processed with grsp-m2datai.
;;   - Elem 1: datae format matrix, can replace current datae or be
;;     appended to it.
;;
(define (grsp-m2datae p_a1 p_j1)
  (let ((res1 '())
	(a1 0)
	(a3 0))

    ;; Create a3.
    (set! a3 (grsp-matrix-create 0 (grsp-tm p_a1) 3))
    
    ;; Loop
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  (begin (array-set! a3 (array-ref p_a1 i1 (grsp-hn p_a1)) i1 0)
		 
		 (loop (+ i1 1)))))

    ;; Cut p_a1.
    (set! a1 (grsp-matrix-subcpy p_a1
				 (grsp-lm p_a1)
				 (grsp-hm p_a1)
				 (grsp-ln p_a1)
				 (- (grsp-hn p_a1) p_j1)))
      
    ;; Compose results.
    (set! res1 (list a1 a3))
    
    res1))


;;;; grsp-ds2ann - Load a dataset p_a1 into neural network p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural, network, training, datasets
;;
;; Parameters:
;;
;; - p_a1: matrix (last p_j1 columns should contain expected results).
;; - p_n1: classifier.
;;
;;   - 0: regular data.
;;   - 1: training data.
;;   - 2: control data.
;;
;; - p_j1; number of columns assigned to results.
;; - p_l1: list, neural network.
;;
;; Notes: 
;;
;; - See grsp-m2datai, grsp-m2datae.
;; - Should be used BEFORE grsp-ann-idata-bvw.
;; - p_a1 should contain the following columns:
;;
;;   - Col 0 ... col j-1: training data.
;;   - Col j ... col j+p_j1: expected results for col 0 ... col j-1.
;;
;; - This function casts dataset matrix into datai format. The ann works
;;   by loading rows corresponding to one epoch into idata.
;;
;; Output:
;;
;; - List (ann).
;;
(define (grsp-ds2ann p_a1 p_n1 p_j1 p_l1)
  (let ((res1 '())
	(l2 '())
	(a1 0)
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))
   
    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))    
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))
    (set! specs (grsp-ann-get-matrix "specs" p_l1))
    (set! odtid (grsp-ann-get-matrix "odtid" p_l1))
    (set! datai (grsp-ann-get-matrix "datai" p_l1))
    (set! datao (grsp-ann-get-matrix "datao" p_l1))
    (set! datae (grsp-ann-get-matrix "datae" p_l1))

    ;; Configure data.
    (set! l2 (grsp-m2datae p_a1 p_j1))
    (set! a1 (list-ref l2 0))
    (set! datae (list-ref l2 1))

    ;; Configure datai.
    (set! datai (grsp-m2datai a1 idata datai p_n1))
    
    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))    
    
    res1))


;;;; grsp-ann-ds-create - Creates "synthetic" datasets with one column
;; results to be used with function grsp-ds2ann.
;;
;; Keywords:
;;
;; - functions, ann, neural, network, training, datasets, random,
;;   simulation
;;
;; Parameters:
;;
;; - p_s1: matrix type. See grsp3.grsp-matrix-create for details.
;; - p_s2: string, operation type. See grsp-matrix-row-opscr for available
;;   operations.
;; - p_m1: rows, positive integer.
;; - p_n1: cols (without counting the results col), positive integer.
;;
;; Notes:
;;
;; - See grsp-ds2ann.
;; - Consider using grsp-random-state-set before this function if you
;;   want to create pseudo-random data with p_s1 value "#rprnd".
;;
;; Output:
;;
;; - Matrix in which the last column contains the results of operation
;;   p_s2 between the column elements of each row.
;;
(define (grsp-ann-ds-create p_s1 p_s2 p_m1 p_n1)
  (let ((res1 0)
	(res2 0)
	(a1 0)
	(a2 0))

    ;; Create matrix.
    (set! a1 (grsp-matrix-create p_s1 p_m1 p_n1))

    ;; Create results vector.
    (set! res2 (grsp-matrix-row-opscr p_s2 a1))

    ;; Merge.
    (set! a2 (grsp-matrix-subexp a1 0 1))
    (set! res1 (grsp-matrix-subrep a2 res2 (grsp-lm a2) (grsp-hn a2)))
    
    res1))


;;;; grsp-ann-nodes-select-linked - Returns a list of two elements
;; containing:
;;
;; - Elem 0: list of connections from node p_n1 to node p_n2.
;; - Elem 1: list of connections from node p_n2 to node p_n1.
;;
;; Keywors:
;;
;; - nodes. related, linked
;;
;; Parameters:
;;
;; - p_l1: list, ANN.
;; - p_n1: numeric, node Id.
;; - p_n2: numeric, node Id.
;;
(define (grsp-ann-nodes-select-linked p_l1 p_n1 p_n2)
  (let ((res1 '())
	(a1 0)
	(a2 0)
	(a3 0)
	(a4 0)
	(conns 0))

    ;; Extract matrices and lists.
    (set! conns (grsp-ann-get-matrix "conns" p_l1))

    ;; Select find connections FROM p_n1 TO p_n2.
    (set! a1 (grsp-matrix-row-select "#=" conns 3 p_n1))
    (set! a2 (grsp-matrix-row-select "#=" a1 4 p_n2))

    ;; Select find connections FROM p_n2 TO p_n1.
    (set! a3 (grsp-matrix-row-select "#=" conns 3 p_n2))
    (set! a4 (grsp-matrix-row-select "#=" a3 4 p_n1))
    
    ;; Compose results.
    (set! res1 (list a2 a4))    

    res1))


;;;; grsp-ann-nodes-select-layer - Selects all nodes of ANN p_l1 located
;; in layer
;; p_n1.
;;
;; Keywords:
;;
;; - nodes, layer
;;
;; Parameters:
;;
;; - p_l1: list, ANN.
;; - p_n1: layer number.
;;
(define (grsp-ann-nodes-select-layer p_l1 p_n1)
  (let ((res1 0)
	(nodes 0))

    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))	

    ;; Select all nodes of layer p_n1
    (set! res1 (grsp-matrix-row-select "#=" nodes 3 p_n1))
    
    res1))


;;;; grsp-ann-nodes-select-st - Selects all nodes of ANN p_l1 of status or
;; type p_s1.
;;
;; Keywords:
;;
;; - nodes, type, status
;;
;; Parameters:
;;
;; - p_l1: list, ANN.
;; - p_s1: string, status or type.
;;
;;   - "dead".
;;   - "inactive".
;;   - "active".
;;   - "input".
;;   - "neuron".
;;   - "output".
;;
(define (grsp-ann-nodes-select-st p_l1 p_s1)
  (let ((res1 0)
	(n1 0)
	(n2 0)
	(nodes 0))

    ;; Extract matrices and lists.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))	
    
    ;; Set col number and value.
    (cond ((equal? p_s1 "dead")
	   (set! n1 1)
	   (set! n2 0))
	  ((equal? p_s1 "inactive")
	   (set! n1 1)
	   (set! n2 1))
	  ((equal? p_s1 "active")
	   (set! n1 1)
	   (set! n2 2))
	  ((equal? p_s1 "input")
	   (set! n1 2)
	   (set! n2 0))
	  ((equal? p_s1 "neuron")
	   (set! n1 2)
	   (set! n2 1))
	  ((equal? p_s1 "output")
	   (set! n1 2)
	   (set! n2 2)))

    ;; Compose results.
    (set! res1 (grsp-matrix-row-select "#=" nodes n1 n2))
        
    res1))


;;;; grsp-ann-id-updat - Change id number of element p_s1 whith id p_n1
;; to id p_n2 in ANN p_l1.
;;
;; Keywords:
;;
;; - key, id
;;
;; Parameters:
;;
;; - p_s1: string, element type.
;;
;;   - "node".
;;   - "conns".
;;
;; - p_l1: list, ANN.
;; - p_n1: numeric, old id.
;; - p_n2: numeric, new id.
;;
;; Notes:
;;
;; - Use with care in order not to mess up the id of elements in your ANN.
;;
(define (grsp-ann-id-update p_s1 p_l1 p_n1 p_n2)
  (let ((res1 '())
	(a1 0)
	(lm 0)
	(hm 0)
	(nodes 0)
	(conns 0)
	(count 0)
	(idata 0)
	(odata 0)
	(specs 0)
	(odtid 0)
	(datai 0)
	(datao 0)	
	(datae 0))
   
    ;; Extract matrices.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))
    (set! conns (grsp-ann-get-matrix "conns" p_l1))
    (set! count (grsp-ann-get-matrix "count" p_l1))    
    (set! idata (grsp-ann-get-matrix "idata" p_l1))
    (set! odata (grsp-ann-get-matrix "odata" p_l1))
    (set! specs (grsp-ann-get-matrix "specs" p_l1))
    (set! odtid (grsp-ann-get-matrix "odtid" p_l1))
    (set! datai (grsp-ann-get-matrix "datai" p_l1))
    (set! datao (grsp-ann-get-matrix "datao" p_l1))
    (set! datae (grsp-ann-get-matrix "datae" p_l1))	

    (cond ((equal? p_s1 "nodes")

	   ;; Change id of the node in nodes.
	   (set! nodes (grsp-matrix-row-update "#=" nodes 0 p_n1 0 p_n2))

	   ;; Change FROM value in conns.
	   (set! conns (grsp-matrix-row-update "#=" conns 3 p_n1 3 p_n2))

	   ;; Change TO value conns.
	   (set! conns (grsp-matrix-row-update "#=" conns 4 p_n1 4 p_n2))
	   
	   ;; Select rows for nodes from idata and change id.
	   (let loop ((i1 lm))
	     (if (<= i1 hm)

		 (begin (cond ((equal? (and (equal? (array-ref idata i1 0) p_n1)
					    (equal? (array-ref idata i1 3) 1)) #t)

			       (array-set! idata p_n2 i1 0)))
		 
			(loop (+ i1 1)))))

	   ;; Change odata.
	   (set! odata (grsp-matrix-row-update "#=" odata 0 p_n1 0 p_n2))

	   ;; Select rows for nodes from datai and change id.
	   (let loop ((i1 lm))
	     (if (<= i1 hm)

		 (begin (cond ((equal? (and (equal? (array-ref datai i1 0) p_n1)
					    (equal? (array-ref datai i1 3) 1)) #t)

			       (array-set! datai p_n2 i1 0)))
		 
			(loop (+ i1 1)))))

	   ;; Change datao.
	   (set! datao (grsp-matrix-row-update "#=" datao 0 p_n1 0 p_n2)))
	   
	  ((equal? p_s1 "conns")

	   ;; Change id of the edge in conns.
	   (set! conns (grsp-matrix-row-update "#="
					       conns
					       0
					       p_n1
					       0
					       p_n2))))
    
    ;; Compose results.
    (set! res1 (list nodes
		     conns
		     count
		     idata
		     odata
		     specs
		     odtid
		     datai
		     datao
		     datae))  

    res1))


;;;;  grsp-ann-node-info - Extracts infro from node identified as p_n1
;; from network p_l1
;;
;; Keywords:
;;
;; - anatomy, extract, info, structure
;;
;; Parameters:
;;
;; - p_l1: list, ANN.
;; - p_n1: numeric. Id of the node to clone.
;;
;; Output:
;;
;; - A list with three elements:
;;
;;   - Elem 0: A matrix row from matrix nodes that corresponds to the node
;;     requested.
;;   - Elem 1: A submatrix from matrix conns with connections TO node
;;     p_n1.
;;   - Elem 2: A submatrix from matrix conns with connections FROM node
;;     p_n1.
;;
;; - Will return empty matrices in case that no node or connections are
;;   found.
;;   Use grsp-matrix-is-empty to verify.
;;
(define (grsp-ann-node-info p_l1 p_n1)
  (let ((res1 '())
	(l2 '())
	(a1 0)
	(b1 #f)
	(nodes 0))
    
    ;; Extract matrices.
    (set! nodes (grsp-ann-get-matrix "nodes" p_l1))

    ;; Check if node with id p_n1 exists and if so, extract info.
    (set! a1 (grsp-matrix-row-select "#=" nodes 0 p_n1))
    (set! b1 (grsp-matrix-is-empty a1))
    
    (cond ((equal? b1 #f)
	       
	   ;; Find conns.
	   (set! l2 (grsp-ann-node-conns p_l1 p_n1))
   
	   ;; Compose results.
	   (set! res1 (list a1 (list-ref l2 0) (list-ref l2 1)))))

    res1))
