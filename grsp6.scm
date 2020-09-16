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
	    grsp-lorentz-transf-x
	    grsp-beta
	    grsp-velocity
	    grsp-acceleration
	    grsp-frequency-observed
	    grsp-frequency-emitted
	    grsp-frequency-osrel
	    grsp-redshift
	    grsp-velocity-un
	    grsp-velocity-ac
	    grsp-distance-parallax
	    grsp-particle-mass))


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

    (set! res1 (/ 1 (sqrt (- 1 (expt (grsp-beta p_v1) 2)))))
    
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


;; grsp-beta - Calculates the beta term of the Lortentz factor.
;;
;; Arguments:
;; - p_v1: relative velocity between two intertial frames.
;;
;; Sources:
;; - En.wikipedia.org. 2020. List Of Relativistic Equations. [online] Available
;;   at: https://en.wikipedia.org/wiki/List_of_relativistic_equations
;;   [Accessed 4 September 2020].
;;
(define (grsp-beta p_v1)
  (let ((res1 0))

    (set! res1 (/ p_v1 (gconst "c")))

    res1))


;; grsp-velocity - Calculates velocity on one axis.
;;
;; Arguments:
;; - p_x1: coord 1.
;; - p_x2: coord 2.
;; - p_t1: time 1.
;; - p_t2: time 2.
;;
(define (grsp-velocity p_x1 p_x2 p_t1 p_t2)
  (let ((res1 0))

    (set! res1 (/ (- p_x2 p_x1) (- p_t2 p_t1)))

    res1))


;; grsp-acceleration - Calculates acceleration on one axis.
;;
;; Arguments:
;; - p_v1: velocity 1.
;; - p_v2: velocity 2.
;; - p_t1: time 1.
;; - p_t2: time 2.
;;
(define (grsp-acceleration p_v1 p_v2 p_t1 p_t2)
  (let ((res1 0))

    (set! res1 (/ (- p_v2 p_v1) (- p_t2 p_t1)))

    res1))    


;; grsp-frequency-observed - Calculates the observed frequency.
;;
;; Arguments:
;; - p_s1: see grsp-frequency-osrel.
;; - p_v1: see grsp-frequency-osrel.
;; - p_v2: see grsp-frequency-osrel.
;; - p_v3: see grsp-frequency-osrel.
;; - p_f1: emitted frequency
;;
;; Sources:
;; - En.wikipedia.org. 2020. Doppler Effect. [online] Available at:
;;   https://en.wikipedia.org/wiki/Doppler_effect [Accessed 7 September 2020].
;;
(define (grsp-frequency-observed p_s1 p_v1 p_v2 p_v3 p_f1)
  (let ((res1 0))
    
    (set! res1 (* p_f1 (grsp-frequency-osrel p_s1 p_v1 p_v2 p_v3)))

    res1))


;; grsp-frequency-emitted - Calculates the emitted frequency.
;;
;; Arguments:
;; - p_s1: see grsp-frequency-osrel.
;; - p_v1: see grsp-frequency-osrel.
;; - p_v2: see grsp-frequency-osrel.
;; - p_v3: see grsp-frequency-osrel.
;; - p_f2: observed frequency.
;;
;; Sources:
;; - En.wikipedia.org. 2020. Doppler Effect. [online] Available at:
;;   https://en.wikipedia.org/wiki/Doppler_effect [Accessed 7 September 2020].
;;
(define (grsp-frequency-emitted p_s1 p_v1 p_v2 p_v3 p_f2)
  (let ((res1 0))

    (set! res1 (/ p_f2 (grsp-frequency-osrel p_s1 p_v1 p_v2 p_v3)))

    res1))

;; grsp-frequency-osrel - Observer - source relationship.
;;
;; Arguments:
;; - p_s1: string, relative movement between the source and the receiver.
;;   - "#++": p_v1 is added to p_v2 (receiver moves toward source), and p_v1 is
;;     added to p_v2 (source moves away from the receiver).
;;   - "$+-": p_v1 is added to p_v2 (receiver moves toward source), and p_v3 is
;;     substracted from p_v1 (source is moving towards the receiver).
;;   - "$-+": p_v2 is substracted from p_v1 (receiver moves away from source),
;;     and p_v1 is added to p_v2 (source moves away from the receiver).
;;   - "$--": p_v2 is substracted from p_v1 (receiver moves away from source),
;;     and p_v3 is substracted from p_v1 (source is moving towards the receiver).
;; - p_v1: propagation speed in the medium.
;; - p_v2: speed of the receiver.
;; - p_v3: speed of the source.
;;
;; Sources:
;; - En.wikipedia.org. 2020. Doppler Effect. [online] Available at:
;;   https://en.wikipedia.org/wiki/Doppler_effect [Accessed 7 September 2020].
;;
(define (grsp-frequency-osrel p_s1 p_v1 p_v2 p_v3)
  (let ((res1 0)
	(n1 1)
	(n2 1))

    ;; Conditions of source and receiver.
    (cond ((equal? p_s1 "#+-")
	   (set! n1 -1))
	  ((equal? p_s1 "#-+")
	   (set! n2 -1))
	  ((equal? p_s1 "#--")
	   (set! n1 -1)
	   (set! n2 -1)))
    
    (set! res1 (/ (+ p_v1 (* n1 p_v2)) (+ p_v1 (* n2 p_v3))))

    res1))
	

;; grsp-redshift - Calculates redshift based on wavelength or frequency.
;;
;; Arguments:
;; - p_s1: string. Defines if wl or fr is used.
;;   - "#wl": for wavelength.
;;   - "#fr": for frequency.
;; - p_n1: value that corresponds to the emitter (wl or fr).
;; - p_n2: value that corresponds to the observer (wl or fr).
;;
;; Sources:
;; - En.wikipedia.org. 2020. Redshift. [online] Available at:
;;   https://en.wikipedia.org/wiki/Redshift [Accessed 9 September 2020].
;;
(define (grsp-redshift p_s1 p_n1 p_n2)
  (let ((res1 0))

    (cond ((equal? p_s1 "#fr")
	   (set! res1 (/ (- p_n1 p_n2) p_n2)))
	  ((equal? p_s1 "#wl")
	   (set! res1 (/ (- p_n2 p_n1) p_n1))))

    res1))


;; grsp-velocity-un - Calculates velocity as distance / time.
;;
;; Arguments:
;; - p_l1: distance.
;; - p_t1: time.
;;
(define (grsp-velocity-un p_l1 p_t1)
  (let ((res1 0))

    (set! res1 (/ p_l1 p_t1))

    res1))


;; grsp-velocity-ac - Calculates velocity as accelertion * time.
;;
;; Arguments:
;; - p_a1: acceleration.
;; - p_t1: time.
;;
(define (grsp-velocity-ac p_a1 p_t1)
  (let ((res1 0))

    (set! res1 (* p_a1 p_t1))

    res1))


;; grsp-distance-parallax - Measures the distance (PC) to a star.
;;
;; Arguments:
;; - p_g1: parallax (arcseconds).
;;
(define (grsp-distance-parallax p_g1)
  (let ((res1 0))

    ;;(set! res1 (/ (gconst "PC") (tan (/ p_g1 3600))))
    (set! res1 (/ 1 p_g1))

    res1))


;; grsp-particle-mass - Energy of a particle.
;;
;; Arguments:
;; - p_v1: speed of the particle.
;; - p_m1: rest mass of the particle.
;;
(define (grsp-particle-mass p_v1 p_m1)
  (let ((res1 0))

    (set! res1 (* (grsp-lorentz-factor p_v1) (* p_m1 (expt (gconst "c") 2))))

    res1))

