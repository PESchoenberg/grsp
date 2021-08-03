;; grsp13.scm
;;
;; Sequences.
;;
;; =============================================================================
;;
;; Copyright (C) 2021 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;; - [1] En.wikipedia.org. 2021. Collatz conjecture - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Collatz_conjecture
;;   [Accessed 1 August 2021].
;;


(define-module (grsp grsp13)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:export (grsp-seq-hailstorm))


;;;; grsp-seq-hailstorm - Calculates p_m1 elements of a hailstorm number
;; sequence that starts at p_n1.
;;
;; Keywords:
;; - number, sequence, collatz, ulam, kakutani, thwaites, hasse, syracuse, erdos.
;;
;; Arguments:
;; - p_n1: integer > 0.
;; - p_m1: iterations, integer > 0.
;;
;; Notes:
;; - See grsp2.grsp-hailstone-number.
;; - Stopping time is defined as the number of iterations required to reach the
;;   value 1 (one) for the first time.
;;
;; Output:
;; - A list with the following format:
;;   - Elem 0: p_n1.
;;   - Elem 1: p_m1.
;;   - Elem 2: stopping time. Will return NaN if the function does not reach
;;     value 1 (one) in p_m1 iterations.
;;   - Elem 3: a list contaning the actual elements of the sequence.
;;
;; Sources:
;; - [1][grsp2.34].
;;
(define (grsp-seq-hailstorm p_n1 p_m1)
  (let ((res1 '())
	(res2 '())
	(i1 0)
	(st 0)
	(n1 0)
	(n2 0))

    ;; Create a list of p_m1 elements and set the first one to p_n1.
    (set! n1 p_n1)
    (set! res2 (make-list p_m1 0))
    (list-set! res2 i1 n1)

    ;; Generate the second and subsequent elements of the sequence and
    ;; copy their values to the list.
    (set! st (gconst "NaN"))
    (set! i1 1)
    (while (< i1 p_m1)

	   ;; Calculate the next sequence element.
	   (set! n1 (grsp-hailstone-number n1))
	   (list-set! res2 i1 n1)

	   ;; Determine stopping time.
	   (cond ((= n1 1)
		  (set! n2 (in n2))))
	   (cond ((= n2 1)
		  (set! st i1)))
	   
	   (set! i1 (in i1)))

    ;; compose results.
    (set! res1 (list p_n1 p_m1 st res2))
    
    res1))

