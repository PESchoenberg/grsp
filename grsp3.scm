;; =============================================================================
;;
;; grsp3.scm
;;
;; Matrices.
;;
;; =============================================================================
;;
;; Copyright (C) 2020 - 2022 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;; - Read sources for limitations on function parameters.
;; - grsp3 provides some level of matrix algebra functionality for Guile, but in
;;   its current version it is not intended to be particulary fast. It does not 
;;   make use of any additional non-Scheme library like BLAS or Lapack.
;; - As a convention here, m represents rows, n represents columns.
;;
;; Sources:
;; - [1] Hep.by. (2020). Array Procedures - Guile Reference Manual. [online]
;;   Available at:
;;   http://www.hep.by/gnu/guile/Array-Procedures.html#Array-Procedures
;;   [Accessed 28 Jan. 2020].
;; - [2] En.wikipedia.org. (2020). Numerical linear algebra. [online] Available 
;;   at: https://en.wikipedia.org/wiki/Numerical_linear_algebra
;;   [Accessed 28 Jan. 2020].
;; - [3] En.wikipedia.org. (2020). Matrix theory. [online] Available at:
;;   https://en.wikipedia.org/wiki/Category:Matrix_theory
;;   [Accessed 28 Jan. 2020].
;; - [4] En.wikipedia.org. (2020). List of matrices. [online] Available at:
;;   https://en.wikipedia.org/wiki/List_of_matrices [Accessed 8 Mar. 2020].
;; - [5] Gnu.org. (2020). Random (Guile Reference Manual). [online] Available
;;   at: https://www.gnu.org/software/guile/manual/html_node/Random.html
;;   [Accessed 26 Jan. 2020].
;; - [6] Es.wikipedia.org. (2020). Factorización LU. [online] Available at:
;;   https://es.wikipedia.org/wiki/Factorizaci%C3%B3n_LU
;;   [Accessed 28 Jan. 2020].
;; - [7] Gnu.org. (2020). Guile Reference Manual. [online] Available at:
;;   https://www.gnu.org/software/guile/manual/guile.html#Arithmetic
;;   [Accessed 6 Feb. 2020].
;; - [8] En.wikipedia.org. (2020). Elementary matrix. [online] Available at:
;;   https://en.wikipedia.org/wiki/Elementary_matrix#Operations
;;   [Accessed 24 Feb. 2020].
;; - [9] En.wikipedia.org. 2020. Determinant. [online] Available at:
;;   https://en.wikipedia.org/wiki/Determinant> [Accessed 2 August 2020].
;; - [10] En.wikipedia.org. 2020. Leibniz Formula For Determinants. [online]
;;   Available at: https://en.wikipedia.org/wiki/Leibniz_formula_for_determinants
;;   [Accessed 4 August 2020].
;; - [11] En.wikipedia.org. 2020. Invertible Matrix. [online] Available at:
;;   https://en.wikipedia.org/wiki/Invertible_matrix [Accessed 5 August 2020].
;; - [12] En.wikipedia.org. 2020. Permanent (Mathematics). [online] Available
;;   at: https://en.wikipedia.org/wiki/Permanent_(mathematics)
;;   [Accessed 7 August 2020].
;; - [13] En.wikipedia.org. 2020. Immanant. [online] Available at:
;;   https://en.wikipedia.org/wiki/Immanant [Accessed 14 August 2020].
;; - [14] En.wikipedia.org. 2020. Eigendecomposition Of A Matrix. [online]
;;   Available at: https://en.wikipedia.org/wiki/Eigendecomposition_of_a_matrix
;; - [15] En.wikipedia.org. 2020. Eigenvalue Algorithm. [online] Available at:
;;   https://en.wikipedia.org/wiki/Eigenvalue_algorithm
;;   [Accessed 12 August 2020].
;; - [16] En.wikipedia.org. 2021. Relational algebra. [online] Available at:
;;   https://en.wikipedia.org/wiki/Relational_algebra [Accessed 16 March 2021].
;; - [17] En.wikipedia.org. 2021. Support (mathematics). [online] Available at:
;;   https://en.wikipedia.org/wiki/Support_(mathematics)> [Accessed 27 March
;;   2021].
;; - [18] Mathispower4u. (2020). LU Decomposition. [online] Available at:
;;   https://www.youtube.com/watch?v=UlWcofkUDDU [Accessed 5 Mar. 2020].
;; - [19] En.wikipedia.org. 2021. Genetic algorithm - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Genetic_algorithm
;;   [Accessed 13 May 2021].
;; - [20] En.wikipedia.org. 2021. Crossover (genetic algorithm) - Wikipedia.
;;   [online] Available at: https://en.wikipedia.org/wiki/Crossover_(genetic_algorithm)
;;   [Accessed 13 May 2021].
;; - [21] En.wikipedia.org. 2021. Mutation (genetic algorithm) - Wikipedia.
;;   [online] Available at: https://en.wikipedia.org/wiki/Mutation_(genetic_algorithm)
;;   [Accessed 13 May 2021].
;; - [22] En.wikipedia.org. 2021. Selection (genetic algorithm) - Wikipedia.
;;   [online] Available at: https://en.wikipedia.org/wiki/Selection_(genetic_algorithm)
;;   [Accessed 13 May 2021].
;; - [23] fitness, A., 2015. Accumulated normalized fitness. [online] Stack
;;   Overflow. Available at:
;;   https://stackoverflow.com/questions/27524241/accumulated-normalized-fitness
;;   [Accessed 13 May 2021].
;; - [24] En.wikipedia.org. 2021. Multiset - Wikipedia. [online] Available at:
;;   https://en.wikipedia.org/wiki/Multiset [Accessed 17 September 2021].
;; - [25] Gnuplotting.org. 2021. Plotting data « Gnuplotting. [online]
;;   Available at: http://www.gnuplotting.org/plotting-data/
;;   [Accessed 21 November 2021].


(define-module (grsp grsp3)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp4)  
  #:export (grsp-matrix-esi
	    grsp-matrix-create
	    grsp-matrix-change
	    grsp-matrix-find
	    grsp-matrix-transpose
	    grsp-matrix-transposer
	    grsp-matrix-conjugate
	    grsp-matrix-conjugate-transpose
	    grsp-matrix-opio
	    grsp-matrix-opsc
	    grsp-matrix-opew
	    grsp-matrix-opfn
	    grsp-matrix-opmm
	    grsp-matrix-cpy
	    grsp-matrix-subcpy
	    grsp-matrix-subrep
	    grsp-matrix-subdcn
	    grsp-matrix-subdel
	    grsp-matrix-subexp
	    grsp-matrix-is-equal
	    grsp-matrix-is-square
	    grsp-matrix-is-symmetric
	    grsp-matrix-is-diagonal
	    grsp-matrix-is-hermitian
	    grsp-matrix-is-binary
	    grsp-matrix-is-nonnegative
	    grsp-matrix-is-positive
	    grsp-matrix-row-opar
	    grsp-matrix-row-opmm
	    grsp-matrix-row-opsc
	    grsp-matrix-row-opsw
	    grsp-matrix-decompose
	    grsp-matrix-density
	    grsp-matrix-is-sparse
	    grsp-matrix-is-symmetric-md
	    grsp-matrix-total-elements
	    grsp-matrix-total-element
	    grsp-matrix-is-hadamard
	    grsp-matrix-is-markov
	    grsp-matrix-is-signature
	    grsp-matrix-is-single-entry
	    grsp-matrix-identify
	    grsp-matrix-is-metzler
	    grsp-l2m
	    grsp-m2l
	    grsp-m2v
	    grsp-dbc2mc
	    grsp-dbc2mc-csv
	    grsp-mc2dbc
	    grsp-mc2dbc-sqlite3
	    grsp-mc2dbc-hdf5
	    grsp-mc2dbc-csv
	    grsp-mc2dbc-gnuplot1
	    grsp-mc2dbc-gnuplot2	    
	    grsp-matrix-interval-mean
	    grsp-matrix-determinant-lu
	    grsp-matrix-is-invertible
	    grsp-eigenval-opio
	    grsp-matrix-sort
	    grsp-matrix-minmax
	    grsp-matrix-trim
	    grsp-matrix-select
	    grsp-matrix-row-minmax
	    grsp-matrix-row-select
	    grsp-matrix-row-delete
	    grsp-matrix-row-sort
	    grsp-matrix-row-invert
	    grsp-matrix-commit
	    grsp-matrix-row-selectn
	    grsp-matrix-col-selectn
	    grsp-matrix-col-select
	    grsp-matrix-njoin
	    grsp-matrix-sjoin
	    grsp-matrix-ajoin
	    grsp-matrix-supp
	    grsp-matrix-row-div
	    grsp-matrix-row-update
	    grsp-matrix-te1
	    grsp-matrix-te2
	    grsp-matrix-row-append
	    grsp-matrix-lojoin
	    grsp-matrix-subrepv
	    grsp-matrix-subswp
	    grsp-matrix-col-total-element
	    grsp-matrix-row-deletev
	    grsp-matrix-clear
	    grsp-matrix-clearni
	    grsp-matrix-row-cartesian
	    grsp-matrix-col-append
	    grsp-matrix-col-find-nth
	    grsp-mn2ll
	    grsp-matrix-mutation
	    grsp-matrix-col-mutation
	    grsp-matrix-col-lmutation
	    grsp-matrix-crossover
	    grsp-matrix-crossover-rprnd
	    grsp-matrix-same-dims
	    grsp-matrix-fitness-rprnd
	    grsp-matrix-selectg
	    grsp-matrix-keyon
	    grsp-matrix-col-aupdate
	    grsp-matrix-row-selectc
	    grsp-matrix-is-empty
	    grsp-matrix-is-multiset
	    grsp-matrix-argtype
	    grsp-matrix-argstru
	    grsp-matrix-row-subrepal
	    grsp-matrix-subdell
	    grsp-matrix-is-samedim
	    grsp-matrix-fill
	    grsp-matrix-fdif
	    grsp-matrix-ftc))


;;;; grsp-matrix-esi - Extracts shape information from an m x n matrix.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_e1: number indicating the element value desired.
;;   - 1: low boundary for m (rows).
;;   - 2: high boundary for m (rows).
;;   - 3: low boundary for n (cols).
;;   - 4: high boundary for n (cols).
;; - p_m1: m.
;;
;; Sources:
;; - [1][2][3][4].
;;
;; Output:
;; - A number corresponding to the shape element value desired. Returns zero  
;;   if p_e1 is incorrect.
;;
(define (grsp-matrix-esi p_e1 p_m1)
  (let ((res1 0)
	(s1 0))

    (set! s1 (array-shape p_m1))
    (cond ((equal? p_e1 1)
	   (set! res1 (car (car s1))))
	  ((equal? p_e1 2)
	   (set! res1 (car (cdr (car s1)))))
	  ((equal? p_e1 3)
	   (set! res1 (car (car (cdr s1)))))
	  ((equal? p_e1 4)
	   (set! res1 (car (cdr (car (cdr s1)))))))

    res1))
  

;;;; grsp-matrix-create - Creates an p_m1 x p_n1 matrix and fills it with
;; element value p_s1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s1: matrix type or element that will fill it initially.
;;   - "#I": Identity matrix.
;;   - "#AI": Anti Identity matrix (anti diagonal).
;;   - "#Q": Quincunx matrix.
;;   - "#Test1": Test matrix 1 (LU decomposable)[1].
;;   - "#Test2": Test matrix 2 (LU decomposable)[2].
;;   - "#Ladder": Ladder matrix.
;;   - "#Arrow": Arrowhead matrix.
;;   - "#Hilbert": Hilbert matrix.
;;   - "#Lehmer": Lehmer matrix.
;;   - "#Pascal": Pascal matrix.
;;   - "#CH": 0-1 checkerboard pattern matrix.
;;   - "#CHR": 0-1 checkerboard pattern matrix, randomized.
;;   - "#+IJ": matrix containing the sum of i and j values.
;;   - "#-IJ": matrix containing the substraction of i and j values.
;;   - "#+IJ": matrix containing the product of i and j values.
;;   - "#-IJ": matrix containing the quotient of i and j values.
;;   - "#US": upper shift matrix.
;;   - "#LS": lower shift matrix.
;;   - "#rprnd": pseduo random values, normal distribution, sd = 0.15.
;;   - "#zrow": zebra row.
;;   - "#zcol": zebra col.
;;   - "#n0[-m:+m]": matrix of (2m +1 ) rows and n cols, with first column
;;     element -m and last row, first col element reaching m.
;; - p_m1: rows, positive integer.
;; - p_n1: cols, positive integer.
;;
;; Sources:
;; - [1][2][18].
;;
(define (grsp-matrix-create p_s1 p_m1 p_n1)
  (let ((res1 0)
	(t1 "n")
	(s1 0)
	(i1 0)
	(j1 0)
	(m1 p_m1)
	(m3 p_m1)
	(n1 p_n1)
	(p0 0)
	(p1 0)
	(p2 0)
	(p3 0))

    (cond ((eq? (grsp-eiget m1 0) #t)
	   (cond ((eq? (grsp-eiget n1 0) #t)

		  ;; For an identity matrix, first set all elements to 0.
		  (cond ((equal? p_s1 "#I")
			 (set! s1 0))
			((equal? p_s1 "#AI")
			 (set! s1 0))			
			((equal? p_s1 "#Q")
			 (set! s1 1)
			 (set! m1 2)
			 (set! n1 2))
			((equal? p_s1 "#Test1")
			 (set! s1 0)
			 (set! m1 3)
			 (set! n1 3))
			((equal? p_s1 "#Test2")
			 (set! s1 0)
			 (set! m1 3)
			 (set! n1 3))			
			((equal? p_s1 "#Ladder")
			 (set! s1 1))
			((equal? p_s1 "#Arrow")
			 (set! s1 0)
			 (set! n1 m1))
			((equal? p_s1 "#Hilbert")
			 (set! s1 0)
			 (set! n1 m1))
			((equal? p_s1 "#Lehmer")
			 (set! s1 0)
			 (set! n1 m1))
			((equal? p_s1 "#Pascal")
			 (set! s1 0)
			 (set! n1 m1))
			((equal? p_s1 "#Fibonacci")
			 (set! s1 0)
			 (set! n1 m1))			
			((equal? p_s1 "#CH")
			 (set! s1 0))
			((equal? p_s1 "#CHR")
			 (set! s1 0))
			((equal? p_s1 "#+IJ")
			 (set! s1 0)
			 (set! n1 m1))
			((equal? p_s1 "#-IJ")
			 (set! s1 0)
			 (set! n1 m1))
			((equal? p_s1 "#*IJ")
			 (set! s1 1)
			 (set! n1 m1))
			((equal? p_s1 "#/IJ")
			 (set! s1 1)
			 (set! n1 m1))
			((equal? p_s1 "#US")
			 (set! s1 0)
			 (set! n1 m1))
			((equal? p_s1 "#LS")
			 (set! s1 0)
			 (set! n1 m1))			
			((equal? p_s1 "#rprnd")
			 (set! s1 0))
			((equal? p_s1 "#zrow")
			 (set! s1 0))
			((equal? p_s1 "#zcol")
			 (set! s1 0))
			((equal? p_s1 "#n0[-m:+m]")
			 (set! s1 0)
			 (set! m1 (+ 1 (* m1 2))))
			
			(else (set! s1 p_s1)))

		  ;; Build the matrix.
		  (set! res1 (make-array s1 m1 n1))

		  ;; Once the matrix has been created, depending on the type of 
		  ;; matrix, modify its values.
		  (cond ((equal? p_s1 "#I")
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)
				       (cond ((eq? i1 j1)
					      (array-set! res1 1 i1 j1)))
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#Test1")
			 (array-set! res1 1 0 0)
			 (array-set! res1 4 0 1)
			 (array-set! res1 -3 0 2)
			 (array-set! res1 -2 1 0)
			 (array-set! res1 8 1 1)
			 (array-set! res1 5 1 2)
			 (array-set! res1 3 2 0)
			 (array-set! res1 4 2 1)
			 (array-set! res1 7 2 2))
			((equal? p_s1 "#Test2")
			 (array-set! res1 2 0 0)
			 (array-set! res1 4 0 1)
			 (array-set! res1 -4 0 2)
			 (array-set! res1 1 1 0)
			 (array-set! res1 -4 1 1)
			 (array-set! res1 3 1 2)
			 (array-set! res1 -6 2 0)
			 (array-set! res1 -9 2 1)
			 (array-set! res1 5 2 2))			
			((equal? p_s1 "#Ladder")
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)			        
				       (array-set! res1 s1 i1 j1)
				       (set! s1 (+ s1 1))
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#Arrow")
			 (set! res1 (grsp-matrix-create "#I" m1 n1))
			 (grsp-matrix-row-opsc "#+" res1 0 1)
			 (set! res1 (grsp-matrix-transpose res1))
			 (grsp-matrix-row-opsc "#+" res1 0 1)
			 (set! res1 (grsp-matrix-transpose res1))
			 (set! res1 (grsp-matrix-transpose res1))
			 (array-set! res1 1 0 0))
			((equal? p_s1 "#AI")
			 (set! i1 (- m1 1))
			 (while (>= i1 0)
				(set! j1 (- n1 1))
				(while (>= j1 0)
				       (cond ((equal? (+ i1 j1) (- m1 1))
					      (array-set! res1 1 i1 j1)))
				       (set! j1 (- j1 1)))
				(set! i1 (- i1 1))))
			((equal? p_s1 "#Hilbert")
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)			        
				       (array-set! res1 (/ 1 (- (+ (+ i1 1) (+ j1 1)) 1)) i1 j1)
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#Lehmer")
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)			        
				       (array-set! res1 (/ (min (+ i1 1) (+ j1 1)) (max (+ i1 1) (+ j1 1))) i1 j1)
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#Pascal")
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)			        
				       (array-set! res1 (grsp-biconr (+ i1 j1) i1) i1 j1)
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#Pfsum")
			 ;; https://en.wikipedia.org/wiki/Prefix_sum
			 )
			((equal? p_s1 "#Fibonacci")
			 (set! p0 0)
			 (set! p1 1)
			 (set! p2 0)
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)

				       ;; Non-recursive calculation of Fibonacci
				       ;; terms in order to fill the matrix
				       ;; easily.
				       (cond ((equal? s1 0)
					      (set! p0 0)
					      (set! s1 1))
					     ((equal? s1 1)
					      (set! p0 1)
					      (set! s1 2))
					     ((equal? s1 2)
					      (set! p0 1)
					      (set! s1 3))
					     ((equal? s1 3)				       
					      (set! p0 (+ p1 p2))))

				       ;; Insert the Fibonacci term.
				       (array-set! res1 p0 i1 j1)

				       ;; Update indexes and values.
				       (set! p2 p1)
				       (set! p1 p0)
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))			
			((equal? p_s1 "#CH")
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)			        
				       (array-set! res1 s1 i1 j1)
				       (cond ((equal? s1 0)
					      (set! s1 1))
					     ((equal? s1 1)
					      (set! s1 0)))
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#CHR")
			 (set! res1 (grsp-matrix-create "#rprnd" m1 n1))			 
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)			        
				       (cond ((>= (array-ref res1 i1 j1) 0) ;; Mean 0.0 sd 0.15
					      (array-set! res1 1 i1 j1))
					     (else (array-set! res1 0 i1 j1)))
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#+IJ")
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)			        
				       (array-set! res1 (+ i1 j1) i1 j1)
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#-IJ")
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)			        
				       (array-set! res1 (- i1 j1) i1 j1)
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#*IJ")
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)			        
				       (array-set! res1 (* i1 j1) i1 j1)
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#/IJ")
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)
				       (cond ((equal? j1 0)
					      (array-set! res1 0 i1 j1)))
				       (cond ((> j1 0)
					      (array-set! res1 (/ i1 j1) i1 j1)))
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#US")
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 (- n1 1))
				       (cond ((eq? i1 j1)
					      (array-set! res1 1 i1 (+ j1 1))))
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#LS")
			 (set! res1 (grsp-matrix-create "#US" m1 n1))
			 (set! res1 (grsp-matrix-transpose res1)))
			((equal? p_s1 "#rprnd")
			 (set! res1 (grsp-matrix-create 1 m1 n1))
			 (set! res1 (grsp-matrix-opsc "#rprnd" res1 0.15)))
			((equal? p_s1 "#zrow")
			 (set! res1 (grsp-matrix-create 0 m1 n1))
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)
				       (array-set! res1 i1 i1 j1)
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))			 
			((equal? p_s1 "#zcol")
			 (set! res1 (grsp-matrix-create 0 m1 n1))
			 (while (< i1 m1)
				(set! j1 0)
				(while (< j1 n1)
				       (array-set! res1 j1 i1 j1)
				       (set! j1 (+ j1 1)))
				(set! i1 (+ i1 1))))
			((equal? p_s1 "#n0[-m:+m]")
			 (set! m3 (* -1 m3))
			 (while (< i1 m1)

				(array-set! res1 m3 i1 0)
				(set! m3 (in m3))
				
				(set! i1 (in i1))))
			
			((equal? p_s1 "#Q")
			 (array-set! res1 -1 (- m1 2) (- n1 1))))))))

    res1))


;;;; grsp-matrix-change - Changes the value to p_v2 where the value of a
;; matrix's element equals p_v1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix to operate on.
;; - p_v1: value to be replaced within p_a1.
;; - p_v2: value to replace p_v1 with.
;;
;; Sources:
;; - [1][2][3][4].
;;
;; Output:
;; - A modified matrix p_a in which all p_v1 values would have been replaced by
;;   p_v2.
;;
(define (grsp-matrix-change p_a1 p_v1 p_v2)
  (let ((res1 p_a1)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0))

    ;; Extract the boundaries of the matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    ;; Cycle thorough the matrix and change to p_v1 those elements whose value  
    ;; is p_v1.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  (cond ((equal? (array-ref res1 i1 j1) p_v1)
			 (array-set! res1 p_v2 i1 j1)))
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))

    res1))


;;;; grsp-matrix-find - Find all occurrences of p_v1 in matrix p_a1 that
;; statisfy condition p_s1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s1: search criteria.
;;   - "#=": searches for all elements equal to p_v1.
;;   - "#>": searches for all elements greather than p_v1.
;;   - "#<": searches for all elements smaller than p_v1.
;;   - "#>=": searches for all elements greather or equal than p_v1.
;;   - "#<=": searches for all elements smaller or equal than p_v1.
;;   - "#!=": searches for all elements not equal to p_v1.
;; - p_a1: matrix.
;; - P_v1: reference value for searching.
;;
;; Sources:
;; - [1][2][3][4].
;;
;; Output:
;; - A matrix of m x 2 elements, being m the number of ocurrences that statisfy
;;   the search criteria. On row 0 goes the row coordinate of each element
;;   found, and on row 1 goes the corresponding col coordinate. Thus, this
;;   matrix shows both he number of found elements as well as their positions
;;   within p_a1.
;;
(define (grsp-matrix-find p_s1 p_a1 p_v1)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(hm2 0)
	(i1 0)
	(j1 0)
	(k1 0)
	(c1 #f))

    ;; Extract the boundaries of the matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))	
	      
    ;; Find the elements.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  (cond ((equal? p_s1 "#=")
			 (cond ((equal? p_v1 (array-ref p_a1 i1 j1))
				(set! k1 (+ k1 1))
				(set! c1 #t))))
			((equal? p_s1 "#>")
			 (cond ((> (array-ref p_a1 i1 j1) p_v1)
				(set! k1 (+ k1 1))
				(set! c1 #t))))		
			((equal? p_s1 "#<")
			 (cond ((< (array-ref p_a1 i1 j1) p_v1)
				(set! k1 (+ k1 1))
				(set! c1 #t))))
			((equal? p_s1 "#>=")
			 (cond ((>= (array-ref p_a1 i1 j1) p_v1)
				(set! k1 (+ k1 1))
				(set! c1 #t))))				
			((equal? p_s1 "#<=")
			 (cond ((<= (array-ref p_a1 i1 j1) p_v1)
				(set! k1 (+ k1 1))
				(set! c1 #t))))
			((equal? p_s1 "#!=")
			 (cond ((< (array-ref p_a1 i1 j1) p_v1)
				(set! k1 (+ k1 1))
				(set! c1 #t))
			       ((> (array-ref p_a1 i1 j1) p_v1)
				(set! k1 (+ k1 1))
				(set! c1 #t)))))
		  
		  (cond ((equal? c1 #t)
			 
			 ;; Create row1 or increase the number of its rows.
			 (cond ((equal? k1 1)
				(set! res1 (grsp-matrix-create 0 1 2)))
			       ((> k1 1)
				(set! res1 (grsp-matrix-subexp res1 1 0))))

			 ;; Fill a new row of res1 with data.
			 (set! hm2 (grsp-matrix-esi 2 res1))
			 (array-set! res1 i1 hm2 0)
			 (array-set! res1 j1 hm2 1)

			 (set! c1 #f)))
		  
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))

    res1))
    

;;;; grsp-matrix-transpose - Transposes a matrix of shape m x n into another
;; with shape n x m.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix to be transposed.
;;
;; Sources:
;; - [1][2][3][4].
;;
(define (grsp-matrix-transpose p_a1)
  (let ((res1 p_a1)
	(res2 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0))

    ;; Extract the boundaries of the matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))	

    ;; Create new matrix with transposed shape.
    (set! res2 (grsp-matrix-create res2 (+ (- hn1 ln1) 1) (+ (- hm1 lm1) 1)))
    
    ;; Transpose the elements.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  (array-set! res2 (array-ref res1 i1 j1) j1 i1)
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))

    res2))


;;;; grsp-matrix-transposer - Transposes p_a1 p_n1 times.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_n1: number, [0, 4].
;;
(define (grsp-matrix-transposer p_a1 p_n1)
  (let ((res1 p_a1)
	(i1 0))

    (cond ((< p_n1 0)
	   (set! p_n1 0))
	  ((> p_n1 4)
	   (set! p_n1 4)))
    
    (while (< i1 p_n1)
	   (set! res1 (grsp-matrix-transpose res1))
	   (set! i1 (+ i1 1)))
    
    res1))


;;;; grsp-matrix-conjugate - Calculates the conjugate matrix of p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-conjugate p_a1)
  (let ((res1 p_a1)
	(res2 0))

    (set! res2 (grsp-matrix-opsc "#si" res1 0))

    res2))


;;;; grsp-matrix-transpose-conjugate - Calculates the transpose conjugate matrix
;; of p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-conjugate-transpose p_a1)
  (let ((res1 p_a1)
	(res2 0))

    (set! res2 (grsp-matrix-conjugate (grsp-matrix-transpose res1)))

    res2))


;;;; grsp-matrix-opio - Internal operations that produce a scalar result.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments;
;; - p_s1: string representing the desired operation.
;;   - "#+": sum of all elements.
;;   - "#-": substraction of all elements.
;;   - "#*": product of all elements.
;;   - "#/": division of all elements.
;;   - "#+r": sum of all elements of row p_l1.
;;   - "#-r": substraction of all elements of row p_l1.
;;   - "#*r": product of all elements of row p_l1.
;;   - "#/r": division of all elements of row p_l1.
;;   - "#+c": sum of all elements of col p_l1.
;;   - "#-c": substraction of all elements of col p_l1.
;;   - "#*c": product of all elements of col p_l1.
;;   - "#/c": division of all elements of col p_l1.
;;   - "#+md": sum of the main diagonal elements (trace).
;;   - "#-md": substraction of the main diagonal elements.
;;   - "#*md": product of the main diagonal elements.
;;   - "#/md": division of the main diagonal elements.
;;   - "#+ad": sum of the anti diagonal elements.
;;   - "#-ad": substraction of the anti diagonal elements.
;;   - "#*ad": product of the anti diagonal elements.
;;   - "#/ad": division of the anti diagonal elements.
;; - p_a1: matrix. 
;; - p_l1: column or row number.
;;
;; Sources:
;; - [1][2][3][4].
;;
;; Notes:
;; - Value for argument p_l1 should be passed as 0 if not used. It is only
;;   needed for row and column operations.
;;
(define (grsp-matrix-opio p_s1 p_a1 p_l1)
  (let ((res1 p_a1)
	(res2 0)
	(res3 1)
	(l1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(k1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    (set! l1 p_l1)
    (set! k1 hm1)
    (cond ((equal? p_s1 "#*")
	   (set! res2 1))
	  ((equal? p_s1 "#/")
	   (set! res2 1))	  
	  ((equal? p_s1 "#*r")
	   (set! res2 1))
	  ((equal? p_s1 "#/r")
	   (set! res2 1))
	  ((equal? p_s1 "#*c")
	   (set! res2 1))
	  ((equal? p_s1 "#/c")
	   (set! res2 1))	  
	  ((equal? p_s1 "#*md")
	   (set! res2 1))
	  ((equal? p_s1 "#/md")
	   (set! res2 1))
	  ((equal? p_s1 "#*ad")
	   (set! res2 1))
	  ((equal? p_s1 "#/ad")
	   (set! res2 1)))
	  
    ;; Apply internal operation.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  (cond ((equal? p_s1 "#+")
			 (set! res2 (+ res2 (array-ref res1 i1 j1))))	  
			((equal? p_s1 "#-")
			 (set! res2 (- res2 (array-ref res1 i1 j1))))
			((equal? p_s1 "#*")
			 (set! res2 (* res2 (array-ref res1 i1 j1))))
			((equal? p_s1 "#/")
			 (set! res2 (/ res2 (array-ref res1 i1 j1))))

			;; Main diagonal operations.
			((equal? p_s1 "#+md")
			 (cond ((equal? (grsp-gtels i1 j1) 0)
				(set! res2 (+ res2 (array-ref res1 i1 j1))))))
			((equal? p_s1 "#-md")
			 (cond ((equal? (grsp-gtels i1 j1) 0)
				(set! res2 (- res2 (array-ref res1 i1 j1))))))
			((equal? p_s1 "#*md")
			 (cond ((equal? (grsp-gtels i1 j1) 0)
				(set! res2 (* res2 (array-ref res1 i1 j1))))))
			((equal? p_s1 "#/md")
			 (cond ((equal? (grsp-gtels i1 j1) 0)
				(set! res2 (/ res2 (array-ref res1 i1 j1))))))

			;; Anti diagonal operations.
			((equal? p_s1 "#+ad")
			 (cond ((equal? k1 (+ i1 j1))
				(set! res2 (+ res2 (array-ref res1 i1 j1))))))
			((equal? p_s1 "#-ad")
			 (cond ((equal? k1 (+ i1 j1))
				(set! res2 (- res2 (array-ref res1 i1 j1))))))
			((equal? p_s1 "#*ad")
			 (cond ((equal? k1 (+ i1 j1))
				(set! res2 (* res2 (array-ref res1 i1 j1))))))
			((equal? p_s1 "#/ad")
			 (cond ((equal? k1 (+ i1 j1))
				(set! res2 (/ res2 (array-ref res1 i1 j1)))))))			
			
		  ;; Row operations.
		  (cond ((= l1 i1)
			 (cond ((equal? p_s1 "#+r")
				(set! res2 (+ res2 (array-ref res1 i1 j1))))
			       ((equal? p_s1 "#-r")
				(set! res2 (- res2 (array-ref res1 i1 j1))))
			       ((equal? p_s1 "#*r")
				(set! res2 (* res2 (array-ref res1 i1 j1))))
			       ((equal? p_s1 "#/r")
				(set! res2 (/ res2 (array-ref res1 i1 j1)))))))

		  ;; Column operations.
		  (cond ((= l1 j1)
			 (cond ((equal? p_s1 "#+c")
				(set! res2 (+ res2 (array-ref res1 i1 j1))))
			       ((equal? p_s1 "#-c")
				(set! res2 (- res2 (array-ref res1 i1 j1))))
			       ((equal? p_s1 "#*c")
				(set! res2 (* res2 (array-ref res1 i1 j1))))
			       ((equal? p_s1 "#/c")
				(set! res2 (/ res2 (array-ref res1 i1 j1)))))))			       

		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))

    res2))


;;;; grsp-matrix-opsc - Performs an operation p_s1 between matrix p_a1 and
;; scalar p_v1 or a discrete operation on p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s: scalar operation.
;;   - "#+": scalar sum.
;;   - "#-": scalar substraction.
;;   - "#*": scalar multiplication.
;;   - "#/": scalar division.
;;   - "#expt": applies expt function to each element of p_a1.
;;   - "#max": applies max function to each element of p_a1.
;;   - "#min": applies min function to each element of p_a1.
;;   - "#rw": replace all elements of p_a1 with p_v1 regardless of their value.
;;   - "#rprnd": replace all elements of p_a1 with pseudo random numbers in a
;;      normal distribution with mean 0.0 and standard deviation equal to p_v1.
;;   - "#si": applies (grsp-complex-inv "#si" z1) to each element z1 of p_a1
;;     (complex conjugate).
;;   - "#is": applies (grsp-complex-inv "#is" z1) to each element z1 of p_a1
;;     (sign inversion of real element of complex number).
;;   - "#ii": applies (grsp-complex-inv "#ii" z1) to each element z1 of p_a1
;;     (sign inversion of both elements of a complex number).
;; - p_a1: matrix.
;; - p_v1: scalar value.
;;
;; Notes:
;; - You may need to use seed->random-state for pseudo random numbers.
;; - This function does not validate the dimensionality or boundaries of the 
;;   matrices involved; the user or an additional shell function should take
;;   care of that.
;;
;; Sources:
;; - [5][6].
;;
(define (grsp-matrix-opsc p_s1 p_a1 p_v1)
  (let ((res1 p_a1)
	(res2 2)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    ;; Create holding matrix.
    (set! res2 (grsp-matrix-create res2 (+ (- hm1 lm1) 1) (+ (- hn1 ln1) 1)))
    
    ;; Apply scalar operation.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  (cond ((equal? p_s1 "#+")
			 (array-set! res2 (+ (array-ref res1 i1 j1) p_v1) i1 j1))
			((equal? p_s1 "#-")
			 (array-set! res2 (- (array-ref res1 i1 j1) p_v1) i1 j1))
			((equal? p_s1 "#*")
			 (array-set! res2 (* (array-ref res1 i1 j1) p_v1) i1 j1))
			((equal? p_s1 "#/")
			 (array-set! res2 (/ (array-ref res1 i1 j1) p_v1) i1 j1))
			((equal? p_s1 "#expt")
			 (array-set! res2 (expt (array-ref res1 i1 j1) p_v1) i1 j1))
			((equal? p_s1 "#max")
			 (array-set! res2 (max (array-ref res1 i1 j1) p_v1) i1 j1))
			((equal? p_s1 "#min")
			 (array-set! res2 (min (array-ref res1 i1 j1) p_v1) i1 j1))
			((equal? p_s1 "#rw")
			 (array-set! res2 p_v1 i1 j1))			  
			((equal? p_s1 "#rprnd")
			 (array-set! res2 (grsp-rprnd "#normal" 0.0 p_v1) i1 j1))			
			((equal? p_s1 "#si")
			 (array-set! res2 (grsp-complex-inv p_s1 (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#is")
			 (array-set! res2 (grsp-complex-inv p_s1 (array-ref res1 i1 j1)) i1 j1))			  
			((equal? p_s1 "#ii")
			 (array-set! res2 (grsp-complex-inv p_s1 (array-ref res1 i1 j1)) i1 j1)))
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))

    res2))


;;;; grsp-matrix-opew - Performs element-wise operation p_s1 between matrices
;; p_a1 and p_a2.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s1: operation described as a string:
;;   - "#+": sum.
;;   - "#-": substraction.
;;   - "#*": multiplication.
;;   - "#/": division.
;;   - "#expt": element wise (expt p_a1 p_a2).
;;   - "#max": element wise max function.
;;   - "#min": element wise min function.
;; - p_a1: first matrix.
;; - p_a2: second matrix.
;;
;; Notes:
;; - This function does not validate the dimensionality or boundaries of the 
;;   matrices involved; the user or an additional shell function should take 
;;   care of that.
;;
(define (grsp-matrix-opew p_s1 p_a1 p_a2)
  (let ((res1 p_a1)
	(res2 p_a2)
	(res3 0)
	(i1 0)
	(j1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))
    
    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))
    
    ;; Create holding matrix.
    (set! res3 (grsp-matrix-create res3 (+ (- hm1 ln1) 1) (+ (- hn1 ln1) 1)))

    ;; Apply bitwise operation.
    (set! i1 lm1)		 
    (while (<= i1 hm1)
	   (set! j1 ln1)			
	   (while (<= j1 hn1)			       
		  (cond ((equal? p_s1 "#+")
			 (array-set! res3 (+ (array-ref res1 i1 j1) (array-ref res2 i1 j1)) i1 j1))
			((equal? p_s1 "#-")
			 (array-set! res3 (- (array-ref res1 i1 j1) (array-ref res2 i1 j1)) i1 j1))
			((equal? p_s1 "#*")
			 (array-set! res3 (* (array-ref res1 i1 j1) (array-ref res2 i1 j1)) i1 j1))
			((equal? p_s1 "#/")
			 (array-set! res3 (/ (array-ref res1 i1 j1) (array-ref res2 i1 j1)) i1 j1))
			((equal? p_s1 "#expt")
			 (array-set! res3 (expt (array-ref res1 i1 j1) (array-ref res2 i1 j1)) i1 j1))
			((equal? p_s1 "#max")
			 (array-set! res3 (max (array-ref res1 i1 j1) (array-ref res2 i1 j1)) i1 j1))
			((equal? p_s1 "#min")
			 (array-set! res3 (min (array-ref res1 i1 j1) (array-ref res2 i1 j1)) i1 j1)))			
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))

    res3))


;;;; grsp-matrix-opfn - Applies function p_s to all elements of p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s1: function as per sources, described as a string:
;;   - "#abs".
;;   - "#truncate".
;;   - "#round".
;;   - "#floor".
;;   - "#ceiling.
;;   - "#sqrt".
;;   - "#sin".
;;   - "#cos".
;;   - "#tan".
;;   - "#asin".
;;   - "#acos".
;;   - "#atan".
;;   - "#exp".
;;   - "#log".
;;   - "#log10".
;;   - "#sinh".
;;   - "#cosh".
;;   - "#tanh".
;;   - "#asinh".
;;   - "#acosh".
;;   - "#atanh".
;;   - "#xlog2x": x * log(2) x
;;   - "#xlognx": x * log(2.71) x
;;   - "#xlog10x": x * log(10) x
;; - p_a1: matrix.
;;
;; Sources:
;; - [7].
;;
(define (grsp-matrix-opfn p_s1 p_a1)
  (let ((res1 p_a1)
	(res3 0)
	(i1 0)
	(j1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))
    
    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))
    
    ;; Create holding matrix.
    (set! res3 (grsp-matrix-create res3 (+ (- hm1 ln1) 1) (+ (- hn1 ln1) 1)))    

    ;; Apply bitwise operation.
    (set! i1 lm1)		 
    (while (<= i1 hm1)
	   (set! j1 ln1)			
	   (while (<= j1 hn1)			       
		  (cond ((equal? p_s1 "#abs")
			 (array-set! res3 (abs (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#truncate")
			 (array-set! res3 (truncate (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#round")
			 (array-set! res3 (round (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#floor")
			 (array-set! res3 (floor (array-ref res1 i1 j1)) i1 j1)) 
			((equal? p_s1 "#ceiling")
			 (array-set! res3 (ceiling (array-ref res1 i1 j1)) i1 j1)) 
			((equal? p_s1 "#sqrt")
			 (array-set! res3 (sqrt (array-ref res1 i1 j1)) i1 j1)) 				     
			((equal? p_s1 "#sin")
			 (array-set! res3 (sin (array-ref res1 i1 j1)) i1 j1)) 			
			((equal? p_s1 "#cos")
			 (array-set! res3 (cos (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#tan")
			 (array-set! res3 (tan (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#asin")
			 (array-set! res3 (asin (array-ref res1 i1 j1)) i1 j1)) 			
			((equal? p_s1 "#acos")
			 (array-set! res3 (acos (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#atan")
			 (array-set! res3 (atan (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#exp")
			 (array-set! res3 (exp (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#log")
			 (array-set! res3 (log (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#log10")
			 (array-set! res3 (log10 (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#sinh")
			 (array-set! res3 (sinh (array-ref res1 i1 j1)) i1 j1)) 			
			((equal? p_s1 "#cosh")
			 (array-set! res3 (cosh (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#tanh")
			 (array-set! res3 (tanh (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#asinh")
			 (array-set! res3 (asinh (array-ref res1 i1 j1)) i1 j1)) 			
			((equal? p_s1 "#acosh")
			 (array-set! res3 (acosh (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#atanh")
			 (array-set! res3 (atanh (array-ref res1 i1 j1)) i1 j1))
			((equal? p_s1 "#xlog2x")
			 (array-set! res3 (* (array-ref res1 i1 j1)
					     (grsp-log 2 (array-ref res1 i1 j1))) i1 j1))			
			((equal? p_s1 "#xlognx")
			 (array-set! res3 (* (array-ref res1 i1 j1)
					     (log (array-ref res1 i1 j1))) i1 j1))
			((equal? p_s1 "#xlog10x")
			 (array-set! res3 (* (array-ref res1 i1 j1)
					     (log10 (array-ref res1 i1 j1))) i1 j1)))			
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))

    res3))


;;;; grsp-matrix-opmm - Performs operation p_s1 between matrices p_a1 and p_a2.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s1: operation described as a string:
;;   - "#+": matrix to matrix sum.
;;   - "#-": matrix to matrix substraction.
;;   - "#*": matrix to matrix multiplication.
;;   - "#/": matrix to matrix pseudo-division.
;; - p_a1: first matrix.
;; - p_a2: second matrix.
;;
;; Notes:
;; - This function does not validate the dimensionality or boundaries of the 
;;   matrices involved; the user or an additional shell function should take
;;   care of that.
;;
(define (grsp-matrix-opmm p_s1 p_a1 p_a2)
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

    ;; Extract the boundaries of the first matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    ;; Extract the boundaries of the second matrix.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))    

    ;; Define the size of the results matrix.
    (set! lm3 lm1)
    (set! hm3 hm1)
    (set! ln3 ln2)
    (set! hn3 hn2)
		   
    ;; Create holding matrix.
    (set! res3 (grsp-matrix-create res3 (+ (- hm3 lm3) 1) (+ (- hn3 ln3) 1)))
    
    ;; Apply mm operation.
    (cond ((equal? p_s1 "#*")
	   (set! i1 lm3)
	   (while (<= i1 hm3)
		  (set! j1 ln3)
		  (while (<= j1 hn3)
			 (set! res4 0)
			 (set! i2 0)
			 (while (<= i2 hm3)
				(set! res4 (+ res4 (* (array-ref res1 i1 i2)
						      (array-ref res2 i2 j1))))
				(set! i2 (+ i2 1)))
			 (array-set! res3 res4 i1 j1)
			 (set! j1 (+ j1 1)))
		  (set! i1 (+ i1 1))))
	  ((equal? p_s1 "#/")
	   (set! i1 lm3)
	   (while (<= i1 hm3)
		  (set! j1 ln3)
		  (while (<= j1 hn3)
			 (set! res4 0)
			 (set! i2 0)
			 (while (<= i2 hm3)
				(set! res4 (+ res4 (/ (array-ref res1 i1 i2)
						      (array-ref res2 i2 j1))))
				(set! i2 (+ i2 1)))
			 (array-set! res3 res4 i1 j1)
			 (set! j1 (+ j1 1)))
		  (set! i1 (+ i1 1))))	  
	  ((equal? p_s1 "#+")
	   (set! res3 (grsp-matrix-opew p_s1 res1 res2)))
	  ((equal? p_s1 "#-")
	   (set! res3 (grsp-matrix-opew p_s1 res1 res2))))

    res3))


;;;; grsp-matrix-cpy - Copies matrix p_a1, element wise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; p_a1: matrix to be copied.
;;
;; Output:
;; - A copy of p_a1.
;;
(define (grsp-matrix-cpy p_a1)
  (let ((res1 0)
 	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))	

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1)) 
    
    ;; Compose results.
    (set! res1 (grsp-matrix-subcpy p_a1 lm1 hm1 ln1 hn1))

    res1))


;;;; grsp-matrix-subcpy - Extracts a block or sub matrix from matrix p_a1. The
;; process is not destructive with regards to p_a1. The user is responsible for
;; providing correct boundaries since the function does not check those
;; parameters in relation to p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix to be partitioned.
;; - p_lm1: lower m boundary (rows).
;; - p_hm1: higher m boundary (rows).
;; - p_ln1: lower n boundary (cols).
;; - p_hn1: higher n boundary (cols).
;;
(define (grsp-matrix-subcpy p_a1 p_lm1 p_hm1 p_ln1 p_hn1)
  (let ((res1 p_a1)
	(res2 0)
	(i1 0)
	(i2 0)
	(j1 0)
	(j2 0))

    ;; Create submatrix.
    (set! res2 (grsp-matrix-create res2 (+ (- p_hm1 p_lm1) 1) (+ (- p_hn1 p_ln1) 1)))  
    
    ;; Copy to submatrix.
    (set! i1 p_lm1)
    (while (<= i1 p_hm1)
	   (set! j1 p_ln1)
	   (set! j2 0)
	   (while (<= j1 p_hn1)
		  (array-set! res2 (array-ref res1 i1 j1) i2 j2)
		  (set! j2 (+ j2 1))
		  (set! j1 (+ j1 1)))
	   (set! i2 (+ i2 1))
	   (set! i1 (+ i1 1)))

    res2))


;;;; grsp-matrix-subrep - Replaces a submatrix or section of matrix p_a1 with 
;; matrix p_a2.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;; 
;; Arguments:
;; - p_a1: matrix.
;; - p_a2: matrix.
;; - p_m1: row coordinate of p_a1 where to place the upper left corner of p_a2.
;; - p_n1: col coordinate of p_a1 where to place the upper left corner of p_a2.
;;
(define (grsp-matrix-subrep p_a1 p_a2 p_m1 p_n1)
  (let ((res1 p_a1)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(i1 p_m1)
	(j1 p_n1)
	(i2 0)
	(j2 0))
    
    ;; Extract the boundaries of the first matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    ;; Extract the boundaries of the second matrix.
    (set! lm2 (grsp-matrix-esi 1 p_a2))
    (set! hm2 (grsp-matrix-esi 2 p_a2))
    (set! ln2 (grsp-matrix-esi 3 p_a2))
    (set! hn2 (grsp-matrix-esi 4 p_a2))    

    ;; Replacement loop.
    (set! i2 lm2)
    (set! i1 p_m1) 
    (while (<= i2 hm2)
	   (set! j1 p_n1)
	   (set! j2 ln2)
	   (while (<= j2 hn2)
		  (array-set! res1 (array-ref p_a2 i2 j2) i1 j1)
		  (set! j2 (+ j2 1))
		  (set! j1 (+ j1 1)))
	   (set! i2 (+ i2 1))
	   (set! i1 (+ i1 1)))

    res1))


;;;; grsp-matrix-subdcn - Deletes row from matrix p_a1 that fulfills condition
;; p_s2 for column p_j1 with regards to value p_n2.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s2 query:
;;   - "#=": equal.
;;   - "#>": greater.
;;   - "#<": less.
;;   - "#>=": greater or equal.
;;   - "#<=": less or equal.
;;   - "#!=": not equal.
;; - p_a1: matrix.
;; - p_j1: col number to query.
;; - p_n2: element value to query according to p_s1 and p_j1.
;;
;; Notes
;; - Obsolete. Use grsp-matrix-row-delete p_s1 instead.
;;
(define (grsp-matrix-subdcn p_s2 p_a1 p_j1 p_n2)
  (let ((res1 p_a1)
	(i1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(b1 #f))
    
    ;; Extract boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))
    
    (set! i1 lm1)
    (while (<= i1 hm1)

	   ;; Find out if the row meets the conditions to be deleted.
	   (cond ((equal? p_s2 "#=")
		  (cond ((equal? (array-ref res1 i1 p_j1) p_n2)
			 (set! b1 #t))))
		 ((equal? p_s2 "#<")
		  (cond ((< (array-ref res1 i1 p_j1) p_n2)
			 (set! b1 #t))))
		 ((equal? p_s2 "#>")
		  (cond ((> (array-ref res1 i1 p_j1) p_n2)
			 (set! b1 #t))))
		 ((equal? p_s2 "#<=")
		  (cond ((<= (array-ref res1 i1 p_j1) p_n2)
			 (set! b1 #t))))
		 ((equal? p_s2 "#>=")
		  (cond ((>= (array-ref res1 i1 p_j1) p_n2)
			 (set! b1 #t))))
		 ((equal? p_s2 "#!=")
		  (cond ((or (< (array-ref res1 i1 p_j1) p_n2)
			     (> (array-ref res1 i1 p_j1) p_n2))
			 (set! b1 #t)))))		 

	   ;; Check col range.
	   (cond ((< p_j1 ln1)
		  (set! b1 #f))
		 ((> p_j1 hn1)
		  (set! b1 #f)))
	   
	   ;; Delete row, if applicable.
	   (cond ((equal? b1 #t)

		  ;; Delete row where the p_n1th col element has value p_n2
		  (set! res1 (grsp-matrix-subdel "#Delr" res1 i1))

		  ;; Extract boundaries of the now row-rerduced matrix.
		  (set! lm1 (grsp-matrix-esi 1 res1))
		  (set! hm1 (grsp-matrix-esi 2 res1))
		  (set! b1 #f)

		  ;; Reset loop counter.
		  (set! i1 (- lm1 1))))
	   
	   (set! i1 (+ i1 1)))
	   
    res1))


;;;; grsp-matrix-subdel - Deletes column or row p_n1 from matrix p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s1: string describing the required operation.
;;   - "#Delc": delete column.
;;   - "#Delr": delete row. 
;; - p_a1: matrix.
;; - p_n1: row or col number to delete.
;;
(define (grsp-matrix-subdel p_s1 p_a1 p_n1)
  (let ((res1 p_a1)
	(res2 0)
	(res3 0)
	(res4 0)
	(n1 p_n1)
	(n2 0)
	(c1 0)
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

    ;; Extract the boundaries of the first matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))
    
    (cond ((equal? p_s1 "#Delc")
	   (set! res2 (grsp-matrix-transpose res1))
	   (set! res2 (grsp-matrix-subdel "#Delr" res2 p_n1))
	   
	   ;; Transpose three times more to return to original state.
	   (set! res2 (grsp-matrix-transposer res2 3)))	  
	  ((equal? p_s1 "#Delr")
	   (cond ((equal? n1 lm1)
		  (set! res2 (grsp-matrix-subcpy res1 (+ lm1 1) hm1 ln1 hn1)))
		 ((equal? n1 hm1)
		  (set! res2 (grsp-matrix-subcpy res1 lm1 (- hm1 1) ln1 hn1)))
		 ((and (> n1 lm1) (< n1 hm1))		  
		  (set! res3 (grsp-matrix-subcpy res1 lm1 (- n1 1) ln1 hn1))
		  (set! res4 (grsp-matrix-subcpy res1 (+ n1 1) hm1 ln1 hn1))

		  ;; Get structural data from the third submatix.
		  (set! lm3 (grsp-matrix-esi 1 res3))
		  (set! hm3 (grsp-matrix-esi 2 res3))
		  (set! ln3 (grsp-matrix-esi 3 res3))
		  (set! hn3 (grsp-matrix-esi 4 res3))			

		  ;; Get structural data from the fourth submatix.
		  (set! lm4 (grsp-matrix-esi 1 res4))
		  (set! hm4 (grsp-matrix-esi 2 res4))
		  (set! ln4 (grsp-matrix-esi 3 res4))
		  (set! hn4 (grsp-matrix-esi 4 res4))

		  ;; Expand the third submatrix in order to paste to the fourh
		  ;; one.		    
		  (set! res3 (grsp-matrix-subexp res3 (+ 1 (- hm4 lm4)) 0))		  
		  
		  ;; Move the data of the fourth submatrix to the expanded part 
		  ;; of the third one.
		  (set! res2 (grsp-matrix-subrep res3 res4 (+ hm3 1) ln3))))))
    
    res2))


;;;; grsp-matrix-subexp - Add p_am1 rows and p_an1 cols to a matrix p_a1,
;; increasing its size.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix to expand.
;; - p_am1: rows to add.
;; - p_an1: cols to add.
;;
(define (grsp-matrix-subexp p_a1 p_am1 p_an1)
  (let ((res1 p_a1)
	(res2 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    ;; Create expanded matrix.
    (set! res2 (grsp-matrix-create res2 (+ (- (+ hm1 p_am1) ln1) 1) (+ (- (+ hn1 p_an1) ln1) 1)))

    ;; Copy to submatrix.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  (array-set! res2 (array-ref res1 i1 j1) i1 j1)
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))

    res2))


;;;; grsp-matrix-is-equal - Returns #t if matrix p_a1 is equal to matrix p_a2
;; (same dimensionality and same elements).
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;; 
;; Arguments:
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
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
	(i1 0)
	(j1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0))

    ;; Extract the boundaries of the first matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    ;; Extract the boundaries of the second matrix.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))

    ;; Compare the size of both matrices.
    (cond ((= lm1 lm2)
	   (cond ((= hm1 hm2)
		  (cond ((= ln1 ln2)
			 (cond ((= hn1 hn2)
				(set! res3 #t)
				(set! res4 #t)))))))))
    
    ;; If the size is the same, compare each element.
    (cond ((equal? res4 #t)
	   (set! i1 lm1)
	   (while (<= i1 hm1)
		  (set! j1 ln1)
		  (while (<= j1 hn1)
			 (cond ((equal? (equal? (grsp-gtels (array-ref res1 i1 j1) (array-ref res2 i1 j1)) 0) #f)
				(set! res5 (+ res5 1))))
			 (set! j1 (+ j1 1)))
		  (set! i1 (+ i1 1)))))

    (cond ((> res5 0)
	   (set! res3 #f)))

    res3))


;;;; grsp-matrix-is-square - Returns #t if matrix p_a1 is square (i.e. m x m).
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-square p_a1)
  (let ((res1 p_a1)
	(res2 #f)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    ;; Find out if m = n.
    (cond ((equal? (- hm1 lm1) (- hn1 ln1))
	   (set! res2 #t)))
    
    res2))


;;;; grsp-matrix-is-symmetric - Returns #t if p_a1 is a symmetrix matrix. #f 
;; otherwise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
;; Notes:
;; - For non-complex numbers.
;;
(define (grsp-matrix-is-symmetric p_a1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-is-square p_a1) #t)
	   (set! res1 (grsp-matrix-is-equal p_a1 (grsp-matrix-transpose p_a1)))))

    res1))


;;;; grsp-matrix-is-diagonal - Returns #t if p_a1 is a square diagonal matrix,
;; #f otherise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-diagonal p_a1)
  (let ((res1 #f)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(k1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))    

    (cond ((equal? (grsp-matrix-is-square p_a1) #t)
	   (set! i1 lm1)
	   (while (<= i1 hm1)
		  (set! j1 ln1)
		  (while (<= j1 hn1)
			 (cond ((equal? (equal? (array-ref p_a1 i1 j1) 0) #f)
				(cond ((equal? (equal? i1 j1) #f)
				       (set! k1 (+ k1 1))))))
			 (set! j1 (+ j1 1)))
		  (set! i1 (+ i1 1)))
	   (cond ((equal? k1 0)
		  (set! res1 #t)))))

    res1))


;;;; grsp-matrix-is-hermitian - Returns #t if p_a1 is equal to its conjugate 
;; transpose.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-hermitian p_a1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-is-square p_a1) #t)
	   (cond ((grsp-matrix-is-equal p_a1 (grsp-matrix-conjugate-transpose p_a1))
		  (set! res1 #t)))))

    res1))


;;;; grsp-matrix-is-binary - Returns #t if p_a1 contains only values 0 or 1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-binary p_a1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-find "#>" p_a1 1) 0)
	   (cond ((equal? (grsp-matrix-find "#<" p_a1 0) 0)
		  (set! res1 #t)))))

    res1))


;;;; grsp-matrix-is-nonnegative - Returns #t if p_a1 contains only values >= 0.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-nonnegative p_a1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-find "#<" p_a1 0) 0)
	   (set! res1 #t)))

    res1))


;;;; grsp-matrix-is-positive - Returns #t if p_a1 contains only values > 0.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-positive p_a1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-find "#<=" p_a1 0) 0)
	   (set! res1 #t)))

    res1))


;;;; grsp-matrix-row-opar - Finds the inverse multiple res1 of p_a1[p_m2, p_n2]
;; so that p_a1[p_m2, p_n2] + ( p_a1[p_m1, p_n1] * res1 ) = 0
;;
;; or
;;
;; res1 = -1 * ( p_a1[p_m2, p_n2] / p_a1[p_m1, p_n1])
;;
;; and
;;
;; replaces p_a1[p_m2, p_n2] with 0.
;;
;; and
;;
;; replaces p_a2[p_m2, p_n2] with res1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix 1.
;; - p_a2: matrix 2.
;; - p_m1: m coord of upper row element.
;; - p_n1: n coord of upper row element.
;; - p_m2: m coord of lower row element.
;; - p_n2: n coord of lower row element.
;;
;; Output:
;; - Note that the function does not return a value but modifies the values of
;;   elements in two matrices directly.
;;
;; Sources:
;; - [8].
;;
(define (grsp-matrix-row-opar p_a1 p_a2 p_m1 p_n1 p_m2 p_n2)
  (let ((res1 0))

    (set! res1 (* 1 (/ (array-ref p_a1 p_m2 p_n2)
		      (array-ref p_a1 p_m1 p_n1))))
    (array-set! p_a1 0 p_m2 p_n2)
    (array-set! p_a2 res1 p_m2 p_n2)

    res1))


;;;; grsp-matrix-row-opmm - Replaces the value of element p_a1[p_m1, p_n1] with
;; ( p_a1[p_m1, p_n1] * p_a2[p_m2, p_n2] ).
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix 1.
;; - p_a2: matrix 2.
;; - p_m1: m coord of p_a1 element.
;; - p_n1: n coord of p_a1 element.
;; - p_m2: m coord of p_a2 element.
;; - p_n2: n coord of p_a2 element.
;;
;; Output:
;; - Note that the function does not return a value but modifies the values of
;;   elements in one matrix.
;;
;; Sources:
;; - [8].
;;
(define (grsp-matrix-row-opmm p_a1 p_a2 p_m1 p_n1 p_m2 p_n2)
  (array-set! p_a1 (* (array-ref p_a1 p_m1 p_n1)
		      (array-ref p_a2 p_m2 p_n2)) p_m1 p_n1))


;;;; grsp-matrix-row-opsc - Performs operation p_s1 between all elements
;; belonging to row p_m1 of matrix p_a1 and scalar p_v1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s1: operation described as a string:
;;   - "#+": sum.
;;   - "#-": substraction.
;;   - "#*": multiplication.
;;   - "#/": division.
;;
;; Output:
;; - Note that the function does not return a value but modifies the values of
;;   elements in row p_m1 of matrix p_a1.
;;
;; Sources:
;; - [8].
;;
(define (grsp-matrix-row-opsc p_s1 p_a1 p_m1 p_v1)
  (let ((ln1 0)
	(hn1 0)
	(j1 0))

    ;; Extract the boundaries of the row.
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    (set! j1 ln1)
    (while (<= j1 hn1)
	   (cond ((equal? p_s1 "#+")
		  (array-set! p_a1 (+ (array-ref p_a1 p_m1 j1) p_v1) p_m1 j1))
		 ((equal? p_s1 "#-")
		  (array-set! p_a1 (+ (array-ref p_a1 p_m1 j1) p_v1) p_m1 j1))		 
		 ((equal? p_s1 "#*")
		  (array-set! p_a1 (* (array-ref p_a1 p_m1 j1) p_v1) p_m1 j1))
		 ((equal? p_s1 "#/")
		  (array-set! p_a1 (+ (array-ref p_a1 p_m1 j1) p_v1) p_m1 j1)))
	   (set! j1 (+ j1 1)))))


;;;; grsp-matrix-row-opsw - Swaps rows p_m1 and p_m2 in matrix p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_m1: row of p_a1.
;; - p_m2: row of p_a1.
;;
;; Output:
;; - Note that the function does not return a value but modifies the values of
;;   elements in matrix p_a1.
;;
;; Sources:
;; - [8].
;;
(define (grsp-matrix-row-opsw p_a1 p_m1 p_m2)
  (let ((res1 p_a1)
	(res2 0)
	(res3 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))
	
    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Copy elements of p_a1, rows p_m1 and p_m2 to separate arrays.
    (set! res2 (grsp-matrix-subcpy p_a1 p_m1 p_m1 ln1 hn1))
    (set! res3 (grsp-matrix-subcpy p_a1 p_m2 p_m2 ln1 hn1))

    ;; Swap positions.
    (set! p_a1 (grsp-matrix-subrep p_a1 res2 p_m2 ln1))
    (set! p_a1 (grsp-matrix-subrep p_a1 res3 p_m1 ln1))))


;;;; grsp-matrix-decompose - Applies decomposition p_s1 to matrix p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s1: decomposition type.
;;   - "#LU": LU by Gaussian elimination.
;; - p_a1: matrix to be decomposed.
;; - This function does not perform viability checks on p_a1 for the 
;;   required operation; the user or an additional shell function should take 
;;   care of that.
;;
;; Sources:
;; - [6].
;;
(define (grsp-matrix-decompose p_s1 p_a1)
  (let ((res1 p_a1)
	(res2 '())
	(res3 0)
	(res4 0)
	(L 0)
	(U p_a1)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(k1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))	

    (cond ((equal? p_s1 "#LU")
	   (set! L (grsp-matrix-create "#I" (+ (- hm1 ln1) 1) (+ (- hn1 ln1) 1)))
	   (set! i1 (+ lm1 1))
	   	   
	   ;; Column cycle.
	   (while (<= i1 hm1)
		  (set! j1 ln1)
		  (set! k1 ln1)
		  (while (< j1 i1)
			 (cond ((> k1 ln1)
				(while (<= k1 j1)
				       (array-set! U (* (array-ref U (- k1 1) j1) res4) k1 j1)
				       (set! k1 (+ k1 1)))
				(set! k1 ln1)))
			 (cond ((equal? k1 ln1)
				(set! res4 (grsp-matrix-row-opar U L k1 j1 i1 j1))				
				(set! k1 (+ k1 1))))
			 (set! j1 (+ j1 1)))
		  (set! i1 (+ i1 1)))
	   (set! res2 (list L U))))

    res2))


;;;; grsp-matrix-density - Returns the density value of matrix p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-density p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(d1 0)
	(t1 0)
	(t2 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))    

    (set! t1 (grsp-matrix-total-elements p_a1))
    (set! res1 (grsp-matrix-find "#=" p_a1 0))   
    (cond ((equal? res1 0)
	   (set! d1 1)))
    (cond ((< d1 1)
	   (set! lm2 (grsp-matrix-esi 1 res1))
	   (set! hm2 (grsp-matrix-esi 2 res1))
	   (set! t2 (+ (- hm2 lm2) 1))
	   (set! d1 (- 1 (/ t2 t1)))))
    (set! res2 d1)
    
    res2))


;;;; grsp-matrix-is-sparse - Returns #t if matrix density of p_a1 is < 0.5, or #f
;; otherwise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-sparse p_a1)
  (let ((res1 #f))

    (cond ((< (grsp-matrix-density p_a1) 0.5)
	   (set! res1 #t)))
    
    res1))


;;;; grsp-matrix-is-symmetric-md - Returns #t if matrix p_a1 is symmetric along 
;; its main diagonal; #f otherwise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-symmetric-md p_a1)
  (let ((res1 #f)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(d1 0))

    (cond ((equal? (grsp-matrix-is-square p_a1))
	   
	   ;; Extract the boundaries of the argument matrix.
	   (set! lm1 (grsp-matrix-esi 1 p_a1))
	   (set! hm1 (grsp-matrix-esi 2 p_a1))
	   (set! ln1 (grsp-matrix-esi 3 p_a1))
	   (set! hn1 (grsp-matrix-esi 4 p_a1))	

	   (set! i1 lm1)
	   (while (<= i1 hm1)
		  (set! j1 ln1)
		  (while (<= j1 hn1)
			 (cond ((equal? (array-ref p_a1 i1 j1)
					(array-ref p_a1 j1 i1))
				(set! d1 (+ d1 1))))
			 (set! j1 (+ j1 1)))
		  (set! i1 (+ i1 1)))

	   (cond ((equal? d1 (grsp-matrix-total-elements p_a1))
		  (set! res1 #t)))))

    res1))


;;;; grsp-matrix-total-elements - Calculates the number of elements in matrix
;; p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-total-elements p_a1)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))
    
    (set! res1 (* (+ (- hm1 lm1) 1) (+ (- hn1 ln1) 1)))
    
    res1))


;;;; grsp-matrix-total-element - Count the number of ocurrences of p_v1 in p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_v1: element value.
;;
(define (grsp-matrix-total-element p_a1 p_v1)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  (cond ((equal? p_v1 (array-ref p_a1 i1 j1))
			 (set! res1 (+ res1 1))))
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))
    res1))

    
;;;; grsp-matrix-is-hadamard - Returns #t if matrix p_a1 is of Hadamard type; #f
;; otherwise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-hadamard p_a1)
  (let ((res1 #f)
	(t1 0)
	(t2 0)
	(t3 0))

    (cond ((equal? (grsp-matrix-is-symmetric-md p_a1) #t)
	   (set! t1 (grsp-matrix-total-elements p_a1))
	   (set! t2 (grsp-matrix-total-element p_a1 -1))
	   (set! t3 (grsp-matrix-total-element p_a1 1))
	   (cond ((equal? t1 (+ t2 t3))
		  (set! res1 #t)))))

    res1))
	   

;;;; grsp-matrix-is-markov - Returns #t if matrix p_a1 is of Markov type; #f
;; otherwise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-markov p_a1)
  (let ((res1 #f)
	(res2 0)
	(res3 #t)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(k1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! res2 (grsp-matrix-subcpy p_a1 i1 i1 ln1 hn1))
	   (cond ((equal? (grsp-matrix-is-nonnegative res2) #t)
		  (set! k1 (+ k1 (grsp-matrix-opio "#+" res2 0))))
		 (else (set! res3 #f)))
	   (set! i1 (+ i1 1)))
    (cond ((equal? res3 #t)
	   (cond ((equal? (/ k1 (+ (- hm1 lm1) 1)) 1)
		  (set! res1 #t)))))

    res1))


;;;; grsp-matrix-is-signature - Returns #t if matrix p_a1 is of signature
;; type; #f otherwise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-signature p_a1)
  (let ((res1 #f)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(k1 0)
	(k2 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    (cond ((equal? (grsp-matrix-is-diagonal p_a1) #t)    
	   (set! i1 lm1)
	   (set! res1 #t)
	   (while (<= i1 hm1)
		  (set! j1 ln1)
		  (while (<= j1 hn1)
			 (cond ((equal? i1 j1)
				(cond ((equal? (abs (array-ref p_a1 i1 j1)) 1)
				       (set! k1 (+ k1 1)))
				      (else ((set! res1 #f))))))
			 (set! j1 (+ j1 1)))
		  (set! i1 (+ i1 1)))))

    res1))


;;;; grsp-matrix-is-single-entry - Returns #t if matrix p_a1 is of single entry 
;; type for value p_v1; #f otherwise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_v1: value.
;;
(define (grsp-matrix-is-single-entry p_a1 p_v1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-total-element p_a1 p_v1) 1)
	   (cond ((equal? (- (grsp-matrix-total-elements p_a1) 1)
			  (grsp-matrix-total-element p_a1 0))
		  (set! res1 #t)))))

    res1))


;;;; grsp-matrix-identify - Returns #t if matrix p_a1 is of type p_s1. This 
;; function aggregates several specific identification functions into one
;; single interface.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s1: matrix type.
;;   - "#I": identity.
;;   - "#AI": anti-identity.
;;   - "#Square".
;;   - "#S": symetric.
;;   - "#MD": main diagonal.
;;   - "#Hermitian".
;;   - "#Binary".
;;   - "#P": positive.
;;   - "#NN": non negative.
;;   - "#Sparse".
;;   - "#SMD": symmetric along main diagonal.
;;   - "#Markov".
;;   - "#Signature": signature.
;;   - "#SE": single entry.
;;   - "#Q": quincunx.
;;   - "#Ladder".
;;   - "#Arrow".
;;   - "#Lehmer".
;;   - "#Pascal".
;;   - "#Idempotent".
;;   - "#Metzler".
;; - p_a1: matrix.
;;
(define (grsp-matrix-identify p_s1 p_a1)
  (let ((res1 #f)
	(res2 0)
	(v1 #f)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))

    ;; Calls for specific-type functions.
    (cond ((equal? p_s1 "#SE")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-single-entry p_a1 1)))
	  ((equal? p_s1 "#Signature")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-signature p_a1)))
	  ((equal? p_s1 "#Markov")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-markov p_a1)))
	  ((equal? p_s1 "#Hadamard")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-hadamard p_a1)))
	  ((equal? p_s1 "#SMD")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-symmetric-md p_a1)))
	  ((equal? p_s1 "#Sparse")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-sparse p_a1)))
	  ((equal? p_s1 "#NN")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-nonnegative p_a1)))
	  ((equal? p_s1 "#P")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-positive p_a1)))
	  ((equal? p_s1 "#Binary")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-binary p_a1)))
	  ((equal? p_s1 "#Hermitian")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-hermitian p_a1)))
	  ((equal? p_s1 "#S")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-symmetric p_a1)))
	  ((equal? p_s1 "#MD")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-diagonal p_a1)))
	  ((equal? p_s1 "#Metzler")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-metzler p_a1)))	  
	  ((equal? p_s1 "#Idempotent")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-equal p_a1 (grsp-matrix-opmm "#*" p_a1 p_a1))))	  
	  ((equal? p_s1 "#Square")
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-square p_a1))))

    ;; Default identification by comparison call. Needs to be placed in a 
    ;; different conditional. Otherwise does not work well (bug?).
    (cond ((equal? v1 #f)
	   
           ;; Extract the boundaries of the argument matrix.
	   (set! lm1 (grsp-matrix-esi 1 p_a1))
	   (set! hm1 (grsp-matrix-esi 2 p_a1))
	   (set! ln1 (grsp-matrix-esi 3 p_a1))
	   (set! hn1 (grsp-matrix-esi 4 p_a1))

	   ;; Compare.
	   (set! res1 (grsp-matrix-is-equal p_a1 (grsp-matrix-create p_s1 (+ (- hm1 lm1) 1) (+ (- hn1 ln1) 1)) ))))

    res1))


;;;; grsp-matrix-is-metzler - Returns #t if matrix p_a1 is of Metzler type; #f
;; otherwise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-metzler p_a1)
  (let ((res1 #f)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(k1 1))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))
    
    (cond ((equal? (grsp-matrix-is-square p_a1) #t)
	   (set! i1 lm1)
	   (set! res1 #t)
	   (while (<= i1 hm1)
		  (set! j1 ln1)
		  (while (<= j1 hn1)
			 (cond ((< (array-ref p_a1 i1 j1) 0)
				(cond ((equal? (equal? i1 j1) #f)
				       (set! res1 #f)))))
			 (set! j1 (+ j1 1)))
		  (set! i1 (+ i1 1)))))

    res1))
    

;;;; grsp-l2m - Casts a list p_l1 of n elements as a 1 x n matrix.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;;  Arguments:
;;  p_l1: list.
;;
(define (grsp-l2m p_l1)
  (let ((res1 (grsp-matrix-create 0 1 (length p_l1)))
	(i1 0)
	(n1 (- (length p_l1) 1)))

    ;; Cycle over the list and copy its elements to the argument matrix.
    (while (<= i1 n1)
	   (array-set! res1 (list-ref p_l1 i1) 0 i1)
	   (set! i1 (+ i1 1)))
    
    res1))
    

;;;; grsp-m2l - Casts a 1 x n matrix p_a1 as a list of n elements.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-m2l p_a1)
  (let ((res1 '())
	(i1 0)
	(n1 0)
	(ln1 0)
	(hn1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Create the list based on the dimensions of the matrix.
    (set! n1 (+ 1 (- hn1 ln1)))
    (set! res1 (make-list n1 0))

    ;; Cycle over the matrix and copy its elements to the list.
    (while (< i1 n1)
	   (list-set! res1 i1 (array-ref p_a1 0 i1))
	   (set! i1 (+ i1 1)))
    
    res1))


;;;; grsp-m2v - Casts a matrix p_a1 of m x n elements as a 1 x (m x n) vector.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;;  Arguments:
;;  p_a1: matrix.
;;
(define (grsp-m2v p_a1)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(j2 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Create vector.
    (set! res1 (grsp-matrix-create 0 1 (grsp-matrix-total-elements p_a1)))

    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  (array-set! res1 (array-ref p_a1 i1 j1) 0 j2)
		  (set! j2 (+ j2 1))
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))  
    
    res1))


;;;; grsp-dbc2cm - Fills a matrix of complex or complex-subset numbers with the
;; contents of a database containing serialized complex or complex-subset
;; numbers.
;;
;; Arguments;
;; - p_db1: database name.
;; - p_q1: database query.
;;
(define (grsp-dbc2mc p_db1 p_q1)
  (let ((res1 0))

    res1))


;;;; grsp-dbc2mc-csv - Fills a matrix of complex or complex-subset numbers with
;; the contents of a csv format database file containing serialized complex or
;; complex-subset numbers.
;;
;; Arguments;
;; - p_d1: database name.
;; - p_t1: table name.
;;
(define (grsp-dbc2mc-csv p_d1 p_t1)
  (let ((res1 0)
	(res3 0)
	(s1 "")
	(s2 "")
	(rp "")
	(l2 '())
	(l3 '())
	(j2 0)
	(i3 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(hn2 0)
	(lm3 0)
	(hm3 0)
	(ln3 0)
	(hn3 0)	
	(m1 0)
	(n1 0))

    ;; We have to create the relative path.
    (set! rp (strings-append (list p_d1 "/" p_t1) 0))

    ;; Read the whole .csv file as one string.
    (set! s1 (read-file-as-string rp))

    ;; Create the string record.
    ;; - field 1: row number.
    ;; - field 2: col number.
    ;; - field 3: value.

    ;; Create a list in which each line of the file becomes a list element.
    (set! l2 (string-split s1 #\nl))
    
    ;; Process list l2.
    (set! j2 0)
    (set! hn2 (- (length l2) 2))
    (while (<= j2 hn2)

	   ;; Take an element from l2 and create list l3 of three elements
	   ;; being these the two matrix coordinates and the matrix element.
	   ;; value.
	   (set! s2 (list-ref l2 j2))
	   (set! l3 (string-split s2 #\,))
	   
	   ;; Create res3 on the first instance; othewise add a row. This matrix
	   ;; will contain the numeric values of each file line.
	   (cond ((= j2 0)
		  (set! res3 (grsp-matrix-create 0 1 3)))
		 (else (set! res3 (grsp-matrix-subexp res3 1 0))))
	   
	   ;; Add the data of each file line read and converted to numeric
	   ;; values.
	   (set! lm3 (grsp-matrix-esi 1 res3))
	   (set! hm3 (grsp-matrix-esi 2 res3))
	   (set! ln3 (grsp-matrix-esi 3 res3))
	   (set! hn3 (grsp-matrix-esi 4 res3))

	   (array-set! res3 (grsp-s2n (list-ref l3 0)) hm3 0)
	   (array-set! res3 (grsp-s2n (list-ref l3 1)) hm3 1)
	   (array-set! res3 (grsp-s2n (list-ref l3 2)) hm3 2)
	   
	   (set! j2 (in j2)))

    ;; Find the max values of cols 0 and 1 of res3 and use them as dimensions to
    ;; create the final matrix.
    (set! lm1 (array-ref (grsp-matrix-row-sort "#asc" res3 0) 0 0))
    (set! hm1 (array-ref (grsp-matrix-row-sort "#des" res3 0) 0 0))
    (set! ln1 (array-ref (grsp-matrix-row-sort "#asc" res3 1) 0 1))
    (set! hn1 (array-ref (grsp-matrix-row-sort "#des" res3 1) 0 1))
    (set! res1 (grsp-matrix-create 0 (+ (- hm1 lm1) 1) (+ (- hn1 ln1) 1)))

    ;; Once the matrix has been created, go over it and read each row, pasting its
    ;; third element on the position described by the coordinates of res3.
    (set! i3 lm3)
    (while (<= i3 hm3)
	   (set! m1 (array-ref res3 i3 0))
	   (set! n1 (array-ref res3 i3 1))
	   (array-set! res1 (array-ref res3 i3 2) m1 n1)
	   (set! i3 (in i3)))
    
    res1))


;;;; grsp-mc2dbc - Creates a database table or dataset for complex or complex
;; subset numbers from matrix p_a1, which contains complex or complex-subset
;; numbers. 
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_d1: database name. If the name contains:
;;   - ".db": creates an Sqlite database.
;;   - ".csv": creates a csv database (folder).
;    - ".h5": creates an HDF5 database. 
;; - p_a1: matrix.
;; - p_t1: table name.
;;
;; Notes:
;; - The database name must contain the strings ".db", ".h5" or ".csv" in its
;;   name for this function to work.
;;
(define (grsp-mc2dbc p_d1 p_a1 p_t1)
  (cond ((>= (string-contains p_d1 ".db") 0)
	 (grsp-mc2dbc-sqlite3 p_d1 p_a1 p_t1))	
	((>= (string-contains p_d1 ".csv") 0)
	 (grsp-mc2dbc-csv p_d1 p_a1 p_t1))		
	((>= (string-contains p_d1 ".h5") 0)
	 (grsp-mc2dbc-hdf5 p_d1 p_a1 p_t1))))
	

;;;; grsp-mc2dbc-sqlite3 - Creates a Sqlite3 table or dataset for complex or
;; complex subset numbers from matrix p_a1, which contains complex or complex
;; subset numbers. 
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, databases.
;;
;; Arguments:
;; - p_d1: database name.
;; - p_a1: matrix.
;; - p_t1: table name.
;;
(define (grsp-mc2dbc-sqlite3 p_d1 p_a1 p_t1)
  (let ((q1 "")
	(q2 "")
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(vr 0)
	(vi 0)
	(vm 0)
	(vn 0)
	(ve 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Define its size.
    (set! vm (+ (- hm1 lm1) 1))
    (set! vn (+ (- hn1 ln1) 1))    
	
    ;; We have to create the table and, if necessary, the database.
    (set! q1 (strings-append (list "CREATE TABLE" p_t1 "(Id INTEGER PRIMARY KEY UNIQUE, Vm INTEGER, Vn INTEGER, Vr REAL, Vi REAL);") 1))
    (system (strings-append (list "./sqlp " p_d1 " \"" q1 "\"") 0))

    ;; Loop over p_a1 and extract each value and insert it into the new table.
    (set! i1 0)
    (while (< i1 vm)
	   (set! j1 0)
	   (while (< j1 vn)
		  
		  ;; Extract and analize each element of the matrix.
		  (set! ve (array-ref p_a1 i1 j1))
		  (set! vi 0)
		  (cond ((complex? ve)
			 (set! vr (real-part ve))
			 (set! vi (imag-part ve))))

		  ;; Insert each element as a record in the database.
		  (set! q2 (strings-append (list (grsp-n2s i1) ", " (grsp-n2s j1) ", " (grsp-n2s vr) ", " (grsp-n2s vi)) 0))
		  (set! q1 (strings-append (list "INSERT INTO " p_t1 " (Vm, Vn, Vr, Vi) VALUES (" q2 ");") 0))
		  (system (strings-append (list "./sqlp " p_d1 " \"" q1 "\"") 0))
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))))


;;;; grsp-mc2dbc-hdf5 - Creates an HDF5 table or dataset for complex or complex
;; subset numbers from matrix p_a1, which contains complex or complex subset
;; numbers. 
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, databases.
;;
;; Arguments:
;; - p_d1: database name.
;; - p_a1: matrix.
;; - p_t1: table name.
;;
(define (grsp-mc2dbc-hdf5 p_d1 p_a1 p_t1)
  (let ((q1 "")
	(q2 "")
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(vr 0)
	(vi 0)
	(vm 0)
	(vn 0)
	(ve 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Define its size.
    (set! vm (+ (- hm1 lm1) 1))
    (set! vn (+ (- hn1 ln1) 1))    
	
    ;; We have to create the table and, if necessary, the database.
    (set! q1 (strings-append (list "CREATE TABLE" p_t1 "(Id INTEGER PRIMARY KEY UNIQUE, Vm INTEGER, Vn INTEGER, Vr REAL, Vi REAL);") 1))
    (system (strings-append (list "./sqlp " p_d1 " \"" q1 "\"") 0))

    ;; Loop over p_a1 and extract each value and insert it into the new table.
    (set! i1 0)
    (while (< i1 vm)
	   (set! j1 0)
	   (while (< j1 vn)
		  
		  ;; Extract and analize each element of the matrix.
		  (set! ve (array-ref p_a1 i1 j1))
		  (set! vi 0)
		  (cond ((complex? ve)
			 (set! vr (real-part ve))
			 (set! vi (imag-part ve))))

		  ;; Insert each element as a record in the database.
		  (set! q2 (strings-append (list (grsp-n2s i1) ", " (grsp-n2s j1) ", " (grsp-n2s vr) ", " (grsp-n2s vi)) 0))
		  (set! q1 (strings-append (list "INSERT INTO " p_t1 " (Vm, Vn, Vr, Vi) VALUES (" q2 ");") 0))
		  (system (strings-append (list "./sqlp " p_d1 " \"" q1 "\"") 0))
		  (set! j1 (+ j1 1)))
	   
	   (set! i1 (+ i1 1)))))


;;;; grsp-mc2dbc-csv - Creates a csv table or dataset for complex or complex
;; subset numbers from matrix p_a1, which contains complex or complex subset
;; numbers. 
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, databases.
;;
;; Arguments:
;; - p_d1: database name.
;; - p_a1: matrix.
;; - p_t1: table name.
;;
(define (grsp-mc2dbc-csv p_d1 p_a1 p_t1)
  (let ((lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(ve 0)
	(rp "")
	(s1 "")
	(s2 ",")
	(s3 "")
	(d1 p_d1)
	(t1 p_t1)
	(i1 0)
	(j1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Test if p_d1 exists. If not, create it.
    (cond ((equal? (file-exists? d1) #f)
	   (mkdir d1)))
    
    ;; We have to create the relative path.
    (set! rp (strings-append (list d1 "/" t1) 0))
    
    ;; Loop over p_a1 and extract each value and insert it into the new table.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  
		  ;; Extract and analize each element of the matrix.
		  (set! ve (array-ref p_a1 i1 j1))

		  ;; Create the string record.
		  ;; - 0: row number.
		  ;; - 1: col number.
		  ;; - 2: value.
		  ;; If this is the last element of the matrix, do not add the
		  ;; new line character at the end of the string.
		  (cond ((equal? (and (>= j1 hn1) (>= i1 hm1)) #t)
			 (set! s1 (strings-append (list (grsp-n2s i1)
							s2
							(grsp-n2s j1)
							s2
							(grsp-n2s ve)) 0)))
			(else (set! s1 (strings-append (list (grsp-n2s i1)
							     s2
							     (grsp-n2s j1)
							     s2 (grsp-n2s ve)
							     "\n") 0))))
		  
		  ;; Add the line string to the file string.
		  (set! s3 (strings-append (list s3 s1) 0))
		  
		  (set! j1 (+ j1 1)))
	   
	   (set! i1 (+ i1 1)))

    (grsp-save-to-file s3 rp "w")))


;;;; grsp-mc2dbc-gnuplot1 - Creates a gnuplot data (.data) table from
;; matrix p_a1. data format is identical to grsp csv tables except that
;; commas are replaced by spaces.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, databases.
;;
;; Arguments:
;; - p_d1: database name.
;; - p_a1: matrix.
;; - p_t1: gnuplot data file name.
;;
;; Sources:
;; - [25].
;;
(define (grsp-mc2dbc-gnuplot1 p_d1 p_a1 p_t1)
  (let ((lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(ve 0)
	(rp "")
	(s1 "")
	(s2 " ")
	(s3 "")
	(d1 p_d1)
	(t1 p_t1)
	(i1 0)
	(j1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Test if p_d1 exists. If not, create it.
    (cond ((equal? (file-exists? d1) #f)
	   (mkdir d1)))
    
    ;; We have to create the relative path.
    (set! rp (strings-append (list d1 "/" t1) 0))
    
    ;; Loop over p_a1 and extract each value and insert it into the new table.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  
		  ;; Extract and analize each element of the matrix.
		  (set! ve (array-ref p_a1 i1 j1))

		  ;; Create the string record.
		  ;; - 0: row number.
		  ;; - 1: col number.
		  ;; - 2: value.
		  ;; If this is the last element of the matrix, do not add the
		  ;; new line character at the end of the string.
		  (cond ((equal? (and (>= j1 hn1) (>= i1 hm1)) #t)
			 (set! s1 (strings-append (list (grsp-n2s i1)
							s2
							(grsp-n2s j1)
							s2
							(grsp-n2s ve)) 0)))
			(else (set! s1 (strings-append (list (grsp-n2s i1)
							     s2
							     (grsp-n2s j1)
							     s2
							     (grsp-n2s ve)
							     "\n") 0))))
		   
		  ;; Add the line string to the file string.
		  (set! s3 (strings-append (list s3 s1) 0))
		  
		  (set! j1 (+ j1 1)))
	   
	   (set! i1 (+ i1 1)))

    (grsp-save-to-file s3 rp "w")))


;;;; grsp-mc2dbc-gnuplot2 - Creates a gnuplot data (.dat) table from
;; matrix p_a1. Rows are represented as lines, columns are sparated
;; with spaces.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, databases.
;;
;; Arguments:
;; - p_d1: database name.
;; - p_a1: matrix.
;; - p_t1: gnuplot data file name.
;;
;; Sources:
;; - [25].
;;
(define (grsp-mc2dbc-gnuplot2 p_d1 p_a1 p_t1)
  (let ((lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(ve 0)
	(rp "")
	(s1 "")
	(s2 " ")
	(s3 "")
	(d1 p_d1)
	(t1 p_t1)
	(i1 0)
	(j1 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Create file header.
    (set! s3 (strings-append (list "# " p_t1 "\n") 0))
    
    ;; Test if p_d1 exists. If not, create it.
    (cond ((equal? (file-exists? d1) #f)
	   (mkdir d1)))
    
    ;; We have to create the relative path.
    (set! rp (strings-append (list d1 "/" t1) 0))
    
    ;; Loop over p_a1 and extract each value and insert it into the new table.
    (set! i1 lm1)
    (while (<= i1 hm1)

	   (set! j1 ln1)
	   (while (<= j1 hn1)
    		  
		  ;; Extract and analize each element of the matrix.
		  (set! ve (array-ref p_a1 i1 j1))

		  ;; Create the string record
		  (cond ((> j1 ln1)
			 (set! s1 (strings-append (list s1 (grsp-n2s ve)) 1)))
			(else (set! s1 (grsp-n2s ve))))
		  
		  (set! j1 (+ j1 1)))

	   ;; Add the line string to the file string.
	   (cond ((> i1 lm1)
		  (set! s3 (strings-append (list s3 "\n" s1) 0)))
		 ;;(else (set! s3 s1)))
		 (else (set! s3 (strings-append (list s3 s1) 0))))
	   
	   (set! i1 (+ i1 1)))

    (grsp-save-to-file s3 rp "w")))
  

;;;; grsp-matrix-interval-mean - Creates a 3 x 1 matrix containing the following
;; values:
;; - (- p_n1 p_min).
;; - (p_min + p_max) / 2.
;; - (+ p_n1 p_max).
;; thus creating an interval [p_min, p_max] in which:
;; - p_min <= p_n1 <= p_max.
;; - p_min <= m <= p_max, being m the mean value of l1 and h1 (see var def).
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_n1: reference value.
;; - p_min: what needs to be substracted to p_n1 to define the lower boundary of
;;   the interval.
;; - p_max: what needs to be added to p_n1 to define the higher boundary of
;;   the interval.
;;
;; Output:
;; - A 3 x1 matrix in which:
;;   - The first element is l1.
;;   - The second is ((h1 + l1)/2).
;;   - The third element is h1.
;;
(define (grsp-matrix-interval-mean p_n1 p_min p_max)
  (let ((res1 (grsp-matrix-create 0 3 1))
	(l1 (- p_n1 p_min))
	(h1 (+ p_n1 p_max)))	   

    (array-set! res1 l1 0 0)
    (array-set! res1 (/ (+ h1 l1) 2) 1 0)
    (array-set! res1 h1 2 0)

    res1))


;;;; grsp-matrix-determinant-lu - Finds the determinant of matrix p_a1 using the
;; LU decompostion.  
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
;; Sources:
;; - [9][10][11][12][13].
;;
(define (grsp-matrix-determinant-lu p_a1)
  (let ((res1 0)
	(L 0)
	(U 0)
	(a2 '())
	(detl 1)
	(detu 1))

    ;; Perform a LU decomposition over p_a1
    (set! a2 (grsp-matrix-decompose "#LU" p_a1))
    (set! L (car a2))
    (set! U (car (cdr a2)))

    ;; Calculate the determinant of L
    (set! detl (grsp-matrix-opio "#*md" L 0))
    
    ;; Calculate the determinant of U.
    (set! detu (grsp-matrix-opio "#*md" U 0))

    ;; Calculate the determinant of p_a1.
    (set! res1 (* detl detu))
    
    res1))


;;;; grsp-matrix-is-invertible - Returns #t if matrix si invertible if its
;; determinant is != 0; #f otherwise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-invertible p_a1)
  (let ((res1 #t))

    (cond ((= (grsp-matrix-determinant-lu p_a1) 0)
	   (set! res1 #f)))
    
    res1))


;;;; grsp-eigenval-opio - Eigenvalue operations that return a scalar. 
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s1: string.
;;   - "#*": product of all eigenvalues.
;;   - "#+": sum of all eigenvalues.
;; - p_a1: matrix.
;;
;; Output:
;; - Returns a scalar (zero if no proper string p_s1 is passed).
;;
;; Sources:
;; - [14][15].
;;
(define (grsp-eigenval-opio p_s1 p_a1)
  (let ((res1 0))

    (cond ((equal? p_s1 "#*")
	   (set! res1 (grsp-matrix-determinant-lu p_a1)))
	  ((equal? p_s1 "#+")
	   (set! res1 (grsp-matrix-opio "#+md" p_a1 0))))
    
    res1))


;;;; grsp-matrix-sort - Sort elements in matrix p_a1 in ascending or descending
;; order.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments
;; - p_s1: sort type.
;;   - "#asc": ascending.
;;   - "#des": descending.
;; - p_a1: matrix.
;;
(define (grsp-matrix-sort p_s1 p_a1)
  (let ((res1 0)
	(res2 0)
	(s1 "#asc")
	(f1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)	
	(i1 0)
	(j1 0)
	(i2 0)
	(j2 0)
	(i3 0)
	(j3 0)
        (v2 0)
	(v3 0)
	(n1 +nan.0))

    ;; Create res1 with the same size as res2 and fill it with zeros.
    ;; (set! res2 p_a1)
    (set! res2 (grsp-matrix-cpy p_a1))
    (set! res1 res2)
    (set! res1 (grsp-matrix-opsc "#*" res1 0))
    
    ;; Extract the boundaries of the first matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))	

    ;; Extract the boundaries of the second matrix.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))	
    
    ;; Define sort order.
    (cond ((not (equal? p_s1 "#asc"))
	   (set! s1 "#des")))
    
    ;; Main cycle.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)

		  (set! v2 (array-ref res2 i1 j1))

		  (set! i3 lm2)
		  (set! j3 ln2)

		  ;; Compare v2 with the rest of the values.
		  (set! i2 lm2)
		  (while (<= i2 hm2)
			 (set! j2 ln2)
			 (while (<= j2 hn2)		  

				;; Read value in res2.
				(set! v3 (array-ref res2 i2 j2))

				; Compare.
				(cond ((eq? s1 "#asc")
				       (cond ((<= v3 v2)
					      (set! i3 i2)
					      (set! j3 j2)
					      (set! f1 +inf.0)
					      (set! v2 v3))))
				      ((eq? s1 "#des")
				       (cond ((>= v3 v2)
					      (set! i3 i2)
					      (set! j3 j2)					      
					      (set! f1 -inf.0)
					      (set! v2 v3)))))					      
				 
				(set! j2 (+ j2 1)))
			 (set! i2 (+ i2 1))) 

		  ;; Mark res2 element as read.
		  (array-set! res2 f1 i3 j3)

		  ;; Put sorted element in res1.
		  (array-set! res1 v2 i1 j1)
		  
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))

    res1))


;;;; grsp-matrix-minmax - Finds the maximum and minimum values in p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
;; Output:
;; - A 1 x 2 matrix containing the min and max values, respectively.
;;
(define (grsp-matrix-minmax p_a1)
  (let ((res1 0)
	(res2 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0))	

    (set! res1 (grsp-matrix-create 0 1 2))
    (set! res2 (grsp-matrix-sort "#asc" p_a1))

    ;; Extract the boundaries of the second matrix.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))    

    ;; Results
    (array-set! res1 (array-ref res2 lm2 ln2) 0 0)
    (array-set! res1 (array-ref res2 hm2 hn2) 0 1)    
    
    res1))


;;;; grsp-matrix-trim - Trim matrix data.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s1: type of operaton.
;; - p_a1: matrix
;; - p_n1: number.
;;
;; Output:
;; - Trimmed data as a 1 x n vector.
;;
(define (grsp-matrix-trim p_s1 p_a1 p_n1)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)	
	(i1 0)
	(j1 0)
	(n1 0)
	(b1 #f)
	(b2 #f))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))
    
    ;; Eval
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)

		  ;; Read value from matrix.
		  (set! n1 (array-ref p_a1 i1 j1))

		  ;; Check if the value meets the conditions to be trimmed
		  ;; or not.
		  (cond ((equal? p_s1 "#=")
			 (cond ((not (equal? n1 p_n1))
				(set! b2 #t))))
			((equal? p_s1 "#>")
			 (cond ((<= n1 p_n1)
				(set! b2 #t))))
			((equal? p_s1 "#<")
			 (cond ((>= n1 p_n1)
				(set! b2 #t))))
			((equal? p_s1 "#>=")
			 (cond ((< n1 p_n1)
				(set! b2 #t))))
			((equal? p_s1 "#<=")
			 (cond ((> n1 p_n1)
				(set! b2 #t))))			
			((equal? p_s1 "#!=")
			 (cond ((equal? n1 p_n1)
				(set! b2 #t)))))
			
		  ;; Add value to vector. If this is the first pass, create the
		  ;; vector first. If not, increase the vector size by one
		  ;; element to contain the new value passed from p_a1.
		  (cond ((equal? b2 #t)
			 (cond ((equal? b1 #f)
				
				;; Create empty vector.
				(set! res1 (grsp-matrix-create 0 1 1))
				(set! b1 #t))			       
			       ((equal? b1 #t)
				
				;; Add element to vector.
				(set! res1 (grsp-matrix-subexp res1 0 1))))

			 ;; Extract the boundaries of the matrix.
			 (set! lm2 (grsp-matrix-esi 1 res1))
			 (set! hm2 (grsp-matrix-esi 2 res1))
			 (set! ln2 (grsp-matrix-esi 3 res1))
			 (set! hn2 (grsp-matrix-esi 4 res1))

			 ;; Add approved number to the last element of the
			 ;; vector.
			 (array-set! res1 n1 lm2 hn2)			 
			 (set! b2 #f)))		  
		  
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))      

    res1))


;;;; grsp-matrix-select - Select between p_a1 and p_a2 based on the value of
;; p_n1. 
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_a2: matrix.
;; - p_n1:
;;   - 0.
;;   - 1.
;;
(define (grsp-matrix-select p_a1 p_a2 p_n1)
  (let ((res1 0))

    (cond ((= p_n1 0)
	   (set! res1 p_a1))
	  ((or (> p_n1 0) (< p_n1 0))
	   (set! res1 p_a2)))

    res1))


;;;; grsp-matrix-row-minmax - Finds the min or max value for column p_j1 in 
;; matrix p_a1 and returns a matrix containing the complete rows where that 
;; value is found.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_s1: string.
;;   - "#min".
;;   - "#max".
;; - p_a1: matrix.
;; - p_j1: column number.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-row-minmax p_s1 p_a1 p_j1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(hm2 0)
	(i1 0)
	(n1 0)
	(n2 0)
	(n3 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Create intermediate matrices.
    (set! res2 (grsp-matrix-subcpy p_a1 lm1 lm1 ln1 hn1))
    (set! res3 res2)
    
    ;; Eval
    (set! i1 lm1)
    (while (<= i1 hm1)

	   ;; Inter init.
	   (set! n2 (array-ref p_a1 i1 p_j1))
	   (set! n3 (array-ref res2 0 p_j1))
	   (set! res3 (grsp-matrix-subcpy p_a1 i1 i1 ln1 hn1))

	   ;; Compare.
	   (cond ((equal? p_s1 "#min")
		  (cond ((< n2 n3)
			 (set! res2 res3))
			((and (= n2 n3) (> i1 lm1))
			 (set! res2 (grsp-matrix-subexp res2 1 0))
			 (set! hm2 (grsp-matrix-esi 2 res2))
			 (set! res2 (grsp-matrix-subrep res2 res3 hm2 ln1)))))
		 ((equal? p_s1 "#max")
		  (cond ((> n2 n3)
			 (set! res2 res3))
			((and (= n2 n3) (> i1 lm1))
			 (set! res2 (grsp-matrix-subexp res2 1 0))
			 (set! hm2 (grsp-matrix-esi 2 res2))
			 (set! res2 (grsp-matrix-subrep res2 res3 hm2 ln1))))))			
	   
	   (set! i1 (+ i1 1)))

    ;; Compose results.
    (set! res1 res2)
    
    res1))


;;;; grsp-matrix-row-select - Select rows from matrix p_a1 for which condition
;; p_s1 is met with regards to value p_n1 in column p_j1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_s1: string.
;;   - "#<".
;;   - "#>".
;;   - "#>=".
;;   - "#<=".
;;   - "#!=".
;;   - "#=".
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: number.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-row-select p_s1 p_a1 p_j1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(hm2 0)
	(i1 0)
	(n1 0)
	(n2 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Create intermediate matrices.
    (set! res2 (grsp-matrix-create 0 1 (+ (- hn1 ln1) 1)))
    (set! res3 res2)
    
    ;; Eval
    (set! i1 lm1)
    (while (<= i1 hm1)

	   ;; Iter init.
	   (set! n2 (array-ref p_a1 i1 p_j1))
	   (set! res3 (grsp-matrix-subcpy p_a1 i1 i1 ln1 hn1))

	   ;; Compare.
	   (cond ((equal? p_s1 "#<")
		  (cond ((< n2 p_n1)
			 (set! res2 (grsp-matrix-subexp res2 1 0))
			 (set! hm2 (grsp-matrix-esi 2 res2))
			 (set! res2 (grsp-matrix-subrep res2 res3 hm2 ln1)))))
		 ((equal? p_s1 "#>")
		  (cond ((> n2 p_n1)
			 (set! res2 (grsp-matrix-subexp res2 1 0))
			 (set! hm2 (grsp-matrix-esi 2 res2))
			 (set! res2 (grsp-matrix-subrep res2 res3 hm2 ln1)))))
		 ((equal? p_s1 "#<=")
		  (cond ((<= n2 p_n1)
			 (set! res2 (grsp-matrix-subexp res2 1 0))
			 (set! hm2 (grsp-matrix-esi 2 res2))
			 (set! res2 (grsp-matrix-subrep res2 res3 hm2 ln1)))))		 
		 ((equal? p_s1 "#>=")
		  (cond ((>= n2 p_n1)
			 (set! res2 (grsp-matrix-subexp res2 1 0))
			 (set! hm2 (grsp-matrix-esi 2 res2))
			 (set! res2 (grsp-matrix-subrep res2 res3 hm2 ln1)))))
		 ((equal? p_s1 "#!=")
		  (cond ((not (= n2 p_n1))
			 (set! res2 (grsp-matrix-subexp res2 1 0))
			 (set! hm2 (grsp-matrix-esi 2 res2))
			 (set! res2 (grsp-matrix-subrep res2 res3 hm2 ln1)))))
		 ((equal? p_s1 "#=")
		  (cond ((= n2 p_n1)
			 (set! res2 (grsp-matrix-subexp res2 1 0))
			 (set! hm2 (grsp-matrix-esi 2 res2))
			 (set! res2 (grsp-matrix-subrep res2 res3 hm2 ln1))))))
	   
	   (set! i1 (+ i1 1)))

    ;; Compose results.
    (set! res1 (grsp-matrix-subdel "#Delr" res2 0))
    
    res1))


;;;; grsp-matrix-row-delete - Deletes rows from matrix p_a1 for which condition
;; p_s1 is met with regards to value p_n1 in column p_j1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_s1: string.
;;   - "#<".
;;   - "#>".
;;   - "#>=".
;;   - "#<=".
;;   - "#!=".
;;   - "#=".
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: number.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-row-delete p_s1 p_a1 p_j1 p_n1)
  (let ((res1 0)
	(s2 p_s1))

    ;; Compare.
    (cond ((equal? p_s1 "#<")
	   (set! s2 "#>="))
	  ((equal? p_s1 "#>")
	   (set! s2 "#<="))
	  ((equal? p_s1 "#<=")
	   (set! s2 "#>"))
	  ((equal? p_s1 "#>=")
	   (set! s2 "#<"))
	  ((equal? p_s1 "#=")
	   (set! s2 "#!="))
	  ((equal? p_s1 "#!=")
	   (set! s2 "#=")))

    ;; Compose results.    
    (set! res1 (grsp-matrix-row-select s2 p_a1 p_j1 p_n1))
    
    res1))


;;;; grsp-matrix-row-sort - Sorts rows from matrix p_a1 for which condition
;; p_s1 is met with regards to column p_j1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_s1: string.
;;   - "#asc".
;;   - "#des".
;; - p_a1: matrix.
;; - p_j1: column number.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-row-sort p_s1 p_a1 p_j1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(b1 #t)
	(n2 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(lm3 0)
	(hm3 0)
	(ln3 0)
	(hn3 0)
	(hm4 0))	

    (cond ((equal? p_s1 "#asc")
	   
	   ;; Extract the boundaries of the argument matrix.
	   (set! lm1 (grsp-matrix-esi 1 p_a1))
	   (set! hm1 (grsp-matrix-esi 2 p_a1))
	   (set! ln1 (grsp-matrix-esi 3 p_a1))
	   (set! hn1 (grsp-matrix-esi 4 p_a1))    

	   ;; Create new matrices.
	   (set! res3 (grsp-matrix-create 0 1 (+ hn1 1)))	   
	   (set! res4 (grsp-matrix-cpy p_a1))

	   (while (equal? b1 #t)

		  ;; Get min rows.
		  (set! res2 (grsp-matrix-row-minmax p_s1 res4 p_j1))
		  (set! n2 (array-ref res2 0 p_j1))

		  ;; Extract the boundaries of the matrix.
		  (set! lm2 (grsp-matrix-esi 1 res2))
		  (set! hm2 (grsp-matrix-esi 2 res2))
		  (set! ln2 (grsp-matrix-esi 3 res2))
		  (set! hn2 (grsp-matrix-esi 4 res2))  

		  ;; Extract the boundaries of the matrix.
		  (set! lm3 (grsp-matrix-esi 1 res3))
		  (set! hm3 (grsp-matrix-esi 2 res3))
		  (set! ln3 (grsp-matrix-esi 3 res3))
		  (set! hn3 (grsp-matrix-esi 4 res3)) 
		  
		  ;; Add a similar number of rows to res3 that exist in res2.
		  (set! res3 (grsp-matrix-subexp res3 (+ (- hm2 lm2) 1) 0))

		  ;; Copy the info from res2 to res3.
		  (set! res3 (grsp-matrix-subrep res3 res2 (+ hm3 1) ln3))

		  ;; Delete.
		  ;;(set! res4 (grsp-matrix-row-delete "#=" res4 p_j1 n2))
		  (set! res4 (grsp-matrix-subdel "#Delr" res4 0))

		  ;; Find out if res4 still has elements.
		  (set! hm4 (grsp-matrix-esi 2 res4))
		  (cond ((< hm4 0)
			 (set! b1 #f))))

	   (set! res1 (grsp-matrix-subdel "#Delr" res3 0)))
	  ((equal? p_s1 "#des")
	   (set! res1 (grsp-matrix-row-sort "#asc" p_a1 p_j1))
	   (set! res1 (grsp-matrix-row-invert res1))))
    
    res1))


;;;; grsp-matrix-row-invert - Inverts the order of all rows in p_a1, so that
;; if p_a1 has rows [0, m] row 0 becomes row m, row 1 becomes row m -1 ...
;; and row m becomes row 0.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_a1: matrix.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-row-invert p_a1)
  (let ((res1 0)
	(res2 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(i2 0)
	(i3 0))

    ;; Extract the boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Create seed matrix.
    (set! res1 (grsp-matrix-create 0 1 (+ hn1 1))) 
    
    (set! i1 lm1)
    (set! i2 hm1)
    (set! i3 1)
    (while (<= i1 hm1)

	   ;; Get row from input matrix (read in reverse row order).
	   (set! res2 (grsp-matrix-subcpy p_a1 i2 i2 ln1 hn1))

	   ;; Expand seed matrix by one row.
	   (set! res1 (grsp-matrix-subexp res1 1 0))

	   ;; Copy extracted row to expanded row in seed matrix.
	   (set! res1 (grsp-matrix-subrep res1 res2 i3 ln1))

	   ;; Update counters.
	   (set! i1 (+ i1 1))
	   (set! i2 (- i2 1))
	   (set! i3 (+ i3 1)))

    ;; Compose results.
    (set! res1 (grsp-matrix-subdel "#Delr" res1 0))

    res1))


;;;; grsp-matrix-commit - Given that p_a2 is a processed submatrix of p_a1,
;; this function copies the data of p_a2 to p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_a2: matrix.
;; - p_j1: column number that corresponds to the shared primary key.
;;
;; Notes:
;; - p_a1 and p_a2 should share a common id or primary key contained in a
;;   column that will be used to identify each row of p_a1 that would be
;;   updated with the data of p_a2.
;; - This function might not work well if during the processing of p_a2
;;   the width (number of columns) has been changed.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-commit p_a1 p_a2 p_j1)
  (let ((res1 p_a1)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(n1 0)
	(n2 0)
	(i1 0)
	(i2 0)
	(j2 0))

    ;; Extract the boundaries of the first matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Extract the boundaries of the second matrix.
    (set! lm2 (grsp-matrix-esi 1 p_a2))
    (set! hm2 (grsp-matrix-esi 2 p_a2))
    (set! ln2 (grsp-matrix-esi 3 p_a2))
    (set! hn2 (grsp-matrix-esi 4 p_a2))    

    ;; Cycle p_a2.
    (set! i2 lm2)
    (while (<= i2 hm2);;

	   ;; Get the key for each row of p_a2.
	   (set! n2 (array-ref p_a2 i2 p_j1))
	   
	   ;; Cycle p_a1.
	   (set! i1 lm1)
	   (while (<= i1 hm1);;

		  ;; Get the key for each row of p_a1.
		  (set! n1 (array-ref p_a1 i1 p_j1))

		  ;; If the keys for the current p_a2 and p_a1 rows are the same
		  ;; then copy data from p_a2 into p_a1.
		  (cond ((equal? n1 n2)
			 (set! j2 ln2)
			 (while (<= j2 hn2);;
				(array-set! p_a1 (array-ref p_a2 i2 j2) i1 j2)
				(set! j2 (+ j2 1)))))			 

		  (set! i1 (+ i1 1)))	   
	   (set! i2 (+ i2 1)))

    ;; Compose results.    
    (set! res1 p_a1)
    
    res1))


;;;; grsp-matrix-row-selectn - Selects from p_a1 only the rows specified in list
;; p_l1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_l1: list containing row numbers.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-row-selectn p_a1 p_l1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(hm1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(lm3 0)
	(hm3 0)
	(ln3 0)
	(hn3 0)	
	(j2 0)
	(i3 0)
	(j3 0))

    ;; Create matrices.
    (set! res2 (grsp-l2m p_l1))
    (set! res3 (grsp-matrix-cpy p_a1))

    ;; Extract the boundaries of the res2 matrix.
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))
    
    ;; Extract the boundaries of the res3 matrix.
    (set! lm3 (grsp-matrix-esi 1 res3))
    (set! hm3 (grsp-matrix-esi 2 res3))
    (set! ln3 (grsp-matrix-esi 3 res3))
    (set! hn3 (grsp-matrix-esi 4 res3))

    ;; Seed matrix.
    (set! res1 (grsp-matrix-create 0 1 (+ (- hn3 ln3) 1)))
    
    (set! j2 ln2)
    (while (<= j2 hn2)

	   ;; Look for records stated in each res2 element in res3.
	   (set! i3 lm3)
	   (while (<= i3 hm3)

		  ;; If row is the correct one, then copy.
		  (cond ((equal? i3 (array-ref res2 0 j2))
			 
			 ;; Expand seed matrix by one row.
			 (set! res1 (grsp-matrix-subexp res1 1 0))

			 ;; Extract boundaries of the res1 matrix.
			 (set! hm1 (grsp-matrix-esi 2 res1))
			 
			 ;; Copy row from res3 to res1.
			 (set! j3 ln3)
			 (while (<= j3 hn3)
				(array-set! res1 (array-ref res3 i3 j3) hm1 j3)
				(set! j3 (+ j3 1)))))

		  (set! i3 (+ i3 1)))
	   
	   (set! j2 (+ j2 1)))

    ;; Compose results.
    (set! res1 (grsp-matrix-subdel "#Delr" res1 0))
    
    res1))


;;;; grsp-matrix-col-selectn - Selects from p_a1 only the columns specified in
;; list p_l1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_l1: list containing col numbers.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-col-selectn p_a1 p_l1)
  (let ((res1 0)
	(i1 0))

    ;; Create matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Operate with transposed matix.
    (set! res1 (grsp-matrix-transpose res1))
    (set! res1 (grsp-matrix-row-selectn res1 p_l1))

    ;; Transpose three times more to return to original state.
    (set! res1 (grsp-matrix-transposer res1 3))
    
    res1))


;;;; grsp-matrix-col-select - Selects columns from matrix p_a1 for which
;; condition p_s1 is met with regards to value p_n1 in row p_i1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_s1: string.
;;   - "#<".
;;   - "#>".
;;   - "#>=".
;;   - "#<=".
;;   - "#!=".
;;   - "#=".
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: number.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-col-select p_s1 p_a1 p_j1 p_n1)
  (let ((res1 0))

    ;; Create matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Operate with transpoed matrix.
    (set! res1 (grsp-matrix-transpose res1))
    (set! res1 (grsp-matrix-row-select p_s1 p_a1 p_j1 p_n1)) ;;col

    ;; Transpose three times more to return to original state.
    (set! res1 (grsp-matrix-transposer res1 3))
    
    res1))


;;;; grsp-matrix-njoin - Natural join of p_a1 with key p_n1 and p_a2 with key
;; p_n2.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; p_a1: matrix.
;; p_n1: column number, key of p_a1.
;; p_a2: matrix.
;; p_a2: column number, key of p_a2.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-njoin p_a1 p_n1 p_a2 p_n2)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)	
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(lm3 0)
	(hm3 0)
	(ln3 0)
	(hn3 0)
	(lm4 0)
	(hm4 0)
	(ln4 0)
	(hn4 0)	
	(i1 0)
	(j1 0)
	(j2 0)
	(j3 0)
	(i4 0)
	(n4 0))

    ;; Create matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))    

    ;; Extract the boundaries of the res1 matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    ;; Extract the boundaries of the res2 matrix.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))   

    ;; Number of columns of JOINed matrix.
    (set! j3 (+ (+ (- hn1 ln1) 1) (+ 1 (- hn2 ln2))))
    
    ;; Create seed of joined matrix.
    (set! res3 (grsp-matrix-create 0 1 j3))

    ;; Cycle over res1, read each key and for each instance copy the rows
    ;; for the current res1 and all the records of res3 that have the same key.
    (set! i1 lm1)
    (while (<= i1 hm1)

	   ;; Read res1 key column for each row.
	   (set! res4 (grsp-matrix-row-select "#=" res2 p_n2 (array-ref res1 i1 p_n1)))

	   ;; Extract the boundaries of the res4 matrix, which contains the
	   ;; rows SELECTed from res2.
	   (set! lm4 (grsp-matrix-esi 1 res4))
	   (set! hm4 (grsp-matrix-esi 2 res4))
	   (set! ln4 (grsp-matrix-esi 3 res4))
	   (set! hn4 (grsp-matrix-esi 4 res4))		 

	   ;; Add rows to res3.
	   (set! i4 lm4)
	   (while (<= i4 hm4)

		  ;; Expand seed matrix by one row.
		  (set! res3 (grsp-matrix-subexp res3 1 0))

		  ;; Extract the boundaries of the res3 matrix.
		  (set! lm3 (grsp-matrix-esi 1 res3))
		  (set! hm3 (grsp-matrix-esi 2 res3))
		  (set! ln3 (grsp-matrix-esi 3 res3))
		  (set! hn3 (grsp-matrix-esi 4 res3))		  
		  
		  ;; Add the res1 component of the row.
		  (set! j1 ln1)
		  (while (<= j1 hn1)
			 (array-set! res3 (array-ref res1 i1 j1) hm3 j1)
			 
			 (set! j1 (+ j1 1)))

		  ;; Add the res2 component of the row.
		  (set! j2 ln2)
		  (while (<= j2 hn2)
			 (array-set! res3 (array-ref res2 i1 j2) hm3 (+ j1 j2))
			 
			 (set! j2 (+ j2 1)))		  
		  
		  (set! i4 (+ i4 1)))
	   
	   ;; Increment main row cycle counter.
	   (set! i1 (+ i1 1)))

    ;; Delete the column in res3 that corresponds to p_n2 in p_a1.
    (set! res3 (grsp-matrix-subdel "#Delc" res3 (+ j1 p_n2)))
    
    ;; Compose results.
    (set! res3 (grsp-matrix-subdel "#Delr" res3 0))
    
    res3))


;;;; grsp-matrix-sjoin - Semi join of p_a1 with key p_n1 and p_a2 with key
;; p_n2.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; p_a1: matrix.
;; p_n1: column number, key of p_a1.
;; p_a2: matrix.
;; p_a2: column number, key of p_a2.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-sjoin p_a1 p_n1 p_a2 p_n2)
  (let ((res1 0)
	(res2 0)
	(res3 0)	
	(lm2 0)
	(hm2 0)
	(hn2 0))

    ;; Create matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2)) 
	
    ;; Extract the boundaries of the res2 matrix.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))

    (set! hn2 (grsp-matrix-esi 4 res2))

    ;; Trim res2.
    (set! res2 (grsp-matrix-subcpy res2 lm2 hm2 p_n2 p_n2))
    (set! hn2 (grsp-matrix-esi 4 res2))	   

    ;; Calculate the natural join.
    (set! res3 (grsp-matrix-njoin res1 p_n1 res2 hn2))
    
    res3))


;;;; grsp-matrix-ajoin - Antijoin. Produces a matrix of elements of p_a1 that
;; cannot be njoined to p_a2 given p_n1 and p_n2.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; p_a1: matrix.
;; p_n1: column number, key of p_a1.
;; p_a2: matrix.
;; p_n2: column number, key of p_a2.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-ajoin p_a1 p_n1 p_a2 p_n2)
  (let ((res1 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)	
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(lm3 0)
	(hm3 0)
	(ln3 0)
	(hn3 0)
	(i1 0)
	(j1 0)
	(i2 0)
	(n1 0)
	(n2 0))

    ;; Extract the boundaries of the p_a1 matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1)) 
    
    ;; Extract the boundaries of the p_a2 matrix.
    (set! lm2 (grsp-matrix-esi 1 p_a2))
    (set! hm2 (grsp-matrix-esi 2 p_a2))
    (set! ln2 (grsp-matrix-esi 3 p_a2))
    (set! hn2 (grsp-matrix-esi 4 p_a2)) 

    ;; Seed res3.
    (set! res3 (grsp-matrix-create 0 1 (+ (- hn1 ln1) 1)))
    (set! res5 (grsp-matrix-subcpy p_a2 lm2 hm2 p_n2 p_n2))

    ;; Extract boundaries of the res3 matrix.
    (set! lm3 (grsp-matrix-esi 1 res3))
    (set! hm3 (grsp-matrix-esi 2 res3))
    (set! ln3 (grsp-matrix-esi 3 res3))
    (set! hn3 (grsp-matrix-esi 4 res3)) 
    
    ;; Compare p_a1 and p_a2 to find out which tuples from p_a1 were not joined
    ;; into p_a2.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! n1 (array-ref p_a1 i1 p_n1))
	   (set! n2 (grsp-matrix-total-element res5 n1))
	   
	   ;; If n2 = 0 then the tuple cannot be joined.
	   (cond ((equal? n2 0)
		  
		  ;; Expand seed matrix by one row.
		  (set! res3 (grsp-matrix-subexp res3 1 0))

		  ;; Extract boundaries of the res3 matrix.
		  (set! hm3 (grsp-matrix-esi 2 res3))	  

		  ;; Add the row to the results matrix
		  (set! res4 (grsp-matrix-subcpy p_a1 i1 i1 ln1 hn1))
		  (set! res3 (grsp-matrix-subrep res3 res4 hm3 ln3))))
		  
	   (set! i1 (+ i1 1)))

    ;; Compose results.
    (set! res1 (grsp-matrix-subdel "#Delr" res3 0))
    
    res1))


;;;; grsp-matrix-supp - Given 1 x n matrix p_a1, it returns a 1 x (n - p)
;; vector that contains one instance per each element value contained in p_a1.
;; That is, it elimitates repeated instances of the elements of p_a1 and
;; returns its domain subset.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; p_a1: matrix ( 1 x n), (-inf.0, +inf.0).
;;
;; Sources:
;; - [17].
;;
(define (grsp-matrix-supp p_a1)
  (let ((res1 0)
	(ln2 0)
	(hn2 0)	
	(j1 0)
	(j2 0)
	(n1 0)
	(n2 0)
	(n3 0)
	(n4 0))

    ;; Create matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Extract the boundaries of the res2 matrix.
    (set! ln2 (grsp-matrix-esi 3 res1))
    (set! hn2 (grsp-matrix-esi 4 res1))
    (set! n3 -inf.0)
    (set! n4 +inf.0)
    
    (set! j1 ln2)
    (while (<= j1 hn2)

	   ;; Read each element.
	   (set! n1 (array-ref res1 0 j1))
	   (set! n2 0)
	   (set! j2 ln2)

	   ;; Find new ocurrences of n1 in the matrix.
	   (while (<= j2 hn2)
		  (cond ((= n1 (array-ref res1 0 j2))
			 (set! n2 (+ n2 1))
			 (cond ((> n2 1)
				(array-set! res1 n3 0 j2)))))
		  (set! j2 (+ j2 1)))			       
	   
	   (set! j1 (+ j1 1)))

    ;; Compose results.
    (set! res1 (grsp-matrix-row-select "#>" (grsp-matrix-transpose res1) 0 n3))
    (set! res1 (grsp-matrix-row-select "#<" res1 0 n4))
    (set! res1 (grsp-matrix-transposer res1 3))

    res1))


;;;; grsp-matrix-row-div - Relational division.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; p_a1: matrix.
;; p_n1: column number, key of p_a1.
;; p_a2: matrix.
;; p_n2: column number, key of p_a2.
;;
;; Sources:
;; - [16].
;;
;; Notes:
;; - Still needs some checking of the results.
;;
(define (grsp-matrix-row-div p_a1 p_n1 p_a2 p_n2)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)	
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(hm5 0)
	(i1 0)
	(i2 0)	
	(n1 0)
	(t3 0))

    ;; Create matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))    
    
    ;; Extract the boundaries of the res1 matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1)) 
    
    ;; Extract the boundaries of the res2 matrix.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))

    ;; Take the index column of res2.
    (set! res3 (grsp-matrix-subcpy res2 lm2 hm2 p_n2 p_n2))
    (set! t3 (grsp-matrix-total-elements res3))    

    ;; Create seed of results matrix.
    (set! res5 (grsp-matrix-create 0 1 (+ (- hn1 ln1) 1)))
    
    ;; Repeat for each row of p_a1, to see if it can be njoined with
    ;; every row of p_a2.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   
	   ;; Check if the current row in res1 can be njoined with all rows in
	   ;; res2.
	   (set! n1 (array-ref res1 i1 p_n1))
	   (cond ((= t3 (grsp-matrix-total-element res3 n1))

		  ;; Expand seed matrix by one row.
		  (set! res5 (grsp-matrix-subexp res5 1 0))
		  (set! hm5 (grsp-matrix-esi 2 res5))
		  
		  ;; This row can be njoined.
		  (set! res4 (grsp-matrix-subcpy res1 i1 i1 ln1 hn1))
		  (set! res5 (grsp-matrix-subrep res5 res4 hm5 ln1))))
	   
	   (set! i1 (+ i1 1)))

    ;; Compose results.
    (set! res5 (grsp-matrix-subdel "#Delr" res5 0))
    
    res5))


;;;; grsp-matrix-row-update - Updates all rows setting value p_n2 in column p_j2
;; from p_a1 where column p_j1 has a p_s1 relationship with p_n1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_s1: string.
;;   - "#<".
;;   - "#>".
;;   - "#>=".
;;   - "#<=".
;;   - "#!=".
;;   - "#=".
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: number.
;; - p_j2: column number.
;; - p_n2: number.
;;
;; Notes:
;; - You cannot make changes to the primary key column using this update
;;   function.
;;
(define (grsp-matrix-row-update p_s1 p_a1 p_j1 p_n1 p_j2 p_n2)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)	
	(i2 0))

    ;; Create matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; First select those rows where conditions are met.
    (set! res2 (grsp-matrix-row-select p_s1 res1 p_j1 p_n1))

    ;; Extract boundaries of res2.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))     

    ;; Cycle and update.
    (set! i2 lm2)
    (while (<= i2 hm2)
	   (array-set! res2 p_n2 i2 p_j2)
	   (set! i2 (+ i2 1)))
    
    ;; Compose results.
    (set! res3 (grsp-matrix-cpy res2))
    (set! res1 (grsp-matrix-commit res1 res3 p_j1))
    
    res1))


;; grsp-matrix-te1 - Total elements of a row or column based on the lower and
;; higher coordinate values.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_lo: lower (lm or ln).
;; - p_hi: higher (hm or hn).
;;  
(define (grsp-matrix-te1 p_lo p_hi)
  (let ((res1 0))

    (set! res1 (+ (- p_hi p_lo) 1))

    res1))


;; grsp-matrix-te2 - Total elements of a row or column. Returns
;; a 2 x 1 matrix containing the number of rows and columns of p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_a1: matrix.
;;  
(define (grsp-matrix-te2 p_a1)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))	

    ;; Extract boundaries of the argument matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    (set! res1 (grsp-matrix-create 0 1 2))
    (array-set! res1 (grsp-matrix-te1 lm1 hm1) 0 0)
    (array-set! res1 (grsp-matrix-te1 ln1 hn1) 0 1)   
    
    res1))


;; grsp-matrix-append - Appends all the rows of p_a2 below the rows of p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_a2: matrix.
;;  
(define (grsp-matrix-row-append p_a1 p_a2)
  (let ((res1 0)
	(res2 0)
	(hm1 0)
	(ln1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0))

    ;; Create matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))

    ;; Extract boundaries of the first matrix.
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))

    ;; Extract boundaries of the second matrix.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))    
    
    ;; Expand res1.
    (set! res1 (grsp-matrix-subexp res1 (grsp-matrix-te1 lm2 hm2) 0))

    ;; Append res2 to res1.
    (set! res1 (grsp-matrix-subrep res1 res2 (+ hm1 1) ln1))
    
    res1))


;;;; grsp-matrix-lojoin - Left outer join.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; p_a1: matrix.
;; p_j1: column number, key of p_a1.
;; p_a2: matrix.
;; p_j2: column number, key of p_a2.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-lojoin p_a1 p_j1 p_a2 p_j2)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(lm3 0)
	(hm3 0)
	(ln3 0)
	(hn3 0)
	(lm4 0)
	(hm4 0)
	(ln4 0)
	(hn4 0)
	(n3 0)
	(n4 0))

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))

    ;; Perform a natural join and an anti join.
    (set! res3 (grsp-matrix-njoin res1 p_j1 res2 p_j2))
    (set! res4 (grsp-matrix-ajoin res1 p_j1 res2 p_j2))

    ;; Extract matrix boundaries.
    (set! lm3 (grsp-matrix-esi 1 res3))
    (set! hm3 (grsp-matrix-esi 2 res3))    
    (set! ln3 (grsp-matrix-esi 3 res3))
    (set! hn3 (grsp-matrix-esi 4 res3))
    
    ;; Extract matrix boundaries.
    (set! lm4 (grsp-matrix-esi 1 res4))
    (set! hm4 (grsp-matrix-esi 2 res4))    
    (set! ln4 (grsp-matrix-esi 3 res4))
    (set! hn4 (grsp-matrix-esi 4 res4)) 

    ;; We need to find if both tables are of equal width (number of columns).
    (set! n3 (grsp-matrix-te1 ln3 hn3))
    (set! n4 (grsp-matrix-te1 ln4 hn4))

    ;; Add columns to one of the matrices, if necessary.
    (cond ((> n3 n4)
	   (set! res4 (grsp-matrix-subexp res4 lm4 (- n3 n4)))
	   (set! res4 (grsp-matrix-subrepv res4 (grsp-nan) lm4 hm4 (+ hn4 1) (grsp-matrix-esi 4 res4))))
	  ((< n3 n4)
	   (set! res3 (grsp-matrix-subexp res3 lm3 (- n4 n3)))
	   (set! res4 (grsp-matrix-subrepv res4 (grsp-nan) lm3 hn3 (+ hn3 1) (grsp-matrix-esi 4 res3)))))

    ;; Compose results.
    (set! res5 (grsp-matrix-row-append res3 res4))

    res5))


;;;; grsp-matrix-subrepv - Replaces a submatrix or section of matrix p_a1,
;; defined  by coordinates (p_m1, p_n1) and (p_m2, p_n2) with value p_v1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;; 
;; Arguments:
;; - p_a1: matrix.
;; - p_v1: value.
;; - p_m1: row coordinate of p_a1.
;; - p_m2: row coordinate of p_a1.
;; - p_n1: col coordinate of p_a1.
;; - p_n1: col coordinate of p_a1.
;;
(define (grsp-matrix-subrepv p_a1 p_v1 p_m1 p_m2 p_n1 p_n2)
  (let ((res1 0)	
	(i1 0)
	(j1 0))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Cycle and replace.
    (set! i1 p_m1)
    (while (<= i1 p_m2)
	   (set! j1 p_n1)
	   (while (<= j1 p_n2)
		  (array-set! res1 p_v1 i1 j1)
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))
    
    res1))


;; grsp-matrix-subswap - Swaps the contents of the submatrix defined by
;; coordinates (p_m1, p_n1) for its upper right vertex and  (p_m2, p_n2)
;; as its lowest left vertex with a submatrix with its upper right vertex at
;; (p_m3, p_n3) and the same size and shape as the first submatrix.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;; 
;; Arguments:
;; - p_a1: matrix.
;; - p_m1: row pos 1.
;; - p_n1: col pos 1.
;; - p_m2: row pos 2.
;; - p_n2: col pos 2.
;; - p_m3: row pos 3.
;; - p_n3: col pos 3.
;;
(define (grsp-matrix-subswp p_a1 p_m1 p_n1 p_m2 p_n2 p_m3 p_n3)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(m4 0)
	(n4 0))

    ;; Create matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Calculate number of elements on both dims and lower-right vertex
    ;; coordinates of the second submatrix.
    (set! m4 (- (+ p_m3 (grsp-matrix-te1 p_m1 p_m2)) 1))
    (set! n4 (- (+ p_n3 (grsp-matrix-te1 p_n1 p_n2)) 1))     
    
    ;; Extract.
    (set! res2 (grsp-matrix-subcpy res1 p_m1 p_m2 p_n1 p_n2))
    (set! res3 (grsp-matrix-subcpy res1 p_m3 m4 p_n3 n4))  
    
    ;; Swap.
    (set! res1 (grsp-matrix-subrep res1 res3 p_m1 p_n1))
    (set! res1 (grsp-matrix-subrep res1 res2 p_m3 p_n3))    
    
    res1))


;;;; grsp-matrix-col-total-element - Counts the number of ocurrences of elements
;; in column p_j1 of matrix p_a1 for which relationship p_s1 is fulfilled with
;; regards to p_n1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_s1: string.
;;   - "#<".
;;   - "#>".
;;   - "#>=".
;;   - "#<=".
;;   - "#!=".
;;   - "#=".
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: number.
;;
(define (grsp-matrix-col-total-element p_s1 p_a1 p_j1 p_n1)
  (let ((res1 0)
	(res2 0)
	(n2 0)
	(i1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))

    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1)) 
    
    ;; Extract column p_j1.
    (set! res2 (grsp-matrix-subcpy p_a1 lm1 hm1 p_j1 p_j1))

    ;; Cycle.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! n2 (array-ref res2 i1 p_j1))
	   (cond ((equal? p_s1 "#<")
		  (cond ((< n2 p_n1)
			 (set! res1 (+ res1 1)))))
		 ((equal? p_s1 "#>")
		  (cond ((> n2 p_n1)
			 (set! res1 (+ res1 1)))))
		 ((equal? p_s1 "#<=")
		  (cond ((<= n2 p_n1)
			 (set! res1 (+ res1 1)))))
		 ((equal? p_s1 "#>=")
		  (cond ((>= n2 p_n1)
			 (set! res1 (+ res1 1)))))
		 ((equal? p_s1 "#=")
		  (cond ((= n2 p_n1)
			 (set! res1 (+ res1 1)))))
		 ((equal? p_s1 "#!=")
		  (cond ((equal? (= n2 p_n1) #f)
			 (set! res1 (+ res1 1))))))
	   (set! i1 (+ i1 1)))
    
    res1))

;;;; grsp-matrix-row-deletev - Deletes all rows where value p_n1 is found at any
;; column.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_a1: matrix
;; - p_n1: number.
;;
(define (grsp-matrix-row-deletev p_a1 p_n1)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Extract initial boundaries.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1)) 

    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)

		  ;; Delete row where p_n1 is found at column j1.
		  (set! res1 (grsp-matrix-row-delete "#=" res1 j1 p_n1))

		  ;; Extract current boundaries.
		  (set! lm1 (grsp-matrix-esi 1 res1))
		  (set! hm1 (grsp-matrix-esi 2 res1))		  
		  
		  (set! j1 (+ j1 1)))
	   (set! i1 (+ i1 1)))
		  
    res1))


;;;; grsp-matrix-clear - Deletes all rows from matrix p_a1 where any of the
;; values contained in list p_l1 is found at any column.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_a1: matrix
;; - p_l1: number.
;;
(define (grsp-matrix-clear p_a1 p_l1)
  (let ((res1 0)
	(res2 0)
	(ln2 0)
	(hn2 0)
	(j2 0))

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-l2m p_l1))
    
    ;; Extract initial boundaries.
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))

    ;; Cycle over the list (now matrix) of values to look on every part of p_a1.
    (set! j2 ln2)
    (while (<= j2 hn2)
	   (set! res1 (grsp-matrix-row-deletev res1 (array-ref res2 0 j2)))
	   (set! j2 (+ j2 1)))

    res1))


;;;; grsp-matrix-clearni - Deletes all rows from matrix p_a1 where any of the
;; values contained in list defined by (grsp-naninf) is found at any column.
;;
;; Arguments:
;; - p_a1: matrix
;;
(define (grsp-matrix-clearni p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-clear p_a1 (grsp-naninf)))

    res1))


;;;; grsp-matrix-row-cartesian - Cartesian product of all rows of p_a1 and p_a2.
;; Note that this function combines every row of one matrix with every row of
;; another matrix, and not every element with every other element.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
(define (grsp-matrix-row-cartesian p_a1 p_a2)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(res6 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(lm6 0)
	(hm6 0)
	(ln6 0)
	(hn6 0)
	(tc1 0)
	(tc2 0)
	(i1 0)
	(i2 0))

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))

    ;; Extract initial boundaries.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))     

    ;; Columns in each matrix.
    (set! tc1 (grsp-matrix-te1 ln1 hn1))
    (set! tc2 (grsp-matrix-te1 ln1 hn1))    

    ;; Seed matrix.
    (set! res6 (grsp-matrix-create 0 1 (+ tc1 tc2)))

    (set! lm6 (grsp-matrix-esi 1 res6))
    (set! hm6 (grsp-matrix-esi 2 res6))
    (set! ln6 (grsp-matrix-esi 3 res6))
    (set! hn6 (grsp-matrix-esi 4 res6))     

    ;; cycle over res1 and combine each row of it with each rown of res2 in res3
    (set! i1 lm1)
    (while (<= i1 hm1)

	   ;; Read a row from res1.
	   (set! res3 (grsp-matrix-subcpy res1 i1 i1 ln1 hn1))
	   (set! i2 lm2)

	   ;; Combine the current res1 row with all rows from res2.
	   (while (<= i2 hm2)

		  ;, Get a row from res2.
		  (set! res4 (grsp-matrix-subcpy res2 i2 i2 ln2 hn2))

		  ;; Col append rows from res3 and res4.
		  (set! res5 (grsp-matrix-col-append res3 res4))

		  ;; Add a fresh row to res5 in which to place the col appended
		  ;; rows.
		  (set! res6 (grsp-matrix-subexp res6 1 0))
		  (set! hm6 (grsp-matrix-esi 2 res6))

		  ;; Add the col appended rows.
		  (set! res6 (grsp-matrix-subrep res6 res5 hm6 ln6))

		  ;; Increment counters.
		  (set! i2 (+ i2 1)))
	   (set! i1 (+ i1 1)))

    ;; Compose results.
    (set! res6 (grsp-matrix-subdel "#Delr" res6 0))
    
    res6))
	

;;;; grsp-matrix-col-append - Appends all the columns of p_a2 to the right of
;; p_a1 row by row.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_a2: matrix.
;;  
(define (grsp-matrix-col-append p_a1 p_a2)
  (let ((res1 0)
	(res2 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(tm1 0)
	(tn1 0)
	(tm2 0)
	(tn2 0)
	(am1 0))

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))

    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))  

    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))    

    (set! tm1 (grsp-matrix-te1 lm1 hm1))
    (set! tm2 (grsp-matrix-te1 lm2 hm2))
    (set! tn2 (grsp-matrix-te1 ln2 hn2))
    
    ;; Find out how many rows would have to be added to res1.
    (cond ((< tm1 tm2)
	   (set! am1 (- tm2 tm1))))
    
    ;; Expand res1.
    (set! res1 (grsp-matrix-subexp res1 am1 tn2))
    
    ;; Append res2 to res1.
    (set! res1 (grsp-matrix-subrep res1 res2 lm1 (+ hn1 1)))
    
    res1))


;;;; grsp-matrix-col-find-nth - Finds the p_n1th element in p_s1 order from
;; column p_j1 in matrix p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_s1: string.
;;   - "#asc": ascending order.
;;   - "#des": descending order.
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: element ordinal.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-col-find-nth p_s1 p_a1 p_j1 p_n1)
  (let ((res1 0)
	(res2 0)
	(s1 "#>")
	(s2 "#asc")
	(i1 0)
	(n1 0))

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; We need to sort the matrix since we will later read the first row of
    ;; the selected ones.
    (cond ((equal? p_s1 "#des")
	   (set! s1 "#<")
	   (set! s2 "#des")))

    (set! n1 p_n1)
    (set! res1 (grsp-matrix-row-sort s2 res1 p_j1))

    ;; Perform the selection and then read the value of col p_j1 row 0.
    (set! i1 1)
    (while (<= i1 n1)
	    (cond ((> i1 1)
		   (set! res1 (grsp-matrix-row-select s1 res1 p_j1 res2))))
	    (set! res2 (array-ref res1 0 p_j1))
	    (set! i1 (+ i1 1)))  
    
    res2))


;;;; grsp-mn2ll - Casts m x n matrix p_a1 into a list of m elements which are
;; themselves lists of n elements each.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_a1: matrix.
;;
;; Output:
;; - A list of lists.
;;
(define (grsp-mn2ll p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 '())
	(res4 '())
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))  

    ;; Create lists based on the dimensions of the matrix.
    (set! res3 (make-list (grsp-matrix-te1 ln1 hn1) 0))
    (set! res4 (make-list (grsp-matrix-te1 lm1 hm1) 0))
    
    ;; Cycle over the matrix and copy its elements to the list.
    (set! i1 lm1)
    (while (<= i1 hm1)

	   ;; Read row i1 into res2
	   (set! res2 (grsp-matrix-subcpy res1 i1 i1 ln1 hn1))
	   
	   ;; Convert res2 to list res3.
	   (set! res3 (grsp-m2l res2))
	   
	   ;; Place list res3 into ist ers4.	   
	   (list-set! res4 i1 res3)

	   (set! i1 (+ i1 1)))
    
    res4))


;;;; grsp-matrix-mutation - Produces random mutations in the values of elements 
;; of matrix p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, genetic.
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
;; Sources:
;; - [19][21].
;;
(define (grsp-matrix-mutation p_a1 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2)
  (let ((res1 0)
	(i1 0)
	(j1 0)
	(j2 0)
	(n1 0)
	(n2 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))	

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    ;; Cycle over.
    (set! i1 lm1)
    (while (<= i1 hm1)
	  (set! j1 ln1)
	  (while (<= j1 hn1)

		 ;; If pseudo random number < p_n1, generate a new random number
		 ;; and replace the value of the current matrix element with it.
		 (cond ((equal? (grsp-ifrprnd p_s1 p_u1 p_v1 p_n1) #t)
			(array-set! res1 (grsp-rprnd p_s2 p_u2 p_v2) i1 j1)))
		 
		 (set! j1 (in j1)))
	  (set! i1 (in i1)))
    
    res1))


;;;; grsp-matrix-col-mutation - Produces random mutations in the values of
;; elements of col p_n2 of matrix p_a1. Applies grsp-matrix-mutation to the
;; selected column instead of the whole matrix.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, genetic.
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
;; - p_n2: column to mutate.
;;
;; Sources:
;; - [19][21].
;;
(define (grsp-matrix-col-mutation p_a1 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2 p_n2)
  (let ((res1 0)
	(res2 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))	

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    ;; Extract column to mutate.
    (set! res2 (grsp-matrix-subcpy res1 lm1 hm1 p_n2 p_n2))    

    ;; Mutate res2.
    (set! res2 (grsp-matrix-mutation res2 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2))

    ;; Copy res2 back to res1.
    (set! res1 (grsp-matrix-subrep res1 res2 lm1 p_n2))
    
    res1))


;;;; grsp-matrix-col-lmutation - Produces random mutations in the values of
;; elements of list p_1 of columns of matrix p_a1. Applies grsp-matrix-mutation
;; to the selected columns instead of the whole matrix.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, genetic.
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
;; - p_l1: list of columns to mutate.
;;
;; Sources:
;; - [19][21].
;;
(define (grsp-matrix-col-lmutation p_a1 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2 p_l1)
  (let ((res1 0)
	;;(j1 1)
	(j1 0)
	(j2 0)
	(hn1 0)
	(l1 '()))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    (set! l1 p_l1)
    (set! hn1 (length l1))
    (while (< j1 hn1)
	   
	   (set! j2 (list-ref l1 j1))
	   (set! res1 (grsp-matrix-col-mutation res1 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2 j2))

	   (set! j1 (in j1)))

    res1))


;;;; grsp-matrix-crossover - Performs a crossover of columns defined by the
;; intervals [p_ln1, p_hn1] and [p_ln2, p_hn2] between matrices p_a1 and p_a2.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, genetic.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_ln1: lower column number of the interval to swap (p_a1).
;; - p_hn1: higher column number of the interval to swap (p_a1).
;; - p_a2: matrix.
;; - p_ln2: lower column number of the interval to swap (p_a1).
;; - p_hn2: higher column number of the interval to swap (p_a1).
;;
;; Sources:
;; - [19][20].
;;
;; Notes:
;; - Matrices should have the same number of rows and columns.
;; - Intervals [p_ln1, p_hn1] and [p_ln2, p_hn2] may not have the same ordinals
;;   (indexes or col numbers) but must have the same number of columns.
;;
;; Output
;; - A matrix containing the children obtained as a result of the swap.
;;
(define (grsp-matrix-crossover p_a1 p_ln1 p_hn1 p_a2 p_ln2 p_hn2)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(res6 0)
	(res7 0)
	(b1 #f)
	(b2 #f)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0))	

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))    

    ;; Only perform this operation if matrices have the same dimensionality.
    (cond ((equal? (grsp-matrix-same-dims p_a1 p_a2) #t)
	   (set! b1 #t)))

    ;; Only perform this operation if the column intervals are equal.
    (cond((= (grsp-matrix-te1 ln1 hn1) (grsp-matrix-te1 ln2 hn2))
	  (set! b2 #t)))
    
    ;; If conditions b1 and b2 are met.
    (cond ((equal? (and (equal? b1 #t) (equal? b2 #t)))
	   ;; Extract boundaries.
	   (set! lm1 (grsp-matrix-esi 1 res1))
	   (set! hm1 (grsp-matrix-esi 2 res1))
	   (set! ln1 (grsp-matrix-esi 3 res1))
	   (set! hn1 (grsp-matrix-esi 4 res1))

	   (set! lm2 (grsp-matrix-esi 1 res2))
	   (set! hm2 (grsp-matrix-esi 2 res2))
	   (set! ln2 (grsp-matrix-esi 3 res2))
	   (set! hn2 (grsp-matrix-esi 4 res2))    

	   ;; Create empty offspring matrices.
	   (set! res3 res1)
	   (set! res4 res2)

	   ;; Extract sub matriesto swap.
	   (set! res5 (grsp-matrix-subcpy res3 lm1 hm1 p_ln1 p_hn1))
	   (set! res6 (grsp-matrix-subcpy res4 lm2 hm2 p_ln2 p_hn2))

	   ;; Swap.
	   (set! res3 (grsp-matrix-subrep res3 res6 lm1 p_ln1))
	   (set! res4 (grsp-matrix-subrep res4 res5 lm1 p_ln2))))
   
    ;; Compose results.
    (set! res7 (grsp-matrix-row-append res3 res4))
    
    res7))


;;;; grsp-matrix-crossover-rprnd - Randomizes the application of
;; grsp-matrix-crossover. In some cases it might be useful to use the 
;; crossover function in an aleatory fashion, while in others it might not.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, genetic.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_ln1: lower column number of the interval to swap (p_a1).
;; - p_hn1: higher column number of the interval to swap (p_a1).
;; - p_a2: matrix.
;; - p_ln2: lower column number of the interval to swap (p_a1).
;; - p_hn2: higher column number of the interval to swap (p_a1).
;; - p_n1: crossover rate, [0, 1].
;; - p_s1: type of distribution.
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;; - p_u1: mean for crossover rate.
;; - p_v1: standard deviation for crossover rate.
;;
;; Sources:
;; - [19][20].
;;
;; Notes:
;; - See grsp-matrix-crossover for further details.
;;
(define (grsp-matrix-crossover-rprnd p_a1 p_ln1 p_hn1 p_a2 p_ln2 p_hn2 p_n1 p_s1 p_u1 p_v1)
  (let ((res1 0))

    (cond ((equal? (grsp-ifrprnd p_s1 p_u1 p_v1 p_n1) #t)
	   (set! res1 (grsp-matrix-crossover p_a1 p_ln1 p_hn1 p_a2 p_ln2 p_hn2))))
    
    res1))


;;;; grsp-matrix-same_dims - Checks if p_a1 and p_a2 have the same number of rows
;; and columns.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
;; Output:
;; - Returns #t if both matrices have the same number of rows and columns; #f
;;   otherwise.
;;
(define (grsp-matrix-same-dims p_a1 p_a2)
  (let ((res1 #f)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0))

    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    (set! lm2 (grsp-matrix-esi 1 p_a2))
    (set! hm2 (grsp-matrix-esi 2 p_a2))
    (set! ln2 (grsp-matrix-esi 3 p_a2))
    (set! hn2 (grsp-matrix-esi 4 p_a2)) 

    ;; Compare the size of both matrices.
    (cond ((= lm1 lm2)
	   (cond ((= hm1 hm2)
		  (cond ((= ln1 ln2)
			 (cond ((= hn1 hn2)
				(set! res1 #t)))))))))
    res1))


;;;; grsp-matrix-fitness-rprnd - Basic fitness function based on pseudo - random
;; numbers.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, genetic.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_m1: row.
;; - p_n1: col.
;; - p_n2: fitness rate, [0, 1].
;; - p_s1: type of distribution.
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;; - p_u1: mean for fitness rate.
;; - p_v1: standard deviation for fitness rate.
;;
;; Notes:
;; - This is justa convenience fitness function. You may want to create your
;;   own for your specific task.
;;
(define (grsp-matrix-fitness-rprnd p_a1 p_m1 p_n1 p_n2 p_s1 p_u1 p_v1)
  (let ((res1 0))

    (array-set! p_a1 (* p_n2 (grsp-rprnd p_s1 p_u1 p_v1)) p_m1 p_n1)
    (set! res1 p_a1)

    res1))


;;;; grsp-matrix-selectg - Genetic selection.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, genetic.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_s2: type of distribution for individual selection.
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;; - p_u2: mean for individual selection.
;; - p_v2: standard deviation for individual selection.
;; - p_j1: column representing the fitness value.
;; - p_j2: column representing the normalized fitness value.
;; - p_j3: column representing the accumulated normalized fitness value.
;;
;; Notes:
;; - You should perform operations such as mutation and fitness calculation on
;;   your dataset before using this function.
;;
;; Output:
;; - A subset of selected individuals (rows) from p_a1.
;;
;; Sources:
;; - [22].
;;
(define (grsp-matrix-selectg p_a1 p_s2 p_u2 p_v2 p_j1 p_j2 p_j3)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(i1 0)
	(j2 0)
	(r1 0))

    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))

    ;; Normalize fitness values (p_j2) and accumulated normalized fitness
    ;; values (p_j3).
    (set! j2 (grsp-matrix-opio "#+c" p_a1 p_j1))
    (set! i1 lm1)
    (while (<= i1 hm1)

	   (array-set! p_a1 (/ (array-ref p_a1 i1 p_j1) j2) i1 p_j2)
	   (array-set! p_a1 (+ (array-ref p_a1 i1 p_j2)
			       (array-ref p_a1 i1 p_j3)) i1 p_j3)
	   
	   (set! i1 (in i1)))    

    ;; Generate random number R.
    (set! r1 (grsp-rprnd p_s2 p_u2 p_v2))

    ;; Select the first individal that meets the condition.
    (set! res1 (grsp-matrix-row-select "#>=" p_a1 p_j3 r1))

    ;; Purge the original matrix.
    (set! p_a1 (grsp-matrix-row-delete "#>=" p_a1 p_j3 r1))

    res1))


;;;; grsp-matrix-keyon - On row or column p_n1 of matrix p_a1, as defined by
;; p_s1, the function creates a unique key starting on value p_n2 and with
;; incremental step p_n3.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_s1: string
;;   - "#row" will use row p_n1 as index.
;;   - "#col" will use column _n1 as index.
;; - p_a1: matrix.
;; - p_n1: number, will represent a row or column depending on p_s1.
;; - p_n2: initial value for key.
;; - p_n3: incremental step.
;;
;; Notes:
;; - This function will overwrite anything on row or column p_n1.
;; - Do not use with set!
;; - Interstingly, you can use these keys to unequivocally identify anything; you
;;   can, for example, set a column wit unique identifiers within a matrix to
;;   point to specific kinds of files. That is, if you set column n as containing
;;   keys, each key can identify a txt or pdf file, for example, which is pointed
;;   from the matrix.
;;
(define (grsp-matrix-keyon p_s1 p_a1 p_n1 p_n2 p_n3)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(i2 0)
	(h1 0)
	(b1 #f))

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    (set! i2 p_n2)
    (cond ((equal? p_s1 "#col")
	   (set! b1 #t)
	   (set! i1 lm1)
	   (set! h1 hm1))
	  ((equal? p_s1 "#row")
	   (set! b1 #t)
	   (set! i1 ln1)
	   (set! h1 hn1)))

    (cond ((equal? b1 #t)
	   (while (<= i1 h1)
		  
		  (cond ((equal? p_s1 "#row")
			 (set! res1 (array-set! p_a1 i2 p_n1 i1)))
			((equal? p_s1 "#col")
			 (set! res1 (array-set! p_a1 i2 i1 p_n1))))

		  (set! i2 (+ i2 p_n3))
		  (set! i1 (in i1)))))
    
    res1))


;;;; grsp-matrix-col-aupdate - Updates all elements of column p_n1 of matrix
;; p_a1, setting value p_n2 in them.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_n1: column number.
;; - p_n2: value to set on p_n1.
;;
(define (grsp-matrix-col-aupdate p_a1 p_n1 p_n2)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(i1 0))

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))

    (while (<= i1 hm1)
	   
	   (array-set! res1 p_n2 i1 p_n1)

	   (set! i1 (in i1)))
    
    res1))


;;;; grsp-matrix-row-selectc - Returns a list containing the result of a
;; grsp-matrix-row-select operation as well as the complement of it in two
;; matrices.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors, relational.
;;
;; Arguments:
;; - p_s1: string.
;;   - "#<".
;;   - "#>".
;;   - "#>=".
;;   - "#<=".
;;   - "#!=".
;;   - "#=".
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: number.
;;
;; Sources:
;; - [16].
;;
(define (grsp-matrix-row-selectc p_s1 p_a1 p_j1 p_n1)
  (let ((res1 '())
	(s2 "")
	(res2 0)
	(res3 0))

    ;; Find set.
    (set! res2 (grsp-matrix-row-select p_s1 p_a1 p_j1 p_n1))

    ;; Establish complementary operation.
    (cond ((equal? p_s1 "#<")
	   (set! s2 "#>="))
	  ((equal? p_s1 "#>")
	   (set! s2 "#>="))	  
	  ((equal? p_s1 "#>=")
	   (set! s2 "#<"))	   
	  ((equal? p_s1 "#<=")
	   (set! s2 "#>"))
	  ((equal? p_s1 "#!=")
	   (set! s2 "#="))
	  ((equal? p_s1 "#=")
	   (set! s2 "#!=")))	  

    ;; Find the complementary set.
    (set! res3 (grsp-matrix-row-select s2 p_a1 p_j1 p_n1))

    ;; Build results.
    (set! res1 (list res2 res3))
    
  res1))


;;;; grsp-matrix-is-empty - Returns #t if the matrix has no elements; #f
;; otherwise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-is-empty p_a1)
  (let ((res1 #t))

    (cond ((> (grsp-matrix-total-elements p_a1) 0)
	   (set! res1 #t)))

    res1))


;;;; grsp-matrix-is-multiset - Returns #t if the matrix has repeated elements; #f
;; otherwise.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
;; Sources:
;; - [24].
;;
(define (grsp-matrix-is-multiset p_a1)
  (let ((res1 0)
	(res2 #f)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(n1 0)
	(n2 0)
	(b1 #f))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))	

    ;; Cycle the matrix and find the first (set) element that has
    ;; multiplicity.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  (set! n2 (array-ref res1 i1 j1))
		  (set! n1 (grsp-matrix-total-element res1 n2))
		  (cond ((> n1 1)
			 (set! b1 #t)
			 (set! i1 hm1)
			 (set! j1 hn1)))
		  (set! j1 (in j1)))
	   (set! i1 (in i1)))

    ;; Compose result.
    (set! res2 b1)

    res2))
    

;;;; grsp-matrix-argtype - Finds the type of each element of matrix p_a1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
;; Output:
;; A matrix of the same dimensions and shape as p_a1 but containing the type of
;; each one of its elements according to the folloing representation:
;; - 0: undefined.
;; - 1: list.
;; - 2: string.
;; - 3: array.
;; - 4: boolean.
;; - 5: char.
;; - 6: integer.
;; - 7: real.
;; - 8: complex.
;; - 9: inf.
;; - 10: nan.
;;
;; Sources:
;; - [grsp0.4][grsp0.5].
;;
(define (grsp-matrix-argtype p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(n1 0)
	(m1 0)
	(n2 0)
	(i1 0)
	(j1 0))
	
    ;; Create safety matrix. 
    (set! res2 (grsp-matrix-cpy p_a1))
    (set! res1 res2)
    
    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 res2))
    (set! hm1 (grsp-matrix-esi 2 res2))
    (set! ln1 (grsp-matrix-esi 3 res2))
    (set! hn1 (grsp-matrix-esi 4 res2))		

    (set! i1 lm1)
    (while (<= i1 hm1)

	   (set! j1 ln1)
	   (while (<= j1 hn1)

		  (cond ((list? (array-ref res2 i1 j1))
			 (set! res3 1))
			((string? (array-ref res2 i1 j1))
			 (set! res3 2))	  
			((array? (array-ref res2 i1 j1))
			 (set! res3 3))	  
			((boolean? (array-ref res2 i1 j1))
			 (set! res3 4))
			((char? (array-ref res2 i1 j1))
			 (set! res3 5))	  
			((integer? (array-ref res2 i1 j1))
			 (set! res3 6))
			((real? (array-ref res2 i1 j1))
			 (set! res3 7))
			((complex? (array-ref res2 i1 j1))
			 (set! res3 8)))

		  ;; This should be processed separatedly.
		  (cond ((< res3 8)
			 (cond ((inf? (array-ref res2 i1 j1))
				(set! res3 9))
			       ((nan? (array-ref res2 i1 j1))
				(set! res3 10)))))
		  
		  (array-set! res1 res3 i1 j1)
		  (set! j1 (in j1)))

	   (set! i1 (in i1)))
    
    res1))


;; grsp-matrix-argstru - Finds the data types of each column of an n x m matrix.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;;
;; Output:
;; - For an m x n matrix, returns a 1 x n matrix containing the codes that
;;   correspond to the type of each column according to:
;;   - 0: undefined.
;;   - 1: list.
;;   - 2: string.
;;   - 3: array.
;;   - 4: boolean.
;;   - 5: char.
;;   - 6: integer.
;;   - 7: real.
;;   - 8: complex.
;;   - 9: inf.
;;   - 10: nan.
;;
(define (grsp-matrix-argstru p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(lm3 0)
	(hm3 0)
	(ln3 0)
	(hn3 0)
	(j3 0)
	(n1 0)
	(n2 0)
	(n3 0)
	(n4 0))

    ;; Create safety matrix. 
    (set! res2 (grsp-matrix-cpy p_a1))

    ;; Create argtype matrix.
    (set! res3 (grsp-matrix-argtype res2))

    ;; Extract boundaries.
    (set! lm3 (grsp-matrix-esi 1 res3))
    (set! hm3 (grsp-matrix-esi 2 res3))
    (set! ln3 (grsp-matrix-esi 3 res3))
    (set! hn3 (grsp-matrix-esi 4 res3))

    ;; Create results matrix.
    (set! n3 (grsp-matrix-te1 ln3 hn3))
    (set! res1 (grsp-matrix-create 0 1 n3))
    
    ;; Cycle.
    (set! j3 ln3)
    (set! n2 0)
    (while (<= j3 hn3)
	   (set! n1 (array-ref res3 lm3 j3))
	   ;;(set! n2 (grsp-matrix-col-total-element "#!=" res3 j3 n1))
	   (cond ((> n2 0)
		  (array-set! res1 0 0 j3))
		 (else (array-set! res1 n1 0 j3)))
	   
	   (set! j3 (in j3)))
    
    res1))


;;;; grsp-matrix-row-subrepal - Replaces row p_m1 of matrix p_a1 with the values
;; contained in list p_l1. If row p_m1 does not exist then a new row is added to
;; place the values of p_l1.
;;
;; Keywords:
;; - function, ann, neural network.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_m1: rown number.
;; - p_l2: list of values to update in row p_m1 of matrix p_a1.
;;
;; Notes:
;; - Make sure that p_l1 has as many elements as p_a1's rows.
;;
(define (grsp-matrix-row-subrepal p_a1 p_m1 p_l2)
  (let ((res1 0)
	(res2 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(n1 0)
	(b1 #f)
	(m1 p_m1))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Extract boundaries.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    ;; Convert list into row vector.
    (set! res2 (grsp-l2m p_l2))
    
    ;; Evaluate if the function will:
    ;; - Edit an existing row.
    ;; - Add a row at the bottom of the matrix.
    (cond ((< m1 lm1)
	   (set! b1 #t))
	  ((> m1 hm1)
	   (set! b1 #t)))

    (cond ((equal? b1 #t)
	   (set! res1 (grsp-matrix-subexp res1 1 0))
	   
	   ;; Extract boundaries since the matrix has changed
	   (set! lm1 (grsp-matrix-esi 1 res1))
	   (set! hm1 (grsp-matrix-esi 2 res1))
	   (set! m1 hm1)))	   

    (set! res1 (grsp-matrix-subrep res1 res2 m1 ln1))
    
    res1))


;;;; grsp-matrix-subdell - Deletes row p_n1 from matrix p_a1 if its
;; elements are respetvely equal, in the same order,
;; to those in list p_l1. 
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;;
;; Arguments:
;; - p_a1: matrix.
;; - p_l1: list.
;;
(define (grsp-matrix-subdell p_a1 p_m1 p_l1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(ln2 0)
	(hn2 0)
	(b1 #f))

    ;; Cast list as matrix.
    (set! res2 (grsp-l2m p_l1))

    ;; Extract boundaries.
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))

    ;; Extract the requested row of the input matrix as a vector.
    (set! res3 (grsp-matrix-subcpy p_a1 p_m1 p_m1 ln2 hn2))

    ;; Compare.
    (set! b1 (grsp-matrix-is-equal res2 res3))

    (cond ((equal? b1 #t)
	   (set! res1 (grsp-matrix-subdel "#Delr" p_a1 p_m1))))
	  
    res1))


;;;; grsp-matrix-is-samedim - Returns #t if the dimensionality of matrix p_a1
;; and matrix p_a2 is the same, but not necessarily have the same elements.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;; 
;; Arguments:
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
;; Output:
;; - Returns #t if both matrices have the same number of rows and columns; #f
;;   otherwise.
;;
(define (grsp-matrix-is-samedim p_a1 p_a2)
  (let ((res1 #f)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0))

    ;; Extract the boundaries of the first matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    ;; Extract the boundaries of the second matrix.
    (set! lm2 (grsp-matrix-esi 1 p_a2))
    (set! hm2 (grsp-matrix-esi 2 p_a2))
    (set! ln2 (grsp-matrix-esi 3 p_a2))
    (set! hn2 (grsp-matrix-esi 4 p_a2))

    ;; Compare the size of both matrices.
    (cond ((= lm1 lm2)
	   (cond ((= hm1 hm2)
		  (cond ((= ln1 ln2)
			 (cond ((= hn1 hn2)
				(set! res1 #t)))))))))
    
    res1))


;;;; grsp-matrix-fill - Fills all elements of matrix p_a1 with value p_n1.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;; 
;; Arguments:
;; - p_a1: matrix.
;;
(define (grsp-matrix-fill p_a1 p_n1)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0))
    
    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))
	  
    ;; Extract the boundaries of the first matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))

    (set! i1 lm1)
    (while (<= i1 hm1)
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  
		  (array-set! res1 p_n1 i1 j1)
		  
		  (set! j1 (in j1)))
	   (set! i1 (in i1)))
    
    res1))


;;;; grsp-matrix-fdif - Find differences between matrices p_a1 and p_a2, This
;; function returns a boolean-numeric matrix in which true (difference found)
;; is expressed as the number one and false (difference not found) is
;; represented by zweo.
;;
;; Keywords:
;; - function, algebra, matrix, matrices, vectors.
;; 
;; Arguments:
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
;; Output:
;; - A matrix of the same dimensions as p_a1 and p_a2 if they have the same
;;   diemntionality, containing elements with value 1 wherever the elements
;;   of the same coordinates in p_a1 and p_a2 are different, or 0 otherwise.
;; - A matrix of the same dimensions as p_a1, with NaN as values.
;;
(define (grsp-matrix-fdif p_a1 p_a2)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0)
	(a1 0)
	(a2 0)
	(n1 0)
	(n2 0))

    (set! n2 (grsp-nan))
    
    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))
	  
    ;; Extract the boundaries of the first matrix.***
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))
    
    ;; Find if matrixes have the same dimensions.
    (cond ((equal? (grsp-matrix-is-samedim p_a1 p_a2) #t)
	   (set! i1 lm1)
	   (while (<= i1 hm1)
		  
		  (set! j1 ln1)
		  (while (<= j1 hn1)

			 (set! a1 (array-ref p_a1 i1 j1))
			 (set! a2 (array-ref p_a2 i1 j1))
			 (cond ((= a1 a2)
				(array-set! res1 0 i1 j1))
			       (else (array-set! res1 1 i1 j1)))

			 (set! j1 (in j1)))

		  (set! i1 (in i1))))
	  (else (set! res1 (grsp-matrix-fill res1 n2))))
			     
    res1))


(define (grsp-matrix-ftc p_a1 p_n1 p_f1)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))
	  
    ;; Extract the boundaries of the first matrix.***
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))    

    (set! i1 lm1)
    (while (<= i1 hm1)

	   (array-set! res1 p_f1 i1 p_n1)
	   
	   (set! i1 (in i1)))
    
    res1))

