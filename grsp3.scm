;; =========================================================================
;; 
;; grsp3.scm
;;
;; Relational vectors, matrices, files and databases. In general, these
;; functions constitute the basis for other functions found in the grspX.scm
;; files, where X > 3.
;;
;; =========================================================================
;;
;; Copyright (C) 2020 - 2024 Pablo Edronkin (pablo.edronkin at yahoo.com)
;;
;;   This program is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU Lesser General Public License as
;;   published by the Free Software Foundation, either version 3 of the
;;   License, or (at your option) any later version.
;;
;;   This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;   GNU Lesser General Public License for more details.
;;
;;   You should have received a copy of the GNU Lesser General Public
;;   License along with this program. If not, see
;;   <https://www.gnu.org/licenses/>.
;;
;; =========================================================================


;;;; General notes:
;;
;; - Read sources for limitations on function parameters.
;; - grsp3 provides some level of matrix algebra functionality for Guile,
;;   but in its current version it is not intended to be particulary fast.
;;   It does not make use of any additional non-Scheme library like BLAS
;;   or Lapack.
;; - As a convention here, m represents rows, n represents columns;
;;   variations in this theme include:
;;
;;   - lm: lowest row number.
;;   - hm: highest row number.
;;   - ln: lowest col number.
;;   - hn: highest col number.
;;   - tm: total number of rows.
;;   - tn: total number of columns.
;;
;; - All matrices referred in this file are numeric except wherever
;;   specifically stated.
;;
;; Sources:
;;
;; See code of functions used and their respective source files for more
;; credits and references.
;;
;; - [1] Hep.by. (2020). Array Procedures - Guile Reference Manual. [online]
;;   Available at:
;;   http://www.hep.by/gnu/guile/Array-Procedures.html#Array-Procedures
;;   [Accessed 28 Jan. 2020].
;; - [2] En.wikipedia.org. (2020). Numerical linear algebra. [online]
;;   Available at: https://en.wikipedia.org/wiki/Numerical_linear_algebra
;;   [Accessed 28 Jan. 2020].
;; - [3] En.wikipedia.org. (2020). Matrix theory. [online] Available at:
;;   https://en.wikipedia.org/wiki/Category:Matrix_theory
;;   [Accessed 28 Jan. 2020].
;; - [4] En.wikipedia.org. (2020). List of matrices. [online] Available at:
;;   https://en.wikipedia.org/wiki/List_of_matrices [Accessed 8 Mar. 2020].
;; - [5] Gnu.org. (2020). Random (Guile Reference Manual). [online]
;;   Available at:
;;   https://www.gnu.org/software/guile/manual/html_node/Random.html
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
;;   https://en.wikipedia.org/wiki/Determinant [Accessed 2 August 2020].
;; - [10] En.wikipedia.org. 2020. Leibniz Formula For Determinants.
;;   [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/Leibniz_formula_for_determinants
;;   [Accessed 4 August 2020].
;; - [11] En.wikipedia.org. 2020. Invertible Matrix. [online] Available at:
;;   https://en.wikipedia.org/wiki/Invertible_matrix [Accessed 5 August
;;   2020].
;; - [12] En.wikipedia.org. 2020. Permanent (Mathematics). [online]
;;   Available at: https://en.wikipedia.org/wiki/Permanent_(mathematics)
;;   [Accessed 7 August 2020].
;; - [13] En.wikipedia.org. 2020. Immanant. [online] Available at:
;;   https://en.wikipedia.org/wiki/Immanant [Accessed 14 August 2020].
;; - [14] En.wikipedia.org. 2020. Eigendecomposition Of A Matrix. [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/Eigendecomposition_of_a_matrix
;; - [15] En.wikipedia.org. 2020. Eigenvalue Algorithm. [online]
;;   Available at: https://en.wikipedia.org/wiki/Eigenvalue_algorithm
;;   [Accessed 12 August 2020].
;; - [16] En.wikipedia.org. 2021. Relational algebra. [online] Available
;;   at: https://en.wikipedia.org/wiki/Relational_algebra [Accessed 16
;;   March 2021].
;; - [17] En.wikipedia.org. 2021. Support (mathematics). [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/Support_(mathematics)> [Accessed 27
;;   March 2021].
;; - [18] Mathispower4u. (2020). LU Decomposition. [online] Available at:
;;   https://www.youtube.com/watch?v=UlWcofkUDDU [Accessed 5 Mar. 2020].
;; - [19] En.wikipedia.org. 2021. Genetic algorithm - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Genetic_algorithm
;;   [Accessed 13 May 2021].
;; - [20] En.wikipedia.org. 2021. Crossover (genetic algorithm) -
;;   Wikipedia. [online] Available at:
;;   https://en.wikipedia.org/wiki/Crossover_(genetic_algorithm)
;;   [Accessed 13 May 2021].
;; - [21] En.wikipedia.org. 2021. Mutation (genetic algorithm) - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Mutation_(genetic_algorithm)
;;   [Accessed 13 May 2021].
;; - [22] En.wikipedia.org. 2021. Selection (genetic algorithm) -
;;   Wikipedia. [online] Available at:
;;   https://en.wikipedia.org/wiki/Selection_(genetic_algorithm)
;;   [Accessed 13 May 2021].
;; - [23] fitness, A., 2015. Accumulated normalized fitness. [online] Stack
;;   Overflow. Available at:
;;   https://stackoverflow.com/questions/27524241/accumulated-normalized-fitness
;;   [Accessed 13 May 2021].
;; - [24] En.wikipedia.org. 2021. Multiset - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Multiset [Accessed 17
;;   September 2021].
;; - [25] Gnuplotting.org. 2021. Plotting data « Gnuplotting. [online]
;;   Available at: http://www.gnuplotting.org/plotting-data/
;;   [Accessed 21 November 2021].
;; - [26] Gnu.org. 2022. Scheduling (Guile Reference Manual). [online]
;;   Available at:
;;   https://www.gnu.org/software/guile/manual/html_node/Scheduling.html
;;   [Accessed 16 May 2022].
;; - [27] En.wikipedia.org. 2022. Pauli matrices - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Pauli_matrices
;;   [Accessed 16 May 2022].
;; - [28] En.wikipedia.org. 2022. Gamma matrices - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Gamma_matrices#Dirac_basis
;;   [Accessed 16 May 2022].
;; - [29] En.wikipedia.org. 2022. Higher-dimensional gamma matrices -
;;   Wikipedia. [online] Available at:
;;   https://en.wikipedia.org/wiki/Higher-dimensional_gamma_matrices
;;   [Accessed 16 May 2022].
;; - [30] En.wikipedia.org. 2022. Gell-Mann matrices - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Gell-Mann_matrices
;;   [Accessed 19 May 2022].
;; - [31] En.wikipedia.org. 2022. Quantum logic gate - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Quantum_logic_gate
;;   [Accessed 31 May 2022].
;; - [32] En.wikipedia.org. 2022. Quantum circuit - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Quantum_circuit
;;   [Accessed 31 May 2022].
;; - [33] En.wikipedia.org. 2022. Penrose graphical notation - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Penrose_graphical_notation
;;   [Accessed 31 May 2022].
;; - [34] En.wikipedia.org. 2022. Categorical quantum mechanics -
;;   Wikipedia. [online] Available at:
;;   https://en.wikipedia.org/wiki/Categorical_quantum_mechanics
;;   [Accessed 31 May 2022].
;; - [35] En.wikipedia.org. 2022. Qutrit - Wikipedia. [online] Available
;;   at: https://en.wikipedia.org/wiki/Qutrit#Qutrit_quantum_gates
;;   [Accessed 31 May 2022].
;; - [36] En.wikipedia.org. 2022. Tensor product - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Tensor_product
;;   [Accessed 31 May 2022].
;; - [37] En.wikipedia.org. 2022. Kronecker product - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Kronecker_product
;;   [Accessed 31 May 2022].
;; - [38] Product, T., Borah, M. and Orrick, W., 2022. Tensor product and
;;   Kronecker Product. [online] Mathematics Stack Exchange. Available at:
;;   https://math.stackexchange.com/questions/203947/tensor-product-and-kronecker-product
;;   [Accessed 1 June 2022].
;; - [39] En.wikipedia.org. 2022. List of named matrices - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/List_of_named_matrices [Accessed 6
;;   June 2022].
;; - [40] En.wikipedia.org. 2022. Hermitian adjoint - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Hermitian_adjoint
;;   [Accessed 9 June 2022].
;; - [41] En.wikipedia.org. 2022. Conjugate transpose - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Conjugate_transpose
;;   [Accessed 9 June 2022].
;; - [42] En.wikipedia.org. 2022. Minor (linear algebra) - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Minor_(linear_algebra)
;;   [Accessed 9 June 2022].
;; - [43] GeeksforGeeks. 2022. Doolittle Algorithm : LU Decomposition -
;;   GeeksforGeeks. [online] Available at:
;;   https://www.geeksforgeeks.org/doolittle-algorithm-lu-decomposition/
;;   [Accessed 27 June 2022].
;; - [44] En.wikipedia.org. 2022. Crout matrix decomposition - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Crout_matrix_decomposition
;;   [Accessed 27 June 2022].
;; - [45] En.wikipedia.org. 2022. Unit vector - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Unit_vector
;;   [Accessed 27 June 2022].
;; - [46] En.wikipedia.org. 2022. Dot product - Wikipedia. [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/Dot_product [Accessed 27 June 2022].
;; - [47] En.wikipedia.org. 2022. Inner product space - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Inner_product_space
;;   [Accessed 27 June 2022].
;; - [48] En.wikipedia.org. 2022. Gram–Schmidt process - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Gram%E2%80%93Schmidt_process
;;   [Accessed 27 June 2022].
;; - [49] 1980. Algorithms for the QR-Decomposition. [ebook] Zuerich.
;;   Gander. Available at:
;;   https://people.inf.ethz.ch/gander/papers/qrneu.pdf [Accessed 6 July
;;   2022].
;; - [50] Bindel, 2017. Householder QR. [ebook] Available at:
;;   https://www.cs.cornell.edu/~bindel/class/cs6210-f09/lec18.pdf
;;   [Accessed 6 July 2022].
;; - [51] People.math.wisc.edu. 2022. qr-4-ls-by-qr. [online] Available at:
;;   https://people.math.wisc.edu/~roch/mmids/qr-4-ls-by-qr.html
;;   [Accessed 6 July 2022].
;; - [52] En.wikipedia.org. 2022. Wilson matrix - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Wilson_matrix [Accessed
;;   7 July 2022].
;; - [53] En.wikipedia.org. 2022. Cholesky decomposition - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Cholesky_decomposition [Accessed 7
;;   July 2022].
;; - [54] Es.wikipedia.org. 2022. Norma matricial - Wikipedia, la
;;   enciclopedia libre. [online] Available at:
;;   https://es.wikipedia.org/wiki/Norma_matricial [Accessed 10 July 2022].
;; - [55] En.wikipedia.org. 2022. QR algorithm - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/QR_algorithm [Accessed
;;   18 July 2022].
;; - [56] En.wikipedia.org. 2022. List of numerical analysis topics -
;;   Wikipedia. [online] Available at:
;;   https://en.wikipedia.org/wiki/List_of_numerical_analysis_topics
;;   [Accessed 18 July 2022].
;; - [57] En.wikipedia.org. 2022. Matrix splitting - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Matrix_splitting
;;   [Accessed 21 July 2022].
;; - [58] En.wikipedia.org. 2022. Gauss–Seidel method - Wikipedia. [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/Gauss%E2%80%93Seidel_method [Accessed
;;   21 July 2022].
;; - [59] En.wikipedia.org. 2022. Jacobi method - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Jacobi_method [Accessed
;;   21 July 2022].
;; - [60] En.wikipedia.org. 2022. Spectral radius - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Spectral_radius
;;   [Accessed 22 July 2022].
;; - [61] En.wikipedia.org. 2022. Rotation matrix - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Rotation_matrix
;;   [Accessed 5 October 2022].
;; - [62] Eigenvector and eigenvalue (no date) Math is Fun Advanced.
;;   Available at: https://www.mathsisfun.com/algebra/eigenvalue.html
;;   (Accessed: January 26, 2023). 
;; - [63] Ciobanu, A. (2021) Writing your own Linear Algebra Matrix
;;   Library in C, andreinc. Available at:
;;   https://www.andreinc.net/2021/01/20/writing-your-own-linear-algebra-matrix-library-in-c#solving-linear-systems-of-equations
;;   (Accessed: January 26, 2023). 
;; - [64] Forward substitution (no date) Algowiki. Available at:
;;   https://algowiki-project.org/en/Forward_substitution
;;   (Accessed: January 26, 2023). 
;; - [65] Backward substitution (no date) Algowiki. Available at:
;;   https://algowiki-project.org/en/Backward_substitution
;;   (Accessed: January 26, 2023).
;; - [66] Singular Value Decomposition (SVD) tutorial  BE.400 / 7.548
;;   (no date) Singular value decomposition (SVD) tutorial. Available at:
;;   https://web.mit.edu/be.400/www/SVD/Singular_Value_Decomposition.htm
;;   (Accessed: March 13, 2023). 
;; - [67] Singular value decomposition (2023) Wikipedia. Wikimedia
;;   Foundation. Available at:
;;   https://en.wikipedia.org/wiki/Singular_value_decomposition
;;   (Accessed: March 16, 2023). 
;; - [68] Frobenius inner product (2022) Wikipedia. Wikimedia Foundation.
;;   Available at: https://en.wikipedia.org/wiki/Frobenius_inner_product
;;   (Accessed: March 16, 2023). 
;; - [69] Khatri–rao product (2023) Wikipedia. Wikimedia Foundation.
;;   Available at: https://en.wikipedia.org/wiki/Khatri%E2%80%93Rao_product
;;   (Accessed: March 17, 2023). 
;; - [70] Block matrix (2023) Wikipedia. Wikimedia Foundation. Available
;;   at: https://en.wikipedia.org/wiki/Block_matrix (Accessed: March 28,
;;   2023). 
;; - [71] https://www.gnu.org/software/guile/manual/html_node/Futures.html


(define-module (grsp grsp3)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp4)
  #:use-module (grsp grsp11)  
  #:use-module (ice-9 threads)
  #:use-module (ice-9 futures)
  #:use-module (ice-9 string-fun)
  #:export (grsp-lm
	    grsp-hm
	    grsp-ln
	    grsp-hn
	    grsp-tm
	    grsp-tn
	    grsp-matrix-order
	    grsp-matrix-esi
	    grsp-matrix-create
	    grsp-matrix-create-set
	    grsp-matrix-create-fix
	    grsp-matrix-create-dim
	    grsp-matrix-change
	    grsp-matrix-find
	    grsp-matrix-transpose
	    grsp-matrix-transposer
	    grsp-matrix-conjugate
	    grsp-matrix-conjugate-transpose
	    grsp-matrix-opio
	    grsp-matrix-opsc
	    grsp-matrix-opew
	    grsp-matrix-opewl
	    grsp-matrix-opfn
	    grsp-matrix-opmm
	    grsp-matrix-opmml
	    grsp-matrix-opmsc
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
	    grsp-matrix-determinant-qr
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
	    grsp-matrix-is-samediml
	    grsp-matrix-fill
	    grsp-matrix-fdif
	    grsp-matrix-opewc
	    grsp-matrix-row-opew-mth
	    grsp-matrix-opew-mth
	    grsp-mr2l
	    grsp-l2mr
	    grsp-matrix-is-traceless
	    grsp-matrix-movemm
	    grsp-matrix-movsmm
	    grsp-matrix-movcrm
	    grsp-matrix-movtrm
	    grsp-matrix-ldiagonal
	    grsp-matrix-minor
	    grsp-matrix-minor-cofactor
	    grsp-matrix-cofactor
	    grsp-matrix-inverse
	    grsp-matrix-adjugate
	    grsp-mn2ms
	    grsp-matrix-spjustify
	    grsp-matrix-slongest
	    grsp-ms2s
	    grsp-matrix-display
	    grsp-ms2mn
	    grsp-matrix-tio
	    grsp-matrix-diagonal-update
	    grsp-matrix-diagonal-vector
	    grsp-matrix-row-proj
	    grsp-matrix-normp
	    grsp-matrix-normf
	    grsp-matrix-normm
	    grsp-eigenval-qr
	    grsp-eigenvec
	    grsp-matrix-is-srddominant
	    grsp-matrix-jacobim
	    grsp-matrix-sradius
	    grsp-ms2ts
	    grsp-mr2ls
	    grsp-dbc2lls
	    grsp-matrix-row-prkey
	    grsp-matrix-strot
	    grsp-matrix-row-corr
	    grsp-matrix-correwl
	    grsp-matrix-wlongest
	    grsp-matrix-mmt
	    grsp-matrix-mtm
	    grsp-matrix-fsubst
	    grsp-matrix-bsubst
	    grsp-matrix-compatibility
	    grsp-matrix-part-create
	    grsp-matrix-is-filled-with
	    grsp-matrix-row-selectrn
	    grsp-matrix-col-selectcn
	    grsp-matrix-row-subrepf
	    grsp-matrix-row-subreps
	    grsp-matrix-ldvl
	    grsp-matrix-blur
	    grsp-matrix-col-replacev
	    grsp-matrix-selectmb
	    grsp-matrix-row-opscr
	    grsp-ms2dbc
	    grsp-dbc2ms
	    grsp-matrix-split
	    grsp-matrix-inputev
	    grsp-matrix-row-inputev
	    grsp-matrix-rows-inputev
	    grsp-matrix-rows-addev
	    grsp-matrix-rows-filled-with
	    grsp-matrix-displayts
	    grsp-matrix-subadd
	    grsp-matrix-displaytn
	    grsp-matrix-edit
	    grsp-my2ms
	    grsp-matrix-displaytm
	    grsp-matrix-editu
	    grsp-my2code
	    grsp-ms2my
	    grsp-cy2cy
	    grsp-ms2mb
	    grsp-matrix-row-select-like
	    grsp-matrix-sincostan-mth
	    grsp-matrix-row-number
	    grsp-matrix-keygen
	    grsp-matrix-keyapl
	    grsp-matrix-subdelr
	    grsp-matrix-row-vol
	    grsp-ms-get-longest-element
	    grsp-ms-create-col-headers
	    grsp-ms-create-row-headers
	    grsp-ms-pad-elements
	    grsp-matrix-displaytms
	    grsp-matrix-row-subrepk
	    grsp-matrix-row-numk
	    grsp-matrix-subrepk
	    grsp-matrix-row-subrepkl
	    grsp-matrix-row-col-setk
	    grsp-matrix-find-if-prkey-exists
	    grsp-matrix-row-subexpk
	    grsp-matrix-row-insert
	    grsp-matrix-tf-idf
	    grsp-matrix-row-insert-ioe
	    grsp-2l2cm
	    grsp-l2cm))


;;;; grsp-lm - Short form of (grsp-matrix-esi 1 p_a1).
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, properties, dimensions, size
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - See grsp-matrix-esi.
;;
;; Output:
;;
;; - Numeric, lm value.
;;
(define (grsp-lm p_a1)
  (let ((res1 0))
    
    (set! res1 (grsp-matrix-esi 1 p_a1))

    res1))


;;;; grsp-hm - Short form of (grsp-matrix-esi 2 p_a1).
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - See grsp-matrix-esi.
;;
;; Output:
;;
;; - Numeric, hm value.
;;
(define (grsp-hm p_a1)
  (let ((res1 0))
    
    (set! res1 (grsp-matrix-esi 2 p_a1))

    res1))


;;;; grsp-ln - Short form of (grsp-matrix-esi 3 p_a1).
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - See grsp-matrix-esi.
;;
;; Output:
;;
;; - Numeric, ln value.
;;  
(define (grsp-ln p_a1)  
  (let ((res1 0))
    
    (set! res1 (grsp-matrix-esi 3 p_a1))

    res1))


;;;; grsp-hn - Short form of (grsp-matrix-esi 4 p_a1).
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - See grsp-matrix-esi.
;;
;; Output:
;;
;; - Numeric, hn value.
;;  
(define (grsp-hn p_a1)  
  (let ((res1 0))
    
    (set! res1 (grsp-matrix-esi 4 p_a1))

    res1))


;;;; grsp-tm - Convenience function that returns the total number of rows
;; in p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - See grsp-matrix-te2.
;;
;; Output:
;;
;; - Numeric, (+ (- hm lm)) value.
;; 
(define (grsp-tm p_a1)
  (let ((res1 0)
	(res2 0))

    (set! res2 (grsp-matrix-te2 p_a1))
    (set! res1 (array-ref res2 0 0))

    res1))


;;;; grsp-tn - Convenience function that returns the total number of cols
;; in p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - See grsp-matrix-te2.
;;
;; Output:
;;
;; - Numeric, (+ (- hn ln)) value.
;; 
(define (grsp-tn p_a1)
  (let ((res1 0)
	(res2 0))

    (set! res2 (grsp-matrix-te2 p_a1))
    (set! res1 (array-ref res2 0 1))

    res1))


;;;; grsp-matrix-order - Returns the order (* tm tn) of a matrix.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-matrix-order p_a1)
  (let ((res1 (* (grsp-tm p_a1) (grsp-tn p_a1))))

    res1))


;;;; grsp-matrix-esi - Extracts shape information from an m x n matrix.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_e1: number indicating the element value desired.
;;
;;   - 1: lm. low boundary for m (rows).
;;   - 2: hm. high boundary for m (rows).
;;   - 3: ln. low boundary for n (cols).
;;   - 4: hn. high boundary for n (cols).
;;
;; - p_m1: m.
;;
;; Sources:
;;
;; - [1][2][3][4].
;;
;; Output:
;;
;; - A number corresponding to the shape element value desired. Returns
;;   zero if p_e1 is incorrect.
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
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: matrix type.
;;
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
;;   - "#Ex2SVD": 4 x 2 matrix example for SVD, see [66].
;;   - "#Ex1SVD": 4 X 5 matrix example for SVD, see [67].
;;   - "#CH": 0-1 checkerboard pattern matrix.
;;   - "#CHR": 0-1 checkerboard pattern matrix, randomized.
;;   - "#+IJ": matrix containing the sum of i and j values.
;;   - "#-IJ": matrix containing the substraction of i and j values.
;;   - "#+IJ": matrix containing the product of i and j values.
;;   - "#-IJ": matrix containing the quotient of i and j values.
;;   - "#US": upper shift matrix.
;;   - "#LS": lower shift matrix.
;;   - "#UT": upper triangular matrix, with value 1 in non-zero elements.
;;   - "#LT": lower triangular matrix, with value 1 in non-zero elements.
;;   - "#rprnd": pseduo random values, normal distribution, sd = 0.15.
;;   - "#zrow": zebra row.
;;   - "#zcol": zebra col.
;;   - "#n0[-m:+m]": matrix of (2m +1 ) rows and n cols, with first column
;;     element -m and last row, first col element reaching m.
;;
;; - p_m1: rows, positive integer.
;; - p_n1: cols, positive integer.
;;
;; Examples:
;;
;; - example3.scm, example5.scm.
;;
;; Notes:
;;
;; - See grsp0.grsp-s2dbc, grsp0.grsp-dbc2s, grsp0.grsp-random-state-set.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [1][2][18][31].
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
			((equal? p_s1 "#Ex2SVD")
			 (set! s1 0))
			((equal? p_s1 "#Ex1SVD")
			 (set! s1 0))				
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

		  ;; Once the matrix has been created, depending on the
		  ;; type of matrix, modify its values.
		  (cond ((equal? p_s1 "#I")
			 
			 (while (< i1 m1)
				
				(set! j1 0)
				(while (< j1 n1)
				       
				       (cond ((eq? i1 j1)
					      (array-set! res1 1 i1 j1)))
				       
				       (set! j1 (+ j1 1)))
				
				(set! i1 (+ i1 1))))
			
			((equal? p_s1 "#Test1")
			 (set! res1 (grsp-l2mr res1 (list 1 4 -3) 0 0))
			 (set! res1 (grsp-l2mr res1 (list -2 8 5) 1 0))
			 (set! res1 (grsp-l2mr res1 (list 3 4 7) 2 0)))	
			((equal? p_s1 "#Test2")
			 (set! res1 (grsp-l2mr res1 (list 2 4 -4) 0 0))
			 (set! res1 (grsp-l2mr res1 (list 1 -4 3) 1 0))
			 (set! res1 (grsp-l2mr res1 (list -6 -9 5) 2 0)))
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
				       (array-set! res1
						   (/ 1
						      (- (+ (+ i1 1) (+ j1 1))
							 1))
						   i1
						   j1)
				       (set! j1 (+ j1 1)))
				
				(set! i1 (+ i1 1))))
			
			((equal? p_s1 "#Lehmer")
			 
			 (while (< i1 m1)
				
				(set! j1 0)				
				(while (< j1 n1)
				       (array-set! res1 (/ (min (+ i1 1)
								(+ j1 1))
							   (max (+ i1 1)
								(+ j1 1)))
						   i1 j1)
				       (set! j1 (+ j1 1)))
				
				(set! i1 (+ i1 1))))
			
			((equal? p_s1 "#Pascal")
			 
			 (while (< i1 m1)
				
				(set! j1 0)				
				(while (< j1 n1)
				       (array-set! res1
						   (grsp-biconr (+ i1 j1)
								i1)
						   i1
						   j1)
				       (set! j1 (+ j1 1)))
				
				(set! i1 (+ i1 1))))
			
			((equal? p_s1 "#Ex2SVD")			 
			 (set! res1 (grsp-matrix-create 0 4 2))
			 (array-set! res1 2 0 0)
			 (array-set! res1 4 0 1)
			 (array-set! res1 1 1 0)
			 (array-set! res1 3 1 1))
			((equal? p_s1 "#Ex1SVD")			 
			 (set! res1 (grsp-matrix-create 0 4 5))
			 (array-set! res1 1 0 0)
			 (array-set! res1 2 0 4)
			 (array-set! res1 3 1 2)			 
			 (array-set! res1 2 3 1))			
			((equal? p_s1 "#Fibonacci")			 
			 (set! p0 0)
			 (set! p1 1)
			 (set! p2 0)
			 
			 (while (< i1 m1)
				
				(set! j1 0)
				(while (< j1 n1)

				       ;; Non-recursive calculation of
				       ;; Fibonacci terms in order to
				       ;; fill the matrix easily.
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

				       ;; Mean 0.0 sd 0.15
				       (cond ((>= (array-ref res1 i1 j1) 0)
					      (array-set! res1 1 i1 j1))
					     (else (array-set! res1
							       0
							       i1
							       j1)))
				       
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
					      (array-set! res1
							  (/ i1 j1)
							  i1
							  j1)))
				       
				       (set! j1 (+ j1 1)))
				
				(set! i1 (+ i1 1))))
			
			((equal? p_s1 "#US")
			 
			 (while (< i1 m1)
				
				(set! j1 0)
				(while (< j1 (- n1 1))
				       
				       (cond ((eq? i1 j1)
					      (array-set! res1
							  1
							  i1
							  (+ j1 1))))
				       
				       (set! j1 (+ j1 1)))
				
				(set! i1 (+ i1 1))))
			
			((equal? p_s1 "#LS")			 
			 (set! res1 (grsp-matrix-create "#US" m1 n1))
			 (set! res1 (grsp-matrix-transpose res1)))
			((equal? p_s1 "#UT")
			 (set! res1 (grsp-matrix-create 0 m1 m1))

			 (set! i1 0)
			 (while (< i1 m1)
				
				(set! j1 0)
				(while (< j1 m1)
				       
				       (cond ((<= i1 j1)
					      (array-set! res1 1 i1 j1)))
				       
				       (set! j1 (in j1)))
				
				(set! i1 (in i1))))
			
			((equal? p_s1 "#LT")
			 (set! res1 (grsp-matrix-create 0 m1 m1))

			 (set! i1 0)
			 (while (< i1 m1)
				
				(set! j1 0)
				(while (< j1 m1)
				       
				       (cond ((>= i1 j1)
					      (array-set! res1 1 i1 j1)))
				       
				       (set! j1 (in j1)))
				
				(set! i1 (in i1))))
			
			((equal? p_s1 "#rprnd")			 
			 (set! res1 (grsp-matrix-create 1 m1 n1))
			 (set! res1 (grsp-matrix-opsc "#rprnd"
						      res1
						      0.15)))
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
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix to operate on.
;; - p_v1: value to be replaced within p_a1.
;; - p_v2: value to replace p_v1 with.
;;
;; Sources:
;;
;; - [1][2][3][4].
;;
;; Output:
;;
;; - A modified matrix p_a in which all p_v1 values would have been
;; replaced by p_v2.
;;
(define (grsp-matrix-change p_a1 p_v1 p_v2)
  (let ((res1 0)
	(i1 0)
	(j1 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Row loop.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln res1)))
		   (if (<= j1 (grsp-hn res1))

		       (begin (cond ((equal? (array-ref res1 i1 j1) p_v1)
				     (array-set! res1 p_v2 i1 j1)))
			      
			      (loop (+ j1 1)))))
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-create-set - Creates pre-defined sets of matrices as
;; elements of a list.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: matrix type.
;;
;;   - "#UD": User defined.
;;   - "#SBC": standard basis, cartesian.
;;   - "#Gell-Mann": Gell-Mann matrices.
;;   - "#Pauli": Pauli matrices.
;;   - "#Dirac": Dirac gamma matrices.
;;   - "#srdd": Ax = b with A strictly diagonal.
;;   - "#rprnd": pseudo random values, normal distribution, sd = 0.15.
;;   - "#mee1": contains original example1 matrix, eigenvectors and
;;     eigenvalue.
;;
;; - p_n2: number of matrices to create.
;; - p_n3: default value for said matrices.
;; - p_m1: rows, positive integer.
;; - p_n1: cols, positive integer.
;;
;; Notes:
;;
;; - Parameters p_n1, p_n2, p_m1 and/or p_n1 might not be relevant in
;;   the case of some sets (for example, in the case of Pauli matrices,
;;   which are all of 2 x 2). In such cases, these two parameters will
;;   not be taken into account irrespectively of the values passed.
;; - If paramenter p_s1 is passed as "#UD", paramseters p_n1, p_n2 p_m1
;;   and p_n1 do matter.
;; - See grsp-matrix-create.
;; - In Scheme lists elements are identified by their ordinals starting
;;   at zero instead of one. Be careful when interpreting some of these
;;   sets because it might be easy to confuse the programming and math
;;   conventions (example; matrix Sigma 1 would be returned as element
;;   0 in the resulting list).
;; - See grsp0.grsp-s2dbc, grsp0.grsp-dbc2s, grsp0.grsp-random-state-set.
;;
;; Output:
;;
;; - A list containing the matrices created as its elements.
;;
;; Sources:
;;
;; - [1][2][18][27][28][29][30][45][46].
;;
(define (grsp-matrix-create-set p_s1 p_n2 p_n3 p_m1 p_n1)
  (let ((res1 '())
	(aa 0)
	(a0 0)
	(a1 0)
	(a2 0)	
	(a3 0)
	(a4 0)
	(a5 0)
	(a6 0)
	(a7 0)	
	(m1 0)
	(n1 0)
	(n2 0)
	(n3 0)
	(i1 0)
	(z0p0p (grsp-mr 0.0 0.0))
	(z1p0p (grsp-mr 1.0 0.0))
	(z1n0p (grsp-mr -1.0 0.0))
	(z1n1n (grsp-mr -1.0 -1.0))
	(z0p1p (grsp-mr 0.0 1.0))
	(z0p1n (grsp-mr 0.0 -1.0)))

    (cond ((equal? p_s1 "#UD")

	   ;; Create list of adequate size.
	   (set! n2 p_n2)
	   (set! res1 (make-list n2))
	   
	   ;; Ser default matrix values.
	   (cond ((< n2 1)
		  (set! n2 1)))

	   (cond ((< p_m1 1)
		  (set! p_m1 1)))

	   (cond ((< p_n1 1)
		  (set! p_n1 1)))

	   ;; Create and put matrices into the list.
	   (while (< i1 n2)
		  (set! a0 (grsp-matrix-create p_n3 p_m1 p_n1))
		  (list-set! res1 i1 a0)		  
		  (set! i1 (in i1))))
	   
	  ((equal? p_s1 "#SBC")

	   ;; Define rows and cols. This creates three different column
	   ;; vectors.
	   (set! m1 3)
	   (set! n1 1) 

	   ;; Create matrix model.
	   (set! aa (grsp-matrix-create 0 m1 n1))
	   
	   ;; Create i.
	   (set! a0 (grsp-matrix-cpy aa)) 
	   (array-set! a0 z1p0p 0 0)	   

	   ;; Create j.
	   (set! a1 (grsp-matrix-cpy aa))	   
	   (array-set! a1 z1p0p 1 0)

	   ;; Create k.
	   (set! a2 (grsp-matrix-cpy aa))
	   (array-set! a2 z1p0p 2 0)	   
	   
	   ;; Compose results for "#SBC".
	   (set! res1 (list a0 a1 a2)))	   	   
	  
	  ((equal? p_s1 "#Gell-Mann")

	   ;; Define rows and cols.
	   (set! m1 3)
	   (set! n1 3) 

	   ;; Create matrix model.
	   (set! aa (grsp-matrix-create z0p0p m1 n1))
	   
	   ;; Create a0.
	   (set! a0 (grsp-matrix-cpy aa))
	   (array-set! a0 z1p0p 0 1)
	   (array-set! a0 z1p0p 1 0)	   

	   ;; Create a1.
	   (set! a1 (grsp-matrix-cpy aa))
	   (array-set! a1 z0p1n 0 1)
	   (array-set! a1 z0p1p 1 0)

	   ;; Create a2.
	   (set! a2 (grsp-matrix-cpy aa))
	   (array-set! a2 z1p0p 0 0)
	   (array-set! a2 z1n0p 1 1)

	   ;; Create a3.
	   (set! a3 (grsp-matrix-cpy aa))
	   (array-set! a3 z1p0p 0 2)
	   (array-set! a3 z1p0p 2 0)

	   ;; Create a4.
	   (set! a4 (grsp-matrix-cpy aa))
	   (array-set! a4 z0p1n 0 2)
	   (array-set! a4 z0p1p 2 0)

	   ;; Create a5.
	   (set! a5 (grsp-matrix-cpy aa))
	   (array-set! a5 z1p0p 1 2)
	   (array-set! a5 z1p0p 2 1)
	   
	   ;; Create a6.
	   (set! a6 (grsp-matrix-cpy aa))
	   (array-set! a6 z0p1n 1 2)
	   (array-set! a6 z0p1p 2 1)

	   ;; Create a7. Note that the final product is matrix a7
	   ;; already multiplied by (/ 1 (sqrt 3)).
	   (set! a7 (grsp-matrix-cpy aa))
	   (array-set! a7 z1p0p 0 0)
	   (array-set! a7 z1p0p 1 1)
	   (array-set! a7 (* 2 z1n0p) 2 2)
	   (set! n3 (/ 1 (sqrt 3)))
	   (set! a7 (grsp-matrix-opsc "#*" a7 n3))
	   
	   ;; Compose results for "#Gell-Mann".
	   (set! res1 (list a0 a1 a2 a3 a4 a5 a6 a7)))
	  
	  ((equal? p_s1 "#Pauli")

	   ;; Define rows and cols.
	   (set! m1 2)
	   (set! n1 2) 

	   ;; Create matrix model.
	   (set! aa (grsp-matrix-create z0p0p m1 n1))
	   
	   ;; Create sigma 1.
	   (set! a0 (grsp-matrix-cpy aa))
	   (array-set! a0 z1p0p 0 1)
	   (array-set! a0 z1p0p 1 0)

	   ;; Create sigma 2.
	   (set! a1 (grsp-matrix-cpy aa))
	   (array-set! a1 z0p1n 0 1)
	   (array-set! a1 z0p1p 1 0)
	   
	   ;; Create sigma 3.
	   (set! a2 (grsp-matrix-cpy aa))
	   (array-set! a2 z1p0p 0 0)
	   (array-set! a2 z1n0p 1 1)	   
	   
	   ;; Compose results for "#Pauli".
	   (set! res1 (list a0 a1 a2)))

	  ((equal? p_s1 "#srdd")
	   (set! m1 p_m1)	   
	   (set! a0 (grsp-matrix-create "#rprnd" m1 m1)) ;; A
	   (set! a1 (grsp-matrix-create "#rprnd" m1 1)) ;; x
	   (set! a2 (grsp-matrix-create 0 m1 1)) ;; b
	   
	   (while (<= i1 (grsp-hm a0))

		  (set! n1 (array-ref a0 i1 i1))
		  (array-set! a0
			      (- (grsp-matrix-opio "#+r" a0 i1) n1)
			      i1
			      i1)
		  
		  (set! i1 (in i1)))

	   (set! a2 (grsp-matrix-opmm "#*" a0 a1))

	   ;; Compose results.
	   (set! res1 (list a0 a1 a2)))

	  ((equal? p_s1 "#mee1")

	   ;; Create a0.
	   (set! a0 (grsp-matrix-create 0 2 2))
	   (array-set! a0 -6 0 0)
	   (array-set! a0 3 0 1)
	   (array-set! a0 4 1 0)
	   (array-set! a0 5 1 1)

	   ;; Create a1.
	   (set! a1 (grsp-matrix-create 0 2 1))
	   (array-set! a1 1 0 0)
	   (array-set! a1 4 1 0)

	   ;; Create a2.
	   (set! a2 (grsp-matrix-create 6 1 1))
	   
	   ;; Compose results for "#mee1".
	   (set! res1 (list a0 a1 a2)))
	  
	  ((equal? p_s1 "#Dirac")

	   ;; Define rows and cols.
	   (set! m1 4)
	   (set! n1 4) 

	   ;; Create matrix model.
	   (set! aa (grsp-matrix-create z0p0p m1 n1))
	   
	   ;; Create a0.
	   (set! a0 (grsp-matrix-cpy aa))
	   (array-set! a0 z1p0p 0 0)
	   (array-set! a0 z1p0p 1 1)
	   (array-set! a0 z1n0p 2 2)
	   (array-set! a0 z1n0p 3 3)
	   
	   ;; Create a1.
	   (set! a1 (grsp-matrix-cpy aa))
	   (array-set! a1 z1p0p 0 3)
	   (array-set! a1 z1p0p 1 2)
	   (array-set! a1 z1n0p 2 1)
	   (array-set! a1 z1n0p 3 0)
	   
	   ;; Create a2.
	   (set! a2 (grsp-matrix-cpy aa))
	   (array-set! a2 z0p1n 0 3)
	   (array-set! a2 z0p1p 1 2)
	   (array-set! a2 z0p1p 2 1)
	   (array-set! a2 z0p1n 3 0)
	   
	   ;; Create a3.
	   (set! a3 (grsp-matrix-cpy aa))
	   (array-set! a3 z1p0p 0 2)
	   (array-set! a3 z1n0p 1 3)
	   (array-set! a3 z1n0p 2 0)
	   (array-set! a3 z1p0p 3 1)
	   
	   ;; Compose results for "#Dirac".
	   (set! res1 (list a0 a1 a2 a3)))) 
    
    res1))


;;;; grsp-matrix-create-fix - Creates pre-defined matrices of specific
;; sizes and values.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: matrix type.
;;
;;   - "#X": Qubit quantum gate. Pauli X. NOT.
;;   - "#Y": Qubit quantum gate. Pauli Y.
;;   - "#Z": Qubit quantum gate. Pauli Z.
;;   - "#QI": Qubit quantum gate. single qubit identity.
;;   - "#H": Qubit quantum gate. Hadamard.
;;   - "#P": Qubit quantum gate. Phase shift, requires also p_z1.
;;   - "#S": Qubit quantum gate. S.
;;   - "#T": Qubit quantum gate. T.
;;   - "#TDG" Quibit quantum gate. T dagger. COnjugater transpose of T.
;;     Tdg gate.
;;   - "#CX": Qubit quantum gate. Controlled X.
;;   - "#CY": Qubit quantum gate. Controlled Y.
;;   - "#CZ": Qubit quantum gate. Controlled Z.
;;   - "#CP": Qubit quantum gate. Controlled P, requires also p_z1 and
;;     state |11>.
;;   - "#RX": Qubit quantum gate. Rotation operator on X, requires also
;;     p_z1 (theta).
;;   - "#RY": Qubit quantum gate. Rotation operator on Y, requires also
;;     p_z1 (theta).
;;   - "#RZ": Qubit quantum gate. Rotation operator on Z, requires also
;;     p_z1 (theta).
;;   - "#SWAP": Qubit quantum gate. SWAP.
;;   - "#SQSWAP": Qubit quantum gate. Square root of SWAP.
;;   - "#CSWAP": Qubit quantum gate. CSWAP, Fredkin.
;;   - "#ISWAP": Qubit quantum gate. Imaginary SWAP.
;;   - "#SQISWAP": Qubit quantum gate. Square root of imaginary SWAP.
;;   - "#CCX": Qubit quantum gate. CCX. Toffoli.
;;   - "#SQX": Qubit quantum gate. SQX. Square root of X.
;;   - "#RXX": Qubit quantum gate. Ising coupling gate, X, requires also
;;     p_z1.
;;   - "#RYY": Qubit quantum gate. Ising coupling gate, Y, requires also
;;     p_z1.
;;   - "#RZZ": Qubit quantum gate. Ising coupling gate, Z, requires also
;;     p_z1.
;;   - "#Wilson": Wilson matrix.
;;   - "#corr": element wise correlation matrix (1 x 6), according to:
;;
;;     - [0,0]: row, element of first matrix.
;;     - [0,1]: col, element of first matrix.
;;     - [0,2]: value of element, first matrix.
;;     - [0,3]: row, element of second matrix.
;;     - [0,4]: col, element of second matrix.
;;     - [0,5]: value of element, second matrix.
;;
;;   - "#part": partition matrix. Used to partition a given matrix in
;;     several submatrices. Creates a 1 x 6 matrix (requires p_z1 for
;;     number of rows).
;;
;;     - Col0: lower m boundary (rows) in partitioned matrix.
;;     - Col1: higher m boundary (rows) in partitioned matrix.
;;     - Col2: lower n boundary (cols) in partitioned matrix.
;;     - Col3: higher n boundary (cols) in partitioned matrix.
;;     - Col4: row of submatrix in partition. 
;;     - Col5: col of submatrix in partition.
;;
;; - p_z1: complex, matrix scalar multiplier.
;;
;; Examples:
;;
;; - example7.scm.
;;
;; Notes:
;;
;; - See grsp0.grsp-s2dbc, grsp0.grsp-dbc2s.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [31][32][33][34][35][52].
;;
(define (grsp-matrix-create-fix p_s1 p_z1)
  (let ((res1 0)
	(res2 0)
	(res3 9)
	(res4 0)
	(res5 0)
	(res6 0)
	(z1 0.0+0.0i)
	(z2 1.0+1.0i)
	(z3 1.0-1.0i)
	(z4 1.0+0.0i)
	(z1p1p 1.0+1.0i)
	(z1p1n 1.0-1.0i)
	(z0p0p 0.0+0.0i)
	(z1p0p 1.0+0.0i)
	(z1n0p -1.0+0.0i)
	(z1n1n -1.0-1.0i)
	(z0p1p 0.0+1.0i)
	(z0p1n 0.0-1.0i))	

    (cond ((equal? p_s1 "#X")
	   (set! res1 (list-ref (grsp-matrix-create-set "#Pauli"
							0
							0
							0
							0)
				0)))
	  ((equal? p_s1 "#Y")
	   (set! res1 (list-ref (grsp-matrix-create-set "#Pauli"
							0
							0
							0
							0)
				1)))
	  ((equal? p_s1 "#Z")
	   (set! res1 (list-ref (grsp-matrix-create-set "#Pauli"
							0
							0
							0
							0)
				2)))
	  ((equal? p_s1 "#QI")	   
	   (set! res1 (grsp-matrix-create "#I" 2 2))
	   (set! res1 (grsp-matrix-opsc "#*" res1 z1p0p)))
	  ((equal? p_s1 "#CX")
	   (set! res1 (grsp-matrix-create z0p0p 4 4))
	   (array-set! res1 z1p0p 0 0)
	   (array-set! res1 z1p0p 1 1)
	   (array-set! res1 z1p0p 2 3)
	   (array-set! res1 z1p0p 3 2))
	  ((equal? p_s1 "#CY")
	   (set! res1 (grsp-matrix-create "#I" 4 4))
	   (set! res1 (grsp-matrix-opsc "#*" res1 z1p0p))
	   (array-set! res1 z0p0p 2 2)
	   (array-set! res1 z0p1n 2 3)
	   (array-set! res1 z0p1p 3 2)
	   (array-set! res1 z0p0p 3 3))	  
	  ((equal? p_s1 "#H")
	   (set! res1 (grsp-matrix-create z1p0p 2 2))
	   (array-set! res1 z1n0p 1 1)
	   (set! res1 (grsp-matrix-opsc "#*" res1 (/ 1 (sqrt 2)))))
	  ((equal? p_s1 "#P")
	   (set! res1 (grsp-matrix-create z0p0p 2 2))
	   (array-set! res1 z1p0p 0 0)
	   (array-set! res1 (grsp-complex-eif p_z1) 1 1))
	  ((equal? p_s1 "#CP")
	   (set! res1 (grsp-matrix-create "#I" 4 4))
	   (set! res1 (grsp-matrix-opsc "#*" res1 z1p0p))
	   (array-set! res1 (grsp-complex-eif p_z1) 3 3))
	  ((equal? p_s1 "#RX")
	   (set! res1 (grsp-matrix-create z0p0p 2 2))
	   (set! z1 (/ p_z1 2))
	   (array-set! res1 (cos z1) 0 0)
	   (array-set! res1 (grsp-mr 0 (sin z1)) 0 1)
	   (array-set! res1 (grsp-mr 0 (sin z1)) 1 0)
	   (array-set! res1 (cos z1) 1 1))
	  ((equal? p_s1 "#RY")
	   (set! res1 (grsp-matrix-create z0p0p 2 2))
	   (set! z1 (/ p_z1 2))
	   (array-set! res1 (cos z1) 0 0)
	   (array-set! res1 (* -1 (sin z1)) 0 1)
	   (array-set! res1 (sin z1) 1 0)
	   (array-set! res1 (cos z1) 1 1))
	  ((equal? p_s1 "#RZ")
	   (set! res1 (grsp-matrix-create z0p0p 2 2))
	   (array-set! res1 (grsp-eex (grsp-mr 0 (* -1 (/ p_z1 2)))) 0 0)
	   (array-set! res1 z0p0p 0 1)
	   (array-set! res1 z0p0p 1 0)	
	   (array-set! res1 (grsp-eex (grsp-mr 0 (/ p_z1 2))) 1 1))
	  ((equal? p_s1 "#S")	  
	   (set! res1 (grsp-matrix-create-fix "#QI" 0))
	   (array-set! res1 z0p1p 1 1))
	  ((equal? p_s1 "#T")	  
	   (set! res1 (grsp-matrix-create-fix "#QI" 0))
	   (array-set! res1 (grsp-complex-eif (/ (grsp-pi) 4)) 1 1))
	  ((equal? p_s1 "#TDG")
	   (set! res1 (grsp-matrix-create-fix "#T" 0))
	   (set! res1 (grsp-matrix-conjugate-transpose res1)))	  
	  ((equal? p_s1 "#CZ")
	   (set! res1 (grsp-matrix-create "#I" 4 4))
	   (array-set! res1 z1n0p 3 3)
	   (set! res1 (grsp-matrix-opsc "#*" res1 z1p0p)))
	  ((equal? p_s1 "#SWAP")
	   (set! res1 (grsp-matrix-create z0p0p 4 4))
	   (array-set! res1 z1p0p 0 0)
	   (array-set! res1 z1p0p 1 2)
	   (array-set! res1 z1p0p 2 1)
	   (array-set! res1 z1p0p 3 3))
	  ((equal? p_s1 "#SQSWAP")
	   (set! res1 (grsp-matrix-create-fix "#SWAP" 0))
	   (set! z2 (* 0.5 z2))
	   (set! z3 (* 0.5 z3))
	   (array-set! res1 z2 1 1)
	   (array-set! res1 z2 2 2)
	   (array-set! res1 z3 1 2)
	   (array-set! res1 z3 2 1))
	  ((equal? p_s1 "#CSWAP")
	   (set! res1 (grsp-matrix-create "#I" 8 8))
	   (set! res1 (grsp-matrix-opsc "#*" res1 z1p0p))
	   (array-set! res1 z0p0p 5 5)
	   (array-set! res1 z1p0p 5 6)
	   (array-set! res1 z1p0p 6 5)
	   (array-set! res1 z0p0p 6 6))
	  ((equal? p_s1 "#ISWAP")
	   (set! res1 (grsp-matrix-create z0p0p 4 4))
	   (array-set! res1 z1p0p 0 0)
	   (array-set! res1 z0p1p 1 2)
	   (array-set! res1 z0p1p 2 1)
	   (array-set! res1 z1p0p 3 3))
	  ((equal? p_s1 "#SQISWAP")
	   (set! res1 (grsp-matrix-create z0p0p 4 4))
	   (set! z2 (/ 1 (sqrt 2)))
	   (set! z3 (* z2 z0p1p))
	   (array-set! res1 z1p0p 0 0)
	   (array-set! res1 z2 1 1)
	   (array-set! res1 z3 1 2)
	   (array-set! res1 z3 2 1)
	   (array-set! res1 z2 2 2)	   
	   (array-set! res1 z1p0p 3 3))	 	  
	  ((equal? p_s1 "#CCX")
	   (set! res1 (grsp-matrix-create "#I" 8 8))
	   (set! res1 (grsp-matrix-opsc "#*" res1 z1p0p))
	   (array-set! res1 z0p0p 6 6)
	   (array-set! res1 z0p0p 7 7)
	   (array-set! res1 z1p0p 6 7)
	   (array-set! res1 z1p0p 7 6))
	  ((equal? p_s1 "#SQX")
	   (set! res1 (grsp-matrix-create z1p1p 2 2))
	   (array-set! res1 z1p1n 0 1)
	   (array-set! res1 z1p1n 1 0)
	   (set! res1 (grsp-matrix-opsc "#*" res1 0.5)))	  
	  ((equal? p_s1 "#RXX")
	   (set! res1 (grsp-matrix-create z0p0p 4 4))
	   (set! z1 (/ p_z1 2))
	   (set! z2 (* (cos z1) z1p0p))
	   (set! z3 (* (sin z1) z0p1n))
	   (array-set! res1 z2 0 0)
	   (array-set! res1 z3 0 3)
	   (array-set! res1 z2 1 1)
	   (array-set! res1 z3 1 2)
	   (array-set! res1 z3 2 1)
	   (array-set! res1 z2 2 2)
	   (array-set! res1 z3 3 0)
	   (array-set! res1 z2 3 3))
	  ((equal? p_s1 "#RYY")
	   (set! res1 (grsp-matrix-create z0p0p 4 4))
	   (set! z1 (/ p_z1 2))
	   (set! z2 (* (cos z1) z1p0p))
	   (set! z3 (* (sin z1) z0p1n))
	   (set! z4 (* (sin z1) z0p1p))	   
	   (array-set! res1 z2 0 0)
	   (array-set! res1 z4 0 3)
	   (array-set! res1 z2 1 1)
	   (array-set! res1 z3 1 2)
	   (array-set! res1 z3 2 1)
	   (array-set! res1 z2 2 2)
	   (array-set! res1 z4 3 0)
	   (array-set! res1 z2 3 3))
	  ((equal? p_s1 "#RZZ")
	   (set! res1 (grsp-matrix-create z0p0p 4 4))
	   (set! z1 (/ p_z1 2))
	   (set! z2 (* z1 z0p1p))
	   (set! z3 (* z1 z0p1n))
	   (array-set! res1 z3 0 0)
	   (array-set! res1 z2 1 1)
	   (array-set! res1 z2 2 2)
	   (array-set! res1 z3 3 3))
	  ((equal? p_s1 "#corr")
	   (set! res1 (grsp-matrix-create 0 1 6)))
	  ((equal? p_s1 "#part")
	   (set! res1 (grsp-matrix-create 0 p_z1 6)))	  
	  ((equal? p_s1 "#Wilson")
	   (set! res1 (grsp-matrix-create 0 4 4))
	   (set! res1 (grsp-l2mr res1 (list 5 7 6 5) 0 0))
	   (set! res1 (grsp-l2mr res1 (list 7 10 8 7) 1 0))
	   (set! res1 (grsp-l2mr res1 (list 6 8 10 9) 2 0))
	   (set! res1 (grsp-l2mr res1 (list 5 7 9 10) 3 0))))
    
    res1))


;;;; grsp-matrix-create-dim - Generates a matrix of type p_s1 based on the
;; size of p_a1. This may be useful - for example - to create an identity
;; matrix of the size of a matrix you have without having to find out its
;; size specifically.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, structure,
;;   dimensionality, size
;;
;; Parameters:
;;
;; . p_s1: see grsp-matrix-create.
;; - p_a1: matrix.
;;
;; Output:
;;
;; - A matrix of the same dimensions of p_a1 filled with value p_s1.
;;
(define (grsp-matrix-create-dim p_s1 p_a1)
  (let ((res1 0)
	(a2 0))

    ;; Extract the number of rows and cols of p_a1 and create a new
    ;; matrix of type p_s1 with the same size.
    (set! a2 (grsp-matrix-te2 p_a1))
    (set! res1 (grsp-matrix-create p_s1
				   (array-ref a2 0 0)
				   (array-ref a2 0 1)))

    res1))


;;;; grsp-matrix-find - Find all occurrences of p_v1 in matrix p_a1 that
;; statisfy condition p_s1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: search criteria.
;;
;;   - "#=": searches for all elements equal to p_v1.
;;   - "#>": searches for all elements greather than p_v1.
;;   - "#<": searches for all elements smaller than p_v1.
;;   - "#>=": searches for all elements greather or equal than p_v1.
;;   - "#<=": searches for all elements smaller or equal than p_v1.
;;   - "#!=": searches for all elements not equal to p_v1.
;;
;; - p_a1: matrix.
;; - P_v1: reference value for searching.
;;
;; Sources:
;;
;; - [1][2][3][4].
;;
;; Output:
;;
;; - A matrix of m x 2 elements, being m the number of ocurrences that
;;   statisfy the search criteria. On row 0 goes the row coordinate of
;;   each element found, and on row 1 goes the corresponding col
;;   coordinate. Thus, this matrix shows both the number of found
;;   elements as well as their positions within p_a1.
;;
(define (grsp-matrix-find p_s1 p_a1 p_v1)
  (let ((res1 0)
	(i1 0)
	(j1 0)
	(k1 0)
	(c1 #f))
	      
    ;; Find the elements.
    (set! i1 (grsp-lm p_a1))
    (while (<= i1 (grsp-hm p_a1))
	   
	   (set! j1 (grsp-ln p_a1))
	   (while (<= j1 (grsp-hn p_a1))

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
			 ;; Create row1 or increase the number of its
			 ;; rows.
			 (cond ((equal? k1 1)				
				(set! res1 (grsp-matrix-create 0 1 2)))
			       ((> k1 1)				
				(set! res1 (grsp-matrix-subexp res1
							       1
							       0))))

			 ;; Fill a new row of res1 with data.
			 (array-set! res1 i1 (grsp-hm res1) 0)
			 (array-set! res1 j1 (grsp-hm res1) 1)
			 (set! c1 #f)))
		  
		  (set! j1 (+ j1 1)))
	   
	   (set! i1 (+ i1 1)))

    res1))
    

;;;; grsp-matrix-transpose - Transposes a matrix of shape m x n into
;; another with shape n x m.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix to be transposed.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [1][2][3][4].
;;
(define (grsp-matrix-transpose p_a1)
  (let ((res1 0)
	(a1 0))

    ;; Safety copy.
    (set! a1 (grsp-matrix-cpy p_a1))
    
    ;; Create new matrix with transposed shape.
    (set! res1 (grsp-matrix-create 0
				   (+ (- (grsp-hn a1) (grsp-ln a1)) 1)
				   (+ (- (grsp-hm a1) (grsp-lm a1)) 1)))

    ;; Row loop.
    (let loop ((i1 (grsp-lm a1)))
      (if (<= i1 (grsp-hm a1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln a1)))
		   (if (<= j1 (grsp-hn a1))

		       ;; Transpose coordinates.
		       (begin (array-set! res1 (array-ref a1 i1 j1) j1 i1)
			      
			      (loop (+ j1 1)))))		 
		 
		 (loop (+ i1 1)))))
   
    res1))


;;;; grsp-matrix-transposer - Transposes p_a1 p_n1 times.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_n1: number, [0, 4].
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-transposer p_a1 p_n1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-cpy p_a1))
    
    (cond ((< p_n1 0)	   
	   (set! p_n1 0))	  
	  ((> p_n1 4)	   
	   (set! p_n1 4)))

    (let loop ((i1 0))
      (if (< i1 p_n1)

	  (begin (set! res1 (grsp-matrix-transpose res1))
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-conjugate - Calculates the conjugate matrix of p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-conjugate p_a1)
  (let ((a1 0)
	(res1 0))

    (set! a1 (grsp-matrix-cpy p_a1))
    (set! res1 (grsp-matrix-opsc "#si" a1 0))

    res1))


;;;; grsp-matrix-conjugate-transpose - Calculates the conjugate transpose
;; matrix of p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, hermitian conjugate,
;;   adjoint, transjugate
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [40][41].
;;
(define (grsp-matrix-conjugate-transpose p_a1)
  (let ((a1 0)
	(res1 0))

    (set! a1 (grsp-matrix-cpy p_a1))
    (set! res1 (grsp-matrix-conjugate (grsp-matrix-transpose a1)))

    res1))


;;;; grsp-matrix-opio - Internal operations that produce a scalar result.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters;
;;
;; - p_s1: string representing the desired operation.
;;
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
;;
;; - p_a1: matrix. 
;; - p_l1: column or row number.
;;
;; Notes:
;;
;; - Value for argument p_l1 should be passed as 0 if not used. It is only
;;   needed for row and column operations.
;;
;; Output:
;;
;; - Numberic, scalar.
;;
;; Sources:
;;
;; - [1][2][3][4].
;;
(define (grsp-matrix-opio p_s1 p_a1 p_l1)
  (let ((a1 0)
	(res2 0)
	(n1 0)
	(l1 0)
	(i1 0)
	(j1 0)
	(k1 0))

    (set! a1 (grsp-matrix-cpy p_a1))
    (set! l1 p_l1)
    (set! k1 (grsp-hm a1))
    
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
    (set! i1 (grsp-lm a1))
    (while (<= i1 (grsp-hm a1))

	   (set! j1 (grsp-ln a1))
	   (while (<= j1 (grsp-hn a1))

		  (set! n1 (array-ref a1 i1 j1))
		  
		  (cond ((equal? p_s1 "#+")			 
			 (set! res2 (+ res2 n1)))
			((equal? p_s1 "#-")			 
			 (set! res2 (- res2 n1)))
			((equal? p_s1 "#*")			 
			 (set! res2 (* res2 n1)))			
			((equal? p_s1 "#/")			 
			 (set! res2 (/ res2 n1)))
			 
			;; Main diagonal operations.
			((equal? p_s1 "#+md")
			 
			 (cond ((equal? (grsp-gtels i1 j1) 0)	
				(set! res2 (+ res2 n1)))))
			
			((equal? p_s1 "#-md")
			 
			 (cond ((equal? (grsp-gtels i1 j1) 0)
				(set! res2 (- res2 n1)))))
			
			((equal? p_s1 "#*md")
			 
			 (cond ((equal? (grsp-gtels i1 j1) 0) 	
				(set! res2 (* res2 n1)))))
			
			((equal? p_s1 "#/md")
			 
			 (cond ((equal? (grsp-gtels i1 j1) 0)
				(set! res2 (/ res2 n1)))))

			;; Anti diagonal operations.
			((equal? p_s1 "#+ad")
			 
			 (cond ((equal? k1 (+ i1 j1))
				(set! res2 (+ res2 n1)))))
			
			((equal? p_s1 "#-ad")
			 
			 (cond ((equal? k1 (+ i1 j1))
				(set! res2 (- res2 n1)))))
			
			((equal? p_s1 "#*ad")
			 
			 (cond ((equal? k1 (+ i1 j1))
				(set! res2 (* res2 n1)))))
			
			((equal? p_s1 "#/ad")
			 
			 (cond ((equal? k1 (+ i1 j1))
				(set! res2 (/ res2 n1))))))
			
		  ;; Row operations.
		  (cond ((= l1 i1)
			 
			 (cond ((equal? p_s1 "#+r")
				(set! res2 (+ res2 n1)))
			       ((equal? p_s1 "#-r")
				(set! res2 (- res2 n1)))
			       ((equal? p_s1 "#*r")
				(set! res2 (* res2 n1)))
			       ((equal? p_s1 "#/r")
				(set! res2 (/ res2 n1))))))

		  ;; Column operations.
		  (cond ((= l1 j1)
			 
			 (cond ((equal? p_s1 "#+c")
				(set! res2 (+ res2 n1)))
			       ((equal? p_s1 "#-c")
				(set! res2 (- res2 n1)))
			       ((equal? p_s1 "#*c")
				(set! res2 (* res2 n1)))
			       ((equal? p_s1 "#/c")
				(set! res2 (/ res2 n1))))))

		  (set! j1 (+ j1 1)))
	   
	   (set! i1 (+ i1 1)))

    res2))


;;;; grsp-matrix-opsc - Performs an operation p_s1 between matrix p_a1 and
;; scalar p_v1 or a discrete operation on p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s: scalar operation.
;;
;;   - "#+": scalar sum.
;;   - "#-": scalar substraction.
;;   - "#*": scalar multiplication.
;;   - "#/": scalar division.
;;   - "#expt": applies expt function to each element of p_a1 (expt p_a1
;;     p_v1).
;;   - "#max": applies max function to each element of p_a1.
;;   - "#min": applies min function to each element of p_a1.
;;   - "#rw": replace all elements of p_a1 with p_v1 regardless of their
;;     value.
;;   - "#rprnd": replace all elements of p_a1 with pseudo random numbers
;;     in a normal distribution with mean 0.0 and standard deviation
;;     equal to p_v1.
;;   - "#si": applies (grsp-complex-inv "#si" z1) to each element z1 of
;;     p_a1 (complex conjugate).
;;   - "#is": applies (grsp-complex-inv "#is" z1) to each element z1 of
;;     p_a1 (sign inversion of real element of complex number).
;;   - "#ii": applies (grsp-complex-inv "#ii" z1) to each element z1 of
;;     p_a1 (sign inversion of both elements of a complex number).
;;
;; - p_a1: matrix.
;; - p_v1: scalar value.
;;
;; Notes:
;;
;; - You may need to use seed->random-state for pseudo random numbers.
;; - This function does not validate the dimensionality or boundaries of
;;   the matrices involved; the user or an additional shell function
;;   should take care of that.
;; - See grsp0.grsp-random-state-set.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [5][6].
;;
(define (grsp-matrix-opsc p_s1 p_a1 p_v1)
  (let ((a1 0)
	(res1 0)
	(n1 0)
	(i1 0)
	(j1 0))

    ;; Safety copy.
    (set! a1 (grsp-matrix-cpy p_a1))
    
    ;; Create holding matrix.
    (set! res1 (grsp-matrix-create res1
				   (+ (- (grsp-hm a1) (grsp-lm a1)) 1)
				   (+ (- (grsp-hn a1) (grsp-ln a1)) 1)))
    
    ;; Apply scalar operation.
    (set! i1 (grsp-lm a1))
    (while (<= i1 (grsp-hm a1))
	   
	   (set! j1 (grsp-ln a1))
	   (while (<= j1 (grsp-hn a1))
		  
		  (set! n1 (array-ref a1 i1 j1))
		  
		  (cond ((equal? p_s1 "#+")			 
			 (array-set! res1 (+ n1 p_v1) i1 j1))
			((equal? p_s1 "#-")			 
			 (array-set! res1 (- n1 p_v1) i1 j1))
			((equal? p_s1 "#*")			 
			 (array-set! res1 (* n1 p_v1) i1 j1))
			((equal? p_s1 "#/")			 
			 (array-set! res1 (/ n1 p_v1) i1 j1))
			((equal? p_s1 "#expt")			 
			 (array-set! res1 (expt n1 p_v1) i1 j1))
			((equal? p_s1 "#max")			 
			 (array-set! res1 (max n1 p_v1) i1 j1))
			((equal? p_s1 "#min")			 
			 (array-set! res1 (min n1 p_v1) i1 j1))
			((equal? p_s1 "#rw")			 
			 (array-set! res1 p_v1 i1 j1))			
			((equal? p_s1 "#rprnd")			 
			 (array-set! res1
				     (grsp-rprnd "#normal" 0.0 p_v1)
				     i1
				     j1))			
			((equal? p_s1 "#si")			 
			 (array-set! res1
				     (grsp-complex-inv p_s1 n1)
				     i1
				     j1))	
			((equal? p_s1 "#is")			 
			 (array-set! res1
				     (grsp-complex-inv p_s1 n1)
				     i1
				     j1))			
			((equal? p_s1 "#ii")			 
			 (array-set! res1
				     (grsp-complex-inv p_s1 n1)
				     i1
				     j1)))
		  
		  (set! j1 (+ j1 1)))
	   
	   (set! i1 (+ i1 1)))

    res1))


;;;; grsp-matrix-opew - Performs element-wise operation p_s1 between
;; matrices p_a1 and p_a2.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, hadamard, direct,
;;   schur
;;
;; Parameters:
;;
;; - p_s1: operation described as a string:
;;
;;   - "#+": sum.
;;   - "#-": substraction.
;;   - "#*": multiplication (Hadamard product).
;;   - "#/": division (Hadamard division).
;;   - "#expt": element wise (expt p_a1 p_a2).
;;   - "#max": element wise max function.
;;   - "#min": element wise min function.
;;   - "#=": copy if equal.
;;   - "#!=": copy if not equal.
;;
;; - p_a1: first matrix.
;; - p_a2: second matrix.
;;
;; Notes:
;;
;; - This function does not validate the dimensionality or boundaries of
;;   the matrices involved; the user or an additional shell function
;;   should take care of that.
;; - See grsp-matrix-opewc, grsp-matrix-opewl.
;;
;; Examples:
;;
;; - example3.scm
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-opew p_s1 p_a1 p_a2)
  (let ((a1 0)
	(a2 0)
	(res1 0)
	(n1 0)
	(n2 0)
	(i1 0)
	(j1 0))

    ;;Safety copies.
    (set! a1 (grsp-matrix-cpy p_a1))
    (set! a2 (grsp-matrix-cpy p_a2))
    
    ;; Create holding matrix.
    (set! res1 (grsp-matrix-create 0
				   (+ (- (grsp-hm a1) (grsp-ln a1)) 1)
				   (+ (- (grsp-hn a1) (grsp-ln a1)) 1)))

    ;; Apply element-wise operation.
    (set! i1 (grsp-lm a1))		 
    (while (<= i1 (grsp-hm a1))
	   
	   (set! j1 (grsp-ln a1))			
	   (while (<= j1 (grsp-hn a1))		  

		  (set! n1 (array-ref a1 i1 j1))
		  (set! n2 (array-ref a2 i1 j1))
		  
		  (cond ((equal? p_s1 "#+")			 
			 (array-set! res1 (+ n1 n2) i1 j1))
			((equal? p_s1 "#-")			 
			 (array-set! res1 (- n1 n2) i1 j1))
			((equal? p_s1 "#*")			 
			 (array-set! res1 (* n1 n2) i1 j1))
			((equal? p_s1 "#/")			 
			 (array-set! res1 (/ n1 n2) i1 j1))
			((equal? p_s1 "#expt")			 
			 (array-set! res1 (expt n1 n2) i1 j1))
			((equal? p_s1 "#max")			 
			 (array-set! res1 (max n1 n2) i1 j1))
			((equal? p_s1 "#min")			 
			 (array-set! res1 (min n1 n2) i1 j1))	
			((equal? p_s1 "#=")
			 
			 (cond ((equal? n1 n2)
				(array-set! res1 n1 i1 j1))))
			
			((equal? p_s1 "#!=")
			 
			 (cond ((equal? (equal? n1 n2) #f)
				(array-set! res1 n1 i1 j1)))))
			
		  (set! j1 (+ j1 1)))
	   
	   (set! i1 (+ i1 1)))

    res1))


;;;; grsp-matrix-opewl - Applies function grsp-matrix-opew succesively
;; to all elements of list p_l1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, hadamard, direct,
;;   schur
;;
;; Parameters:
;;
;; - p_s1: operation described as a string (see grsp-matrix-opew).
;; - p_l1; list of m x n matrices.
;;
;; Notes: 
;;
;; - See grsp-matrix-opew.
;;
(define (grsp-matrix-opewl p_s1 p_l1)
  (let ((res1 0)
	(a2 0)
	(l1 '())
	(ln 0))

    (set! res1 (list-ref p_l1 0))
    (set! l1 p_l1)
    (set! ln (length l1))
    
    ;; Cycle.
    (let loop ((j1 1))
      (if (< j1 ln)
	  
	  (begin (set! a2 (list-ref p_l1 j1))
		 (set! res1 (grsp-matrix-opew p_s1 res1 a2))
		 
		 (loop (+ j1 1)))))
    
    res1))


;;;; grsp-matrix-opfn - Applies function p_s to all elements of p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: function as per sources, described as a string:
;;
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
;;   - "#xlog2x": x * log(2) x.
;;   - "#xlognx": x * log(2.71) x.
;;   - "#xlog10x": x * log(10) x.
;;
;; - p_a1: matrix.
;;
;; Output;
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [7].
;;
(define (grsp-matrix-opfn p_s1 p_a1)
  (let ((res1 p_a1)
	(res3 0)
	(n1 0)
	(i1 0)
	(j1 0))
    
    ;; Create holding matrix.
    (set! res3 (grsp-matrix-create res3
				   (+ (- (grsp-hm res1) (grsp-ln res1))
				      1)
				   (+ (- (grsp-hn res1) (grsp-ln res1))
				      1)))

    ;; Apply bitwise operation.
    (set! i1 (grsp-lm res1))		 
    (while (<= i1 (grsp-hm res1))

	   (set! j1 (grsp-ln res1))			
	   (while (<= j1 (grsp-hn res1))		  

		  (set! n1 (array-ref res1 i1 j1))
		  
		  (cond ((equal? p_s1 "#abs")			 
			 (array-set! res3 (abs n1) i1 j1))
			((equal? p_s1 "#truncate")			 
			 (array-set! res3 (truncate n1) i1 j1))
			((equal? p_s1 "#round")			 
			 (array-set! res3 (round n1) i1 j1))
			((equal? p_s1 "#floor")			 
			 (array-set! res3 (floor n1) i1 j1))
			((equal? p_s1 "#ceiling")			 
			 (array-set! res3 (ceiling n1) i1 j1))
			((equal? p_s1 "#sqrt")			 
			 (array-set! res3 (sqrt n1) i1 j1))
			((equal? p_s1 "#sin")			 
			 (array-set! res3 (sin n1) i1 j1))
			((equal? p_s1 "#cos")			 
			 (array-set! res3 (cos n1) i1 j1))
			((equal? p_s1 "#tan")			 
			 (array-set! res3 (tan n1) i1 j1))
			((equal? p_s1 "#asin")			 
			 (array-set! res3 (asin n1) i1 j1))
			((equal? p_s1 "#acos")			 
			 (array-set! res3 (acos n1) i1 j1))
			((equal? p_s1 "#atan")			 
			 (array-set! res3 (atan n1) i1 j1))
			((equal? p_s1 "#exp")			 
			 (array-set! res3 (exp n1) i1 j1))
			((equal? p_s1 "#log")			 
			 (array-set! res3 (log n1) i1 j1))
			((equal? p_s1 "#log10")			 
			 (array-set! res3 (log10 n1) i1 j1))
			((equal? p_s1 "#sinh")			 
			 (array-set! res3 (sinh n1) i1 j1))
			((equal? p_s1 "#cosh")			 
			 (array-set! res3 (cosh n1) i1 j1))
			((equal? p_s1 "#tanh")			 
			 (array-set! res3 (tanh n1) i1 j1))
			((equal? p_s1 "#asinh")			 
			 (array-set! res3 (asinh n1) i1 j1))
			((equal? p_s1 "#acosh")			 
			 (array-set! res3 (acosh n1) i1 j1))
			((equal? p_s1 "#atanh")			 
			 (array-set! res3 (atanh n1) i1 j1))
			((equal? p_s1 "#xlog2x")			 
			 (array-set! res3 (* n1 (grsp-log 2 n1)) i1 j1))
			((equal? p_s1 "#xlognx")			 
			 (array-set! res3 (* n1 (log n1)) i1 j1))
			((equal? p_s1 "#xlog10x")			 
			 (array-set! res3 (* n1 (log10 n1)) i1 j1)))
		  
		  (set! j1 (+ j1 1)))
	   
	   (set! i1 (+ i1 1)))

    res3))


;;;; grsp-matrix-opmm - Performs operation p_s1 between matrices p_a1
;; and p_a2 producing a matrix as a result.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: operation described as a string:
;;
;;   - "#+": matrix to matrix sum.
;;   - "#-": matrix to matrix substraction.
;;   - "#*": matrix to matrix multiplication.
;;   - "#/": matrix to matrix pseudo-division.
;;   - "#(+): Kronecker sum."
;;   - "#(*): Kronecker product."
;;
;; - p_a1: first matrix.
;; - p_a2: second matrix.
;;
;; Notes:
;;
;; - This function does not validate the dimensionality or boundaries of
;;   the matrices involved; the user or an additional shell function
;;   should take care of that.
;; - See grsp-matrix-opmml.
;;
;; Examples:
;;
;; - example5.scm.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [36][37][38].
;;
(define (grsp-matrix-opmm p_s1 p_a1 p_a2)
  (let ((res1 0)
	(res3 0)
	(res5 0)
	(res6 0)
	(sum 0)
	(I1 0)
	(I2 0)
	(i1 0)
	(j1 0)
	(k1 0)
	(i2 0)
	(j2 0)
	(i3 0)
	(j3 0))  
		   
    ;; Create a default results matrix.
    (set! res3 (grsp-matrix-create res3
				   (+ (- (grsp-hm p_a1) (grsp-lm p_a1))
				      1)
				   (+ (- (grsp-hn p_a2) (grsp-ln p_a2))
				      1)))
    
    ;; Apply mm operation.
    (cond ((equal? p_s1 "#*")

	   (set! i1 (grsp-lm p_a1))
	   (while (<= i1 (grsp-hm p_a1))

		  (set! j1 (grsp-ln p_a2))
		  (while (<= j1 (grsp-hn p_a2))
			
			 (set! sum 0)
			 (set! k1 (grsp-ln p_a1))
			 (while (<= k1 (grsp-hn p_a1))

				(set! sum (+ sum
					     (* (array-ref p_a1 i1 k1)
						(array-ref p_a2 k1 j1))))
				
				(set! k1 (in k1)))

			 (array-set! res3 sum i1 j1)
			 
			 (set! j1 (in j1)))
		  
		  (set! i1 (in i1))))
	   
	  ((equal? p_s1 "#/")	   
	   
	   (set! i1 (grsp-lm p_a1))
	   (while (<= i1 (grsp-hm p_a1))

		  (set! j1 (grsp-ln p_a2))
		  (while (<= j1 (grsp-hn p_a2))
			
			 (set! sum 0)
			 (set! k1 (grsp-ln p_a1))
			 (while (<= k1 (grsp-hn p_a1))

				(set! sum (+ sum
					     (/ (array-ref p_a1 i1 k1)
						(array-ref p_a2 k1 j1))))
				
				(set! k1 (in k1)))

			 (array-set! res3 sum i1 j1)
			 
			 (set! j1 (in j1)))
		  
		  (set! i1 (in i1))))
	  
	  ((equal? p_s1 "#+")	   
	   (set! res3 (grsp-matrix-opew p_s1 p_a1 p_a2)))	  
	  ((equal? p_s1 "#-")	   
	   (set! res3 (grsp-matrix-opew p_s1 p_a1 p_a2)))	  
	  ((equal? p_s1 "#(+)")
	   (set! I1 (grsp-matrix-create "#I"
					(grsp-tm p_a2)
					(grsp-tm p_a2)))
	   (set! I2 (grsp-matrix-create "#I"
					(grsp-tm p_a1)
					(grsp-tm p_a1)))
	   (set! res5 (grsp-matrix-opmm "#(*)" p_a1 I2))
	   (set! res6 (grsp-matrix-opmm "#(*)" I1 p_a2))
	   (set! res3 (grsp-matrix-opmm "#+" res5 res6)))
	  ((equal? p_s1 "#(*)")
	   (set! res5 (grsp-matrix-cpy p_a2))
	   
	   ;; This requires a definition of the results matrix since the
	   ;; Kronecker product generates a matrix M of (m1*m2)*(n1*n2)
	   ;; size.	   
	   (set! res3 (grsp-matrix-create 0
					  (* (grsp-tm p_a1)
					     (grsp-tm p_a2))
					  (* (grsp-tn p_a1)
					     (grsp-tn p_a2))))

	   ;; Cycle over p_a1 and perform a scalar product between each
	   ;; element of p_a1 and matrix p_a2
	   (set! i3 (grsp-lm res3))
	   (set! j3 (grsp-ln res3))
	   (set! i1 (grsp-lm p_a1))
	   (while (<= i1 (grsp-hm p_a1))

		  (set! j3 (grsp-ln res3))
		  (set! j1 (grsp-ln p_a1))
		  (while (<= j1 (grsp-hn p_a1))

			 ;; Perform scalar product between p_a1(i1,j1)
			 ;; and p_b1.
			 (set! res5 (grsp-matrix-opsc "#*"
						      p_a2
						      (array-ref p_a1
								 i1
								 j1)))

			 ;; Paste res5 into res3.
			 (set! res3 (grsp-matrix-subrep res3 res5 i3 j3))

			 ;; Find the next position in res3 where to
			 ;; paste the next matrix resulting from the
			 ;; scalar product.
			 (set! j3 (+ j3 (grsp-tn p_a2)))
			 (set! j1 (in j1)))
		  
		  (set! i3 (+ i3 (grsp-tm p_a2)))
		  (set! i1 (in i1)))))
    
    res3))


;;;; grsp-matrix-opmml - Applies function grsp-matrix-opmm succesively
;; to all elements of list p_l1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, hadamard, direct,
;;   schur
;;
;; Parameters:
;;
;; - p_s1: operation described as a string (see grsp-matrix-opmm).
;; - p_l1; list of m x n matrices.
;;
;; Notes: 
;;
;; - See grsp-matrix-opmm.
;;
(define (grsp-matrix-opmml p_s1 p_l1)
  (let ((res1 0)
	(a2 0)
	(l1 '())
	(ln 0))

    (set! res1 (list-ref p_l1 0))
    (set! l1 p_l1)
    (set! ln (length l1))
    
    ;; Cycle.
    (let loop ((j1 1))
      (if (< j1 ln)
	  (begin (set! a2 (list-ref p_l1 j1))
		 
		 (set! res1 (grsp-matrix-opmm p_s1 res1 a2))
		 
		 (loop (+ j1 1)))))
    
    res1))


;;;; grsp-matrix-opmsc - Operations between two matrices that produce a
;; scalar result.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: operation described as a string:
;;
;;   - "#.R": dot product (real numbers).
;;   - "#.C": dot product (complex numbers).
;;   - "#*f": Frobenius inner product.
;;
;; Notes:
;;
;; - Real matrices should have the same dimensions.
;; - For complex matrices take into account transposition of p_a2.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [45][46][47][68].
;;
(define (grsp-matrix-opmsc p_s1 p_a1 p_a2)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(inf 0)
	(sup 0)
	(n1 0)
	(n2 0)
	(i1 0)
	(i2 0)
	(j1 0)
	(j2 0))

    (cond ((equal? p_s1 "#.R")
	   (set! res2 (grsp-matrix-opew "#*" p_a1 p_a2))
	   (set! res1 (grsp-matrix-opio "#+" res2 0)))
	  ((equal? p_s1 "#.C")
	   (set! res3 (grsp-matrix-conjugate-transpose p_a2))
	   (set! res1 (grsp-matrix-opmsc "#.R" res3 p_a1)))    
	  ((equal? p_s1 "#*f")
	   (set! res2 (grsp-matrix-conjugate-transpose p_a1))
	   (set! res3 (grsp-matrix-opmm "#*" res2 p_a2))
	   (set! res1 (grsp-matrix-opio "#+md" res3 0))))
	  
    res1))


;;;; grsp-matrix-cpy - Copies matrix p_a1, element wise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix to be copied.
;;
;; Examples:
;;
;; - example5.scm.
;;
;; Output:
;;
;; - Matrix. A copy of p_a1.
;;
(define (grsp-matrix-cpy p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-subcpy p_a1
				   (grsp-lm p_a1)
				   (grsp-hm p_a1)
				   (grsp-ln p_a1)
				   (grsp-hn p_a1)))    

    res1))


;;;; grsp-matrix-subcpy - Extracts a block or sub matrix from matrix
;; p_a1. The process is not destructive with regards to p_a1. The user
;; is responsible for providing correct boundaries since the function
;; does not check those parameters in relation to p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix to be partitioned.
;; - p_lm1: lower m boundary (rows).
;; - p_hm1: higher m boundary (rows).
;; - p_ln1: lower n boundary (cols).
;; - p_hn1: higher n boundary (cols).
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-subcpy p_a1 p_lm1 p_hm1 p_ln1 p_hn1)
  (let ((res1 p_a1)
	(res2 0)
	(i1 0)
	(i2 0)
	(j1 0)
	(j2 0))

    ;; Create submatrix.
    (set! res2 (grsp-matrix-create res2
				   (+ (- p_hm1 p_lm1) 1)
				   (+ (- p_hn1 p_ln1) 1)))
    
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


;;;; grsp-matrix-subrep - Replaces a submatrix or section of matrix p_a1
;; with matrix p_a2.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;; 
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;; - p_m1: row coordinate of p_a1 where to place the upper left corner
;;   of p_a2.
;; - p_n1: col coordinate of p_a1 where to place the upper left corner
;;   of p_a2.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-subrep p_a1 p_a2 p_m1 p_n1)
  (let ((res1 0)
	(i1 0)
	(j1 0)
	(i2 0)
	(j2 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Replacement cycle.
    (set! i2 (grsp-lm p_a2))
    (set! i1 p_m1)
    (while (<= i2 (grsp-hm p_a2))
	   
	   (set! j1 p_n1)
	   (set! j2 (grsp-ln p_a2))
	   (while (<= j2 (grsp-hn p_a2))
		  
		  (array-set! res1 (array-ref p_a2 i2 j2) i1 j1)
		  (set! j2 (+ j2 1))
		  
		  (set! j1 (+ j1 1)))
	   
	   (set! i2 (+ i2 1))
	   
	   (set! i1 (+ i1 1)))
    
    res1))


;;;; grsp-matrix-subdcn - Deletes row from matrix p_a1 that fulfills
;; condition p_s2 for column p_j1 with regards to value p_n2.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s2 query:
;;
;;   - "#=": equal.
;;   - "#>": greater.
;;   - "#<": less.
;;   - "#>=": greater or equal.
;;   - "#<=": less or equal.
;;   - "#!=": not equal.
;;
;; - p_a1: matrix.
;; - p_j1: col number to query.
;; - p_n2: element value to query according to p_s1 and p_j1.
;;
;; Notes:
;;
;; - Obsolete. Use grsp-matrix-row-delete p_s1 instead.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-subdcn p_s2 p_a1 p_j1 p_n2)
  (let ((res1 0)
	(i1 0)
	(b1 #f))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    (set! i1 (grsp-lm res1))
    (while (<= i1 (grsp-hm res1))
	   
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

	   (cond ((< p_j1 (grsp-ln res1))		  
		  (set! b1 #f))		 
		 ((> p_j1 (grsp-hn res1))		  
		  (set! b1 #f)))	   
	   
	   ;; Delete row, if applicable.
	   (cond ((equal? b1 #t)

		  ;; Delete row where the p_n1th col element has value
		  ;; p_n2.
		  (set! res1 (grsp-matrix-subdel "#Delr" res1 i1))
		  (set! b1 #f)

		  ;; Reset loop counter.
		  (set! i1 (- (grsp-lm res1) 1))))
	   
	   (set! i1 (+ i1 1)))
	   
    res1))


;;;; grsp-matrix-subdel - Deletes column or row p_n1 from matrix p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: string describing the required operation.
;;
;;   - "#Delc": delete column.
;;   - "#Delr": delete row. 
;;
;; - p_a1: matrix.
;; - p_n1: row or col number to delete.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-subdel p_s1 p_a1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(n1 0)
	(n2 0)
	(c1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(hm3 0)
	(ln3 0))	

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! n1 p_n1)
    
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
		  (set! res2 (grsp-matrix-subcpy res1
						 (+ lm1 1)
						 hm1
						 ln1
						 hn1)))
		 ((equal? n1 hm1)		  
		  (set! res2 (grsp-matrix-subcpy res1
						 lm1
						 (- hm1 1)
						 ln1
						 hn1)))		 
		 ((and (> n1 lm1) (< n1 hm1))		  
		  (set! res3 (grsp-matrix-subcpy res1
						 lm1
						 (- n1 1)
						 ln1
						 hn1))
		  (set! res4 (grsp-matrix-subcpy res1
						 (+ n1 1)
						 hm1
						 ln1
						 hn1))

		  ;; Get structural data from the third submatix.
		  (set! hm3 (grsp-matrix-esi 2 res3))
		  (set! ln3 (grsp-matrix-esi 3 res3))	

		  ;; Expand the third submatrix in order to paste to the
		  ;; fourth one.		    
		  (set! res3 (grsp-matrix-subexp res3
						 (+ 1
						    (- (grsp-hm res4)
						       (grsp-lm res4)))
						 0))
		  
		  ;; Move the data of the fourth submatrix to the
		  ;; expanded part of the third one.
		  (set! res2 (grsp-matrix-subrep res3
						 res4
						 (+ hm3 1)
						 ln3))))))
    
    res2))


;;;; grsp-matrix-subexp - Add p_am1 rows and p_an1 cols to a matrix p_a1,
;; increasing its size.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix to expand.
;; - p_am1: rows to add.
;; - p_an1: cols to add.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-subexp p_a1 p_am1 p_an1)
  (let ((res1 0))

    ;; Create expanded matrix.
    (set! res1 (grsp-matrix-create res1
				   (+ (- (+ (grsp-hm p_a1) p_am1)
					 (grsp-lm p_a1))
				      1) ;; ln
				   (+ (- (+ (grsp-hn p_a1)
					    p_an1)
					 (grsp-ln p_a1))
				      1)))
    
    ;; Copy to submatrix.
    ;; Row loop.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln p_a1)))
		   (if (<= j1 (grsp-hn p_a1))

		       (begin (array-set! res1
					  (array-ref p_a1 i1 j1)
					  i1
					  j1)
			      
			      (loop (+ j1 1)))))		 
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-is-equal - Returns #t if matrix p_a1 is equal to matrix
;; p_a2 (same dimensionality and same elements).
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;; 
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
;; Examples:
;;
;; - example5.scm
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-equal p_a1 p_a2)
  (let ((res1 0)
	(res2 0)
	(res4 #f)
	(res3 #f)
	(res5 0))

    ;; Safety copies.
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))    
    
    ;; Compare the size of both matrices.
    (cond ((= (grsp-lm res1) (grsp-lm res2))
	   
	   (cond ((= (grsp-hm res1) (grsp-hm res2))
		  
		  (cond ((= (grsp-ln res1) (grsp-ln res2))
			 
			 (cond ((= (grsp-hn res1) (grsp-hn res2))
				(set! res3 #t)
				(set! res4 #t)))))))))
    
    ;; If the size is the same, compare each element.
    (cond ((equal? res4 #t)
	   
	   ;; Row loop.
	   (let loop ((i1 (grsp-lm res1)))
	     (if (<= i1 (grsp-hm res1))

		 ;; Col loop.
		 (begin (let loop ((j1 (grsp-ln res1)))
			  (if (<= j1 (grsp-hn res1))

			      (begin (cond ((equal? (equal? (grsp-gtels (array-ref res1 i1 j1) (array-ref res2 i1 j1)) 0) #f)
					    (set! res5 (+ res5 1))))
				     
				     (loop (+ j1 1)))))		 
			
			(loop (+ i1 1)))))))

    (cond ((> res5 0)
	   (set! res3 #f)))

    res3))


;;;; grsp-matrix-is-square - Returns #t if matrix p_a1 is square (i.e.
;; m x m).
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-square p_a1)
  (let ((res1 p_a1)
	(res2 #f))

    (cond ((equal? (- (grsp-hm res1) (grsp-lm res1))
		   (- (grsp-hn res1) (grsp-ln res1)))
	   (set! res2 #t)))
    
    res2))


;;;; grsp-matrix-is-symmetric - Returns #t if p_a1 is a symmetrix matrix.
;; #f otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - For non-complex numbers.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-symmetric p_a1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-is-square p_a1) #t)	   
	   (set! res1 (grsp-matrix-is-equal p_a1 (grsp-matrix-transpose p_a1)))))

    res1))


;;;; grsp-matrix-is-diagonal - Returns #t if p_a1 is a square diagonal
;; matrix, #f otherise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-diagonal p_a1)
  (let ((res1 #f)
	(k1 0))

    (cond ((equal? (grsp-matrix-is-square p_a1) #t)

	   ;; Row loop.
	   (let loop ((i1 (grsp-lm p_a1)))
	     (if (<= i1 (grsp-hm p_a1))

		 ;; Col loop.
		 (begin (let loop ((j1 (grsp-ln p_a1)))
			  (if (<= j1 (grsp-hn p_a1))

			      (begin (cond ((equal? (equal? (array-ref p_a1 i1 j1) 0) #f)
					    
					    (cond ((equal? (equal? i1 j1) #f)				       
						   (set! k1 (+ k1 1))))))
				     
				     (loop (+ j1 1)))))		 
			
			(loop (+ i1 1)))))
	   
	   (cond ((equal? k1 0)		  
		  (set! res1 #t)))))

    res1))


;;;; grsp-matrix-is-hermitian - Returns #t if p_a1 is equal to its
;; conjugate transpose.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
;; Sources:
;;
;; - [40].
;;
(define (grsp-matrix-is-hermitian p_a1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-is-square p_a1) #t)
	   
	   (cond ((grsp-matrix-is-equal p_a1 (grsp-matrix-conjugate-transpose p_a1))		  
		  (set! res1 #t)))))

    res1))


;;;; grsp-matrix-is-binary - Returns #t if p_a1 contains only values 0
;; or 1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-binary p_a1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-find "#>" p_a1 1) 0)
	   
	   (cond ((equal? (grsp-matrix-find "#<" p_a1 0) 0)		  
		  (set! res1 #t)))))

    res1))


;;;; grsp-matrix-is-nonnegative - Returns #t if p_a1 contains only
;; values >= 0.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-nonnegative p_a1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-find "#<" p_a1 0) 0)	   
	   (set! res1 #t)))

    res1))


;;;; grsp-matrix-is-positive - Returns #t if p_a1 contains only
;; values > 0.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-positive p_a1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-find "#<=" p_a1 0) 0)	   
	   (set! res1 #t)))

    res1))


;;;; grsp-matrix-row-opar - Finds the inverse multiple res1 of
;; p_a1[p_m2, p_n2] so that p_a1[p_m2, p_n2] + ( p_a1[p_m1, p_n1]
;; * res1 ) = 0
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
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix 1.
;; - p_a2: matrix 2.
;; - p_m1: m coord of upper row element.
;; - p_n1: n coord of upper row element.
;; - p_m2: m coord of lower row element.
;; - p_n2: n coord of lower row element.
;;
;; Output:
;;
;; - Note that the function does not return a value but modifies the
;;   values of elements in two matrices directly.
;;
;; Sources:
;;
;; - [8].
;;
(define (grsp-matrix-row-opar p_a1 p_a2 p_m1 p_n1 p_m2 p_n2)
  (let ((res1 0))

    (set! res1 (* 1 (/ (array-ref p_a1 p_m2 p_n2)
		      (array-ref p_a1 p_m1 p_n1))))
    (array-set! p_a1 0 p_m2 p_n2)
    (array-set! p_a2 res1 p_m2 p_n2)

    res1))


;;;; grsp-matrix-row-opmm - Replaces the value of element p_a1[p_m1, p_n
;; with ( p_a1[p_m1, p_n1] * p_a2[p_m2, p_n2] ).
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix 1.
;; - p_a2: matrix 2.
;; - p_m1: m coord of p_a1 element.
;; - p_n1: n coord of p_a1 element.
;; - p_m2: m coord of p_a2 element.
;; - p_n2: n coord of p_a2 element.
;;
;; Output:
;;
;; - Note that the function does not return a value but modifies the
;;   values of elements in one matrix.
;;
;; Sources:
;;
;; - [8].
;;
(define (grsp-matrix-row-opmm p_a1 p_a2 p_m1 p_n1 p_m2 p_n2)  
  (array-set! p_a1 (* (array-ref p_a1 p_m1 p_n1)
		      (array-ref p_a2 p_m2 p_n2)) p_m1 p_n1))


;;;; grsp-matrix-row-opsc - Performs operation p_s1 between all elements
;; belonging to row p_m1 of matrix p_a1 and scalar p_v1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: operation described as a string:
;;
;;   - "#+": sum.
;;   - "#-": substraction.
;;   - "#*": multiplication.
;;   - "#/": division.
;;
;; Output:
;;
;; - Note that the function does not return a value but modifies the
;; values of elements in row p_m1 of matrix p_a1.
;;
;; Sources:
;;
;; - [8].
;;
(define (grsp-matrix-row-opsc p_s1 p_a1 p_m1 p_v1)
  
  (let loop ((j1 (grsp-lm p_a1)))
    (if (<= j1 (grsp-hn p_a1))

	(begin (cond ((equal? p_s1 "#+")		  
		      (array-set! p_a1
				  (+ (array-ref p_a1 p_m1 j1) p_v1)
				  p_m1
				  j1))		 
		     ((equal? p_s1 "#-")		  
		      (array-set! p_a1
				  (+ (array-ref p_a1 p_m1 j1) p_v1)
				  p_m1
				  j1))		 
		     ((equal? p_s1 "#*")		  
		      (array-set! p_a1
				  (* (array-ref p_a1 p_m1 j1) p_v1)
				  p_m1
				  j1))		 
		     ((equal? p_s1 "#/")		  
		      (array-set! p_a1
				  (+ (array-ref p_a1 p_m1 j1) p_v1)
				  p_m1
				  j1)))
	       
	       (loop (+ j1 1))))))


;;;; grsp-matrix-row-opsw - Swaps rows p_m1 and p_m2 in matrix p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: row of p_a1.
;; - p_m2: row of p_a1.
;;
;; Output:
;;
;; - Note that the function does not return a value but modifies the
;;   values of elements in matrix p_a1.
;;
;; Sources:
;;
;; - [8].
;;
(define (grsp-matrix-row-opsw p_a1 p_m1 p_m2)
  (let ((res1 p_a1)
	(res2 0)
	(res3 0))

    ;; Copy elements of p_a1, rows p_m1 and p_m2 to separate arrays.
    (set! res2 (grsp-matrix-subcpy p_a1
				   p_m1
				   p_m1
				   (grsp-ln p_a1)
				   (grsp-hn p_a1)))
    (set! res3 (grsp-matrix-subcpy p_a1
				   p_m2
				   p_m2
				   (grsp-ln p_a1)
				   (grsp-hn p_a1)))

    ;; Swap positions.
    (set! p_a1 (grsp-matrix-subrep p_a1 res2 p_m2 (grsp-ln p_a1)))
    (set! p_a1 (grsp-matrix-subrep p_a1 res3 p_m1 (grsp-ln p_a1)))))


;;;; grsp-matrix-decompose - Applies decomposition p_s1 to matrix p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: decomposition type.
;;
;;   - "#LUD": LU decomposition, Doolitle.
;;   - "#QRMG: QR decomposition, modified Gram-Schmidt.
;;   - "#LL": LL decomposition, Cholesky-Banachiewicz.
;;   - "#SVD": SVD decomposition.
;;
;; - p_a1: matrix to be decomposed.
;;
;; Notes:
;;
;; - This function does not perform viability checks on p_a1 for the 
;;   required operation; the user or an additional shell function should
;;   take care of that.
;;
;; Examples:
;;
;; - example5.scm, example17.scm.
;;
;; Output:
;;
;; - List of matrices.
;;
;; Sources:
;;
;; - [6][43][49][50][51][64][65][66].
;;
(define (grsp-matrix-decompose p_s1 p_a1)
  (let ((res1 '())
	(b1 #t)
	(A 0)
	(At 0)
	(AAt 0)
	(AtA 0)
	(AAtv 0)
	(AAtb 0)
	(AtAv 0)
	(AtAb 0)
	(L 0)
	(Lct 0)
	(M 0)
	(D 0)
	(Q 0)
	(R 0)
	(H 0)
	(S 0)
	(V 0)
	(Ve 0)
	(Vt 0)
	(U 0)
	(Ul 0)
	(i1 0)
	(j1 0)
	(k1 0)
	(sum 0)
	(fak 0)
	(n1 0)
	(n2 0)
	(m1 0))

    ;; Safety copy.
    (set! A (grsp-matrix-cpy p_a1))    
	   
    (cond ((equal? p_s1 "#QRMG")
	   (set! Q (grsp-matrix-create 0 (grsp-tm A) (grsp-tn A)))
	   (set! R (grsp-matrix-create 0 (grsp-tn A) (grsp-tn A)))
	   
	   (set! k1 (grsp-ln A))
	   (while (<= k1 (grsp-hn A))

		  ;; R
		  (set! sum 0)
		  (set! j1 (grsp-lm A))
		  (while (<= j1 (grsp-hm A))
			 (set! sum (+ sum (expt (array-ref A j1 k1) 2)))
			 (set! j1 (in j1)))
		  
		  (array-set! R (sqrt sum) k1 k1)

		  ;; Q
		  (set! j1 (grsp-lm A))
		  (while (<= j1 (grsp-hm A))

			 ;; To avoid div by zero errors.
			 (cond ((equal? (equal? (array-ref R k1 k1) 0) #f)
				(array-set! Q
					    (/ (array-ref A j1 k1)
					       (array-ref R k1 k1))
					    j1
					    k1)) ;; B
			       ((equal? (equal? (array-ref R k1 k1) 0) #t)
				(array-set! Q 0 j1 k1)))
			 
			 (set! j1 (in j1)))
		  
		  ;; A
		  (set! i1 (+ k1 1))
		  (while (<= i1 (grsp-hn A))
			 
			 (set! sum 0)
			 (set! j1 (grsp-lm A))
			 (while (<= j1 (grsp-hm A))
				(set! sum (+ sum
					     (* (array-ref A j1 i1)
						(array-ref Q j1 k1))))
				(set! j1 (in j1)))
				
			 (array-set! R sum k1 i1)
			 
			 (set! j1 (grsp-lm A))
			 (while (<= j1 (grsp-hm A))
				(array-set! A
					    (- (array-ref A j1 i1)
					       (* (array-ref R k1 i1)
						  (array-ref Q j1 k1)))
					    j1 i1)
				(set! j1 (in j1)))
				 
			 (set! i1 (in i1)))
		  
		  (set! k1 (in k1)))	   

	   ;; Compose results for QRMG.
	   (set! res1 (list Q R)))

	  ((equal? p_s1 "#SVD")

	   ;; Construct working matrices.
	   (set! AAt (grsp-matrix-mmt A))
	   (set! AtA (grsp-matrix-mtm A))

	   ;; Eigenvalues.
	   (set! AAtv (grsp-eigenval-qr "#QRMG" AAt 100))
	   (set! AtAv (grsp-eigenval-qr "#QRMG" AtA 100))

	   ;; Eigenvectors.
	   (set! AAtb (grsp-eigenvec AAt AAtv))
	   (set! AtAb (grsp-eigenvec AtA AtAv))

	   ;; U, Vt and S.
	   (set! Ul (grsp-eigenvec AAt AAtv))
	   (set! U (list-ref Ul 0))
	   (set! V (grsp-eigenvec AtA AtAv))
	   (set! S (grsp-matrix-opsc "#expt" AAt 0.5))
	   (set! Ve (list-ref V 0))
	   (set! Vt (grsp-matrix-transpose Ve))
	   	   
	   ;; Compose results for SVD (matrices U, S, Vt).	   
	   (set! res1 (list U S Vt)))

	  ((equal? p_s1 "#LL")

	   ;; Create matrix L based on the dimensions of A.
	   (set! L (grsp-matrix-create 0 (grsp-tm A) (grsp-tn A)))

	   ;; Cycle.
	   (set! i1 (grsp-lm A))
	   (while (<= i1 (grsp-hm A))

		  (set! j1 (grsp-lm A))
		  (while (<= j1 i1)

			 (set! sum 0)
			 (set! k1 (grsp-lm A))
			 (while (< k1 j1)
				(set! sum (+ sum (* (array-ref L i1 k1)
						    (array-ref L j1 k1))))
				(set! k1 (in k1)))

			 (cond ((equal? i1 j1)
				(array-set! L
					    (sqrt (- (array-ref A i1 i1)
						     sum))
					    i1
					    j1))			       
			       (else (array-set! L
						 (* (/ 1.0
						       (array-ref L
								  j1
								  j1))
						    (- (array-ref A
								  i1
								  j1)
						       sum))
						 i1
						 j1)))
				
			 (set! j1 (in j1)))

		  (set! i1 (in i1)))

	   (set! Lct (grsp-matrix-conjugate-transpose L))
	   
	   ;; Compose results for LL.
	   (set! res1 (list L Lct)))
	  
	  ((equal? p_s1 "#LUD")
	   	   
	   ;; Create L and U matrices of the same size as p_a1.
	   (set! L (grsp-matrix-create-dim "#I" A))
	   (set! U (grsp-matrix-create-dim 0 A))

	   (set! n1 (grsp-hm A))
	   (set! i1 (grsp-lm A))
	   (while (<= i1 n1)

		  ;; U
		  (set! k1 i1)
		  (while (<= k1 n1)

			 ;; Summation.
			 (set! sum 0)
			 (set! j1 (grsp-lm A))
			 (while (< j1 i1)
				(set! sum (+ sum
					     (* (array-ref L i1 j1)
						(array-ref U j1 k1))))
				(set! j1 (in j1)))

			 ;; Evaluation.
			 (array-set! U (- (array-ref A i1 k1) sum) i1 k1)
			 (set! k1 (in k1)))

		  ;; L
		  (set! k1 i1)
		  (while (<= k1 n1)

			 (set! b1 #t)
			 (cond ((= i1 k1)
				(set! b1 #f)
				(array-set! L 1 i1 i1)))
			 (cond ((equal? b1 #t)				
				(set! sum  0)

				;; Summation.
				(set! j1 (grsp-lm A))
				(while (< j1 i1)
				       (set! sum (+ sum
						    (* (array-ref L
								  k1
								  j1)
						       (array-ref U
								  j1
								  i1))))
				       (set! j1 (in j1)))

				;; Evaluation.
				(array-set! L (/ (- (array-ref A
							       k1
							       j1)
						    sum)
						 (array-ref U
							    i1
							    i1))
					    k1
					    i1)))
			 
			 (set! k1 (in k1)))
		  
		  (set! i1 (in i1)))
	   		  
	   ;; Compose results for LUD.
	   (set! res1 (list L U))))
	   
    res1))


;;;; grsp-matrix-density - Returns the density value of matrix p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-matrix-density p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(d1 0)
	(t1 0)
	(t2 0))

    (set! t1 (grsp-matrix-total-elements p_a1))
    (set! res1 (grsp-matrix-find "#=" p_a1 0))
    
    (cond ((equal? res1 0)	   
	   (set! d1 1)))
    
    (cond ((< d1 1)	   
	   (set! t2 (+ (- (grsp-hm res1) (grsp-lm res1)) 1))
	   (set! d1 (- 1 (/ t2 t1)))))

    ;; Compose ressults.
    (set! res2 d1)
    
    res2))


;;;; grsp-matrix-is-sparse - Returns #t if matrix density of p_a1 is
;; < 0.5, or #f otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-sparse p_a1)
  (let ((res1 #f))

    (cond ((< (grsp-matrix-density p_a1) 0.5)
	   (set! res1 #t)))
    
    res1))


;;;; grsp-matrix-is-symmetric-md - Returns #t if matrix p_a1 is
;; symmetric along its main diagonal; #f otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-symmetric-md p_a1)
  (let ((res1 #f)
	(d1 0))

    (cond ((equal? (grsp-matrix-is-square p_a1))

	   ;; Row loop.
	   (let loop ((i1 (grsp-lm p_a1)))
	     (if (<= i1 (grsp-hm p_a1))

		 ;; Col loop.
		 (begin (let loop ((j1 (grsp-ln p_a1)))
			  (if (<= j1 (grsp-hn p_a1))

			      (begin (cond ((equal? (array-ref p_a1 i1 j1)
						    (array-ref p_a1 j1 i1))
					    
					    (set! d1 (+ d1 1))))
				     
				     (loop (+ j1 1)))))		 
			
			(loop (+ i1 1)))))
	   
	   (cond ((equal? d1 (grsp-matrix-total-elements p_a1))		  
		  (set! res1 #t)))))

    res1))


;;;; grsp-matrix-total-elements - Calculates the number of elements in
;; matrix p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-matrix-total-elements p_a1)
  (let ((res1 0))

    (set! res1 (* (+ (- (grsp-hm p_a1) (grsp-lm p_a1)) 1)
		  (+ (- (grsp-hn p_a1) (grsp-ln p_a1)) 1)))
    
    res1))


;;;; grsp-matrix-total-element - Counts the number of ocurrences of
;; p_v1 in p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_v1: element value.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-matrix-total-element p_a1 p_v1)
  (let ((res1 0))

    ;; Row loop.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln p_a1)))
		   (if (<= j1 (grsp-hn p_a1))

		       (begin (cond ((equal? p_v1 (array-ref p_a1 i1 j1))
				     (set! res1 (+ res1 1))))
			      
			      (loop (+ j1 1)))))		 
		 
		 (loop (+ i1 1)))))    
    
    res1))

    
;;;; grsp-matrix-is-hadamard - Returns #t if matrix p_a1 is of Hadamard
;; type; #f otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
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
	   

;;;; grsp-matrix-is-markov - Returns #t if matrix p_a1 is of Markov
;; type; #f otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-markov p_a1)
  (let ((res1 #f)
	(res2 0)
	(res3 #t)
	(k1 0))

    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  (begin (set! res2 (grsp-matrix-subcpy p_a1
						i1
						i1
						(grsp-ln p_a1)
						(grsp-hn p_a1)))
		 
		 (cond ((equal? (grsp-matrix-is-nonnegative res2) #t) 
			(set! k1 (+ k1 (grsp-matrix-opio "#+" res2 0))))
		       (else (set! res3 #f)))
		 
		 (loop (+ i1 1)))))
    
    (cond ((equal? res3 #t)
	   
	   (cond ((equal? (/ k1 (+ (- (grsp-hm p_a1) (grsp-lm p_a1)) 1)) 1)		  
		  (set! res1 #t)))))

    res1))


;;;; grsp-matrix-is-signature - Returns #t if matrix p_a1 is of signature
;; type; #f otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-signature p_a1)
  (let ((res1 #f)
	(k1 0))

    ; Check if the matrix is diagonal.
    (cond ((equal? (grsp-matrix-is-diagonal p_a1) #t)    
	   (set! res1 #t)
	   
	   ;; Row loop.
	   (let loop ((i1 (grsp-lm p_a1)))
	     (if (<= i1 (grsp-hm p_a1))

		 ;; Col loop.
		 (begin (let loop ((j1 (grsp-ln p_a1)))
			  (if (<= j1 (grsp-hn p_a1))

			      (begin (cond ((equal? i1 j1)
					    
					    (cond ((equal? (abs (array-ref p_a1 i1 j1)) 1)				       
						   (set! k1 (+ k1 1)))				      
						  (else ((set! res1 #f))))))
				     
				     (loop (+ j1 1)))))		 
			
			(loop (+ i1 1)))))))
    
    res1))


;;;; grsp-matrix-is-single-entry - Returns #t if matrix p_a1 is of single
;; entry type for value p_v1; #f otherwise (extension of single entry
;; concept from ine to any value).
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_v1: value.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-single-entry p_a1 p_v1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-total-element p_a1 p_v1) 1)
	   
	   (cond ((equal? (- (grsp-matrix-total-elements p_a1) 1)
			  (grsp-matrix-total-element p_a1 0))
		  
		  (set! res1 #t)))))

    res1))


;;;; grsp-matrix-identify - Returns #t if matrix p_a1 is of type p_s1.
;; This function aggregates several specific identification functions
;; into one single interface.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: matrix type.
;;
;;   - "#I": identity.
;;   - "#AI": anti-identity.
;;   - "#Square".
;;   - "#S": symmetric.
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
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-identify p_s1 p_a1)
  (let ((res1 #f)
	(res2 0)
	(v1 #f))

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
	   (set! res1 (grsp-matrix-is-equal p_a1
					    (grsp-matrix-opmm "#*"
							      p_a1
							      p_a1))))	  
	  ((equal? p_s1 "#Square")	   
	   (set! v1 #t)
	   (set! res1 (grsp-matrix-is-square p_a1))))

    ;; Default identification by comparison call. Needs to be placed in a 
    ;; different conditional. Otherwise does not work well.
    (cond ((equal? v1 #f)	   
	   (set! res1 (grsp-matrix-is-equal p_a1
					    (grsp-matrix-create p_s1
								(+ (- (grsp-hm p_a1) (grsp-lm p_a1)) 1)
								(+ (- (grsp-hn p_a1) (grsp-ln p_a1)) 1))))))
    
    res1))


;;;; grsp-matrix-is-metzler - Returns #t if matrix p_a1 is of Metzler
;; type; #f otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-metzler p_a1)
  (let ((res1 #f)
	(i1 0)
	(j1 0)
	(k1 1))

    ;; First condition is that the matrix is square.
    (cond ((equal? (grsp-matrix-is-square p_a1) #t)

	   ;; Cycle.
	   (set! i1 (grsp-lm p_a1))
	   (set! res1 #t)
	   (while (<= i1 (grsp-hm p_a1))

		  (set! j1 (grsp-ln p_a1))
		  (while (<= j1 (grsp-hn p_a1))
			 
			 (cond ((< (array-ref p_a1 i1 j1) 0)
				
				(cond ((equal? (equal? i1 j1) #f)				       
				       (set! res1 #f)))))
			 
			 (set! j1 (+ j1 1)))
		  
		  (set! i1 (+ i1 1)))))

    res1))    


;;;; grsp-l2m - Casts a list p_l1 of n elements as a 1 x n matrix.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_l1: list.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-l2m p_l1)
  (let ((res1 (grsp-matrix-create 0 1 (length p_l1)))
	(n1 (- (length p_l1) 1)))

    (let loop ((i1 0))
      (if (<= i1 n1)

	  (begin (array-set! res1 (list-ref p_l1 i1) 0 i1)
		 
		 (loop (+ i1 1)))))

    res1))
    

;;;; grsp-m2l - Casts a 1 x n matrix p_a1 as a list of n elements.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-m2l p_a1)
  (let ((res1 '())
	(n1 0))

    ;; Create the list based on the dimensions of the matrix.
    (set! n1 (+ 1 (- (grsp-hn p_a1) (grsp-ln p_a1))))
    (set! res1 (make-list n1 0))

    ;; Cycle over the matrix and copy its elements to the list.
    (let loop ((i1 0))
      (if (< i1 n1)

	  (begin (list-set! res1 i1 (array-ref p_a1 0 i1))
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-m2v - Casts a matrix p_a1 of m x n elements as a 1 x (m x n)
;; vector.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Row vector ((1 x (m x n)) matrix).
;;
(define (grsp-m2v p_a1)
  (let ((res1 0)
	(j2 0))

    ;; Create empty vector.
    (set! res1 (grsp-matrix-create 0 1 (grsp-matrix-total-elements p_a1)))

    ; Cycle over p_a1 and put each matrix value on vector res1.
    
    ;; Row loop.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln p_a1)))
		   (if (<= j1 (grsp-hn p_a1))

		       (begin (array-set! res1
					  (array-ref p_a1
						     i1
						     j1)
					  0
					  j2)
			      (set! j2 (+ j2 1))		  
			      
			      (loop (+ j1 1)))))		 
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-dbc2mc - Fills a matrix of complex or complex-subset numbers
;; with the contents of a database containing serialized complex or
;; complex-subset numbers.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, database, serial
;;
;; Parameters:
;;
;; - p_db1: database name.
;; - p_q1: database query.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-dbc2mc p_db1 p_q1)
  (let ((res1 0))

    res1))


;;;; grsp-dbc2mc-csv - Fills a matrix of complex or complex-subset
;; numbers with the contents of a csv format database file containing
;; serialized complex or complex-subset numbers.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, database, serial
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_t1: table name.
;;
;; Output:
;;
;; - Matrix.
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

    ;; Create a list in which each line of the file becomes a list
    ;; element.
    (set! l2 (string-split s1 #\nl))
    
    ;; Process list l2.
    (set! j2 0)
    (set! hn2 (- (length l2) 2))
    (while (<= j2 hn2)

	   ;; Take an element from l2 and create list l3 of three elements
	   ;; being these the two matrix coordinates and the matrix
	   ;; element value.
	   (set! s2 (list-ref l2 j2))
	   (set! l3 (string-split s2 #\,))
	   
	   ;; Create res3 on the first instance; othewise add a row.
	   ;; This matrix will contain the numeric values of each file
	   ;; line.
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

    ;; Find the max values of cols 0 and 1 of res3 and use them as
    ;; dimensions to create the final matrix.
    (set! lm1 (array-ref (grsp-matrix-row-sort "#asc" res3 0) 0 0))
    (set! hm1 (array-ref (grsp-matrix-row-sort "#des" res3 0) 0 0))
    (set! ln1 (array-ref (grsp-matrix-row-sort "#asc" res3 1) 0 1))
    (set! hn1 (array-ref (grsp-matrix-row-sort "#des" res3 1) 0 1))
    (set! res1 (grsp-matrix-create 0 (+ (- hm1 lm1) 1) (+ (- hn1 ln1) 1)))

    ;; Once the matrix has been created, go over it and read each row,
    ;; pasting its third element on the position described by the
    ;; coordinates of res3.
    (set! i3 lm3)
    (while (<= i3 hm3)	   
	   (set! m1 (array-ref res3 i3 0))
	   (set! n1 (array-ref res3 i3 1))
	   (array-set! res1 (array-ref res3 i3 2) m1 n1)	   
	   (set! i3 (in i3)))
    
    res1))


;;;; grsp-mc2dbc - Creates a database table or dataset for complex or
;; complex subset numbers from matrix p_a1, which contains complex or
;; complex-subset numbers. 
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_d1: database name. If the name contains:
;;
;;   - ".db": creates an Sqlite database.
;;   - ".csv": creates a csv database (folder).
;    - ".h5": creates an HDF5 database. 
;;
;; - p_a1: matrix.
;; - p_t1: table name.
;;
;; Notes:
;;
;; - The database name must contain the strings ".db", ".h5" or ".csv"
;;   in its
;;   name for this function to work.
;;
(define (grsp-mc2dbc p_d1 p_a1 p_t1)
  
  (cond ((>= (string-contains p_d1 ".db") 0)	 
	 (grsp-mc2dbc-sqlite3 p_d1 p_a1 p_t1))	
	((>= (string-contains p_d1 ".csv") 0)	 
	 (grsp-mc2dbc-csv p_d1 p_a1 p_t1))	
	((>= (string-contains p_d1 ".h5") 0)	 
	 (grsp-mc2dbc-hdf5 p_d1 p_a1 p_t1))))
	

;;;; grsp-mc2dbc-sqlite3 - Creates a Sqlite3 table or dataset for complex
;; or complex subset numbers from matrix p_a1, which contains complex or
;; complex subset numbers. 
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, databases
;;
;; Parameters:
;;
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

    ;; Loop over p_a1 and extract each value and insert it into the new
    ;; table.
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


;;;; grsp-mc2dbc-hdf5 - Creates an HDF5 table or dataset for complex or
;; complex subset numbers from matrix p_a1, which contains complex or
;; complex subset numbers. 
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, databases
;;
;; Parameters:
;;
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

    ;; Loop over p_a1 and extract each value and insert it into the new
    ;; table.
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


;;;; grsp-mc2dbc-csv - Creates a csv table or dataset for complex or
;; complex subset numbers from matrix p_a1, which contains complex or
;; complex subset numbers. 
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, databases
;;
;; Parameters:
;;
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
    
    ;; Loop over p_a1 and extract each value and insert it into the new
    ;; table.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  
		  ;; Extract and analize each element of the matrix.
		  (set! ve (array-ref p_a1 i1 j1))

		  ;; Create the string record.
		  ;;
		  ;; - 0: row number.
		  ;; - 1: col number.
		  ;; - 2: value.
		  ;;
		  ;; If this is the last element of the matrix, do not
		  ;; add the new line character at the end of the string.
		  ;;
		  (cond ((equal? (and (>= j1 hn1) (>= i1 hm1)) #t)
			 (set! s1 (strings-append (list (grsp-n2s i1)
							s2
							(grsp-n2s j1)
							s2
							(grsp-n2s ve))
						  0)))
			
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
;; matrix p_a1. Data format is identical to grsp csv tables except that
;; commas are replaced by spaces.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, databases, gnuplot
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_a1: matrix.
;; - p_t1: gnuplot data file name.
;;
;; Sources:
;;
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
    
    ;; Loop over p_a1 and extract each value and insert it into the new
    ;; table.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  
		  ;; Extract and analize each element of the matrix.
		  (set! ve (array-ref p_a1 i1 j1))

		  ;; Create the string record.
		  ;;
		  ;; - 0: row number.
		  ;; - 1: col number.
		  ;; - 2: value.
		  ;;
		  ;; If this is the last element of the matrix, do not
		  ;; add the
		  ;; new line character at the end of the string.
		  ;;
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
;;
;; - functions, algebra, matrix, matrices, vectors, databases, gnuplot
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_a1: matrix.
;; - p_t1: gnuplot data file name.
;;
;; Sources:
;;
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
    
    ;; Loop over p_a1 and extract each value and insert it into the new
    ;; table.
    (set! i1 lm1)
    (while (<= i1 hm1)

	   (set! j1 ln1)
	   (while (<= j1 hn1)
    		  
		  ;; Extract and analize each element of the matrix.
		  (set! ve (array-ref p_a1 i1 j1))

		  ;; Create the string record.
		  (cond ((> j1 ln1)			 
			 (set! s1 (strings-append (list s1
							(grsp-n2s ve))
						  1)))			
			(else (set! s1 (grsp-n2s ve))))
		  
		  (set! j1 (+ j1 1)))

	   ;; Add the line string to the file string.
	   (cond ((> i1 lm1)		  
		  (set! s3 (strings-append (list s3 "\n" s1) 0)))
		 (else (set! s3 (strings-append (list s3 s1) 0))))
	   
	   (set! i1 (+ i1 1)))

    (grsp-save-to-file s3 rp "w")))
  

;;;; grsp-matrix-interval-mean - Creates a 3 x 1 matrix containing the
;; following values:
;;
;; - (- p_n1 p_min).
;; - (p_min + p_max) / 2.
;; - (+ p_n1 p_max).
;;
;; thus creating an interval [p_min, p_max] in which:
;;
;; - p_min <= p_n1 <= p_max.
;; - p_min <= m <= p_max, being m the mean value of l1 and h1 (see var
;;   def).
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, intervals, mean,
;;   average
;;
;; Parameters:
;;
;; - p_n1: reference value.
;; - p_min: what needs to be substracted to p_n1 to define the lower
;;   boundary of the interval.
;; - p_max: what needs to be added to p_n1 to define the higher boundary
;;   of the interval.
;;
;; Output:
;;
;; - A 3 x1 matrix in which:
;;
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


;;;; grsp-matrix-determinant-lu - Finds the determinant of matrix p_a1
;; using the LU decompostion (Doolitle).  
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
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
    (set! a2 (grsp-matrix-decompose "#LUD" p_a1))
    (set! L (car a2))
    (set! U (car (cdr a2)))

    ;; Calculate the determinant of L
    (set! detl (grsp-matrix-opio "#*md" L 0))
    
    ;; Calculate the determinant of U.
    (set! detu (grsp-matrix-opio "#*md" U 0))

    ;; Calculate the determinant of p_a1.
    (set! res1 (* detl detu))
    
    res1))


;;;; grsp-matrix-determinant-qr - Finds the determinant of matrix p_a1
;; using the QR decompostion.  
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [9][10][11][12][13].
;;
(define (grsp-matrix-determinant-qr p_a1)
  (let ((res1 0)
	(a1 0)
	(Q 0)
	(R 0))

    ;; Safety copyy.
    (set! a1 (grsp-matrix-cpy p_a1))
    
    ;; Perform a QR decomposition over a1.
    (set! a1 (grsp-matrix-decompose "#QRMG" a1))
    (set! Q (car a1))
    (set! R (cadr a1))
    
    (set! res1 (abs (grsp-matrix-opio "#*md" R 0)))
    
    res1))


;;;; grsp-matrix-is-invertible - Returns #t if matrix si invertible if its
;; determinant is != 0; #f otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-invertible p_a1)
  (let ((res1 #t))

    (cond ((= (grsp-matrix-determinant-lu p_a1) 0)	   
	   (set! res1 #f)))
    
    res1))


;;;; grsp-eigenval-opio - Eigenvalue operations that return a scalar. 
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#*": product of all eigenvalues.
;;   - "#+": sum of all eigenvalues.
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Returns a scalar (zero if no proper string p_s1 is passed).
;;
;; Sources:
;;
;; - [14][15].
;;
(define (grsp-eigenval-opio p_s1 p_a1)
  (let ((res1 0))

    (cond ((equal? p_s1 "#*")	   
	   (set! res1 (grsp-matrix-determinant-lu p_a1)))	  
	  ((equal? p_s1 "#+")	   
	   (set! res1 (grsp-matrix-opio "#+md" p_a1 0))))
    
    res1))


;;;; grsp-matrix-sort - Sort elements in matrix p_a1 in ascending or
;; descending order.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: sort type.
;;
;;   - "#asc": ascending.
;;   - "#des": descending.
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-sort p_s1 p_a1)
  (let ((res1 0)
	(res2 0)
	(s1 "#asc")
	(f1 0)	
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
    ;; (set! res2 p_a1).
    (set! res2 (grsp-matrix-cpy p_a1))
    (set! res1 res2)
    (set! res1 (grsp-matrix-opsc "#*" res1 0))
        
    ;; Define sort order.
    (cond ((not (equal? p_s1 "#asc"))	   
	   (set! s1 "#des")))
    
    ;; Main cycle.
    (set! i1 (grsp-lm res1))
    (while (<= i1 (grsp-hm res1))
    
	   (set! j1 (grsp-ln res1))
	   (while (<= j1 (grsp-hn res1))

		  (set! v2 (array-ref res2 i1 j1))
		  (set! i3 (grsp-lm res2))
		  (set! j3 (grsp-ln res2))

		  ;; Compare v2 with the rest of the values.
		  (set! i2 (grsp-lm res2))
		  (while (<= i2 (grsp-hm res2))
			 
			 (set! j2 (grsp-ln res2))
			 (while (<= j2 (grsp-hn res2))

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
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - A 1 x 2 matrix containing the min and max values, respectively.
;;
(define (grsp-matrix-minmax p_a1)
  (let ((res1 0)
	(res2 0))	

    (set! res1 (grsp-matrix-create 0 1 2))
    (set! res2 (grsp-matrix-sort "#asc" p_a1))

    ;; Compose results.  
    (array-set! res1 (array-ref res2 (grsp-lm res2) (grsp-ln res2)) 0 0)
    (array-set! res1 (array-ref res2 (grsp-hm res2) (grsp-hn res2)) 0 1)
    
    res1))


;;;; grsp-matrix-trim - Trim matrix data. Deletes elements from p_a1 that
;; fulfill condition p_s1 regarding p_n1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: type of operation.
;;
;;   - "#=".
;;   - "#>".
;;   - "#<".
;;   - "#>=".
;;   - "#<=".
;;   - "!=".
;;
;; - p_a1: matrix
;; - p_n1: number.
;;
;; Output:
;;
;; - Trimmed data as a row vector (1 x n matrix).
;;
(define (grsp-matrix-trim p_s1 p_a1 p_n1)
  (let ((res1 0)	
	(i1 0)
	(j1 0)
	(n1 0)
	(b1 #f)
	(b2 #f))

    ;; Cycle and eval.
    (set! i1 (grsp-lm p_a1))
    (while (<= i1 (grsp-hm p_a1))
	   
	   (set! j1 (grsp-ln p_a1))
	   (while (<= j1 (grsp-hn p_a1))
		  
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
			
		  ;; Add value to vector. If this is the first pass,
		  ;; create the vector first. If not, increase the vector
		  ;; size by one element to contain the new value passed
		  ;; from p_a1.
		  (cond ((equal? b2 #t)
			 
			 (cond ((equal? b1 #f)
				
				;; Create empty vector.
				(set! res1 (grsp-matrix-create 0 1 1))
				(set! b1 #t))			       
			       ((equal? b1 #t)
				
				;; Add element to vector.
				(set! res1 (grsp-matrix-subexp res1
							       0
							       1))))

			 ;; Add approved number to the last element of the
			 ;; vector.
			 (array-set! res1
				     n1
				     (grsp-lm res1)
				     (grsp-hn res1))
			 (set! b2 #f)))		  
		  
		  (set! j1 (+ j1 1)))
	   
	   (set! i1 (+ i1 1)))      

    res1))


;;;; grsp-matrix-select - Select between p_a1 and p_a2 based on the value
;; of p_n1. 
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;; - p_n1:
;;
;;   - 0.
;;   - 1.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-select p_a1 p_a2 p_n1)
  (let ((res1 0))

    (cond ((= p_n1 0)	   
	   (set! res1 p_a1))	  
	  ((or (> p_n1 0) (< p_n1 0))	   
	   (set! res1 p_a2)))

    res1))


;;;; grsp-matrix-row-minmax - Finds the min or max value for column p_j1
;; in matrix p_a1 and returns a matrix containing the complete rows where
;; that value is found.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#min".
;;   - "#max".
;;
;; - p_a1: matrix.
;; - p_j1: column number.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
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
    
    ;; Eval.  Row loop.
    (let loop ((i1 lm1))
      (if (<= i1 hm1)

	  (begin (set! n2 (array-ref p_a1 i1 p_j1))
		 (set! n3 (array-ref res2 0 p_j1))
		 (set! res3 (grsp-matrix-subcpy p_a1 i1 i1 ln1 hn1))

		 ;; Compare.
		 (cond ((equal? p_s1 "#min")
			
			(cond ((< n2 n3)			 
			       (set! res2 res3))			
			      ((and (= n2 n3) (> i1 lm1))
			       (set! res2 (grsp-matrix-subexp res2 1 0))
			       (set! hm2 (grsp-matrix-esi 2 res2))
			       (set! res2 (grsp-matrix-subrep res2
							      res3
							      hm2
							      ln1)))))
		       
		       ((equal? p_s1 "#max")
			
			(cond ((> n2 n3)			 
			       (set! res2 res3))			
			      ((and (= n2 n3) (> i1 lm1))
			       (set! res2 (grsp-matrix-subexp res2 1 0))
			       (set! hm2 (grsp-matrix-esi 2 res2))
			       (set! res2 (grsp-matrix-subrep res2
							      res3
							      hm2
							      ln1))))))					 
		 
		 (loop (+ i1 1)))))
    
    ;; Compose results.
    (set! res1 res2)
    
    res1))


;;;; grsp-matrix-row-select - Select rows from matrix p_a1 for which
;; condition p_s1 is met with regards to value p_n1 in column p_j1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#<".
;;   - "#>".
;;   - "#>=".
;;   - "#<=".
;;   - "#!=".
;;   - "#=".
;;   - "#eq", string equals.
;;   - "#ct", string contains.
;;
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: value.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
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

    ;; Cycle and eval. Row loop.
    (let loop ((i1 lm1))
      (if (<= i1 hm1)

	  (begin (set! n2 (array-ref p_a1 i1 p_j1))
		 (set! res3 (grsp-matrix-subcpy p_a1 i1 i1 ln1 hn1))

		 ;; Compare.
		 (cond ((equal? p_s1 "#<")
			
			(cond ((< n2 p_n1)			 
			       (set! res2 (grsp-matrix-subexp res2 1 0))
			       (set! hm2 (grsp-matrix-esi 2 res2))
			       (set! res2 (grsp-matrix-subrep res2
							      res3
							      hm2
							      ln1)))))
		       
		       ((equal? p_s1 "#>")
			
			(cond ((> n2 p_n1)			 
			       (set! res2 (grsp-matrix-subexp res2 1 0))
			       (set! hm2 (grsp-matrix-esi 2 res2))
			       (set! res2 (grsp-matrix-subrep res2
							      res3
							      hm2
							      ln1)))))
		       
		       ((equal? p_s1 "#<=")
			
			(cond ((<= n2 p_n1)			 
			       (set! res2 (grsp-matrix-subexp res2 1 0))
			       (set! hm2 (grsp-matrix-esi 2 res2))
			       (set! res2 (grsp-matrix-subrep res2
							      res3
							      hm2
							      ln1)))))
		       
		       ((equal? p_s1 "#>=")
			
			(cond ((>= n2 p_n1)			 
			       (set! res2 (grsp-matrix-subexp res2 1 0))
			       (set! hm2 (grsp-matrix-esi 2 res2))
			       (set! res2 (grsp-matrix-subrep res2
							      res3
							      hm2
							      ln1)))))
		       
		       ((equal? p_s1 "#!=")
			
			(cond ((not (= n2 p_n1))			 
			       (set! res2 (grsp-matrix-subexp res2 1 0))
			       (set! hm2 (grsp-matrix-esi 2 res2))
			       (set! res2 (grsp-matrix-subrep res2
							      res3
							      hm2
							      ln1)))))

		       ((equal? p_s1 "#eq")
			
			(cond ((equal? n2 p_n1)			 
			       (set! res2 (grsp-matrix-subexp res2 1 0))
			       (set! hm2 (grsp-matrix-esi 2 res2))
			       (set! res2 (grsp-matrix-subrep res2
							      res3
							      hm2
							      ln1)))))


		       ((equal? p_s1 "#ct")
			
			(cond ((equal? (equal? (string-contains n2 p_n1) #f) #f)
			       (set! res2 (grsp-matrix-subexp res2 1 0))
			       (set! hm2 (grsp-matrix-esi 2 res2))
			       (set! res2 (grsp-matrix-subrep res2
							      res3
							      hm2
							      ln1)))))
		       
		       ((equal? p_s1 "#=")
			
			(cond ((= n2 p_n1)			 
			       (set! res2 (grsp-matrix-subexp res2 1 0))
			       (set! hm2 (grsp-matrix-esi 2 res2))
			       (set! res2 (grsp-matrix-subrep res2
							      res3
							      hm2
							      ln1))))))
		 
		 (loop (+ i1 1)))))
    
    ;; Compose results.
    (set! res1 (grsp-matrix-subdel "#Delr" res2 0))
    
    res1))


;;;; grsp-matrix-row-delete - Deletes rows from matrix p_a1 for which
;; condition p_s1 is met with regards to value p_n1 in column p_j1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_s1: string.
;;   - "#<".
;;   - "#>".
;;   - "#>=".
;;   - "#<=".
;;   - "#!=".
;;   - "#=".
;;
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: number.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [16].
;; ***
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


;;;; grsp-matrix-row-sort - Sorts rows from matrix p_a1 for which
;; condition p_s1 is met with regards to column p_j1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#asc".
;;   - "#des".
;;
;; - p_a1: matrix.
;; - p_j1: column number.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
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
		  
		  ;; Add a similar number of rows to res3 that exist in
		  ;; res2.
		  (set! res3 (grsp-matrix-subexp res3
						 (+ (- hm2 lm2) 1)
						 0))

		  ;; Copy the info from res2 to res3.
		  (set! res3 (grsp-matrix-subrep res3 res2 (+ hm3 1) ln3))

		  ;; Delete.
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


;;;; grsp-matrix-row-invert - Inverts the order of all rows in p_a1, so
;; that if p_a1 has rows [0, m] row 0 becomes row m, row 1 becomes row
;; m -1 ... and row m becomes row 0.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [16].
;;
(define (grsp-matrix-row-invert p_a1)
  (let ((res1 0)
	(res2 0)
	(i2 0)
	(i3 0))

    ;; Create seed matrix.
    (set! res1 (grsp-matrix-create 0 1 (+ (grsp-hn p_a1) 1)))     
    
    ;; Cycle.       
    (set! i2 (grsp-hm p_a1))    
    (set! i3 1)

    ;; Row loop.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;; Get row from input matrix (read in reverse row order).
	  (begin (set! res2 (grsp-matrix-subcpy p_a1
						i2
						i2
						(grsp-ln p_a1)
						(grsp-hn p_a1)))

		 ;; Expand seed matrix by one row.
		 (set! res1 (grsp-matrix-subexp res1 1 0))

		 ;; Copy extracted row to expanded row in seed matrix.
		 (set! res1 (grsp-matrix-subrep res1
						res2
						i3
						(grsp-ln p_a1)))

		 ;; Update counters.
		 (set! i2 (- i2 1))
		 (set! i3 (+ i3 1))
		 
		 (loop (+ i1 1)))))    
    
    ;; Compose results.
    (set! res1 (grsp-matrix-subdel "#Delr" res1 0))

    res1))


;;;; grsp-matrix-commit - Given that p_a2 is a processed submatrix of
;; p_a1, this function copies the data of p_a2 to p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;; - p_j1: column number that corresponds to the shared primary key.
;;
;; Notes:
;;
;; - p_a1 and p_a2 should share a common id or primary key contained in a
;;   column that will be used to identify each row of p_a1 that would be
;;   updated with the data of p_a2.
;; - This function might not work well if during the processing of p_a2
;;   the width (number of columns) has been changed.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [16].
;;
(define (grsp-matrix-commit p_a1 p_a2 p_j1)
  (let ((res1 0)
	(n1 0)
	(n2 0)
	(i1 0)
	(i2 0)
	(j2 0))  

    ;; Cycle p_a2.
    (set! i2 (grsp-lm p_a2))
    (while (<= i2 (grsp-hm p_a2))	   

	   ;; Get the key for each row of p_a2.
	   (set! n2 (array-ref p_a2 i2 p_j1))
	   
	   ;; Cycle p_a1.
	   (set! i1 (grsp-lm p_a1))
	   (while (<= i1 (grsp-hm p_a1))
	   
		  ;; Get the key for each row of p_a1.
		  (set! n1 (array-ref p_a1 i1 p_j1))

		  ;; If the keys for the current p_a2 and p_a1 rows are
		  ;; the same then copy data from p_a2 into p_a1.
		  (cond ((equal? n1 n2)

			 (set! j2 (grsp-ln p_a2))
			 (while (<= j2 (grsp-hn p_a2))
			
				(array-set! p_a1
					    (array-ref p_a2 i2 j2)
					    i1
					    j2)				
				(set! j2 (+ j2 1)))))			 

		  (set! i1 (+ i1 1)))
	   
	   (set! i2 (+ i2 1)))

    ;; Compose results.    
    (set! res1 p_a1)
    
    res1))


;;;; grsp-matrix-row-selectn - Selects from p_a1 only the rows specified
;; in list p_l1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_l1: list containing row numbers.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
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
	(hn3 0))

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

    ;; Cycle, main.
    (let loop ((j2 ln2))
      (if (<= j2 hn2)

	  (begin (let loop ((i3 lm3))
		   (if (<= i3 hn3)

		       ;; If row is the correct one, then copy.
		       (begin (cond ((equal? i3 (array-ref res2 0 j2))
				     
				     ;; Expand seed matrix by one row.
				     (set! res1 (grsp-matrix-subexp res1
								    1 0))

				     ;; Extract boundaries of the res1
				     ;; matrix.
				     (set! hm1 (grsp-matrix-esi 2 res1))
				     
				     ;; Copy row from res3 to res1.
				     (let loop ((j3 ln3))
				       (if (<= j3 hn3)

					   (begin (array-set! res1
							      (array-ref res3
									 i3
									 j3)
							      hm1 j3)
						  
						  (loop (+ j3 1)))))))
			      
			      (loop (+ i3 1)))))		 
		 
		 (loop (+ j2 1)))))
    
    ;; Compose results.
    (set! res1 (grsp-matrix-subdel "#Delr" res1 0))
    
    res1))


;;;; grsp-matrix-col-selectn - Selects from p_a1 only the columns
;; specified in list p_l1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_l1: list containing col numbers.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
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
;; condition p_s1 is met with regards to value p_n1 in col p_j1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#<".
;;   - "#>".
;;   - "#>=".
;;   - "#<=".
;;   - "#!=".
;;   - "#=".
;;
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: number.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [16].
;;
(define (grsp-matrix-col-select p_s1 p_a1 p_j1 p_n1)
  (let ((res1 0))

    ;; Create matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Operate with transposed matrix.
    (set! res1 (grsp-matrix-transpose res1))
    (set! res1 (grsp-matrix-row-select p_s1 p_a1 p_j1 p_n1)) ;;col

    ;; Transpose three times more to return to original state.
    (set! res1 (grsp-matrix-transposer res1 3))
    
    res1))


;;;; grsp-matrix-njoin - Natural join of p_a1 with key p_n1 and p_a2
;; with key p_n2.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_n1: column number, key of p_a1.
;; - p_a2: matrix.
;; - p_a2: column number, key of p_a2.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
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
    ;; for the current res1 and all the records of res3 that have the
    ;; same key.
    (set! i1 lm1)
    (while (<= i1 hm1)

	   ;; Read res1 key column for each row.
	   (set! res4 (grsp-matrix-row-select "#="
					      res2
					      p_n2
					      (array-ref res1 i1 p_n1)))

	   ;; Extract the boundaries of the res4 matrix, which contains
	   ;; the rows SELECTed from res2.
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
			 (array-set! res3
				     (array-ref res2 i1 j2)
				     hm3
				     (+ j1 j2))
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
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_n1: column number, key of p_a1.
;; - p_a2: matrix.
;; - p_a2: column number, key of p_a2.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
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


;;;; grsp-matrix-ajoin - Antijoin. Produces a matrix of elements of
;; p_a1 that cannot be njoined to p_a2 given p_n1 and p_n2.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_n1: column number, key of p_a1.
;; - p_a2: matrix.
;; - p_n2: column number, key of p_a2.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
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
    
    ;; Compare p_a1 and p_a2 to find out which tuples from p_a1 were
    ;; not joined into p_a2.
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

		  ;; Add the row to the results matrix.
		  (set! res4 (grsp-matrix-subcpy p_a1 i1 i1 ln1 hn1))
		  (set! res3 (grsp-matrix-subrep res3 res4 hm3 ln3))))
		  
	   (set! i1 (+ i1 1)))

    ;; Compose results.
    (set! res1 (grsp-matrix-subdel "#Delr" res3 0))
    
    res1))


;;;; grsp-matrix-supp - Given 1 x n matrix p_a1, it returns a 1 x (n - p)
;; vector that contains one instance per each element value contained in
;; p_a1. That is, it elimitates repeated instances of the elements of
;; p_a1 and returns its domain subset.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix ( 1 x n), (-inf.0, +inf.0).
;;
;; Output:
;;
;; - Row vector (1 x (n - p) matrix).
;;
;; Sources:
;;
;; - [17].
;;
(define (grsp-matrix-supp p_a1)
  (let ((res1 0)	
	(n1 0)
	(n2 0)
	(n3 0)
	(n4 0))

    ;; Create matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Extract the boundaries of the res2 matrix.
    (set! n3 -inf.0)
    (set! n4 +inf.0)

    ;; First loop.
    (let loop ((j1 (grsp-ln res1)))
      (if (<= j1 (grsp-hn res1))

	  ;; Second loop.
 	  (begin (set! n1 (array-ref res1 0 j1))
		 (set! n2 0)
		 
		 (let loop ((j2 (grsp-ln res1)))
		   (if (<= j2 (grsp-hn res1))

		       (begin (cond ((= n1 (array-ref res1 0 j2))
				     (set! n2 (+ n2 1))
				     
				     (cond ((> n2 1)				
					    (array-set! res1 n3 0 j2)))))
			      
			      (loop (+ j2 1)))))		 
		 
		 (loop (+ j1 1)))))
    
    ;; Compose results.
    (set! res1 (grsp-matrix-row-select "#>"
				       (grsp-matrix-transpose
					res1)
				       0
				       n3))
    (set! res1 (grsp-matrix-row-select "#<" res1 0 n4))
    (set! res1 (grsp-matrix-transposer res1 3))

    res1))


;;;; grsp-matrix-row-div - Relational division.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_n1: column number, key of p_a1.
;; - p_a2: matrix.
;; - p_n2: column number, key of p_a2.
;;
;; Notes:
;;
;; - Still needs some checking of the results.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [16].
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

    ;; Create safety matrices. 
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
	   
	   ;; Check if the current row in res1 can be njoined with all
	   ;;rows in res2.
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


;;;; grsp-matrix-row-update - Updates all rows setting value p_n2 in
;; column p_j2 from p_a1 where column p_j1 has a p_s1 relationship with
;; p_n1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#<".
;;   - "#>".
;;   - "#>=".
;;   - "#<=".
;;   - "#!=".
;;   - "#=".
;;
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: number.
;; - p_j2: column number.
;; - p_n2: number.
;;
;; Notes:
;;
;; - You cannot make changes to the primary key column using this update
;;   function.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-row-update p_s1 p_a1 p_j1 p_n1 p_j2 p_n2)
  (let ((res1 0)
	(b1 #f)
	(n1 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Row loop.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  (begin (set! n1 (array-ref res1 i1 p_j1))
		 
		 (cond ((equal? p_s1 "#<")

			(cond ((< n1 p_n1)
			       (set! b1 #t))))
		       
		       ((equal? p_s1 "#>")

			(cond ((> n1 p_n1)
			       (set! b1 #t))))
		       
		       ((equal? p_s1 "#<=")

			(cond ((<= n1 p_n1)
			       (set! b1 #t))))
		       
		       ((equal? p_s1 "#>=")

			(cond ((>= n1 p_n1)
			       (set! b1 #t))))		  

		       ((equal? p_s1 "#=")

			(cond ((= n1 p_n1)
			       (set! b1 #t))))

		       ((equal? p_s1 "#!=")

			(cond ((equal? (= n1 p_n1) #f)
			       (set! b1 #t)))))		 

		 ;; Update element.
		 (cond ((equal? b1 #t)
			(set! b1 #f)
			(array-set! res1 p_n2 i1 p_j2)))
		 
		 (loop (+ i1 1)))))
    
    res1))


;; grsp-matrix-te1 - Total elements of a row or column based on the
;; lower and higher coordinate values.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_lo: lower (lm or ln).
;; - p_hi: higher (hm or hn).
;;
;; Output:
;;
;; - Numeric.
;;  
(define (grsp-matrix-te1 p_lo p_hi)
  (let ((res1 0))

    (set! res1 (+ (- p_hi p_lo) 1))

    res1))


;; grsp-matrix-te2 - Total elements of a row or column. Returns
;; a 2 x 1 matrix containing the number of rows and columns of p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Numeric.
;;  
(define (grsp-matrix-te2 p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-create 0 1 2)) 
    (array-set! res1 (grsp-matrix-te1 (grsp-lm p_a1) (grsp-hm p_a1)) 0 0)
    (array-set! res1 (grsp-matrix-te1 (grsp-ln p_a1) (grsp-hn p_a1)) 0 1) 
    
    res1))


;; grsp-matrix-append - Appends all the rows of p_a2 below the rows of
;; p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
;; Output:
;;
;; - Matrix.
;;  
(define (grsp-matrix-row-append p_a1 p_a2)
  (let ((res1 0)
	(res2 0)
	(hm1 0)
	(ln1 0)
	(lm2 0)
	(hm2 0))

    ;; Create matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))

    ;; Extract boundaries of the first matrix.
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))

    ;; Extract boundaries of the second matrix.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    
    ;; Expand res1.
    (set! res1 (grsp-matrix-subexp res1 (grsp-matrix-te1 lm2 hm2) 0))
    
    ;; Append res2 to res1.
    (set! res1 (grsp-matrix-subrep res1 res2 (+ hm1 1) ln1))  
    
    res1))


;;;; grsp-matrix-lojoin - Left outer join.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_j1: column number, key of p_a1.
;; - p_a2: matrix.
;; - p_j2: column number, key of p_a2.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
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

    ;; We need to find if both tables are of equal width (number of
    ;; columns).
    (set! n3 (grsp-matrix-te1 ln3 hn3))
    (set! n4 (grsp-matrix-te1 ln4 hn4))

    ;; Add columns to one of the matrices, if necessary.
    (cond ((> n3 n4)	   
	   (set! res4 (grsp-matrix-subexp res4 lm4 (- n3 n4)))
	   (set! res4 (grsp-matrix-subrepv res4
					   (grsp-nan)
					   lm4
					   hm4
					   (+ hn4 1)
					   (grsp-matrix-esi 4 res4))))
	  ((< n3 n4)	   
	   (set! res3 (grsp-matrix-subexp res3 lm3 (- n4 n3)))
	   (set! res4 (grsp-matrix-subrepv res4
					   (grsp-nan)
					   lm3
					   hn3
					   (+ hn3 1)
					   (grsp-matrix-esi 4 res3)))))

    ;; Compose results.
    (set! res5 (grsp-matrix-row-append res3 res4))

    res5))


;;;; grsp-matrix-subrepv - Replaces a submatrix or section of matrix p_a1,
;; defined  by coordinates (p_m1, p_n1) and (p_m2, p_n2) with value p_v1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;; 
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_v1: value.
;; - p_m1: row coordinate of p_a1.
;; - p_m2: row coordinate of p_a1.
;; - p_n1: col coordinate of p_a1.
;; - p_n1: col coordinate of p_a1.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-subrepv p_a1 p_v1 p_m1 p_m2 p_n1 p_n2)
  (let ((res1 0))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Cycle and replace.
    ;; Row loop.
    (let loop ((i1 p_m1))
      (if (<= i1 p_m2)

	  ;; Col loop.
	  (begin (let loop ((j1 p_n1))
		   (if (<= j1 p_n2)

		       (begin (array-set! res1 p_v1 i1 j1)		       
			      
			      (loop (+ j1 1)))))
		 
		 (loop (+ i1 1)))))
    
    res1))


;; grsp-matrix-subswap - Swaps the contents of the submatrix defined by
;; coordinates (p_m1, p_n1) for its upper right vertex and  (p_m2, p_n2)
;; as its lowest left vertex with a submatrix with its upper right
;; vertex at (p_m3, p_n3) and the same size and shape as the first
;; submatrix.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;; 
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: row pos 1.
;; - p_n1: col pos 1.
;; - p_m2: row pos 2.
;; - p_n2: col pos 2.
;; - p_m3: row pos 3.
;; - p_n3: col pos 3.
;;
;; Output:
;;
;; - Matrix.
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


;;;; grsp-matrix-col-total-element - Counts the number of ocurrences of
;; elements in column p_j1 of matrix p_a1 for which relationship p_s1 is
;; fulfilled with regards to p_n1. 
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#<".
;;   - "#>".
;;   - "#>=".
;;   - "#<=".
;;   - "#!=".
;;   - "#=".
;;
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: number.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-matrix-col-total-element p_s1 p_a1 p_j1 p_n1)
  (let ((res1 0)
	(res2 0)
	(n2 0))

    ;; Extract column p_j1.
    (set! res2 (grsp-matrix-subcpy p_a1
				   (grsp-lm p_a1)
				   (grsp-hm p_a1)
				   p_j1
				   p_j1))

    ;; Row loop.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;;(begin (set! n2 (array-ref res2 i1 p_j1))
	  (begin (set! n2 (array-ref res2 i1 0))
		 
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
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-row-deletev - Deletes all rows where value p_n1 is found
;; at any column.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational, deletion
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_n1: number.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-row-deletev p_a1 p_n1)
  (let ((res1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Extract initial boundaries.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1)) 

    ;; Row loop.
    (let loop ((i1 lm1))
      (if (<= i1 hm1)

	  ;; Col loop.
	  (begin (let loop ((j1 ln1))
		   (if (<= j1 hn1)

		       (begin (set! res1 (grsp-matrix-row-delete "#="
								 res1
								 j1
								 p_n1))

			      ;; Extract current boundaries.
			      (set! lm1 (grsp-matrix-esi 1 res1))
			      (set! hm1 (grsp-matrix-esi 2 res1))
			      
			      (loop (+ j1 1)))))		 
		 
		 (loop (+ i1 1)))))    
    
    res1))


;;;; grsp-matrix-clear - Deletes all rows from matrix p_a1 where any of
;; the values contained in list p_l1 is found at any column.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_l1: number.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-clear p_a1 p_l1)
  (let ((res1 0)
	(res2 0))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Cast list as a matrix (simpler to deal here with a matrix tha a
    ;; list).
    (set! res2 (grsp-l2m p_l1))
    
    ;; Cycle over the matrix that was the list of values to look on
    ;; every part of p_a1.
    (let loop ((j2 (grsp-ln res2)))
      (if (<= j2 (grsp-hn res2))

	  (begin (set! res1 (grsp-matrix-row-deletev res1
						     (array-ref res2
								0
								j2)))
		 
		 (loop (+ j2 1)))))
    
    res1))


;;;; grsp-matrix-clearni - Deletes all rows from matrix p_a1 where any
;; of the values contained in list defined by (grsp-naninf) is found at
;; any column.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, deletion
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-clearni p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-clear p_a1 (grsp-naninf)))

    res1))


;;;; grsp-matrix-row-cartesian - Cartesian product of all rows of p_a1
;; and p_a2. Note that this function combines every row of one matrix
;; with every row of another matrix, and not every element with every
;; other element.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
;; Output:
;;
;; - Matrix.
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

    ;; Extract matrix info.
    (set! lm6 (grsp-matrix-esi 1 res6))
    (set! hm6 (grsp-matrix-esi 2 res6))
    (set! ln6 (grsp-matrix-esi 3 res6))
    (set! hn6 (grsp-matrix-esi 4 res6))     

    ;; cycle over res1 and combine each row of it with each rown of res2
    ;; in res3.
    (set! i1 lm1)
    (while (<= i1 hm1)

	   ;; Read a row from res1.
	   (set! res3 (grsp-matrix-subcpy res1 i1 i1 ln1 hn1))
	   (set! i2 lm2)

	   ;; Combine the current res1 row with all rows from res2.
	   (while (<= i2 hm2)

		  ;; Get a row from res2.
		  (set! res4 (grsp-matrix-subcpy res2 i2 i2 ln2 hn2))

		  ;; Col append rows from res3 and res4.
		  (set! res5 (grsp-matrix-col-append res3 res4))

		  ;; Add a fresh row to res5 in which to place the col
		  ;; appended rows.
		  (set! res6 (grsp-matrix-subexp res6 1 0))
		  (set! hm6 (grsp-matrix-esi 2 res6))

		  ;; Add the col appended rows.
		  (set! res6 (grsp-matrix-subrep res6 res5 hm6 ln6))

		  (set! i2 (+ i2 1)))
	   
	   (set! i1 (+ i1 1)))

    ;; Compose results.
    (set! res6 (grsp-matrix-subdel "#Delr" res6 0))
    
    res6))
	

;;;; grsp-matrix-col-append - Appends all the columns of p_a2 to the
;; right of p_a1 row by row.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
;; Output:
;;
;; - Matrix.
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
    
    ;; Compose results.
    (set! res1 (grsp-matrix-subrep res1 res2 lm1 (+ hn1 1)))
    
    res1))


;;;; grsp-matrix-col-find-nth - Finds the p_n1th element in p_s1 order
;; from column p_j1 in matrix p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#asc": ascending order.
;;   - "#des": descending order.
;;
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: element ordinal.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [16].
;;
(define (grsp-matrix-col-find-nth p_s1 p_a1 p_j1 p_n1)
  (let ((res1 0)
	(res2 0)
	(s1 "#>")
	(s2 "#asc")
	(n1 0))

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; We need to sort the matrix since we will later read the first row
    ;; of the selected ones.
    (cond ((equal? p_s1 "#des")	   
	   (set! s1 "#<")
	   (set! s2 "#des")))

    (set! n1 p_n1)
    (set! res1 (grsp-matrix-row-sort s2 res1 p_j1))

    ;; Perform the selection and then read the value of col p_j1 row 0.
    (let loop ((i1 1))
      (if (<= i1 n1)

	  (begin (cond ((> i1 1)		  
			(set! res1 (grsp-matrix-row-select s1
							   res1
							   p_j1
							   res2))))
		 
		 (set! res2 (array-ref res1 0 p_j1))	
		 
		 (loop (+ i1 1)))))    
    
    res2))


;;;; grsp-mn2ll - Casts m x n matrix p_a1 into a list of m elements
;; which are themselves lists of n elements each.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - A list of lists.
;;
(define (grsp-mn2ll p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 '())
	(res4 '()))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Create lists based on the dimensions of the matrix.
    (set! res3 (make-list (grsp-matrix-te1
			   (grsp-ln res1)
			   (grsp-hn res1))
			  0))
    (set! res4 (make-list (grsp-matrix-te1
			   (grsp-lm res1)
			   (grsp-hm res1))
			  0))
    
    ;; Cycle over the matrix and copy its elements to the list.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  ;; Read row i1 into res2.
	  (begin (set! res2 (grsp-matrix-subcpy res1
						i1
						i1
						(grsp-ln res1)
						(grsp-hn res1)))
		 
		 ;; Convert res2 to list res3.
		 (set! res3 (grsp-m2l res2))
		 
		 ;; Place list res3 into list res4.	   
		 (list-set! res4 i1 res3)
	  
	  (loop (+ i1 1)))))
    
    res4))


;;;; grsp-matrix-mutation - Produces random mutations in the values of
;; elements of matrix p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, genetic
;;
;; Parameters:
;;
;; - p_a1: matrix.
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
;; - Matrix.
;;
;; Sources:
;;
;; - [19][21].
;;
(define (grsp-matrix-mutation p_a1 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2)
  (let ((res1 0)
	(j2 0)
	(n1 0)
	(n2 0))	

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Row loop.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln res1)))
		   (if (<= j1 (grsp-hn res1))

		       ;; Replace element value by its noisy or blurred
		       ;; variant.
		       (begin (cond ((equal? (grsp-ifrprnd p_s1 p_u1 p_v1 p_n1) #t)			
				     (array-set! res1
						 (grsp-rprnd p_s2
							     p_u2
							     p_v2)
						 i1
						 j1)))
			      
			      (loop (+ j1 1)))))
	  
	  (loop (+ i1 1)))))
   
    res1))


;;;; grsp-matrix-col-mutation - Produces random mutations in the values of
;; elements of col p_n2 of matrix p_a1. Applies grsp-matrix-mutation to
;; the selected column instead of the whole matrix.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, genetic
;;
;; Parameters:
;;
;; - p_a1: matrix.
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
;; - p_n2: column to mutate.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [19][21].
;;
(define (grsp-matrix-col-mutation p_a1 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2 p_n2)
  (let ((res1 0)
	(res2 0))	

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Extract column to mutate.
    (set! res2 (grsp-matrix-subcpy res1
				   (grsp-lm res1)
				   (grsp-hm res1)
				   p_n2
				   p_n2))    

    ;; Mutate res2.
    (set! res2 (grsp-matrix-mutation res2
				     p_n1
				     p_s1
				     p_u1
				     p_v1
				     p_s2
				     p_u2
				     p_v2))

    ;; Compose results.
    (set! res1 (grsp-matrix-subrep res1 res2 (grsp-lm res1) p_n2))
    
    res1))


;;;; grsp-matrix-col-lmutation - Produces random mutations in the values
;; of elements of list p_1 of columns of matrix p_a1. Applies
;; grsp-matrix-mutation to the selected columns instead of the whole
;; matrix.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, genetic
;;
;; Parameters:
;;
;; - p_a1: matrix.
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
;; - p_l1: list of columns to mutate.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [19][21].
;;
(define (grsp-matrix-col-lmutation p_a1 p_n1 p_s1 p_u1 p_v1 p_s2 p_u2 p_v2 p_l1)
  (let ((res1 0)
	(j2 0)
	(l1 '()))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Cycle.
    (set! l1 p_l1)

    (let loop ((j1 0))
      (if (< j1 (length l1))

	  (begin (set! j2 (list-ref l1 j1))
		 (set! res1 (grsp-matrix-col-mutation res1
						      p_n1
						      p_s1
						      p_u1
						      p_v1
						      p_s2
						      p_u2
						      p_v2
						      j2))
		 
		 (loop (+ j1 1)))))    
    
    res1))


;;;; grsp-matrix-crossover - Performs a crossover of columns defined by
;; the intervals [p_ln1, p_hn1] and [p_ln2, p_hn2] between matrices p_a1
;; and p_a2.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, genetic
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_ln1: lower column number of the interval to swap (p_a1).
;; - p_hn1: higher column number of the interval to swap (p_a1).
;; - p_a2: matrix.
;; - p_ln2: lower column number of the interval to swap (p_a1).
;; - p_hn2: higher column number of the interval to swap (p_a1).
;;
;; Notes:
;;
;; - Matrices should have the same number of rows and columns.
;; - Intervals [p_ln1, p_hn1] and [p_ln2, p_hn2] may not have the same
;;   ordinals (indexes or col numbers) but must have the same number of
;;   columns.
;;
;; Output
;;
;; - A matrix containing the children obtained as a result of the swap.
;;
;; Sources:
;;
;; - [19][20].
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

    ;; Only perform this operation if matrices have the same
    ;; dimensionality.
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

	   ;; Extract sub matrices to swap.
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
;; crossover function in an aleatory fashion, while in others it might
;; not.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, genetic
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_ln1: lower column number of the interval to swap (p_a1).
;; - p_hn1: higher column number of the interval to swap (p_a1).
;; - p_a2: matrix.
;; - p_ln2: lower column number of the interval to swap (p_a1).
;; - p_hn2: higher column number of the interval to swap (p_a1).
;; - p_n1: crossover rate, [0, 1].
;; - p_s1: type of distribution.
;;
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;;
;; - p_u1: mean for crossover rate.
;; - p_v1: standard deviation for crossover rate.
;;
;; Notes:
;;
;; - See grsp-matrix-crossover for further details.
;; - See grsp0.grsp-random-state-set.
;;
;; Output
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [19][20].
;;
(define (grsp-matrix-crossover-rprnd p_a1 p_ln1 p_hn1 p_a2 p_ln2 p_hn2 p_n1 p_s1 p_u1 p_v1)
  (let ((res1 0))

    (cond ((equal? (grsp-ifrprnd p_s1 p_u1 p_v1 p_n1) #t)	   
	   (set! res1 (grsp-matrix-crossover p_a1
					     p_ln1
					     p_hn1
					     p_a2
					     p_ln2
					     p_hn2))))
    
    res1))


;;;; grsp-matrix-same_dims - Checks if p_a1 and p_a2 have the same
;; number of rows and columns.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
;;   - Returns #t if both matrices have the same number of rows and
;;     columns.
;;   - #f otherwise.
;;
(define (grsp-matrix-same-dims p_a1 p_a2)
  (let ((res1 #f))

    (cond ((= (grsp-lm p_a1) (grsp-lm p_a2))
	   
	   (cond ((= (grsp-hm p_a1) (grsp-hm p_a2))
		  
		  (cond ((= (grsp-ln p_a1) (grsp-ln p_a2))
			 
			 (cond ((= (grsp-hn p_a1) (grsp-hn p_a2))
				
				(set! res1 #t)))))))))
    res1))


;;;; grsp-matrix-fitness-rprnd - Basic fitness function based on pseudo
;; - random numbers.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, genetic
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: row.
;; - p_n1: col.
;; - p_n2: fitness rate, [0, 1].
;; - p_s1: type of distribution.
;;
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;;
;; - p_u1: mean for fitness rate.
;; - p_v1: standard deviation for fitness rate.
;;
;; Notes:
;;
;; - This is just a convenience fitness function. You may want to create
;;   your own for your specific task.
;; - See grsp0.grsp-random-state-set.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-fitness-rprnd p_a1 p_m1 p_n1 p_n2 p_s1 p_u1 p_v1)
  (let ((res1 0))

    (array-set! p_a1 (* p_n2 (grsp-rprnd p_s1 p_u1 p_v1)) p_m1 p_n1)
    (set! res1 p_a1)

    res1))


;;;; grsp-matrix-selectg - Genetic selection.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, genetic
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_s2: type of distribution for individual selection.
;;
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;;
;; - p_u2: mean for individual selection.
;; - p_v2: standard deviation for individual selection.
;; - p_j1: column representing the fitness value.
;; - p_j2: column representing the normalized fitness value.
;; - p_j3: column representing the accumulated normalized fitness value.
;;
;; Notes:
;;
;; - You should perform operations such as mutation and fitness
;;   calculation on your dataset before using this function.
;;
;; Output:
;;
;; - Matrix. A subset of selected individuals (rows) from p_a1.
;;
;; Sources:
;;
;; - [22].
;;
(define (grsp-matrix-selectg p_a1 p_s2 p_u2 p_v2 p_j1 p_j2 p_j3)
  (let ((res1 0)
	(i1 0)
	(j2 0)
	(r1 0))

    ;; Normalize fitness values (p_j2) and accumulated normalized fitness.
    (set! j2 (grsp-matrix-opio "#+c" p_a1 p_j1))
    (set! i1 (grsp-lm p_a1))
    (while (<= i1 (grsp-hm p_a1))
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


;;;; grsp-matrix-keyon - On row or column p_n1 of matrix p_a1, as defined
;; by p_s1, the function creates a unique key starting on value p_n2 and
;; with incremental step p_n3.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: string
;;
;;   - "#row" will use row p_n1 as index.
;;   - "#col" will use column p_n1 as index.
;;
;; - p_a1: matrix.
;; - p_n1: number, will represent a row or column depending on p_s1.
;; - p_n2: initial value for key.
;; - p_n3: incremental step.
;;
;; Notes:
;;
;; - This function will overwrite anything on row or column p_n1.
;; - Do not use with set!
;; - Interstingly, you can use these keys to unequivocally identify
;;   anything; you can, for example, set a column wit unique identifiers
;;   within a matrix to point to specific kinds of files. That is, if you
;;   set column n as containing keys, each key can identify a txt or pdf
;;   file, for example, which is pointed from the matrix.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-keyon p_s1 p_a1 p_n1 p_n2 p_n3)
  (let ((res1 0)
	(i1 0)
	(i2 0)
	(h1 0)
	(b1 #f))

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))

    (set! i2 p_n2)
    (cond ((equal? p_s1 "#col")	   
	   (set! b1 #t)
	   (set! i1 (grsp-lm res1))
	   (set! h1 (grsp-hm res1)))	  
	  ((equal? p_s1 "#row")	   
	   (set! b1 #t)
	   (set! i1 (grsp-ln res1))
	   (set! h1 (grsp-hn res1))))

    ;; Cycle.
    (cond ((equal? b1 #t)
	   
	   (while (<= i1 h1)
		  
		  (cond ((equal? p_s1 "#row")			 
			 (set! res1 (array-set! p_a1 i2 p_n1 i1)))	
			((equal? p_s1 "#col")			 
			 (set! res1 (array-set! p_a1 i2 i1 p_n1))))

		  (set! i2 (+ i2 p_n3))		  
		  (set! i1 (in i1)))))
	   
    res1))


;;;; grsp-matrix-col-aupdate - Updates all elements of column p_n1 of
;; matrix p_a1, setting value p_n2 in them.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_n1: column number.
;; - p_n2: value to set on p_n1.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-col-aupdate p_a1 p_n1 p_n2)
  (let ((res1 0))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))
    
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  (begin (array-set! res1 p_n2 i1 p_n1)
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-row-selectc - Returns a list containing the result of a
;; grsp-matrix-row-select operation as well as the complement of it in two
;; matrices.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, relational
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#<".
;;   - "#>".
;;   - "#>=".
;;   - "#<=".
;;   - "#!=".
;;   - "#=".
;;
;; - p_a1: matrix.
;; - p_j1: column number.
;; - p_n1: number.
;;
;; Output
;;
;; - List.
;;
;; Sources:
;;
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

    ;; Compose results.
    (set! res1 (list res2 res3))
    
  res1))


;;;; grsp-matrix-is-empty - Returns #t if the matrix has no elements; #f
;; otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output
;;
;; - Boolean.
;;
(define (grsp-matrix-is-empty p_a1)
  (let ((res1 #t))

    (cond ((> (grsp-matrix-total-elements p_a1) 0)	   
	   (set! res1 #f))) 

    res1))


;;;; grsp-matrix-is-multiset - Returns #t if the matrix has repeated
;; elements; #f otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output
;;
;; - Boolean.
;;
;; Sources:
;;
;; - [24].
;;
(define (grsp-matrix-is-multiset p_a1)
  (let ((res1 0)
	(res2 #f)
	(n1 0)
	(n2 0)
	(b1 #f))

    ;; Create safety matrix. 
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Cycle rows.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  ;; Cycle cols.
	  (begin (let loop ((j1 (grsp-ln res1)))
		   (if (<= j1 (grsp-hn res1))

		       (begin (set! n2 (array-ref res1 i1 j1))
			      (set! n1 (grsp-matrix-total-element res1
								  n2))
			      
			      (cond ((> n1 1)			 
				     (set! b1 #t)
				     (set! i1 (grsp-hm res1))
				     (set! j1 (grsp-hn res1))))
			      
			      (loop (+ j1 1)))))
		 
		 (loop (+ i1 1)))))
    
    ;; Compose results.
    (set! res2 b1)

    res2))
    

;;;; grsp-matrix-argtype - Finds the type of each element of matrix p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - A matrix of the same dimensions and shape as p_a1 but containing the
;;   type of each one of its elements according to the following
;;   representation:
;;
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
;; Sources:
;;
;; - [grsp0.4][grsp0.5].
;;
(define (grsp-matrix-argtype p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0))
	
    ;; Create safety matrix. 
    (set! res2 (grsp-matrix-cpy p_a1))
    (set! res1 res2)		

    ;; Cycle rows.
    (let loop ((i1 (grsp-lm res2)))
      (if (<= i1 (grsp-hm res2))

	  ;; Cycle cols.
	  (begin (let loop ((j1 (grsp-ln res2)))
		   (if (<= j1 (grsp-hn res2))

		       (begin (cond ((list? (array-ref res2 i1 j1)) 
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
			      (cond ((equal? (and (> res3 5) (< res3 8)) #t)
				     
				     (cond ((inf? (array-ref res2 i1 j1))
					    (set! res3 9))
					   ((nan? (array-ref res2 i1 j1))
					    (set! res3 10)))))
			      
			      (array-set! res1 res3 i1 j1)
			      
			      (loop (+ j1 1)))))
		 
		 (loop (+ i1 1)))))
    
    res1))


;; grsp-matrix-argstru - Finds the data types of each column of an
;; n x m matrix.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - For an m x n matrix, returns a 1 x n matrix containing the codes that
;;   correspond to the type of each column according to:
;;
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
	(n1 0)
	(n2 0)
	(n3 0))

    ;; Create safety matrix. 
    (set! res2 (grsp-matrix-cpy p_a1))

    ;; Create argtype matrix.
    (set! res3 (grsp-matrix-argtype res2))

    ;; Create results matrix.
    (set! n3 (grsp-matrix-te1 (grsp-ln res3) (grsp-hn res3)))
    (set! res1 (grsp-matrix-create 0 1 n3))
    
    ;; Cycle.
    (set! n2 0)

    (let loop ((j3 (grsp-ln res3)))
      (if (<= j3 (grsp-hn res3))

	  (begin (set! n1 (array-ref res3 (grsp-lm res3) j3))
		 
		 (cond ((> n2 0)
			(array-set! res1 0 0 j3))
		       (else (array-set! res1 n1 0 j3)))
		 
		 (loop (+ j3 1)))))
    
    res1))


;;;; grsp-matrix-row-subrepal - Replaces row p_m1 of matrix p_a1 with the
;; values contained in list p_l1. If row p_m1 does not exist then a new
;; row is added to place the values of p_l1.
;;
;; Keywords:
;;
;; - functions, ann, neural network
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: rown number.
;; - p_l2: list of values to update in row p_m1 of matrix p_a1.
;;
;; Notes:
;;
;; - Make sure that p_l1 has as many elements as p_a1's rows.
;;
;; Output
;;
;; - Matrix.
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
    ;;
    ;; - Edit an existing row.
    ;; - Add a row at the bottom of the matrix.
    (cond ((< m1 lm1)	   
	   (set! b1 #t))	  
	  ((> m1 hm1)	   
	   (set! b1 #t)))

    (cond ((equal? b1 #t)
	   (set! res1 (grsp-matrix-subexp res1 1 0))
	   
	   ;; Extract boundaries since the matrix has changed
	   ;; due to expansion.
	   (set! lm1 (grsp-matrix-esi 1 res1))
	   (set! hm1 (grsp-matrix-esi 2 res1))
	   (set! m1 hm1)))	   

    ;; Compose results.
    (set! res1 (grsp-matrix-subrep res1 res2 m1 ln1))
    
    res1))


;;;; grsp-matrix-subdell - Deletes row p_m1 from matrix p_a1 if its
;; elements are respetively equal, in the same order, to those in list
;; p_l1. 
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: row number.
;; - p_l1: list.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-subdell p_a1 p_m1 p_l1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(b1 #f))

    ;; Cast list as matrix.
    (set! res2 (grsp-l2m p_l1))

    ;; Extract the requested row of the input matrix as a vector.
    (set! res3 (grsp-matrix-subcpy p_a1
				   p_m1
				   p_m1
				   (grsp-ln res2)
				   (grsp-hn res2)))

    ;; Compare.
    (set! b1 (grsp-matrix-is-equal res2 res3))

    (cond ((equal? b1 #t)
	   (set! res1 (grsp-matrix-subdel "#Delr" p_a1 p_m1))))
	  
    res1))


;;;; grsp-matrix-is-samedim - Returns #t if the dimensionality of matrix
;; p_a1 and matrix p_a2 is the same, but not necessarily have the same
;; elements.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;; 
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
;; Output:
;;
;; - Returns #t if both matrices have the same number of rows and
;;   columns; #f otherwise.
;;
(define (grsp-matrix-is-samedim p_a1 p_a2)
  (let ((res1 #f))

    ;; Compare the size of both matrices.
    (cond ((= (grsp-lm p_a1) (grsp-lm p_a2))
	   
	   (cond ((= (grsp-hm p_a1) (grsp-hm p_a2))
		  
		  (cond ((= (grsp-ln p_a1) (grsp-ln p_a2))
			 
			 (cond ((= (grsp-hn p_a1) (grsp-hn p_a2))
				
				(set! res1 #t)))))))))
    
    res1))


;;;; grsp-matrix-is-samediml - Applies grsp-matrix-is-samedim to all
;; elements of list p_l1
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;; 
;; Parameters:
;;
;; - p_l1: list of matrices.
;;
;; Output:
;;
;; - Returns #t if all matrices have the same number of rows and columns;
;;   #f otherwise.
;;
(define (grsp-matrix-is-samediml p_l1)
  (let ((res1 #t)
	(a0 0)
	(a1 0)
	(b1 #f))

    ;; All matrices will be compared to the first one.
    (set! a0 (list-ref p_l1 0))

    (let loop ((j1 1))
      (if (< j1 (length p_l1))

	  (begin (set! a1 (list-ref p_l1 j1))
		 (set! b1 (grsp-matrix-is-samedim a0 a1))

		 ;; If one anomalous matrix is found is enough to stop
		 ;; the process and return #f.
		 (cond ((equal? b1 #f)
			(set! res1 #f)
			(set! j1 (length p_l1))))
		 
		 (loop (+ j1 1)))))
        
    res1))


;;;; grsp-matrix-fill - Creates a matrix of the same dimensions as p_a1
;; Filled with value p_n1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;; 
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-fill p_a1 p_n1)
  (let ((res1 0))
   
    (set! res1 (grsp-matrix-create p_n1 (grsp-tm p_a1) (grsp-tn p_a1)))

    res1))


;;;; grsp-matrix-fdif - Find differences between matrices p_a1 and p_a2,
;; This function returns a boolean-numeric matrix in which true
;; (difference found) is expressed as the number one and false
;; (difference not found) is represented by zero if both matrices have
;; the same dimensions, or one matrix of the same dimensions as p_a1 with
;; NaN as unique value if p_a1 and p_a2 are of different size.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;; 
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
;; Output:
;;
;; - A matrix of the same dimensions as p_a1 and p_a2 if they have the
;;   same size, containing elements with value 1 wherever the elements of
;;   the same coordinates in p_a1 and p_a2 are different, or 0 otherwise.
;; - A matrix of the same dimensions as p_a1, with NaN as values, if
;;   matrices have different sizes.
;;
(define (grsp-matrix-fdif p_a1 p_a2)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(n1 0)
	(n3 0)
	(n4 0))
    
    ;; Create safety matrices.
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))
    (set! res3 (grsp-matrix-cpy res1))

    ;; Find if matrices have the same dimensions.
    (cond ((equal? (grsp-matrix-is-samedim res1 res2) #t)
  
	   ;; Rows.
	   (let loop ((i1 (grsp-lm res1)))
	     (if (<= i1 (grsp-hm res1))

		 ;; Cols.
		 (begin (let loop ((j1 (grsp-ln res1)))
			  (if (<= j1 (grsp-hn res1))

			      (begin (set! n3 (array-ref res1 i1 j1))
				     (set! n4 (array-ref res2 i1 j1))
				     
				     (cond ((= n3 n4)
					    (array-set! res3 0 i1 j1))
					   (else (array-set! res3
							     1
							     i1
							     j1)))
				     
				     (loop (+ j1 1)))))
			
			(loop (+ i1 1))))))
	   
	  (else (set! res3 (grsp-matrix-fill res3 (grsp-nan)))))
			     
    res3))


;;;; grsp-matrix-opewc - Apply p_s1 to columns p_j1 and p_j2 of matrices
;; p_a1 and p_a2 respectively and place the results in column p_j3 of
;; matrix p_a3. This is a no-frills, quick-and-dirt function that I made
;; to test some stuff. There are certainly better solutions. This function
;; provides an easy way to operate element-wise between columns of a
;; single matrix or various matrices.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices
;;
;; Parameters:
;;
;; - p_s1:
;;
;;   - "#+": sum.
;;   - "#-": substraction.
;;   - "#*": product.
;;   - "#/": division.
;;   - "#expt": (expt p_a1(p_j1) p_a2(p_j2)).
;;   - "#max": max function.
;;   - "#min": min function.
;;   - "#=": if p_j1 is equal to p_j2, copy p_j1
;;     to p_j3.
;;   - "#!=": if p_j1 is not equal to p_j2, copy p_j1
;;     to p_j3.
;;
;; - p_a1: matrix 1.
;; - p_j1: col number, matrix 1.
;; - p_a2: matrix 2.
;; - p_j2: col number, matrix 2.
;; - p_a3: matrix 3.
;; - p_j3: colnumber, matrix 3.
;;
;; Notes:
;;
;; - p_a1, p_a2 and p_a3 must have the same number of rows. They can be
;;   the same matrix as well.
;; - See grsp-matrix-opew.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-opewc p_s1 p_a1 p_j1 p_a2 p_j2 p_a3 p_j3)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(n1 0)
	(n2 0)
	(n3 0))

    ;; Create safety matrices. It is assumed that p_a2 and
    ;; p_a3 have the same number of rows as p_a1.
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))
    (set! res3 (grsp-matrix-cpy p_a3))
	  
    ;; Cycle over p_a1 rows.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  (begin (set! n1 (array-ref res1 i1 p_j1))
		 (set! n2 (array-ref res2 i1 p_j2))
		 (set! n3 (array-ref res3 i1 p_j3))
		 
		 (cond ((equal? p_s1 "#+")		  
			(set! n3 (+ n1 n2)))		 
		       ((equal? p_s1 "#-")		  
			(set! n3 (+ n1 n2)))		 
		       ((equal? p_s1 "#*")		  
			(set! n3 (* n1 n2)))		 
		       ((equal? p_s1 "#/")		  
			(set! n3 (/ n1 n2)))		 
		       ((equal? p_s1 "#expt")		  
			(set! n3 (expt n1 n2)))		 
		       ((equal? p_s1 "#max")		  
			(set! n3 (max n1 n2)))		 
		       ((equal? p_s1 "#min")		  
			(set! n3 (min n1 n2)))		 
		       ((equal? p_s1 "#=")
			
			(cond ((equal? n1 n2)			 
			       (set! n3 n1))))
		       
		       ((equal? p_s1 "#!=")
			
			(cond ((equal? (equal? n1 n2) #f)
			       (set! n3 n1)))))	 

		 (array-set! res3 n3 i1 p_j3)
		 
		 (loop (+ i1 1)))))
    
    res3))


;;;; grsp-matrix-opew-mth - Performs element-wise operation p_s1 between
;; rows p_m1 and p_m2 of matrices p_a1 and p_a2 respectively; this is a
;; multithreaded function.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, multithreaded
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
;; - p_a1: first matrix.
;; - p_a2: second matrix.
;; - p_m1: row of p_a1.
;; - p_m2: row of p_a2.
;;
;; Notes:
;;
;; - This function does not validate the dimensionality or boundaries of
;;   the matrices involved; the user or an additional shell function
;;   should take care of that.
;; - Both matrices should be of equal dimensions.
;; - See grsp-matrix-opewc.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-row-opew-mth p_s1 p_a1 p_a2 p_m1 p_m2)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(l1 '())
	(l2 '())
	(l3 '()))   
	  
    ;; Cast submatrices as lists.
    (parallel (set! l1 (grsp-mr2l p_a1 p_m1))
	      (set! l2 (grsp-mr2l p_a2 p_m2)))

    ;; Operate on lists.
    (cond ((equal? p_s1 "#+")
	   (set! l3 (par-map + l1 l2)))
	  ((equal? p_s1 "#-")
	   (set! l3 (par-map - l1 l2)))
	  ((equal? p_s1 "#*")
	   (set! l3 (par-map * l1 l2)))
	  ((equal? p_s1 "#/")
	   (set! l3 (par-map / l1 l2)))
	  ((equal? p_s1 "#expt")
	   (set! l3 (par-map expt l1 l2)))
	  ((equal? p_s1 "#max")
	   (set! l3 (par-map max l1 l2)))
	  ((equal? p_s1 "#min")
	   (set! l3 (par-map min l1 l2))))
    
    ;; Cast results list as matrix.
    (set! res1 (grsp-l2m l3))
    
    res1))


;;;; grsp-mr2l - Casts row p_m1 of matrix p_a1 as a list.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: row number.
;;
;; Output
;;
;; - List.
;;
(define (grsp-mr2l p_a1 p_m1)
  (let ((res1 '())
	(a1 0))

    (set! a1 (grsp-matrix-subcpy p_a1
				 p_m1
				 p_m1
				 (grsp-ln p_a1)
				 (grsp-hn p_a1)))
    (set! res1 (grsp-m2l a1))
    
    res1))


;;;; grsp-l2mr - Place on row p_m1 of matrix p_a1, starting at col p_n1
;; the contents of list p_l1 as matrix elements.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix, target.
;; - p_l2: list.
;; - p_m1: row number where to place the beginning of the list.
;; - p_n1: col number where to place the beginning of the list.
;;
;; Examples:
;;
;; - example9.scm.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-l2mr p_a1 p_l2 p_m1 p_n1)
  (let ((res1 0)
	(res2 0)
	(m1 0)
	(n1 0)
	(pl 0))

    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-l2m p_l2))

    ;; If p_m1 surpasses the maximum number of rows, calculate
    ;; the number of rows that will be added (m1).
    (cond ((> p_m1 (grsp-hm res1))
	   (set! m1 (- p_m1 (grsp-hm res1)))))

    ;; If p_n1 surpasses the maximum number of cols, calculate
    ;; the number of cols that will be added (n1).
    (set! pl (+ (- (length p_l2) 1) p_n1))
    
    (cond ((> pl (grsp-hn res1))
	   (set! n1 (- pl (grsp-hn res1)))))

    ;; Add the required rows and cols.
    (set! res1 (grsp-matrix-subexp res1 m1 n1))

    ;; Paste the contents of the list on the required coordinates
    ;; on the - possibly expanded - target matrix.
    (set! res1 (grsp-matrix-subrep res1 res2 p_m1 p_n1))
    
    res1))


;;;; grsp-matrix-opew-mth - Performs element-wise operation p_s1 between
;; p_a1 and p_a2 in parallel.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, multithreaded
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
;; - p_a1: first matrix.
;; - p_a2: second matrix.
;;
;; Notes:
;;
;; - This function does not validate the dimensionality or boundaries of
;;   the matrices involved; the user or an additional shell function
;;   should take care of that.
;; - Both matrices should be of equal dimensions.
;; - See grsp-matrix-opew, grsp-matrix-row-opew-mth.
;;
;; Output
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [26].
;;
(define (grsp-matrix-opew-mth p_s1 p_a1 p_a2)
  (let ((res1 0)
	(a3 0)
	(i2 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Cycle. Note that indexes for p_a1 and p_a2 should be initialized
    ;; and updated separatedly since the row ordinals for each matrix
    ;; might be different.
    (set! i2 (grsp-lm p_a2))

    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  (begin (set! a3 (grsp-matrix-row-opew-mth p_s1 p_a1 p_a2 i1 i2))
		 (set! res1 (grsp-matrix-subrep res1 a3 i1 (grsp-ln a3)))
		 (set! i2 (in i2))
		 
	  (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-is-traceless - Returns #t if matrix p_a1 is square and
;; the sum of its main diagonal elements equals zero; false otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output
;;
;; - Boolean.
;;
(define (grsp-matrix-is-traceless p_a1)
  (let ((res1 #f))

    (cond ((equal? (grsp-matrix-is-square p_a1) #t)
	   
	   (cond ((equal? (grsp-matrix-opio "#+md" p_a1 0) 0)
		  (set! res1 #t)))))
    
    res1))


;;;; grsp-matrix-movemm - Circulates (moves) the value found at (p_m1,
;; p_n1) of matrix p_a1 to position (p_m2, p_n2) of matrix p_a2. This
;; allpws for independent, element by element discrete movement of values
;; between matrices.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, moving
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;; - p_m1: row ordinal of p_a1.
;; - p_n1: col ordinal of p_a1.
;; - p_m2: row ordinal of p_a2.
;; - p_n2: col ordinal of p_a2.
;;
;; Notes:
;;
;; - This function does not check the dimensions of the matrices involved.
;;
;; Output:
;;
;; - Matrix with the value in question changed.
;;
(define (grsp-matrix-movemm p_a1 p_a2 p_m1 p_n1 p_m2 p_n2)
  (let ((res1 0))

    (set! res1 (grsp-matrix-cpy p_a2))
    (array-set! res1 (array-ref p_a1 p_m1 p_n1) p_m2 p_n2)
    
    res1))


;;;; grsp-matrix-movsmm - Swaps element located at position (p_m1, p_n1)
;; of matrix p_a1 with element located at p_a2 (p_m2, p_n2).
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, swapping
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;; - p_m1: row ordinal of p_a1.
;; - p_n1: col ordinal of p_a1.
;; - p_m2: row ordinal of p_a2.
;; - p_n2: col ordinal of p_a2.
;;
;; Notes:
;;
;; - This function does not check the dimensions of the matrices involved.
;;
;; Output:
;;
;; - List containing matrices p_a1 and p_a2 with elements in question
;;   swapped.
;;
(define (grsp-matrix-movsmm p_a1 p_a2 p_m1 p_n1 p_m2 p_n2)
  (let ((res1 '())
	(a1 0)
	(a2 0)
	(n1 0)
	(n2 0))

    ;; Make safety copies of matrices.
    (set! a1 (grsp-matrix-cpy p_a1))
    (set! a2 (grsp-matrix-cpy p_a2))

    ;; Store intermediate values.
    (set! n1 (array-ref a1 p_m1 p_n1))
    (set! n2 (array-ref a2 p_m2 p_n2))

    ;; Swap values.
    (array-set! a1 n2 p_m1 p_n1)
    (array-set! a2 n1 p_m2 p_n2)

    ;; Compose results.
    (set! res1 (list a1 a2))
    
    res1))


;;;; grsp-matrix-movcrm - Circulates row p_m1 of matrix p_a1 by p_j2
;; elements from left to right, or lower col number to higher col number.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, circulation
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: circulate from left to right.
;;   - #f: circulate from right to left.
;;
;; - p_a1: matrix.
;; - p_m1: row number.
;; - p_j2: number of cols to circulate.
;;
;; Notes:
;;
;; - This function does not vaildate if row p_m1 actually exists on
;;   matrix p_a1.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-movcrm p_b1 p_a1 p_m1 p_j2)
  (let ((res1 0)
	(nl (grsp-ln p_a1))
	(nh (grsp-hn p_a1))
	(j1 0)
	(j2 1)
	(n1 0)
	(n2 0)
	(n3 0))

    (set! res1 (grsp-matrix-cpy p_a1))

    (cond ((equal? p_b1 #t)
	   
	   ;; Cycle as many times as you want to circulate the row from
	   ;; left to right.
	   (while (<= j2 p_j2)

		  ;; Cycle that corresponds to a one-element circulation.
		  (set! j1 nh)
		  (while (>= j1 nl)
			 ;; Get the value of the current element according
			 ;; to coordinates (p_m1, j1).
			 (set! n1 (array-ref res1 p_m1 j1))
			 
			 (cond ((equal? j1 nh)
				;; Special case of the last row element.
				(set! n2 n1)
				(set! n3 (array-ref res1 p_m1 (- j1 1)))
				(array-set! res1 n3 p_m1 j1))
			       ((equal? (and (< j1 nh) (> j1 nl)) #t)
				;; Replace the value of the current
				;; element with the value of the prior
				;; element (the one that has a col index
				;; lower by one).
				(set! n3 (array-ref res1 p_m1 (- j1 1)))
				(array-set! res1 n3 p_m1 j1))
			       ((equal? j1 nl)
				;; special case of the first row element.
				(array-set! res1 n2 p_m1 j1)))
			 
			 (set! j1 (de j1)))

		  (set! j2 (in j2))))

	  ((equal? p_b1 #f)

	   ;; Cycle as many times as you want to circulate the row from
	   ;; right to left.
	   (while (<= j2 p_j2)

		  ;; Cycle that corresponds to a one-element circulation.
		  (set! j1 nl)
		  (while (<= j1 nh)
			 ;; Get the value of the current element according
			 ;; to coordinates (p_m1, j1).
			 (set! n1 (array-ref res1 p_m1 j1))
			 
			 (cond ((equal? j1 nl)
				;; Special case of the first row element.
				(set! n2 n1)
				(set! n3 (array-ref res1 p_m1 (+ j1 1)))
				(array-set! res1 n3 p_m1 j1))
			       ((equal? (and (< j1 nh) (> j1 nl)) #t)
				;; Replace the value of the current
				;; element with the value of the posterior
				;; element (the one that has a col index
				;; higher by one).
				(set! n3 (array-ref res1 p_m1 (+ j1 1)))
				(array-set! res1 n3 p_m1 j1))
			       ((equal? j1 nh)
				;; special case of the first row element.
				(array-set! res1 n2 p_m1 j1)))
			 
			 (set! j1 (in j1)))

		  (set! j2 (in j2))) ))
    
    res1))


;;;; grsp-matrix-movtrm - Given matrix p_a1, this function will take each
;; element p_a1(0,n) and will place it on p_a1(n,n) if p_b1 is #t, or each
;; element p_a1(n,0) and will place it on p_a1(n,n) if p_b1 is #f, until
;; it reaches n = m.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, swapping
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-movtrm p_b1 p_a1)
  (let ((res1 0)
	(j1 (grsp-ln p_a1)))

    (set! res1 (grsp-matrix-cpy p_a1))
    
    (while (equal? (and (<= j1 (grsp-hm res1)) (<= j1 (grsp-hn res1))) #t)
	   
	   (cond ((equal? p_b1 #t)
		  (array-set! res1 (array-ref res1
					      (grsp-lm res1)
					      j1)
			      j1
			      j1))
		 (else
		  (array-set! res1 (array-ref res1
					      j1
					      (grsp-ln res1))
			      j1
			      j1)))
	   
	   (set! j1 (in j1)))
    
    res1))


;;;; grsp-matrix-ldiagonal - Replaces every element of matrix p_a1 with
;; value p_n1 except those on the main diagonal.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, diagonal, replacement,
;;   replacing, change
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_n1: number.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-ldiagonal p_a1 p_n1)
  (let ((res1 0))

    ;; Make safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Cycle and replace all elements of the matrix except in the case
    ;; of those with m = n (equal row and col numbers, meaning that they
    ;; are in the main diagonal.
    
    ;; Rows.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  ;; Cols.
	  (begin (let loop ((j1 (grsp-ln res1)))
		   (if (<= j1 (grsp-hn res1))

		       (begin (cond ((equal? (equal? i1 j1) #f)
				     (array-set! res1 p_n1 i1 j1)))
			      
			      (loop (+ j1 1)))))
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-minor - Find the (p_m1, p_n1) minor of p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: row coordinate.
;; - p_n1: col cordinate.
;;
;; Output
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-matrix-minor p_a1 p_m1 p_n1)
  (let ((res1 0)
	(a1 0))

    ;; Make safety copy. Matrix p_a1 will not be altered.
    (set! a1 (grsp-matrix-cpy p_a1))

    ;; Delete row p_m1.
    (set! a1 (grsp-matrix-subdel "#Delr" a1 p_m1))
    
    ;; Delete col p_n1.
    (set! a1 (grsp-matrix-subdel "#Delc" a1 p_n1))
    
    ;; Find the determinant of p_a1 after trimming.
    (set! res1 (grsp-matrix-determinant-lu a1))
    
    res1))


;;;; grsp-matrix-minor-cofactor - Find the (p_m1, p_n1) cofactor of p_a1
;; based on its (p_m1, p_n1) minor.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: row coordinate.
;; - p_n1: col cordinate.
;;
;; Output
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-matrix-minor-cofactor p_a1 p_m1 p_n1)
  (let ((res1 0)
	(n1 0))

    ;; Find the minor.
    (set! n1 (grsp-matrix-minor p_a1 p_m1 p_n1))

    ;; Calculate the cofactor.
    (set! res1 (* n1 (expt -1 (+ p_m1 p_n1))))

    res1))


;;;; grsp-matrix-cofactor - Calculates the cofactor matrix of matrix p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-matrix-cofactor p_a1)
  (let ((res1 0))

    ;; Set res1 to be a matrix of the same size as p_a1, filled with
    ;; zeros.
    (set! res1 (grsp-matrix-create-dim 0 p_a1))    

    ;; Rows.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;; Cols.
	  (begin (let loop ((j1 (grsp-ln p_a1)))
		   (if (<= j1 (grsp-hn p_a1))

		       (begin (array-set! res1
					  (grsp-matrix-minor-cofactor p_a1
								      i1
								      j1)
					  i1
					  j1)
			      
		       (loop (+ j1 1)))))
		       
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-inverse - Calculates the inverse of matrix p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, inversion
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-matrix-inverse p_a1)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(n1 0))

    (set! a1 (grsp-matrix-cpy p_a1))
    (set! a2 (grsp-matrix-cpy p_a1))
    
    (cond ((equal? (grsp-matrix-is-invertible a1) #t)

	   ;; Transpose of cofactor matrix (adjugate).
	   (set! a2 (grsp-matrix-adjugate a1))

	   ;; Inverse of the determinant.
	   (set! n1 (/ 1 (grsp-matrix-determinant-lu a1)))
	   
	   ;; FInal result.
	   (set! res1 (grsp-matrix-opsc "#*" a2 n1))))
	   
    res1))


;;;; grsp-matrix-adjugate - Calculates the adjugate of matrix p_a1
;; (transpose of cofactor of p_a1).
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-matrix-adjugate p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-transpose (grsp-matrix-cofactor p_a1)))
    
    res1))


;;;; grsp-mn2ms - Casts numeric matrix p_a1 into a string matrix.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-mn2ms p_a1)
  (let ((res1 "")	
	(i1 0)
	(j1 0))

    ;; Create a results string matrix of the same dimensions as p_a1.
    (set! res1 (grsp-matrix-create-dim "" p_a1))

    ;; Cycle thorough both matrices, cast each element of p_a1 as a string
    ;; and copy it to the exact position into res1.

    ;; Row.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;; Cols.
	  (begin (let loop ((j1 (grsp-ln p_a1)))
		   (if (<= j1 (grsp-hn p_a1))

		       (begin (array-set! res1 (grsp-n2s (array-ref p_a1
								    i1
								    j1))
					  i1
					  j1)
				    
			      (loop (+ j1 1)))))
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-string-spjustify - Applies grsp-string-pjustify to every element
;; of p_a1, producing a matrix of strings of equal length, padded with
;; p_s3 and lustified according to p_s1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings, padding
;;
;; Parameters:
;;
;; - p_s1: string. Mode.
;;
;;   - "#l": p_s2 to the left.
;;   - "#r": p_s2 to the right.
;;   - "#b": center p_s2.
;;
;; - p_a1: matrix of strings.
;; - p_s3: string for padding (one char length).
;; - p_n1: numeric. Length of padded and justified string.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-spjustify p_s1 p_a1 p_s3 p_n1)
  (let ((res1 "")
	(s2 "")
	(i1 0)
	(j1 0))

    ;; Make safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Row.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  ;; Cols.
	  (begin (let loop ((j1 (grsp-ln res1)))
		   (if (<= j1 (grsp-hn res1))

		       (begin (set! s2 (grsp-string-pjustify p_s1
							     (array-ref res1
									i1
									j1)
							     p_s3
							     p_n1))
			      (array-set! res1 s2 i1 j1)
				    
			      (loop (+ j1 1)))))
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-slongest - Finds the length in number of characters of
;; the longest string of string matrix p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings, length
;;
;; Parameters:
;;
;; - p_a1: matrix. String.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-slongest p_a1)
  (let ((res1 0)
	(n1 0)
	(s1 "")
	(i1 0)
	(j1 0))

    ;; Row.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;; Cols.
	  (begin (let loop ((j1 (grsp-ln p_a1)))
		   (if (<= j1 (grsp-hn p_a1))

		       (begin (set! s1 (array-ref p_a1 i1 j1))
			      (set! n1 (string-length s1))
			      
			      (cond ((> n1 res1)
				     (set! res1 n1)))
				    
			      (loop (+ j1 1)))))
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-ms2s - Creates a formatted long string from p_a1 for display.
;; This function transforms all elements of a string matrix into a
;; unified string.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings
;;
;; Parameters:
;;
;; - p_b1:
;;
;;   - #t: to justify each column separatedly.
;;   - #f: otherwise.
;;
;; - p_a1: matrix. String.
;;
;; Output
;;
;; - String.
;;
(define (grsp-ms2s p_b1 p_a1)
  (let ((res1 "")
	(a1 0)
	(a2 "")
	(a3 0)
	(l1 0)
	(i1 0)
	(j1 0))

    ;; Safety copy.
    (set! a1 (grsp-matrix-cpy p_a1))
    
    (cond ((equal? p_b1 #t)

	   ;; Pad with some spaces.
	   (set! a1 (grsp-ms-pad-elements a1 1 1))
	   
	   ;; Col loop. We deal with each column of a1 separatedly.
	   (let loop ((j1 (grsp-ln a1)))
	     (if (<= j1 (grsp-hn a1))

		 (begin (set! a3 (grsp-matrix-subcpy a1
						     (grsp-lm a1)
						     (grsp-hm a1)
						     j1
						     j1))
			
			;; Find the longest string in the matrix.
			(set! l1 (+ (grsp-matrix-slongest a3) 1))
			
			;; Justify.
			(set! a3 (grsp-matrix-spjustify "#l" a3 " " l1))
			
			;; Put a3 back in a1.
			(set! a1 (grsp-matrix-subrep a1
						     a3
						     (grsp-lm a1)
						     j1))
			
			(loop (+ j1 1)))))
	   
	   (set! a2 (grsp-matrix-cpy a1)))
	  
	  ((equal? p_b1 #f)
	   
	   ;; Find the longest string in the matrix.
	   (set! l1 (+ (grsp-matrix-slongest a1) 1))
	   
	   ;; Justify.
	   (set! a2 (grsp-matrix-spjustify "#r" a1 " " l1))))

    ;; Row loop. Append everything to a string.
    (let loop ((i1 (grsp-lm a1)))
      (if (<= i1 (grsp-hm a1))

	  ;; Cols.
	  (begin (let loop ((j1 (grsp-ln a1)))
		   (if (<= j1 (grsp-hn a1))

		       (begin (set! res1 (string-append res1
							(array-ref a2
								   i1
								   j1)))
			      
			      (loop (+ j1 1)))))

		 ;; Insert a new line string after a row is completed.
		 (set! res1 (string-append res1 "\n"))
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-display - Displays matrix p_a1 in a visually-intuitive
;; format.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings
;;
;; Parameters:
;;
;; - p_a1: matrix. Numeric.
;;
;; Examples:
;;
;; - example5.scm.
;;
;; Output
;;
;; - String.
;;
(define (grsp-matrix-display p_a1)
  (let ((res1 "")
	(a1 ""))

    (set! a1 (grsp-my2ms p_a1))
    (set! res1 (grsp-ms2s #t a1))

    (display res1)))
  

;;;; grsp-ms2mn - Casts string matrix p_a1 into a numeric matrix.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings
;;
;; Parameters:
;;
;; - p_a1: matrix. String.
;;
;; Notes:
;;
;; - The strings corresponding to each element must correspond
;;   to numbers, for example "42" or "666". Otherwise you might
;;   get an error or a matrix filled with #f values.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-ms2mn p_a1)
  (let ((res1 0)	
	(i1 0)
	(j1 0)
	(n1 0))

    ;; Create a results numeric matrix of the same dimensions as p_a1.
    (set! res1 (grsp-matrix-create-dim 0 p_a1))

    ;; Cycle thorough both matrices, cast each element of p_a1 as a number
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  (begin (let loop ((j1 (grsp-ln p_a1)))
		   (if (<= j1 (grsp-hn p_a1))

		       (begin (array-set! res1 (grsp-s2n (array-ref p_a1
								    i1
								    j1))
					  i1
					  j1)
		       
			      (loop (+ j1 1)))))
		       
		       (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-tio - Turns into number p_n1 every number between
;; established limits or p_n2 otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings, replacement,
;;   substitution
;;
;; Parameters:
;;
;; - p_s1: string. Interval mode (inclusive or exclusive).
;;
;;   - "#[]" l inclusive, h inclusive.
;;   - "#[)" l inclusive, h exclusive.
;;   - "#(]" l exclusive, h inclusive.
;;   - "#()" l exclusive, h exclusive.
;;
;; - p_a1: matrix.
;; - p_n1: value to set if condition is met.
;; - p_n2: value to set otherwise.
;; - p_min: number. Lower limit.
;; - p_max: higher limit.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-tio p_s1 p_a1 p_n1 p_n2 p_min p_max)
  (let ((res1 0)
	(b1 #f)
	(i1 0)
	(j1 0)
	(n1 0)
	(n2 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Row cycle.
    (set! i1 (grsp-lm res1))
    (while (<= i1 (grsp-hm res1))

	   ;; Col cycle.
	   (set! j1 (grsp-ln res1))
	   (while (<= j1 (grsp-hn res1))

		  ;; Get current value at position i1 j1.
		  (set! n1 (array-ref res1 i1 j1))

		  ;; Selec mode.
		  (cond ((equal? p_s1 "#[]")
			 
			 (cond ((equal? (and (>= n1 p_min) (<= n1 p_max)) #t)
				(set! n1 p_n1))
			       (else (set! n1 p_n2))))
			
			((equal? p_s1 "#[)")
			 
			 (cond ((equal? (and (>= n1 p_min) (< n1 p_max)) #t)
				(set! n1 p_n1))
			       (else (set! n1 p_n2))))
			
			((equal? p_s1 "#(]")
			 
			 (cond ((equal? (and (> n1 p_min) (<= n1 p_max)) #t)
				(set! n1 p_n1))
			       (else (set! n1 p_n2))))
			
			((equal? p_s1 "#()")
			 
			 (cond ((equal? (and (> n1 p_min) (< n1 p_max)) #t)
				(set! n1 p_n1))
			       (else (set! n1 p_n2)))))

		  ;; Set new, capped value.
		  (array-set! res1 n1 i1 j1)
				 
		  (set! j1 (in j1)))
	   
	   (set! i1 (in i1)))
    
    res1))


;;;; grsp-matrix-diagonal-update - Replaces all the elements of the main
;; diagonal of a square matrix p_a1 with value p_n1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings, replacement,
;;   substitution
;;
;; Parameters:
;;
;; - p_a1: matrix (should be square).
;; - p_n1: number. New value for diagonal elements.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-diagonal-update p_a1 p_n1)
  (let ((res1 0)
	(i1 0)
	(j1 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Cycle rows.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  ;; Cycle cols.
	  (begin (let loop ((j1 (grsp-ln res1)))
		   (if (<= j1 (grsp-hn res1))

		       (begin (cond ((= i1 j1)
				     (array-set! res1 p_n1 i1 j1)))
			      
			      (loop (+ j1 1)))))
	  
	  (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-diagonal-vector - Creates a vector (row) with the
;; elements of the diagonal of matrix p_a1.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings, diagonal
;;
;; Parameters:
;;
;; - p_a1: matrix (should be square).
;;
;; Output
;;
;; - Row vector (1 x n matrix).
;;
(define (grsp-matrix-diagonal-vector p_a1)
  (let ((res1 0)
	(n1 0)
	(i1 0)
	(j1 0))

    (set! n1 (grsp-matrix-te1 (grsp-lm p_a1) (grsp-hm p_a1)))
    (set! res1 (grsp-matrix-create 0 1 n1))
    (set! j1 (grsp-ln res1))

    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  (begin (array-set! res1 (array-ref p_a1 i1 i1) 0 j1)
		 (set! j1 (in j1))
		 
		 (loop (+ i1 1)))))    
    
    res1))


;;;; grsp-matrix-row-proj - Orthogonal projection of p_a1 over p_a2.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings,
;;   orthogonality, perpendicularity
;;
;; Parameters:
;;
;; - p_a1: row vector.
;; - p_a1: row vector.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-row-proj p_a1 p_a2)
  (let ((res1 0)
	(res2 0)
	(uv 0)
	(uu 0))

    (set! uv (grsp-matrix-opmsc "#.R" p_a2 p_a1))
    (set! uu (grsp-matrix-normf uu))
    (set! res2 (/ uv uu))
    (set! res1 (grsp-matrix-opsc "#*" p_a2 res2))
    
    res1))


;;;; grsp-matrix-normp - Calculates the matrix norm using the vector
;; p-norm rule.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, entry wise
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_p1: p.
;;
;; Notes:
;;
;; . Not defined for p_p1 = 0.
;;
;; Sources:
;;
;; - [54].
;;
(define (grsp-matrix-normp p_a1 p_p1)
  (let ((res1 0)
	(res2 0))
    
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res1 (grsp-matrix-opfn "#abs" res1))
    (set! res1 (grsp-matrix-opsc "#expt" res1 p_p1))
    (set! res2 (grsp-matrix-opio "#+" res1 0))
    (set! res2 (expt res2 (/ 1 p_p1)))
    
    res2))


;;;; grsp-matrix-normf - Calculates the matrix Frobenius norm.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, entry wise
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Sources:
;;
;; - [54].
;;
(define (grsp-matrix-normf p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-normp p_a1 2))

    res1))


;;;; grsp-matrix-normm - Calculates the matrix Manhattan norm.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, entry wise
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Sources:
;;
;; - [54].
;;
(define (grsp-matrix-normm p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-normp p_a1 1))

    res1))


;;;; grsp-eigenval-qr - Calculates eigenvalues using iterations of the QR
;; decomposition.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, entry wise,
;;   eigenvalue
;;
;; Parameters:
;;
;; - p_s1: decomposition method (QR).
;; - p_a1: matrix.
;; - p_n1: max number of iterations.
;;
;; Notes:
;;
;; - See grsp-matrix-decompose for suitable decomposition methods.
;;
;; Output:
;;
;; - A one-row matrix containing the eigenvalues of p_a1.
;;
;; Sources:
;;
;; - [55][56].
;;
(define (grsp-eigenval-qr p_s1 p_a1 p_n1)
  (let ((res1 0)
	(res2 0)
	(b1 #f)
	(A 0)
	(Q 0)
	(R 0)
	(i1 0))

    ;; Safety copy.
    (set! A (grsp-matrix-cpy p_a1))

    ;; Apply decomposition repeatedly until conditions are met.
    (while (equal? b1 #f)

	   ;; Unpack list of matrices.
	   (cond ((> i1 0)
		  (set! Q (car res1))
		  (set! R (cadr res1))
		  (set! A (grsp-matrix-opmm "#*" R Q))))

	   ;; Apply decomposition.
	   (set! res1 (grsp-matrix-decompose p_s1 A))
	   
	   (set! i1 (in i1))

	   ;; Check for number of iterations.
	   (cond ((> i1 p_n1)
		  (set! b1 #t)))

	   ;; Check if res1 is an identity matrix.
	   (cond ((equal? (grsp-matrix-identify "#I" (car res1)) #t)
		  (set! b1 #t))))

    ;; Extract elements from the main diagonal.
    (set! res2 (grsp-matrix-diagonal-vector A))
    
    res2))


;;;; grsp-eigenvec - Calculates right eigenvectors based on p_a1 and
;; p_a2.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, eigenvector
;;
;; Parameters:
;;
;; - p_a1: square matrix.
;; - p_a2: column vector containing the eigenvalues of p_a1.
;;
;; Notes:
;;
;; - See grsp-eigenval-qr.
;; - TODO: still needs working.
;;
;; Output
;;
;; - List.
;;
;; Sources:
;;
;; - [55][56].
;;
(define (grsp-eigenvec p_a1 p_a2)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(A 0)
	(I 0)
	(v 0)
	(tm 0))

    ;; Safety copies.
    (set! A (grsp-matrix-cpy p_a1))
    (set! v (grsp-matrix-cpy p_a2))

    ;; Create identity matrix of same dimensions as A.
    (set! I (grsp-matrix-create-dim "#I" A))

    ;; Create results list.
    (set! tm (grsp-tm v))
    (set! res1 (make-list tm 0))

    (let loop ((i2 (grsp-lm v)))
      (if (<= i2 (grsp-hm v))

	  (begin (set! res2 (grsp-matrix-opsc "#*" I (array-ref v i2 0)))
		 (set! res3 (grsp-matrix-opmm "#-" A res2))
		 
		 ;; Place eigenvector in list of results.
		 (list-set! res1 i2 res3)
		 
		 (loop (+ i2 1)))))
    
    res1))


;;;; grsp-matrix-is-srddominant - Returns #t if square matrix p_a1 is
;; strictly row diagonally dominant; #f otherwise.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, dominance, diagonal
;;
;; Parameters:
;;
;; - p_a1: matrix, square.
;;
;; Output
;;
;; - Boolean.
;;
;; Sources:
;;
;; - [59].
;;
(define (grsp-matrix-is-srddominant p_a1)
  (let ((res1 #f)
	(i1 0)
	(j1 0)
	(n1 0)
	(a1 0)
	(a2 0))

    (set! i1 (grsp-lm p_a1))
    (while (<= i1 (grsp-hm p_a1))

	   ;; Find the absolute value of the diagonal element.
	   (set! a1 (abs (array-ref p_a1 i1 i1)))
	   
	   (set! j1 (grsp-ln p_a1))
	   (while (<= j1 (grsp-hn p_a1))

		  ;; Find the absolute value of the current element.
		  (set! a2 (abs (array-ref p_a1 i1 j1)))

		  ;; Only apply when i1 is not equal to j1.
		  (cond ((equal? (equal? i1 j1) #f)

			 ;; If the a1 is less or equal than a2 at least
			 ;; once, then the matrix is not strictly row
			 ;; dominant.
			 (cond ((<= a1 a2)
				(set! n1 (in n1))))))
		  
		  (set! j1 (in j1)))

	   (set! i1 (in i1)))

    ;; Only if n1 remains zero the matrix will be considered strictly row
    ;; diagonally dominant.
    (cond ((= n1 0)
	   (set! res1 #t)))
    
    res1))


;;;; grsp-matrix-jacobim - Implementation of the Jacobi method for
;; solving Ax = b.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, jacobian
;;
;; Parameters:
;;
;; - p_s1: decomposition method (QR).
;; - p_a1: matrix A.
;; - p_b1: matrix b.
;; - p_x1: natrix x.
;; - p_n1: max number of iterations.
;;
;; Notes:
;;
;; - See grsp-matrix-sradius.
;;
;; Output:
;;
;; - Matrix.
;;  
;; Sources:
;;
;; - [57][59][60].
;;
(define (grsp-matrix-jacobim p_s1 p_a1 p_x1 p_b1 p_n1)
  (let ((res1 0)
	(A 0)
	(X 0)
	(B 0)
	(sum 0)
	(b1 #f)
	(i1 0)
	(j1 0)
	(n1 0)
	(n2 0)
	(n3 0)
	(n4 0))

    ;; Safety copies.
    (set! A (grsp-matrix-cpy p_a1))
    (set! B (grsp-matrix-cpy p_b1))
    (set! X (grsp-matrix-cpy p_x1))    
    
    (while (equal? b1 #f)

	   (set! i1 (grsp-lm A))
	   (while (<= i1 (grsp-hm A))

		  (set! sum 0)
		  (set! j1 (grsp-ln A))
		  (while (<= j1 (grsp-hn A))

			 (cond ((equal? (grsp-eq i1 j1) #f)
				(set! sum (+ sum (* (array-ref A i1 j1)
						    (array-ref X
							       j1
							       0))))))

			 (set! j1 (in j1)))

		  (array-set! X (/ (- (array-ref B i1 0) sum)
				   (array-ref A i1 i1)) i1 0)
		  		  
		  (set! i1 (in i1)))

	   (set! n1 (in n1))

	   ;; Convergence conditions.
	   (cond ((>= n1 p_n1)
		  (set! b1 #t)))

	   (cond ((< (grsp-matrix-sradius p_s1 A p_n1) 1)
		  (set! b1 #t)))
	   
	   (cond ((equal? b1 #f)
		  (set! b1 (grsp-matrix-is-srddominant A)))))

    (set! res1 X)
    
    res1))


;;;; grsp-matrix-sradius - Calculates the spectral radius of matrix
;; p_a1. 
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, decomposition,
;;   factorization
;;
;; Parameters:
;;
;; - p_s1: decomposition method (QR).
;; - p_a1: matrix (square).
;; - p_n1: max number of iterations.
;;
;; Notes:
;;
;; - See grsp-matrix-decompose for suitable decomposition methods for
;;   eigenvalue calculation.
;;
;; Output
;;
;; - Numerix.
;;
;; Sources:
;;
;; - [60].
;;
(define (grsp-matrix-sradius p_s1 p_a1 p_n1)
  (let ((res1 0))

    (set! res1 (array-ref (grsp-matrix-minmax (grsp-eigenval-qr p_s1
								p_a1
								p_n1))
			  0
			  1))
    
    res1))


;;;; grsp-ms2ts - Creates a text string from the file pointed by the
;; string contained at (array-ref p_a1 p_m1 p_n1).
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings, text,
;;   pointers
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: row.
;; - p_n1: col.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ms2ts p_a1 p_m1 p_n1)
  (let ((res1 "")
	(s2 "")
	(n2 0))
    
    (set! n2 (array-ref p_a1 p_m1 p_n1))
    (set! s2 (grsp-dbc2s n2))
    (set! res1 (read-file-as-string s2))
    
    res1))


;;;; grsp-mr2ls - Matrix row to list of strings. Returns row p_m1 from
;; matrix p_a1 as a list of strings.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings, lists
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: row.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-mr2ls p_a1 p_m1)
  (let ((res1 '()))

    (set! res1 (map grsp-bcn2s (grsp-mr2l p_a1 p_m1)))

    res1))


;;;; grsp-dbc2lls - For database table (matrix) element p_a1(p_m1, p_n1)
;; representing a link to a file with a numeric string, this function
;; returns a two element string list containing:
;;
;; - Elem 0: the path to the plain text file as codified in the table.
;; - Elem 1: text of the file as a single string.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings, lists,
;;   pointers, links, lists
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: row.
;; . p_n1: col.
;;
;; Notes:
;;
;; - See grsp0.grsp-s2dbc, grsp0.grsp-dbc2s.
;;
;; Output
;;
;; - List.
;;
(define (grsp-dbc2lls p_a1 p_m1 p_n1)
  (let ((res1 '()))
	
    (set! res1 (list (grsp-dbc2s (array-ref p_a1 p_m1 p_n1))
		     (grsp-ms2ts p_a1 p_m1 p_n1)))
    
    res1))


;;;; grsp-matrix-row-prkey - Defines an explicit primary key on col p_j1
;; from matrix p_a1, starting at row p_m1 and whose values equal the
;; corresponding row numbers. The resulting primary keys are unique
;; since row numbers are also unique.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors, strings, lists
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: row.
;; - p_j1: col.
;;
;; Notes:
;;
;; - This function should be used with care to avoid messing-up primary
;;   keys.
;; - The function gives the choice to start at any row number in order to
;;   save time when assigning primary key values to new rows.
;; - Take into account that key numbers may not coincide with row
;;   numbers.
;; - Elements on p_j1 should be zero before applying this function.
;;
;; Output
;;
;; - Matrix.
;;
(define (grsp-matrix-row-prkey p_a1 p_m1 p_j1)
  (let ((res1 0)
	(i1 0)
	(i2 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Cycle.
    (set! i1 p_m1)
    (set! i2 i1)
    (while (<= i1 (grsp-hm res1))

	   ;; Only act on elements that have no value assigned as key.
	   (cond ((equal? (array-ref res1 i1 p_j1) 0)

		  ;; Check if i2 already exists as a key. If it does,
		  ;; increment i2 and continue checking until i2 has a
		  ;; value that does not exist in column p_j1.
		  (cond ((> i1 0)
			 (while (> (grsp-matrix-col-total-element "#=" p_a1 p_j1 i2) 0)
				(set! i2 (in i2)))))

		  ;; Assign key.
		  (array-set! res1 i2 i1 p_j1)
		  (set! i2 (in i2))))
	   
	   (set! i1 (in i1)))
  
    res1))


;;;; grsp-matrix-strot - Rotates column vector (p_v1) by angle p_t1
;; about the x, y or z axis.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices, vectors
;;
;; Parameters:
;;
;; - p_s1: rotation axis (facing the obsever).
;;   - "#x". 
;;   - "#y".
;;   - "#z".
;;
;; - p_v2: three element vector, representig its x,y,z values.
;; - p_t1: angle of rotation, counterclockwise facing the observer.
;;
;; Notes:
;;
;; - See grsp-matrix-create-set, "#SBC".
;;
;; Output
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [61].
;;
(define (grsp-matrix-strot p_s1 p_v1 p_t1)
  (let ((res1 0)
	(R 0)
	(ct (cos p_t1))
	(st (sin p_t1))
	(zt 0))

    ;; Create rotation matrix.
    (set! zt (* -1 st))
    (define R (grsp-matrix-create 0.0 3 3))
    (cond ((equal? p_s1 "#x")
	   (array-set! R 1.0 0 0)
	   (array-set! R ct 1 1)
	   (array-set! R zt 1 2)
	   (array-set! R st 2 1)
	   (array-set! R ct 2 2))
	  ((equal? p_s1 "#y")
	   (array-set! R ct 0 0)
	   (array-set! R st 0 2)
	   (array-set! R 1.0 1 1)
	   (array-set! R zt 2 0)
	   (array-set! R ct 2 2))
	  ((equal? p_s1 "#z")
	   (array-set! R ct 0 0)
	   (array-set! R zt 0 1)
	   (array-set! R st 1 0)
	   (array-set! R ct 1 1)
	   (array-set! R 1.0 2 2)))

    ;; Multiply rotation matrix by argument vector.
    (set! res1 (grsp-matrix-opmm "#*" R p_v1))
    
    res1))


;;;; grsp-matrix-row-corr - Correlates elements p_a1[p_m1,p_n2] and
;; p_a2[p_m2,p_n2], and places the data in a correlation matrix.
;;
;; Keywords:
;;
;; - matrix, element, correlation, matrices
;;
;; Parameters:
;;
;; - p_a1: matrix 1.
;; - p_m1: row coordinate of matrix p_a1 element.
;; - p_n1: col coordinate of matrix p_a1 element.
;; - p_a2: matrix 2.
;; - p_m2: row coordinate of matrix p_a2 element.
;; - p_n2: col coordinate of matrix p_a2 element.
;;
;; Notes:
;;
;; - See grsp-matrix-correwl.
;;
;; Output:
;;
;; - Correlation matrix row. See grsp-matrix-create-fix.#corr.
;;
(define (grsp-matrix-row-corr p_a1 p_m1 p_n1 p_a2 p_m2 p_n2)
  (let ((res1 0))

    (set! res1 (grsp-matrix-create-fix "#corr" 0.0+0.0i))
    (array-set! res1 p_m1 0 0)
    (array-set! res1 p_n1 0 1)
    (array-set! res1 (array-ref p_a1 p_m1 p_n1) 0 2)
    (array-set! res1 p_m2 0 3)    
    (array-set! res1 p_n2 0 4)
    (array-set! res1 (array-ref p_a2 p_m2 p_n2) 0 5)
    
    res1))


;;;; grsp-matrix-correwl - Correlate element wise all matrices
;; contained in list p_l1.
;;
;; Keywords:
;;
;; - matrix, element, correlation, matrices
;;
;; Parameters:
;;
;; - p_l1: list of matrices.
;;
;; Notes:
;;
;; - All matrices of list p_l1 should have the rows and columns of the
;;   same size.
;; - See grsp-matrix-row-corr.
;;
;; Output:
;;
;; - Returns a list of two elements:
;;
;;   - Elem 0:
;;
;;     - #t: if the correlation was possible.
;;     - #f: otherwise.
;;
;;   - Elem 1:
;;
;;     - 0: if Elem 1 is #f.
;;     - Correlation matrix, otherwise.
;;
(define (grsp-matrix-correwl p_l1)
  (let ((res1 '())
	(a0 0)
	(a1 0)
	(a2 0)
	(b1 #f)
	(b2 #f)
	(j1 1)
	(i2 0)
	(j2 0))

    ;; This function requires that all matrices in the list have the
    ;; same number of rows and cols.
    (set! b1 (grsp-matrix-is-samediml p_l1))

    (cond ((equal? b1 #t)

	   ;; Using first matrix as reference.
	   (set! a0 (list-ref p_l1 0))

	   (set! j1 1)
	   (while (< j1 (length p_l1))

		  ;; a1 is the matrix a0 will be correlated to in this
		  ;; instance.
		  (set! a1 (list-ref p_l1 j1))

		  (set! i2 (grsp-lm a0))
		  (while (<= i2 (grsp-hm a0))

			 (set! j2 (grsp-ln a0))
			 (while (<= j2 (grsp-hn a0))
				
				;; Correlate element wise a0 and a1.
				(set! a2 (grsp-matrix-row-corr a0
							       i2
							       j2
							       a1
							       i2
							       j2))
				
				;; Add row to correlation matrix.
				(cond ((equal? b2 #f)
				       (set! res1 a2)
				       (set! b2 #t))
				      (else (begin (set! res1 (grsp-matrix-row-append res1 a2)))))
			 
				(set! j2 (in j2)))
				
			 (set! i2 (in i2)))

		  (set! j1 (in j1)))

	   (set! res1 (list #t res1)))
	  
	  (else (set! res1 (list #f 0))))
        
    res1))


;;;; grsp-matrix-wlongest - Finds if matrix p_a1 has more rows than
;; columns or vice-versa.
;;
;; Keywords:
;;
;; - matrix, size
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - -1 if rows > cols.
;; - 0 if rows = cols-
;; - 1 if rows < cols.
;;
(define (grsp-matrix-wlongest p_a1)
  (let ((res1 0))

    (cond ((> (grsp-tm p_a1) (grsp-tn p_a1))
	   (set! res1 -1))
	  ((< (grsp-tm p_a1) (grsp-tn p_a1))
	   (set! res1 1)))
    
    res1))


;;;; grsp-matrix-mmt - Given matrix p_a1, calculates the product of p_a1
;; and its transposed matrix
;;
;; Keywords:
;;
;; - matrix, product, transpose, aat, mmt
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-mmt p_a1)
  (let ((res1 0)
	(a1 0)
	(a2 0))

    (set! a1 (grsp-matrix-cpy p_a1))
    
    (set! a2 (grsp-matrix-transpose a1))
    (set! res1 (grsp-matrix-opmm "#*" a1 a2))
    
    res1))


;;;; grsp-matrix-mtm - Given matrix p_a1, calculates the product of its
;; transposed matrix and  p_a1.
;;
;; Keywords:
;;
;; - matrix, product, transpose, ata, mtm
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-mtm p_a1)
  (let ((res1 0)
	(a1 0)
	(a2 0))

    (set! a1 (grsp-matrix-cpy p_a1))
    
    (set! a2 (grsp-matrix-transpose a1))
    (set! res1 (grsp-matrix-opmm "#*" a2 a1))
    
    res1))


;;;; grsp-matrix-fsubst - Performs a forward substitution on linear
;; system of equations p_a1 * x = p_a2, solving for coulmn vector x
;;
;; Keywords:
;;
;; - matrix, product, transpose, linear, algebra, equations, system
;;
;; Parameters:
;;
;; - p_a1: matrix, lower triangular, m x m.
;; - p_a2: matrix, column matrix (vector), m x 1.
;;
;; Output:
;;
;; - Column vector (m x 1 matrix).
;;
;; Sources
;;
;; - [61][62][63][64][65].
;;
(define (grsp-matrix-fsubst p_a1 p_a2)
  (let ((res1 0)
	(sum 0)
	(hj 0)
	(b1 0)
	(i1 1)
	(j1 0)
	(y1 0))

    ;; Prepare working matrices.
    (set! res1 (grsp-matrix-create-dim 0 p_a2)) 
    (array-set! res1 (array-ref p_a2 0 0) 0 0) ;; y0 = b0

    ;; Row loop.
    (let loop ((i1 1))
      (if (<= i1 (grsp-hm res1))
	  
	  (begin (set! sum 0)
		 (set! hj (- i1 1))
		 
		 ;; Col loop.
		 (begin (let loop ((j1 0))
			  (if (<= j1 hj)

			      (begin (set! sum (+ sum
						  (* (array-ref p_a1
								i1
								j1)
						     (array-ref res1
								j1
								0))))
				     
				     (loop (+ j1 1))))))

		 ;; Find matrix var.
		 (set! y1 (- (array-ref p_a2 i1 0) sum))
		 (array-set! res1 y1 i1 0)
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-bsubst - Performs a backward substitution on linear
;; system of equations p_a1 * x = p_a2, solving for column vector x.
;;
;; Keywords:
;;
;; - matrix, product, transpose, linear, algebra, equations, system
;;
;; Parameters:
;;
;; - p_a1: matrix, upper triangular, m x m.
;; - p_a2: matrix, column matrix (vector), m x 1.
;;
;; Output:
;;
;; - Column vector (m x 1 matrix).
;;
;; Sources
;;
;; - [61][62][63][64][65].
;;
(define (grsp-matrix-bsubst p_a1 p_a2)
  (let ((res1 0)
	(sum 0)
	(hj (grsp-hn p_a1))
	(n1 0)
	(n2 0)
	(b1 0)
	(i1 1)
	(j1 0)
	(y1 0))

    ;; Prepare working matrices.
    (set! res1 (grsp-matrix-create-dim 0 p_a2))

    ;; y[n] = B[n] / U[n,n]
    (array-set! res1 (/ (array-ref p_a2 hj 0)
			(array-ref p_a1 hj hj))
		hj
		0) 

    ;; Dec cycle.
    (let loop ((i1 (- hj 1)))
      (if (>= i1 0)
	   
	   ;; Summation
	  (begin (set! sum 0)
		 (let loop ((j1 (+ i1 1)))
		   (if (<= j1 hj)

		       (begin (set! sum (+ sum (* (array-ref p_a1
							     i1
							     j1)
						  (array-ref res1
							     j1
							     0))))
			      ;;(set! j1 (in j1))
			      
			      (loop (+ j1 1)))))
		 
		 ;; Find matrix var.
		 (set! y1 (/ (- (array-ref p_a2 i1 0) sum)
			     (array-ref p_a1 i1 i1)))
		 (array-set! res1 y1 i1 0)	   

	   (loop (- i1 1)))))
	   
    res1))


;;;; grsp-matrix-compatibility - Returns #t if the two matrices are
;; compatible for operation p_s1, and returns #f otherwise.
;;
;; Keywords:
;;
;; - matrix, product, sum, compatibility
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#+": matrix sum.
;;   - "#*": matrix multplication (Binet).
;;   - "#*f" matrix inner product (Frobenius) See [68].
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
;; Output:
;;
;; - Boolean.
;;
;; Sources:
;;
;; - [68].
;;
(define (grsp-matrix-compatibility p_s1 p_a1 p_a2)
  (let ((res1 #f))

    (cond ((equal? p_s1 "#+")

	   (cond ((equal? (and (equal? (grsp-tm p_a1) (grsp-tm p_a2)) (equal? (grsp-tn p_a1) (grsp-tn p_a2))) #t)
		  (set! res1 #t))))

	  ((equal? p_s1 "#*f")
	   (set! res1 (grsp-matrix-compatibility "#+" p_a1 p_a2)))
	  
	  ((equal? p_s1 "#*")

	   (cond ((equal? (grsp-tn p_a1) (grsp-tn p_a2))
		  (set! res1 #t)))))
		      
    res1))


;;;; grsp-matrix-part-create - Creates a partition table for matrix p_a1
;; according to p_s1.
;;
;; Keywords:
;;
;; - matrix, partition
;;
;; Parameters:
;;
;; - p_s1: partition type.
;;
;;   - "#col": columnar.
;;   - "#row": row.
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Matrix.
;;
;; Sources:
;;
;; - [70].
;;
(define (grsp-matrix-part-create p_s1 p_a1)
  (let ((res1 0)
	(tm 0)
	(tn 0)
	(i1 0)
	(j1 0))

    (set! tm (grsp-tm p_a1))
    (set! tn (grsp-tn p_a1))    
    
    (cond ((equal? p_s1 "#col")
	   ;; Create partition matrix.
	   (set! res1 (grsp-matrix-create-fix "#part" tn))

	   ;; Cycle.
	   (let loop ((j1 (grsp-ln p_a1)))
	     (if (<= j1 (grsp-hn p_a1))
		 (begin (array-set! res1 (grsp-lm p_a1) j1 0)
			(array-set! res1 (grsp-hm p_a1) j1 1)
			(array-set! res1 j1 j1 2)
			(array-set! res1 j1 j1 3)
			(array-set! res1 0 j1 4)
			(array-set! res1 j1 j1 5)
			(loop (+ j1 1))))))
	   
	  ((equal? p_s1 "#row")
	   ;; Create partition matrix.
	   (set! res1 (grsp-matrix-create-fix "#part" tm))

	   ;; Cycle.
	   (let loop ((i1 (grsp-lm p_a1)))
	     (if (<= i1 (grsp-hm p_a1))
		 (begin (array-set! res1 i1 i1 0)
			(array-set! res1 i1 i1 1)
			(array-set! res1 (grsp-ln p_a1) i1 2)
			(array-set! res1 (grsp-hn p_a1) i1 3)
			(array-set! res1 i1 i1 4)
			(array-set! res1 0 i1 5)
			(loop (+ i1 1)))))))
    
    res1))


;;;; grsp-matrix-is-filled-with - Returns true if all elements of
;; matrix p_a1 are equal to value p_n1.
;;
;; Keywords:
;;
;; - matrix, values
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_n1: value.
;;
;; Output:
;;
;; - Boolean.
;;
(define (grsp-matrix-is-filled-with p_a1 p_n1)
  (let ((res1 #t)
	(i1 0)
	(j1 0))

    ;; Cycle rows.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;; Cycle cols.
	  (let loop ((j1 (grsp-ln p_a1)))
	    (if (<= j1 (grsp-hn p_a1))

		(cond ((equal? (equal? (array-ref p_a1 i1 j1) p_n1) #f)
		       (set! res1 #f)
		       (set! i1 (grsp-hm p_a1))
		       (set! j1 (grsp-hn p_a1))))
		       
		(loop (+ j1 1))))
      
      (loop (+ i1 1))))    

    res1))


;;;; grsp-matrix-row-selectrn - Selects row p_m1 from matrix p_a1.
;;
;; Keywords:
;;
;; - matrix, selection, row
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: row number.
;;
;; Output:
;;
;; - Matrix (row vector).
;;
(define (grsp-matrix-row-selectrn p_a1 p_m1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-subcpy p_a1
				   p_m1
				   p_m1
				   (grsp-ln p_a1)
				   (grsp-hn p_a1)))
    
    res1))


;;;; grsp-matrix-row-selectcn - Selects col p_n1 from matrix p_a1.
;;
;; Keywords:
;;
;; - matrix, selection, col
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: col number.
;;
;; Output:
;;
;; - Matrix (col vector).
;;
(define (grsp-matrix-col-selectcn p_a1 p_n1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-subcpy p_a1
				   (grsp-lm p_a1)
				   (grsp-hm p_a1)
				   p_n1
				   p_n1))
    
    res1))


;;;; grsp-matrix-row-subrepf - Replace in matrix p_a1 all rows with row
;; vector p_a2 where col p_j1 has a value equal to p_v1.
;;
;; Keywords:
;;
;; - matrix, replacement, col, row
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2; matrix, row vector of the same number of cols as p_a1.
;; - p_j1: col number.
;; - p_v1: value.
;;
;; Notes:
;;
;; - See grsp-matrix-row-subreps.
;;
;; Output:
;;
;; - Matrix. Updated p_a1.
;;
(define (grsp-matrix-row-subrepf p_a1 p_a2 p_j1 p_v1)
  (let ((res1 0)
	(res2 0)
	(i1 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))
    
    ;; Cycle.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))
	  
	  (begin (cond ((equal? (array-ref res1 i1 p_j1) p_v1)
			(set! res1 (grsp-matrix-subrep res1
						       res2
						       i1
						       (grsp-ln res1))))) 
	  
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-row-subreps - For each and all rows of p_a2, replace
;; in matrix p_a1 all rows with row vector p_a2 where col p_n1 is equal
;; to p_v1. This is the same as saying that this function applies
;; grsp-matrix-row-subrepf to all elements in p_a2, in order.
;;
;; Keywords:
;;
;; - matrix, replacement, col, row
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2; matrix from wich row vectors will be procesed.
;; - p_j1: col number for p_a1
;; - p_j2: col number for p_a2
;; - p_v1: key value for p_a1.
;; - p_v2: key value for p_a2.
;;
;; Notes:
;;
;; - See grsp-matrix-row-subrepf.
;;
;; Output:
;;
;; - Matrix. Updated p_a1.
;;
(define (grsp-matrix-row-subreps p_a1 p_a2 p_j1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(b1 #t)
	(n1 0)
	(n2 0)
	(i1 0)
	(i2 0)
	(j2 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))
    (set! res2 (grsp-matrix-cpy p_a2))
    
    ;; Cycle.
    (let loop ((i2 (grsp-lm res2)))
      (if (<= i2 (grsp-hm res2))

	  ;; Get key value.
	  (begin (set! n2 (array-ref res2 i2 p_j1))
		 
		 (set! b1 #t)
		 (set! i1 (grsp-lm res1))
		 (while (equal? b1 #t)
			(set! n1 (array-ref res1 i1 p_j1))

			;; On row found.
			(cond ((equal? i1 i2)
			       (set! res3 (grsp-matrix-subcpy res2 i2 i2 (grsp-ln res2) (grsp-hn res2)))
			       (set! res1 (grsp-matrix-subrep res1 res3 i1 (grsp-ln res1)))
			       (set! b1 #f)))

			(set! i1 (in i1)))
		 
		 (loop (+ i2 1)))))
    
    res1))


;;;; grsp-matrix-ldvl - Line, display title, display matrix. line.
;; Displays p_n1 blank lines before string p_s1 and matrix p_a2, and
;; p_n2 blank lines after p_s1.
;;
;; Keywords:
;;
;; - console, strings, matrices
;;
;; Parameters:
;;
;; - p_s1: string.
;; - p_a1: matrix.
;; - p_n1: number of new lines preceeding the string.
;; - p_n2: number of new lines after the string.
;;
;; Examples:
;;
;; - example28.scm.
;;
;; Output:
;;
;; - String as title, and matrix.
;;
(define (grsp-matrix-ldvl p_s1 p_a1 p_n1 p_n2)
  (grsp-ldl p_s1 p_n1 p_n2)
  (grsp-matrix-display p_a1))


;;;; grsp-matrix-blur - Adds noise to elements of matrix p_a1 using stats
;; distribution p_s1 with standard deviation p_v1.
;;
;; Keywords:
;;
;; - matrices, random, noise
;;
;; Parameters:
;;
;; - p_s1: type of distribution.
;;
;;   - "#normal": normal.
;;   - "#exp": exponential.
;;   - "#uniform": uniform.
;;
;; - p_a1: matrix.
;; - p_v1: standard deviation.
;;
;; Notes:
;;
;; - Values in p_a1 will act as statistical mean in each case.
;; - See grsp2.grsp-rprnd, grsp0.grsp-random-state-set.
;; - With a normal distribution, mean 0 and variance 1 you shoild get
;;   Gaussian noise.
;;
;; Output:
;;
;; - Matrix, numeric.
;;
(define (grsp-matrix-blur p_s1 p_a1 p_v1)
  (let ((res1 0)
	(i1 0)
	(j1 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Row loop.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln res1)))
		   (if (<= j1 (grsp-hn res1))

		       ;; Replace element value by its noisy or blurred
		       ;; variant.
		       (begin (array-set! res1
					  (grsp-rprnd p_s1
						      (array-ref res1
								 i1
								 j1)
						      p_v1)
					  i1
					  j1)		       
			      
			      (loop (+ j1 1)))))
	  
	  (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-col-replacev - Replace all instances in column p_j1
;; with p_v2 in matrix p_a1 for p_j1 elements with relationship p_s1
;; betwheen them and value p_v1.
;;
;; Keywords:
;;
;; - matrices, replace, columns, values
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#="; equal.
;;   . "#!=" not equal.
;;   - "#<"; less than.
;;   - "#>"; greater than.
;;   - "#<="; less or equal.
;;   - "#>="; greater or equal than.
;;
;; - p_a1; matrix.
;; - p_j1: numeric, column number.
;; - p_v1; value.
;; - p_v2; value
;; - p_v3: value.
;;
;; Output:
;;
;; . Matrix.
;;
(define (grsp-matrix-col-replacev p_s1 p_a1 p_j1 p_v1 p_v2)
  (let ((res1 0)
	(v3 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Cycle.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))
	  
	  (begin (set! v3 (array-ref res1 i1 p_j1))
		 
		 (cond ((equal? p_s1 "#=")

			(cond ((= v3 p_v1)
			       (array-set! res1 p_v2 i1 p_j1))))

		       ((equal? p_s1 "#!=")

			(cond ((equal? (= v3 p_v1) #f)
			       (array-set! res1 p_v2 i1 p_j1))))
		       
		       ((equal? p_s1 "#<")

			(cond ((< v3 p_v1)
			       (array-set! res1 p_v2 i1 p_j1))))

		       ((equal? p_s1 "#>")

			(cond ((> v3 p_v1)
			       (array-set! res1 p_v2 i1 p_j1))))

		       ((equal? p_s1 "#<=")

			(cond ((<= v3 p_v1)
			       (array-set! res1 p_v2 i1 p_j1))))

		       ((equal? p_s1 "#>=")

			(cond ((>= v3 p_v1)
			       (array-set! res1 p_v2 i1 p_j1)))))      
	  
		 (loop (+ i1 1)))))
	
    res1))


;;;; grsp-matrix-selectmb - Select a mini-batch of random rows from p_a1.
;;
;; Keywords:
;;
;; - random, group, combinatorics, combination
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2; integer, batch sizw.
;;
(define (grsp-matrix-selectmb p_a1 p_m1)
  (let ((res1 0)
	(res2 0)
	(m1 0)
	(m2 0))

    ;; If p_m1 is higher than the number of rows in p_a1, replace m1
    ;; with the number of rows of p_a1. In this case the mini batch
    ;; will be of the same size as the matrix.
    (set! m1 p_m1)
    (cond ((> m1 (grsp-tm p_a1))
	   (set! m1 (grsp-tm p_a1))))

    ;; Create a matrix of m1 rows and with the same number of cols as
    ;; p_a1.
    (set! res1 (grsp-matrix-create 0 m1 (grsp-tn p_a1)))
    
    ;; Cycle.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  (begin (set! m2 (random (+ (grsp-tm res1) 1)))
		 
		 (set! res2 (grsp-matrix-subcpy p_a1
						m2
						m2
						(grsp-ln p_a1)
						(grsp-hn p_a1)))
		 (set! res1 (grsp-matrix-subrep res1
						res2
						i1
						(grsp-ln res1)))
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-row-opscr - Performs operation p_s1 row by row on p_a1
;; and places scalar results on a column vector.
;;
;; Keywords:
;;
;; - functions, algebra, matrix, matrices
;;
;; Parameters:
;;
;; - p_s1:
;;
;;   - "#+": sum.
;;   - "#-": substraction.
;;   - "#*": product.
;;   - "#/": division.
;;
;; - p_a1: matrix.
;;
;; - Matrix.
;;
(define (grsp-matrix-row-opscr p_s1 p_a1)
  (let ((res1 0)
	(res2 0)
	(n1 0)
	(j2 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-create 0 (grsp-tm p_a1) 1))

    ;; Cycle.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  (begin (set! j2 (grsp-ln p_a1))

		 ;; Set res2 to the value of the first col and increment
		 ;; j2 to start from the following column.
		 (set! res2 (array-ref p_a1 i1 j2))
		 (set! j2 (in j2))
		 
		 (let loop ((j1 j2))
		   (if (<= j1 (grsp-hn p_a1))
		       
		       (begin (set! n1 (array-ref p_a1 i1 j1))

			      (cond ((equal? p_s1 "#+")
				     (set! res2 (+ res2 n1)))
				    ((equal? p_s1 "#-")
				     (set! res2 (- res2 n1)))
				    ((equal? p_s1 "#*")
				     (set! res2 (* res2 n1)))
				    ((equal? p_s1 "#/")
				     (set! res2 (/ res2 n1))))

			      (array-set! res1 res2 i1 0)
			      
			      (loop (+ j1 1)))))	 
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-ms2dbc - Casts a matrix of strings as a matrix of numbers
;; representing those strings as numeric values.
;;
;; Keywords:
;;
;; - casting, convert, strings, numeric
;;
;; Parameters:
;;
;; - p_a1: matrix containing strings.
;;
;; Notes:
;;
;; - See grsp-s2dbc, grsp-dbc2s, grsp-dbc2ms.
;; - This function is the oppositoe of grsp-dbc2ms.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-ms2dbc p_a1)
  (let ((res1 0)
	(s1 0)
	(n1 0))

    (set! res1 (grsp-matrix-create-dim 0 p_a1))

    ;; Row loop.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln p_a1)))
		   (if (<= j1 (grsp-hn p_a1))

		       (begin (set! s1 (array-ref p_a1 i1 j1))
			      (set! n1 (grsp-s2dbc s1))
			      (array-set! res1 n1 i1 j1)
			      
			      (loop (+ j1 1)))))		 
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-dbc2ms - Casts a dbc matrix of numbers representing strings
;; as a matrix of strings.
;;
;; Keywords:
;;
;; - casting, convert, strings, numeric
;;
;; Parameters:
;;
;; - p_a1: matrix containing numbers representing strings.
;;
;; Notes:
;;
;; - See grsp-s2dbc, grsp-dbc2s, grsp-ms2dbc.
;; - This function is the opposite of grsp-ms2dbc.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-dbc2ms p_a1)
  (let ((res1 0)
	(s1 0)
	(n1 0))

    (set! res1 (grsp-matrix-create-dim "" p_a1))

    ;; Row loop.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln p_a1)))
		   (if (<= j1 (grsp-hn p_a1))

		       (begin (set! n1 (array-ref p_a1 i1 j1))
			      (set! s1 (grsp-dbc2s n1))
			      (array-set! res1 s1 i1 j1)
			      
			      (loop (+ j1 1)))))		 
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-split - From matrix p_a1 with primary key on column 0,
;; this function creates two matrices:
;;
;; - Matrix 1: from col 0 to col p_n1.
;; - Matrix 2: at col 0 it copies col 9 from p_a1, and from p_n1+1 to
;;   col hn (last col on the right).
;;
;; Keywords:
;;
;; - splitting, matrices, separate
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_n1: numeric, col number.
;;
;; Notes:
;;
;; - Matrix p_a1 must have a primary key on col 0.
;; - Both output matrices wiññ have the same primary keys on col 0.
;;
;; Output:
;;
;; - A list of two matrices.
;;
(define (grsp-matrix-split p_a1 p_n1)
  (let ((res1 '())
	(a1 0)
	(a2 0)
	(a3 0)
	(a4 0))

    ;; First matrix.
    (set! a1 (grsp-matrix-subcpy p_a1
				 (grsp-lm p_a1)
				 (grsp-hm p_a1)
				 (grsp-ln p_a1)
				 p_n1))
    
    ;; Intermediate matrix.
    (set! a3 (grsp-matrix-subcpy p_a1
				 (grsp-lm p_a1)
				 (grsp-hm p_a1)
				 (+ p_n1 1)
				 (grsp-hn p_a1)))

    ;; Second matrix.
    (set! a2 (grsp-matrix-create 0 (grsp-tm a3) (+ (grsp-tn a3) 1)))

    ;; Set col 0 of a2 with the same primary keys as a1.
    (set! a4 (grsp-matrix-subcpy a1 (grsp-lm a1) (grsp-hm a1) 0 0))
    (set! a2 (grsp-matrix-subrep a2 a4 0 0))    
    (set! a2 (grsp-matrix-subrep a2 a3 0 1))
    
    ;; Compose results.
    (set! res1 (list a1 a2))
    
    res1))


;;;; grsp-matrix-inputev - Input a value in element p_i1 p_j1 of matrix
;; p_a1 interactively.
;;
;; Keywords:
;;
;; - interactive, data, entry, matrices, input, enter, entering, loading
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t to show p_a1 before entering the value.
;;   - #f otherwise.
;;
;; - p_b2: boolean.
;;
;;   - #t to show p_a1 after entering the value.
;;   - #f otherwise.
;;
;; - p_a1: matrix.
;; - p_i1; numeric, row coordinate.
;; - p_j1: numeric, col coordinate.
;;
;; Notes:
;;
;; - For string and numeric matrices only.
;;
(define (grsp-matrix-inputev p_b1 p_b2 p_a1 p_i1 p_j1)
  (let ((res1 0)
	(res2 0)
	(s1 "")
	(s2 "")
	(s3 "")
	(s4 "")
	(s5 "")
	(n1 0))

    (set! res2 (grsp-matrix-cpy p_a1))
    (set! res1 (grsp-my2ms res2))
    
    (cond ((equal? p_b1 #t)
	   (clear)
	   (grsp-ldl (gconsts "mbu") 0 0)
	   (grsp-matrix-display res1)))

    (set! s5 (array-ref res1 p_i1 p_j1))    
    (set! s4 (strings-append (list (gconsts "cve")
				   (grsp-n2s p_i1)
				   ", "
				   (grsp-n2s p_j1)
				   "]  "
				   s5)
			     0))			     
    
    (set! s1 (strings-append (list (gconsts "nve")
				   (grsp-n2s p_i1)
				   ", "
				   (grsp-n2s p_j1)
				   "]? ")
			     0))
    (grsp-ldl s4 1 1)
    (set! s2 (grsp-ask s1))

    (cond ((symbol? s2)    
	   (set! s3 (symbol->string s2)))
	  ((number? s2)
	   (set! s3 (grsp-n2s s2)))
	  ((string? s2)
	   (set! s3 s2)))
    
    (cond ((string? (array-ref res1 p_i1 p_j1))
	   (array-set! res1 s3 p_i1 p_j1))
	  ((number? (array-ref res1 p_i1 p_j1))
	   (set! n1 (grsp-s2n s3))
	   (array-set! res1 n1 p_i1 p_j1)))

    (cond ((equal? p_b2 #t)
	   (clear)
	   (grsp-ldl (gconsts "mau") 0 0)	   
	   (grsp-matrix-display res1)))
    
    res1))


;;;; grsp-matrix-row-inputev - Input a value in every element of row
;; p_i1 of matrix p_a1 interactively.
;;
;; Keywords:
;;
;; - interactive, data, entry, matrices, input, enter, entering, loading
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t to show p_a1 before entering the value.
;;   - #f otherwise.
;;
;; - p_b2: boolean.
;;
;;   - #t to show p_a1 after entering the value.
;;   - #f otherwise.
;;
;; - p_a1: matrix.
;; - p_i1; numeric, row number.
;;
;; Notes:
;;
;; - For string and numeric matrices only.
;;
(define (grsp-matrix-row-inputev p_b1 p_b2 p_a1 p_i1)
  (let ((res1 0))

    ;; Safety copy
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Col loop.
    (let loop ((j1 (grsp-ln p_a1)))
      (if (<= j1 (grsp-hn p_a1))

	  (begin (set! res1 (grsp-matrix-inputev p_b1 p_b2 res1 p_i1 j1))
		 
		 (loop (+ j1 1)))))
    
    res1))


;;;; grsp-matrix-row-inputev - Input a value in every element of every
;; row of matrix p_a1 between rows p_i1 and p_i2 interactively.
;;
;; Keywords:
;;
;; - interactive, data, entry, matrices, input, enter, entering, loading
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t to show p_a1 before entering the value.
;;   - #f otherwise.
;;
;; - p_b2: boolean.
;;
;;   - #t to show p_a1 after entering the value.
;;   - #f otherwise.
;;
;; - p_a1: matrix.
;; - p_i1; numeric, row number, initial.
;; - p_i2; numeric, row number, final.
;;
;; Notes:
;;
;; - For string and numeric matrices only.
;;
(define (grsp-matrix-rows-inputev p_b1 p_b2 p_a1 p_i1 p_i2)
  (let ((res1 0))

    ;; Safety copy
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Row loop.
    (let loop ((i1 p_i1))
      (if (<= i1 p_i2)

	  (begin (set! res1 (grsp-matrix-row-inputev p_b1 p_b2 res1 i1))
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-rows-addev - Add rows to matrix p_a1 interactively.
;;
;; Keywords:
;;
;; - interactive, data, entry, matrices, input, enter, entering, loading
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t to show p_a1 before entering the value.
;;   - #f otherwise.
;;
;; - p_b2: boolean.
;;
;;   - #t to show p_a1 after entering the value.
;;   - #f otherwise.
;;
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - For string and numeric matrices only.
;;
(define (grsp-matrix-rows-addev p_b1 p_b2 p_a1)
  (let ((res1 0)
	(b3 #t))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))
    
    (while (equal? b3 #t)
	   (clear)
	   (grsp-ldl (gconsts "arm") 0 1)
	   (grsp-matrix-display res1)	   
	   (set! b3 (grsp-confirm b3))
	   
	   (cond ((equal? b3 #t)
		  (set! res1 (grsp-matrix-subexp res1 1 0))
		  (set! res1 (grsp-matrix-row-inputev p_b1
						      p_b2
						      res1
						      (grsp-hm res1))))))
	       
    res1))


;;;; grsp-matrix-lm-filled-with - Returns #t if the p_i1 initial rows of
;; the matrix are filled with value p_v1. If p_i1 exceeds the total
;; number of rows of p_a1, then the function with perform the evaluation
;; not on the number of rows delcared by p_i1 but on the total numbero
;; of rows in the matrix.
;;
;; Keywords:
;;
;; - initial, empty, row, record
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_i1: numeric, number of rows to test.
;; - p_v1: value.
;;
(define (grsp-matrix-rows-filled-with p_a1 p_i1 p_v1)
  (let ((res1 #f)
	(res2 0)
	(i1 0)
	(tm 0))

    (set! tm (grsp-tm p_a1))
    
    (cond ((> p_i1 tm)
	   (set! i1 tm))
	  (else (set! i1 p_i1)))
    
    (set! res2 (grsp-matrix-subcpy p_a1
				   (grsp-lm p_a1)
				   (- i1 1)
				   (grsp-ln p_a1)
				   (grsp-hn p_a1)))
    
    (set! res1 (grsp-matrix-is-filled-with res2 p_v1))
    
    res1))
    

;;;; grsp-matrix-displayts - Display string matrix p_a1 with column
;; titles according to string list p_l1.
;;
;; Keywords
;;
;; - matrix, display, titled, titles, names, columns
;;
;; Parameters:
;;
;; - p_a1: matrix of strings.
;; - p_l1: list of strings.
;;
;; Notes:
;;
;; - The number of elements of p_l1 should be the same as the number of
;;   columns of p_a1
;;
(define (grsp-matrix-displayts p_a1 p_l1)
  (let ((res1 0)
	(a1 0)
	(a2 0))

    ;; Safety copy.
    (set! a1 (grsp-matrix-cpy p_a1))

    ;; Create col headers
    (set! res1 (grsp-ms-create-col-headers p_a1 p_l1))
    
    ;; Add col headers.
    (set! res1 (grsp-matrix-subadd res1 a1))     

    ;; Create row headers.
    (set! a2 (grsp-ms-create-row-headers res1))
    
    ;; Add row headers.
    (set! res1 (grsp-matrix-subrep a2 res1 0 1))
    
    ;; Display.
    (grsp-matrix-display res1)))


;;;; grsp-matrix-subadd - Add p_a2 at the bottom of p_a1. 
;;
;; Keywords:
;;
;; - paste, add
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;;
(define (grsp-matrix-subadd p_a1 p_a2)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(lm2 0))

    (set! a1 (grsp-matrix-cpy p_a1))
    (set! a2 (grsp-matrix-cpy p_a2))
    (set! lm2 (+ (grsp-hm a1) 1))
    (set! a1 (grsp-matrix-subexp a1 (grsp-tm a2) 0))
    (set! res1 (grsp-matrix-subrep a1 a2 lm2 0))
    
    res1))  


;;;; grsp-matrix-displaytn - Display numeric matrix p_a1 with column
;; titles according to string list p_l1.
;;
;; Keywords
;;
;; - matrix, display, titled, titles, names, columns
;;
;; Parameters:
;;
;; - p_a1: matrix, numeric.
;; - p_l1: list of strings.
;;
;; Notes:
;;
;; - The number of elements of p_l1 should be the same as the number of
;;   columns of p_a1
;;
(define (grsp-matrix-displaytn p_a1 p_l1)
  (let ((a1 0))

    (set! a1 (grsp-mn2ms p_a1))
    (grsp-matrix-displayts a1 p_l1)))


;;;; grsp-matrix-edit - Edit a matrix interactively.
;;
;; Keywords:
;;
;; - edit, add, delete, interactive, edition, modification
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_l1: list of strings, column names or titles.
;; - p_l2: list of default values per row.
;; - p_l3: list of properties per col.
;;
;;   - "#str": string.
;;   - "#num": numeric.
;;   - "#bol": boolean.
;;   - "#key": primary key column.
;;   - "#ai": autoincrement.
;;   - "#0": start counting from zero.
;;   - "#key#num#ai": autoincrementable, numeric, primary key.
;;   - "": no properties.
;; - p_a4: source matrix of p_a1. See grsp-matrix-displaytm.
;;
(define (grsp-matrix-edit p_a1 p_l1 p_l2 p_l3 p_a4)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(a3 0)
	(n1 0)
	(i1 0)
	(j1 0)
	(b1 #t))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    (while (equal? b1 #t)

	   ;; Clean the matrix of uncontrolled, induced types.
	   (set! res1 (grsp-my2ms res1))
	   (set! res1 (grsp-ms2my res1))
	   
	   ;; Display matrix.
	   (grsp-color-set "fgreen")
	   (grsp-matrix-displaytms res1 p_l1 p_l3 p_a4)
	   (grsp-color-set "fcyan")
	   (grsp-ldl (gconsts "01234") 0 0)
	   (grsp-color-set "fdefault")
	   (set! n1 (grsp-askn "? "))

	   (cond ((equal? n1 0)
		  (set! b1 #f))
		 ((equal? n1 1)
		  (set! i1 (grsp-askn (gconsts "row")))
		  (set! j1 (grsp-askn (gconsts "col")))
		  (set! res1 (grsp-matrix-inputev #f #f res1 i1 j1)))
		 ((equal? n1 2)
		  (set! res1 (grsp-matrix-row-subexpk res1 p_l2 p_l3)))
		 ((equal? n1 3)		  
		  (set! i1 (grsp-askn (gconsts "row")))
		  (set! res1 (grsp-matrix-subdel "#Delr" res1 i1)))
		 ((equal? n1 4)
		  (set! i1 (grsp-askn (gconsts "row")))

		  ;; If a pr key col is found (the function returns a
		  ;; number instead of a #f value.
		  (cond ((equal? (number? (grsp-matrix-find-if-prkey-exists p_l3)) #t)

			 ;; Get the col number.
			 (set! n1 (grsp-matrix-find-if-prkey-exists p_l3))
			 (set! res1 (grsp-matrix-editu res1
						       i1
						       p_l2
						       n1)))))))

    res1))

  
;;;; grsp-my2ms - Casts a matrix with columns of multiple data types as a
;; matrix of strings.
;;
;; Keywords:
;;
;; - cast, types, argtyoe
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - The following types cannot be cast as strings:
;;
;;   - 0: undefined.
;;   - 1: list.
;;   - 3: array.
;;
(define (grsp-my2ms p_a1)
  (let ((res1 0)
	(s1 "")
	(a1 0))
    
    ;; Safety copy.
    (set! a1 (grsp-matrix-cpy p_a1))

    ;; Create results matrix.
    (set! res1 (grsp-matrix-create-dim " " a1))

    ;; go over the matrix and cast each element.
    
    ;; Row loop.
    (let loop ((i1 (grsp-lm a1)))
      (if (<= i1 (grsp-hm a1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln a1)))
		   (if (<= j1 (grsp-hn a1))

		       (begin (set! s1 (grsp-y2s (array-ref a1 i1 j1)))
			      (array-set! res1 s1 i1 j1)
			      
			      (loop (+ j1 1)))))		 
		 
		 (loop (+ i1 1)))))    
    
    res1))
  

;;;; grsp-matrix-displaytn - Displays the type matrix of matrix p_a1
;; and returns said type matrix.
;;
;; Keywords
;;
;; - matrix, types, columns, data
;;
;; Parameters:
;;
;; - p_a1: matrix, numeric.
;; - p_3: string list, matrix properties.
;; - p_a4: source matrix (the matrix from which p_a1
;;   has been extracted. Should pass p_a1 as argumrnt here
;;   if it is the source.
;;
;; Output:
;;
;; - Matrix, datatypes of p_a1.
;;
(define (grsp-matrix-displaytm p_a1 p_l3 p_a4)
  (let ((res1 0)
	(a2 0)
	(a3 0)
	(a4 0)
	(b1 #t)
	(s1 "")
	(s2 " - ")
	(s3 "")
	(n1 0)
	(k1 0)
	(k4 0))

    ;; Find out if there is a primary key, and if so, the corresponding
    ;; column number.
    (cond ((equal? (grsp-lal-esubstr p_l3 "#key") #f)
	   (set! b1 #f))
	  (else (set! n1 (grsp-lal-esubstr p_l3 "#key"))))

    ;; Do not look into empty matrices.
    (cond ((equal? (null? p_a1) #t)
	   (set! b1 #t)))
    
    ;; If key is found build a string to inform the max key value found
    ;; in the submatrix and the source matrix. 
    (cond ((equal? b1 #f)
	   (set! a2 (grsp-matrix-row-minmax "#max" p_a1 n1))
	   (set! a4 (grsp-matrix-row-minmax "#max" p_a4 n1))
	   (set! k1 (array-ref a2 0 n1))
	   (set! k4 (array-ref a4 0 n1))	   
	   
	   (set! s1 (strings-append (list s1
					  (gconsts "Mpkv")
					  (grsp-n2s k1)
					  " "
					  (gconsts "ac")
					  (grsp-n2s n1))					  
				    0))

	   (set! s3 (strings-append (list s3
					  (gconsts "Mspkv")
					  (grsp-n2s k4)
					  " "
					  (gconsts "ac")
					  (grsp-n2s n1))					  
				    0))))
    
    (grsp-ldl (gconsts "dat") 0 0)
    (set! res1 (grsp-matrix-argstru p_a1))
    (grsp-matrix-display res1)
    (grsp-ldl (strings-append (list (gconsts "Lr")
				    (grsp-n2s (grsp-hm p_a1))
				    s2
				    (gconsts "Lc")
				    (grsp-n2s (grsp-hn p_a1))
				    s2
				    s1
				    s2
				    s3)
			      0)
	      0
	      0)
    
    res1))


;;;; grsp-matrix-editu - Sets default values contained in list p_l2 in
;; row p_i1 of matrix p_a1.
;;
;; Keywords:
;;
;; - default, initial
;;
;; Parameters:
;; 
;; - p_a1: matrix.
;; - p_i1: numeric, row number.
;; - p_l2: list of default values for every element of row p_i1.
;; - p_n1: col number that holds the primary key.
;;
;; Notes:
;;
;; - Be careful not to overwrite existing values in rows that don't
;;   need default values.
;; - This function requires the matrix to have a primary key column.
;;
(define (grsp-matrix-editu p_a1 p_i1 p_l2 p_n1)
  (let ((res1 0))
	
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Col loop.
    (let loop ((j1 (grsp-ln res1)))
      (if (<= j1 (grsp-hn res1))

	  (begin (cond ((equal? (equal? j1 p_n1) #f)

			(array-set! res1 (list-ref p_l2 j1) p_i1 j1)))
		 
		 (loop (+ j1 1))))) 
    
    res1))


;;;; grsp-my2code - Returns the matrix contents as a string of Guile
;; Scheme code.
;;
;; Keywords:
;;
;; - code, coding, programming, edition, lisp, scheme
;;
;; Arguments:
;;
;; - p_s1: string.
;;
;;   - "#define", for define op.
;;   " "#set!", for set! op.
;;
;; - p_s2: string, name of the matrix to create.
;; - p_a1: matrix.
;;
(define (grsp-my2code p_s1 p_s2 p_a1)
  (let ((res1 "")
	(a1 0)
	(s1 "")
	(s2 "")
	(s3 ""))

    ;; First cast the matrix as astring matrix.
    (set! a1 (grsp-my2ms p_a1))

    (cond ((equal? p_s1 "#define")
	   (set! s1 (strings-append (list "(define "
					  p_s2
					  " (grsp-matrix-create "
					  p_s2)
				    0)))
	  ((equal? p_s1 "#set!")
	   (set! s1 (strings-append (list "(set! "
					  p_s2
					  " (grsp-matrix-create "
					  p_s2)
				    0))))
	   
    (set! res1 (strings-append (list s1
				     " "
				     (grsp-n2s (grsp-tm p_a1))
				     " "
				     (grsp-n2s (grsp-tn p_a1))
				     ")")
			       0))
    
    ;; Row loop.
    (let loop ((i1 (grsp-lm a1)))
      (if (<= i1 (grsp-hm a1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln a1)))
		   (if (<= j1 (grsp-hn a1))

		       (begin (set! s2 (array-ref a1 i1 j1))
			      (set! s3 (strings-append (list "(array-set! "
							     p_s2
							     " "
							     s2
							     " "
							     (grsp-n2s i1)
							     " "
							     (grsp-n2s j1)
							     ")")
						       0))
			      (set! res1 (strings-append (list res1 "\n" s3) 0))
			      
			      (loop (+ j1 1)))))		 
		 
		 (loop (+ i1 1)))))

    (set! res1 (strings-append (list res1 "\n") 0))
    
    res1))


;;;; grsp-ms2my - Casts a matrix of strings as a matrix with columns of
;; multiple data types.
;;
;; Keywords:
;;
;; - cast, types, argtyoe
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - The following types cannot be cast using this function.
;;
;;   - 0: undefined.
;;   - 1: list.
;;   - 3: array.
;;
(define (grsp-ms2my p_a1)
  (let ((res1 0)
	(s1 "")
	(a1 0))

    (set! res1 (grsp-matrix-create-dim 0 p_a1))

    ;; Row loop.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln p_a1)))
		   (if (<= j1 (grsp-hn p_a1))

		       (begin (set! s1 (array-ref p_a1 i1 j1))
			      (array-set! res1 (grsp-s2y s1) i1 j1)
			      
			      (loop (+ j1 1)))))		 
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; - Casts as type p_s1 column p_j1 of matrix p_a1.
;;
;; Keywords:
;;
;; - casting, columns, cast
;;
;; Parameters:
;;
;; - p_s1: string, type.
;;
;;   - "#bol"; boolean.
;;   - "#num": numeric.
;;   - "#str": string.
;;
;; - p_a1: matrix.
;; - p_j1: col number.
;;
(define (grsp-cy2cy p_s1 p_a1 p_j1)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(a3 0))

    ;; Safety copy.
    (set! a1 (grsp-matrix-cpy p_a1))

    ;; Extract column.
    (set! a2 (grsp-matrix-subcpy a1 (grsp-lm a1) (grsp-hm a1) p_j1 p_j1))

    ;; Cast the whole column.
    (set! a2 (grsp-my2ms a2))
    
    (cond ((equal? p_s1 "#num")
	   (set! a3 (grsp-ms2mn a2)))
	  ((equal? p_s1 "#bol")
	   (set! a3 (grsp-ms2mb a2))))
	      
    ;; Replace the old colunn in a1 with a3.
    (set! res1 (grsp-matrix-subrep a1 a3 (grsp-lm a1) p_j1))

    res1))


;;;; grsp-ms2mb - Casts mattrix of strings p_a1 representing bollean
;; values as a matrix of bolleans.
;;
;; Keywords:
;;
;; . boole. bollean, logical. cast, casting
;;
;; Arguments:
;;
;; - p_a1: matrix of strings.
;;
(define (grsp-ms2mb p_a1)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(s1 ""))

    ;; Safety copy.
    (set! a1 (grsp-matrix-cpy p_a1))
    (set! a2 (grsp-matrix-create-dim "" a1))
    
    ;; Row loop.
    (let loop ((i1 (grsp-lm a1)))
      (if (<= i1 (grsp-hm a1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln a1)))
		   (if (<= j1 (grsp-hn a1))

		       (begin (set! s1 (array-ref a1 i1 j1))

			      (array-set! a2 (grsp-s2b s1) i1 j1)
			      
			      (loop (+ j1 1)))))
		 
		 (loop (+ i1 1)))))

    (set! res1 a2)
    
    res1))


;;;; grsp-matrix-row-select-like - Selects all rows where the element
;; found at col p_j1 is like p_v1.
;;
;; Keywords:
;;
;; p_a1: matrix.
;; p_j1; number, row.
;; p_v1: value.
;;
;; Output:
;;
;; . Submatrix of p_a1 containing the queried results, if found; zero
;;   otherwise.
;;
(define (grsp-matrix-row-select-like p_a1 p_j1 p_v1)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(s1 "")
	(s2 "")
	(n1 0)
	(v1 ""))

    ;; These two need a check.
    (set! a1 (grsp-my2ms p_a1))
    (set! v1 (grsp-y2s p_v1))
    
    ;; Row loop.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  (begin (set! s1 (array-ref a1 i1 p_j1))

		 (cond ((equal? (number? (string-contains s1 v1)) #t)

			(set! a2 (grsp-matrix-subcpy a1
						     i1
						     i1
						     (grsp-ln a1)
						     (grsp-hn a1)))
			
			(cond ((equal? n1 0)
			       ;; Create results matrix.
			       (set! res1 (grsp-matrix-cpy a2))
			       (set! n1 (in n1)))
			      ((> n1 0)
			       ;; Add row to results matrix.
			       (set! res1 (grsp-matrix-subadd res1
							      a2))))))

		 (loop (+ i1 1)))))

    res1))


;;;; grsp-matrix-sincostan-mth - Calculates sin, cos and tan for
;; elements of matrix p_a1.
;;
;; Keywords:
;;
;; - mth, trigonometric
;;
;; Parameter:
;;
;; . p_a1: matrix, numeric.
;;
;; Output: a list containing:
;;
;; - Elem 0: future of sin calculation of p_a1 elements.
;; - Elem 1: future of cos calculation of p_a1 elements.
;; - Elem 2: future of tan calculation of p_a1 elements.
;;
;; Sources:
;;
;; - [71]. 
;;
(define (grsp-matrix-sincostan-mth p_a1)
  (let ((res1 '())
	(f1 (future (grsp-matrix-opfn "#sin" p_a1)))
	(f2 (future (grsp-matrix-opfn "#cos" p_a1)))
	(f3 (future (grsp-matrix-opfn "#tan" p_a1))))

    (set! res1 (list f1 f2 f3))
  
    res1))


;;;; grsp-matrix-row-number - Returns a list containing the row numbers
;; for each instance in which for matrix p_a1 value p_v1 is found at
;; column p_j1.
;;
;; Keywords:
;;
;; - row, order, numbering
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_v1: value.
;; - p_j1: col number.
;;
;; Output:
;;
;; - If ocurrences are found, it returns a list with the row numbers.
;; - Else returns an empty list.
;;
(define (grsp-matrix-row-number p_a1 p_v1 p_j1)
  (let ((res1 '())
	(l1 '())
	(b1 #f))

    ;; Row loop.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  (begin (cond ((equal? (array-ref p_a1 i1 p_j1) p_v1)

			;; Change value on finding the first ocurrence
			;; and pass the row number to the list.
			(cond ((equal? b1 #f)
			       (set! res1 (list i1))
			       (set! b1 #t))
			      ((equal? b1 #t)
			       (set! l1 (list i1))
			       (set! res1 (append res1 l1))))))
		 
		 (loop (+ i1 1)))))

    res1))


;;;; grsp-matrix-keygen - Creates an unique numeric key value for
;; column p_j1 of matrix p_a1.
;;
;; Keywords:
;;
;; - column, adding, keys, unique
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_j1: col number.
;; - p_n1: increment value.
;;
;; Notes:
;;
;; - Should only be used on columns defined as primary key.
;;
;; Output:
;;
;; - Numeric value.
;;
(define (grsp-matrix-keygen p_a1 p_j1 p_n1)
  (let ((res1 0)
	(a1 0))

    (set! a1 (grsp-matrix-row-minmax "#max" p_a1 p_j1))
    (set! res1 (array-ref a1 0 p_j1))
    (set! res1 (+ res1 p_n1))
    
    res1))


;;;; grsp-matrix-keyapl - Appends a new key value to the element of
;; column p_j1 of the last row of matrix p_a1.
;;
;; Keywords:
;;
;; - column, adding, key, increment, values
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_j1: col number corresponding to the key column.
;; - p_n1: increment step value.
;;
;; Notes:
;;
;; - Should only be used on columns defined as primary key or
;;   autoincrementable.
;; - The user should identify correctly which column will be modified. 
;;
;; Output:
;;
;; - Matrix with a newly unique value for element at col p_j1 of
;;   the last row of matrix p_a1-
;;
(define (grsp-matrix-keyapl p_a1 p_j1 p_n1)
  (let ((res1 0)
	(n1 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Calculate the value for new key.
    (set! n1 (grsp-matrix-keygen res1 p_j1 p_n1))

    ;; Apply key.
    (array-set! res1 n1 (grsp-hm res1) p_j1) 
    
    res1))


;;;; grsp-matrix-subdelr - Deletes rows from p_m1 to p_m2 of matrix p_a1.
;;
;; Keywords:
;;
;; - deletion, submatrix, submatrices
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_m1: numeric, row.
;; - p_m2: numeric, row.
;;
(define (grsp-matrix-subdelr p_a1 p_m1 p_m2)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(m1 0)
	(m2 0))

    ;; Check lower limit coherence.
    (set! m1 (- p_m1 1))
    (cond ((< m1 0)
	   (set! m1 0)))

    ;; Check upper limit coherence.
    (set! m2 (+ p_m2 1))
    (cond ((> m2 (grsp-hm p_a1))
	   (set! m2 p_m2)))
     
    ;; Copy lower block, from the first row to the lower limit.
    (set! a1 (grsp-matrix-subcpy p_a1
				 (grsp-lm p_a1)
				 m1
				 (grsp-ln p_a1)
				 (grsp-hn p_a1)))

    ;; Copy higher block from the upper limit to the last row.
    (set! a2 (grsp-matrix-subcpy p_a1
				 m2
				 (grsp-hm p_a1)
				 (grsp-ln p_a1)
				 (grsp-hn p_a1)))

    ;; The two steps before create two submatrices and leave out the
    ;; rows in the intersection of the lower and higher limits. Then we
    ;; add the two copied submatrices to compose the result.
    (set! res1 (grsp-matrix-subadd a1 a2)) 

    res1))


;;;; gdb-de-row-vol - Subdivides a matrix row-wise.
;;
;; Keywords:
;;
;; - entity, submatrix, properties, sections
;;
;; Parameters:
;;
;; - p_a1; matrix.
;; - p_n1: numeric, rows per volume.
;;
(define (grsp-matrix-row-vol p_a1 p_n1)
  (let ((res1 0)
	(a1 0)
	(q2 0)
	(r1 0)
	(mi 0)
	(lm 0)
	(hm 0)
	(i2 1))

    ;; Calculate number of iterations.
    (set! q2 (floor-quotient (grsp-tm p_a1) p_n1))
    (set! r1 (floor-remainder(grsp-tm p_a1) p_n1))

    (grsp-ld q2)
    (grsp-ld r1)
    
    ;; Create results matrix.
    ;;(set! res1 (grsp-matrix-create 0 (+ q2 r1) 2))

    (cond ((equal? r1 0)
	   (set! res1 (grsp-matrix-create 0 q2 2)))
	  (else (set! res1 (grsp-matrix-create 0 (+ q2 1) 2))))
    
    ;; Row loop.
    (let loop ((i1 1))
      (if (<= i1 q2)
	  
	  (begin (cond ((= i1 1)
			(set! lm (grsp-lm p_a1))
			(set! hm (- (* i1 p_n1) 1)))
		       ((> i1 1)
			(set! lm (+ hm 1))
			(set! hm (- (* i1 p_n1) 1))))

		 (set! i2 (- i1 1))
		 
		 (array-set! res1 lm i2 0)
		 (array-set! res1 hm i2 1)

		 (loop (+ i1 1)))))

    ;; Add remainder, if it exists.
    (cond ((> r1 0)
	   (set! i2 (+ i2 1))	   	   
	   (array-set! res1 (+ hm 1) i2 0)
	   (array-set! res1 (grsp-hm p_a1) i2 1)))
    
    res1))


;;;; grsp-ms-get-longest-element - Get the longest string from matrix
;; p_a1.
;;
;; Keywords:
;;
;; - strings, length
;;
;; Parameters:
;;
;; - p_a1: string matrix.
;;
(define (grsp-ms-get-longest-element p_a1)
  (let ((res1 "")
	(s1 ""))

    ;; Get the first element.
    (set! res1 (array-ref p_a1 (grsp-lm p_a1) (grsp-ln p_a1)))
	
    ;; Row loop.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln p_a1)))
		   (if (<= j1 (grsp-hn p_a1))

		       (begin (set! s1 (array-ref p_a1 i1 j1))

			      (cond ((> (string-length s1) (string-length res1))
				     (set! res1 s1)))
			      
			      (loop (+ j1 1)))))		 
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-ms-create-col.headers - Creates and pads column headers for
;; string matrix display.
;;
;; Keywords:
;;
;; - padding, headers, presentation, display
;;
;; Parameters:
;;
;; - p_a1: string matrix.
;; - p_l1: list of headers.
;;
;; Notes:
;;
;; - grsp-ms-create-row-headers
;;
;; Output:
;;
;; - 1 x n string matrix of headers formatted to display with p_a1.
;;
(define (grsp-ms-create-col-headers p_a1 p_l1)
  (let ((res1 0)
	(l1 '())
	(s1 "")
	(s2 ""))

    ;; Generate col headers.
    (set! l1 (list-copy p_l1))
    (set! l1 (grsp-lal-ansl l1))
    (set! res1 (grsp-l2m l1))

    ;; Padding col headers.
    (let loop ((j1 (grsp-ln res1)))
      (if (<= j1 (grsp-hn res1))

	  (begin (set! s1 (array-ref res1 0 j1))
		 (set! s2 (array-ref p_a1 0 j1))
		 (set! s1 (grsp-pad-lr s1 s2))
		 (array-set! res1 s1 0 j1)
		 
		 (loop (+ j1 1)))))
    
    res1))


;;;; grsp-ms-create-row-headers - Builds row headers for string matrix
;; display.
;;
;; Keywords:
;;
;; - padding, headers, presentation, display
;;
;; Parameters:
;;
;; - p_a1: string matrix.
;;
;; Notes:
;;
;; - grsp-ms-create-col-headers
;;
;; Output:
;;
;; - m x 1 string matrix with numbered rows to be joined to the matrix
;;   to be displayed.
;;
(define (grsp-ms-create-row-headers p_a1)
  (let ((res1 0)
	(i2 0))

    (set! res1 (grsp-matrix-create " "
				   (grsp-tm p_a1)
				   (+ (grsp-tn p_a1) 1)))
    (array-set! res1 "/" 0 0)
     
    (let loop ((i1 1))
      (if (<= i1 (grsp-hm res1))

	  (begin (set! i2 (- i1 1))
		 (array-set! res1 (grsp-n2s i2) i1 0)
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-ms-pad-elements - Pads elements of a string matrix to the
;; right or left with blank spaces.
;;
;; Keywords:
;;
;; - pad, padding, fill, filling, display
;;
;; Parameters:
;;
;; - p_a1: string matrix.
;; - p_n1: number of blanks to add to the right.
;; - p_n2: number of blanks to add to the left.
;;
(define (grsp-ms-pad-elements p_a1 p_n1 p_n2)
  (let ((res1 0)
	(s1 ""))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Row loop.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln res1)))
		   (if (<= j1 (grsp-hn res1))

		       (begin (set! s1 (array-ref res1 i1 j1))
			      (set! s1 (newspaces p_n1 s1 0))
			      (set! s1 (newspaces p_n2 s1 1))
			      (array-set! res1 s1 i1 j1)
			      
			      (loop (+ j1 1)))))		 
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-displaytms - Applies functions grsp-matrixtm and
;; grsp-matrixts to matrix p_a1 and displays it.
;;
;; Keywords:
;;
;; - show, display
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_l1: list of strings, column names or titles.
;; - p_l3: list of strings, column properties.
;; - p_a4: source matrix. See grsp-matrix-displaytm.
;;
(define (grsp-matrix-displaytms p_a1 p_l1 p_l3 p_a4)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(a3 0))

    ;; Safety copy.
    (set! a1 (grsp-matrix-cpy p_a1))
    (set! a3 (grsp-my2ms a1))
    (set! a2 (grsp-matrix-displaytm a1 p_l3 p_a4))
    (grsp-ldl (gconsts "dam") 0 0)
    (grsp-color-set "fgreen")
    (grsp-matrix-displayts a3 p_l1)
    (grsp-color-set "fdefault")

    res1))


;;;; grsp-matrix-subreprk - Copies row vector p_a2 to matrix p_a1 based
;; on the primary key p_n1 and option p_b1.
;;
;; Keywords:
;;
;; - saving, copy, update, updating
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: to add p_a2 as a new row in p_a1 if a row in p_a1 with the
;;     same value as what p_a2 holds in col p_j1 is found.
;;   - #f: otherwise.
;;
;; - p_a1: matrix.
;; - p_a2: matrix.
;; - p_j1: column number holding the primary key.
;;
;; Notes:
;;
;; - Both matrices should have the same structure in terms of number of
;;   columns and primary keys.
;;
(define (grsp-matrix-row-subrepk p_b1 p_a1 p_a2 p_j1)
  (let ((res1 0)
	(i1 0)
	(k1 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Get key value.
    (set! k1 (array-ref p_a2 0 p_j1))
    ;; ***a
    ;; Find row number that corresponds to key p_k1. If the row does not
    ;; exist, the function will return value -1.
    (set! i1 (grsp-matrix-row-numk res1 p_j1 k1))

    ;; Replace row if found. If not, add the row on request.
    (cond ((>= i1 0)
	   (set! res1 (grsp-matrix-subrep res1 p_a2 i1 (grsp-ln res1))))
	  ((= i1 -1)

	   (cond ((equal? p_b1 #t)
		  (set! res1 (grsp-matrix-subadd res1 p_a2))))))
    
    res1))


;;;; grsp-matrix-row-numk - Finds the row number in matrix p_a1
;; corresponding to key p_v1 in column p_j1.
;;
;; Keywords:
;;
;; - primary, key, search, find
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_j1: key column.
;; - p_v1: key value.
;;
;; Output:
;;
;; - Returns the row number of the first row where the key value
;;   p_v1 in col p_j1 is found, if it exists.
;; - Returns -1 if no row with key p_v1 is found
;;
(define (grsp-matrix-row-numk p_a1 p_j1 p_v1)
  (let ((res1 -1))

    ;; Row loop.
    (let loop ((i1 (grsp-lm p_a1)))
      (if (<= i1 (grsp-hm p_a1))

	  (begin (cond ((equal? p_v1 (array-ref p_a1 i1 p_j1))
			(set! res1 i1)
			(set! i1 (grsp-hm p_a1))))
		 
		 (loop (+ i1 1)))))
    
    res1))


;;;; grsp-matrix-subreprk - Copies each row of matrix p_a2 to matrix
;; p_a1 based on the primary key p_n1 and option p_b1.
;;
;; Keywords:
;;
;; - saving, copy, update, updating
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: to add p_a2 rows as new in p_a1 if a row in p_a1 with the same
;;     values as what p_a2  rows hold in col p_j1.
;;   - #f: otherwise.
;;
;; - p_a1: matrix, target.
;; - p_a2: matrix to commit to p_a1.
;; - p_j1: column number holding the primary key values.
;;
;; Notes:
;;
;; - Both matrices should have the same structure in terms of number of
;;   columns and primary keys.
;;
(define (grsp-matrix-subrepk p_b1 p_a1 p_a2 p_j1)
  (let ((res1 0)
	(a3 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Cycle over p_a2 and process each row individually.
    (let loop ((i2 (grsp-lm p_a2)))
      (if (<= i2 (grsp-hm p_a2))

	  ;; First we need to extract each vector from p_a2 and
	  ;; pass it.
	  (begin (set! a3 (grsp-matrix-subcpy p_a2
					      i2
					      i2
					      (grsp-ln p_a2)
					      (grsp-hn p_a2)))
		 
		 ;; Now replace or add row to target matrix.
		 (set! res1 (grsp-matrix-row-subrepk p_b1
						     res1
						     a3
						     p_j1))
		 
		 (loop (+ i2 1)))))    
    
    res1))


;;;; grsp-matrix-subreprkl - Copies from a vector a2 to matrix p_a1 based
;; on the primary key p_n1 and option p_b1 the values of elements of
;; columns contained in list p_l1.
;;
;; Keywords:
;;
;; - saving, copy, update, updating
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: to add p_a2 as a new row in p_a1 if a row in p_a1 with the
;;     same value as what p_a2 holds in col p_j1 is found.
;;   - #f: otherwise.
;;
;; - p_a1: matrix.
;; - p_a2: matrix (horizontal vector).
;; - p_j1: column number holding the primary key.
;; - p_l1: list of column numbers to copy.
;;
;; Notes:
;;
;; - Both matrices should have the same structure in terms of number of
;;   columns and primary keys.
;;
(define (grsp-matrix-row-subrepkl p_b1 p_a1 p_a2 p_j1 p_l1) 
  (let ((res1 0)
	(i1 0)
	(k1 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Get key value.
    (set! k1 (array-ref p_a2 0 p_j1))
    
    ;; Find row number.
    (set! i1 (grsp-matrix-row-numk res1 p_j1 k1))

    ;; Replace row cols if found. If not, add the row on request.
    (cond ((>= i1 0)

	   ;; List loop.
	   (let loop ((j1 0))
	     (if (< j1 (length p_l1))

		 (begin (array-set! res1
				    (array-ref p_a2
					       0
					       (list-ref p_l1 j1)
					       i1
					       j1))
			
			(loop (+ j1 1)))))

	  ((= i1 -1)

	   (cond ((equal? p_b1 #t)
		  (set! res1 (grsp-matrix-subadd res1 p_a2)))))))
    
    res1))


;;;; grsp-matrix-row-col-setk - On matrix p_a1, at the row whose key
;; value of column p_j1 is p_v2, place at col p_j2 value p_v2.
;;
;; Keywords:
;;
;; - saving, copy, update, updating
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_j1: column number, primary jkey.
;; - p_v1: key value at p_j1.
;; - p_j2: column of element to modify.
;; - p_v2: value to enter at p_j2; at the row identified by key p_v1.
;;
(define (grsp-matrix-row-col-setk p_a1 p_j1 p_v1 p_j2 p_v2)
  (let ((i2 0))
   
    (set! i2 (grsp-matrix-row-numk p_a1 p_j1 p_v1))
    (array-set! p_a1 p_v2 i2 p_j2)))


;;;; Find out if there is a primary key in the properties list p_l3,
;; and if so, the corresponding column number.
;;
;; Keywords:
;;
;; - key, primary
;;
;; Parameters:
;;
;; - p_l3: list of strings, column properties of a matrix.
;;
;; Output:
;;
;; - Col number if it exists.
;; - #f otherwise.
;;
(define (grsp-matrix-find-if-prkey-exists p_l3)
  (let ((res1 0))

    (cond ((equal? (grsp-lal-esubstr p_l3 "#key") #f)
	   (set! res1 #f))
	  (else (set! res1 (grsp-lal-esubstr p_l3 "#key"))))

    res1))


;;;; grsp-matrix-row-subexpk - Adds a new row and identifies it with a new
;; key value if a primary key is defined for one of its columns.
;;
;; Keywords:
;;
;; - key, primary, adding
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_l2: list of default values per row.
;; - p_l3: list of strings, column properties of a matrix.
;;
(define (grsp-matrix-row-subexpk p_a1 p_l2 p_l3)
  (let ((res1 0)
	(a2 0)
	(k1 0)
	(n1 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Add a row at the bottom of the matrix.
    (set! res1 (grsp-matrix-subexp res1 1 0))
    
    ;; If a pr key col is found (the function returns a number instead of
    ;; a #f value).
    (cond ((equal? (number? (grsp-matrix-find-if-prkey-exists p_l3)) #t)

	   ;; Get the col number.
	   (set! n1 (grsp-matrix-find-if-prkey-exists p_l3))

	   ;; Get the max value for the primary key found.	   
	   (set! a2 (grsp-matrix-row-minmax "#max" res1 n1))
	   (set! k1 (array-ref a2 0 n1))
	   
	   ;; Increase the key value.
	   (set! k1 (in k1))

	   ;; Set the new key value in the recently added row.
	   (array-set! res1 k1 (grsp-hm res1) n1)

	   ;; Set default values.
	   (set! res1 (grsp-matrix-editu res1 (grsp-hm res1) p_l2 n1))))
    
    res1))


;;;; grsp-matrix-row-insert - Adds a new row on matrix p_a1 and fills it
;; with the values contained in list p_l1.
;;
;; Keywords:
;;
;; - adding
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: for matrix type conversion.
;;   - #f: otherwise.
;;
;;
;; - p_a1: matrix.
;; - p_l1: list, multiple types, arguments to pass to p_a1.
;;
;; Notes:
;;
;; - This function requires that p_l1 has as many elements as there are cols
;;   in p_a1.
;; - If the types of p_l1 and p_a1 match element by element, p_b1 may be
;;   set to #f in order to save time during operations.
;;
;; Output:
;;
;; - Matrix.
;;
(define (grsp-matrix-row-insert p_b1 p_a1 p_l1)
  (let ((res1 0)
	(a1 0))

    (set! res1 (grsp-matrix-cpy p_a1))
    (set! a1 (grsp-l2m p_l1))

    (cond ((equal? p_b1 #t)
	   (set! res1 (grsp-my2ms res1))
	   (set! a1 (grsp-my2ms a1))))
    
    (set! res1 (grsp-matrix-subadd res1 a1))

    (cond ((equal? p_b1 #t)    
	   (set! res1 (grsp-ms2my res1))))

    res1))


;;;; grsp-matrix-tf-idf - Creates a matrix for TF-IDF.
;;
;; Keywords:
;;
;; - frequency, embeddings, words, terms
;;
;; Parameters:
;;
;; - p_a1: col vector, string, list of documents.
;; - p_n1: numeric. Word lenght threshold.
;;
;; Notes:
;;
;; - https://www.turing.com/kb/guide-on-word-embeddings-in-nlp
;;
(define (grsp-matrix-tf-idf p_a1 p_n1)
  (let ((res1 0)
	(s1 "")
	(s2 "")
	(s3 "")
	(td 0)
	(a1 0)
	(a2 0)
	(a3 0)
	(tn 0)
	(l1 '("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "ñ" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
	      "á" "é" "í" "ó" "ú" " "))
	(l2 '()))
    
    ;; Create matrices matrices.
    (set! a2 (grsp-matrix-create 0 1 1))
    
    ;; Add a column to a1 to contain the results of td calculation.
    (set! a1 (grsp-matrix-subexp p_a1 0 1))

    (grsp-ld "Step 1.0")
    
    ;; Downcase and clean strings of all elements in the first col
    ;; of a1.
    (let loop ((i1 (grsp-lm a1)))
      (if (<= i1 (grsp-hm a1))

	  ;; First we eliminate short substrings, downcase, trim and clean the string.
	  ;; These operations will increase the efficiency of the whole tf-idf
	  ;; calculation by eliminating wors such as "the", "or", etc. which would
	  ;; consume lots of resources and probably not add much to the final result.
	  (begin (set! s1 (grsp-substring-delete-shorter (array-ref a1 i1 0) p_n1))
		 (set! s1 (string-downcase s1))
		 (set! s1 (string-trim-both s1))
		 (set! s1 (grsp-substring-replace s1 "  " ""))
		 (set! s1 (grsp-string-lo s1 l1))
		 (array-set! a1 s1 i1 0)

		 (grsp-ld "Step 2.0")
		 
		 ;; Calculate the number of terms in each document (td) and
		 ;; place the results for each document on the second column
		 ;; of a1.
		 (array-set! a1 (grsp-count-words s1) i1 1)

		 ;; Analize each document and identify each different word.
		 ;; Place them in column vector a2 once. If a term already
		 ;; exists in a2, then do not add a second instance of it.
		 (set! l2 (string-split s1 #\space))
		 (set! tn (length l2))
		 (set! a3 (grsp-matrix-transpose (grsp-l2m l2)))
		 (set! a3 (grsp-matrix-subexp a2 0 1))

		 (grsp-ld "Step 3.0")
		 
		 ;; Row loop.
		 (let loop ((i2 (grsp-lm a3)))
		   (if (<= i2 (grsp-hm a3))

		       (begin (set! s3 (array-ref a3 i2 0))
			      (set! a2 (grsp-matrix-row-insert-ioe a3 0 s3 0 s3))

			      (grsp-ld "Step 4.0")
			      
			      (loop (+ i2 1)))))

		 (loop (+ i1 1)))))

    (grsp-ld "Step 5.0")
    
    ;; Build results matrix.
    (set! res1 (grsp-matrix-create 0 (grsp-tm a1) (grsp-tm a2)))

    (grsp-ld "Step 6.0")
    
    ;; Calculate each termś frequency on each document. Insert the result
    ;; for each term in each document in res1.

    (grsp-ld "Step 7.0")
    
    ;; Eliminate trivial terms not already eliminated.

    (grsp-ld "Step 8.0")

    ;; Count the number of documents containing each non-trivial term.

    (grsp-ld "Step 9.0")

    res1))


;;;; grsp-matrix-row-insert-ioe - Inserts value p_v1 at col p_j1 in a new row
;; only it value p_v2 does not exist in any row of col p_j2.
;;
;; Keywords:
;;
;; - insert, nonexistent
;;
;; Parameters:
;;
;; - p_a1: matrix.
;; - p_j1: col, target.
;; - p_v1; value to insert.
;; - p_j2: col, control.
;; - p_v2; value, control.
;;
(define (grsp-matrix-row-insert-ioe p_a1 p_j1 p_v1 p_j2 p_v2)
  (let ((res1 0)
	(b2 #f)
	(a1 0))

    ;; Safety copy.
    (set! res1 (grsp-matrix-cpy p_a1))
    
    ;; Row loop.
    (let loop ((i1 (grsp-lm res1)))
      (if (<= i1 (grsp-hm res1))

	  ;; If found, then b2 becomes #t and the loop ends then
	  ;; to save time.
	  (begin (cond ((equal? p_v2 (array-ref res1 i1 p_j2))
			(set! b2 #t)
			(set! i1 (grsp-hm res1))))	 
		 
		 (loop (+ i1 1)))))
    
    ;; Insert only if not found (b2 remains #f).
    (cond ((equal? b2 #f)
	   (set! res1 (grsp-matrix-subexp res1 1 0))
	   (array-set! res1 p_v1 (grsp-hm res1) p_j1)))
    
    res1))


;;;; grsp-2l2m - Creates a column matrix containing p_l1 as the first column
;; and p_l2 as the second one.
;;
;; Keywords:
;;
;; - lists, matrices, conversion, columnar
;;
;; Parameters:
;;
;; - p_l1: list.
;; - p_l2: list.
;;
;; Notes:
;;
;; - Both lists should have the same number of elements.
;;
(define (grsp-2l2cm p_l1 p_l2)
  (let ((res1 0)
	(a1 0))

    (set! a1 (grsp-l2m p_l1))
    (set! res1 (grsp-matrix-row-insert #f a1 p_l2))
    (set! res1 (grsp-matrix-transpose res1))
    
    res1))


;;;; grsp-l2m - Creates a column matrix with list p_l1.
;;
;; Keywords:
;;
;; - lists, matrices, conversion, columnar
;;
;; Parameters:
;;
;; - p_l1: list.
;;
(define (grsp-l2cm p_l1)
  (let ((res1 0))

    (set! res1 (grsp-l2m p_l1))
    (set! res1 (grsp-matrix-transpose res1))
    
    res1))
