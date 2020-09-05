;; =============================================================================
;;
;; grsp6.scm
;;
;; Physics functions.
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


(define-module (grsp grsp6)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp4)
  #:use-module (grsp grsp5)  
  #:export (grsp-ds
	    grsp-lorentz-factor
	    grsp-time-dilation
	    grsp-length-contraction
	    grsp-lorentz-transf-x))


;; grsp-ds - Calculate intervals in Euclidean space or Minkowski spacetime (norm
;; of a time-like vector).
;;
;; Arguments:
;; - p_t1: t1.
;; - p_t2: t2.
;; - p_x1: x1.
;; - p_x2: x2.
;; - p_y1: y1.
;; - p_y2: y2.
;; - p_z1: z1.
;; - p_z2: z2.
;;
;; Sources:
;; - En.wikipedia.org. 2020. Minkowski Space. [online] Available at:
;;   https://en.wikipedia.org/wiki/Minkowski_space [Accessed 31 August 2020].
;;
(define (grsp-ds p_t1 p_t2 p_x1 p_x2 p_y1 p_y2 p_z1 p_z2)
  (let ((res1 0)
	(nx 0)
	(ny 0)
	(nz 0)
	(nt 0)
	(nf -1)
	(l #t))

    ;; If p_t1 and p_t2 are zero, ignore time displacement and use Euclidean
    ;; space. If time coordinates are not zero, use Minkowski spacetime.
    (cond ((equal? p_t1 0)
	   (cond ((equal? p_t2 0)
		  (set! l #f)
		  (set! nf 1)))))

    ;; x displacement.
    (set! nx (* (grsp-osbv "#-" 2 p_x1 p_x2) nf))

    ;; y displacement.
    (set! ny (* (grsp-osbv "#-" 2 p_y1 p_y2) nf))

    ;; z displacement.
    (set! nz (* (grsp-osbv "#-" 2 p_z1 p_z2) nf))

    ;; t displacement.
    (cond ((equal? l #t)
	   (set! nt (expt (* (gconst "c") (- p_t1 p_t2)) 2 ))))

    ;; Calculate root of summation of dimensions. If Euclidean space is
    ;; used, nf = 1 so that spacelike vectors will be positive (+ + +), and if
    ;; spacetime is used, nf = -1 so that spacelike vectors become negative and
    ;; the timelike vector is trated as positive (+ - - -).
    (set! res1 (sqrt (+ (+ (+ nx ny) nz) nt)))
	   
    res1))


;; grsp-lorentz-factor - Calculates gamma, or Lorentz factor.
;;
;; Arguments: 
;; - p_v1: relative velocity between inertial frames (should be p_v1 < c).
;;
;; Sources:
;; - https://en.wikipedia.org/wiki/Lorentz_factor
;; - En.wikipedia.org. 2020. List Of Relativistic Equations. [online] Available
;;   at: https://en.wikipedia.org/wiki/List_of_relativistic_equations
;;   [Accessed 4 September 2020].
;;
(define (grsp-lorentz-factor p_v1)
  (let ((res1 0))

    (set! res1 (/ 1 (sqrt (- 1 (/ (expt p_v1 2) (expt (gconst "c") 2))))))

    res1))


;; grsp-time-dilation - Calculates time t' from t at a given position x in
;; same inertial frame
;;
;; Arguments: 
;; - p_v1: relative velocity.
;; - p_t1: proper time.
;;
;; Sources:
;; - En.wikipedia.org. 2020. List Of Relativistic Equations. [online] Available
;;   at: https://en.wikipedia.org/wiki/List_of_relativistic_equations
;;   [Accessed 4 September 2020].
;;
(define (grsp-time-dilation p_v1 p_t1)
  (let ((res1 0))

    (set! res1 (* (grsp-lorentz-factor p_v1) p_t1))

    res1))


;; grsp-length-contraction - Calculates length contraction under relativistic
;; conditions.
;;
;; Arguments: 
;; - p_v1: relative velocity.
;; - p_d1: proper length.
;;
;; Sources:
;; - En.wikipedia.org. 2020. List Of Relativistic Equations. [online] Available
;;   at: https://en.wikipedia.org/wiki/List_of_relativistic_equations
;;   [Accessed 4 September 2020].
;;
(define (grsp-length-contraction p_v1 p_d1)
  (let ((res1 0))

    (set! res1 (/ p_d1 (grsp-lorentz-factor p_v1)))

    res1))


;; grsp-lorentz-transf-x - Lorentz transformations (x).
;;
;; Arguments: 
;; - p_v1: relative velocity.
;; - p_t1: proper time.
;; - p_x1: x rel. coord.
;; - p_y2: y rel. coord.
;; - p_z1: z rel/ coord.
;;
;; Sources:
;; - En.wikipedia.org. 2020. List Of Relativistic Equations. [online] Available
;;   at: https://en.wikipedia.org/wiki/List_of_relativistic_equations
;;   [Accessed 4 September 2020].
;;
(define (grsp-lorentz-transf-x p_v1 p_t1 p_x1 p_y1 p_z1)
  (let ((res1 '())
	(t2 0)
	(x2 0)
	(y2 0)
	(z2 0)
	(l1 0))

    (set! l1 (grsp-lorentz-factor p_v1))
    (set! t2 (* l1 (- p_t1 (/ (* p_v1 p_x1) (expt (gconst "c") 2)))))
    (set! x2 (* l1 (- p_x1 (* p_v1 p_t1))))
    (set! y2 p_y1)
    (set! z2 p_z1)
    
    (set! res1 (list t2 x2 y2 z2))

    res1))

