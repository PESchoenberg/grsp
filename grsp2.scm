;; =============================================================================
;;
;; grsp2.scm
;;
;; Real number functions.
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


;;;; General notes:
;; - Read sources for limitations on function parameters.
;;
;; Sources:
;; - [1] https://en.wikipedia.org/wiki/Falling_and_rising_factorials
;; - [2] En.wikipedia.org. 2020. Triangular Number. [online] Available at:
;;   https://en.wikipedia.org/wiki/Triangular_number [Accessed 20 November
;;   2020].
;; - [3] En.wikipedia.org. (2020). Binomial coefficient. [online] Available at:
;;   https://en.wikipedia.org/wiki/Binomial_coefficient [Accessed 13 Jan. 2020].
;; - [4] En.wikipedia.org. (2020). Bailey–Borwein–Plouffe formula. [online]
;;   Available at: https://en.wikipedia.org/wiki/Bailey%E2%80%93Borwein%E2%80%93
;;   Plouffe_formula [Accessed 9 Jan. 2020].
;; - [5] En.wikipedia.org. (2020). Hyperoperation. [online] Available at:
;;   https://en.wikipedia.org/wiki/Hyperoperation [Accessed 1 Jan. 2020].
;; - [6] En.wikipedia.org. (2020). Woodall number. [online] Available at:
;;   https://en.wikipedia.org/wiki/Woodall_number
;;   [Accessed 6 Jan. 2020]. En.wikipedia.org. (2020).
;; - [7] En.wikipedia.org. (2020). Cullen number. [online] Available at:
;;   https://en.wikipedia.org/wiki/Cullen_number [Accessed 6 Jan. 2020].
;; - [8] En.wikipedia.org. (2020). Proth prime. [online] Available at:
;;   https://en.wikipedia.org/wiki/Proth_prime [Accessed 9 Jan. 2020].
;; - [9] Mersenne.org. (2020). Great Internet Mersenne Prime Search - PrimeNet.
;;   [online] Available at: https://www.mersenne.org/ [Accessed 9 Jan. 2020].
;; - [10] Mathworld.wolfram.com. (2020). Mersenne Number -- from Wolfram
;;   MathWorld. [online] Available at:
;;   http://mathworld.wolfram.com/MersenneNumber.html [Accessed 16 Jan. 2020].
;; - [11] En.wikipedia.org. (2020). Repdigit. [online] Available at:
;;   https://en.wikipedia.org/wiki/Repdigit [Accessed 11 Jan. 2020].
;; - [12] En.wikipedia.org. (2020). Wagstaff prime. [online] Available at:
;;   https://en.wikipedia.org/wiki/Wagstaff_prime [Accessed 11 Jan. 2020].
;; - [13] En.wikipedia.org. (2020). Williams number. [online] Available at:
;;   https://en.wikipedia.org/wiki/Williams_number [Accessed 11 Jan. 2020].
;; - [14] En.wikipedia.org. (2020). Catalan number. [online] Available at:
;;   https://en.wikipedia.org/wiki/Catalan_number [Accessed 13 Jan. 2020].
;; - [15] En.wikipedia.org. (2020). Wagstaff prime. [online] Available at:
;;   https://en.wikipedia.org/wiki/Wagstaff_prime [Accessed 11 Jan. 2020].
;; - [16] En.wikipedia.org. (2020). Dobiński's formula. [online] Available at:
;;   https://en.wikipedia.org/wiki/Dobi%C5%84ski%27s_formula
;;   [Accessed 14 Jan. 2020].
;; - [17] En.wikipedia.org. (2020). Newton's method. [online] Available at:
;;   https://en.wikipedia.org/wiki/Newton%27s_method [Accessed 23 Jan. 2020].
;; - [18] En.wikipedia.org. (2020). Numerical analysis. [online] Available at:
;;   https://en.wikipedia.org/wiki/Numerical_analysis [Accessed 24 Jan. 2020].
;; - [19] En.wikipedia.org. (2020). Euler method. [online] Available at:
;;   https://en.wikipedia.org/wiki/Euler_method [Accessed 24 Jan. 2020].
;; - [20] En.wikipedia.org. (2020). Numerical analysis. [online] Available at:
;;   https://en.wikipedia.org/wiki/Numerical_analysis [Accessed 24 Jan. 2020].
;; - [21] En.wikipedia.org. (2020). Linear interpolation. [online] Available at:
;;   https://en.wikipedia.org/wiki/Linear_interpolation [Accessed 24 Jan. 2020].
;; - [22] En.wikipedia.org. 2020. Torus. [online] Available at:
;;   https://en.wikipedia.org/wiki/Torus [Accessed 3 November 2020].
;; - [23] En.wikipedia.org. 2020. Asymptotic Analysis. [online] Available at:
;;   https://en.wikipedia.org/wiki/Asymptotic_analysis
;;   [Accessed 8 November 2020].
;; - [24] En.wikipedia.org. 2020. Stirling's Approximation. [online] Available
;;   at: https://en.wikipedia.org/wiki/Stirling%27s_approximation
;;   [Accessed 8 November 2020].
;; - [25] En.wikipedia.org. 2020. Airy Function. [online] Available at:
;;   https://en.wikipedia.org/wiki/Airy_function [Accessed 9 November 2020].
;; - [26] En.wikipedia.org. 2020. Factorial. [online] Available at:
;;   https://en.wikipedia.org/wiki/Factorial#Superfactorial
;;   [Accessed 17 November 2020].
;; - [27] En.wikipedia.org. 2020. Alternating Factorial. [online] Available at:
;;   https://en.wikipedia.org/wiki/Alternating_factorial
;;   [Accessed 17 November 2020].
;; - [28] En.wikipedia.org. 2020. Exponential Factorial. [online] Available at:
;;   https://en.wikipedia.org/wiki/Exponential_factorial
;;   [Accessed 17 November 2020].
;; - [29] En.wikipedia.org. 2020. Derangement. [online] Available at:
;;   https://en.wikipedia.org/wiki/Derangement [Accessed 18 November 2020].
;; - [30] Gnu.org. 2020. Exactness (Guile Reference Manual). [online] Available
;;   at: https://www.gnu.org/software/guile/manual/html_node/Exactness.html
;;   [Accessed 28 November 2020].
;; - [31] https://en.wikipedia.org/wiki/Test_functions_for_optimization
;; - [32]
;; - [33]
;; - [34]
;; - [35]
;; - [36]
;; - [37]
;; - [38]
;; - [39]
;; - [40]


(define-module (grsp grsp2)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:export (grsp-gtels
	    grsp-sign
	    grsp-eiget
	    grsp-is-prime
	    grsp-fact
	    grsp-sumat
	    grsp-biconr
	    grsp-bicowr
	    grsp-gtls
	    grsp-getles
	    grsp-krnb
	    grsp-bpp
	    grsp-sexp
	    grsp-slog
	    grsp-woodall-number
	    grsp-cullen-number
	    grsp-proth-number
	    grsp-mersenne-number
	    grsp-repdigit-number
	    grsp-wagstaff-number
	    grsp-williams-number
	    grsp-thabit-number
	    grsp-fermat-number
	    grsp-catalan-number
	    grsp-wagstaff-prime
	    grsp-dobinski-formula
	    grsp-method-newton
	    grsp-method-euler
	    grsp-lerp
	    grsp-givens-rotation
	    grsp-fitin
	    grsp-fitin-0-1
	    grsp-eccentricity-spheroid
	    grsp-rcurv-oblate-ellipsoid
	    grsp-volume-ellipsoid
	    grsp-third-flattening-ellipsoid
	    grsp-flattening-ellipsoid
	    grsp-eccentricityf-ellipsoid
	    grsp-mrc-ellipsoid
	    grsp-pvrc-ellipsoid
	    grsp-dirc-ellipsoid
	    grsp-urc-ellipsoid
	    grsp-r1-iugg
	    grsp-r2-iugg
	    grsp-r3-iugg
	    grsp-r4-iugg
	    grsp-fxyz-torus
	    grsp-stirling-approximation
	    grsp-airy-function
	    grsp-sfact-pickover
	    grsp-sfact-sp
	    grsp-hfact
	    grsp-fact-alt
	    grsp-fact-exp
	    grsp-fact-sub
	    grsp-fact-low
	    grsp-fact-upp
	    grsp-ratio-derper
	    grsp-intifint
	    grsp-log
	    grsp-dtr
	    grsp-opz
	    grsp-eex
	    grsp-e
	    grsp-pi
	    grsp-em
	    grsp-phi))


;;;; grsp-gtels - Finds if p_n1 is greater, equal or smaller than p_n2.
;; this function is equivalent to the sgn math function.
;;
;; Keywords:
;; - function, comparison.
;;
;; Arguments:
;; - p_n1: number.
;; - p_n2: number.
;;
;; Output:
;; - 1 if (> p_n1 p_n2).
;; - 0 if (= p_n1 p_n2).
;; - (-1) if (< p_n1 p_n2).
;;
(define (grsp-gtels p_n1 p_n2)
  (let ((res1 0))

    (cond ((> p_n1 p_n2)
	   (set! res1 1))
	  ((< p_n1 p_n2)
	   (set! res1 -1)))

    res1))


;;;; grsp-sign - Returns 1 if p_n1 >= 0, -1 otherwise.
;;
;; Keywords:
;; - function, comparison.
;;
;; Arguments:
;; - p_n1: real number.
;;
(define (grsp-sign p_n1)
  (let ((res1 0))

	(set! res1 (grsp-gtels p_n1 0))
	(cond ((equal? res1 0)
	       (set! res1 1)))
	
	res1))


;;;; grsp-eiget - Finds out if p_n1 is an exact integer equal or greater than
;; p_n2.
;;
;; Keywords:
;; - function, comparison.
;;
;; Arguments:
;; - p_n1: integer.
;; - p_n2: integer.
;;
;; Output:
;; - Returns #t if p_n1 is an integer and equal or greater than p_n2. Returns #f
;;   otherwise.
;;
(define (grsp-eiget p_n1 p_n2)
  (let ((res1 #f))

    (cond ((exact-integer? p_n1)
	   (cond ((>= p_n1 p_n2)    
		  (set! res1 #t)))))

    res1))


;;;; grsp-is-prime - This is a very simple procedure, inefficient but
;; sufficient for small numbers to find if they are prime or not. For large
;; numbers other methods will likely be more adequate.
;;
;; Keywords:
;; - function, primes, prime number.
;;
;; Arguments:
;; - p_n: integer.
;;
;; Output: 
;; - Returns #f of p_n is prime, #f otherwise.
;;
(define (grsp-is-prime p_n1)
  (let ((res1 #t)
	(b1 #f)
	(i1 2))

    (while (eq? b1 #f)
	   (cond ((= 0 (remainder p_n1 i1))
		  (set! res1 #f)
		  (set! b1 #t)))
	   (set! i1 (+ i1 1))
	   (cond ((>= i1 p_n1)
		  (set! b1 #t))))
    (cond ((grsp-getles p_n1 -1 1)
	   (set! res1 #f)))

    res1))


;;;; grsp-fact - Calculates the factorial of p_n1.
;;
;; Keywords:
;; - function, factorial.
;;
;; Arguments:
;; - p_n1: natural number.
;; 
;; Output:
;; - Returns 1 if p_n1 is not a natural number. Factorial of p_n1 otherwise.
;;
(define (grsp-fact p_n1)
  (let ((res1 1))

    (cond ((eq? (grsp-eiget p_n1 1) #t)
	   (set! res1 (* p_n1 (grsp-fact (- p_n1 1))))))

    res1))


;;;; grsp-sumat - Calculates the summation of p_n1 (triangular number).
;;
;; Keywords:
;; - function, summation.
;;
;; Arguments:
;; - p_n1: integer >= 0.
;; 
;; Output:
;; - Returns 0 if p_n1 is not a natural number. Summation value of p_n1
;;   otherwise.
;;
;; Sources:
;; - [2].
;;
(define (grsp-sumat p_n1)
  (let ((res1 0))

    (cond ((eq? (grsp-eiget p_n1 0) #t)
	   (set! res1 (+ p_n1 (grsp-sumat (- p_n1 1))))))

    res1))


;;;; grsp-biconr - Binomial coefficient. Lets you choose p_k1 elements from a 
;; set of p_n1 elements without repetition.
;;
;; Keywords:
;; - function, combinatorics.
;;
;; Arguemnts:
;; - p_n1: integer >= 0
;; - p_k1: integer between [0, p_n1].
;;
;; Sources:
;; - [3].
;;
(define (grsp-biconr p_n1 p_k1)
  (let ((res1 0))

    (cond ((eq? (grsp-eiget p_n1 0) #t)		  
	   (cond ((eq? (grsp-eiget p_k1 0) #t)				
		  (cond ((>= p_n1 p_k1)
			 (set! res1 (/ (grsp-fact p_n1)
				      (* (grsp-fact (- p_n1 p_k1))
					 (grsp-fact p_k1))))))))))

    res1))


;;;; grsp-bicowr - Binomial coefficient. Les you choose p_k1 elements from a set
;; of p_n1 elements with repetition.
;;
;; Keywords:
;; - function, combinatorics.
;;
;; Arguemnts:
;; - p_n1: integer >= 0
;; - p_k1: integer >= 0 and <= p_n1.
;;
;; Sources:
;; - [3].
;;
(define (grsp-bicowr p_n1 p_k1)
  (let ((res1 0))

    (set! res1 (grsp-biconr (+ p_n1 (- p_k1 1)) p_k1))

    res1))


;;;; grsp-gtls - "gtls = Greater than, less than" Finds if number p_n1 is 
;; greater than p_n2 and smaller than p_n3, or in the interval (p_n2:p_n3).
;;
;; Keywords:
;; - function, comparison.
;;
;; Arguments:
;; - p_n1
;; - p_n2
;; - p_n3
;; 
;; Output:
;; - Returns #t if the condition holds. #f otherwise.
;;
(define (grsp-gtls p_n1 p_n2 p_n3)
  (let ((res #f))

    (cond ((> p_n1 p_n2)
	   (cond ((< p_n1 p_n3)
		  (set! res #t)))))

    res))


;;;; grsp-getles - "getles = Greater or equal than, less or equal than" Finds if
;; number p_n1 is greater or equal than p_n2 and smaller or equal than p_n3.
;;
;; Keywords:
;; - function, comparison.
;;
;; Arguments:
;; - p_n1
;; - p_n2
;; - p_n3
;; 
;; Output:
;; - Returns #t if the condition holds. #f otherwise.
;;
(define (grsp-getles p_n1 p_n2 p_n3)
  (let ((res #f))

    (cond ((>= p_n1 p_n2)
	   (cond ((<= p_n1 p_n3)
		  (set! res #t)))))

    res))


;;;; grsp-k2nb - Returns the value of (p_k1 * (p_r1**p_n1)) + p_b1 .
;;
;; Keywords:
;; - function.
;;
;; Arguments:
;; - p_k1
;; - p_r1
;; - p_n1
;; - p_b1
;; 
(define (grsp-krnb p_k1 p_r1 p_n1 p_b1)
  (let ((res1 0))

    (set! res1 (+ (* p_k1 (expt p_r1 p_n1)) p_b1))

    res1))


;;;; grsp-bpp - Bailey–Borwein–Plouffe formula.
;;
;; Keywords:
;; - function.
;;
;; Arguments:
;; - p_k1: summation iterations desired.
;; - p_b1: integer base.
;; - p_pf: polynomial with integer coef.
;; - p_qf: polynomial with integer coef.
;;
;; Sources:
;; - [4].
;;
(define (grsp-bpp p_k1 p_b1 p_pf p_qf)
  (let ((res1 0)
	(k1 0))

    (cond ((exact-integer? p_k1)
	   (cond ((eq? (grsp-eiget p_b1 2) #t)
		  (begin (while (< k1 p_k1)
				(set! res1 (+ res1 (* (/ 1 (expt p_b1 k1))
						      (/ (p_pf k1)
							 (p_qf k1)))))
				(set! k1 (+ k1 1))))))))

    res1))
			 

;;;; grsp-sexp - Performs a non-recursive tetration operation on p_x1 of height
;; p_n1. sexp stands for super exponential.
;;
;; Keywords:
;; - function, exp, expt.
;;
;; Arguments;
;; - p_x1: base.
;; - p_n1: rank or height of the power tower.
;;
;; Note:
;; - This operation might have a significant impact on the performance of your 
;;   computer due to its very fast function growth. Use with care.
;;
;; Sources:
;; - [5].
;;
(define (grsp-sexp p_x1 p_n1)
  (let ((x1 p_x1)
	(n1 p_n1)
	(i1 1)
	(res1 0))

    (cond ((= n1 0)
	   (set! res1 1))
	  ((< n1 0)
	   (set! res1 0))
	  ((> n1 0)
	   (begin (set! res1 x1)
		  (while (< i1 n1)
			 (set! res1 (expt x1 res1))
			 (set! i1 (+ i1 1))))))

    res1))


;;;; grsp-slog - Performs a non-recursive super logarithm operation on p_x1 of
;; height p_n1.
;;
;; Keywords:
;; - function, logarithm.
;;
;; Arguments;
;; - p_x1: base.
;; - p_n1: rank or height of the power tower of the super exponentiation for
;;   which grsp-slog is inverse.
;;
;; Note:
;; - This operation might have a significant impact on the performance of your 
;;   computer due to its very fast function growth. Use with care.
;;
(define (grsp-slog p_x1 p_n1)
  (let ((res1 0))

    (set! res1 (/ 1 (grsp-sexp p_x1 p_n1)))

    res1))


;;;; grsp-woodall-number - Calculates the Woodall number of p_n1.
;;
;; Keywords:
;; - function, number.
;;
;; Arguments:
;; - p_n1: natural number.
;;
;; Output:
;; - If p_n1 is not a natural number, the function returns 1. Otherwise, it
;;   returns the Woodall number of p_n1.
;;
;; Sources:
;; - [6].
;;
(define (grsp-woodall-number p_n1)
  (let ((res1 1))

    (cond ((eq? (grsp-eiget p_n1 1) #t)		  
	   (set! res1 (grsp-krnb p_n1 2 p_n1 -1))))

    res1))


;;;; grsp-cullen-number - Calculates the Cullen number of p_n1.
;;
;; Keywords:
;; - function, number.
;;
;; Arguments:
;; - p_n1: any natural number.
;;
;; Output:
;; - If p_n1 is not a natural number, the function returns 1. Otherwise, it
;;   returns the Cullen number of p_n1.
;;
;; Sources:
;; - [7].
;;
(define (grsp-cullen-number p_n1)
  (let ((res1 1))

    (cond ((eq? (grsp-eiget p_n1 1) #t)		  
	   (set! res1 (grsp-krnb p_n1 2 p_n1 1))))

    res1))


;;;; grsp-proth-number - Returns the value of a Proth number if:
;; - Both p_n1 and p_k1 are positive integers.
;; - p_k1 s odd.
;; - 2**p_n1 > p_k1.
;;
;; Keywords:
;; - function, number.
;;
;; Arguments:
;; - p_k1: positive integer.
;; - p_n1: positive integer.
;;
;; Output:
;; - 0 if p_n1 and p_k1 do not fill the requisites to calculate a Proth number.
;; - The Proth number if both p_n1 and p_k1 satisfy the conditions mentioned.
;;
;; Sources:
;; - [8].
;;
(define (grsp-proth-number p_n1 p_k1)
  (let ((res1 0))

    (cond ((exact-integer? p_n1)
	   (cond ((exact-integer? p_k1)
		  (cond ((odd? p_k1)
			 (cond ((> (expt 2 p_n1) p_k1)
				(set! res1 (grsp-krnb p_k1 2 p_n1 1))))))))))

    res1))


;;;; grsp-mersenne-number - Calculates a Mersenne number according to
;; Mn = 2**p_n1 - 1 .
;;
;; Keywords:
;; - function, number.
;;
;; Arguments:
;; - p_n1: positive integer.
;;
;; Output:
;; - 0 if p_n1 is not a positive integer.
;; - Mn if p_n1 is a positive integer.
;;
;; Sources:
;; - [9][10].
;;
(define (grsp-mersenne-number p_n1)
  (let ((res1 0))

    (cond ((exact-integer? p_n1)
	   (set! res1 (grsp-krnb 1 2 p_n1 -1))))

    res1))
	  

;;;; grsp-repdigit-number - Produces a repdigit number composed by p_n1 repeated
;; p_d1 instances.
;;
;; Keywords:
;; - function, number.
;;
;; Arguments:
;; - p_n1: natural number between [1,9].
;; - p_d1: natural number.
;;
;; Sources:
;; - [11].
;;
(define (grsp-repdigit-number p_n1 p_d1)
  (let ((res1 0)
	(i1 0))

    (cond ((exact-integer? p_n1)
	   (cond ((exact-integer? p_d1)
		  (cond ((eq? (grsp-gtls p_n1 0 10) #t)
			 (while (< i1 p_d1)
				(set! res1 (+ res1 p_n1))
				(set! i1 (+ i1 1))
				(cond ((< i1 p_d1)
				       (set! res1 (* res1 10)))))))))))

    res1))


;;;; grsp-wagstaff-number - Produces a Wagstaff number of base p_b1.
;;
;; Keywords:
;; - function, number.
;;
;; Arguments:
;; - p_n1: natural number.
;; - p_b1: natural number >= 2.
;;
;; Output:
;; - If conditions for arguments are met, the result is a Wagstaff number.
;;   Otherwise the function returns zero.
;;
;; Sources:
;; - [12].
;;
(define (grsp-wagstaff-number p_n1 p_b1)
  (let ((res1 0))

    (cond ((eq? (grsp-eiget p_n1 1) #t)
	   (cond ((eq? (grsp-eiget p_b1 2) #t)
		  (set! res1 (* 1.0 (/ (+ (expt p_b1 p_n1) 1) (+ p_b1 1))))))))

    res1))


;;;; grsp-williams-number - Produces a Williams number of base p_b1.
;;
;; Keywords:
;; - function, number.
;;
;; Arguments:
;; - p_n1: Natural number >= 1.
;; - p_b1: Natural number >= 2.
;;
;; Output:
;; - If conditions for arguments are met, the result is a Williams number.
;;   Otherwise the function returns zero.
;;
;; Sources:
;; - [13].
;;
(define (grsp-williams-number p_n1 p_b1)
  (let ((res1 0))

    (cond ((eq? (grsp-eiget p_n1 1) #t)		  
	   (cond ((eq? (grsp-eiget p_b1 2) #t)				
		  (set! res1 (- (* (- p_b1 1) (expt p_b1 p_n1)) 1))))))

    res1))


;;;; grsp-thabit-number - Produces a Thabit number.
;;
;; Keywords:
;; - function, number.
;;
;; Arguments:
;; - p_n1: positive integer.
;;
;; Output:
;; - If conditions for arguments are met, the result is a Thabit number.
;;   Otherwise the function returns zero.
;;
(define (grsp-thabit-number p_n1)
  (let ((res1 0))

    (cond ((eq? (grsp-eiget p_n1 0) #t)		  
	   (set! res1 (- (* 3 (expt 2 p_n1)) 1))))

    res1))


;;;; grsp-fermat-number - Produces a Fermat number.
;;
;; Keywords:
;; - function, number.
;;
;; Arguments:
;; - p_n1: non-negative integer.
;;
;; Output:
;; - If conditions for arguments are met, the result is a Fermat number.
;;   Otherwise the function returns zero.
;;
(define (grsp-fermat-number p_n1)
  (let ((res1 0))

    (cond ((eq? (grsp-eiget p_n1 0) #t)		  
	   (set! res1 (+ (expt 2 (expt 2 p_n1)) 1))))

    res1))


;;;; grsp-catalan-number - Calculates the p_n1(th) Catalan number.
;;
;; Keywords:
;; - function, number.
;;
;; Arguments:
;; - p_n1: non-negative integer.
;;
;; Output:
;; - Returns 0 if conditions for p_n1 are not met.
;;
;; Sources:
;; - [14].
;;
(define (grsp-catalan-number p_n1)
  (let ((res1 0))

    (cond ((eq? (grsp-eiget p_n1 0) #t)		      
	   (set! res1 (* (/ 1 (+ p_n1 1))
			(grsp-biconr (* 2 p_n1) p_n1)))))

    res1))

			
;;;; grsp-wagstaff-prime - Produces a Wagstaff prime number.
;;
;; Keywords:
;; - function, primes, prime number.
;;
;; Arguments:
;; - p_n1: Prime number.
;;
;; Output:
;; - A Wagstaff prime if p_n1 is prime, zero otherwise.
;;
;; Sources:
;; - [15].
;;
(define (grsp-wagstaff-prime p_n1)
  (let ((res1 0))

    (cond ((eq? (grsp-eiget p_n1 1) #t)    
	   (cond ((eq? (odd? p_n1) #t)
		  (set! res1 (/ (+ (expt 2 p_n1) 1) 3))))))

    res1))


;;;; grsp-dobinski-formula - Implementation of the Dobinski formula.
;;
;; Keywords:
;; - function, dobinski.
;;
;; Arguments:
;; - p_n1: non-negative integer.
;; - p_k1: non-negative integer.
;;
;; Output:
;; - Zero if conditions for p_n1 and p_k1 are not met. p_n1(th) Bell number. 
;;
;; Sources:
;; - [16].
;;
(define (grsp-dobinski-formula p_n1 p_k1)
  (let ((res1 0)
	(i1 0))

    (cond ((eq? (grsp-eiget p_n1 0) #t)
	   (cond ((eq? (grsp-eiget p_k1 0) #t)
		  (while (<= i1 p_n1)
			 (set! res1 (+ (/ (expt p_k1 p_n1)
					  (grsp-fact p_k1))))
			 (set! i1 (+ i1 1)))))))
    (set! res1 (* res1 (/ 1 (grsp-e))))

    res1))


;;;; grsp-method-netwton - Simple implementation of the Newton-Rapson method.
;;
;; Keywords:
;; - function, newton, numerical.
;;
;; Arguments:
;; - p_x1: x(n).
;; - p_fx: f(x(b)).
;; - p_dx: f'(x(n)).
;;
;; Output:
;; - x1(n1+1)
;;
;; Sources:
;; - [17][18].
;;
(define (grsp-method-newton p_x1 p_fx p_dx)
  (let ((res1 0))

    (set! res1 (- p_x1 (/ p_fx p_dx)))

    res1))


;;;; grsp-method-euler - Simple implementation of the Euler method.
;;
;; Keywords:
;; - function, euler, numerical.
;;
;; Arguments:
;; - p_y1: y(n).
;; - p_h1: h (step).
;; - p_f1: f(t,y).
;;
;; Output:
;; - x1(n1+1)
;;
;; Sources:
;; - [19][20].
;;
(define (grsp-method-euler p_y1 p_h1 p_f1)
  (let ((res1 0))

    (set! res1 (+ p_y1 (* p_h1 p_f1)))

    res1))


;;;; grsp-lerp - Linear interpolation. Interpolates p_y3 in the interval
;; (p_x1, p_x2) given p_x3.
;;
;; Keywords:
;; - function, interpolation.
;;
;; Arguments:
;; - p_x1: x1.
;; - p_x2: x2.
;; - p_x3: x3.
;; - p_y1: y1.
;; - p_y2: y2.
;; 
;; Output:
;; - y3.
;;
;; Sources:
;; - [21].
;;
(define (grsp-lerp p_x1 p_x2 p_x3 p_y1 p_y2)
  (let ((res1 0))

    (set! res1 (+ p_y1 (* (- p_x3 p_x1)
			 (/ (- p_y2 p_y1)
			    (- p_x2 p_x1)))))

    res1))


;;;; grsp-matrix-givens-rotation - Givens rotation. The code for this function
;; is adapted to Scheme from the original Octave code presented in the sources.
;;
;; Keywords:
;; - function, givens.
;;
;; Arguments:
;; - p_v1.
;; - p_v2.
;;
;; Sources:
;; - En.wikipedia.org. 2020. Givens Rotation. [online] Available at:
;;   https://en.wikipedia.org/wiki/Givens_rotation [Accessed 25 March 2020].
;;
;; Output:
;; - A list containing the values for c, s, and r, in that order.
;;
(define (grsp-givens-rotation p_v1 p_v2)
  (let ((res1 '())
	(v1 p_v1) ; a
	(v2 p_v2) ; b
	(v3 0) ; c
	(v4 0) ; s
	(v5 0) ; r
	(v6 0) ; t
	(v7 0) ; u
	(b1 #f))

    (cond ((equal? v2 0)
	   (set! v3 (grsp-sign v1))
	   (set! v4 0)
	   (set! v5 (abs v1))
	   (set! b1 #t)))
    (cond ((equal? v1 0)
	   (set! v3 0)
	   (set! v4 (grsp-sign v2))	   
	   (set! v5 (abs v2))
	   (set! b1 #t)))
    (cond ((> (abs v1) (abs v2))
	   (set! v6 (/ v2 v1))
	   (set! v7 (* (grsp-sign v1)
		       (sqrt (+ 1 (expt v6 2)))))
	   (set! v3 (/ 1 v7))
	   (set! v4 (* v3 v7))
	   (set! v5 (* v1 v7))
	   (set! b1 #t)))
    (cond ((equal? b1 #f)
	   (set! v6 (/ v1 v2))
	   (set! v7 (* (grsp-sign v2)
		       (sqrt (+ 1 (expt v6 2)))))
	   (set! v4 (/ 1 v7))
	   (set! v3 (* v4 v6))
	   (set! v5 (* v2 v7))))
    (set! res1 (list v3 v4 v5))
    
    res1))


;;;; grsp-fitin - Truncates p_n1 if it does not fit in the interval
;; [p_nmin, p_nmax].
;;
;; Keywords:
;; - function, trim, truncation.
;;
;; Arguments:
;; - p_n1: real.
;; - p_nmin: lower bounday of interval.
;; - p_nmax: higher boundary of th interval.
;;
;; Output:
;; - p_n1 if it is in [p_nmin,p:nmax]
;; - p_nmin if p_n1 < p_nmin.
;; - p_nmax if p_n1 > p_nmax.
;;
(define (grsp-fitin p_n1 p_nmin p_nmax)
  (let ((res1 p_n1))

    (cond ((> p_n1 p_nmax)
	   (set! res1 p_nmax))
	  ((< p_n1 p_nmin)
	   (set! res1 p_nmin)))

    res1))


;;;; grsp-fitin-0-1 - Applies grsp-fitin to p_n1 within the interval [0.0, 1.0].
;;
;; Keywords:
;; - function, trim, truncation.
;;
;; Arguments:
;; p_n1: real.
;;
(define (grsp-fitin-0-1 p_n1)

  (grsp-fitin p_n1 0.0 1.0))


;;;; grsp-eccentricity-spheroid - Eccentricity of a spheroid.
;;
;; Keywords:
;; - function, curves, sphere, spheroid.
;;
;; Arguments:
;; - p_x1: semi major axis.
;; - p_y1: semi minor axis.
;;
;; Sources:
;; - See grsp6 [14].
;;
(define (grsp-eccentricity-spheroid p_x1 p_y1)
  (let ((res1 0)
	(x1 0)
	(y1 0))

    (set! x1 (expt p_x1 2))
    (set! y1 (expt p_y1 2))
    (set! res1 (/ (- x1 y1) x1))

    res1))


;;;; grsp-rcurv-oblate-ellipsoid - Calculates the specified radius of curvature 
;; of an oblate ellipsoid.
;;
;; Keywords:
;; - function, curves, ellipsoid.
;;
;; Arguments:
;; - p_s1: string
;;   - "#p": polar radius.
;;   - "#e": equatorial radius.
;; - p_x1: semi major axis.
;; - p_y1: semi minor axis.
;;
;; Sources:
;; - See grsp1 [19][21].
;;
(define (grsp-rcurv-oblate-ellipsoid p_s1 p_x1 p_y1)
  (let ((res1 0))

    (cond ((equal? p_s1 "#p")
	   (set! res1 (/ (expt p_x1 2) p_y1)))
	  ((equal? p_s1 "#e")
	   (set! res1 (/ (expt p_y1 2) p_x1))))	  
    
    res1))
    

;;;; grsp-volume-ellipsoid - Volume of an ellipsoid.
;;
;; Keywords:
;; - function, curves, ellipsoid, volume.
;;
;; Arguments:
;; - p_x1: semi major axis.
;; - p_y1: semi minor axis.
;;
;; Sources:
;; - See grsp1 [19].
;;
(define (grsp-volume-ellipsoid p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (* (/ 4 3) (* (grsp-pi) (* (expt p_x1 2) p_y1))))

    res1))


;;;; grsp-tird-flattening-ellipsoid - Third flattening of an ellipsoid.
;;
;; Keywords:
;; - function, curves, ellipsoid.
;;
;; Arguments:
;; - p_x1: semi major axis.
;; - p_y1: semi minor axis.
;;
;; Sources:
;; - See grsp1 [21].
;;
(define (grsp-third-flattening-ellipsoid p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (/ (- p_x1 p_y1)
		  (+ p_x1 p_y1)))

    res1))


;;;; grsp-flattening-ellipsoid - Flattening of an ellipsoid.
;;
;; Keywords:
;; - function, curves, ellipsoid.
;;
;; Arguments:
;; - p_x1: semi major axis.
;; - p_y1: semi minor axis.
;;
;; Sources:
;; - See grsp1 [21].
;;
(define (grsp-flattening-ellipsoid p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (/ (- p_x1 p_y1) p_x1))

    res1))


;;;; grsp-eccentricityf-ellipsoid - Calculates the eccentricity of an ellipsoid
;; based on its flattening.
;;
;; Keywords:
;; - function, curves, ellipsoid.
;;
;; Arguments:
;; - p_f1: flattening.
;;
;; Sources:
;; - See grsp1 [21].
;;
(define (grsp-eccentricityf-ellipsoid p_f1)
  (let ((res1 0))

    (set! res1 (sqrt (* p_f1 (- 2 p_f1))))

    res1))


;;;; grsp-mrc-ellipsoid - Meridian radius of curvature (N S).
;;
;; Keywords:
;; - function, curves, ellipsoid.
;;
;; Arguments:
;; - p_x1: semi major axis.
;; - p_e1: eccenticity.
;; - p_l1: longitude.
;;
;; Sources:
;; - See grsp1 [21].
;; - See grsp1 [22].
;;  
(define (grsp-mrc-ellipsoid p_x1 p_e1 p_l1)
  (let ((res1 0))

    (set! res1 (/ (* p_x1 (- 1 (expt p_e1 2)))
		  (expt (- 1 (* (expt p_e1 2) (expt (sin p_l1) 2))) (/ 3 2))))

    res1))


;;;; grsp-pvrc-ellipsoid - Prime vertical radius of curvature (W E).
;;
;; Keywords:
;; - function, curves, ellipsoid.
;;
;; Arguments:
;; - p_x1: semi major axis.
;; - p_y1: semi minor axis.
;; - p_l1: geodetic latitude.
;;
;; Sources:
;; - See grsp1 [22].
;;  
(define (grsp-pvrc-ellipsoid p_x1 p_y1 p_l1)
  (let ((res1 0)
	(e1 0))

    (set! e1 (grsp-eccentricityf-ellipsoid (grsp-flattening-ellipsoid p_x1 p_y1)))
    (set! res1 (/ p_x1 (sqrt (- 1 (* (expt e1 2)
				     (expt (sin p_l1) 2))))))

    res1))


;;;; grsp-dirrc-ellipsoid - Directional radius of curvature on an ellipsoid at
;; and azimuth p_a1.
;;
;; Keywords:
;; - function, curves, ellipsoid.
;;
;; Arguments:
;; - p_x1: semi major axis.
;; - p_y1: semi minor axis.
;; - p_l1: geodetic latitude.
;; - p_a1: azimuth.
;;
;; Sources:
;; - See grsp1 [21].
;; - See grsp1 [22].
;;  
(define (grsp-dirc-ellipsoid p_x1 p_y1 p_l1 p_a1)
  (let ((res1 0))
	  
    (set! res1 (/ 1 (+ (/ (expt (cos p_a1) 2)
			  (grsp-mrc-ellipsoid p_x1 (grsp-eccentricityf-ellipsoid (grsp-flattening-ellipsoid p_x1 p_y1)) p_l1))
		       (/ (expt (sin p_a1) 2)
			  (grsp-pvrc-ellipsoid p_x1 p_y1 p_l1))))) ; N
    
    res1))    


;;;; grsp-urc-ellipsoid - Mean radius of curvature at p_l1.
;;
;; Keywords:
;; - function, curves.
;;
;; Arguments:
;; - p_x1: semi major axis.
;; - p_y1: semi minor axis.
;; - p_l1: geodetic latitude.
;; - p_a1: azimuth.
;;
;; Sources:
;; - See grsp1 [21].
;; - See grsp1 [22].
;; 
(define (grsp-urc-ellipsoid p_x1 p_y1 p_l1)
  (let ((res1 0))
	  
    (set! res1 (/ 2 (+ (/ 1
			  (grsp-mrc-ellipsoid p_x1 (grsp-eccentricityf-ellipsoid (grsp-flattening-ellipsoid p_x1 p_y1)) p_l1))
		       (/ 1 (grsp-pvrc-ellipsoid p_x1 p_y1 p_l1)))))
    
    res1))    


;;;; grsp-r1-iugg - Mean radius of curvature (IUGG).
;;
;; Keywords:
;; - function, curves.
;;
;; Arguments:
;; - p_x1: semi major axis.
;; - p_y1: semi minor axis.
;;
;; Sources:
;; - See grsp1 [22].
;; 
(define (grsp-r1-iugg p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (/ (+ (* 2 p_x1) p_y1) 3))
    
    res1))


;;;; grsp-r2-iugg - Authalic radius (IUGG).
;;
;; Keywords:
;; - function, curves.
;;
;; Arguments:
;; - p_x1: semi major axis.
;; - p_y1: semi minor axis.
;;
;; Sources:
;; - See grsp1 [22].
;;
;; Notes:
;; - Requires that p_x1 > p_y1
;;
(define (grsp-r2-iugg p_x1 p_y1)
  (let ((res1 0)
	(e1 0)
	(x1 0)
	(y1 0))
    
    (set! x1 (expt p_x1 2))
    (set! y1 (expt p_y1 2))    
    (set! e1 (sqrt (/ (- x1 y1) x1))) 
    (set! res1 (sqrt (/ (+ x1 (* (/ y1 e1)
				 (log (/ (+ 1 e1)
					 (/ p_y1 p_x1))))) 2)))
    
    res1))


;;;; grsp-r3-iugg - Volumetric radius (IUGG).
;;
;; Keywords:
;; - function, volume.
;;
;; Arguments:
;; - p_x1: semi major axis.
;; - p_y1: semi minor axis.
;;
;; Sources:
;; - See grsp1 [22].
;;
(define (grsp-r3-iugg p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (expt (* (expt p_x1 2) p_y1) (/ 1 3)))

    res1))


;;;; grsp-r4-iugg - Mean curvature (IUGG).
;;
;; Keywords:
;; - function, curves.
;;
;; Arguments:
;; - p_x1: semi major axis.
;; - p_e1: eccentricity.
;;
;; Sources:
;; - See grsp1 [22].
;;
(define (grsp-r4-iugg p_x1 p_e1)
  (let ((res1 0))

    (set! res1 (* (/ p_x1 2)
		  (sqrt (- (/ 1 (expt p_e1 2)) 1))
		  (log (/ (+ 1 p_e1)
			  (- 1 p_e1)))))

    res1))


;;;; grsp-fxyz-torus - Solution for f(x,y,z)
;;
;; Keywords:
;; - function, torus.
;;
;; Arguments:
;; - p_r1: R, distance from the center of the tube to the center of the torus.
;; - p_r2: r, tube radius.
;; - p_x1: x.
;; - p_y1: y.
;; - p_z1: z.
;;
;; Sources:
;; - [22].
;;
(define (grsp-fxyz-torus p_r1 p_r2 p_x1 p_y1 p_z1)
  (let ((res1 0))

    (set! res1 (+ (expt (- (sqrt (+ (expt p_x1 2)
				    (expt p_y1 2))) p_r1) 2)
		  (expt p_z1 2)
		  (* -1 (expt p_r1 2))))

    res1))


;;;; grsp-stirling-approximation - Approximation function for factorials. Allows
;; to estimate the factorial pf p_n1.
;;
;; Keywords:
;; - function, factorial, stirling.
;;
;; - p_n1: number for which its factorial is to be approximated.
;;
;; Sources:
;; - [23][24].
;;
(define (grsp-stirling-approximation p_n1)
  (let ((res1 0))

    (set! res1 (* (sqrt (* 2 (grsp-pi) p_n1))
		  (expt (/ p_n1 (grsp-e)) 2)))
    
    res1))


;;;; grsp-airy-function - Solution to y'' − xy = 0.
;;
;; Keywords:
;; - function, airy.
;;
;; arguments:
;; - p_x1.
;;
;; Sources:
;; - [23][25].
;;
(define (grsp-airy-function p_x1)
  (let ((res1 0))

    (set! res1 (/ (expt (expt (grsp-e) (* (/ -2 3) p_x1)) (/ 3 2))
		  (* 2 (sqrt (grsp-pi)) (expt p_x1 (/ 1 4)))))    

    res1))


;;;; grsp-sfact-pickover - Returns Pickover's superfactorial.
;;
;; Keywords:
;; - function, factorial.
;;
;; Arguments:
;; - p_n1: positive integer.
;;
;; Notes:
;; - This operation might have a significant impact on the performance of your 
;;   computer due to its very fast function growth. Use with care.
;;
;; Sources:
;; - [26].
;;
(define (grsp-sfact-pickover p_n1)
  (let ((res1 0)
	(n2 0))

    (set! n2 (grsp-fact p_n1))
    (set! res1 (grsp-sexp n2 n2))
    
    res1))


;;;; grsp-sfact-sp - Returns Sloane-Plouffe's superfactorial.
;;
;; Keywords:
;; - function, factorial.
;;
;; Arguments:
;; - p_n1: positive integer.
;;
;; Notes:
;; - This operation might have a significant impact on the performance of your 
;;   computer due to its very fast function growth. Use with care.
;;
;; Sources:
;; - [26].
;;
(define (grsp-sfact-sp p_n1)
  (let ((res1 1)
	(i1 1))

    (while (<= i1 p_n1)
	   (set! res1 (* res1 (grsp-fact i1)))
	   (set! i1 (+ i1 1)))
    
    res1))


;;;; grsp-hfact - Hyperfactorial.
;;
;; Keywords:
;; - function, factorial.
;;
;; Arguments:
;; - p_n1: positive integer.
;;
;; Notes:
;; - This operation might have a significant impact on the performance of your 
;;   computer due to its very fast function growth. Use with care.
;;
;; Sources:
;; - [26].
;;
(define (grsp-hfact p_n1)
  (let ((res1 1)
	(i1 1))

    (while (<= i1 p_n1)
	   (set! res1 (* res1 (expt i1 i1)))
	   (set! i1 (+ i1 1)))
    
    res1))


;;;; grsp-fact-alt - alternating factorial.
;;
;; Keywords:
;; - function, factorial.
;;
;; Arguments:
;; - p_n1: positive integer.
;;
;; Sources:
;; - [27].
;;
(define (grsp-fact-alt p_n1)
  (let ((res1 1))

    (cond ((> p_n1 1)
	   (set! res1 (- (grsp-fact p_n1)
			 (grsp-fact-alt (- p_n1 1))))))
    
    res1))


;;;; grsp-fact-exp - exponential factorial.
;;
;; Keywords:
;; - function, factorial.
;;
;; Arguments:
;; - p_n1: positive integer.
;;
;; Notes:
;; - This operation might have a significant impact on the performance of your 
;;   computer due to its very fast function growth. Use with care.
;;
;; Sources:
;; - [28].
;;
(define (grsp-fact-exp p_n1)
  (let ((res1 1))

    (cond ((> p_n1 1)
	   (set! res1 (expt p_n1 (grsp-fact-exp (- p_n1 1))))))
    
    res1))


;;;; grsp-fact-sub - sub factorial (derangement). Calculates the number of
;; permutations with no fixed points or repetitions in a set.
;;
;; Keywords:
;; - function, factorial.
;;
;; Arguments:
;; - p_n1: positive integer.
;;
;; Sources:
;; - [29].
;;
(define (grsp-fact-sub p_n1)
  (let ((res1 0.0))

    (cond ((<= p_n1 0)
	   (set! res1 1.0))
	  ((= p_n1 1)
	   (set! res1 0.0))
	  ((> p_n1 1)
	   (set! res1 (round (/ (grsp-fact p_n1)
				(grsp-e))))))
    
    res1))


;;;; grsp-fact-low - Lower factorial.
;;
;; Keywords:
;; - function, factorial, falling, descending, sequential.
;;
;; Arguments:
;; - p_x1: positive integer.
;; - p_n1: iterations, positive integer.
;;
;; Sources:
;; - [1].
;;
(define (grsp-fact-low p_x1 p_n1)
  (let ((res1 1)
	(k1 0))

    (cond ((> p_n1 0)
	   (while (< k1 p_n1)
		  (set! res1 (+ res1 (- p_x1 k1)))
		  (set! k1 (+ k1 1)))))
    
    res1))


;;;; grsp-fact-upp - Upper factorial.
;;
;; Keywords:
;; - function, factorial, upper, pochhammer, ascending, rising.
;;
;; Arguments:
;; - p_x1: positive integer.
;; - p_n1: iterations, positive integer.
;;
;; Sources:
;; - [1].
;;
(define (grsp-fact-upp p_x1 p_n1)
  (let ((res1 1)
	(k1 0))

    (cond ((> p_n1 0)
	   (while (< k1 p_n1)
		  (set! res1 (+ res1 (+ p_x1 k1)))
		  (set! k1 (+ k1 1)))))
    
    res1))


;;;; grsp-ratio-derper - Calculates the ratio between derangement (sub 
;; factorial and permutations (factorial) in a set. As p_n1 tends to infinity,
;; this ratio should approach 1/e. Limit of the probability that a permutation
;; is a derangement.
;;
;; Keywords:
;; - function, ratio.
;;
;; Arguments:
;; - p_n1: positive integer.
;;
;; Sources:
;; - [29].
;;
(define (grsp-ratio-derper p_n1)
  (let ((res1 0.0))

    (set! res1 (/ (grsp-fact-sub p_n1)
		  (grsp-fact p_n1)))

    res1))


;;;; grsp-intifint - If p_z1 is an integer, rounds p_z2 to zero decimals. This
;; might be necessary to satisfy exactness rquirements as per R5RS criteria as
;; describe in the sources.
;;
;; Keywords:
;; - function, cast, rounding.
;;
;; Arguments:
;; - p_b1:
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_z1: complex.
;; - p_z2: complex
;;
;; Sources:
;; - [30].
;;
(define (grsp-intifint p_b1 p_z1 p_z2)
  (let ((res1 p_z2) ; 0
	(z1 p_z1))

    (cond ((equal? p_b1 #t)
	   (cond ((integer? z1)
		  (set! res1 (round p_z2))))))

    res1))


;;;; grsp-log - Calculates the logarithm of p_x1 in base p_g1.
;;
;; Keywords:
;; - function.
;;
;; Arguments:
;; - p_g1: base.
;; - p_x1: exponent.
;;
(define (grsp-log p_g1 p_x1)
  (let ((res1 0))

    (set! res1 (/ (log10 p_x1)
		  (log10 p_g1)))
    
    res1))


;;;; grsp-dtr - Divides p_n1 into two natural numbers and returns a list.
;; If p_n1 is even then both values returned are equal. If p_n1 is odd then the
;; function truncates one and rounds the other according to p_s1.
;;
;; Keywords:
;; - function, classificatin, sorting.
;;
;; Arguments:
;; - p_s1: determines which half is rounded and wich one is truncated if p_n1 is
;;   odd:
;;   - "#rt": rounnd the first value, truncae the second.
;;   - "#tr": truncate the first and round the second.
;;
;; Output:
;; - As an example, for p_n1 = 4, will return 2,2 regardless of p_s1.
;; - Or if, for example  p_n1 = 5, will return 3,2 if p_s1 = "#rt" or 2,3 if
;;   p_s1 = "#tr". 
;;
(define (grsp-dtr p_s1 p_n1)
  (let ((res1 '())
	(n1 0)
	(n2 0)
	(n3 0)
	(s1 "#rt"))

    (cond ((not (equal? p_s1 "#rt"))
	   (set! s1 "#tr")))
    
    (set! n1 (abs p_n1))
    
    (cond ((even? n1)
	   (set! n2 (/ n1 2))
	   (set! n3 n2))
	  ((odd? n1)
	   (set! n1 (- n1 1))
	   (set! n2 (/ n1 2))
	   (cond ((equal? s1 "#rt")
		  (set! n3 n2)
		  (set! n2 (+ n2 1)))
		 ((equal? s1 "#tr")
		  (set! n3 (+ n2 1))))))
   
    (set! res1 (list n2 n3))
    
    res1))


;;;; grsp-opz - One point zero. Multiplies p_n1 by 1.0 in order to cast an  
;; exact number as real.
;;
;; Keywords:
;; - function, cast.
;;
;; Arguments:
;; - p_n1: number.
;;
(define (grsp-opz p_n1)
  (let ((res1 0))

    (set! res1 (* p_n1 1.00))

    res1))


;;;; grsp-eex - Calculates e**p_n1.
;;
;; Keywords:
;; - function, exp.
;;
;; Arguments:
;; - p_n1: number.
;;
(define (grsp-eex p_n1)
  (let ((res1 0))

    (set! res1 (expt (grsp-e) p_n1))

    res1))


;;;; grsp-e - Returns Euler's number.
;;
;; Keywords:
;; - function, exp.
;;
(define (grsp-e)
  (let ((res1 0))

    (set! res1 (gconst "A001113"))

    res1))


;;;; grsp-pi - Returns Pi.
;;
;; Keywords:
;; - function, exp.
;;
(define (grsp-pi)
  (let ((res1 0))

    (set! res1 (gconst "A000796"))

    res1))


;;;; grsp-em - Returns Euler-Mascheroni's Gamma.
;;
;; Keywords:
;; - function, exp.
;;
(define (grsp-em)
  (let ((res1 0))

    (set! res1 (gconst "A001620"))

    res1))


;;;; grsp-phi - Returns Phi (Golden Ratio).
;;
;; Keywords:
;; - function, exp.
;;
(define (grsp-phi)
  (let ((res1 0))

    (set! res1 (gconst "A001622"))

    res1))

