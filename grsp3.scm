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
; (use-modules (grsp grsp0)(grsp grsp1)(grsp grsp2)(grsp grsp3)(grsp grsp4)
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
	    grsp-matrix-subcpy
	    grsp-matrix-subrep
	    grsp-matrix-subdel
	    grsp-matrix-subexp
	    grsp-matrix-is-equal
	    grsp-matrix-is-square
	    grsp-matrix-is-symmetric
	    grsp-matrix-is-diagonal
	    grsp-matrix-row-opar
	    grsp-matrix-row-opmm
	    grsp-matrix-row-opsc
	    grsp-matrix-row-opsw
	    grsp-matrix-decompose))


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
  

; grsp-matrix-create - Creates a p_m x p_n matrix and fills it with element value 
; p_s.
;
; Arguments:
; - p_s: matrix type or element that will fill it initially.
;   - "#I": Identity matrix.
;   - "#Q": Quincunx matrix.
;   - "#Test1": Test matrix 1 (LU decomposable)[1].
;   - "#Test2": Test matrix 2 (LU decomposable)[2].
;
;- p_m: rows, positive integer.
; - p_n: cols, positive integer.
;
; Sources:
; - [1][2] Mathispower4u. (2020). LU Decomposition. [online] Available at:
;   https://www.youtube.com/watch?v=UlWcofkUDDU [Accessed 5 Mar. 2020].
;
(define (grsp-matrix-create p_s p_m p_n)
  (let ((res 0)
	(t "n")
	(s 0)
	(i 0)
	(j 0)
	(m p_m)
	(n p_n))
    (cond ((eq? (grsp-eiget m 0) #t)
	   (cond ((eq? (grsp-eiget n 0) #t)

		  ; For an identity matrix, First set all elements to 0.
		  (cond ((equal? p_s "#I")
			 (set! s 0))
			((equal? p_s "#Q")
			 (set! s 1)
			 (set! m 2)
			 (set! n 2))
			((equal? p_s "#Test1")
			 (set! s 0)
			 (set! m 3)
			 (set! n 3))
			((equal? p_s "#Test2")
			 (set! s 0)
			 (set! m 3)
			 (set! n 3))			
			((equal? p_s "#Ladder")
			 (set! s 1))
			(else (set! s p_s)))

		  ; Build the matrix.
		  (set! res (make-array s m n))

		  ; Once the matrix has been created, depending on the type of 
		  ; matrix, modify its values.
		  (cond ((equal? p_s "#I")
			 (while (< i m)
				(set! j 0)
				(while (< j n)
				       (cond ((eq? i j)
					      (array-set! res 1 i j)))
				       (set! j (+ j 1)))
				(set! i (+ i 1))))
			((equal? p_s "#Test1")
			 (array-set! res 1 0 0)
			 (array-set! res 4 0 1)
			 (array-set! res -3 0 2)
			 (array-set! res -2 1 0)
			 (array-set! res 8 1 1)
			 (array-set! res 5 1 2)
			 (array-set! res 3 2 0)
			 (array-set! res 4 2 1)
			 (array-set! res 7 2 2))
			((equal? p_s "#Test2")
			 (array-set! res 2 0 0)
			 (array-set! res 4 0 1)
			 (array-set! res -4 0 2)
			 (array-set! res 1 1 0)
			 (array-set! res -4 1 1)
			 (array-set! res 3 1 2)
			 (array-set! res -6 2 0)
			 (array-set! res -9 2 1)
			 (array-set! res 5 2 2))			
			((equal? p_s "#Ladder")
			 (while (< i m)
				(set! j 0)
				(while (< j n)			        
				       (array-set! res s i j)
				       (set! s (+ s 1))
				       (set! j (+ j 1)))
				(set! i (+ i 1))))			
			((equal? p_s "#Q")
			 (array-set! res -1 (- m 2) (- n 1))))))))
    res))


; grsp-matrix-change - Changes the value to p_v2 where the value of a matrix's
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
    (set! res2 (grsp-matrix-create res2 (+ (- hm lm) 1) (+ (- hn ln) 1)))
    
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
;   - "#+": matrix to matrix sum.
;   - "#-": matrix to matrix substraction.
;   - "#*": matrix to matrix multiplication.
;   - "#/": matrix to matrix pseudo-division.
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
    (set! res3 (grsp-matrix-create res3 (+ (- hm3 lm3) 1) (+ (- hn3 ln3) 1)))
    
    ; Apply mm operation.
    (cond ((equal? p_s "#*")
	   (set! i1 lm3)
	   (while (<= i1 hm3)
		  (set! j1 ln3)
		  (while (<= j1 hn3)
			 (set! res4 0)
			 (set! i2 0)
			 (while (<= i2 hm3)
				(set! res4 (+ res4 (* (array-ref res1 i1 i2) (array-ref res2 i2 j1))))
				(set! i2 (+ i2 1)))
			 (array-set! res3 res4 i1 j1)
			 (set! j1 (+ j1 1)))
		  (set! i1 (+ i1 1))))
	  ((equal? p_s "#/")
	   (set! i1 lm3)
	   (while (<= i1 hm3)
		  (set! j1 ln3)
		  (while (<= j1 hn3)
			 (set! res4 0)
			 (set! i2 0)
			 (while (<= i2 hm3)
				(set! res4 (+ res4 (/ (array-ref res1 i1 i2) (array-ref res2 i2 j1))))
				(set! i2 (+ i2 1)))
			 (array-set! res3 res4 i1 j1)
			 (set! j1 (+ j1 1)))
		  (set! i1 (+ i1 1))))	  
	  ((equal? p_s "#+")
	   (set! res3 (grsp-matrix-opew p_s res1 res2)))
	  ((equal? p_s "#-")
	   (set! res3 (grsp-matrix-opew p_s res1 res2))))
    res3))
    

; grsp-matrix-subcpy - Extracts a block or sub matrix from matrix p_a. The process is
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
(define (grsp-matrix-subcpy p_a p_lm p_hm p_ln p_hn)
  (let ((res1 p_a)
	(res2 0)
	(i1 0)
	(i2 0)
	(j1 0)
	(j2 0))

    ; Create submatrix.
    (set! res2 (grsp-matrix-create res2 (+ (- p_hm p_lm) 1) (+ (- p_hn p_ln) 1)))  
    
    ; Copy to submatrix.
    (set! i1 p_lm)
    (while (<= i1 p_hm)
	   (set! j1 p_ln)
	   (set! j2 0)
	   (while (<= j1 p_hn)
		  (array-set! res2 (array-ref res1 i1 j1) i2 j2)
		  (set! j2 (+ j2 1))
		  (set! j1 (+ j1 1)))
	   (set! i2 (+ i2 1))
	   (set! i1 (+ i1 1)))
    res2))


; grsp-matrix-subrep - Replaces a submatrix or section of matrix p_a1 with matrix 
; p_a2.
; 
; Arguments:
; - p_a1: matrix.
; - p_a2: matrix.
; - p_m1: row coordinate of p_a1 where to place the upper left corner of p_a2.
; - p_n1: col coordinate of p_a1 where to place the upper left corner of p_a2.
;
(define (grsp-matrix-subrep p_a1 p_a2 p_m1 p_n1)
  (let ((res1 p_a1)
	(res2 p_a2)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(m1 p_m1)
	(n1 p_n1)
	(i1 0)
	(j1 0)
	(i2 0)
	(j2 0)
	(i3 0)
	(j3 0))

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

    ; Define initial position counter values.
    (set! i1 m1)
    (set! j1 n1)

    ; Define the span of the count.
    (set! i2 (+ i1 (- hm2 lm2)))
    (set! j2 (+ j1 (- hn2 ln2)))

    ; Replacement loop.
    (while (<= i1 i2)
	   (set! j3 0)
	   (while (<= j1 j2)
		  (array-set! res1 (array-ref res2 i3 j3) i1 j1)
		  (set! j3 (+ j3 1))
		  (set! j1 (+ j1 1)))
	   (set! i3 (+ i3 1))
	   (set! i1 (+ i1 1)))
    res1))


; grsp-matrix-subdel - Deletes column or row p_n from matrix p_a.
;
; Arguments:
; - p_s: string describing the required operation.
;   - "#Delc": delete column.
;   - "#Delr": delete row. 
; - p_a: matrix.
; - p_n: row or col number to delete.
;
; Notes:
; - Still buggy.
;
(define (grsp-matrix-subdel p_s p_a p_n)
  (let ((res1 p_a)
	(res2 p_a)
	(res3 p_a)
	(res4 p_a)
	(n p_n)
	(c 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm3 0)
	(hm3 0)
	(ln3 0)
	(hn3 0)	
	(lm4 0)
	(hm4 0)
	(ln4 0)
	(hn4 0))	

    ; Extract the boundaries of the first matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))
    
    (cond ((equal? p_s "#Delr")
	   (cond ((equal? n lm1)
		  (set! res2 (grsp-matrix-subcpy res1 (+ lm1 1) hm1 ln1 hn1)))
		 ((equal? n hm1)
		  (set! res2 (grsp-matrix-subcpy res1 lm1 (- hm1 1) ln1 hn1)))
		 (else ((set! c hm1)
			(while (>= c (+ lm1 n))

			       ; Get structural data from the THIRD submatix.
			       (set! lm3 (grsp-matrix-esi 1 res3))
			       (set! hm3 (grsp-matrix-esi 2 res3))
			       (set! ln3 (grsp-matrix-esi 3 res3))
			       (set! hn3 (grsp-matrix-esi 4 res3))

			       ; Delete the current first row of res3
			       (set! res3 (grsp-matrix-subcpy res3 lm3 (- hm3 1) ln3 hn3))
			       (set! c (- c 1)))			

			; Build the bottom submatrix.
			(set! c lm1)
			(while (<= c (+ lm1 n))

			       ; Get structural data from the fourth submatix.
			       (set! lm4 (grsp-matrix-esi 1 res4))
			       (set! hm4 (grsp-matrix-esi 2 res4))
			       (set! ln4 (grsp-matrix-esi 3 res4))
			       (set! hn4 (grsp-matrix-esi 4 res4))

			       ; Delete the current first row of res4
			       (set! res4 (grsp-matrix-subcpy res4 (+ lm4 1) hm4 ln4 hn4))
			       (set! c (+ c 1)))

			; Expand the first submatrix in order to paste to it the second one.
			;(set! res3 (grsp-matrix-subexp res3 (+ (- hm4 lm4) 1) 0))
			(set! res3 (grsp-matrix-subexp res3 (- hm4 lm4) 0))			
			; Move the data of the second submatrix to the expanded part 
			; of the first one.
			(set! res2 (grsp-matrix-subrep res3 res4 (+ (+ lm1 n) 0) ln1))))))) ; This call is causing problems.
    res2))


; grsp-matrix-subexp - Add p_am columns and p_an rows to a matrix p_a, increasing its size.
;
; Arguments:
; - p_a: matrix to expand.
; - p_am: rows to add.
; - p_an: cols to add.
;
(define (grsp-matrix-subexp p_a p_am p_an)
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


; grsp-matrix-is-equal - Returns #t if matrix p_a1 is equal to matrix p_a2.
; 
; Arguments:
; - p_a1: matrix.
; - p_a2: matrix.
;
(define (grsp-matrix-is-equal p_a1 p_a2)
  (let ((res1 p_a1)
	(res2 p_a2)
	(res4 #f)
	(res3 #f)
	(res5 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i 0)
	(j 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0))

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

    ; Compare the size of both matrices.
    (cond ((= lm1 lm2)
	   (cond ((= hm1 hm2)
		  (cond ((= ln1 ln2)
			 (cond ((= hn1 hn2)
				(set! res3 #t)
				(set! res4 #t)))))))))
    
    ; If the size is the same, compare each element.
    (cond ((equal? res4 #t)
	   (set! i lm1)
	   (while (<= i hm1)
		  (set! j ln1)
		  (while (<= j hn1)
			 (cond ((equal? (equal? (grsp-gtels (array-ref res1 i j) (array-ref res2 i j)) 0) #f)
				(set! res5 (+ res5 1))))
			 (set! j (+ j 1)))
		  (set! i (+ i 1)))))
    (cond ((> res5 0)
	   (set! res3 #f)))
    res3))


; grsp-matrix-is-square - Returns #t if matrix p_a1 is square (i.e. m x m).
;
; Arguments:
; - p_a1: matrix.
;
(define (grsp-matrix-is-square p_a1)
  (let ((res1 p_a1)
	(res2 #f)
	(lm 0)
	(hm 0)
	(ln 0)
	(hn 0))

    ; Extract the boundaries of the matrix.
    (set! lm (grsp-matrix-esi 1 res1))
    (set! hm (grsp-matrix-esi 2 res1))
    (set! ln (grsp-matrix-esi 3 res1))
    (set! hn (grsp-matrix-esi 4 res1))

    ; Find out if m = n.
    (cond ((equal? (- hm lm) (- hn ln))
	   (set! res2 #t)))
    
    res2))


; grsp-matrix-is-symmetric - Returns #t if p_a1 is a symmetrix matrix. #f otherwise.
; 
; Arguments:
; - p_a1: matrix.
;
; Notes:
; - For non-complex numbers.
;
(define (grsp-matrix-is-symmetric p_a1)
  (let ((res1 #f))
    (cond ((equal? (grsp-matrix-is-square p_a1) #t)
	   (set! res1 (grsp-matrix-is-equal p_a1 (grsp-matrix-transpose p_a1)))))
    res1))


; grsp-matrix-is-diagonal - Returns #t if p_a1 is a square diagonal matrix,
; #f otherise.
;
; Arguments:
; - p_a1: matrix.
;
(define (grsp-matrix-is-diagonal p_a1)
  (let ((res1 #f)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i 0)
	(j 0)
	(k 0))

    ; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))    

    (cond ((equal? (grsp-matrix-is-square p_a1) #t)
	   (set! i lm1)
	   (while (<= i hm1)
		  (set! j ln1)
		  (while (<= j hn1)
			 (cond ((equal? (equal? (array-ref p_a1 i j) 0) #f)
				(cond ((equal? (equal? i j) #f)
				       (set! k (+ k 1))))))
			 (set! j (+ j 1)))
		  (set! i (+ i 1)))
	   (cond ((equal? k 0)
		  (set! res1 #t)))))
    res1))
		  

; grsp-matrix-row-opar - Finds the inverse amultiple res of p_a1[p_m2,p_n2] so that
; p_a1[p_m2,p_n2] + ( p_a1[p_m1,p_n1] * res ) = 0
;
; or
;
; res = -1 * ( p_a1[p_m2,p_n2] / p_a1[p_m1,p_n1])
;
; and
;
; Replaces p_a1[p_m2,p_n2] with 0.
;
; and
;
; Replaces p_a2[p_m2,p_n2] with res.
;
; Arguments:
; - p_a1: matrix 1.
; - p_a2: matrix 2.
; - p_m1: m coord of upper row element.
; - p_n1: n coord of upper row element.
; - p_m2: m coord of lower row element.
; - p_n2: n coord of lower row element.
;
; Output:
; - Note that the function does not return a value but modifies the values of
;   elements in two matrices directly.
;
; Sources:
; - En.wikipedia.org. (2020). Elementary matrix. [online] Available at:
;   https://en.wikipedia.org/wiki/Elementary_matrix#Operations
;   [Accessed 24 Feb. 2020].
;
(define (grsp-matrix-row-opar p_a1 p_a2 p_m1 p_n1 p_m2 p_n2)
  (let ((res 0))
    (set! res (* 1 (/ (array-ref p_a1 p_m2 p_n2) (array-ref p_a1 p_m1 p_n1))))
    (array-set! p_a1 0 p_m2 p_n2)
    (array-set! p_a2 res p_m2 p_n2)
    res))


; grsp-matrix-row-opmm - Replaces the value of element p_a1[p_m1,p_n1] with
; ( p_a1[p_m1,p_n1] * p_a2[p_m2,p_n2] )
;
; Arguments:
; - p_a1: matrix 1.
; - p_a2: matrix 2.
; - p_m1: m coord of p_a1 element.
; - p_n1: n coord of p_a1 element.
; - p_m2: m coord of p_a2 element.
; - p_n2: n coord of p_a2 element.
;
; Output:
; - Note that the function does not return a value but modifies the values of
;   elements in one matrix.
;
; Sources:
; - En.wikipedia.org. (2020). Elementary matrix. [online] Available at:
;   https://en.wikipedia.org/wiki/Elementary_matrix#Operations
;   [Accessed 24 Feb. 2020].
;
(define (grsp-matrix-row-opmm p_a1 p_a2 p_m1 p_n1 p_m2 p_n2)
  (array-set! p_a1 (* (array-ref p_a1 p_m1 p_n1) (array-ref p_a2 p_m2 p_n2)) p_m1 p_n1))


; grsp-matrix-row-opsc - Performs operation p_s1 between all elements belonging to 
; row p_m1 of matrix p_a1 and scalar p_v1.
;
; Arguments:
; - p_s1: operation described as a string:
;   - "#+": sum.
;   - "#-": substraction.
;   - "#*": multiplication.
;   - "#/": division.
;
; Output:
; - Note that the function does not return a value but modifies the values of
;   elements in row p_m1 of matrix p_a1.
;
; Sources:
; - En.wikipedia.org. (2020). Elementary matrix. [online] Available at:
;   https://en.wikipedia.org/wiki/Elementary_matrix#Operations
;   [Accessed 24 Feb. 2020].
;
(define (grsp-matrix-row-opsc p_s1 p_a1 p_m1 p_v1)
  (let ((ln 0)
	(hn 0)
	(j 0))

    ; Extract the boundaries of the row.
    (set! ln (grsp-matrix-esi 3 p_a1))
    (set! hn (grsp-matrix-esi 4 p_a1))

    (set! j ln)
    (while (<= j hn)
	   (cond ((equal? p_s1 "#+")
		  (array-set! p_a1 (+ (array-ref p_a1 p_m1 j) p_v1) p_m1 j))
		 ((equal? p_s1 "#-")
		  (array-set! p_a1 (+ (array-ref p_a1 p_m1 j) p_v1) p_m1 j))		 
		 ((equal? p_s1 "#*")
		  (array-set! p_a1 (* (array-ref p_a1 p_m1 j) p_v1) p_m1 j))
		 ((equal? p_s1 "#/")
		  (array-set! p_a1 (+ (array-ref p_a1 p_m1 j) p_v1) p_m1 j)))
	   (set! j (+ j 1)))))


; grsp-matrix-row-opsw - Swaps rows p_m1 and p_m2 in matrix p_a1.
;
; Arguments:
; - p_a1: matrix.
; - p_m1: row of p_a1.
; - p_m2: row of p_a1.
;
; Output:
; - Note that the function does not return a value but modifies the values of
;   elements in matrix p_a1.
;
; Sources:
; - En.wikipedia.org. (2020). Elementary matrix. [online] Available at:
;   https://en.wikipedia.org/wiki/Elementary_matrix#Operations
;   [Accessed 24 Feb. 2020].
;
(define (grsp-matrix-row-opsw p_a1 p_m1 p_m2)
  (let ((res1 p_a1)
	(res2 0)
	(res3 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))
	
    ; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ; Copy elements of p_a1, rows p_m1 and p_m2 to separeate arrays.
    (set! res2 (grsp-matrix-subcpy p_a1 p_m1 p_m1 ln1 hn1))
    (set! res3 (grsp-matrix-subcpy p_a1 p_m2 p_m2 ln1 hn1))

    ; Swap positions.
    (set! p_a1 (grsp-matrix-subrep p_a1 res2 p_m2 ln1))
    (set! p_a1 (grsp-matrix-subrep p_a1 res3 p_m1 ln1))))


; grsp-matrix-decompose - Applies decomposition p_s to matrix p_a1.
;
; Arguments:
; - p_s: decomposition type.
;   - "#LU": LU by Gaussian elimination.
; - p_a1: matrix to be decomposed.
; - This function does not perform viability checks on p_a1 for the 
;   required operation; the user or an additional shell function should take 
;   care of that.
;
; Sources:
; - Es.wikipedia.org. (2020). Factorización LU. [online] Available at:
;   https://es.wikipedia.org/wiki/Factorizaci%C3%B3n_LU [Accessed 12 Feb. 2020].
;
(define (grsp-matrix-decompose p_s p_a1)
  (let ((res1 p_a1)
	(res2 '())
	(res3 0)
	(res4 0)
	(L 0)
	(U p_a1)
	(lm 0)
	(hm 0)
	(ln 0)
	(hn 0)
	(i 0)
	(j 0)
	(k 0))

    ; Extract the boundaries of the matrix.
    (set! lm (grsp-matrix-esi 1 res1))
    (set! hm (grsp-matrix-esi 2 res1))
    (set! ln (grsp-matrix-esi 3 res1))
    (set! hn (grsp-matrix-esi 4 res1))	

    (cond ((equal? p_s "#LU")
	   (set! L (grsp-matrix-create "#I" (+ (- hm ln) 1) (+ (- hn ln) 1)))
	   (set! i (+ lm 1))
	   	   
	   ; Column cycle.
	   (while (<= i hm)
		  (set! j ln)
		  (set! k ln)
		  ;(display "\nP2\n")
		  (while (< j i)
			 ;(display "\nP2.1\n")
			 (cond ((> k ln)
				(while (<= k j)
				       ;(display "\nP2.1.1\n")				       
				       (array-set! U (* (array-ref U (- k 1) j) res4) k j)
				       (set! k (+ k 1)))
				(set! k ln)))
			 (cond ((equal? k ln)
				;(display "\nP2.1.2\n")
				(set! res4 (grsp-matrix-row-opar U L k j i j))				
				(set! k (+ k 1))))
			 (set! j (+ j 1)))
			 ;(display "\nP3\n")
			 ;(display L)
			 ;(display "\n")
			 ;(display res4)
			 ;(display "\n")
			 ;(display U)
			 ;(display "\n")
			 ;(display "\nP4\n"))
		  ;(display "\nP5\n")
		  (set! i (+ i 1)))
	   (set! res2 (list L U))))
    res2))

