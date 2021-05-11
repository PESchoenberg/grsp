;; =============================================================================
;;
;; grsp4.scm
;;
;; Complex functions.
;;
;; =============================================================================
;;
;; Copyright (C) 2020 - 2021 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;; - [11] https://en.wikipedia.org/wiki/Error_function


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
	    grsp-complex-erfci))
  

;;;; grsp-complex-inv-imag - Calculates the inverse of the imaginary
;; component of a complex number.
;;
;; Keywords:
;; - complex.
;;
;; Arguments:
;; - p_z1: complex number.
;;
;; Output:
;; - The conjugate of p_z1 (imaginary part negated).
;;
;; Sources:
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
;; - complex.
;;
;; Arguments:
;; - p_z1: complex number.
;;
;; Sources:
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
;; - complex.
;;
;; Arguments:
;; - p_s1: operation.
;;   - "#si": inverts the imaginary component only.
;;   - "#is": inverts the real component only.
;;   - "#ii": inverts both.
;; - p_z1: complex number.
;;
;; Sources:
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
;; - complex.
;;
;; Arguments:
;; - p_z1: complex number.
;;
;; Output:
;; - (1 1) if both components are positive or real is positive and
;;   imaginary is zero.
;; - (-1 -1) if both components are negative.
;; - (-1 1) if the real component is negative and the imaginary positive or
;;   zero.
;; - (1 -1) if the real component is positive and the imaginary is negative.
;;
;; Sources:
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
;; - complex.
;;
;; Arguments:
;; - p_r1: growth rate.
;; - p_x1
;;
;; Sources:
;; - [2][3].
;;
(define (grsp-complex-logistic p_r1 p_x1)
  (let ((res1 0))

    (set! res1 (* p_r1 (* p_x1 (- 1 p_x1))))

    res1))


;;;; grsp-complex-mandelbrot - Quadratic map function for the Mandelbrot set.
;;
;; Keywords:
;; - complex.
;;
;; Arguments:
;; - p_z1
;; - p_c1
;;
;; Sources:
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
;; - complex.
;;
;; Arguments:
;; - p_z1: ordinal of the desired Fibonacci number.
;;
;; Sources:
;; [6].
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
;; - complex.
;;
;; Arguments:
;; - p_s1: s.
;; - p_l1: iterations.
;;
;; Sources:
;; - [4].
;;
(define (grsp-complex-dirichlet-eta p_s1 p_l1)
  (let ((res1 0)
	(n1 1))

    (while (< n1 p_l1)
	   (set! res1 (+ res1 (/ (expt -1 (- n1 1))
				 (expt n1 p_s1))))
	   (set! n1 (in n1)))

    res1))


;;;; grsp-complex-f1 - Solves (p_a1 * (p_x1**p_n1)) / (1 + (p_a2 (p_x1**p_b2)))
;;
;; Keywords:
;; - complex.
;;
;; Arguments:
;; - p_a1
;; - p_a2
;; - p_x1
;; - p_n1
;; - p_n2
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
;; - complex.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_z1: complex.
;; - p_n1: desired product iterations.
;;
;; Output:
;; - For negative integers, the function returns +inf.0 (Riemann sphere).
;;
;; Sources:
;; - [5].
;;
(define (grsp-complex-gamma-euler p_b2 p_z1 p_n1)
  (let ((res1 0)
	(res2 1)
	(i1 1)
	(res3 0)
	(res4 0)
	(defined #t))

    (cond ((integer? p_z1)
	   (cond ((< p_z1 0)
		  (set! defined #f)))))
    (cond ((eq? defined #t)
	   (while (<= i1 p_n1)
		  (set! res3 (expt (+ 1 (/ 1 i1)) p_z1))
		  (set! res4 (+ 1 (/ p_z1 i1)))
		  (set! res2 (* res2 (/ res3 res4)))
		  (set! i1 (in i1)))
	   (set! res1 (* 1.00 (/ 1 p_z1) res2)))
	  ((eq? defined #f)
	   (set! res1 +inf.0)))

    (set! res1 (grsp-intifint p_b2 p_z1 res1))
    
    res1))


;;;; grsp-complex-gamma-weierstrass - Complex extension of the gamma function
;; according to Weierstrass.
;;
;; Keywords:
;; - complex.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_z1: complex.
;; - p_n1: desired product iterations.
;;
;; Output:
;; - For negative integers, the function returns +inf.0 (Riemann sphere).
;;
;; Sources:
;; - [5].
;;
(define (grsp-complex-gamma-weierstrass p_b2 p_z1 p_n1)
  (let ((res1 0)
	(res2 1)
	(i1 1)
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
	   (set! res3 (/ (expt e1 (* -1 g1 p_z1)) p_z1))
	   (while (<= i1 p_n1)
		  (set! z2 (/ p_z1 i1))
		  (set! res4 (/ 1 (+ 1 z2)))
		  (set! res5 (expt e1 z2))
		  (set! res2 (* res2 res4 res5))
		  (set! i1 (in i1)))
	   (set! res1 (* 1.00 res3 res2)))
	  ((eq? defined #f)
	   (set! res1 +inf.0)))

    (set! res1 (grsp-intifint p_b2 p_z1 res1))
    
    res1))


;;;; grsp-complex-gamma - Calculating gamma using different representations. 
;;
;; Keywords:
;; - complex.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_s1: desired gamma repesentation:
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;; - p_z1: complex.
;; - p_n1: desired product iterations.
;;
;; Sources:
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
;; - complex.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_s1: desired gamma repesentation:
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;; - p_z1: complex.
;; - p_n1: desired product iterations.
;;
;; Sources:
;; - [5].
;;
(define (grsp-complex-pigamma p_b2 p_s1 p_z1 p_n1)
  (let ((res1 0)
	(z2 (+ p_z1 1)))

    (set! res1 (grsp-complex-gamma p_b2 p_s1 z2 p_n1))
    
    res1))


;;;; grsp-complex-lngamma - Calculates the natural logarythm of gamma.
;;
;; Keywords:
;; - complex.
;;
;; Arguments:
;; - p_z1: complex.
;; - p_n1: desired product iterations.
;;
;; Sources:
;; - [5].
;;
(define (grsp-complex-lngamma p_z1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(res6 0)
	(i1 1))

    (set! res2 (* -1 (grsp-em) p_z1))
    (set! res3 (* -1 (log p_z1)))
    (while (<= i1 p_n1)
	   (set! res6 (/ p_z1 i1))
	   (set! res4 (- res6 (log (+ 1 res6))))
	   (set! res5 (+ res5 res4))
	   (set! i1 (in i1)))    

    res1))


;;;; grsp-complex-digamma - Digamma function for p_z1 - 1.
;;
;; Keywords:
;; - complex.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_z1: complex.
;; - p_n1: Desired product iterations.
;;
;; Sources:
;; - [5].
;;
(define (grsp-complex-digamma p_b2 p_z1 p_n1)
  (let ((res1 0)
	(res2 1)
	(i1 1)
	(z2 (- p_z1 1))
	(defined #t))

    (cond ((integer? z2)
	   (cond ((< z2 0)
		  (set! defined #f)))))
    (cond ((eq? defined #t)
	   (while (<= i1 p_n1)
		  (set! res2 (/ z2 (* i1 (+ i1 z2))))		  
		  (set! i1 (+ i1 1)))
	   (set! res1 (* -1.00 (grsp-em) res2)))
	  ((eq? defined #f)
	   (set! res1 +inf.0)))

    (set! res1 (grsp-intifint p_b2 z2 res1))
    
    res1))


;;;; grsp-complex-ligamma - Lower incomplete gamma function.
;;
;; Keywords:
;; - complex.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_s1: desired gamma repesentation:
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;; - p_z1: complex.
;; - p_z2: complex.
;; - p_n1: Desired product iterations.
;;
;; Sources:
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
;; - complex.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_s1: desired gamma repesentation:
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;; - p_z1: complex.
;; - p_z2: complex.
;; - p_n1: Desired product iterations.
;;
;; Sources:
;; - [5][7].
;;  
(define (grsp-complex-llgamma p_b2 p_s1 p_z1 p_z2 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(i1 0))

    ;; res2
    (set! res2 (expt (grsp-e) (* -1 p_z2)))

    ;; res3
    (while (<= i1 p_n1)
	   (set! res3 (+ res3 (/ (expt p_z2 i1)
				 (grsp-complex-gamma p_b2 p_s1 (+ p_z1 i1 1) p_n1))))		 
	   (set! i1 (in i1)))   

    ;; Complete.
    (set! res1 (* res2 res3))

    res1))


;;;; grsp-complex-uigamma - Upper incomplete gamma function.
;;
;; Keywords:
;; - complex.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_s1: desired gamma repesentation:
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;; - p_z1: complex.
;; - p_z2: complex.
;; - p_n1: Desired product iterations.
;;
;; Sources:
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
;; - complex.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_s1: desired gamma repesentation:
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;; - p_z1: complex.
;; - p_z2: complex.
;; - p_n1: Desired product iterations.
;;
;; Sources:
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
;; - complex.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_s1: desired gamma repesentation:
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;; - p_z1: complex.
;; - p_z2: complex.
;; - p_n1: Desired product iterations.
;;
;; Sources:
;; - [5][7].
;; 
(define (grsp-complex-qrgamma p_b2 p_s1 p_z1 p_z2 p_n1)
  (let ((res1 0))

    (set! res1 (- 1 (grsp-complex-prgamma p_b2 p_s1 p_z1 p_z2 p_n1)))

    res1))
    

;;;; grsp-complex-kummer-ch1 - Kummer's complex hypergeometric function (M).
;;
;; Keywords:
;; - complex, hypergeometric.
;;
;; Arguments:
;; - p_a1: a.
;; - p_b1: b.
;; - p_z1: z.
;; - p_n1: iterations.
;;
;; Sources:
;; - [10].
;;
(define (grsp-complex-chm p_a1 p_b1 p_z1 p_n1)
  (let ((res1 0)
	(i1 0)
	(n2 0)
	(n3 0))

    (while (< i1 p_n1)
	   (set! n2 (* (grsp-fact-upp p_a1 i1) (expt p_z1 i1)))
	   (set! n3 (* (grsp-fact-upp p_b1 i1) (grsp-fact i1)))
	   (set! res1 (+ res1 (/ n2 n3)))
	   (set! i1 (in i1)))
    
    res1))


;;;; grsp-complex-chu - Tricomi's complex hypergeometric function (U).
;;
;; Keywords:
;; - complex, hypergeometric.
;;
;; Arguments:
;; - p_a1: a.
;; - p_b1: b. Non-integer.
;; - p_z1: z.
;; - p_n1: iterations (M component).
;; - p_b2: see grsp4.grsp-complex-gamma.
;; - p_s2: see grsp4.grsp-complex-gamma.
;; - p_n2; see grsp4.grsp-complex-gamma.
;;
;; Sources:
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
    
    ;; Final result.
    (set! res1 (+ (* n21 n22) (* n31 n32)))
    
    res1))


;;;; grsp-complex-erf - Gauss error function.
;;
;; Arguments:
;; - p_z1: complex.
;; - p_n1: iterations.
;;
;; Sources:
;; - [11].
;;
(define (grsp-complex-erf p_z1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(res6 0)
	(i1 0))

    ;; Res2.
    (set! res2 (/ 2 (sqrt (grsp-pi))))

    ;; Res3.
    (while (< i1 p_n1)
	   (set! res6 (+ (* 2 i1) 1))
	   (set! res4 (* (expt -1 i1) (expt p_z1 res6)))
	   (set! res5 (* (grsp-fact i1) res6))
	   (set! res3 (+ res2 (/ res4 res5)))
	   (set! i1 (in i1)))

    ;; Final.
    (set! res1 (* res2 res3))
	   
    res1))


;;;; grsp-complex-erf - Gauss imaginary error function.
;;
;; Arguments:
;; - p_z1: complex.
;; - p_n1: iterations.
;;
;; Sources:
;; - [11].
;;
(define (grsp-complex-erfi p_z1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(res6 0)
	(i1 0))

    ;; Res2.
    (set! res2 (/ 2 (sqrt (grsp-pi))))

    ;; Res3.
    (while (< i1 p_n1)
	   (set! res6 (+ (* 2 i1) 1))
	   (set! res4 (expt p_z1 res6))
	   (set! res5 (* (grsp-fact i1) res6))
	   (set! res3 (+ res2 (/ res4 res5)))
	   (set! i1 (in i1)))

    ;; Final.
    (set! res1 (* res2 res3))
	   
    res1))


;;;; grsp-complex-erfc - Gauss complementary error function.
;;
;; Arguments:
;; - p_z1: complex.
;; - p_n1: iterations.
;;
;; Sources:
;; - [11].
;;
(define (grsp-complex-erfc p_z1 p_n1)
  (let ((res1 0))

    (set! res1 (- 1 (grsp-complex-erf p_z1 p_n1)))
    
    res1))


;;;; grsp-complex-erfci - Gauss complementary imaginary error function.
;;
;; Arguments:
;; - p_z1: complex.
;; - p_n1: iterations.
;;
;; Sources:
;; - [11].
;;
(define (grsp-complex-erfci p_z1 p_n1)
  (let ((res1 0))

    (set! res1 (- 1 (grsp-complex-erfi p_z1 p_n1)))
    
    res1))
