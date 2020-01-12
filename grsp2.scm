; ==============================================================================
;
; grsp2.scm
;
; Math stuff.
;
; ==============================================================================
;
; Copyright (C) 2018  Pablo Edronkin (pablo.edronkin at yahoo.com)
;
;   This program is free software: you can redistribute it and/or modify
;   it under the terms of the GNU Lesser General Public License as published by
;   the Free Software Foundation, either version 3 of the License, or
;   (at your option) any later version.
;
;   This program is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU Lesser General Public License for more details.
;
;   You should have received a copy of the GNU Lesser General Public License
;   along with this program. If not, see <https://www.gnu.org/licenses/>.
;
; ==============================================================================


(define-module (grsp grsp2)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:export (grsp-is-prime
	    grsp-gtls
	    grsp-getles
	    grsp-ps3bl1
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
	    grsp-wagstaff-prime))


; grsp-is-prime - This is a very simple procedure, inefficient, but sufficient for
; small numbers to find if they are prime or not. For large numbers other methods
; qill likely be more adequate.
;
; Arguments:
; - p_n: integer.
;
; Output: 
; - Returns #f of p_n is prime, #f otherwise.
;
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



; grsp-gtls - "gtls = Greater than, less than" Finds if number p_n1 is greater
; than p_n2 and smaller than p_n3.
;
; Arguments:
; - p_n1
; - p_n2
; - p_n3
; 
; Output:
; - Returns #t if the condition holds. #f otherwise.
;
(define (grsp-gtls p_n1 p_n2 p_n3)
  (let ((res #f))
    (cond ((> p_n1 p_n2)
	   (cond ((< p_n1 p_n3)
		  (set! res #t)))))
    res))


; grsp-getles - "getles = Greater or equal than, less or equal than" Finds if
; number p_n1 is greater or equal than p_n2 and smaller or equal than p_n3.
;
; Arguments:
; - p_n1
; - p_n2
; - p_n3
; 
; Output:
; - Returns #t if the condition holds. #f otherwise.
;
(define (grsp-getles p_n1 p_n2 p_n3)
  (let ((res #f))
    (cond ((>= p_n1 p_n2)
	   (cond ((<= p_n1 p_n3)
		  (set! res #t)))))
    res))


; grsp-ps3bl1 - Pseudo tri-boolean 1. Provides a pseudo trinary result.
;
; Arguments: 
; - p_n: number.
;
; Output:
; - Retuns -1, 0 or 1 depending on the number being less than, equal or 
;   greater than zero.
;
(define (grsp-ps3bl1 p_n)
  (let ((res 0))
    (cond ((equal? p_n 0)(set! res 0))
	  ((> p_n 0)(set! res 1))
	  ((< p_n 0)(set! res -1)))
    res))


; grsp-k2nb - Returns the value of (p_k * (p_r**p_n)) + p_b
;
; Arguments:
; - p_k
; - p_r
; - p_n
; - p_b
; 
(define (grsp-krnb p_k p_r p_n p_b)
  (let ((res 0))
    (set! res (+ (* p_k (expt p_r p_n)) p_b))
    res))


; grsp-bpp - Bailey–Borwein–Plouffe formula.
;
; Arguments:
; - p_k: Summation iterations desired.
; - p_b: integer base.
; - p_pf: polynomial with integer coef.
; - p_qf: polynomial with integer coef.
;
; Sources:
; - En.wikipedia.org. (2020). Bailey–Borwein–Plouffe formula. [online]
;   Available at: https://en.wikipedia.org/wiki/Bailey%E2%80%93Borwein%E2%80%93
;   Plouffe_formula [Accessed 9 Jan. 2020].
;
(define (grsp-bpp p_k p_b p_pf p_qf)
  (let ((res 0)
	(k 0))
    (cond ((exact-integer? p_k)
	   (cond ((exact-integer? p_b)
		  (cond ((>= p_b 2)(begin (while (< k p_k)
						 (set! res (+ res (* (/ 1 (expt p_b k)) (/ (p_pf k) (p_qf k)))))
						 (set! k (+ k 1))))))))))
    res))
			 

; grsp-sexp - Performs a non-recursive tetration operation on p_x of height
; p_n. sexp stands for super exponential.
;
; Arguments;
; - p_x: base.
; - p_n: rank or height of the power tower.
;
; Note:
; - This operation might have a significant impact on the performance of your 
;   computer due to its very fast function growth. Use with care.
;
; Sources:
; - En.wikipedia.org. (2020). Hyperoperation. [online] Available at:
;   https://en.wikipedia.org/wiki/Hyperoperation [Accessed 1 Jan. 2020].
;
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


; grsp-slog - Performs a non-recursive super logarithm operation on p_x of height
; p_n.
;
; Arguments;
; - p_x: base.
; - p_n: rank or height of the power tower of the super exponentiation for which.
;   grsp-slog is inverse.
;
; Note:
; - This operation might have a significant impact on the performance of your 
;   computer due to its very fast function growth. Use with care.
;
(define (grsp-slog p_x p_n)
  (let ((res 0))
     (set! res (/ 1 (grsp-sexp p_x p_n)))
     res))


; grsp-woodall-number - Calculates the Woodall number of p_n.
;
; Arguments:
; - p_n: any natural number.
;
; Output:
; - If p_n is not a natural number, the function returns 1. Otherwise, it
;   returns the Woodall number of p_n.
;
; Sources:
; - En.wikipedia.org. (2020). Woodall number. [online] Available at:
;   https://en.wikipedia.org/wiki/Woodall_number
;   [Accessed 6 Jan. 2020].En.wikipedia.org. (2020).
;
(define (grsp-woodall-number p_n)
  (let ((res 1))
    (cond ((exact-integer? p_n)(cond ((> p_n 0)(set! res (grsp-krnb p_n 2 p_n -1))))))
    res))


; grsp-cullen-number - Calculates the Cullen number of p_n.
;
; Arguments:
; - p_n: any natural number.
;
; Output:
; - If p_n is not a natural number, the function returns 1. Otherwise, it
;   returns the Cullen number of p_n.
;
; Sources:
; - En.wikipedia.org. (2020). Cullen number. [online] Available at:
;   https://en.wikipedia.org/wiki/Cullen_number [Accessed 6 Jan. 2020].
;
(define (grsp-cullen-number p_n)
  (let ((res 1))
    (cond ((exact-integer? p_n)(cond ((> p_n 0)(set! res (grsp-krnb p_n 2 p_n 1))))))
    res))

; grsp-proth-number - Returns the value of a Proth number if:
; - Both p_n and p_k are positive integers.
; - p_k s odd.
; - 2**p_n > p_k.
;
; Arguments:
; - p_k: positive integer.
; - p_n: positive integer.
;
; Output:
; - 0 if p_n and p_k do not fill the requisites to calculate a Proth number.
; - The Proth number if both p_n and p_k satisfy the conditions mentioned.
;
; Sources:
; - En.wikipedia.org. (2020). Proth prime. [online] Available at:
;   https://en.wikipedia.org/wiki/Proth_prime [Accessed 9 Jan. 2020].
;
(define (grsp-proth-number p_n p_k)
  (let ((res 0))
    (cond ((exact-integer? p_n)
	   (cond ((exact-integer? p_k)
		  (cond ((odd? p_k)
			 (cond ((> (expt 2 p_n) p_k)
				(set! res (grsp-krnb p_k 2 p_n 1))))))))))
    res))


; grsp-mersenne-number - Calculates a Mersenne number according to Mn = 2**p_n -1 .
;
; Arguments:
; - p_n positive integer.
;
; Output:
; - 0 if p_n is not a positive integer.
; - Mn if p_n is a positive integer.
;
; Sources:
; - Mersenne.org. (2020). Great Internet Mersenne Prime Search - PrimeNet.
; [online] Available at: https://www.mersenne.org/ [Accessed 9 Jan. 2020].
;
(define (grsp-mersenne-number p_n)
  (let ((res 0))
    (cond ((exact-integer? p_n)
	   (set! res (grsp-krnb 1 2 p_n -1))))
    res))
	  

; grsp-repdigit-number - Produces a repdigit number composed by p_n repeated
; p_d instances.
;
; Arguments:
; - p_n: Natural number between [1,9].
; - p_d: Natural number.
;
; Sources:
; - En.wikipedia.org. (2020). Repdigit. [online] Available at:
;   https://en.wikipedia.org/wiki/Repdigit [Accessed 11 Jan. 2020].
;
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


; grsp-wagstaff-number - Producesa Wagstaff number of base p_b.
;
; Arguments:
; - p_n: Natural number.
; - p_b: Natural number >= 2.
;
; Output:
; - If conditions for arguments are met, the result is a Wagstaff number. Otherwise
; the function returns zero.
;
; Sources:
; - En.wikipedia.org. (2020). Wagstaff prime. [online] Available at:
; https://en.wikipedia.org/wiki/Wagstaff_prime [Accessed 11 Jan. 2020].
;
(define (grsp-wagstaff-number p_n p_b)
  (let ((res 0))
    (cond ((exact-integer? p_n)
	   (cond ((exact-integer? p_b)
		  (cond ((>= p_n 1)
			 (cond ((>= p_b 2)
				(set! res (* 1.0 (/ (+ (expt p_b p_n) 1) (+ p_b 1))))))))))))
    res))


; grsp-williams-number - Produces a Williams number of base p_b.
;
; Arguments:
; - p_n: Natural number >= 1.
; - p_b: Natural number >= 2.
;
; Output:
; - If conditions for arguments are met, the result is a Wagstaff number. Otherwise
; the function returns zero.
;
; Sources:
; - En.wikipedia.org. (2020). Williams number. [online] Available at:
; https://en.wikipedia.org/wiki/Williams_number [Accessed 11 Jan. 2020].
;
(define (grsp-williams-number p_n p_b)
  (let ((res 0))
    (cond ((exact-integer? p_n)
	   (cond ((exact-integer? p_b)
		  (cond ((>= p_n 1)
			 (cond ((>= p_b 2)    
				(set! res (- (* (- p_b 1) (expt p_b p_n)) 1))))))))))
    res))


; grsp-thabit-number - Produces a Thabit number.
;
; Arguments:
; - p_n: Natural number >= 0.
;
; Output:
; - If conditions for arguments are met, the result is a Thabit number. Otherwise
; the function returns zero.
;
(define (grsp-thabit-number p_n)
  (let ((res 0))
    (cond ((exact-integer? p_n)
	   (cond ((>= p_n 0)
		  (set! res (- (* 3 (expt 2 p_n)) 1))))))
    res))


; grsp-fermat-number - Produces a Fermat numbernumber.
;
; Arguments:
; - p_n: non-negative integer.
;
; Output:
; - If conditions for arguments are met, the result is a Fermat number. Otherwise
; the function returns zero.
;
(define (grsp-fermat-number p_n)
  (let ((res 0))
    (cond ((exact-integer? p_n)
	   (cond ((>= p_n 0)
		  (set! res (+ (expt 2 (expt 2 p_n)) 1))))))
    res))

		  
; grsp-wagstaff-prime - Produces a Wagstaff prime number.
;
; Arguments:
; - p_n: Prime number.
;
; Output:
; - A Wagstaff prime if p_n is prime, zero otherwise.
;
; Sources:
; - En.wikipedia.org. (2020). Wagstaff prime. [online] Available at:
; https://en.wikipedia.org/wiki/Wagstaff_prime [Accessed 11 Jan. 2020].
;
(define (grsp-wagstaff-prime p_n)
  (let ((res 0))
    (cond ((exact-integer? p_n)
	   (cond ((eq? (odd? p_n) #t)
		  (cond ((> p_n 0)
			 (set! res (/ (+ (expt 2 p_n) 1) 3))))))))
    res))

	   
