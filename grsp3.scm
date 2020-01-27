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

; http://www.hep.by/gnu/guile/Array-Procedures.html#Array-Procedures
; https://en.wikipedia.org/wiki/Numerical_linear_algebra

(define-module (grsp grsp3)
  #:use-module (grsp grsp2)
  #:export (grsp-matrix-esi
	    grsp-matrix-create
	    grsp-matrix-change
	    grsp-matrix-transpose
	    grsp-matrix-opsc
	    grsp-matrix-sub))


; grsp-matrix-esi - Extracts shape information from an m x n matrix.
;
; Arguments:
; - p_e: number indicating the element value desired.
; - 1: low boundary for m.
; - 2: high boundary for m.
; - 3: low boundary for n.
; - 4: high boundary for n.
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
; - p_x: size on x axis (cols), positive integer.
; - p_y: size on y axis (rows), positive integer
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
; - p_v1: value to be replaced.
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


; grsp-matrix-opsc - Performs scalar operation p_s between matrix p_a and
; scalar p_v or discrete operation on p_a.
;c
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
;   - "#L": obtains the L matrix of p_a.
;   - "#U": obtains the U matrix of p_a.
; - p_a: matrix.
; - p_v: scalar value.
;
; Notes:
; - You may need to use seed->random-state for pseudo random numbers.
;
; Sources:
; - Gnu.org. (2020). Random (Guile Reference Manual). [online] Available at:
;   https://www.gnu.org/software/guile/manual/html_node/Random.html
;   [Accessed 26 Jan. 2020].
; - https://es.wikipedia.org/wiki/Factorizaci%C3%B3n_LU
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


; grsp-matrix-sub - Extracts a block or sub matrix from matrix p_a. The process is
; not destructive with regards to p_a. The user is responsable for providing
; correct boundaries since the function does not check those parameters in 
; relation to p_a.
;
; Arguments:
; - p_a: matrix to be partitioned.
; - p_lm: lower m boundary.
; - p_hm: higher m boundary.
; - p_ln: lower n boundary.
; - p_hn: higher n boundary
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

