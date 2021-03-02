;; =============================================================================
;;
;; grsp9.scm
;;
;; Test functions for optimization.
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


;;;; General notes:
;; - Read sources for limitations on function parameters.
;;
;; Sources:
;; - [1] https://en.wikipedia.org/wiki/Test_functions_for_optimization


(define-module (grsp grsp9)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp4)  
  #:export (grsp-booth
	    grsp-bukin6
	    grsp-beale
	    grsp-matyas
	    grsp-rastrigin
	    grsp-goldstein-price
	    grsp-levi13
	    grsp-himmelblau
	    grsp-3camel
	    grsp-mccormick
	    grsp-schaffer2
	    grsp-schaffer4
	    grsp-spheret))


;;;; grsp-booth - Booth test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-booth p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (+ (expt (+ p_x1 (* 2 p_y1) (* -1 7)) 2)
		  (expt (+ (* 2 p_x1) p_y1 (* -1 5)) 2)))
    
    res1))


;;;; grsp-bukin6 - Bukin 6 test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_x1: number, [-15.0, -5.0].
;; - p_y1: number, [-3.0, 3.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-bukin6 p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (+ (* 100 (sqrt (abs (- p_y1 (* 0.001 (expt p_x1 2))))))
		  (* 0.01 (abs (+ p_x1 10)))))
    
    res1))


;;;; grsp-beale - Bukin 6 test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_x1: number, [-4.5, 4.5].
;; - p_y1: number, [-4.5, 4.5].
;;
;; Sources:
;; - [1].
;;
(define (grsp-beale p_x1 p_y1)
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
    
    ;; res1.
    (set! res1 (+ res2 res3 res4))
    
    res1))


;;;; grsp-matyas - Matyas test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-matyas p_x1 p_y1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

	;; res2.
	(set! res2 (* 0.26 (+ (expt p_x1 2) (expt p_y1 2))))
	
	;; res3.
	(set! res3 (* 0.48 p_x1 p_y1))
	
    (set! res1 (- res2 res3))

    res1))


;;;; grsp-rastrigin - Rastrigin test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_a1: 1 x n vector with n elements, representing an n-dimensinal problem.
;;
;; Notes:
;; - Each element of p_a1 should belong to the interval [-5.12, 5.12].
;;
;; Sources:
;; - [1].
;;
(define (grsp-rastrigin p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(p2 0)
	(j1 1)
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
    (set! p2 (* 2 (gconst "A000796")))

    ;; res2.
    (set! res2 (* 10 n1))
    
    ;; res3.
    (while (<= j1 n1)
	   (set! x1 (array-ref p_a1 0 j1))
	   (set! res3 (+ res3 (- (expt x1 2) (* 10 (cos (* p2 x1))))))
	   (set! j1 (+ j1 1)))
	   
    ;; res1.
    (set! res1 (+ res2 res3))

    res1))


;;;; grsp-goldstein-price - Goldstein-Price test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_x1: number, [-2.0, 2.0].
;; - p_y1: number, [-2.0, 2.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-goldstein-price p_x1 p_y1)
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
    
    ;; Res1.
    (set! res1 (* res2 res3))
    
    res1))


;;;; grsp-levi13 - Levi test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_x1: number, [-10.0, 10.0].
;; - p_y1: number, [-10.0, 10.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-levi13 p_x1 p_y1)
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
    (set! px (* x (gconst "A000796")))
    (set! py (* y (gconst "A000796")))

    ;; res2.
    (set! res2 (expt (sin (* 3 px)) 2))
    
    ;; res3.
    (set! res3 (* (expt (- x 1 ) 2) (+ 1 (expt (sin (* 3 py)) 2))))
    
    ;; res4.
    (set! res4 (* (expt (- y 1) 2) (+ 1 (expt (sin (* 2 py)) 2))))
    
    ;; res1.
    (set! res1 (+ res2 res3 res4))
    
    res1))


;;;; grsp-himmelblau - Himmelblau test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_x1: number, [-5.0, 5.0].
;; - p_y1: number, [-5.0, 5.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-himmelblau p_x1 p_y1)
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
    
    ;; res1.
    (set! res1 (+ res2 res3))

    res1))


;;;; grsp-himmelblau - Three hump camel test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_x1: number, [-5.0, 5.0].
;; - p_y1: number, [-5.0, 5.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-3camel p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (+ (* 2 (expt p_x1 2))
		  (* 1.05 (expt p_x1 4))
		  (* (/ (expt p_x1 6) 6))
		  (* p_x1 p_y1)
		  (expt p_y1 2)))
    
    res1))


;;;; grsp-mccormick - McCormick test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_x1: number, [-1.5, 4.0].
;; - p_y1: number, [-3.0, 4.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-mccormick p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (+ (sin (+ p_x1 p_y1))
		  (expt (- p_x1 p_y1 ) 2)
		  (* -1.5 p_x1)
		  (* 2.5 p_y1)
		  1))
    
    res1))


;;;; grsp-schaffer2 - Schaffer 2 test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_x1: number, [-100.0, 100.0].
;; - p_y1: number, [-100.0, 100.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-schaffer2 p_x1 p_y1)
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
    
    ;; res1.
    (set! res1 (+ 0.5 (/ res2 res3)))
    
    res1))


;;;; grsp-schaffer4 - Schaffer 4 test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_x1: number, [-100.0, 100.0].
;; - p_y1: number, [-100.0, 100.0].
;;
;; Sources:
;; - [1].
;;
(define (grsp-schaffer4 p_x1 p_y1)
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
    
    ;; res1.
    (set! res1 (+ 0.5 (/ res2 res3)))
    
    res1))


;;;; grsp-spheret - Sphere test, single objective function.
;;
;; Keywords:
;; - function, test, optimization, artificial, landscape.
;;
;; Arguments:
;; - p_a1: 1 x n vector with n elements, representing an n-dimensinal problem.
;;   [-inf.0, +inf.0]
;;
;; Sources:
;; - [1].
;;
(define (grsp-spheret p_a1)
  (let ((res1 0)
	(j1 0)
	(ln1 0)
	(hn1 0))

    ;; Extract the boundaries of the matrix (vector).
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1)) 

    (set! j1 ln1)
    (while (<= j1 ln1)
	   (set! res1 (+ res1 (expt (array-ref p_a1 0 j1) 2)))
	   (set! j1 (+ j1 1)))
    
    res1))
	
