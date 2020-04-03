; ==============================================================================
;
; grsp5.scm
;
; Statisitical and probabilistic functions.
;
; ==============================================================================
;
; Copyright (C) 2018  Pablo Edronkin (pablo.edronkin at yahoo.com)
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

; https://en.wikipedia.org/wiki/Probability

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
	    grsp-pcond))


; grsp-feature-scaling - scales (normalizes) p_n between [0,1].
;
; Arguments:
; - p_n: scalar.
; - p_nmin: min value for p_n.
; - p_max: max value for p_x.
;
; Sources:
; - https://www.statisticshowto.datasciencecentral.com/normalized/
;
(define (grsp-feature-scaling p_n p_nmin p_nmax)
  (let ((res1 0))

    (set! res1 (* 1.0 (/ (- p_n p_nmin) (- p_nmax p_nmin))))
    res1))


; grsp-z-score - calculates the z score for a sample data point.
;
; Arguments:
; - p_n1: data point.
; - p_m1: sample mean.
; - p_s1: sample standard deviation.
;
; Sources:
; - https://www.statisticshowto.datasciencecentral.com/normalized/
;
(define (grsp-z-score p_n1 p_m1 p_s1)
  (let ((res1 0))

    (set! res1 (* 1.0 (/ (- p_n1 p_m1) p_s1)))
    res1))


; grsp-binop - performs operation p_s1 on p_n1 and p_n2 and calculates the p_n3
; power of that binomial operation.
;
; Arguments:
; - p_s1: string determining the operation.
;   - "#+": sum.
;   - "#-": substraction.
;   - "#*": multiplication.
;   - "#/": division.
; - p_n1: real.
; - p_n2: real.
; - p_n3: real.
;
(define (grsp-binop p_s1 p_n1 p_n2 p_n3)
  (let ((res1 0))

    (cond  ((equal? p_s1 "#+")
	    (set! res1 (expt (+ p_n1 p_n2) p_n3)))
	   ((equal? p_s1 "#-")
	    (set! res1 (expt (- p_n1 p_n2) p_n3)))
	   ((equal? p_s1 "#*")
	    (set! res1 (expt (- p_n1 p_n2) p_n3)))
	   ((equal? p_s1 "#/")
	    (set! res1 (expt (- p_n1 p_n2) p_n3))))
	   
    res1))


; grsp-pnot - calculates the complementary probability of p_n1.
;
; Arguments:
;- p_n1: real representing a probability in [0,1]
;
(define (grsp-pnot p_n1)
  (let ((res1 1))

    (set! res1 (- res1 (grsp-fitin p_n1 0.0 1.0)))

    res1))


; grsp-pand - calculates the probability of p_n1 and p_n2 happening, 
; being independent.
;
; Arguments:
;- p_n1: real repesenting a probability in [0,1]
;- p_n2: real repesenting a probability in [0,1]
;
(define (grsp-pand p_n1 p_n2)
  (let ((res1 1))

    (set! res1 (* (grsp-fitin p_n1 0.0 1.0) (grsp-fitin p_n2 0.0 1.0)))

    res1))


; grsp-pnand - calculates the probability of p_n1 and p_n2 happening, 
; being not independent.
;
; Arguments:
;- p_n1: real repesenting a probability in [0,1]
;- p_n2: real repesenting a probability in [0,1]
;
(define (grsp-pnand p_n1 p_n2)
  (let ((res1 1)
	(n1 0)
	(n2 0))

    (set! n1 (grsp-fitin p_n1 0.0 1.0))
    (set! n2 (grsp-fitin p_n2 0.0 1.0)) 
    (set! res1 (* (grsp-pcond n1 n2) n2))
    
    res1))


; grsp-por - calculates the probability of p_n1 or p_n2 happening.
;
; Arguments:
;- p_n1: real repesenting a probability in [0,1]
;- p_n2: real repesenting a probability in [0,1]
;
(define (grsp-por p_n1 p_n2)
  (let ((res1 1)
	(n1 0)
	(n2 0))

    (set! n1 (grsp-fitin p_n1 0.0 1.0))
    (set! n2 (grsp-fitin p_n2 0.0 1.0))    
    (set! res1 (- (+ n1 n2) (grsp-pand n1 n2)))

    res1))


; grsp-pxor - calculates the probability of p_n1 or p_n2 happening, 
; beign mutually exclusive.
;
; Arguments:
;- p_n1: real repesenting a probability in [0,1]
;- p_n2: real repesenting a probability in [0,1]
;
(define (grsp-pxor p_n1 p_n2)
  (let ((res1 0)
	(n1 0)
	(n2 0))

    (set! n1 (grsp-fitin p_n1 0.0 1.0))
    (set! n2 (grsp-fitin p_n2 0.0 1.0))    
    (cond ((<= (+ n1 n2) 1)
	   (set! res1 (+ n1 n2))))

    res1))


; grsp-pcond - calculates the probability of p_n1 given p_n2 happening.
;
; Arguments:
;- p_n1: real repesenting a probability in [0,1]
;- p_n2: real repesenting a probability in [0,1]
;
(define (grsp-pcond p_n1 p_n2)
  (let ((res1 0)
	(n1 0)
	(n2 0))

    (set! n1 (grsp-fitin p_n1 0.0 1.0))
    (set! n2 (grsp-fitin p_n2 0.0 1.0))
    (cond ((> n2 0)
	   (set! res1 (/ (grsp-pand n1 n2) n2))))

    res1))

