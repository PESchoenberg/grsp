; ==============================================================================
;
; grsp3.scm
;
; Matrices.
;
; ==============================================================================
;
; Copyright (C) 2020  Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;
; Notes:
; - grsp3 provides some level of matrix algebra functionality for Guile, but in
;  its current version it is not intended to be particulary fast. It does not make
;  use of any additional non-Scheme library like BLAS or Lapack.
; - As a convention here, m represents rows, n represents columns.
;
; Sources:
; - Hep.by. (2020). Array Procedures - Guile Reference Manual. [online] Available
;   at: http://www.hep.by/gnu/guile/Array-Procedures.html#Array-Procedures
;   [Accessed 28 Jan. 2020].
; - En.wikipedia.org. (2020). Numerical linear algebra. [online] Available at:
;   https://en.wikipedia.org/wiki/Numerical_linear_algebra
;   [Accessed 28 Jan. 2020].
; - En.wikipedia.org. (2020). Matrix theory. [online] Available at:
;   https://en.wikipedia.org/wiki/Category:Matrix_theory
;   [Accessed 28 Jan. 2020].
;
; REPL examples:
; (use-modules (grsp grsp0)(grsp grsp1)(grsp grsp2)(grsp grsp3))
; (define X (grsp-matrix-create 1 4 4))
; (define Y (grsp-matrix-create 2 4 4))
; (define R (grsp-matrix-opew "#+" X Y))


(define-module (grsp grsp3)
  #:use-module (grsp grsp2)
  #:export (grsp-matrix-esi
	    grsp-matrix-create
	    grsp-matrix-change
	    grsp-matrix-transpose
	    grsp-matrix-opio
	    grsp-matrix-opsc
	    grsp-matrix-opew
	    grsp-matrix-opfn
	    grsp-matrix-opmm
	    grsp-matrix-sub
	    grsp-matrix-exp))


; grsp-matrix-esi - Extracts shape information from an m x n matrix.
;
; Arguments:
; - p_e: number indicating the element value desired.
; - 1: low boundary for m (rows).
; - 2: high boundary for m (rows).
; - 3: low boundary for n (cols).
; - 4: high boundary for n (cols).
;
; Output:
; - A number corresponding to the shape element value desired. Returns 0 
;    if p_e is incorrect.
;
(define (grsp-matrix-esi p_e p_m)
  (let ((res 0)
	(s 0))
    (set! s (array-shape p_m))
    (cond ((equal? p_e 1)
	   (set! res (car (car s))))
	  ((equal? p_e 2)
	   (set! res (car (cdr (car s)))))
	  ((equal? p_e 3)
	   (set! res (car (car (cdr s)))))
	  ((equal? p_e 4)
	   (set! res (car (cdr (car (cdr s)))))))
    res))
  

; grsp-matrix-create - Creates a p_m x p_n matrix and fill it with element value 
; p_v.
;
; Arguments:
; - p_v: element that will initially fill the matrix.
; - p_m: rows, positive integer.
; - p_n: cols, positive integer.
;
(define (grsp-matrix-create p_v p_m p_n)
  (let ((res 0)
	(t "n")
	(v 0)
	(i 0)
	(j 0))
    (cond ((eq? (grsp-eiget p_m 0) #t)
	   (cond ((eq? (grsp-eiget p_n 0) #t)

		  ; For an identity matrix, First set all elements to 0.
		  (cond ((equal? p_v "#I")
			 (set! v 0))
			(else (set! v p_v)))

		  ; Build the matrix with all elements as 0.
		  (set! res (make-array v p_m p_n))

		  ; Once the matrix has been created, depending on the type of 
		  ; matrix, modify its values.
		  (cond ((equal? p_v "#I")
			 (while (< i p_m)
				(set! j 0)
				(while (< j p_n)
				       (cond ((eq? i j)
					      (array-set! res 1 i j)))
				       (set! j (+ j 1)))
				(set! i (+ i 1)))))))))    
    res))


; grsp-matrix-change - Change the value to p_v2 where the value of a matrix's
; element equals p_v1.
;
; Arguments:
; - p_a: matrix to operate on.
; - p_v1: value to be replaced within p_a.
; - p_v2: value to replace p_v1 with.
;
; Output:
; - A modified matrix p_a in which all p_v1 values would have been replaced by
;   p_v2
;
(define (grsp-matrix-change p_a p_v1 p_v2)
  (let ((res p_a)
	(lm 0)
	(hm 0)
	(ln 0)
	(hn 0)
	(i 0)
	(j 0))

    ; Extract the boundaries of the matrix.
    (set! lm (grsp-matrix-esi 1 res))
    (set! hm (grsp-matrix-esi 2 res))
    (set! ln (grsp-matrix-esi 3 res))
    (set! hn (grsp-matrix-esi 4 res))

    ; Cycle thorough the matrix and change to p_v1 those elements whose value is 
    ; p_v1.
    (set! i lm)
    (while (<= i hm)
	   (set! j ln)
	   (while (<= j hn)
		  (cond ((equal? (array-ref res i j) p_v1)
			 (array-set! res p_v2 i j)))
		  (set! j (+ j 1)))
	   (set! i (+ i 1)))
    res))


; grsp-matrix-transpose - Transposes a matrix of shape m x n into another with
; shape n x m.
;
; Arguments:
; - p_a: matrix to be transposed.
;
(define (grsp-matrix-transpose p_a)
  (let ((res1 p_a)
	(res2 0)
	(lm 0)
	(hm 0)
	(ln 0)
	(hn 0)
	(i 0)
	(j 0))

    ; Extract the boundaries of the matrix.
    (set! lm (grsp-matrix-esi 1 res1))
    (set! hm (grsp-matrix-esi 2 res1))
    (set! ln (grsp-matrix-esi 3 res1))
    (set! hn (grsp-matrix-esi 4 res1))	

    ; Create new matrix with transposed shape.
    (set! res2 (grsp-matrix-create res2 (+ (- hn ln) 1) (+ (- hm lm) 1)))
    
    ; Transpose the elements.
    (set! i lm)
    (while (<= i hm)
	   (set! j ln)
	   (while (<= j hn)
		  (array-set! res2 (array-ref res1 i j) j i)
		  (set! j (+ j 1)))
	   (set! i (+ i 1)))
    res2))


; grsp-matrix-opio - Internal operations that produce a scalar result.
;
; Arguments;
; - p_s: operation.
;   - "#+": sum of all elements.
;   - "#-": substraction of all elements.
;   - "#*": product of all elements.
;   - "#/": division of all elements.
;   - "#+r": sum of all elements of row p_l.
;   - "#-r": substraction of all elements of row p_l.
;   - "#*r": product of all elements of row p_l.
;   - "#/r": division of all elements of row p_l.
;   - "#+c": sum of all elements of col p_l.
;   - "#-c": substraction of all elements of col p_l.
;   - "#*c": product of all elements of col p_l.
;   - "#/c": division of all elements of col p_l.
;   - "#trace": sum of the diagonal elements.
; - p_a: matrix. 
; - p_l: column or row number.
;
; Note:
; - Value for argument p_l should be passed as 0 if not used. It is only
;   needed for row and column operations.
;
(define (grsp-matrix-opio p_s p_a p_l)
  (let ((res1 p_a)
	(res2 0)
	(res3 1)
	(l 0)
	(lm 0)
	(hm 0)
	(ln 0)
	(hn 0)
	(i 0)
	(j 0))

    ; Extract the boundaries of the matrix.
    (set! lm (grsp-matrix-esi 1 res1))
    (set! hm (grsp-matrix-esi 2 res1))
    (set! ln (grsp-matrix-esi 3 res1))
    (set! hn (grsp-matrix-esi 4 res1))

    (set! l p_l)
    (cond ((equal? p_s "#*")
	   (set! res2 1))
	  ((equal? p_s "#/")
	   (set! res2 1))	  
	  ((equal? p_s "#*r")
	   (set! res2 1))
	  ((equal? p_s "#/r")
	   (set! res2 1))
	  ((equal? p_s "#*c")
	   (set! res2 1))
	  ((equal? p_s "#/c")
	   (set! res2 1)))	  
	  
    ; Apply internal operation.
    (set! i lm)
    (while (<= i hm)
	   (set! j ln)
	   (while (<= j hn)
		  (cond ((equal? p_s "#+")
			 (set! res2 (+ res2 (array-ref res1 i j))))	  
			((equal? p_s "#-")
			 (set! res2 (- res2 (array-ref res1 i j))))
			((equal? p_s "#*")
			 (set! res2 (* res2 (array-ref res1 i j))))
			((equal? p_s "#/")
			 (set! res2 (/ res2 (array-ref res1 i j))))

			; Diagonal operations.
			((equal? p_s "#trace")
			 (cond ((equal? (grsp-gtels i j) 0)
				(set! res2 (+ res2 (array-ref res1 i j)))))))
			
		  ; Row operations.
		  (cond ((= l i)
			 (cond ((equal? p_s "#+r")
				(set! res2 (+ res2 (array-ref res1 i j))))
			       ((equal? p_s "#-r")
				(set! res2 (- res2 (array-ref res1 i j))))
			       ((equal? p_s "#*r")
				(set! res2 (* res2 (array-ref res1 i j))))
			       ((equal? p_s "#/r")
				(set! res2 (/ res2 (array-ref res1 i j)))))))

		  ; Column operations.
		  (cond ((= l j)
			 (cond ((equal? p_s "#+c")
				(set! res2 (+ res2 (array-ref res1 i j))))
			       ((equal? p_s "#-c")
				(set! res2 (- res2 (array-ref res1 i j))))
			       ((equal? p_s "#*c")
				(set! res2 (* res2 (array-ref res1 i j))))
			       ((equal? p_s "#/c")
				(set! res2 (/ res2 (array-ref res1 i j)))))))			       

		  (set! j (+ j 1)))
	   (set! i (+ i 1)))
    res2))


; grsp-matrix-opsc - Performs an operation p_s between matrix p_a and scalar
; p_v or a discrete operation on p_a.
;
; Arguments:
; - p_s: scalar operation.
;   - "#+": scalar sum.
;   - "#-": scalar substraction.
;   - "#*": scalar multiplication.
;   - "#/": scalar division.
;   - "#expt": applies expt function to each element of p_a.
;   - "#max": applies max function to each element of p_a.
;   - "#min": applies min function to each element of p_a.
;   - "#rw": replace all elements of p_a with p_v regardless of their value.
;   - "#rprnd": replace all elements of p_a with pseudo random numbers in a
;      normal distribution with mean 0.0 and standard deviation equal to p_v.
;   - "#L": obtains the L matrix of p_a for a LU decomposition.
;   - "#U": obtains the U matrix of p_a for a LU decomposition.
; - p_a: matrix.
; - p_v: scalar value.
;
; Notes:
; - You may need to use seed->random-state for pseudo random numbers.
; - This function does not validate the dimensionality or boundaries of the 
;   matrices involved; the user or an additional shell function should take care
;   of that.
;
; Sources:
; - Gnu.org. (2020). Random (Guile Reference Manual). [online] Available at:
;   https://www.gnu.org/software/guile/manual/html_node/Random.html
;   [Accessed 26 Jan. 2020].
; - Es.wikipedia.org. (2020). Factorización LU. [online] Available at:
;   https://es.wikipedia.org/wiki/Factorizaci%C3%B3n_LU
;   [Accessed 28 Jan. 2020].
;
(define (grsp-matrix-opsc p_s p_a p_v)
  (let ((res1 p_a)
	(res2 2)
	(lm 0)
	(hm 0)
	(ln 0)
	(hn 0)
	(i 0)
	(j 0))

    ; Extract the boundaries of the matrix.
    (set! lm (grsp-matrix-esi 1 res1))
    (set! hm (grsp-matrix-esi 2 res1))
    (set! ln (grsp-matrix-esi 3 res1))
    (set! hn (grsp-matrix-esi 4 res1))

    ; Create holding matrix.
    (set! res2 (grsp-matrix-create res2 (+ (- hm ln) 1) (+ (- hn ln) 1)))
    
    ; Apply scalar operation.
    (set! i lm)
    (while (<= i hm)
	   (set! j ln)
	   (while (<= j hn)
		  (cond ((equal? p_s "#+")
			 (array-set! res2 (+ (array-ref res1 i j) p_v) i j))
			((equal? p_s "#-")
			 (array-set! res2 (- (array-ref res1 i j) p_v) i j))
			((equal? p_s "#*")
			 (array-set! res2 (* (array-ref res1 i j) p_v) i j))
			((equal? p_s "#/")
			 (array-set! res2 (/ (array-ref res1 i j) p_v) i j))
			((equal? p_s "#expt")
			 (array-set! res2 (expt (array-ref res1 i j) p_v) i j))
			((equal? p_s "#max")
			 (array-set! res2 (max (array-ref res1 i j) p_v) i j))
			((equal? p_s "#min")
			 (array-set! res2 (min (array-ref res1 i j) p_v) i j))
			((equal? p_s "#rw")
			 (array-set! res2 p_v i j))
			((equal? p_s "#L")
			 (cond ((< i j)
				(array-set! res2 0 i j))))	       
			((equal? p_s "#U")
			 (cond ((> i j)
				(array-set! res2 0 i j))))			  
			((equal? p_s "#rprnd")
			 (array-set! res2 (+ 0.0 (* p_v (random:normal))) i j)))
		  (set! j (+ j 1)))
	   (set! i (+ i 1)))
    res2))


; grsp-matrix-opew - Performs element-wise operation p_s between matrices p_a1 and
; p_a2.
;
; Arguments:
; - p_s: operation described as a string:
;   - "#+": sum.
;   - "#-": substraction.
;   - "#*": multiplication.
;   - "#/": division.
;   - "#expt": element wise (expt p_a1 p_a2).
;   - "#max": element wise max function.
;   - "#min": element wise min function.
; - p_a1: first matrix.
; - p_a2: second matrix.
;
; Notes:
; - This function does not validate the dimensionality or boundaries of the 
;   matrices involved; the user or an additional shell function should take care
;   of that.
;
(define (grsp-matrix-opew p_s p_a1 p_a2)
  (let ((res1 p_a1)
	(res2 p_a2)
	(res3 0)
	(i 0)
	(j 0)
	(lm 0)
	(hm 0)
	(ln 0)
	(hn 0))
    
    ; Extract the boundaries of the matrix.
    (set! lm (grsp-matrix-esi 1 res1))
    (set! hm (grsp-matrix-esi 2 res1))
    (set! ln (grsp-matrix-esi 3 res1))
    (set! hn (grsp-matrix-esi 4 res1))
    
    ; Create holding matrix.
    (set! res3 (grsp-matrix-create res3 (+ (- hm ln) 1) (+ (- hn ln) 1)))    

    ; Apply bitwise operation.
    (set! i lm)		 
    (while (<= i hm)
	   (set! j ln)			
	   (while (<= j hn)			       
		  (cond ((equal? p_s "#+")
			 (array-set! res3 (+ (array-ref res1 i j) (array-ref res2 i j)) i j))
			((equal? p_s "#-")
			 (array-set! res3 (- (array-ref res1 i j) (array-ref res2 i j)) i j))
			((equal? p_s "#*")
			 (array-set! res3 (* (array-ref res1 i j) (array-ref res2 i j)) i j))
			((equal? p_s "#/")
			 (array-set! res3 (/ (array-ref res1 i j) (array-ref res2 i j)) i j))
			((equal? p_s "#expt")
			 (array-set! res3 (expt (array-ref res1 i j) (array-ref res2 i j)) i j))
			((equal? p_s "#max")
			 (array-set! res3 (max (array-ref res1 i j) (array-ref res2 i j)) i j))
			((equal? p_s "#min")
			 (array-set! res3 (min (array-ref res1 i j) (array-ref res2 i j)) i j)))			
		  (set! j (+ j 1)))
	   (set! i (+ i 1)))
    res3))


; grsp-matrix-opfn - Applies function p_s to all elements of p_a1.
;
; Arguments:
; - p_s: function as per sources, described as a string:
;   - "#abs".
;   - "#truncate".
;   - "#round".
;   - "#floor".
;   - "#ceiling.
;   - "#sqrt".
;   - "#sin".
;   - "#cos".
;   - "#tan".
;   - "#asin".
;   - "#acos".
;   - "#atan".
;   - "#exp".
;   - "#log".
;   - "#log10".
;   - "#sinh".
;   - "#cosh".
;   - "#tanh".
;   - "#asinh".
;   - "#acosh".
;   - "#atanh".
;- p_a1: matrix.
;
; Sources:
; - Gnu.org. (2020). Guile Reference Manual. [online] Available at:
;   https://www.gnu.org/software/guile/manual/guile.html#Arithmetic
;   [Accessed 6 Feb. 2020].
;
(define (grsp-matrix-opfn p_s p_a1)
  (let ((res1 p_a1)
	(res3 0)
	(i 0)
	(j 0)
	(lm 0)
	(hm 0)
	(ln 0)
	(hn 0))
    
    ; Extract the boundaries of the matrix.
    (set! lm (grsp-matrix-esi 1 res1))
    (set! hm (grsp-matrix-esi 2 res1))
    (set! ln (grsp-matrix-esi 3 res1))
    (set! hn (grsp-matrix-esi 4 res1))
    
    ; Create holding matrix.
    (set! res3 (grsp-matrix-create res3 (+ (- hm ln) 1) (+ (- hn ln) 1)))    

    ; Apply bitwise operation.
    (set! i lm)		 
    (while (<= i hm)
	   (set! j ln)			
	   (while (<= j hn)			       
		  (cond ((equal? p_s "#abs")
			 (array-set! res3 (abs (array-ref res1 i j)) i j))
			((equal? p_s "#truncate")
			 (array-set! res3 (truncate (array-ref res1 i j)) i j))
			((equal? p_s "#round")
			 (array-set! res3 (round (array-ref res1 i j)) i j))
			((equal? p_s "#floor")
			 (array-set! res3 (floor (array-ref res1 i j)) i j)) 
			((equal? p_s "#ceiling")
			 (array-set! res3 (ceiling (array-ref res1 i j)) i j)) 
			((equal? p_s "#sqrt")
			 (array-set! res3 (sqrt (array-ref res1 i j)) i j)) 				     
			((equal? p_s "#sin")
			 (array-set! res3 (sin (array-ref res1 i j)) i j)) 			
			((equal? p_s "#cos")
			 (array-set! res3 (cos (array-ref res1 i j)) i j))
			((equal? p_s "#tan")
			 (array-set! res3 (tan (array-ref res1 i j)) i j))
			((equal? p_s "#asin")
			 (array-set! res3 (asin (array-ref res1 i j)) i j)) 			
			((equal? p_s "#acos")
			 (array-set! res3 (acos (array-ref res1 i j)) i j))
			((equal? p_s "#atan")
			 (array-set! res3 (atan (array-ref res1 i j)) i j))
			((equal? p_s "#exp")
			 (array-set! res3 (exp (array-ref res1 i j)) i j))
			((equal? p_s "#log")
			 (array-set! res3 (log (array-ref res1 i j)) i j))
			((equal? p_s "#log10")
			 (array-set! res3 (log10 (array-ref res1 i j)) i j))
			((equal? p_s "#sinh")
			 (array-set! res3 (sinh (array-ref res1 i j)) i j)) 			
			((equal? p_s "#cosh")
			 (array-set! res3 (cosh (array-ref res1 i j)) i j))
			((equal? p_s "#tanh")
			 (array-set! res3 (tanh (array-ref res1 i j)) i j))
			((equal? p_s "#asinh")
			 (array-set! res3 (asinh (array-ref res1 i j)) i j)) 			
			((equal? p_s "#acosh")
			 (array-set! res3 (acosh (array-ref res1 i j)) i j))
			((equal? p_s "#atanh")
			 (array-set! res3 (atanh (array-ref res1 i j)) i j)))						
		  (set! j (+ j 1)))
	   (set! i (+ i 1)))
    res3))


; grsp-matrix-opmm - Performs operation p_s between matrices p_a1 and p_a2.
;
; Arguments:
; - p_s: operation described as a string:
;   - "#+": matrix sum.
;   - "#-": matrix substraction.
;   - "#*": matrix multiplication.
;   - "#/": matrix division.
; - p_a1: first matrix.
; - p_a2: second matrix.
;
; Notes:
; - This function does not validate the dimensionality or boundaries of the 
;   matrices involved; the user or an additional shell function should take care
;   of that.
;
(define (grsp-matrix-opmm p_s p_a1 p_a2)
  (let ((res1 p_a1)
	(res2 p_a2)
	(res4 0)
	(res3 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(i2 0)
	(j2 0)
	(lm3 0)
	(hm3 0)
	(ln3 0)
	(hn3 0))

    ; Extract the boundaries of the first matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    ; Extract the boundaries of the second matrix.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))    

    ; Define the size of the results matrix.
    (set! lm3 lm1)
    (set! hm3 hm1)
    (set! ln3 ln2)
    (set! hn3 hn2)
		   
    ; Create holding matrix.
    ; (set! res3 (grsp-matrix-create res3 (+ (- hm3 ln3) 1) (+ (- hn3 ln3) 1)))
    (set! res3 (grsp-matrix-create res3 (+ (- hm3 lm3) 1) (+ (- hn3 ln3) 1)))
    
    ; Apply mm operation.
    (cond ((equal? p_s "#*")
	   (set! i1 lm3)
	   (while (<= i1 hm3)
		  ; https://en.wikipedia.org/wiki/Matrix_multiplication
		  ; https://en.wikipedia.org/wiki/Matrix_multiplication_algorithm
		  (set! j1 ln3)
		  (while (<= j1 hn3)
			 (set! res4 0)
			 (set! i2 0)
			 (while (<= i2 hm3)
				(set! res4 (+ res4 (* (array-ref res1 i1 i2) (array-ref res1 i2 j1))))
				(set! i2 (+ i2 1)))
			 (array-set! res3 res4 i1 j1)
			 (set! j1 (+ j1 1)))
		  (set! i1 (+ i1 1)))))
    res3))
    

; grsp-matrix-sub - Extracts a block or sub matrix from matrix p_a. The process is
; not destructive with regards to p_a. The user is responsable for providing
; correct boundaries since the function does not check those parameters in 
; relation to p_a.
;
; Arguments:
; - p_a: matrix to be partitioned.
; - p_lm: lower m boundary (rows).
; - p_hm: higher m boundary (rows).
; - p_ln: lower n boundary (cols).
; - p_hn: higher n boundary (cols).
;
(define (grsp-matrix-sub p_a p_lm p_hm p_ln p_hn)
  (let ((res1 p_a)
	(res2 2)
	(i 0)
	(j 0))

    ; Create submatrix.
    (set! res2 (grsp-matrix-create res2 (+ (- p_hm p_ln) 1) (+ (- p_hn p_ln) 1)))  

    ; Copy to submatrix.
    (set! i p_lm)
    (while (<= i p_hm)
	   (set! j p_ln)
	   (while (<= j p_hn)
		  (array-set! res2 (array-ref res1 i j) i j)
		  (set! j (+ j 1)))
	   (set! i (+ i 1)))
    res2))


; grsp-matrix-exp - Add columns or rows to a matrix.
;
; Arguments:
; - p_a: matrix to expand.
; - p_am: rows to add.
; - p_an: cols to add.
;
(define (grsp-matrix-exp p_a p_am p_an)
  (let ((res1 p_a)
	(res2 0)
	(lm 0)
	(hm 0)
	(ln 0)
	(hn 0)
	(i 0)
	(j 0))

    ; Extract the boundaries of the matrix.
    (set! lm (grsp-matrix-esi 1 res1))
    (set! hm (grsp-matrix-esi 2 res1))
    (set! ln (grsp-matrix-esi 3 res1))
    (set! hn (grsp-matrix-esi 4 res1))

    ; Create ex[anded matrix.
    (set! res2 (grsp-matrix-create res2 (+ (- (+ hm p_am) ln) 1) (+ (- (+ hn p_an) ln) 1)))

    ; Copy to submatrix.
    (set! i lm)
    (while (<= i hm)
	   (set! j ln)
	   (while (<= j hn)
		  (array-set! res2 (array-ref res1 i j) i j)
		  (set! j (+ j 1)))
	   (set! i (+ i 1)))
    res2))
