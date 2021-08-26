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
;; - Always take into account the odd behavior of numeric sequences before use.
;;
;; Sources:
;; - [1] En.wikipedia.org. 2021. Collatz conjecture - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Collatz_conjecture
;;   [Accessed 1 August 2021].
;; - [2] Es.wikipedia.org. 2021. Serie (matemática) - Wikipedia, la enciclopedia
;;   libre. [online] Available at:
;;   https://es.wikipedia.org/wiki/Serie_(matem%C3%A1tica)
;;   [Accessed 6 August 2021].
;; - [3] Es.wikipedia.org. 2021. Fracción continua - Wikipedia, la enciclopedia
;;   libre. [online] Available at:
;;   https://es.wikipedia.org/wiki/Fracci%C3%B3n_continua
;;   [Accessed 8 August 2021].
;; - [4] Es.wikipedia.org. 2021. Criterio del cociente - Wikipedia, la
;;   enciclopedia libre. [online] Available at:
;;   https://es.wikipedia.org/wiki/Criterio_del_cociente
;;   [Accessed 8 August 2021].
;; - [5] En.wikipedia.org. 2021. Harmonic series (mathematics) - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Harmonic_series_(mathematics)
;;   [Accessed 9 August 2021].
;;


(define-module (grsp grsp13)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp4)  
  #:export (grsp-seq-hailstorm
	    grsp-seq-geometric
	    grsp-seq-hyperarmonic))


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
;;   - Elem 3: a list containing the actual elements of the sequence.
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

    ;; Compose results.
    (set! res1 (list p_n1 p_m1 st res2))
    
    res1))


;;;; grsp-seq-geometric - Calculates a geometric convergent series.
;;
;; Keywords:
;; - number, sequence, geometric, convergent.
;;
;; Arguments:
;; - p_b1:
;;   - #t: calculated terms of the series will be returned.
;;   - #f: calculated terms of the series will not be returned.
;; - p_n1: number > 0.
;; - p_m1: iterations, integer > 0.
;; - p_r1: common ratio. Number with (abs p_r1) < 1.
;;
;; Notes:
;; - Will generally converge to (= s (/ p_n1 (- 1 p_r1)))
;;
;; Output:
;; - A list with the following format:
;;   - Elem 0: p_n1.
;;   - Elem 1: p_m1.
;;   - Elem 2: Convergence goal.
;;   - Elem 3: Convergence delta.
;;   - Elem 4: actual result of the summation.
;;   - Elem 4: list of series elements calculated to p_m1 iterations of the
;;     series summation (shown only if p_b1 is passed #t).
;;
;; Sources:
;; - [2].
;;
(define (grsp-seq-geometric p_b1 p_n1 p_m1 p_r1)
  (let ((res1 0)
	(res2 '())
	(res3 '())
	(i1 0)
	(n2 0)
	(cg 0)
	(cd 0)
	(n1 0)
	(m1 0)
	(r1 0)
	(b1 #f))

    (set! n1 p_n1)
    (set! m1 p_m1)
    (set! r1 p_r1)
    (set! b1 p_b1)
    (cond ((equal? b1 #t)
	   (set! res3 (make-list m1 0))))

    ;; Estimated convergence goal.
    (set! cg (/ n1 (- 1 r1)))
    
    (while (< i1 m1)
	   (set! n2 (* n1 (expt r1 i1)))
	   (cond ((equal? b1 #t)
		  (list-set! res3 i1 n2)))
	   (set! res1 (+ res1 n2))
	   (set! i1 (in i1)))

    ;; Convergence delta.
    (set! cd (- cg res1)) 

    ;; Compose results.
    (set! res2 (list n1 m1 cg cd res1 res3))

    res2))


;;;; grsp-seq-hyperarmonic - Calculates a hyperarmonic series.
;;
;; Keywords:
;; - number, sequence, harmonic, hyper, convergent.
;;
;; Arguments:
;; - p_b1:
;;   - #t: calculated terms of the series will be returned.
;;   - #f: calculated terms of the series will not be returned.
;; - p_n1: number > 0 (generally 1).
;; - p_m1: iterations, integer > 0.
;; - p_p1: p factor. If p_p1 > 0, the series converges to Z(p_p1).
;;
;; Output:
;; - A list with the following format:
;;   - Elem 0: p_n1.
;;   - Elem 1: p_m1.
;;   - Elem 2: Convergence goal.
;;   - Elem 3: Convergence delta.
;;   - Elem 4: actual result of the summation.
;;   - Elem 4: list of series elements calculated to p_m1 iterations of the
;;     series summation (shown only if p_b1 is passed #t).
;;
;; Sources:
;; - [2][5][grsp4.12].
;;    
(define (grsp-seq-hyperarmonic p_b1 p_s1 p_n1 p_m1 p_m2 p_p1)
  (let ((res1 0.0)
	(res2 '())
	(res3 '())
	(i1 1)
	(i2 0.0)
	(n2 0.0)
	(cg 0.0)
	(cd 0.0)
	(n1 0.0)
	(m1 0)
	(p1 0.0)
	(b1 #f))

    (set! n1 p_n1)
    (set! m1 p_m1)
    (set! p1 p_p1)
    (set! b1 p_b1)
    (cond ((equal? b1 #t)
	   (set! res3 (make-list m1 0))))

    ;; Estimated convergence goal.
    (set! cg (grsp-opz (grsp-complex-riemann-zeta #t p_s1 p_n1 m1 p_m2)))

    ;; Cycle.
    (while (<= i1 m1)
	   (set! i2 (- i1 1))
	   (set! n2 (/ 1 (expt i1 p1)))
	   (set! res1 (+ res1 n2))
	   (cond ((equal? b1 #t)
		  (list-set! res3 i2 n2)))	   
	   (set! i1 (in i1)))

    ;; Convergence delta.
    (set! cd (- cg res1)) 

    ;; Compose results.
    (set! res2 (list n1 m1 cg cd res1 res3))

    res2))
