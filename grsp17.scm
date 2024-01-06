;; =========================================================================
;; 
;; grsp17.scm
;;
;; Quantum information theory functions.
;;
;; =========================================================================
;;
;; Copyright (C) 2021 - 2024 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;; Sources:
;;
;; See code of functions used and their respective source files for more
;; credits and references.
;;
;; - [1] Quantum computing (2022) Wikipedia. Wikimedia Foundation. Available
;;   at: https://en.wikipedia.org/wiki/Quantum_computing
;;   (Accessed: December 11, 2022). 
;; - [2] Quantum Volume (2022) Wikipedia. Wikimedia Foundation. Available
;;   at: https://en.wikipedia.org/wiki/Quantum_volume
;;   (Accessed: December 11, 2022). 
;; - [3] Bra–Ket Notation (2022) Wikipedia. Wikimedia Foundation. Available
;;   at: https://en.wikipedia.org/wiki/Bra%E2%80%93ket_notation
;;   (Accessed: December 12, 2022). 
;; - [4] W State (2022) Wikipedia. Wikimedia Foundation. Available at:
;;   https://en.wikipedia.org/wiki/W_state (Accessed: December 13, 2022). 
;; - [5] Greenberger–Horne–zeilinger state (2022) Wikipedia. Wikimedia
;;   Foundation. Available at:
;;   https://en.wikipedia.org/wiki/Greenberger%E2%80%93Horne%E2%80%93Zeilinger_state
;;   (Accessed: December 13, 2022).
;; - [6] List of mathematical symbols by subject (2022) Wikipedia. Wikimedia
;;   Foundation. Available at:
;;   https://en.wikipedia.org/wiki/List_of_mathematical_symbols_by_subject
;;   (Accessed: December 15, 2022). 
;; - [7] Multipartite entanglement (2022) Wikipedia. Wikimedia Foundation.
;;   Available at: https://en.wikipedia.org/wiki/Multipartite_entanglement
;;   (Accessed: December 16, 2022).
;; - [8] Many-worlds interpretation (2022) Wikipedia. Wikimedia Foundation.
;;   Available at: https://en.wikipedia.org/wiki/Many-worlds_interpretation
;;   (Accessed: January 6, 2023).
;; - [9] Mathematical universe hypothesis (2023) Wikipedia. Available at:
;;   https://en.wikipedia.org/wiki/Mathematical_universe_hypothesis
;;   (Accessed: 31 July 2023). 


(define-module (grsp grsp17)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp5) 
  #:export (grsp-qit-depth
	    grsp-qit-volume
	    grsp-qit-eeff1
	    grsp-qit-bra
	    grsp-qit-ket
	    grsp-qit-ghz
	    grsp-qit-w))


;;;; grsp-qit-depth - Circuit depth. Number of operations possible before
;; decoherence.
;;
;; Keywords:
;;
;; - quantum, circuit, depth, errors, tolerance
;;
;; Parameters:
;;
;; - p_n1: number of qubits.
;; - p_n2: effective error rate (average error rate of a two-qubit gate).
;;
;; Notes:
;;
;; - Results are in this case approximate.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [2].
;;
(define (grsp-qit-depth p_n1 p_n2)
  (let ((res1 0))

    (set! res1 (/ 1 (* p_n1 p_n2)))
    
    res1))


;;;; grsp-qit-volume - Quantum volume.
;;
;; Keywords:
;;
;; - quantum, circuit, volume, performance, capacity, power
;;
;; Parameters:
;;
;; - p_n1: number of qubits.
;; - p_n2: depth.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [2].
;;
(define (grsp-qit-volume p_n1 p_n2)
  (let ((res1 0))

    (set! res1 (* p_n1 p_n2))

    res1))


;;;; grsp-qit-eeff1 - Effective error rate; average mean error rate of a
;; two - qubit gate.
;;
;; Keywords:
;;
;; - quantum, circuit, volume, performance, errors
;;
;; Parameters:
;;
;; - p_a1: sample matrix.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [2].
;;
(define (grsp-qit-eeff1 p_a1)
  (let ((res1 0))

    (set! res1 (grsp-mean1 p_a1))

    res1))


;;;; grsp-qit-bra - Expresses p_a1 as a bra (row vector) following Dirac
;; notation.
;;
;; Keywords:
;;
;; - quantum, matrices, dirac, bra, ket, dirac
;;
;; Parameters:
;;
;; - p_a1: row vector (bra).
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-quit-bra p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-cpy p_a1))
     
    (cond ((> (grsp-matrix-wlongest p_a1) 0)
	   (set! res1 (grsp-matrix-transpose p_a1))))
	       
    res1))


;;;; grsp-qit-ket - Expresses p_a1 as a ket (column vector) following Dirac
;; notation.
;;
;; Keywords:
;;
;; - quantum, matrices, dirac, bra, ket
;;
;; Parameters:
;;
;; - p_a1: col vector (bra).
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-quit-ket p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-cpy p_a1))
     
    (cond ((< (grsp-matrix-wlongest p_a1) 0)
	   (set! res1 (grsp-matrix-transpose p_a1))))
    
    res1))


;;;; grsp-qit-ghz - Generalized GHZ state.
;;
;; Keywords:
;;
;; - quantum, matrices, dirac, bra, ket, state
;;
;; Parameters:
;;
;; - p_l1: list of ket subsystems.
;;
;; Output:
;;
;; - numeric.
;;
;; Sources:
;;
;; - [5].
;;
(define (grsp-qit-ghz p_l1)
  (let ((res1 0)
	(n1 (/ 1 (sqrt 2))))

    ;; Kronecker product.
    (set! res1 (grsp-matrix-opmml "#(*)" p_l1))
    
    ;; Scalar product.
    (set! res1 (grsp-matrix-opsc "#*" res1 n1))
	  
    res1))


;;;; grsp-qit-w - Generalized W state.
;;
;; Keywords:
;;
;; - quantum, matrices, dirac, bra, ket, state
;;
;; Parameters:
;;
;; - p_l1: list of ket subsystems.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [5].
;;
(define (grsp-qit-w p_l1)
  (let ((res1 0)
	(n1 (/ 1 (length p_l1))))

    ;; Kronecker product.
    (set! res1 (grsp-matrix-opmml "#(*)" p_l1))
    
    ;; Scalar product.
    (set! res1 (grsp-matrix-opsc "#*" res1 n1))
	  
    res1))
