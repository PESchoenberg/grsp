;; =============================================================================
;; 
;; grsp17.scm
;;
;; Quantum information theory functions.
;;
;; =============================================================================
;;
;; Copyright (C) 2021 - 2022 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;;
;; - Read sources for limitations on function parameters.
;;
;; Sources:
;;
;; - [1] https://en.wikipedia.org/wiki/Quantum_computing
;; - [2] https://en.wikipedia.org/wiki/Quantum_volume


(define-module (grsp grsp17)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:export (grsp-qit-depth))


;;;; grsp-qit-depth - Circuit depth.
;;
;; Keywords:
;;
;; - quantum, circuit, depth, errors
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
;; Sources:
;;
;; - [2].
;;
(define (grsp-qit-depth p_n1 p_n2)
  (let ((res1 0))

    (set! res1 (/ 1 (* p_n1 p_n2)))
    
    res1))
