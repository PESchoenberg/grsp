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
	    grsp-eccentricity-spheroid))


;; grsp-gtels - Finds if p_n1 is greater, equal or smaller than p_n2.
;; this function is equivalent to the sgn math function.
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
  (let ((res 0))

    (cond ((> p_n1 p_n2)(set! res 1))
	  ((< p_n1 p_n2)(set! res -1)))

    res))


;; grsp-sign - Returns 1 if p_n1 >= 0, -1 otherwise.
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


;; grsp-eiget - Finds out if p_n1 is an exact integer equal or greater than
;; p_n2.
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
  (let ((res #f))

    (cond ((exact-integer? p_n1)
	   (cond ((>= p_n1 p_n2)    
		  (set! res #t)))))

    res))


;; grsp-is-prime - This is a very simple procedure, inefficient but sufficient 
;; for small numbers to find if they are prime or not. For large numbers other
;; methods will likely be more adequate.
;;
;; Arguments:
;; - p_n: integer.
;;
;; Output: 
;; - Returns #f of p_n is prime, #f otherwise.
;;
(define (grsp-is-prime p_n)
  (let ((res #t)
	(cyc #f)
	(i 2))

    (while (eq? cyc #f)
	   (cond ((= 0 (remainder p_n i))
		  (set! res #f)
		  (set! cyc #t)))
	   (set! i (+ i 1))
	   (cond ((>= i p_n)
		  (set! cyc #t))))
    (cond ((grsp-getles p_n -1 1)
	   (set! res #f)))

    res))


;; grsp-fact - Calculates the factorial of p_n.
;;
;; Arguments:
;; - p_n: natural number.
;; 
;; Output:
;; - Returns 1 if p_n is not a natural number. Factorial of p_n otherwise.
;;
(define (grsp-fact p_n)
  (let ((res 1))

    (cond ((eq? (grsp-eiget p_n 1) #t)
	   (set! res (* p_n (grsp-fact (- p_n 1))))))

    res))


;; grsp-sumat - Calculates the summation of p_n.
;;
;; Arguments:
;; - p_n: integer >= 0.
;; 
;; Output:
;; - Returns 0 if p_n is not a natural number. Summation value of p_n otherwise.
;;
(define (grsp-sumat p_n)
  (let ((res 0))

    (cond ((eq? (grsp-eiget p_n 0) #t)
	   (set! res (+ p_n (grsp-sumat (- p_n 1))))))

    res))


;; grsp-biconr - Binomial coefficient. Les you choose p_k elements from a set of
;; p_n elements without repetition.
;; 
;; Arguemnts:
;; - p_n: integer >= 0
;; - p_k: integer between [0, p_n].
;;
;; Sources:
;; - En.wikipedia.org. (2020). Binomial coefficient. [online] Available at:
;;   https://en.wikipedia.org/wiki/Binomial_coefficient [Accessed 13 Jan. 2020].
;;
(define (grsp-biconr p_n p_k)
  (let ((res 0))

    (cond ((eq? (grsp-eiget p_n 0) #t)		  
	   (cond ((eq? (grsp-eiget p_k 0) #t)				
		  (cond ((>= p_n p_k)
			 (set! res (/ (grsp-fact p_n) (* (grsp-fact (- p_n p_k)) (grsp-fact p_k))))))))))

    res))


;; grsp-bicowr - Binomial coefficient. Les you choose p_k elements from a set of
;; p_n elements with repetition.
;; 
;; Arguemnts:
;; - p_n: integer >= 0
;; - p_k: integer >= 0 and <= p_n.
;;
;; Sources:
;; - En.wikipedia.org. (2020). Binomial coefficient. [online] Available at:
;;   https://en.wikipedia.org/wiki/Binomial_coefficient [Accessed 13 Jan. 2020].
;;
(define (grsp-bicowr p_n p_k)
  (let ((res 0))

    (set! res (grsp-biconr (+ p_n (- p_k 1)) p_k))

    res))


;; grsp-gtls - "gtls = Greater than, less than" Finds if number p_n1 is greater
;; than p_n2 and smaller than p_n3, or in the interval (p_n2:p_n3).
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


;; grsp-getles - "getles = Greater or equal than, less or equal than" Finds if
;; number p_n1 is greater or equal than p_n2 and smaller or equal than p_n3.
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


;; grsp-k2nb - Returns the value of (p_k * (p_r**p_n)) + p_b .
;;
;; Arguments:
;; - p_k
;; - p_r
;; - p_n
;; - p_b
;; 
(define (grsp-krnb p_k p_r p_n p_b)
  (let ((res 0))

    (set! res (+ (* p_k (expt p_r p_n)) p_b))

    res))


;; grsp-bpp - Bailey–Borwein–Plouffe formula.
;;
;; Arguments:
;; - p_k: summation iterations desired.
;; - p_b: integer base.
;; - p_pf: polynomial with integer coef.
;; - p_qf: polynomial with integer coef.
;;
;; Sources:
;; - En.wikipedia.org. (2020). Bailey–Borwein–Plouffe formula. [online]
;;   Available at: https://en.wikipedia.org/wiki/Bailey%E2%80%93Borwein%E2%80%93
;;   Plouffe_formula [Accessed 9 Jan. 2020].
;;
(define (grsp-bpp p_k p_b p_pf p_qf)
  (let ((res 0)
	(k 0))

    (cond ((exact-integer? p_k)
	   (cond ((eq? (grsp-eiget p_b 2) #t)
		  (begin (while (< k p_k)
				(set! res (+ res (* (/ 1 (expt p_b k)) (/ (p_pf k) (p_qf k)))))
				(set! k (+ k 1))))))))

    res))
			 

;; grsp-sexp - Performs a non-recursive tetration operation on p_x of height
;; p_n. sexp stands for super exponential.
;;
;; Arguments;
;; - p_x: base.
;; - p_n: rank or height of the power tower.
;;
;; Note:
;; - This operation might have a significant impact on the performance of your 
;;   computer due to its very fast function growth. Use with care.
;;
;; Sources:
;; - En.wikipedia.org. (2020). Hyperoperation. [online] Available at:
;;   https://en.wikipedia.org/wiki/Hyperoperation [Accessed 1 Jan. 2020].
;;
(define (grsp-sexp p_x p_n)
  (let ((x p_x)
	(n p_n)
	(i 1)
	(res 0))

    (cond ((= n 0)(set! res 1))
	  ((< n 0)(set! res 0))
	  ((> n 0)(begin (set! res x)
			 (while (< i n)
				(set! res (expt x res))
				(set! i (+ i 1))))))

    res))


;; grsp-slog - Performs a non-recursive super logarithm operation on p_x of
;; height p_n.
;;
;; Arguments;
;; - p_x: base.
;; - p_n: rank or height of the power tower of the super exponentiation for
;;   which grsp-slog is inverse.
;;
;; Note:
;; - This operation might have a significant impact on the performance of your 
;;   computer due to its very fast function growth. Use with care.
;;
(define (grsp-slog p_x p_n)
  (let ((res 0))

    (set! res (/ 1 (grsp-sexp p_x p_n)))

    res))


;; grsp-woodall-number - Calculates the Woodall number of p_n.
;;
;; Arguments:
;; - p_n: natural number.
;;
;; Output:
;; - If p_n is not a natural number, the function returns 1. Otherwise, it
;;   returns the Woodall number of p_n.
;;
;; Sources:
;; - En.wikipedia.org. (2020). Woodall number. [online] Available at:
;;   https://en.wikipedia.org/wiki/Woodall_number
;;   [Accessed 6 Jan. 2020]. En.wikipedia.org. (2020).
;;
(define (grsp-woodall-number p_n)
  (let ((res 1))

    (cond ((eq? (grsp-eiget p_n 1) #t)		  
	   (set! res (grsp-krnb p_n 2 p_n -1))))

    res))


;; grsp-cullen-number - Calculates the Cullen number of p_n.
;;
;; Arguments:
;; - p_n: any natural number.
;;
;; Output:
;; - If p_n is not a natural number, the function returns 1. Otherwise, it
;;   returns the Cullen number of p_n.
;;
;; Sources:
;; - En.wikipedia.org. (2020). Cullen number. [online] Available at:
;;   https://en.wikipedia.org/wiki/Cullen_number [Accessed 6 Jan. 2020].
;;
(define (grsp-cullen-number p_n)
  (let ((res 1))

    (cond ((eq? (grsp-eiget p_n 1) #t)		  
	   (set! res (grsp-krnb p_n 2 p_n 1))))

    res))


;; grsp-proth-number - Returns the value of a Proth number if:
;; - Both p_n and p_k are positive integers.
;; - p_k s odd.
;; - 2**p_n > p_k.
;;
;; Arguments:
;; - p_k: positive integer.
;; - p_n: positive integer.
;;
;; Output:
;; - 0 if p_n and p_k do not fill the requisites to calculate a Proth number.
;; - The Proth number if both p_n and p_k satisfy the conditions mentioned.
;;
;; Sources:
;; - En.wikipedia.org. (2020). Proth prime. [online] Available at:
;;   https://en.wikipedia.org/wiki/Proth_prime [Accessed 9 Jan. 2020].
;;
(define (grsp-proth-number p_n p_k)
  (let ((res 0))

    (cond ((exact-integer? p_n)
	   (cond ((exact-integer? p_k)
		  (cond ((odd? p_k)
			 (cond ((> (expt 2 p_n) p_k)
				(set! res (grsp-krnb p_k 2 p_n 1))))))))))

    res))


;; grsp-mersenne-number - Calculates a Mersenne number according to
;; Mn = 2**p_n - 1 .
;;
;; Arguments:
;; - p_n: positive integer.
;;
;; Output:
;; - 0 if p_n is not a positive integer.
;; - Mn if p_n is a positive integer.
;;
;; Sources:
;; - Mersenne.org. (2020). Great Internet Mersenne Prime Search - PrimeNet.
;;   [online] Available at: https://www.mersenne.org/ [Accessed 9 Jan. 2020].
;; - Mathworld.wolfram.com. (2020). Mersenne Number -- from Wolfram MathWorld.
;;   [online] Available at: http://mathworld.wolfram.com/MersenneNumber.html
;;   [Accessed 16 Jan. 2020].
;;
(define (grsp-mersenne-number p_n)
  (let ((res 0))

    (cond ((exact-integer? p_n)
	   (set! res (grsp-krnb 1 2 p_n -1))))

    res))
	  

;; grsp-repdigit-number - Produces a repdigit number composed by p_n repeated
;; p_d instances.
;;
;; Arguments:
;; - p_n: natural number between [1,9].
;; - p_d: natural number.
;;
;; Sources:
;; - En.wikipedia.org. (2020). Repdigit. [online] Available at:
;;   https://en.wikipedia.org/wiki/Repdigit [Accessed 11 Jan. 2020].
;;
(define (grsp-repdigit-number p_n p_d)
  (let ((res 0)
	(i 0))

    (cond ((exact-integer? p_n)
	   (cond ((exact-integer? p_d)
		  (cond ((eq? (grsp-gtls p_n 0 10) #t)
			 (while (< i p_d)
				(set! res (+ res p_n))
				(set! i (+ i 1))
				(cond ((< i p_d)
				       (set! res (* res 10)))))))))))

    res))


;; grsp-wagstaff-number - Produces a Wagstaff number of base p_b.
;;
;; Arguments:
;; - p_n: natural number.
;; - p_b: natural number >= 2.
;;
;; Output:
;; - If conditions for arguments are met, the result is a Wagstaff number.
;;   Otherwise the function returns zero.
;;
;; Sources:
;; - En.wikipedia.org. (2020). Wagstaff prime. [online] Available at:
;;   https://en.wikipedia.org/wiki/Wagstaff_prime [Accessed 11 Jan. 2020].
;;
(define (grsp-wagstaff-number p_n p_b)
  (let ((res 0))

    (cond ((eq? (grsp-eiget p_n 1) #t)
	   (cond ((eq? (grsp-eiget p_b 2) #t)
		  (set! res (* 1.0 (/ (+ (expt p_b p_n) 1) (+ p_b 1))))))))

    res))


;; grsp-williams-number - Produces a Williams number of base p_b.
;;
;; Arguments:
;; - p_n: Natural number >= 1.
;; - p_b: Natural number >= 2.
;;
;; Output:
;; - If conditions for arguments are met, the result is a Williams number.
;;   Otherwise the function returns zero.
;;
;; Sources:
;; - En.wikipedia.org. (2020). Williams number. [online] Available at:
;;   https://en.wikipedia.org/wiki/Williams_number [Accessed 11 Jan. 2020].
;;
(define (grsp-williams-number p_n p_b)
  (let ((res 0))

    (cond ((eq? (grsp-eiget p_n 1) #t)		  
	   (cond ((eq? (grsp-eiget p_b 2) #t)				
		  (set! res (- (* (- p_b 1) (expt p_b p_n)) 1))))))

    res))


;; grsp-thabit-number - Produces a Thabit number.
;;
;; Arguments:
;; - p_n: positive integer.
;;
;; Output:
;; - If conditions for arguments are met, the result is a Thabit number.
;;   Otherwise the function returns zero.
;;
(define (grsp-thabit-number p_n)
  (let ((res 0))

    (cond ((eq? (grsp-eiget p_n 0) #t)		  
	   (set! res (- (* 3 (expt 2 p_n)) 1))))

    res))


;; grsp-fermat-number - Produces a Fermat number.
;;
;; Arguments:
;; - p_n: non-negative integer.
;;
;; Output:
;; - If conditions for arguments are met, the result is a Fermat number.
;;   Otherwise the function returns zero.
;;
(define (grsp-fermat-number p_n)
  (let ((res 0))

    (cond ((eq? (grsp-eiget p_n 0) #t)		  
	   (set! res (+ (expt 2 (expt 2 p_n)) 1))))

    res))


;; grsp-catalan-number - Calculates the p_n(th) Catalan number.
;;
;; Arguments:
;; - p_n: non-negative integer.
;;
;; Output:
;; - Returns 0 if conditions for p_n are not met.
;;
;; Sources:
;; - En.wikipedia.org. (2020). Catalan number. [online] Available at:
;;   https://en.wikipedia.org/wiki/Catalan_number [Accessed 13 Jan. 2020].
;;
(define (grsp-catalan-number p_n)
  (let ((res 0))

    (cond ((eq? (grsp-eiget p_n 0) #t)		      
	   (set! res (* (/ 1 (+ p_n 1)) (grsp-biconr (* 2 p_n) p_n)))))

    res))

			
;; grsp-wagstaff-prime - Produces a Wagstaff prime number.
;;
;; Arguments:
;; - p_n: Prime number.
;;
;; Output:
;; - A Wagstaff prime if p_n is prime, zero otherwise.
;;
;; Sources:
;; - En.wikipedia.org. (2020). Wagstaff prime. [online] Available at:
;;   https://en.wikipedia.org/wiki/Wagstaff_prime [Accessed 11 Jan. 2020].
;;
(define (grsp-wagstaff-prime p_n)
  (let ((res 0))

    (cond ((eq? (grsp-eiget p_n 1) #t)    
	   (cond ((eq? (odd? p_n) #t)
		  (set! res (/ (+ (expt 2 p_n) 1) 3))))))

    res))


;; grsp-dobinski-formula - Implementation of the Dobinski formula.
;;
;; Arguments:
;; - p_n: non-negative integer.
;; - p_k: non-negative integer.
;;
;; Output:
;; - Zero if conditions for p_n and p_k are not met. p_n(th) Bell number. 
;;
;; Sources:
;; - En.wikipedia.org. (2020). Dobiński's formula. [online] Available at:
;;   https://en.wikipedia.org/wiki/Dobi%C5%84ski%27s_formula
;;   [Accessed 14 Jan. 2020].
;;
(define (grsp-dobinski-formula p_n p_k)
  (let ((res 0)
	(i 0))

    (cond ((eq? (grsp-eiget p_n 0) #t)
	   (cond ((eq? (grsp-eiget p_k 0) #t)
		  (while (<= i p_n)
			 (set! res (+ (/ (expt p_k p_n) (grsp-fact p_k))))
			 (set! i (+ i 1)))))))
    (set! res (* res (/ 1 (gconst "A001113"))))

    res))


;; grsp-method-netwton - Simple implementation of the Newton-Rapson method.
;; 
;; - p_x: x(n).
;; - p_fx: f(x(b)).
;; - p_dx: f'(x(n)).
;;
;; Output:
;; - x(n+1)
;;
;; Sources:
;; - En.wikipedia.org. (2020). Newton's method. [online] Available at:
;;   https://en.wikipedia.org/wiki/Newton%27s_method [Accessed 23 Jan. 2020].
;; - En.wikipedia.org. (2020). Numerical analysis. [online] Available at:
;;   https://en.wikipedia.org/wiki/Numerical_analysis [Accessed 24 Jan. 2020].
;;
(define (grsp-method-newton p_x p_fx p_dx)
  (let ((res 0))

    (set! res (- p_x (/ p_fx p_dx)))

    res))


;; grsp-method-euler - Simple implementation of the Euler method.
;; 
;; Arguments:
;; - p_y: y(n).
;; - p_h: h (step).
;; - p_f: f(t,y).
;;
;; Output:
;; - x(n+1)
;;
;; Sources:
;; - En.wikipedia.org. (2020). Euler method. [online] Available at:
;;   https://en.wikipedia.org/wiki/Euler_method [Accessed 24 Jan. 2020].
;; - En.wikipedia.org. (2020). Numerical analysis. [online] Available at:
;;   https://en.wikipedia.org/wiki/Numerical_analysis [Accessed 24 Jan. 2020].
;;
(define (grsp-method-euler p_y p_h p_f)
  (let ((res 0))

    (set! res (+ p_y (* p_h p_f)))

    res))


;; grsp-lerp - Linear interpolation. Interpolates p_y3 in the interval
;; (p_x1, p_x2) given p_x3.
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
;; - En.wikipedia.org. (2020). Linear interpolation. [online] Available at:
;;   https://en.wikipedia.org/wiki/Linear_interpolation [Accessed 24 Jan. 2020].
;;
(define (grsp-lerp p_x1 p_x2 p_x3 p_y1 p_y2)
  (let ((res 0))

    (set! res (+ p_y1 (* (- p_x3 p_x1) (/ (- p_y2 p_y1) (- p_x2 p_x1)))))

    res))


;; grsp-matrix-givens-rotation - Givens rotation. The code for this function
;; is adapted to Scheme from the original Octave code presented in the source.
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
	   (set! v7 (* (grsp-sign v1) (sqrt (+ 1 (expt v6 2)))))
	   (set! v3 (/ 1 v7))
	   (set! v4 (* v3 v7))
	   (set! v5 (* v1 v7))
	   (set! b1 #t)))
    (cond ((equal? b1 #f)
	   (set! v6 (/ v1 v2))
	   (set! v7 (* (grsp-sign v2) (sqrt (+ 1 (expt v6 2)))))
	   (set! v4 (/ 1 v7))
	   (set! v3 (* v4 v6))
	   (set! v5 (* v2 v7))))
    (set! res1 (list v3 v4 v5))
    
    res1))


;; grsp-fitin - Truncates p_n1 if it does not fit in the interval
;; [p_nmin, p_nmax].
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


;; grsp-fitin-0-1 - Applies grsp-fitin to p_n1 within the interval [0.0,1.0].
;;
;; Arguments:
;; p_n1: real.
;;
(define (grsp-fitin-0-1 p_n1)

  (grsp-fitin p_n1 0.0 1.0))


;; grsp-eccentricity-spheroid - Eccentricity of a spheroid.
;;
;; Arguments:
;; p_x1: semi major axis.
;; p_x2: semi minor axis.
;;
;; Sources:
;; - See grsp6 [14].
;;
(define (grsp-eccentricity-spheroid p_x1 p_y1)
  (let ((res1 0)
	(x1 0)
	(x2 0))

    (set! x1 (expt p_x1 2))
    (set! x2 (expt p_x2 2))
    (set! res1 (/ (- x1 x2) x1))

    res1))
