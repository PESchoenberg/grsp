;; =============================================================================
;;
;; grsp11.scm
;;
;; List algebra and list-related functions.
;;
;; =============================================================================
;;
;; Copyright (C) 2018 - 2023 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;; See code of functions used and their respective source files for more
;; credits and references.
;;
;; - [1] The simplest sorting algorithm (you've never heard of) (2022) YouTube.
;;   YouTube. Available at:
;;   https://www.youtube.com/watch?v=_W0yUJlscRA (Accessed: February 6, 2023). 
;; - [2] ArXiv:2110.01111v1 [cs.DS] 3 Oct 2021 (no date). Available at:
;;   https://arxiv.org/pdf/2110.01111.pdf (Accessed: February 6, 2023). 
;; - [3] Double-ended queue (2022) Wikipedia. Wikimedia Foundation. Available
;;   at: https://en.wikipedia.org/wiki/Double-ended_queue
;;   (Accessed: February 8, 2023). 


(define-module (grsp grsp11)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp5)
  #:use-module (ice-9 threads)
  #:export (grsp-lal-rel
	    grsp-lal-rfl
	    grsp-lal-leql
	    grsp-lal-leqe
	    grsp-lal-opio
	    grsp-lal-opsc
	    grsp-lal-opew
	    grsp-lal-opew-mth
	    grsp-lal-mutation
	    grsp-lal-dev
	    grsp-lal-devt
	    grsp-lal-subcpy
	    grsp-lal-subrep
	    grsp-lal-is-nonnegative
	    grsp-lal-is-positive
	    grsp-lal-density
	    grsp-lal-total-element
	    grsp-lal-is-single-entry
	    grsp-lal-sort
	    grsp-lal-minmax
	    grsp-lal-supp
	    grsp-lal-same-dims
	    grsp-lal-is-multiset
	    grsp-lal-sorts
	    grsp-lal-swap
	    grsp-lal-deque
	    grsp-lal-ll2l))


;;;; grsp-lal-rel - Replace element in list. Replace element p_j1 of list p_l1
;; with value p_n1 if condition p_s1 between p_n1 and element p_j1 is met. This
;; function tests and replaces  if applicable- one single element of p_l1. To
;; test and replace al elements of p_l1 with this method, use grsp-lal-rfl.
;;
;; Keywords:
;;
;; - console, lists
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#!=": not equal.
;;   - "#>": greater.
;;   - "#>=": greater or equal.
;;   - "#<": less.
;;   - "#<=": less orequal.
;;
;; - p_l1: list.
;; - p_j1: number.
;; - p_n1: number.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-lal-rel p_s1 p_n1 p_l1 p_j1)
  (let ((res1 '()))

    (set! res1 p_l1)
    (cond ((equal? p_s1 "#!=")
	   
	   (cond ((equal? (equal? p_n1 (list-ref res1 p_j1)) #f)
		  (list-set! res1 p_j1 p_n1))))
	  
	  ((equal? p_s1 "#>")
	   
	   (cond ((> p_n1 (list-ref res1 p_j1))
		  (list-set! res1 p_j1 p_n1))))
	  
	  ((equal? p_s1 "#>=")
	   
	   (cond ((>= p_n1 (list-ref res1 p_j1))
		  (list-set! res1 p_j1 p_n1))))
	  
	  ((equal? p_s1 "#<")
	   
	   (cond ((< p_n1 (list-ref res1 p_j1))
		  (list-set! res1 p_j1 p_n1))))
	  
	  ((equal? p_s1 "#<=")
	   
	   (cond ((<= p_n1 (list-ref res1 p_j1))
		  (list-set! res1 p_j1 p_n1)))))
    
    res1))


;;;; grsp-lal-rfl - Replaces full list. Evaluates elements of list p_l1 with
;; regards to value p_n1. If condition p_s1 between p_n1 and an element of the
;; list is met, then replace that element with value p_n1. This function tests
;; and replaces - if applicable - all elements of list p_l1. In order to test
;; and replae a single element use grsp-lal-rel.
;;
;; Keywords:
;;
;; - console, lists
;;
;; Parameters:
;;
;; - p_s1: string.
;;   - "#!=": not equal.
;;   - "#>": greater.
;;   - "#>=": greater or equal.
;;   - "#<": less.
;;   - "#<=": less or equal.
;;
;; - p_l1: list.
;; - p_n1: number.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-lal-rfl p_s1 p_n1 p_l1)
  (let ((res1 '())
	(hn 0))

    (set! hn (length p_l1))
    (set! res1 p_l1)

    ;; Cycle.
    (let loop ((j1 0))
      (if (< j1 hn)
	  (begin (set! res1 (grsp-lal-rel p_s1 p_n1 res1 j1))
		 (loop (+ j1 1)))))    
    
    res1))


;;;; grsp-lal-leql - Returns #t if lists p_l1 and p_l2 are of the same length,
;; #f otherwise.
;;
;; Keywords:
;;
;; - function, algebra, lists, lenght, quantity
;;
;; Parameters:
;;
;; - p_l1: list.
;; - p_l2: list.
;;
;; Output:
;;
;; - Boolean.
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
;; Keywords:
;;
;; - function, algebra, lists, equality, equivalent, equivalence
;;
;; Parameters:
;;
;; - p_l1: list.
;; - p_l2: list.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-lal-leqe p_l1 p_l2)
  (let ((res1 #f)
	(res2 #f)
	(hn 0))

	(cond ((equal? (grsp-lal-leql p_l1 p_l2) #t)
	       (set! hn (length p_l1))
	       (set! res2 #t)

	       ;; Cycle.
	       (let loop ((j1 0))
		 (if (< j1 hn)
		     (begin (cond ((equal? (equal? (list-ref p_l1 j1)
						   (list-ref p_l2 j1)) #f)
				   (set! res2 #f)))
			    (loop (+ j1 1)))))))
    
    res2))

;;;; grsp-lal-opio - Internal operations that produce a scalar result.
;;
;; Keywords:
;;
;; - function, algebra, lists
;;
;; Parameters;
;;
;; - p_s1: string representing the desired operation.
;;
;;   - "#+": sum of all elements.
;;   - "#-": substraction of all elements.
;;   - "#*": product of all elements.
;;   - "#/": division of all elements.
;;
;; - p_l1: list.
;;
;; Output:
;;
;; - Numeric.
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
;;
;; - function, algebra, lists
;;
;; Parameters:
;;
;; - p_s: scalar operation.
;;
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
;;
;; - p_l1: list.
;; - p_v1: scalar value.
;;
;; Notes:
;;
;; - You may need to use seed->random-state for pseudo random numbers.
;; - See grsp0.grsp-random-state-set.
;;
;; Sources:
;;
;; - grsp3.[5], grsp3.[6].
;;
;; Output:
;;
;; - List.
;;
(define (grsp-lal-opsc p_s1 p_l1 p_v1)
  (let ((res1 0)
	(res2 0)
	(res3 '()))

    (set! res2 (grsp-l2m p_l1))
    (set! res2 (grsp-matrix-opsc p_s1 res2 p_v1))
    (set! res3 (grsp-m2l res2))
    
    res3))


;;;; grsp-lal-opew - Performs element-wise operation p_s1 between lists
;; p_l1 and p_l2.
;;
;; Keywords:
;;
;; - function, algebra, lists
;;
;; Parameters:
;;
;; - p_s1: operation described as a string:
;;
;;   - "#+": sum.
;;   - "#-": substraction.
;;   - "#*": multiplication.
;;   - "#/": division.
;;   - "#expt": element wise (expt p_a1 p_a2).
;;   - "#max": element wise max function.
;;   - "#min": element wise min function.
;;   - "#=": copy if equal.
;;   - "#!=": copy if not equal.
;;
;; - p_l1: first list.
;; - p_l2: second list.
;;
;; Notes:
;;
;; - This function does not validate the dimensionality or boundaries of the 
;;   lists involved; the user or an additional shell function should take 
;;   care of that.
;; - Both lists should contain numeric elements.
;; - See grsp-matrix-opew.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-lal-opew p_s1 p_l1 p_l2)
  (let ((res1 '())
	(res2 0)
	(a1 0)
	(a2 0))

    ;; Convert both lists into matrices.
    (set! a1 (grsp-l2m p_l1))
    (set! a2 (grsp-l2m p_l2))
    
    ;; Apply grsp-matrix-opew
    (set! res2 (grsp-matrix-opew p_s1 a1 a2))
    
    ;; Convert resulting matrix into list.
    (set! res1 (grsp-m2l res2))
    
    res1))


;;;; grsp-lal-opew - Performs element-wise operation p_s1 between lists
;; p_l1 and p_l2, multithreaded.
;;
;; Keywords:
;;
;; - function, algebra, lists
;;
;; Parameters:
;;
;; - p_s1: operation described as a string:
;;
;;   - "#+": sum.
;;   - "#-": substraction.
;;   - "#*": multiplication.
;;   - "#/": division.
;;   - "#expt": (expt p_a1 p_a2).
;;   - "#max": max function.
;;   - "#min": min function.
;;
;; - p_l1: first list.
;; - p_l2: second list.
;;
;; Notes:
;;
;; - This function does not validate the dimensionality or boundaries of the 
;;   lists involved; the user or an additional shell function should take 
;;   care of that.
;; - Both lists should contain numeric elements.
;; - See grsp-matrix-opew.
;; - This function works as a convenience wrapper for par-map; it is not
;;   necessarily more efficient than par-map itself.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-lal-opew-mth p_s1 p_l1 p_l2)
  (let ((res1 '()))

    (cond ((equal? p_s1 "#+")
	   (set! res1 (par-map + p_l1 p_l2)))
	  ((equal? p_s1 "#-")
	   (set! res1 (par-map - p_l1 p_l2)))
	  ((equal? p_s1 "#*")
	   (set! res1 (par-map * p_l1 p_l2)))
	  ((equal? p_s1 "#/")
	   (set! res1 (par-map / p_l1 p_l2)))
	  ((equal? p_s1 "#expt")
	   (set! res1 (par-map expt p_l1 p_l2)))
	  ((equal? p_s1 "#max")
	   (set! res1 (par-map max p_l1 p_l2)))
	  ((equal? p_s1 "#min")
	   (set! res1 (par-map min p_l1 p_l2))))
	  
    res1))
	

;;;; grsp-lal-mutation - Produces random mutations in the values of elements 
;; of list p_l1.
;;
;; Keywords:
;;
;; - function, algebra, lists, genetic, random, mutation, mutate
;;
;; Parameters:
;;
;; - p_l1: list.
;; - p_n1: mutation rate, [0, 1].
;; - p_s1: type of distribution.
;;
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;;
;; - p_u1: mean for mutation rate.
;; - p_v1: standard deviation for mutation rate.
;; - p_s2: type of distribution.
;;
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;;
;; - p_u2: mean for element random value.
;; - p_v2: standard deviation for element random value.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-lal-mutation p_l1 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2)
  (let ((res1 '())
	(res2 0))

    (set! res2 (grsp-l2m p_l1))
    (set! res2 (grsp-matrix-mutation res2 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2))
    (set! res1 (grsp-m2l res2))
    
    res1))


;;;; grsp-lal-dev - Display, enumerated vertically. Displays list elements, each
;; on a different line.
;;
;; Keywords:
;;
;; - function, algebra, lists, show
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: shows element ordinals.
;;   - #f: does not show ordinals.
;;
;; - p_l1: list.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-lal-dev p_b1 p_l1)
  (let ((nh 0))

    (set! nh (length p_l1))
    (let loop ((j1 0))
      (if (< j1 nh)
	  (begin (cond ((equal? p_b1 #t)
			(pres2 (grsp-n2s j1) (list-ref p_l1 j1)))
		       (else (pres2 " " (list-ref p_l1 j1))))
		 (loop (+ j1 1)))))))


;;;; grsp-lal-devt - Display, enumerated vertically. Displays all elements
;; of list p_l1 vertically with titles from p_l2.
;;
;; Keywords:
;;
;; - function, algebra, lists, show
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: shows element names.
;;   - #f: does not show names.
;;
;; - p_l1: list.
;; - p_l2: list.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-lal-devt p_b1 p_l1 p_l2)
  (let ((nh 0)
	(s1 0)
	(s2 0))

    (set! nh (length p_l1))
    (let loop ((j1 0))
      (if (< j1 nh)
	  (begin (set! s1 (grsp-n2s j1))
		 (set! s2 (list-ref p_l2 j1))
		 
		 (cond ((equal? p_b1 #t)
			(pres2 (strings-append (list s1 s2) 1) (list-ref p_l1 j1)))
		       (else (pres2 s2 (list-ref p_l1 j1))))
		 (loop (+ j1 1)))))))


;;;; grsp-lal-subcpy - Extracts a block or sub list from list p_l1. The
;; process is not destructive with regards to p_l1. The user is responsible for
;; providing correct boundaries since the function does not check those
;; parameters in relation to p_l1.
;;
;; Keywords:
;;
;; - function, algebra, lists, subset
;;
;; Parameters:
;;
;; - p_a1: list.
;; - p_ln1: lower n boundary (elem).
;; - p_hn1: higher n boundary (elem).
;;
;; Output:
;;
;; - List.
;;
(define (grsp-lal-subcpy p_l1 p_ln1 p_hn1)
  (let ((res1 '())
	(a1 0)
	(a2 0))

    ;; Convert list to matrix.
    (set! a1 (grsp-l2m p_l1))

    ;; Extract submatrix.
    (set! a2 (grsp-matrix-subcpy a1 (grsp-lm a1) (grsp-hm a1) p_ln1 p_hn1))

    ;; Convert extracted submatrix to list.
    (set! res1 (grsp-m2l a2))
    
    res1))


;;;; grsp-lal-subrep - Replaces a submatrix or section of list p_l1 with 
;; list p_l2.
;;
;; Keywords:
;;
;; - function, algebra, lists, subset
;;
;; Parameters:
;;
;; - p_l1: list.
;; - p_l2: list.
;; - p_n1: element number of p_l1 where to place the initial element of p_l2.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-lal-subrep p_l1 p_l2 p_n1)
  (let ((res1 '())
	(a1 0)
	(a2 0)
	(a3 0))

    ;; Convert lists to matrix format.
    (set! a1 (grsp-l2m p_l1))
    (set! a2 (grsp-l2m p_l2))
    
    ;; Replace with a2.
    (set! a3 (grsp-matrix-subrep a1 a2 (grsp-lm a1) p_n1))

    ;; Convert extracted submatrix to list.
    (set! res1 (grsp-m2l a3))	

    res1))


;;;; grsp-lal-is-nonnegative - Returns #t if p_l1 contains only values >= 0.
;;
;; Keywords:
;;
;; - function, algebra, lists
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-lal-is-nonnegative p_l1)
  (let ((res1 #f)
	(a1 0))

    ;; Convert list to matrix format.
    (set! a1 (grsp-l2m p_l1))

    ;; Query matrix.
    (cond ((equal? (grsp-matrix-find "#<" a1 0) 0)	   
	   (set! res1 #t)))

    res1))


;;;; grsp-lal-is-positive - Returns #t if p_l1 contains only values > 0.
;;
;; Keywords:
;;
;; - function, algebra, lists
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-lal-is-positive p_l1)
  (let ((res1 #f)
	(a1 0))

    ;; Convert list to matrix format.
    (set! a1 (grsp-l2m p_l1))

    ;; Query matrix.
    (cond ((equal? (grsp-matrix-find "#<=" a1 0) 0)	   
	   (set! res1 #t)))

    res1))


;;;; grsp-list-density - Returns the density value of list p_l1.
;;
;; Keywords:
;;
;; - function, algebra, lists
;;
;; Parameters:
;;
;; - p_l1: numeric list.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-lal-density p_l1)
  (let ((res1 0)
	(a1 0))

    (set! a1 (grsp-l2m p_l1))
    (set! res1 (grsp-matrix-density a1))

    res1))


;;;; grsp-lal-total-element - Counts the number of ocurrences of p_n1 in p_l1.
;;
;; Keywords:
;;
;; - function, algebra, lists, quantity, total, instances
;;
;; Parameters:
;;
;; - p_l1: list.
;; - p_n1: element.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-lal-total-element p_l1 p_n1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-total-element (grsp-l2m p_l1) p_n1))

    res1))


;;;; grsp-lal-is-single-entry - Returns #t if list p_l1 is of single entry 
;; type for value p_n1; #f otherwise.
;;
;; Keywords:
;;
;; - function, algebra, lists, single, equal
;;
;; Parameters:
;;
;; - p_l1: list.
;; - p_n1: element.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-lal-is-single-entry p_l1 p_n1)
  (let ((res1 #f))

    (set! res1 (grsp-matrix-is-single-entry (grsp-l2m p_l1) p_n1))
    
    res1))


;;;; grsp-lal-sort - Sort elements in list p_l1 in ascending or descending
;; order.
;;
;; Keywords:
;;
;; - function, algebra, lists, ordering
;;
;; Parameters
;;
;; - p_s1: sort type.
;;
;;   - "#asc": ascending.
;;   - "#des": descending.
;;
;; - p_l1: matrix.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-lal-sort p_s1 p_l1)
  (let ((res1 '()))

    (set! res1 (grsp-matrix-sort p_s1 (grsp-l2m p_l1)))
	
    res1))


;;;; grsp-lal-minmax - Finds the maximum and minimum values in p_l1.
;;
;; Keywords:
;;
;; - function, algebra, lists, minmax, max, min
;;
;; Parameters:
;;
;; - p_a1: list.
;;
;; Output:
;;
;; - A list containing the min and max values, respectively.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-lal-minmax p_l1)
  (let ((res1 '()))

    (set! res1 (grsp-matrix-minmax (grsp-l2m p_l1)))

    res1))


;;;; grsp-lal-supp - Given list p_l1 with n elements, it returns a
;; list that contains one instance per each element value contained in p_11.
;; That is, it elimitates repeated instances of the elements of p_l1 and
;; returns its domain subset.
;;
;; Keywords:
;;
;; - function, algebra, lists, instances
;;
;; Parameters:
;;
;; - p_l1: list.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-lal-supp p_l1)
  (let ((res1 '()))

    (set! res1 (grsp-matrix-supp (grsp-l2m p_l1)))

    res1))


;;;; grsp-lal-same_dims - Checks if p_l1 and p_l2 have the same number of
;; elements.
;;
;; Keywords:
;;
;; - function, algebra, lists, equality, quantity
;;
;; Parameters:
;;
;; - p_l1: list.
;; - p_l2: list.
;;
;; Output:
;;
;; - Returns #t if both lists have the same number of elements; #f otherwise.
;;
(define (grsp-lal-same-dims p_l1 p_l2)
  (let ((res1 #f))

    (cond ((equal? (length p_l1) (length p_l2))
	   (set! res1 #t)))
    
    res1))


;;;; grsp-lal-is-multiset - Returns #t if the list has repeated elements;
;; #f otherwise.
;;
;; Keywords:
;;
;; - function, algebra, matrix, matrices, vectors, repetition
;;
;; Parameters:
;;
;; - p_l1: list.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-lal-is-multiset p_l1)
  (let ((res1 #f))

    (set! res1 (grsp-matrix-is-multiset (grsp-l2m p_l1)))
    
    res1))


;;;; grsp-lal-sorts
;;
;; Keywords:
;;
;; - list, sort, sorting
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#asc": sort on ascending order.
;;   - "#des": sort on descending order.
;;
;; - p_l1: list, numeric.
;;
;; Output:
;;
;; - List, numeric.
;;
(define (grsp-lal-sorts p_s1 p_l1)
  (let ((res1 '())
	(n1 (length p_l1))
	(ai 0)
	(aj 0)
	(as 0)
	(i1 0)
	(j1 0))

    (set! res1 p_l1)
    
    (while (< i1 n1)

	   (set! j1 0)
	   (while (< j1 n1)

		  ;; Read elements from list.
		  (set! aj (list-ref res1 j1))
		  (set! ai (list-ref res1 i1))
		  
		  ;; Swap if required.
		  (cond ((equal? p_s1 "#asc")
		  
			 (cond ((< ai aj)
				(set! as ai)
				(list-set! res1 i1 aj)
				(list-set! res1 j1 as))))
			
			((equal? p_s1 "#des")

			 (cond ((> ai aj)
				(set! as ai)
				(list-set! res1 i1 aj)
				(list-set! res1 j1 as)))))
		  
		  (set! j1 (in j1)))

	   (set! i1 (in i1)))
    
    res1))


;;;; grsp-lal-swap - Swaps elements p_n1 and p_n2 of list p_l1.
;;
;; Keywords:
;;
;; - function, lists, swap. change, move
;;
;; Parameters:
;;
;; - p_l1: list.
;; - p_n1; numeric, Element number within p_l1.
;; - p_n2; numeric, Element number within p_l1.
;;
;; Output:
;;
;; - List with:
;;
;;   - Element p_n1 of list p_l1 in position p_n2.
;;   - Element p_n2 of list p_l1 in position p_n1.
;;
(define (grsp-lal-swap p_l1 p_n1 p_n2)
  (let ((res1 '())
	(n3 0))

    (set! res1 p_l1)
    
    (set! n3 (list-ref res1 p_n1))
    (list-set! res1 p_n1 (list-ref res1 p_n2))
    (list-set! res1 p_n2 n3)

    res1))


;;;; grsp-lal-deque - Uses list p-l1 as a double ended queue.
;; Keywords:
;;
;; - function, lists, swap. change, move, queues
;;
;; Parameters:
;;
;; - p_s1: string. Operation.
;;
;;   - "#en". Enqueue.
;;   - "#de". Dequeue.
;;
;; - p_b1:
;;  
;;   - #t: beginning of the queue.
;;   - #f: end of the queue.
;;
;; - p_l1: list.
;; - p_v1: value to enqueue (leave to zero or equivalent void type
;;   value for #de). 
;;
;; Output:
;;
;; - List.
;;
;; Sources:
;;
;; - [3].
;;
(define (grsp-lal-deque p_s1 p_b1 p_l1 p_v1)
  (let ((res1 '())
	(res2 '())
	(ln 0)
	(hn (- (length p_l1) 1)))

    (set! res1 p_l1)
    (set! res2 (list p_v1))
    
    (cond ((equal? p_b1 #t)

	   (cond ((equal? p_s1 "#en")
		  (set! res1 (append res2 res1)))
		 ((equal? p_s1 "#de")
		  (set! res1 (list-tail p_l1 1)))))
	  
	  ((equal? p_b1 #f)

	   (cond ((equal? p_s1 "#en")
		  (set! res1 (append res1 res2)))
		 ((equal? p_s1 "#de")
		  (set! res1 (list-head p_l1 (- (length p_l1) 1)))))))
    
    res1))


;;;; grsp-lal-ll2l - Returns a list containing lists p_l1 and p_l2,
;;
;; Keywords:
;;
;; - lists, growth, duplication, accretion
;;
;; Parameters:
;;
;; - p_l1: list.
;; - p_l2: list.
;;
;; Output:
;;
;; - List containing two elements:
;;
;;   - Elem 0: p_l1.
;;   - Elem 1: p_l2.
;;
(define (grsp-lal-ll2l p_l1 p_l2)
  (let ((res1 '()))
    
    ;; Compose results.
    (set! res1 (list p_l1 p_l2))
    
    res1))
