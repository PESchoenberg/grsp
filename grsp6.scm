;; =========================================================================
;;
;; grsp6.scm
;;
;; Physics functions and related code.
;;
;; =========================================================================
;;
;; Copyright (C) 2018 - 2024 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;;
;; Sources:
;;
;; See code of functions used and their respective source files for more
;; credits and references.
;;
;; - [1] En.wikipedia.org. 2020. Standard Gravitational Parameter. [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/Standard_gravitational_parameter
;;   [Accessed 22 September 2020].
;; - [2] En.wikipedia.org. 2020. Minkowski Space. [online] Available at:
;;   https://en.wikipedia.org/wiki/Minkowski_space [Accessed 31 August
;;   2020].
;; - [3] En.wikipedia.org. 2020. Lorentz Factor. [online] Available at:
;;   https://en.wikipedia.org/wiki/Lorentz_factor [Accessed 19 September
;;   2020].
;; - [4] En.wikipedia.org. 2020. List Of Relativistic Equations. [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/List_of_relativistic_equations
;;   [Accessed 4 September 2020].
;; - [5] En.wikipedia.org. 2020. Doppler Effect. [online] Available at:
;;   https://en.wikipedia.org/wiki/Doppler_effect [Accessed 7 September
;;   2020].
;; - [6] En.wikipedia.org. 2020. Redshift. [online] Available at:
;;   https://en.wikipedia.org/wiki/Redshift [Accessed 9 September 2020].
;; - [7]  En.wikipedia.org. 2020. Modern Physics. [online] Available at:
;;   https://en.wikipedia.org/wiki/Modern_physics [Accessed 26 September
;;   2020].
;; - [8] See grsp1 [14].
;; - [9] Es.wikipedia.org. 2020. Ecuación Del Cohete De Tsiolkovski.
;;   [online] Available at:
;;   https://es.wikipedia.org/wiki/Ecuaci%C3%B3n_del_cohete_de_Tsiolkovski
;;   [Accessed 29 September 2020].
;; - [10] En.wikipedia.org. 2020. Eötvös Effect. [online] Available at:
;;   https://en.wikipedia.org/wiki/E%C3%B6tv%C3%B6s_effect
;;   [Accessed 2 October 2020].
;; - [11] En.wikipedia.org. 2020. Gravity Of Earth. [online] Available at:
;;   https://en.wikipedia.org/wiki/Gravity_of_Earth [Accessed 3 October
;;   2020].
;; - [12] En.wikipedia.org. 2020. Gravitational Acceleration. [online]
;;   Available at: https://en.wikipedia.org/wiki/Gravitational_acceleration
;;   [Accessed 8 October 2020].
;; - [13] En.wikipedia.org. 2020. Theoretical Gravity. [online] Available
;;   at: https://en.wikipedia.org/wiki/Theoretical_gravity [Accessed 8
;;   October 2020].
;; - [14] En.wikipedia.org. 2020. Clairaut's Theorem. [online] Available at:
;;   https://en.wikipedia.org/wiki/Clairaut%27s_theorem#Somigliana_equation
;;   [Accessed 10 October 2020].
;; - [15] Pl.wikipedia.org. 2020. Przyspieszenie Ziemskie. [online]
;;   Available at: https://pl.wikipedia.org/wiki/Przyspieszenie_ziemskie
;;   [Accessed 12 October 2020].
;; - [16] Es.wikipedia.org. 2020. Métrica De Alcubierre. [online] Available
;;   at: https://es.wikipedia.org/wiki/M%C3%A9trica_de_Alcubierre
;;   [Accessed 5 November 2020].
;; - [17] Es.wikipedia.org. 2021. Métrica de Schwarzschild - Wikipedia, la
;;   enciclopedia libre. [online] Available at:
;;   https://es.wikipedia.org/wiki/M%C3%A9trica_de_Schwarzschild
;;   [Accessed 28 October 2021].
;; - [18] En.wikipedia.org. 2021. Equations of motion - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Equations_of_motion
;;   [Accessed 21 November 2021].
;; - [19] En.wikipedia.org. 2022. Wormhole - Wikipedia. [online] Available
;;   at: https://en.wikipedia.org/wiki/Wormhole[Accessed 25 January 2022].
;; - [20] En.wikipedia.org. 2022. ER = EPR - Wikipedia. [online] Available
;;   at: https://en.wikipedia.org/wiki/ER_%3D_EPR [Accessed 25 January
;;   2022].
;; - [21] En.wikipedia.org. 2022. Bloch sphere - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Bloch_sphere [Accessed
;;   26 May 2022].
;; - [22] En.wikipedia.org. 2022. Riemann sphere - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Riemann_sphere [Accessed
;;   26 May 2022].


(define-module (grsp grsp6)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp4)
  #:use-module (grsp grsp5)
  #:use-module (ice-9 threads)  
  #:export (grsp-ds
	    grsp-ds-mth
	    grsp-lorentz-factor
	    grsp-time-dilation
	    grsp-length-contraction
	    grsp-lorentz-transf-x
	    grsp-lorentz-transf-x-mth
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
	    grsp-particle-mass
	    grsp-sgp-mass
	    grsp-sgp-ellip
	    grsp-effective-exhaust-velocity
	    grsp-ideal-rocket
	    grsp-grav-earth-lat
	    grsp-grav-earth-alt
	    grsp-grav-radius
	    grsp-grav-ifor
	    grsp-grav-iforh
	    grsp-grav-somigliana
	    grsp-grav-somigliana-mth))


;;;; grsp-ds - Calculate intervals in Euclidean space or Minkowski
;; spacetime (norm of a time-like vector).
;;
;; Keywords:
;;
;; - relativity, metric
;;
;; Parameters:
;;
;; - p_t1: t1.
;; - p_t2: t2.
;; - p_x1: x1.
;; - p_x2: x2.
;; - p_y1: y1.
;; - p_y2: y2.
;; - p_z1: z1.
;; - p_z2: z2.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [2].
;;
(define (grsp-ds p_t1 p_t2 p_x1 p_x2 p_y1 p_y2 p_z1 p_z2)
  (let ((res1 0)
	(nx 0)
	(ny 0)
	(nz 0)
	(nt 0)
	(nf -1)
	(l #t))

    ;; If p_t1 and p_t2 are zero, ignore time displacement and use
    ;; Euclidean space. If time coordinates are not zero, use Minkowski
    ;; spacetime.
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
    ;; used, nf = 1 so that spacelike vectors will be positive (+ + +),
    ;; and if spacetime is used, nf = -1 so that spacelike vectors become
    ;; negative and the timelike vector is treated as positive (+ - - -).
    (set! res1 (sqrt (+ (+ (+ nx ny) nz) nt)))
	   
    res1))


;;;; grsp-ds-mth - Multithreaded variant of grsp-ds.
;;
;; Keywords:
;;
;; - relativity, metric
;;
;; Parameters:
;;
;; - p_t1: t1.
;; - p_t2: t2.
;; - p_x1: x1.
;; - p_x2: x2.
;; - p_y1: y1.
;; - p_y2: y2.
;; - p_z1: z1.
;; - p_z2: z2.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [2].
;;
(define (grsp-ds-mth p_t1 p_t2 p_x1 p_x2 p_y1 p_y2 p_z1 p_z2)
  (let ((res1 0)
	(nx 0)
	(ny 0)
	(nz 0)
	(nt 0)
	(nf -1)
	(l #t))

    (cond ((equal? p_t1 0)
	   
	   (cond ((equal? p_t2 0)
		  (set! l #f)
		  (set! nf 1)))))

    (parallel (set! nx (* (grsp-osbv "#-" 2 p_x1 p_x2) nf))
	      (set! ny (* (grsp-osbv "#-" 2 p_y1 p_y2) nf))
	      (set! nz (* (grsp-osbv "#-" 2 p_z1 p_z2) nf))
	      
	      (cond ((equal? l #t)
		     (set! nt (expt (* (gconst "c") (- p_t1 p_t2)) 2 )))))

    ;; Compose results.
    (set! res1 (sqrt (+ nx ny nz nt)))
	   
    res1))


;;;; grsp-lorentz-factor - Calculates gamma (Lorentz factor).
;;
;; Keywords:
;;
;; - relativity, dilation, observer
;;
;; Parameters:
;; 
;; - p_v1: relative velocity between inertial frames (should be p_v1 < c).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [3][4].
;;
(define (grsp-lorentz-factor p_v1)
  (let ((res1 0))

    (set! res1 (/ 1 (sqrt (- 1 (expt (grsp-beta p_v1) 2)))))
    
    res1))


;;;; grsp-time-dilation - Calculates time t' from t at a given position x
;; in same inertial frame.
;;
;; Keywords:
;;
;; - relativity, dilation, observer
;;
;; Parameters:
;; 
;; - p_v1: relative velocity.
;; - p_t1: proper time.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [4].
;;
(define (grsp-time-dilation p_v1 p_t1)
  (let ((res1 0))

    (set! res1 (* (grsp-lorentz-factor p_v1) p_t1))

    res1))


;;;; grsp-length-contraction - Calculates length contraction under
;; relativistic conditions.
;;
;; Keywords:
;;
;; - relativity, contraction, observer
;;
;; Parameters:
;; 
;; - p_v1: relative velocity.
;; - p_d1: proper length.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [4].
;;
(define (grsp-length-contraction p_v1 p_d1)
  (let ((res1 0))

    (set! res1 (/ p_d1 (grsp-lorentz-factor p_v1)))

    res1))


;;;; grsp-lorentz-transf-x - Lorentz transformations (x).
;;
;; Keywords:
;;
;; - relativity, transform
;;
;; Parameters:
;; 
;; - p_v1: relative velocity.
;; - p_t1: proper time.
;; - p_x1: x rel. coord.
;; - p_y2: y rel. coord.
;; - p_z1: z rel. coord.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [4].
;;
(define (grsp-lorentz-transf-x p_v1 p_t1 p_x1 p_y1 p_z1)
  (let ((res1 '())
	(t2 0.0)
	(x2 0.0)
	(y2 0.0)
	(z2 0.0)
	(l1 0.0))

    (set! l1 (grsp-lorentz-factor p_v1))
    (set! t2 (* l1 (- p_t1 (/ (* p_v1 p_x1) (expt (gconst "c") 2)))))
    (set! x2 (* l1 (- p_x1 (* p_v1 p_t1))))
    (set! y2 p_y1)
    (set! z2 p_z1)

    ;; Compose results.
    (set! res1 (list t2 x2 y2 z2))

    res1))


;;;; grsp-lorentz-transf-x-mth - Multithreaded variant of
;; grsp-lorentz-transf.
;;
;; Keywords:
;;
;; - relativity, transform
;;
;; Parameters:
;; 
;; - p_v1: relative velocity.
;; - p_t1: proper time.
;; - p_x1: x rel. coord.
;; - p_y2: y rel. coord.
;; - p_z1: z rel. coord.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [4].
;;
(define (grsp-lorentz-transf-x-mth p_v1 p_t1 p_x1 p_y1 p_z1)
  (let ((res1 '())
	(t2 0.0)
	(x2 0.0)
	(y2 0.0)
	(z2 0.0)
	(l1 0.0))

    (set! l1 (grsp-lorentz-factor p_v1))
    (parallel (set! t2 (* l1
			  (- p_t1
			     (/ (* p_v1 p_x1) (expt (gconst "c") 2)))))
	      (set! x2 (* l1 (- p_x1 (* p_v1 p_t1))))
	      (set! y2 p_y1)
	      (set! z2 p_z1))

    ;; Compose results.    
    (set! res1 (list t2 x2 y2 z2))

    res1))


;;;; grsp-beta - Calculates the beta term of the Lorentz factor.
;;
;; Keywords:
;;
;; - relativity, frames, special
;;
;; Parameters:
;;
;; - p_v1: relative velocity between two inertial frames.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [4].
;;
(define (grsp-beta p_v1)
  (let ((res1 0))

    (set! res1 (/ p_v1 (gconst "c")))

    res1))


;;;; grsp-velocity - Calculates velocity, one axis.
;;
;; Keywords:
;;
;; - dynamics, speed, velocity
;;
;; Parameters:
;;
;; - p_x1: coord 1.
;; - p_x2: coord 2.
;; - p_t1: time 1.
;; - p_t2: time 2.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-velocity p_x1 p_x2 p_t1 p_t2)
  (let ((res1 0))

    (set! res1 (/ (- p_x2 p_x1) (- p_t2 p_t1)))

    res1))


;;;; grsp-acceleration - Calculates acceleration, one axis.
;;
;; Keywords:
;;
;; - dynamics, acceleration, increment
;;
;; Parameters:
;;
;; - p_v1: velocity 1.
;; - p_v2: velocity 2.
;; - p_t1: time 1.
;; - p_t2: time 2.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-acceleration p_v1 p_v2 p_t1 p_t2)
  (let ((res1 0))

    (set! res1 (/ (- p_v2 p_v1) (- p_t2 p_t1)))

    res1))    


;;;; grsp-frequency-observed - Calculates the observed frequency.
;;
;; Keywords:
;;
;; - waves, observable, frequency
;;
;; Parameters:
;;
;; - p_s1: see grsp-frequency-osrel.
;; - p_v1: see grsp-frequency-osrel.
;; - p_v2: see grsp-frequency-osrel.
;; - p_v3: see grsp-frequency-osrel.
;; - p_f1: emitted frequency
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [5].
;;
(define (grsp-frequency-observed p_s1 p_v1 p_v2 p_v3 p_f1)
  (let ((res1 0))
    
    (set! res1 (* p_f1 (grsp-frequency-osrel p_s1 p_v1 p_v2 p_v3)))

    res1))


;;;; grsp-frequency-emitted - Calculates the emitted frequency.
;;
;; Keywords:
;;
;; - waves, frequency
;;
;; Parameters:
;;
;; - p_s1: see grsp-frequency-osrel.
;; - p_v1: see grsp-frequency-osrel.
;; - p_v2: see grsp-frequency-osrel.
;; - p_v3: see grsp-frequency-osrel.
;; - p_f2: observed frequency.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [5].
;;
(define (grsp-frequency-emitted p_s1 p_v1 p_v2 p_v3 p_f2)
  (let ((res1 0))

    (set! res1 (/ p_f2 (grsp-frequency-osrel p_s1 p_v1 p_v2 p_v3)))

    res1))


;;;; grsp-frequency-osrel - Observer - source relationship.
;;
;; Keywords:
;;
;; - waves, sources, observer, relativity
;;
;; Parameters:
;;
;; - p_s1: string, relative movement between the source and the receiver.
;;
;;   - "#++": p_v1 is added to p_v2 (receiver moves toward source), and
;;     p_v1 is added to p_v2 (source moves away from the receiver).
;;   - "$+-": p_v1 is added to p_v2 (receiver moves toward source), and
;;     p_v3 is substracted from p_v1 (source is moving towards the
;;     receiver).
;;   - "$-+": p_v2 is substracted from p_v1 (receiver moves away from
;;     source), and p_v1 is added to p_v2 (source moves away from the
;;     receiver).
;;   - "$--": p_v2 is substracted from p_v1 (receiver moves away from
;;     source), and p_v3 is substracted from p_v1 (source is moving
;;     towards the receiver).
;;
;; - p_v1: propagation speed in the medium.
;; - p_v2: speed of the receiver.
;; - p_v3: speed of the source.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [5].
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
	

;;;; grsp-redshift - Calculates redshift based on wavelength or frequency.
;;
;; Keywords:
;;
;; - waves, wave, shift, redshift
;;
;; Parameters:
;;
;; - p_s1: string. Defines if wl or fr is used.
;;
;;   - "#wl": for wavelength.
;;   - "#fr": for frequency.
;;
;; - p_n1: value that corresponds to the emitter (wl or fr).
;; - p_n2: value that corresponds to the observer (wl or fr).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-redshift p_s1 p_n1 p_n2)
  (let ((res1 0))

    (cond ((equal? p_s1 "#fr")
	   (set! res1 (/ (- p_n1 p_n2) p_n2)))
	  ((equal? p_s1 "#wl")
	   (set! res1 (/ (- p_n2 p_n1) p_n1))))

    res1))


;;;; grsp-velocity-un - Calculates velocity as distance / time.
;;
;; Keywords:
;;
;; - dynamics, distance, time, velocity, speed, dsiplacement
;;
;; Parameters:
;;
;; - p_l1: distance.
;; - p_t1: time.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-velocity-un p_l1 p_t1)
  (let ((res1 0))

    (set! res1 (/ p_l1 p_t1))

    res1))


;;;; grsp-velocity-ac - Calculates velocity as acceleration * time.
;;
;; Keywords:
;;
;; - dynamics, accelerate, time, speed, velocity, displacement, speed
;;
;; Parameters:
;;
;; - p_a1: acceleration.
;; - p_t1: time.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-velocity-ac p_a1 p_t1)
  (let ((res1 0))

    (set! res1 (* p_a1 p_t1))

    res1))


;;;; grsp-distance-parallax - Measures the distance (PC) to a star.
;;
;; Keywords:
;;
;; - astro, celestial, body, measurement, distance
;;
;; Parameters:
;;
;; - p_g1: parallax (arcseconds).
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-distance-parallax p_g1)
  (let ((res1 0))

    (set! res1 (/ 1 p_g1))

    res1))


;;;; grsp-particle-mass - Energy of a particle.
;;
;; Keywords:
;;
;; - relativity, particles, energy
;;
;; Parameters:
;;
;; - p_v1: speed of the particle.
;; - p_m1: rest mass of the particle.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-particle-mass p_v1 p_m1)
  (let ((res1 0))

    (set! res1 (* (grsp-lorentz-factor p_v1)
		  (* p_m1 (expt (gconst "c") 2))))

    res1))


;;;; grsp-sgp-mass - Calculates the standard gravitational parameter of a
;; body of mass m1.
;;
;; Keywords:
;;
;; - relativity, astro, mass
;;
;; Parameters:
;;
;; - p_m1: mass of the body (kg).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-sgp-mass p_m1)
  (let ((res1 0))

    (set! res1 (* p_m1 (gconst "G")))

    res1))


;;;; grsp-sgp=mass - Calculates the standard gravitational parameter of a
;; body at relative distance p_a1 and orbital period p_t1.
;;
;; Keywords:
;;
;; - relativity, astro
;;
;; Parameters:
;;
;; - p_a1: relative distance between the main and secodary bodies.
;; - p_t1: orbital period of secondary arond main body.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-sgp-ellip p_a1 p_t1)
  (let ((res1 0))

    (set! res1 (/ (* (* 4 (grsp-pi)) (expt p_a1 3)) (expt p_t1 2)))

    res1))

	  
;;;; grsp-effective-exhaust-velocity - Calculates eev.
;;
;; Keywords:
;;
;; - dynamics, astro, impulse, acceleration
;;
;; Parameters:
;;
;; - p_x1: specific impulse in dimension of time.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [8][15].
;;
(define (grsp-effective-exhaust-velocity p_x1)
  (let ((res1 0))

    (set! res1 (* p_x1 (gconst "g0")))

    res1))


;;;; grsp-ideal-rocket - Ideal rocket equation.
;;
;; Keywords:
;;
;; - dynamics, astro, ideal, model
;;
;; Parameters:
;;
;; - p_x1: specific impulse.
;; - p_m1: initial mass.
;; - p_m2: final mass.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [8][9].
;;
(define (grsp-ideal-rocket p_x1 p_m1 p_m2)
  (let ((res1 0))

    (set! res1 (* (grsp-effective-exhaust-velocity p_x1)
		  (log (/ p_m1 p_m2))))

    res1))


;;;; grsp-grav-earth-lat - Gravity on Earth as a function of latitude.
;;
;; Keywords:
;;
;; - astro, gravity, planet, earth. latitude, coordinates
;;
;; Parameters:
;;
;; - p_l1: latitude [-90, 90].
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [9].
;;
(define (grsp-grav-earth-lat p_l1)
  (let ((res1 0))

    (set! res1 (- (gconst "g0")
		  (* (* 0.5 (- (gconst "gpoles")
			       (gconst "gequator")))
		     (cos (* (* 2 p_l1)
			     (/ (grsp-pi) 180))))))

    res1))


;;;; grsp-grav-earth-alt - Gravity on Earth as a function of altitude.
;;
;; Keywords:
;;
;; - astro, planet, earth. latitude, logitude, height, altitude
;;
;; Parameters:
;;
;; - p_z1: altitude.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-grav-earth-alt p_z1)
  (let ((res1 0))

    (set! res1 (* (gconst "g0")
		  (expt (/ (gconst "Re")
			   (+ (gconst "Re") p_z1))
			2)))
    
    res1))


;;;; grsp-grav-radius - Gravity on a body of radius p_pr1 and mass p_m1.
;;
;; Keywords:
;;
;; - astro, radius, diameter
;;
;; Parameters:
;;
;; - p_r1: radius.
;; - p_m1: mass within p_r1.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-grav-radius p_m1 p_r1)
  (let ((res1 0))

    (set! res1 (* -1 (/ (* (gconst "G") p_m1)
			(expt p_r1 2))))

    res1))


;;;; grsp-grav-ifor - International gravity formula.
;;
;; Keywords:
;;
;; - astro, gravity
;;
;; Parameters:
;;
;; - p_x1: latitude.
;; - p_x2: param A.
;; - p_x3: param B.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-grav-ifor p_x1 p_x2 p_x3)
  (let ((res1 0))

    (set! res1 (* (gconst "gequator")
		  (+ 1
		     (- (* p_x2 (expt (sin p_x1) 2))
			(* p_x3 (expt (sin (* 2 p_x1)) 2))))))

    res1))


;;;; grsp-grav-iforh - International gravity formula + height.
;;
;; Keywords:
;;
;; - astro, gravity
;;
;; Parameters:
;;
;; - p_x1: latitude.
;; - p_x2: param A.
;; - p_x3: param B.
;; - p_y1: altitude.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [15].
;;
(define (grsp-grav-iforh p_x1 p_x2 p_x3 p_y1)
  (let ((res1 0))

    (set! res1 (- (grsp-grav-ifor p_x1 p_x2 p_x3)
		  (* (* 3.086 (expt 10 -6)) p_y1)))

    res1))


;;;; grsp-grav-somigliana - Somigliana equation.
;;
;; Keywords:
;;
;; - astro
;;
;; Parameters:
;;
;; - p_x1: latitude.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [14].
;;
(define (grsp-grav-somigliana p_x1)
  (let ((res1 0)
	(x2 0)
	(y2 0)
	(n 0)
	(s 0)
	(e 0)
	(k 0))
	
    (set! x2 (gconst "requator"))
    (set! y2 (gconst "rpoles"))
    (set! n (* x2 (gconst "gequator")))
    (set! s (expt (sin p_x1) 2))
    (set! e (grsp-eccentricity-spheroid x2 y2))
    (set! k (/ (- (* y2 (gconst "gpoles")) n) n))
    (set! res1 (* (gconst "gequator")
		  (/ (+ 1 (* k s)) (sqrt (- 1 (* e s))))))
    
    res1))


;;;; grsp-grav-somigliana-mth - Multithreaded variant of
;; grsp-grav-somigliana.
;;
;; Keywords:
;;
;; - astro
;;
;; Parameters:
;;
;; - p_x1: latitude.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [14].
;;
(define (grsp-grav-somigliana-mth p_x1)
  (let ((res1 0)
	(x2 0)
	(y2 0)
	(n 0)
	(s 0)
	(e 0)
	(k 0))
	
    (set! x2 (gconst "requator"))
    (set! y2 (gconst "rpoles"))
    (set! n (* x2 (gconst "gequator")))
    
    (parallel (set! s (expt (sin p_x1) 2))
	      (set! e (grsp-eccentricity-spheroid x2 y2))
	      (set! k (/ (- (* y2 (gconst "gpoles")) n) n)))
    
    (set! res1 (* (gconst "gequator")
		  (/ (+ 1 (* k s)) (sqrt (- 1 (* e s))))))
    
    res1))

