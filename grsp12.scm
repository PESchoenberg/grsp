;; =============================================================================
;; 
;; grsp12.scm
;;
;; Evolutionary and genetic functions.
;;
;; =============================================================================
;;
;; Copyright (C) 2021 - 2022 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;; - [1] En.wikipedia.org. 2021. Differential evolution - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Differential_evolution
;;   [Accessed 21 October 2021].


(define-module (grsp grsp12)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp5)
  #:export (grsp-evo-mod1-ff1
	    grsp-evo-mod1-pop-create
	    grsp-evo-mod1-evolve))


;;;; grsp-evo-mod1-ff1 - Calculates the fitness of each individual as a measure
;; of it attaining proximity to the problem's goal expressed as a succesive
;; base operation p_s1 on all elements corresponding to columns contaiend in
;; p_l1 of matrix p_a1. Differential evolution.
;;
;; Keywords:
;; - function, evolution, genetic, differential.
;;
;; Arguments:
;; - p_s1: base op.
;;   - "#+r": row sumation.
;;   - "#-r": row substraction.
;;   - "#*r": row product.
;;   - "#/r": row division.
;; - p_a1: population matrix.
;; - p_n1: column containing the goal.
;; - p_g1: goal value.
;; - p_l1: list of columns of p_a1 on which p_s1 is performed.
;;
(define (grsp-evo-mod1-ff1 p_s1 p_a1 p_n1 p_g1 p_l1)
  (let ((res1 p_a1)
	(res2 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(j1 0)
	(r1 0)
	(l1 '()))

  ;; Extract boundaries.
  (set! lm1 (grsp-matrix-esi 1 res1))
  (set! hm1 (grsp-matrix-esi 2 res1))
  (set! ln1 (grsp-matrix-esi 3 res1))
  (set! hn1 (grsp-matrix-esi 4 res1))

  ;; Select columns to oeprate on.
  (set! res2 (grsp-matrix-col-selectn p_a1 p_l1))
  
  ;; Cycle.
  (let loop ((i1 lm1))
    (if (<= i1 hm1)
	(begin (set! r1 (grsp-matrix-opio p_s1 p_a1 i1))
	       (array-set! res1 r1 i1 p_n1)
	       ;; Evaluate fitness as the inverse of absolute "distance" to the goal
	       ;; (col 3 has fitness).
	       (array-set! res1 (abs (/ 1 (- p_g1 (array-ref res1 i1 p_n1)))) i1 3)
	       (loop (+ i1 1)))))
  
  res1))


;;;; grsp-evo-mod1-pop-create - Creates a population matrix according to the
;; following structure:
;; - Col 0: id.
;; - Col 1: status.
;;   - 0: dead.
;;   - 1: inactive.
;;   - 2: active.
;; - Col 2: type.
;; - Col 3: fitness.
;; - Col 4: result.
;;
;; Keywords:
;; - function, evolution, genetic.
;;
;; Arguments:
;; - p_m1: total number of rows (individuals).
;; - p_n1: number of columns (+ 5 existing).
;;
;; Notes:
;; - The structure of the matrix is set to make it compatible with the
;;   requirements of other datas structures such as those of grsp8.
;;
(define (grsp-evo-mod1-pop-create p_m1 p_n1)
  (let ((res1 0)
	(n1 0))

    ;; Total number of columns.
    (set! n1 (+ 5 p_n1))

    ;; Creation of population matrix.
    (set! res1 (grsp-matrix-create "#rprnd" p_m1 n1))

    ;; Id - Create unique key on col 0.
    (grsp-matrix-keyon "#col" res1 0 0 1)

    ;; Active - Set col 1 to 2 in all rows.
    (set! res1 (grsp-matrix-col-aupdate res1 1 2))

    ;; Type - Set col 2 to 0 in all rows.
    (set! res1 (grsp-matrix-col-aupdate res1 2 0))

    ;; Fitness - Set col 3 to 0 in all rows.
    (set! res1 (grsp-matrix-col-aupdate res1 3 0))

    ;; Compose results - Set col 4 to 0 in all rows.
    (set! res1 (grsp-matrix-col-aupdate res1 6 n1)) ;; p_n2

    res1))


;;;; grsp-evo-mod1-evolve - Evolve results.
;;
;; Keywords:
;; - function, evolution, genetic.
;;
;; Arguments.
;; - p_a1: population matrix.
;; - p_m1: Number of individuals per generation.
;; - p_n1: max number of generations.
;; - p_n2: column containing the goal value.
;; - p_g1: goal value for fitness function.
;; - p_ft1: minimum desired fitness.
;; - p_s2: fitness function.
;;   - "#mod1-ff1": use grsp-evo-mod1-ff1.
;; - p_l2: list of arguments for p_s1.
;; - p_s1: base op (see grsp-evo-mod1-ff1).
;; - p_l1: list of columns of p_a1 on which p_s1 is performed.
;;
(define (grsp-evo-mod1-evolve p_a1 p_m1 p_n1 p_n2 p_g1 p_s2 p_l2 p_ft1 p_s1 p_l1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(u1 0)
	(m1 0)
	(sd1 0)
	(ft2 0)
	(i1 0))

    ;; Create safety matrices. 
    (set! res1 (grsp-matrix-cpy p_a1))
    
    (while (< i1 p_n1)
	   
	   ;; Calculate fitness.
	   (cond ((equal? p_s2 "#mod1-ff1")
		  (cond ((= i1 0)
			 (set! res1 (list-ref p_l2 1))))
		  
		  (set! res1 (grsp-evo-mod1-ff1 (list-ref p_l2 0)
						res1
						(list-ref p_l2 2)
						(list-ref p_l2 3)
						(list-ref p_l2 4)))))
	   
	   ;; Select the two most fit individuals.
	   (set! res1 (grsp-matrix-row-sort "#des" res1 3))
	   (set! res1 (grsp-matrix-row-selectn res1 '(0 1)))
	   
	   ;; Perform crossover.
	   (set! res2 res1)
	   (set! res3 (grsp-matrix-row-invert res1))
	   (set! res4 (grsp-matrix-crossover res2 4 5 res3 4 5))
	   
	   ;; Calculate mean fitness.
	   (cond ((> (grsp-mean1-mth (grsp-matrix-col-selectn res4 '(3))) p_ft1)
		  (set! i1 p_n1)))
	   
	   (set! res1 res4)
	   
	   ;; Mutate if not on the last cycle.
	   (cond ((< i1 (- p_n1 1))
		  (set! res1 (grsp-matrix-col-lmutation res4
							0.5
							"#normal"
							0.0
							0.15
							"#normal"
							0.0
							0.15
							'(4 5)))))
	   
	   (set! i1 (in i1)))

    ;; At this point only the best solution attained should be returned (i.e.
    ;; individual or row with highest fitness value).
    (set! res1 (grsp-matrix-row-sort "#des" res1 3))
    (set! res1 (grsp-matrix-row-selectn res1 '(0)))  
    
    res1))



