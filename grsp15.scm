;; grsp15.scm
;;
;; Polynomials.
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
;; - function, division, fractions.
;;
;; Arguments:
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
;; Arguments:
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
;; Arguments:
;; - p_x1: x.
;; - p_j1: j.
;; - p_a1: matrix, data points.
;;
;; Sources:
;; - [3][4].
;;
(define (grsp-lagrange-bpoly p_x1 p_j1 p_a1)
  (let ((res1 1.0)
	(res2 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(xm 0)
	(xj 0)
	(i1 0)
	(j1 0))
    
    ;; Create safety matrix. 
    (set! res2 (grsp-matrix-cpy p_a1))
	  
    ;; Extract matrix boundaries.
    (set! lm1 (grsp-matrix-esi 1 res2))
    (set! hm1 (grsp-matrix-esi 2 res2))
    (set! ln1 (grsp-matrix-esi 3 res2))
    (set! hn1 (grsp-matrix-esi 4 res2))

    (set! i1 lm1)
    (while (<= i1 hm1)

	   (cond ((equal? (= i1 p_j1) #f)
		  (set! xm (array-ref p_a1 i1 0))
		  (set! xj (array-ref p_a1 p_j1 0))
		  (set! res1 (* res1 (/ (- p_x1 xm) (- xj xm))))))
	   
	   (set! i1 (in i1)))
    
    res1))


;;;; grsp-lagrange-ipoly - Lagrange interpolation polynomial.
;;
;; Keywords:
;; - functions, interpolation, polynomials.
;;
;; Arguments:
;; - p_x1: x.
;; - p_a1: matrix, data points.
;;
;; Sources:
;; - [3][4].
;;
(define (grsp-lagrange-ipoly p_x1 p_a1)
  (let ((res1 0.0)
	(res2 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(x1 0)
	(y1 0))

    ;; Create safety matrix. 
    (set! res2 (grsp-matrix-cpy p_a1))
	  
    ;; Extract matrix boundaries.
    (set! lm1 (grsp-matrix-esi 1 res2))
    (set! hm1 (grsp-matrix-esi 2 res2))
    (set! ln1 (grsp-matrix-esi 3 res2))
    (set! hn1 (grsp-matrix-esi 4 res2))

    ;; Cycle.
    (set! i1 lm1)
    (while (<= i1 hm1)

	   (set! y1 (array-ref res2 i1 (+ ln1 1)))
	   (set! res1 (+ res1 (* y1 (grsp-lagrange-bpoly p_x1 i1 res2))))
	   
	   (set! i1 (in i1)))
    
    res1))

