;; =============================================================================
;; 
;; grsp15.scm
;;
;; Poly-related functions.
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
;; - Read sources for limitations on function parameters.
;; - [1] En.wikipedia.org. 2022. Runge's phenomenon - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Runge%27s_phenomenon
;;   [Accessed 3 January 2022].
;; - [2] En.wikipedia.org. 2022. Chebyshev nodes - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Chebyshev_nodes
;;   [Accessed 3 January 2022].
;; - [3] En.wikipedia.org. 2022. Polynomial interpolation - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Polynomial_interpolation
;;   [Accessed 6 January 2022].
;; - [4] En.wikipedia.org. 2022. Lagrange polynomial - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Lagrange_polynomial
;;   [Accessed 6 January 2022].


(define-module (grsp grsp15)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)  
  #:use-module (ice-9 threads)
  #:export (grsp-runge
	    grsp-chebyshev-node
	    grsp-lagrange-bpoly
	    grsp-lagrange-ipoly))


;;;; grsp-runge - Runge function. 
;;
;; Keywords:
;; - functions, division, fractions, polynomials.
;;
;; Parameters:
;; - p_n1.
;;
;; Sources:
;; - [1][2].
;;
(define (grsp-runge p_n1)
  (let ((res1 0.0))

    (set! res1 (/ 1 (+ 1 (* 25 (expt p_n1 2)))))

    res1))


;;;; grsp-chebyshev-node - Calculates Chebyshev polynomial root p_k1 of p_n1
;; over the interval [p_a1, p_b1].
;;
;; Keywords:
;; - functions, interpolation, polynomials.
;;
;; Parameters:
;; - p_a1: a.
;; - p_b1: b.
;; - p_k1: k.
;; - p_n1: n.
;;
;; Sources:
;; - [1][2].
;;
(define (grsp-chebyshev-node p_a1 p_b1 p_k1 p_n1)
  (let ((res1 0)
	(k1 0))

    (set! res1 (+ (* 0.5 (+ p_a1 p_b1))
		  (* 0.5
		     (- p_b1 p_a1)
		     (cos (* (/ (- (* 2 p_k1) 1) (* 2 p_n1))
			     (grsp-pi))))))
    
    res1))


;;;; grsp-lagrange-bpoly - Lagrange basis polynomial.
;;
;; Keywords:
;; - functions, interpolation, polynomials.
;;
;; Parameters:
;; - p_x1: x.
;; - p_j1: j.
;; - p_a1: matrixwith data points.
;;
;; Sources:
;; - [3][4].
;;
(define (grsp-lagrange-bpoly p_x1 p_j1 p_a1)
  (let ((res1 1.0)
	(res2 0)
	(xm 0)
	(xj 0)
	(j1 0))
    
    ;; Create safety matrix. 
    (set! res2 (grsp-matrix-cpy p_a1))

    ;; Cycle.
    (let loop ((i1 (grsp-lm res2)))
      (if (<= i1 (grsp-hm res2))
	  (begin (cond ((equal? (= i1 p_j1) #f)
			(set! xm (array-ref p_a1 i1 0))
			(set! xj (array-ref p_a1 p_j1 0))
			(set! res1 (* res1 (/ (- p_x1 xm) (- xj xm))))))
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-lagrange-ipoly - Lagrange interpolation polynomial.
;;
;; Keywords:
;; - functions, interpolation, polynomials.
;;
;; Parameters:
;; - p_x1: x.
;; - p_a1: matrix, data points.
;;
;; Sources:
;; - [3][4].
;;
(define (grsp-lagrange-ipoly p_x1 p_a1)
  (let ((res1 0.0)
	(res2 0)
	(x1 0)
	(y1 0))

    ;; Create safety matrix. 
    (set! res2 (grsp-matrix-cpy p_a1))

    ;; Cycle.
    (let loop ((i1 (grsp-lm res2)))
      (if (<= i1 (grsp-hm res2))
	  (begin (set! y1 (array-ref res2 i1 (+ (grsp-ln res2) 1)))
		 (set! res1 (+ res1 (* y1 (grsp-lagrange-bpoly p_x1 i1 res2))))
		 (loop (+ i1 1)))))
    
    res1))

