;; =============================================================================
;;
;; grsp4.scm
;;
;; Complex functions and complex-related code.
;;
;; =============================================================================
;;
;; Copyright (C) 2020 - 2023 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;; - [1] Gnu.org. 2020. Complex (Guile Reference Manual). [online] Available at:
;;   https://www.gnu.org/software/guile/manual/html_node/Complex.html
;;   [Accessed 24 July 2020].
;; - [2] En.wikipedia.org. 2020. Mandelbrot Set. [online] Available at:
;;   https://en.wikipedia.org/wiki/Mandelbrot_set [Accessed 4 October 2020].
;; - [3] En.wikipedia.org. 2020. Feigenbaum Constants. [online] Available at:
;;   https://en.wikipedia.org/wiki/Feigenbaum_constants
;;   [Accessed 5 October 2020].
;; - [4] En.wikipedia.org. 2020. Dirichlet Eta Function. [online] Available at:
;;   https://en.wikipedia.org/wiki/Dirichlet_eta_function
;;   [Accessed 10 November 2020].
;; - [5] En.wikipedia.org. 2020. Gamma Function. [online] Available at:
;;   https://en.wikipedia.org/wiki/Gamma_function [Accessed 24 November
;;   2020].
;; - [6] En.wikipedia.org. 2020. Fibonacci Number. [online] Available at:
;;   https://en.wikipedia.org/wiki/Fibonacci_number#Binet's_formula
;;   [Accessed 5 November 2020].
;; - [7] En.wikipedia.org. 2020. Digamma Function. [online] Available at:
;;   https://en.wikipedia.org/wiki/Digamma_function [Accessed 1 December 2020].
;; - [8] En.wikipedia.org. 2020. Incomplete Gamma Function. [online] Available
;;   at: https://en.wikipedia.org/wiki/Incomplete_gamma_function
;;   [Accessed 9 December 2020].
;; - [10] En.wikipedia.org. 2021. Confluent hypergeometric function. [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/Confluent_hypergeometric_function
;;   [Accessed 19 February 2021].
;; - [11] En.wikipedia.org. 2021. Error function - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Error_function
;;   [Accessed 23 August 2021].
;; - [12] En.wikipedia.org. 2021. Riemann zeta function - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Riemann_zeta_function
;;   [Accessed 23 August 2021].
;; - [13] En.wikipedia.org. 2021. Analytic continuation - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Analytic_continuation
;;   [Accessed 23 August 2021].
;; - [14] Mathworld.wolfram.com. 2021. Riemann Zeta Function -- from Wolfram
;;   MathWorld. [online] Available at:
;;   https://mathworld.wolfram.com/RiemannZetaFunction.html
;;   [Accessed 23 August 2021].
;; - [15] Jagy, W., Riedel, M. and Fischer, D., 2021. Riemann zeta for real
;;   argument between 0 and 1 using Mellin, with short asymptotic expansion.
;;   [online] Mathematics Stack Exchange. Available at:
;;   https://math.stackexchange.com/questions/2597478/riemann-zeta-for-real-argument-between-0-and-1-using-mellin-with-short-asymptot
;;   [Accessed 23 August 2021].
;; - [16] Es.wikipedia.org. 2021. Número de Bernoulli - Wikipedia, la
;;   enciclopedia libre. [online] Available at:
;;   https://es.wikipedia.org/wiki/N%C3%BAmero_de_Bernoulli
;;   [Accessed 25 August 2021].
;; - [17] En.wikipedia.org. 2022. Dual number - Wikipedia. [online] Available at
;;   https://en.wikipedia.org/wiki/Dual_number [Accessed 24 February 2022].


(define-module (grsp grsp4)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)  
  #:use-module (grsp grsp2)
  #:export (grsp-complex-inv-imag
	    grsp-complex-inv-real
	    grsp-complex-inv
	    grsp-complex-sign
	    grsp-complex-logistic
	    grsp-complex-mandelbrot
	    grsp-complex-binet
	    grsp-complex-dirichlet-eta
	    grsp-complex-f1
	    grsp-complex-gamma-euler
	    grsp-complex-gamma-weierstrass
	    grsp-complex-gamma
	    grsp-complex-pigamma
	    grsp-complex-lngamma
	    grsp-complex-digamma
	    grsp-complex-ligamma
	    grsp-complex-llgamma
	    grsp-complex-uigamma
	    grsp-complex-prgamma
	    grsp-complex-qrgamma
	    grsp-complex-chm
	    grsp-complex-chu
	    grsp-complex-erf
	    grsp-complex-erfi
	    grsp-complex-erfc
	    grsp-complex-erfci
	    grsp-complex-riemann-zeta
	    grsp-complex-riemann-fezeta
	    grsp-complex-riemann-euzeta
	    grsp-complex-riemann-cszeta
	    grsp-complex-bernoulli-number
	    grsp-complex-eif
	    grsp-mr))
  

;;;; grsp-complex-inv-imag - Calculates the inverse of the imaginary
;; component of a complex number.
;;
;; Keywords:
;;
;; - complex, inverse
;;
;; Parameters:
;;
;; - p_z1: complex number.
;;
;; Output:
;;
;; - The conjugate of p_z1 (imaginary part negated).
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-complex-inv-imag p_z1)
  (let ((res1 0)
	(vr 0)
	(vi 0))

    (cond ((complex? p_z1)
	   (set! vr (real-part p_z1))
	   (set! vi (* -1 (imag-part p_z1)))
	   (set! res1 (make-rectangular vr vi)))
	  (else ((set! res1 p_z1))))

    res1))


;;;; grsp-complex-inv-real - Calculates the inverse of the real component of a
;; complex number.
;;
;; Keywords:
;;
;; - complex, inverse
;;
;; Parameters:
;;
;; - p_z1: complex number.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-complex-inv-real p_z1)
  (let ((res1 0)
	(vr 0)
	(vi 0))

    (cond ((complex? p_z1)
	   (set! vr (* -1 (real-part p_z1)))
	   (set! vi (imag-part p_z1))
	   (set! res1 (make-rectangular vr vi)))
	  (else ((set! res1 (* -1 p_z1)))))

    res1))


;;;; grsp-complex-inv - Calculates various inverses of complex numbers.
;;
;; Keywords:
;;
;; - complex, inverse
;;
;; Parameters:
;;
;; - p_s1: operation.
;;
;;   - "#si": inverts the imaginary component only.
;;   - "#is": inverts the real component only.
;;   - "#ii": inverts both.
;;
;; - p_z1: complex number.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-complex-inv p_s1 p_z1)
  (let ((res1 p_z1)
	(vr 0)
	(v 0))

    (cond ((equal? p_s1 "#si")
	   (set! res1 (grsp-complex-inv-imag res1)))
	  ((equal? p_s1 "#is")
	   (set! res1 (grsp-complex-inv-real res1)))
	  ((equal? p_s1 "#ii")
	   (set! res1 (grsp-complex-inv-imag res1))
	   (set! res1 (grsp-complex-inv-real res1))))	  

    res1))


;;;; grsp-complex-sign - Returns a list containing boolean values indicating
;; the signs of the real and imaginary parts of a complex number.
;;
;; Keywords:
;;
;; - complex, signage
;;
;; Parameters:
;;
;; - p_z1: complex number.
;;
;; Output:
;;
;; - (1 1) if both components are positive or real is positive and
;;   imaginary is zero.
;; - (-1 -1) if both components are negative.
;; - (-1 1) if the real component is negative and the imaginary positive or
;;   zero.
;; - (1 -1) if the real component is positive and the imaginary is negative.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-complex-sign p_z1)
  (let ((res1 '())
	(vr 0)
	(vi 0))

    (cond ((complex? p_z1)
	   (set! vr (grsp-sign (real-part p_z1)))
	   (set! vi (grsp-sign (imag-part p_z1))))	  
	  (else ((set! vr (grsp-sign p_z1))
		 (set! vi 1))))
    
    (set! res1 (list vr vi))
    
    res1))


;;;; grsp-complex-logistic - Logistic map equation. Pseudo-random number
;; generator.
;;
;; Keywords:
;;
;; - complex, aleatory, random
;;
;; Parameters:
;;
;; - p_r1: growth rate.
;; - p_x1: number, init.
;;
;; Sources:
;;
;; - [2][3].
;;
(define (grsp-complex-logistic p_r1 p_x1)
  (let ((res1 0))

    (set! res1 (* p_r1 (* p_x1 (- 1 p_x1))))

    res1))


;;;; grsp-complex-mandelbrot - Quadratic map function for the Mandelbrot set.
;;
;; Keywords:
;;
;; - complex, fractals
;;
;; Parameters:
;;
;; - p_z1.
;; - p_c1.
;;
;; Sources:
;;
;; - [2][3].
;;
(define (grsp-complex-mandelbrot p_z1 p_c1)
  (let ((res1 0))

    (set! res1 (+ (expt p_z1 2) p_c1))

    res1))


;;;; grsp-complex-binet - Closed form expression of the Fibonacci sequence. It
;; provides as a result the p_n1th value of the Fibonnaci series. 
;;
;; Keywords:
;;
;; - complex, sequences
;;
;; Parameters:
;;
;; - p_z1: ordinal of the desired Fibonacci number.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-complex-binet p_z1)
  (let ((res1 0)
	(g1 (grsp-phi)))

    (set! res1 (/ (- (expt g1 p_z1)
		     (expt (- 1 g1) p_z1))
		  (sqrt 5)))

    res1))


;;;; grsp-complex-dirichlet-eta - Dirichlet eta function.
;;
;; Keywords:
;;
;; - complex
;;
;; Parameters:
;;
;; - p_s1: s.
;; - p_l1: iterations.
;;
;; Sources:
;;
;; - [4].
;;
(define (grsp-complex-dirichlet-eta p_s1 p_l1)
  (let ((res1 0))

    (let loop ((i1 1))
      (if (< i1 p_l1)
	  (begin (set! res1 (+ res1 (/ (expt -1 (- i1 1)) (expt i1 p_s1))))
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-complex-f1 - Solves (p_a1 * (p_x1**p_n1)) / (1 + (p_a2 (p_x1**p_b2)))
;;
;; Keywords:
;;
;; - complex
;;
;; Parameters:
;;
;; - p_a1.
;; - p_a2.
;; - p_x1.
;; - p_n1.
;; - p_n2.
;;
(define (grsp-complex-f1 p_a1 p_a2 p_x1 p_n1 p_n2)
  (let ((res1 0))

    (set! res1 (/ (* p_a1 (expt p_x1 p_n1))
		  (+ 1 (* p_a2 (expt p_x1 p_n2)))))

    res1))


;;;; grsp-complex-gamma-euler - Complex extension of the gamma function
;; according to Euler's infinite product representation. 
;;
;; Keywords:
;;
;; - complex, gamma
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_z1: complex.
;; - p_n1: desired product iterations.
;;
;; Output:
;;
;; - For negative integers, the function returns +inf.0 (Riemann sphere).
;;
;; Sources:
;;
;; - [5].
;;
(define (grsp-complex-gamma-euler p_b2 p_z1 p_n1)
  (let ((res1 0)
	(res2 1)
	(res3 0)
	(res4 0)
	(defined #t))

    (cond ((integer? p_z1)
	   (cond ((< p_z1 0)
		  (set! defined #f)))))
    
    (cond ((eq? defined #t)

	   (let loop ((i1 1))
	     (if (<= i1 p_n1)
		 (begin (set! res3 (expt (+ 1 (/ 1 i1)) p_z1))
			(set! res4 (+ 1 (/ p_z1 i1)))
			(set! res2 (* res2 (/ res3 res4)))
			(loop (+ i1 1)))))
	   
	   
	   (set! res1 (* 1.00 (/ 1 p_z1) res2)))
	  ((eq? defined #f)
	   (set! res1 +inf.0)))

    ;; Compose results.    
    (set! res1 (grsp-intifint p_b2 p_z1 res1))
    
    res1))


;;;; grsp-complex-gamma-weierstrass - Complex extension of the gamma function
;; according to Weierstrass.
;;
;; Keywords:
;;
;; - complex, gamma
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_z1: complex.
;; - p_n1: desired product iterations.
;;
;; Output:
;;
;; - For negative integers, the function returns +inf.0 (Riemann sphere).
;;
;; Sources:
;;
;; - [5].
;;
(define (grsp-complex-gamma-weierstrass p_b2 p_z1 p_n1)
  (let ((res1 0)
	(res2 1)
	(e1 (grsp-e))
	(g1 (grsp-em))
	(z2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(defined #t))

    (cond ((integer? p_z1)
	   (cond ((< p_z1 0)
		  (set! defined #f)))))
    
    (cond ((eq? defined #t)

	   ;; Cycle.
	   (set! res3 (/ (expt e1 (* -1 g1 p_z1)) p_z1))
	   (let loop ((i1 1))
	     (if (<= i1 p_n1)
		 (begin (set! z2 (/ p_z1 i1))
			(set! res4 (/ 1 (+ 1 z2)))
			(set! res5 (expt e1 z2))
			(set! res2 (* res2 res4 res5))
			(loop (+ i1 1)))))	   
	   
	   (set! res1 (* 1.00 res3 res2)))
	  ((eq? defined #f)
	   (set! res1 +inf.0)))

    ;; Compose results.    
    (set! res1 (grsp-intifint p_b2 p_z1 res1))
    
    res1))


;;;; grsp-complex-gamma - Calculates gamma using different representations. 
;;
;; Keywords:
;;
;; - complex, gamma
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_z1: complex.
;; - p_n1: desired product iterations.
;;
;; Sources:
;;
;; - [5].
;;
(define (grsp-complex-gamma p_b2 p_s1 p_z1 p_n1)
  (let ((res1 0)
	(s1 "#e"))

    (cond ((equal? p_s1 "#w")
	   (set! s1 p_s1)))
    
    (cond ((equal? s1 "#e")
	   (set! res1 (grsp-complex-gamma-euler p_b2 p_z1 p_n1)))
	  ((equal? s1 "#w")
	   (set! res1 (grsp-complex-gamma-weierstrass p_b2 p_z1 p_n1))))

    res1))


;;;; grsp-complex-pigamma - Pi Gauss function. Calculates gamma for p_z1 + 1.
;;
;; Keywords:
;;
;; - complex, gamma
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_z1: complex.
;; - p_n1: desired product iterations.
;;
;; Sources:
;;
;; - [5].
;;
(define (grsp-complex-pigamma p_b2 p_s1 p_z1 p_n1)
  (let ((res1 0)
	(z2 (+ p_z1 1)))

    (set! res1 (grsp-complex-gamma p_b2 p_s1 z2 p_n1))
    
    res1))


;;;; grsp-complex-lngamma - Calculates the natural logarithm of gamma.
;;
;; Keywords:
;;
;; - complex, gamma, log
;;
;; Parameters:
;;
;; - p_z1: complex.
;; - p_n1: desired product iterations.
;;
;; Notes:
;;
;; - TODO: still needs some checking.
;;
;; Sources:
;;
;; - [5].
;;
(define (grsp-complex-lngamma p_z1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(res6 0))

    ;; - yz.
    (set! res2 (* -1 (grsp-em) p_z1))

    ;; - ln z.
    (set! res3 (* -1 (log p_z1)))

    ;; Summation.
    (let loop ((i1 1))
      (if (<= i1 p_n1)
	  (begin (set! res5 (/ p_z1 i1))
		 (set! res4 (- res5 (log (+ 1 res5))))
		 (set! res6 (+ res6 res4))
		 (loop (+ i1 1)))))

    ;; Compose.
    (set! res1 (+ res2 res3 res6))
	  
    res1))


;;;; grsp-complex-digamma - Digamma function for p_z1 - 1.
;;
;; Keywords:
;;
;; - complex, digamma
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_z1: complex.
;; - p_n1: Desired product iterations.
;;
;; Sources:
;;
;; - [5].
;;
(define (grsp-complex-digamma p_b2 p_z1 p_n1)
  (let ((res1 0)
	(res2 1)
	(z2 (- p_z1 1))
	(defined #t))

    (cond ((integer? z2)
	   (cond ((< z2 0)
		  (set! defined #f)))))
    
    (cond ((eq? defined #t)

	   (let loop ((i1 1))
	     (if (<= i1 p_n1)
		 (begin (set! res2 (/ z2 (* i1 (+ i1 z2))))
			(loop (+ i1 1)))))
	   
	   (set! res1 (* -1.00 (grsp-em) res2)))
	  ((eq? defined #f)
	   (set! res1 +inf.0)))

    ;; Compose results.    
    (set! res1 (grsp-intifint p_b2 z2 res1))
    
    res1))


;;;; grsp-complex-ligamma - Lower incomplete gamma function.
;;
;; Keywords:
;;
;; - complex, ligamma, gamma
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_z1: complex.
;; - p_z2: complex.
;; - p_n1: Desired product iterations.
;;
;; Sources:
;;
;; - [5][7].
;;
(define (grsp-complex-ligamma p_b2 p_s1 p_z1 p_z2 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0))

    (set! res1 (* (expt p_z2 p_z1)
		  (grsp-complex-gamma p_b2 p_s1 p_z1 p_n1)
		  (grsp-complex-llgamma p_b2 p_s1 p_z1 p_z2 p_n1)))

    res1))


;;;; grsp-complex-llgamma - Lower incomplete limiting gamma function.
;;
;; Keywords:
;;
;; - complex, ligamma
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_z1: complex.
;; - p_z2: complex.
;; - p_n1: Desired product iterations.
;;
;; Sources:
;;
;; - [5][7].
;;  
(define (grsp-complex-llgamma p_b2 p_s1 p_z1 p_z2 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0))

    ;; res2.
    (set! res2 (expt (grsp-e) (* -1 p_z2)))

    ;; res3.
    (let loop ((i1 0))
      (if (<= i1 p_n1)
	  (begin (set! res3 (+ res3 (/ (expt p_z2 i1)
				       (grsp-complex-gamma p_b2 p_s1 (+ p_z1 i1 1) p_n1))))
		 (loop (+ i1 1)))))
    
    ;; Compose results.
    (set! res1 (* res2 res3))

    res1))


;;;; grsp-complex-uigamma - Upper incomplete gamma function.
;;
;; Keywords:
;;
;; - complex, uigamma
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_z1: complex.
;; - p_z2: complex.
;; - p_n1: Desired product iterations.
;;
;; Sources:
;;
;; - [5][7].
;; 
(define (grsp-complex-uigamma p_b2 p_s1 p_z1 p_z2 p_n1)
  (let ((res1 0))

    (set! res1 (- (grsp-complex-gamma p_b2 p_s1 p_z1 p_n1)
      		  (grsp-complex-ligamma p_b2 p_s1 p_z1 p_z2 p_n1))) 

    res1))


;;;; grsp-complex-prgamma - Lower regularized gamma function P.
;;
;; Keywords:
;;
;; - complex, prgamma
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_z1: complex.
;; - p_z2: complex.
;; - p_n1: Desired product iterations.
;;
;; Sources:
;;
;; - [5][7].
;; 
(define (grsp-complex-prgamma p_b2 p_s1 p_z1 p_z2 p_n1)
  (let ((res1 0))

    (set! res1 (/ (grsp-complex-ligamma p_b2 p_s1 p_z1 p_z2 p_n1)
		  (grsp-complex-gamma p_b2 p_s1 p_z1 p_n1)))

    res1))


;;;; grsp-complex-qrgamma - Lower regularized gamma function Q.
;;
;; Keywords:
;;
;; - complex, qrgamma
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_z1: complex.
;; - p_z2: complex.
;; - p_n1: Desired product iterations.
;;
;; Sources:
;;
;; - [5][7].
;; 
(define (grsp-complex-qrgamma p_b2 p_s1 p_z1 p_z2 p_n1)
  (let ((res1 0))

    (set! res1 (- 1 (grsp-complex-prgamma p_b2 p_s1 p_z1 p_z2 p_n1)))

    res1))
    

;;;; grsp-complex-kummer-ch1 - Kummer's complex hypergeometric function (M).
;;
;; Keywords:
;;
;; - complex, hypergeometric
;;
;; Parameters:
;;
;; - p_a1: a.
;; - p_b1: b.
;; - p_z1: z.
;; - p_n1: iterations.
;;
;; Sources:
;;
;; - [10].
;;
(define (grsp-complex-chm p_a1 p_b1 p_z1 p_n1)
  (let ((res1 0)
	(n2 0)
	(n3 0))

    (let loop ((i1 0))
      (if (< i1 p_n1)
	  (begin (set! n2 (* (grsp-fact-upp p_a1 i1) (expt p_z1 i1)))
		 (set! n3 (* (grsp-fact-upp p_b1 i1) (grsp-fact i1)))
		 (set! res1 (+ res1 (/ n2 n3)))
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-complex-chu - Tricomi's complex hypergeometric function (U).
;;
;; Keywords:
;;
;; - complex, hypergeometric
;;
;; Parameters:
;;
;; - p_a1: a.
;; - p_b1: b. Non-integer.
;; - p_z1: z.
;; - p_n1: iterations (M component).
;; - p_b2: see grsp4.grsp-complex-gamma.
;; - p_s2: see grsp4.grsp-complex-gamma.
;; - p_n2; see grsp4.grsp-complex-gamma.
;;
;; Sources:
;;
;; - [10].
;;
(define (grsp-complex-chu p_a1 p_b1 p_z1 p_n1 p_b2 p_s2 p_n2)
  (let ((res1 0)
	(i1 0)
	(n21 0)
	(n22 0)
	(n31 0)
	(n32 0))
    
    ;; First term.
    (set! n21 (/ (grsp-complex-gamma p_b2 p_s2 (- 1 p_b1) p_n2)
		 (grsp-complex-gamma p_b2 p_s2 (+ p_a1 (- 1 p_b1)) p_n2)))
    (set! n22 (grsp-complex-chm p_a1 p_b1 p_z1 p_n1))

    ;; Second term.
    (set! n31 (* (/ (grsp-complex-gamma p_b2 p_s2 (- p_b1 1) p_n2)
		    (grsp-complex-gamma p_b2 p_s2 p_a1 p_n2))
		 (expt p_z1 (- 1 p_b1))))
    (set! n32 (grsp-complex-chm (+ p_a1 (- 1 p_b1)) (- 2 p_b1) p_z1 p_n1))
    
    ;; Compose results.
    (set! res1 (+ (* n21 n22) (* n31 n32)))
    
    res1))


;;;; grsp-complex-erf - Gauss error function.
;;
;; Keywords:
;;
;; - complex, gauss
;;
;; Parameters:
;;
;; - p_z1: complex.
;; - p_n1: iterations.
;;
;; Sources:
;;
;; - [11].
;;
(define (grsp-complex-erf p_z1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(res6 0))

    ;; res2.
    (set! res2 (/ 2 (sqrt (grsp-pi))))

    ;; res3.
    (let loop ((i1 0))
      (if (< i1 p_n1)
	  (begin (set! res6 (+ (* 2 i1) 1))
		 (set! res4 (* (expt -1 i1) (expt p_z1 res6)))
		 (set! res5 (* (grsp-fact i1) res6))
		 (set! res3 (+ res2 (/ res4 res5)))
		 (loop (+ i1 1)))))    
    
    ;; Compose results.
    (set! res1 (* res2 res3))
	   
    res1))


;;;; grsp-complex-erfi - Gauss imaginary error function.
;;
;; Keywords:
;;
;; - complex, gauss
;;
;; Parameters:
;;
;; - p_z1: complex.
;; - p_n1: iterations.
;;
;; Sources:
;;
;; - [11].
;;
(define (grsp-complex-erfi p_z1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(res6 0))

    ;; res2.
    (set! res2 (/ 2 (sqrt (grsp-pi))))

    (let loop ((i1 0))
      (if (< i1 p_n1)
	  (begin (set! res6 (+ (* 2 i1) 1))
		 (set! res4 (expt p_z1 res6))
		 (set! res5 (* (grsp-fact i1) res6))
		 (set! res3 (+ res2 (/ res4 res5)))
		 (loop (+ i1 1)))))   
    
    ;; Compose results.
    (set! res1 (* res2 res3))
	   
    res1))


;;;; grsp-complex-erfc - Gauss complementary error function.
;;
;; Keywords:
;;
;; - complex, gauss
;;
;; Parameters:
;;
;; - p_z1: complex.
;; - p_n1: iterations.
;;
;; Sources:
;;
;; - [11].
;;
(define (grsp-complex-erfc p_z1 p_n1)
  (let ((res1 0))

    (set! res1 (- 1 (grsp-complex-erf p_z1 p_n1)))
    
    res1))


;;;; grsp-complex-erfci - Gauss complementary imaginary error function.
;;
;; Keywords:
;;
;; - complex, gauss
;;
;; Parameters:
;;
;; - p_z1: complex.
;; - p_n1: iterations.
;;
;; Sources:
;;
;; - [11].
;;
(define (grsp-complex-erfci p_z1 p_n1)
  (let ((res1 0))

    (set! res1 (- 1 (grsp-complex-erfi p_z1 p_n1)))
    
    res1))


;;;; grsp-complex-riemann-zeta - Riemann Zeta function.
;;
;; Keywords:
;;
;; - complex
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_z1: complex.
;; - p_m1: iterations, converging.
;; - p_m2: iterations, analytic.
;;
;; Notes:
;;
;; - Output might require rounding.
;;
;; Sources:
;;
;; - [12][13][14][15].
;;
(define (grsp-complex-riemann-zeta p_b2 p_s1 p_z1 p_m1 p_m2)
  (let ((res1 0.0)
	(z1 0.0)
	(r1 0.0))

    (set! z1 p_z1)
    (set! r1 (real-part z1))
    
    ;; Calculate according to domain intervals.
    (cond ((>= r1 0)
	   
	   (cond ((> r1 1) ; (1, +inf.0).
		  (set! res1 (grsp-complex-riemann-euzeta z1 p_m1)))
		 ((= r1 1) ; [1, 1].
		  (set! res1 +inf.0))		 
		 ((> r1 0) ; (0, 1).
		  (set! res1 (grsp-complex-riemann-cszeta z1 p_m1)))
		 ((= r1 0) ; [0, 0].
		  (set! res1 -0.5))))
	  ((< r1 0) ; (-inf.0, 0).
	   (set! res1 (grsp-complex-riemann-fezeta p_b2 p_s1 z1 p_m1 p_m2))))
    
    res1))


;;;; grsp-complex-riemann-fezeta - Riemann Zeta, functional equation
;; (for z1 in (-inf.0, 0).
;;
;; Keywords:
;;
;; - complex
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_z1: complex, real component must be < 0.
;; - p_m1: iterations, converging.
;; - p_m2: iterations, analytic.
;;
;; Notes:
;;
;; - Use grsp-complex-riemann-zeta to operate on the whole Z domain.
;;
;; Sources:
;;
;; - [12][13][14][15].
;;
(define (grsp-complex-riemann-fezeta p_b2 p_s1 p_z1 p_m1 p_m2)
  (let ((res1 0.0)
	(res2 0.0)
	(res3 0.0)
	(res4 0.0)
	(res5 0.0)
	(res6 0.0)
	(z1 0.0)
	(z2 0.0)
	(pi (gconst "A000796")))

    (set! z1 p_z1)
    (set! z2 (- 1 z1))
    (set! res2 (expt 2 z1))
    (set! res3 (expt pi (- z1 1)))
    (set! res4 (sin (/ (* pi z1) 2)))
    (set! res5 (grsp-complex-gamma p_b2 p_s1 z2 p_m1))
    (set! res6 (grsp-complex-riemann-zeta p_b2 p_s1 z2 p_m1 p_m2))

    ;; Compose results.
    (set! res1 (* res2 res3 res4 res5 res6))
    
    res1))


;;;; grsp-complex-riemann-euzeta - Riemann Zeta, for z1 in (1, +inf.0).
;;
;; Keywords:
;;
;; - complex, riemann, zeta
;;
;; Parameters:
;;
;; - p_z1: complex, real component must be > 1.
;; - p_m1: iterations.
;;
;; Notes:
;;
;; - Use grsp-complex-riemann-zeta to operate on the whole Z domain.
;;
;; Sources:
;;
;; - [12][13][14][15].
;;
(define (grsp-complex-riemann-euzeta p_z1 p_m1)
  (let ((res1 0.0))

    (let loop ((i1 1))
      (if (<= i1 p_m1)
	  (begin (set! res1 (+ res1 (/ 1 (expt i1 p_z1))))
		 (loop (+ i1 1)))))   
        
    res1))


;;;; grsp-complex-riemann-cszeta - Riemann Zeta, for z1 in (0, 1).
;;
;; Keywords:
;;
;; - complex, riemann, zeta
;;
;; Parameters:
;;
;; - p_z1: complex, real component must be > 1.
;; - p_m1: iterations.
;;
;; Notes:
;;
;; - Use grsp-complex-riemann-zeta to operate on the whole Z domain.
;;
;; Sources:
;;
;; - [12][13][14][15].
;;
(define (grsp-complex-riemann-cszeta p_z1 p_m1)
  (let ((res1 0.0)
	(z1 0.0)
	(z2 0.0)
	(m1 0))

    (set! m1 p_m1)
    (set! z1 p_z1)
    (set! z2 (- 1 z1))
    
    (set! res1 (grsp-complex-riemann-euzeta z1 m1))
    (set! res1 (- res1 (/ (expt m1 z2) z2)))

    res1))


;;;; grsp-complex-bernoulli-number - Bernoulli numbers calculated by means of
;; Riemann's Zeta function.
;;
;; Keywords:
;;
;; - complex, riemann, zeta
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_n2: number, integer [0, +inf.0).
;; - p_m1: iterations, converging.
;; - p_m2: iterations, analytic.
;;
;; Notes:
;;
;; - See info on grsp-complex-riemann-zeta before using this function.
;;
;; Sources:
;;
;; - [16].
;;
(define (grsp-complex-bernoulli-number p_b2 p_s1 p_n2 p_m1 p_m2)
  (let ((res1 0.0)
	(res2 0.0)
	(res3 0.0)
	(res4 0.0)
	(z1 0.0)
	(z2 0.0))

    ;; Bernoulli's number index argument (p_n2) should be an integer, but our
    ;; Riemann zeta will reat it as a complex with an imaginary part equal to
    ;; zero.
    (set! z2 p_n2)
    (set! z1 (/ z2 2))

    (set! res2 (* 2 (expt -1 (+ 1 z1))))
    (set! res3 (* (grsp-complex-riemann-zeta p_b2 p_s1 z2 p_m1 p_m2)
		  (grsp-fact z2)))
    (set! res4 (expt (* 2 (grsp-pi)) z2))
    
    ;; Compose results.
    (set! res1 (* res2 (/ res3 res4)))

    ;; Patch for Z(1) = +inf.0, B(1) = -0.5, which would otherwise give +inf.0 
    ;; as a result.
    (cond ((= z2 1)
	   (set! res1 -0.5))) ;; Z(0).
    
    res1))


;;;; grsp-complex-eif - Phase shift.
;;
;; Keywords:
;;
;; - complex
;;
;; Parameters:
;;
;; - p_f1: shift value.
;;
(define (grsp-complex-eif p_f1)
  (let ((res1 0))

    (set! res1 (expt (grsp-e) (* (grsp-mr 0 1) p_f1)))

    res1))

;;;; grsp-mr - Returns a complex number in rectangular form with real p_n1 and
;; imaginary component p_n2. This is a wrapper for Guile's make-rectangular
;; function but with a shorter syntax.
;;
;; Keywords:
;;
;; - complex
;;
;; Parameters:
;;
;; - p_n1: number.
;; - p_n2: number.
;;
(define (grsp-mr p_n1 p_n2)
  (let ((res1 (make-rectangular p_n1 p_n2)))
    
    res1))


