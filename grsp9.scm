;; =============================================================================
;;
;; grsp9.scm
;;
;; Test functions and artificial landscapes for single-objective optimization.
;;
;; =============================================================================
;;
;; Copyright (C) 2018 - 2022 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;;
;; Sources:
;; - [1] En.wikipedia.org. 2021. Test functions for optimization. [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/Test_functions_for_optimization
;;   [Accessed 5 March 2021].
;; - [2] En.wikipedia.org. 2021. Mathematical optimization. [online] Available
;;   at: https://en.wikipedia.org/wiki/Mathematical_optimization
;;   [Accessed 9 March 2021].
;; - [3] En.wikipedia.org. 2021. List of algorithms. [online] Available at:
;;   https://en.wikipedia.org/wiki/List_of_algorithms [Accessed 9 March 2021].


(define-module (grsp grsp9)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp4)
  #:use-module (ice-9 threads)  
  #:export (grsp-sop-booth
	    grsp-sop-bukin6
	    grsp-sop-beale
	    grsp-sop-beale-mth
	    grsp-sop-matyas
	    grsp-sop-matyas-mth
	    grsp-sop-rastrigin
	    grsp-sop-rastrigin-mth
	    grsp-sop-goldstein-price
	    grsp-sop-goldstein-price-mth
	    grsp-sop-levi13
	    grsp-sop-levi13-mth
	    grsp-sop-himmelblau
	    grsp-sop-himmelblau-mth
	    grsp-sop-3camel
	    grsp-sop-mccormick
	    grsp-sop-schaffer2
	    grsp-sop-schaffer2-mth
	    grsp-sop-schaffer4
	    grsp-sop-schaffer4-mth
	    grsp-sop-spheret
	    grsp-sop-rosenbrock
	    grsp-sop-eggholder
	    grsp-sop-eggholder-mth
	    grsp-sop-styblinski-tang
	    grsp-sop-ackley
	    grsp-sop-ackley-mth
	    grsp-sop-easom
	    grsp-sop-easom-mth
	    grsp-sop-cit
	    grsp-sop-cit-mth
	    grsp-sop-hoelder
	    grsp-sop-hoelder-mth
	    grsp-cop-rosenbrock1
	    grsp-cop-rosenbrock2
	    grsp-cop-mbird
	    grsp-cop-mbird-mth
	    grsp-cop-simionescu))


;;;; grsp-sop-booth - Booth test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-booth p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (+ (expt (+ p_x1 (* 2 p_y1) (* -1 7)) 2)
		  (expt (+ (* 2 p_x1) p_y1 (* -1 5)) 2)))
    
    res1))


;;;; grsp-sop-bukin6 - Bukin 6 test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-15.0, -5.0].
;; - p_y1: number, [-3.0, 3.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-bukin6 p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (+ (* 100 (sqrt (abs (- p_y1 (* 0.001 (expt p_x1 2))))))
		  (* 0.01 (abs (+ p_x1 10)))))
    
    res1))


;;;; grsp-sop-beale - Beale single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-4.5, 4.5].
;; - p_y1: number, [-4.5, 4.5].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-beale p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(x1 0)
	(xy 0))

    ;; Prep.
    (set! xy (* p_x1 p_y1))
    (set! x1 (* -1 p_x1))
    
    ;; res2.
    (set! res2 (expt (+ 1.5 x1 xy) 2))
    
    ;; res3.
    (set! res3 (expt (+ 2.25 x1 (* p_x1 (expt p_y1 2))) 2))
    
    ;; res4.
    (set! res4 (expt (+ 2.625 x1 (* p_x1 (expt p_y1 3))) 2))
    
    ;; Compose results.
    (set! res1 (+ res2 res3 res4))
    
    res1))


;;;; grsp-sop-beale-mth - Multithreaded variant of grsp-sop-beale-mth.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-4.5, 4.5].
;; - p_y1: number, [-4.5, 4.5].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-beale-mth p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(x1 0)
	(xy 0))

    (parallel (set! xy (* p_x1 p_y1))
	      (set! x1 (* -1 p_x1)))
    
    (parallel (set! res2 (expt (+ 1.5 x1 xy) 2))
	      (set! res3 (expt (+ 2.25 x1 (* p_x1 (expt p_y1 2))) 2))
	      (set! res4 (expt (+ 2.625 x1 (* p_x1 (expt p_y1 3))) 2)))

    ;; Compose results.    
    (set! res1 (+ res2 res3 res4))
    
    res1))


;;;; grsp-sop-matyas - Matyas test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-matyas p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

	;; res2.
	(set! res2 (* 0.26 (+ (expt p_x1 2) (expt p_y1 2))))
	
	;; res3.
	(set! res3 (* 0.48 p_x1 p_y1))

    ;; Compose results.
    (set! res1 (- res2 res3))

    res1))


;;;; grsp-sop-matyas-mth - Multithreaded variant of grsp-sop-matyas.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-matyas-mth p_x1 p_y1)
  (letpar ((res1 0)
	   (res2 (* 0.26 (+ (expt p_x1 2) (expt p_y1 2))))
	   (res3 (* 0.48 p_x1 p_y1)))
	
	  (set! res1 (- res2 res3))

	  res1))


;;;; grsp-sop-rastrigin - Rastrigin test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_a1: 1 x n vector with n elements, representing an n-dimensinal problem.
;;
;; Notes:
;; - Each element of p_a1 should belong to the interval [-5.12, 5.12].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-rastrigin p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(p2 0)
	(n1 0)
	(x1 0)
	(ln1 0)
	(hn1 0))

    ;; Extract the boundaries of the matrix (vector).
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))     

    ;; Problem dimensionality.
    (set! n1 (- hn1 ln1))
    
    ;; 2pi.
    (set! p2 (* 2 (grsp-pi)))

    ;; res2.
    (set! res2 (* 10 n1))
    
    ;; res3.
    (let loop ((j1 1))
      (if (<= j1 n1)
	  (begin (set! x1 (array-ref p_a1 0 j1))
		 (set! res3 (+ res3 (- (expt x1 2) (* 10 (cos (* p2 x1))))))
		 (loop (+ j1 1)))))
    
    ;; Compose results.
    (set! res1 (+ res2 res3))

    res1))


;;;; grsp-sop-rastrigin-mth - Multithreaded version of grsp-sop-rastrigin.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_a1: 1 x n vector with n elements, representing an n-dimensinal problem.
;;
;; Notes:
;; - Each element of p_a1 should belong to the interval [-5.12, 5.12].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-rastrigin-mth p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(p2 0)
	(n1 0)
	(x1 0)
	(ln1 0)
	(hn1 0))

    (parallel (set! ln1 (grsp-matrix-esi 3 p_a1))
	      (set! hn1 (grsp-matrix-esi 4 p_a1)))

    (parallel (set! n1 (- hn1 ln1))
	      (set! p2 (* 2 (grsp-pi))))

    (parallel (set! res2 (* 10 n1))
	      (let loop ((j1 1))
		(if (<= j1 n1)
		    (begin (set! x1 (array-ref p_a1 0 j1))
			   (set! res3 (+ res3 (- (expt x1 2) (* 10 (cos (* p2 x1))))))
			   (loop (+ j1 1))))))
    
    ;; Compose results.	   
    (set! res1 (+ res2 res3))

    res1))


;;;; grsp-sop-goldstein-price - Goldstein-Price test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-2.0, 2.0].
;; - p_y1: number, [-2.0, 2.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-goldstein-price p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res21 0)
	(res22 0)
	(res31 0)
	(res32 0)
	(x2 0)
	(y2 0)
	(xy 0)
	(x 0)
	(y 0))

    ;; Preparation.
    (set! x p_x1)
    (set! y p_y1)
    (set! x2 (expt x 2))
    (set! y2 (expt y 2))
    (set! xy (* x y))

    ;; res2.
    (set! res21 (expt (+ x y 1) 2))
    (set! res22 (+ 19 (* -14 x) (* 3 x2) (* -14 y) (* 6 xy) (* 3 y2)))
    (set! res2 (+ 1 (* res21 res22)))

    ;; res3.
    (set! res31 (expt (- (* 2 x) (* 3 y)) 2))
    (set! res32 (+ 18 (* -32 x) (* 12 x2) (* 48 y) (* -36 xy) (* 27 y2)))
    (set! res3 (+ 30 (* res31 res32)))
    
    ;; Compose results.
    (set! res1 (* res2 res3))
    
    res1))


;;;; grsp-sop-goldstein-price-mth - Multithreaded variant of
;; grsp-sop-goldstein-price.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-2.0, 2.0].
;; - p_y1: number, [-2.0, 2.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-goldstein-price-mth p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res21 0)
	(res22 0)
	(res31 0)
	(res32 0)
	(x2 0)
	(y2 0)
	(xy 0)
	(x p_x1)
	(y p_y1))

    ;; Preparation.
    (parallel (set! x2 (expt x 2))
	      (set! y2 (expt y 2))
	      (set! xy (* x y)))

    ;; res2.
    (parallel (set! res21 (expt (+ x y 1) 2))
	      (set! res22 (+ 19 (* -14 x) (* 3 x2) (* -14 y) (* 6 xy) (* 3 y2))))
    
    (set! res2 (+ 1 (* res21 res22)))

    ;; res3.
    (parallel (set! res31 (expt (- (* 2 x) (* 3 y)) 2))
	      (set! res32 (+ 18 (* -32 x) (* 12 x2) (* 48 y) (* -36 xy) (* 27 y2))))
    
    (set! res3 (+ 30 (* res31 res32)))
    
    ;; Compose results.
    (set! res1 (* res2 res3))
    
    res1))


;;;; grsp-sop-levi13 - Levi test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-levi13 p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(x 0)
	(y 0)
	(px 0)
	(py 0))

    ;; Preparation.
    (set! x p_x1)
    (set! y p_y1)
    (set! px (* x (grsp-pi)))
    (set! py (* y (grsp-pi)))

    ;; res2.
    (set! res2 (expt (sin (* 3 px)) 2))
    
    ;; res3.
    (set! res3 (* (expt (- x 1 ) 2) (+ 1 (expt (sin (* 3 py)) 2))))
    
    ;; res4.
    (set! res4 (* (expt (- y 1) 2) (+ 1 (expt (sin (* 2 py)) 2))))
    
    ;; Compose results.
    (set! res1 (+ res2 res3 res4))
    
    res1))


;;;; grsp-sop-levi13-mth - Multithreaded variant of grsp-sop-levi13.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-levi13-mth p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(x p_x1)
	(y p_y1)
	(px 0)
	(py 0))

    ;; Preparation.
    (parallel (set! px (* x (grsp-pi)))
	      (set! py (* y (grsp-pi))))

    (parallel (set! res2 (expt (sin (* 3 px)) 2))
	      (set! res3 (* (expt (- x 1 ) 2) (+ 1 (expt (sin (* 3 py)) 2))))
	      (set! res4 (* (expt (- y 1) 2) (+ 1 (expt (sin (* 2 py)) 2)))))

    ;; Compose results.    
    (set! res1 (+ res2 res3 res4))
    
    res1))


;;;; grsp-sop-himmelblau - Himmelblau test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-5.0, 5.0].
;; - p_y1: number, [-5.0, 5.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-himmelblau p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(x 0)
	(y 0))

    ;; Initial.
    (set! x p_x1)
    (set! y p_y1)
    
    ;; res2.
    (set! res2 (expt (+ (expt x 2) y -11) 2))
    
    ;; res3.
    (set! res3 (expt (+ x (expt y 2) -7) 2))
    
    ;; Compose results.
    (set! res1 (+ res2 res3))

    res1))


;;;; grsp-sop-himmelblau-mth - Multithreaded variant of grsp-sop-himmelblau.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-5.0, 5.0].
;; - p_y1: number, [-5.0, 5.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-himmelblau-mth p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(x p_x1)
	(y p_y1))
    
    (parallel (set! res2 (expt (+ (expt x 2) y -11) 2))
	      (set! res3 (expt (+ x (expt y 2) -7) 2)))

    ;; Compose results.    
    (set! res1 (+ res2 res3))

    res1))


;;;; grsp-sop-3camel - Three hump camel test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-5.0, 5.0].
;; - p_y1: number, [-5.0, 5.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-3camel p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (+ (* 2 (expt p_x1 2))
		  (* 1.05 (expt p_x1 4))
		  (* (/ (expt p_x1 6) 6))
		  (* p_x1 p_y1)
		  (expt p_y1 2)))
    
    res1))


;;;; grsp-sop-mccormick - McCormick test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-1.5, 4.0].
;; - p_y1: number, [-3.0, 4.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-mccormick p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (+ (sin (+ p_x1 p_y1))
		  (expt (- p_x1 p_y1 ) 2)
		  (* -1.5 p_x1)
		  (* 2.5 p_y1)
		  1))
    
    res1))


;;;; grsp-sop-schaffer2 - Schaffer 2 test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-100.0, 100.0].
;; - p_y1: number, [-100.0, 100.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-schaffer2 p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(x2 0)
	(y2 0))

    ;; Init.
    (set! x2 (expt p_x1 2))
    (set! y2 (expt p_y1 2))    

    ;; res2.
    (set! res2 (- (expt (sin (- x2 y2)) 2) 0.5))

    ;; res3.
    (set! res3 (expt (+ 1 (* 0.001 (+ x2 y2))) 2))		      
    
    ;; Compose results.
    (set! res1 (+ 0.5 (/ res2 res3)))
    
    res1))


;;;; grsp-sop-schaffer2-mth - Multithreaded variant of grsp-sop-schaffer2.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-100.0, 100.0].
;; - p_y1: number, [-100.0, 100.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-schaffer2-mth p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(x2 0)
	(y2 0))

    (parallel (set! x2 (expt p_x1 2))
	      (set! y2 (expt p_y1 2)))
    
    (parallel (set! res2 (- (expt (sin (- x2 y2)) 2) 0.5))
	      (set! res3 (expt (+ 1 (* 0.001 (+ x2 y2))) 2)))

    ;; Compose results.    
    (set! res1 (+ 0.5 (/ res2 res3)))
    
    res1))


;;;; grsp-sop-schaffer4 - Schaffer 4 test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-100.0, 100.0].
;; - p_y1: number, [-100.0, 100.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-schaffer4 p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(x2 0)
	(y2 0))

    ;; Init.
    (set! x2 (expt p_x1 2))
    (set! y2 (expt p_y1 2))    

    ;; res2.
    (set! res2 (- (expt (cos (sin (abs (- x2 y2)))) 2) 0.5))

    ;; res3.
    (set! res3 (expt (+ 1 (* 0.001 (+ x2 y2))) 2))
    
    ;; Compose results.
    (set! res1 (+ 0.5 (/ res2 res3)))
    
    res1))


;;;; grsp-sop-schaffer4-mth - Multithreaded variant of grsp-sop-schaffer4.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-100.0, 100.0].
;; - p_y1: number, [-100.0, 100.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-schaffer4-mth p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(x2 p_x1)
	(y2 p_y1))

    ;; Init.
    (parallel (set! x2 (expt p_x1 2))
	      (set! y2 (expt p_y1 2)))

    (parallel (set! res2 (- (expt (cos (sin (abs (- x2 y2)))) 2) 0.5))
	      (set! res3 (expt (+ 1 (* 0.001 (+ x2 y2))) 2)))

    ;; Compose results.
    (set! res1 (+ 0.5 (/ res2 res3)))
    
    res1))


;;;; grsp-sop-spheret - Sphere test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_a1: 1 x n vector with n elements, representing an n-dimensinal problem.
;;   [-inf.0, +inf.0]
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-spheret p_a1)
  (let ((res1 0)
	(ln1 0)
	(hn1 0))

    ;; Extract the boundaries of the matrix (vector).
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1)) 

    (let loop ((j1 0))
      (if (<= j1 hn1)
	  (begin (set! res1 (+ res1 (expt (array-ref p_a1 0 j1) 2)))
		 (loop (+ j1 1)))))
    
    res1))
	

;;;; grsp-sop-rosenbrock - Rosenbrock test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_a1: 1 x n vector with n elements, representing an n-dimensional problem.
;;   [-inf.0, +inf.0]
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-rosenbrock p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(n1 0)
	(ln1 0)
	(hn1 0))

    ;; Extract the boundaries of the matrix (vector).
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1)) 

    ;; Cycle.
    (set! n1 (- hn1 1))
    (let loop ((j1 ln1))
      (if (<= j1 n1)
	  (begin (set! res2 (* 100
			       (expt (- (array-ref p_a1 0 (+ j1 1))
					(expt (array-ref p_a1 0 j1) 2)) 2)))
		 (set! res3 (expt (- 1 (array-ref p_a1 0 j1)) 2))	   
		 (set! res1 (+ res1 res2 res3))
		 (loop (+ j1 1)))))
        
    res1))


;;;; grsp-sop-eggholder - Eggholder test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-512.0, 512.0].
;; - p_y1: number, [-512.0, 512.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-eggholder p_x1 p_y1)
  (let ((res1 0)
	(res3 0)
	(res4 0)
	(y1 0)
	(x2 0)
	(y2 0))

    ;; Init.
    (set! y1 (+ p_y1 47))

    ;; res3.
    (set! res3 (sin (sqrt (abs (+ (/ p_x1 2) y1)))))
    
    ;; res4.
    (set! res4 (* p_x1 (sin (sqrt (abs (- p_x1 y1))))))
    
    ;; Compose results.
    (set! res1 (- (* (* -1 y1) res3) res4))

    res1))


;;;; grsp-sop-eggholder-mth - Multithreaded variant of grsp-sop-eggholder
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-512.0, 512.0].
;; - p_y1: number, [-512.0, 512.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-eggholder-mth p_x1 p_y1)
  (let ((res1 0)
	(res3 0)
	(res4 0)
	(y1 0)
	(x2 0)
	(y2 0))

    (set! y1 (+ p_y1 47))

    (parallel (set! res3 (sin (sqrt (abs (+ (/ p_x1 2) y1)))))
	      (set! res4 (* p_x1 (sin (sqrt (abs (- p_x1 y1)))))))

    ;; Compose results.    
    (set! res1 (- (* (* -1 y1) res3) res4))

    res1))


;;;; grsp-sop-styblinski-tang - S & T test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_a1: 1 x n vector with n elements, representing an n-dimensinal problem.
;;   [-5.0, +5.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-styblinski-tang p_a1)
  (let ((res1 0)
	(res2 0)
	(x1 0)
	(ln1 0)
	(hn1 0))

    ;; Extract the boundaries of the matrix (vector).
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1)) 

    ;; Cycle.
    (let loop ((j1 ln1))
      (if (<= j1 hn1)
	  (begin (set! x1 (array-ref p_a1 0 j1))
		 (set! res2 (+ (expt x1 4) (* -16 (expt x1 2)) (* 5 x1)))
		 (set! res1 (+ res1 (/ res2 2)))
		 (loop (+ j1 1)))))    
    
    res1))


;;;; grsp-sop-ackley - Ackley test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-5.0, +5.0].
;; - p_y1: number, [-5.0, +5.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-ackley p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(p2 0))

    ;; Init.
    (set! p2 (* 2 (grsp-pi)))
    
    ;; res4.
    (set! res4 (* -0.2 (sqrt (* 0.5 (+ (expt p_x1 2) (expt p_y1 2))))))
    
    ;; res5.
    (set! res5 (* 0.5 (+ (cos (* p2 p_x1)) (cos (* p2 p_y1)))))
    
    ;; res2.
    (set! res2 (* -20 (grsp-eex res4)))
    
    ;; res3.
    (set! res3 (* -1 (grsp-eex res5)))
    
    ;; Compose results.
    (set! res1 (+ res2 res3 (grsp-e) 20))
    
    res1))


;;;; grsp-sop-ackley-mth - Multithreaded variant of grsp-sop-ackley
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-5.0, +5.0].
;; - p_y1: number, [-5.0, +5.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-ackley-mth p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(p2 0))

    (set! p2 (* 2 (grsp-pi)))
    
    (parallel (set! res4 (* -0.2 (sqrt (* 0.5 (+ (expt p_x1 2) (expt p_y1 2))))))
	      (set! res5 (* 0.5 (+ (cos (* p2 p_x1)) (cos (* p2 p_y1))))))
    
    (parallel (set! res2 (* -20 (grsp-eex res4)))
	      (set! res3 (* -1 (grsp-eex res5))))

    ;; Compose results.    
    (set! res1 (+ res2 res3 (grsp-e) 20))
    
    res1))


;;;; grsp-sop-easom - Easom test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-easom p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    ;; res2.
    (set! res2 (* -1 (cos p_x1) (cos p_y1)))

    ;; res3.
    (set! res3 (grsp-eex (* -1 (+ (expt (- p_x1 (grsp-pi)) 2) 
				  (expt (- p_y1 (grsp-pi)) 2)))))
    
    ;; Compose results.
    (set! res1 (* res2 res3))
    
    res1))


;;;; grsp-sop-easom-mth - Multithreaded variant of grsp-sop-easom.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-easom-mth p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    (parallel (set! res2 (* -1 (cos p_x1) (cos p_y1)))
	      (set! res3 (grsp-eex (* -1 (+ (expt (- p_x1 (grsp-pi)) 2) 
					    (expt (- p_y1 (grsp-pi)) 2))))))

    ;; Compose results.    
    (set! res1 (* res2 res3))
    
    res1))


;;;; grsp-sop-cit - Cross-in-tray test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-cit p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    ;; res2.
    (set! res2 (* (sin p_x1) (sin p_y1)))

    ;; res3.
    (set! res3 (grsp-eex (abs (- 100 (/ (sqrt (+ (expt p_x1 2) (expt p_y1 2))) (grsp-pi))))))

    ;; Compose results.
    (set! res1 (* -1 0.0001 (expt (+ (abs (* res2 res3)) 1) 0.1)))
    
    res1))


;;;; grsp-sop-cit-mth - Multithreaded variant of grsp-sop-cit.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-cit-mth p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    (parallel (set! res2 (* (sin p_x1) (sin p_y1)))
	      (set! res3 (grsp-eex (abs (- 100 (/ (sqrt (+ (expt p_x1 2)
							   (expt p_y1 2)))
						  (grsp-pi)))))))

    ;; Compose results.    
    (set! res1 (* -1 0.0001 (expt (+ (abs (* res2 res3)) 1) 0.1)))
    
    res1))


;;;; grsp-sop-hoelder - Hoelder test, single objective function.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-hoelder p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    ;; res2.
    (set! res2 (* (sin p_x1) (cos p_y1)))

    ;; res3.
    (set! res3 (grsp-eex (abs (- 1 (/ (sqrt (+ (expt p_x1 2)
					       (expt p_y1 2)))
				      (grsp-pi))))))

    ;; Compose results.
    (set! res1 (* -1 (abs (* res2 res3))))
    
    res1))


;;;; grsp-sop-hoelder-mth - Multithreaded variant of grsp-sop-hoelder.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-sop-hoelder-mth p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    (parallel (set! res2 (* (sin p_x1) (cos p_y1)))
	      (set! res3 (grsp-eex (abs (- 1 (/ (sqrt (+ (expt p_x1 2)
							 (expt p_y1 2)))
						(grsp-pi)))))))

    ;; Compose results.    
    (set! res1 (* -1 (abs (* res2 res3))))
    
    res1))


;;;; grsp-cop-rosenbrock1 - Rosenbrock test, constrained objective function
;; (cube, line). Returns +nan.0 for unconstraied arguments.
;; - (p_x1 - 1)**3 - p_y1 + 1 <= 0.
;; - p_x1 = p_y1 - 2 <= 0.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number [-1.5, 1.5].
;; - p_y1: number [-0.5, 2.5].
;;
;; Sources:
;; - [1].
;;
(define (grsp-cop-rosenbrock1 p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    ;; res2.
    (set! res2 (+ (expt (- p_x1 1) 3) (* -1 p_y1) 1))
    
    ;; res3.
    (set! res3 (+ p_x1 p_y1 -2))
    
    ;; Compose results.
    (cond ((equal? (and (<= res2 0) (<= res3 0)) #t)
	   (set! res1 (+ (expt (- 1 p_x1) 2)
			 (* 100 (expt (- p_y1 (expt p_x1 2)) 2)))))
	  (else (set! res1 +nan.0)))
    
    res1))


;;;; grsp-cop-rosenbrock2 - Rosenbrock test, constrained objective function
;; (disk). Returns +nan.0 for unconstraied arguments.
;; - p_x1**2 + p_y1**2 <= 2-
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number [-1.5, 1.5].
;; - p_y1: number [-1.5, 1.5].
;;
;; Sources:
;; - [1].
;;
(define (grsp-cop-rosenbrock2 p_x1 p_y1)
  (let ((res1 0)
	(x2 0)
	(y2 0))

    ;; Init.
    (set! x2 (expt p_x1 2))
    (set! y2 (expt p_y1 2))
    
    ;; Compose results.
    (cond ((equal? (<= (+ x2 y2) 2) #t)
	   (set! res1 (+ (expt (- 1 p_x1) 2) (* 100 (expt (- p_x1 x2) 2))))) 
	  (else (set! res1 +nan.0)))
    
    res1))


;;;; grsp-cop-mbird - Mishra's bird test, constrained objective function
;; (disk). Returns +nan.0 for unconstraied arguments.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number.
;; - p_y1: number.
;;
;; Sources:
;; - [1].
;;
(define (grsp-cop-mbird p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(x2 0)
	(y2 0))

    ;; Init.
    (set! x2 (cos p_x1))
    (set! y2 (sin p_y1))

    ;; res2.
    (set! res2 (+ (expt (+ p_x1 5) 2) (expt (+ p_y1 5) 2)))
    
    ;; res1.
    (cond ((equal? (< res2 25) #t)

	   ;; res3.
	   (set! res3 (* y2 (grsp-eex (expt (- 1 x2) 2))))
	   
	   ;; res4.
	   (set! res4 (* x2 (grsp-eex (expt (- 1 y2) 2))))
	   
	   ;; res5.
	   (set! res5 (expt (- p_x1 p_y1) 2))
	   
	   (set! res1 (+ res3 res4 res5))) 
	  (else (set! res1 +nan.0)))
    
    res1))


;;;; grsp-cop-mbird-mth - Multithreaded variant of grsp-cop-mbird.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number.
;; - p_y1: number.
;;
;; Sources:
;; - [1].
;;
(define (grsp-cop-mbird-mth p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(res5 0)
	(x2 0)
	(y2 0))

    (parallel (set! x2 (cos p_x1))
	      (set! y2 (sin p_y1))
	      (set! res2 (+ (expt (+ p_x1 5) 2) (expt (+ p_y1 5) 2))))
    
    (cond ((equal? (< res2 25) #t)

	   (parallel (set! res3 (* y2 (grsp-eex (expt (- 1 x2) 2))))
		     (set! res4 (* x2 (grsp-eex (expt (- 1 y2) 2))))
		     (set! res5 (expt (- p_x1 p_y1) 2)))
	   
	   (set! res1 (+ res3 res4 res5))) 
	  (else (set! res1 +nan.0)))
    
    res1))


;;;; grsp-cop-simionescu - Simionescu test, constrained objective function
;; (disk). Returns +nan.0 for unconstraied arguments.
;;
;; Keywords:
;; - functions, test, optimization, artificial, landscape.
;;
;; Parameters:
;; - p_x1: number [-1.25, 1.25].
;; - p_y1: number [-1.25, 1.25] != 0.
;;
;; Sources:
;; - [1].
;;
(define (grsp-cop-simionescu p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    ;; res2.
    (set! res2 (+ (expt p_x1 2) (expt p_y1 2)))

    ;; res3.
    (cond ((equal? (equal? p_y1 0) #f)
	   (set! res3 (expt (+ 1 (* 0.2 (cos (* 8 (atan (/ p_x1 p_y1)))))) 2)))
	  (else (set! res3 (- res2 1))))
    
    ;; Compose results.
    (cond ((equal? (<= res2 res3) #t)
	   (set! res1 (* 0.1 p_x1 p_y1)))
	  (else (set! res1 +nan.0)))
    
    res1))
    
