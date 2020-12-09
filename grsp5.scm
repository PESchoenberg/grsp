;; =============================================================================
;;
;; grsp5.scm
;;
;; Statistical and probabilistic functions.
;;
;; =============================================================================
;;
;; Copyright (C) 2018 - 2020  Pablo Edronkin (pablo.edronkin at yahoo.com)
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


;; Sources:
;; - [1] En.wikipedia.org. 2020. Probability. [online] Available at:
;;   https://en.wikipedia.org/wiki/Probability [Accessed 23 July 2020].
;; - [2] En.wikipedia.org. 2020. Bayes' Theorem [online] Available at:
;;   https://en.wikipedia.org/wiki/Bayes%27_theorem [Accessed 23 July 2020].
;; - [3] Statistics How To. 2020. Normalized Data / Normalization - Statistics
;;   How To. [online] Available at:
;;   https://www.statisticshowto.datasciencecentral.com/normalized/
;;   [Accessed 23 July 2020].
;; - [4] En.wikipedia.org. 2020. Poisson Distribution. [online] Available at:
;;   https://en.wikipedia.org/wiki/Poisson_distribution
;;   [Accessed 23 November 2020].
;; - [5] En.wikipedia.org. 2020. Probability Mass Function. [online] Available
;;   at: https://en.wikipedia.org/wiki/Probability_mass_function
;;   [Accessed 23 November 2020].
;; - [6] En.wikipedia.org. 2020. Gamma Distribution. [online] Available at:
;;   https://en.wikipedia.org/wiki/Gamma_distribution
;;   [Accessed 3 December 2020].


(define-module (grsp grsp5)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp4)  
  #:export (grsp-feature-scaling
	    grsp-z-score
	    grsp-binop
	    grsp-pnot
	    grsp-pand
	    grsp-pnand
	    grsp-por
	    grsp-pxor
	    grsp-pcond
	    grsp-pcomp
	    grsp-osbv
	    grsp-obsv
	    grsp-poisson-pmf
	    grsp-poisson-kurtosis
	    grsp-poisson-skewness
	    grsp-poisson-fisher
	    grsp-gamma-mean1
	    grsp-gamma-mean2
	    grsp-gamma-variance1
	    grsp-gamma-variance2
	    grsp-gamma-kurtosis
	    grsp-gamma-skewness
	    grsp-gamma-mode1
	    grsp-gamma-mode2
	    grsp-gamma-pdf1
	    grsp-gamma-pdf2
	    grsp-gamma-cdf1
	    grsp-gamma-cdf2))


;; grsp-feature-scaling - Scales p_n to the interval [p_nmin, p_nmax].
;;
;; Arguments:
;; - p_n1: scalar, real.
;; - p_nmin: min value for p_n.
;; - p_max: max value for p_x.
;;
;; Sources:
;; - [3].
;;
;; Notes:
;; - If p_n1 lies outside the interval [p_nmin, p_nmax] the function will  
;;   truncate p_n1 to fit it within the interval.
;;
(define (grsp-feature-scaling p_n1 p_nmin p_nmax)
  (let ((res1 0.0))

    (cond ((> p_n1 p_nmax)
	   (set! p_nmax p_n1))
	  ((< p_n1 p_nmin)
	   (set! p_nmin p_n1)))
    (set! res1 (* 1.0 (/ (- p_n1 p_nmin) (- p_nmax p_nmin))))
    
    res1))


;; grsp-z-score - Calculates the z score for a sample data point.
;;
;; Arguments:
;; - p_n1: data point.
;; - p_m1: sample mean.
;; - p_s1: sample standard deviation.
;;
;; Sources:
;; - [3].
;;
(define (grsp-z-score p_n1 p_m1 p_s1)
  (let ((res1 0.0))

    (set! res1 (* 1.0 (/ (- p_n1 p_m1) p_s1)))
    
    res1))


;; grsp-binop - Performs an operation p_s1 on p_n1 and p_n2 and calculates the
;; p_n3 power of that binomial operation.
;;
;; Arguments:
;; - p_s1: string determining the operation.
;;   - "#+": sum.
;;   - "#-": substraction.
;;   - "#*": multiplication.
;;   - "#/": division.
;; - p_n1: real.
;; - p_n2: real.
;; - p_n3: real.
;;
;; Sources:
;; - [1].
;;
(define (grsp-binop p_s1 p_n1 p_n2 p_n3)
  (let ((res1 0.0))

    (cond  ((equal? p_s1 "#+")
	    (set! res1 (expt (+ p_n1 p_n2) p_n3)))
	   ((equal? p_s1 "#-")
	    (set! res1 (expt (- p_n1 p_n2) p_n3)))
	   ((equal? p_s1 "#*")
	    (set! res1 (expt (- p_n1 p_n2) p_n3)))
	   ((equal? p_s1 "#/")
	    (set! res1 (expt (- p_n1 p_n2) p_n3))))
    
    res1))


;; grsp-pnot - Calculates the complementary probability of p_n1.
;;
;; Arguments:
;; - p_n1: real representing a probability in [0,1].
;;
;; Sources:
;; - [1].
;;
(define (grsp-pnot p_n1)
  (let ((res1 1.0))

    (set! res1 (- res1 (grsp-fitin-0-1 p_n1)))

    res1))


;; grsp-pand - Calculates the probability of p_n1 and p_n2, being independent.
;;
;; Arguments:
;; - p_n1: real repesenting a probability in [0,1].
;; - p_n2: real repesenting a probability in [0,1].
;;
;; Sources:
;; - [1].
;;
(define (grsp-pand p_n1 p_n2)
  (let ((res1 1.0))

    (set! res1 (* (grsp-fitin-0-1 p_n1) (grsp-fitin-0-1 p_n2)))

    res1))


;; grsp-pnand - Calculates the probability of p_n1 and p_n2 happening, 
;; being p_n1 and p_n2 not independent.
;;
;; Arguments:
;; - p_n1: real repesenting a probability in [0,1].
;; - p_n2: real repesenting a probability in [0,1].
;;
;; Sources:
;; - [1].
;;
(define (grsp-pnand p_n1 p_n2)
  (let ((res1 1.0)
	(n1 0.0)
	(n2 0.0))

    (set! n1 (grsp-fitin-0-1 p_n1))
    (set! n2 (grsp-fitin-0-1 p_n2)) 
    (set! res1 (* (grsp-pand n1 n2) n2))
    
    res1))


;; grsp-por - Calculates the probability of p_n1 or p_n2.
;;
;; Arguments:
;; - p_n1: real repesenting a probability in [0,1].
;; - p_n2: real repesenting a probability in [0,1].
;;
;; Sources:
;; - [1].
;;
(define (grsp-por p_n1 p_n2)
  (let ((res1 1.0)
	(n1 0.0)
	(n2 0.0))

    (set! n1 (grsp-fitin-0-1 p_n1))
    (set! n2 (grsp-fitin-0-1 p_n2))    
    (set! res1 (- (+ n1 n2) (grsp-pand n1 n2)))

    res1))


;; grsp-pxor - Calculates the probability of p_n1 or p_n2 happening, 
;; beign p_n1 and p_n2 mutually exclusive.
;;
;; Arguments:
;; - p_n1: real repesenting a probability in [0,1].
;; - p_n2: real repesenting a probability in [0,1].
;;
;; Sources:
;; - [1].
;;
(define (grsp-pxor p_n1 p_n2)
  (let ((res1 0.0)
	(n1 0.0)
	(n2 0.0))

    (set! n1 (grsp-fitin-0-1 p_n1))
    (set! n2 (grsp-fitin-0-1 p_n2))    
    (cond ((<= (+ n1 n2) 1)
	   (set! res1 (+ n1 n2))))

    res1))


;; grsp-pcond - Calculates the probability of p_n1 given p_n2.
;;
;; Arguments:
;; - p_n1: real repesenting a probability in [0,1].
;; - p_n2: real repesenting a probability in [0,1].
;;
;; Sources:
;; - [1].
;; - [2].
;;
(define (grsp-pcond p_n1 p_n2)
  (let ((res1 0.0)
	(n1 p_n1)
	(n2 p_n2))

    (set! n1 (grsp-fitin-0-1 p_n1))
    (set! n2 (grsp-fitin-0-1 p_n2))
    (cond ((> n2 0.0)
	   (set! res1 (/ (grsp-pand n1 n2) n2))))

    res1))


;; grsp-pcomp - Given that (expt (abs p_n1) 2) + (expt (abs n2) 2) = 1, and 
;; given p_n1 as a parameter, returns (abs n2).
;;
;; Arguments:
;; - p_n1: real repesenting a probability in [0,1]
;;
;; Sources:
;; - [1].
;;
(define (grsp-pcomp p_n1)
  (let ((res1 0.0))

    (set! res1 (sqrt (- 1 (expt (abs p_n1) 2))))

    res1))


;; grsp-osbv - Calculates expt operation p_s1 between p_n1 and p_n2 according
;; to exponent p_e1. Can be used to calculate - for example - the squared
;; difference between two numbers.
;;
;; Arguments:
;; - p_s1: operation.
;;   - "#+": addition.
;;   - "#-": substraction.
;;   - "#*": multiplication.
;;   - "#/": division.
;; - p_e1: exponent (power).
;; - p_n1: real number.
;; - p_n2: real number.
;;
;; Sources:
;; - [1].
;;
(define (grsp-osbv p_s1 p_e1 p_n1 p_n2)
  (let ((res1 0.0))
    
    (cond ((equal? p_s1 "#-")
	   (set! res1 (expt (- p_n1 p_n2) p_e1)))
	  ((equal? p_s1 "#*")
	   (set! res1 (expt (* p_n1 p_n2) p_e1)))	  
	  ((equal? p_s1 "#/")
	   (set! res1 (expt (/ p_n1 p_n2) p_e1)))
	  (else (set! res1 (expt (+ p_n1 p_n2) p_e1))))
	  
    res1))


;; grsp-obsv - Calculates expt operation to p_e1 power for p_n1 and p_n2 and
;; then perfoms operation p_s1 between those values.
;;
;; Arguments:
;; - p_s1: operation.
;;   - "#+": addition.
;;   - "#-": substraction.
;;   - "#*": multiplication.
;;   - "#/": division.
;; - p_n1: real number.
;; - p_n2: real number.
;;
;; Sources:
;; - [1].
;;
(define (grsp-obsv p_s1 p_e1 p_n1 p_n2)
  (let ((res1 0.0)
	(n1 (expt p_n1 p_e1))
	(n2 (expt p_n2 p_e1)))	
    
    (cond ((equal? p_s1 "#-")
	   (set! res1 (- p_n1 p_n2)))
	  ((equal? p_s1 "#*")
	   (set! res1 (* p_n1 p_n2)))
	  ((equal? p_s1 "#/")
	   (set! res1 (/ p_n1 p_n2)))
	  (else (set! res1 (+ p_n1 p_n2))))
	  
    res1))


;; grsp-poisson-pmf - Poisson distribution, progability mass function.
;;
;; Arguments:
;; - p_l1: mean, expected value. Lambda, [0, +inf).
;; - p_k1: number oc. Int, [0, +inf).
;;
;; Sources:
;; - [4][5].
;;
(define (grsp-poisson-pmf p_l1 p_k1)
  (let ((res1 0))

    (set! res1 (/ (* (expt p_l1 p_k1)
		     (expt (gconst "A001113") (* -1 p_l1)))
		  (grsp-fact p_k1)))

    res1))


;; grsp-poisson-kurtosis
;;
;; Arguments:
;; - p_l1: mean, expected value. Lambda, [0, +inf).
;;
;; Sources:
;; - [4].
;;
(define (grsp-poisson-kurtosis p_l1)
  (let ((res1 0))

    (set! res1 (expt p_l1 -1))

    res1))


;; grsp-poisson-skewness
;;
;; Arguments:
;; - p_l1: mean, expected value. Lambda, [0, +inf).
;;
;; Sources:
;; - [4].
;;
(define (grsp-poisson-skewness p_l1)
  (let ((res1 0))

    (set! res1 (expt p_l1 (/ -1 2)))

    res1))


;; grsp-poisson-fisher - Fisher information.
;;
;; Arguments:
;; - p_l1: mean, expected value. Lambda, [0, +inf).
;;
;; Sources:
;; - [4].
;;
(define (grsp-poisson-fisher p_l1)
  (let ((res1 0))

    (set! res1 (/ 1 p_l1))

    res1))
    

;; grsp-gamma-mean1 - Mean, parametrization k-t.
;;
;; Arguments:
;; - p_k1: k. Shape, (0, +inf).
;; - p_t1: theta. Scale, (0, +inf).
;;
;; Sources:
;; - [6].
;;
(define (grsp-gamma-mean1 p_k1 p_t1)
  (let ((res1 0))

    (set! res1 (* p_k1 p_t1))

    res1))


;; grsp-gamma-mean2 - Mean, parametrization a-b.
;;
;; Arguments:
;; - p_a1: alpha. Shape, (0, +inf).
;; - p_b1: beta. Scale, (0, +inf).
;;
;; Sources:
;; - [6].
;;
(define (grsp-gamma-mean2 p_a1 p_b1)
  (let ((res1 0))

    (set! res1 (/ p_a1 p_b1))

    res1))


;; grsp-gamma-variance1 - Variance, parametrization k-t.
;;
;; Arguments:
;; - p_k1: k. Shape, (0, +inf).
;; - p_t1: theta, (0, +inf).
;;
;; Sources:
;; - [6].
;;
(define (grsp-gamma-variance1 p_k1 p_t1)
  (let ((res1 0))

    (set! res1 (* p_k1 (expt p_t1 2)))

    res1))


;; grsp-gamma-variance2 - Variance, parametrization a-b.
;;
;; Arguments:
;; - p_a1: alpha. Shape, (0, +inf).
;; - p_b1: beta. Scale, (0, +inf).
;;
;; Sources:
;; - [6].
;;
(define (grsp-gamma-variance2 p_a1 p_b1)
  (let ((res1 0))

    (set! res1 (/ p_a1 (expt p_b1 2)))

    res1))


;; grsp-gamma-kurtosis - Kurtosis, parametrizationa k-t and a-b.
;;
;; Arguments:
;; - p_n1:
;;   - k: for parametrization k-t.
;;   - alpha: for parametrization a-b.
;;
;; Sources:
;; - [6].
;;
(define (grsp-gamma-kurtosis p_n1)
  (let ((res1 0))

    (set! res1 (/ 6 p_n1))

    res1))


;; grsp-gamma-skewness - Skewness, parametrizationa k-t and a-b.
;;
;; Arguments:
;; - p_n1:
;;   - k: for parametrization k-t.
;;   - alpha: for parametrization a-b.
;;
;; Sources:
;; - [6].
;;
(define (grsp-gamma-skewness p_n1)
  (let ((res1 0))

    (set! res1 (/ 2 (sqrt p_n1)))

    res1))


;; grsp-gamma-mode1 - Mode, parametrization k-t.
;;
;; Arguments:
;; - p_k1: k. Shape. Mode requires [0, +inf).
;; - p_t1: theta. Scale, (0, +inf).
;;
;; Sources:
;; - [6].
;;
(define (grsp-gamma-mode1 p_k1 p_t1)
  (let ((res1 0))

    (set! res1 (* (- p_k1 1) p_t1))

    res1))


;; grsp-gamma-mode2 - Mode, parametrization a-b.
;;
;; Arguments:
;; - p_a1: alpha. Shape. Mode requires [1, +inf).
;; - p_b1: beta. Scale, (0, +inf).
;;
;; Sources:
;; - [6].
;;
(define (grsp-gamma-mode2 p_a1 p_b1)
  (let ((res1 0))

    (set! res1 (/ (- p_a1 1) p_b1))

    res1))


;; grsp-gamma-pdf1 - Probability density function, parametrization k-t.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_s1: desired gamma repesentation:
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;; - p_k1: k. Shape.
;; - p_t1: theta.
;; - p_x1: sample, (0, +inf)
;; - p_n1: desired product iterations.
;;
;; Sources:
;; - [6].
;;
(define (grsp-gamma-pdf1 p_b2 p_s1 p_k1 p_t1 p_x1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0))
   
    ;; res2
    (set! res2 (/ 1 (* (grsp-complex-gamma p_b2 p_s1 p_k1 p_n1) (expt p_t1 p_k1))))
    
    ;; res3
    (set! res3 (expt p_x1 (- p_k1 1)))
    
    ;; res4
    (set! res4 (expt (gconst "A001113") (* -1 (/ p_x1 p_t1))))

    ;; Complete formula.
    (set! res1 (* res2 res3 res4))
    
    res1))


;; grsp-gamma-pdf2 - Probability density function, parametrization a-b.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_s1: desired gamma repesentation:
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;; - p_a1: alpha. 
;; - p_b1: beta.
;; - p_x1: sample, (0, +inf).
;; - p_n1: desired product iterations.
;;
;; Sources:
;; - [6].
;;
(define (grsp-gamma-pdf2 p_b2 p_s1 p_a1 p_b1 p_x1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0))
   
    ;; res2
    (set! res2 (/ (expt p_b1 p_a1) (grsp-complex-gamma p_b2 p_s1 p_a1 p_n1)))
    
    ;; res3
    (set! res3 (expt p_x1 (- p_a1 1)))
    
    ;; res4
    (set! res4 (expt (gconst "A001113") (* -1 p_b1 p_x1)))

    ;; Complete.
    (set! res1 (* res2 res3 res4))
    
    res1))


;; grsp-gamma-cdf1 - Cumulative distribution function, parametrization k-t.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_s1: desired gamma repesentation:
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;; - p_a1: alpha. 
;; - p_b1: beta.
;; - p_x1: sample, (0, +inf).
;; - p_n1: desired product iterations.
;;
;; Sources:
;; - [6].
;;
(define (grsp-gamma-cdf1 p_b2 p_s1 p_k1 p_t1 p_x1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    ;; res2
    (set! res2 (/ 1 (grsp-complex-gamma p_b2 p_s1 p_k1 p_n1)))
    
    ;; res3
    (set! res3 (grsp-complex-ligamma p_b2 p_s1 p_k1 (/ p_x1 p_t1) p_n1))

    ;; Complete.
    (set! res1 (* res2 res3)) 
    
    res1))


;; grsp-gamma-cdf2 - Cumulative distribution function, parametrization a-b.
;;
;; Arguments:
;; - p_b2: for integers.
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;; - p_s1: desired gamma repesentation:
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;; - p_a1: alpha. 
;; - p_b1: beta.
;; - p_x1: sample, (0, +inf).
;; - p_n1: desired product iterations.
;;
;; Sources:
;; - [6].
;;
(define (grsp-gamma-cdf2 p_b2 p_s1 p_a1 p_b1 p_x1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    ;; res2
    (set! res2 (/ 1 (grsp-complex-gamma p_b2 p_s1 p_a1 p_n1)))
    
    ;; res3
    (set! res3 (grsp-complex-ligamma p_b2 p_s1 p_a1 (* p_b1 p_x1) p_n1))

    ;; Complete.
    (set! res1 (* res2 res3)) 
    
    res1))

  
