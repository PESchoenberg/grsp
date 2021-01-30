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
  #:export (grsp-ann-define-net
	    ;;grsp-ann-define-node
	    ;;grsp-ann-define-conn
	    grsp-ann-neuron))


;; grsp-ann-define-net - Define a new neural network.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Output:
;; - A list with two elements. The first is a matix for the definition
;;   of nodes. The second, a matrix for the definition of connections
;;   between those nodes, according to:
;;
;;   - nodes:
;;     - Col 0: id.
;;     - Col 1: status.
;;     - Col 2: type.
;;     - Col 3: bias.
;;     - Col 4: output value.
;;     - Col 5: associated function.
;;     - Col 6: evol.
;;     - Col 7: weight.
;;   - conns:
;;     - Col 0: id.
;;     - Col 1: status.
;;     - Col 2: type.
;;     - Col 3: bias.
;;     - Col 4: output value.
;;     - Col 5: associated function.
;;     - Col 6: evol.
;;     - Col 7: weight.
;;
;;
;;
;;
(define (grsp-ann-define-net)
  (let ((nodes 0)
	(conns 0)
	(res1 '()))

    ;; Create matrices with one row.
    (set! nodes (grsp-matrix-create 0 1 7))
    (set! conns (grsp-matrix-create 0 1 7))

    ;; Results.
    (set! res1 (list nodes conns))
    
    res1))

;; grsp-ann-neuron - Process neurons.
;;
;; Keywords:
;; - function, ann, neural network.
;;
(define (grsp-ann-neuron p_l1)
  (let ((res1 0)
	(nodes 0)
	(conns 0))

    (set! nodes (car p_l1))
    (set! conns (cadr p_l1))

    res1))
