;; =============================================================================
;;
;; grsp11.scm
;;
;; List algebra functions.
;;
;; =============================================================================
;;
;; Copyright (C) 2018 - 2021 Pablo Edronkin (pablo.edronkin at yahoo.com)
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


(define-module (grsp grsp11)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp3)  
  #:export (grsp-lal-rel
	    grsp-lal-rfl
	    grsp-lal-leql
	    grsp-lal-leqe
	    grsp-lal-opio
	    grsp-lal-opsc
	    grsp-lal-mutation))


;;;; grsp-lal-rel - Replace element in list. Replace element p_j1 of list p_l1
;; with value p_n1 if condition p_s1 between p_n1 and element p_j1 is met. This
;; function tests and replaces  if applicable- one single element of p_l1. To
;; test and replace al elements of p_l1 with this method, use grsp-lal-rfl.
;;
;; Keywords:
;; - console, lists.
;;
;; Arguments:
;; - p_s1: string.
;;   - "#!=": not equal.
;;   - "#>": greater.
;;   - "#>=": greater or equal.
;;   - "#<": less.
;;   - "#<=": less orequal.
;; - p_l1: list.
;; - p_j1: number.
;; - p_n1: number.
;;
(define (grsp-lal-rel p_s1 p_n1 p_l1 p_j1)
  (let ((res1 '()))

    (set! res1 p_l1)
    (cond ((equal? p_s1 "#!=")
	   (cond ((equal? (equal? p_n1 (list-ref res1 p_j1)) #f)
		  (list-set! p_l1 p_j1 p_n1))))
	  ((equal? p_s1 "#>")
	    (cond ((> p_n1 (list-ref res1 p_j1))
		   (list-set! p_l1 p_j1 p_n1))))
	  ((equal? p_s1 "#>=")
	   (cond ((>= p_n1 (list-ref res1 p_j1))
		  (list-set! p_l1 p_j1 p_n1))))
	  ((equal? p_s1 "#<")
	   (cond ((< p_n1 (list-ref res1 p_j1))
		  (list-set! p_l1 p_j1 p_n1))))
	  ((equal? p_s1 "#<=")
	   (cond ((<= p_n1 (list-ref res1 p_j1))
		  (list-set! p_l1 p_j1 p_n1)))))
    
    res1))


;;;; grsp-lal-rfl - Replaces full list. Evaluates elements of list p_l1 with
;; regards to value p_n1. If condition p_s1 between p_n1 and an element of the
;; list is met, then replace that element with value p_n1. This function tests
;; and replaces - if applicable - all elements of list p_l1. In order to test
;; and replae a single element use grsp-lal-rel.
;;
;; Keywords:
;; - console, lists.
;;
;; Arguments:
;; - p_s1: string.
;;   - "#!=": not equal.
;;   - "#>": greater.
;;   - "#>=": greater or equal.
;;   - "#<": less.
;;   - "#<=": less orequal.
;; - p_l1: list.
;; - p_n1: number.
;;
(define (grsp-lal-rfl p_s1 p_n1 p_l1)
  (let ((res1 '())
	(hn 0)
	(j1 0))

    (set! hn (length p_l1))
    (set! res1 p_l1)
    (while (< j1 hn)
	   (set! res1 (grsp-lal-rel p_s1 p_n1 res1 j1))
	   (set! j1 (in j1)))

    res1))


;;;; grsp-lall-leql - Returns #t if lists p_l1 and p_l2 are of the same length,
;; #f otherwise.
;;
;; Arguments:
;; - p_l1: list.
;; - p_l2: list.
;;
(define (grsp-lal-leql p_l1 p_l2)
  (let ((res1 #f))

    (cond ((equal? (length p_l1) (length p_l2))
	   (set! res1 #t)))
    
    res1))


;;;; grsp-lal-leqe - Returns #t if element n1 of list p_l1 is equal to element
;; n1 of p_l2 in all instances. That is, the function returns #t if both lists
;; are equal.
;;
;; Arguments:
;; - p_l1: list.
;; - p_l2: list.
;;
(define (grsp-lal-leqe p_l1 p_l2)
  (let ((res1 #f)
	(res2 #f)
	(hn 0)
	(j1 0))

    (cond ((equal? (grsp-lal-leql p_l1 p_l2) #t)
	   (set! hn (length p_l1))
	   (set! res2 #t)
	   (while (< j1 hn)
		  (cond ((equal? (equal? (list-ref p_l1 j1)
					 (list-ref p_l2 j1)) #f)
			 (set! res2 #f)))
		  (set! j1 (in j1)))))		  
	    
    res2))

;;;; grsp-lal-opio - Internal operations that produce a scalar result.
;;
;; Keywords:
;; - function, algebra, lists.
;;
;; Arguments;
;; - p_s1: string representing the desired operation.
;;   - "#+": sum of all elements.
;;   - "#-": substraction of all elements.
;;   - "#*": product of all elements.
;;   - "#/": division of all elements.
;; - p_l1: list.
;;
;; Output:
;; - Scalar value.
;;
(define (grsp-lal-opio p_s1 p_l1)
  (let ((res1 0)
	(res2 0))

    (set! res2 (grsp-l2m p_l1))
    (set! res1 (grsp-matrix-opio p_s1 res2 0))
    
    res1))


;;;; grsp-lal-opsc - Performs an operation p_s1 between list p_l1 and
;; scalar p_v1 or a discrete operation on p_l1.
;;
;; Keywords:
;; - function, algebra, lists.
;;
;; Arguments:
;; - p_s: scalar operation.
;;   - "#+": scalar sum.
;;   - "#-": scalar substraction.
;;   - "#*": scalar multiplication.
;;   - "#/": scalar division.
;;   - "#expt": applies expt function to each element of p_l1.
;;   - "#max": applies max function to each element of p_l1.
;;   - "#min": applies min function to each element of p_l1.
;;   - "#rw": replace all elements of p_l1 with p_v1 regardless of their value.
;;   - "#rprnd": replace all elements of p_l1 with pseudo random numbers in a
;;      normal distribution with mean 0.0 and standard deviation equal to p_v1.
;;   - "#si": applies (grsp-complex-inv "#si" z1) to each element z1 of p_l1
;;     (complex conjugate).
;;   - "#is": applies (grsp-complex-inv "#is" z1) to each element z1 of p_l1
;;     (sign inversion of real element of complex number).
;;   - "#ii": applies (grsp-complex-inv "#ii" z1) to each element z1 of p_l1
;;     (sign inversion of both elements of a complex number).
;; - p_l1: list.
;; - p_v1: scalar value.
;;
;; Notes:
;; - You may need to use seed->random-state for pseudo random numbers.
;;
;; Sources:
;; - grsp3.[5], grsp3.[6].
;;
(define (grsp-lal-opsc p_s1 p_l1 p_v1)
  (let ((res1 0)
	(res2 0)
	(res3 '()))

    (set! res2 (grsp-l2m p_l1))
    (set! res2 (grsp-matrix-opsc p_s1 res2 p_v1))
    (set! res3 (grsp-m2l res2))
    
    res3))


;;;; grsp-lal-mutation - Produces random mutations in the values of elements 
;; of list p_l1.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_n1: mutation rate, [0, 1].
;; - p_s1: type of distribution.
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;; - p_u1: mean for mutation rate.
;; - p_v1: standard deviation for mutation rate.
;; - p_s2: type of distribution.
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;; - p_u2: mean for element random value.
;; - p_v2: standard deviation for element random value.
;;
(define (grsp-lal-mutation p_l1 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2)
  (let ((res1 '())
	(res2 0))

    (set! res2 (grsp-l2m p_l1))
    (set! res2 (grsp-matrix-mutation res2 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2))
    (set! res1 (grsp-m2l res2))
    
    res1))
