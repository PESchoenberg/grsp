;; =============================================================================
;;
;; grsp1.scm
;;
;; Constants.
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


(define-module (grsp grsp1)
  #:export (gconst))
	    

;;;; gconst - Various constants.
;;
;; Arguments:
;; - p_n1: constant name, string.
;;
;; Sources:
;; - [1] En.wikipedia.org. (2020). List of mathematical constants. [online]
;;   Available at: https://en.wikipedia.org/wiki/List_of_mathematical_constants
;;   [Accessed 1 Jan. 2020].
;; - [2] Oeis.org. (2020). The On-Line Encyclopedia of Integer Sequences®
;;   (OEIS®). [online] Available at: https://oeis.org/ [Accessed 1 Jan. 2020].
;; - [3] En.wikipedia.org. (2020). Particular values of the Riemann zeta
;;   function. [online] Available at:
;;   https://en.wikipedia.org/wiki/Particular_values_of_the_Riemann_zeta_function
;;   [Accessed 1 Jan. 2020].
;; - [4] En.wikipedia.org. (2020). Names of large numbers. [online] Available 
;;   at: https://en.wikipedia.org/wiki/Names_of_large_numbers#The_googol_family
;;   [Accessed 1 Jan. 2020].
;; - [5] En.wikipedia.org. (2020). Power of 10. [online] Available at:
;;   https://en.wikipedia.org/wiki/Power_of_10 [Accessed 1 Jan. 2020].
;; - [6] En.wikipedia.org. (2020). Orders of magnitude (numbers). [online]
;;   Available at: https://en.wikipedia.org/wiki/Orders_of_magnitude_(numbers)
;;   [Accessed 6 Jan. 2020].
;; - [7] En.wikipedia.org. 2020. Parsec. [online] Available at:
;;   https://en.wikipedia.org/wiki/Parsec [Accessed 13 September 2020].
;; - [8] En.wikipedia.org. 2020. Astronomical Unit. [online] Available at:
;;   https://en.wikipedia.org/wiki/Astronomical_unit [Accessed 18 September
;;   2020].
;; - [9] En.wikipedia.org. 2020. Sidereal Time. [online] Available at:
;;   https://en.wikipedia.org/wiki/Sidereal_time [Accessed 20 September 2020].
;; - [10] En.wikipedia.org. 2020. Tropical Year. [online] Available at:
;;   https://en.wikipedia.org/wiki/Tropical_year [Accessed 24 September 2020].
;; - [11] En.wikipedia.org. 2021. Solar time. [online] Available at:
;;   https://en.wikipedia.org/wiki/Solar_time#Mean_solar_time
;;   [Accessed 13 February 2021].
;; - [12] En.wikipedia.org. 2021. List of gravitationally rounded objects of
;;   the Solar System. [online] Available at:
;;   https://en.wikipedia.org/wiki/List_of_gravitationally_rounded_objects_of_the_Solar_System
;;   [Accessed 13 February 2021].
;; - [13] En.wikipedia.org. 2020. Energy Density. [online] Available at:
;;   https://en.wikipedia.org/wiki/Energy_density [Accessed 30 September 2020].
;; - [14] En.wikipedia.org. 2020. Standard Gravity. [online] Available at:
;;   https://en.wikipedia.org/wiki/Standard_gravity [Accessed 30 September
;;   2020].
;; - [15] En.wikipedia.org. 2021. Gravitational acceleration. [online]
;;   Available at: <https://en.wikipedia.org/wiki/Gravitational_acceleration
;;   [Accessed 13 February 2021].
;; - [16] En.wikipedia.org. 2021. Earth radius. [online] Available at:
;;   https://en.wikipedia.org/wiki/Earth_radius [Accessed 13 February 2021].
;; - [17] See grsp6 [14].
;; - [18] En.wikipedia.org. 2020. Earth. [online] Available at:
;;   https://en.wikipedia.org/wiki/Earth [Accessed 14 October 2020].
;; - [19] En.wikipedia.org. 2020. Figure Of The Earth. [online] Available at:
;;   https://en.wikipedia.org/wiki/Figure_of_the_Earth
;;   [Accessed 15 October 2020].
;; - [20] En.wikipedia.org. 2020. Spherical Earth. [online] Available at:
;;   https://en.wikipedia.org/wiki/Spherical_Earth [Accessed 17 October 2020].
;; - [21] En.wikipedia.org. 2020. Meridian Arc. [online] Available at:
;;   https://en.wikipedia.org/wiki/Meridian_arc [Accessed 17 October 2020].
;; - [22] En.wikipedia.org. 2020. Earth Radius. [online] Available at:
;;   https://en.wikipedia.org/wiki/Earth_radius#Meridional
;;   [Accessed 18 October 2020].
;; - [23] En.wikipedia.org. 2020. Earth Mass. [online] Available at:
;;   https://en.wikipedia.org/wiki/Earth_mass [Accessed 27 October 2020].
;; - [24] En.wikipedia.org. 2020. Solar Mass. [online] Available at:
;;   https://en.wikipedia.org/wiki/Solar_mass [Accessed 29 October 2020].
;; - [25] En.wikipedia.org. 2020. List Of Most Massive Stars. [online] Available
;;   at: https://en.wikipedia.org/wiki/List_of_most_massive_stars
;;   [Accessed 31 October 2020].
;; - [26] En.wikipedia.org. 2020. List Of Most Massive Black Holes. [online]
;;   Available at: https://en.wikipedia.org/wiki/List_of_most_massive_black_holes
;;   [Accessed 2 November 2020].
;; - [27] En.wikipedia.org. 2020. Manifold. [online] Available at:
;;   https://en.wikipedia.org/wiki/Manifold [Accessed 2 November 2020].
;; - [28] En.wikipedia.org. 2020. Riemannian Manifold. [online] Available at:
;;   https://en.wikipedia.org/wiki/Riemannian_manifold#Riemannian_metrics
;;   [Accessed 3 November 2020].
;; - [29] En.wikipedia.org. 2020. List Of Manifolds. [online] Available at:
;;   https://en.wikipedia.org/wiki/List_of_manifolds
;;   [Accessed 3 November 2020].
;; - [30] En.wikipedia.org. 2020. Fine-Structure Constant. [online] Available
;;   at: https://en.wikipedia.org/wiki/Fine-structure_constant
;;   [Accessed 4 November 2020].


;;;; gconst - Constants.
;;
;; Keywords:
;; - constants.
;;
;; Arguments:
;; - p_n1: constant identifier.
;;
(define (gconst p_n1)
  (let ((res 0))

    (cond ((equal? p_n1 "gr")
	   (set! res 1.00))

	  ;; -------------------------------------------------------------------
	  ;; Math

	  ;; NaN, Not a Number, as per GNU Guile specs.
	  ((equal? p_n1 "NaN")
	   (set! res +nan.0))
	  
	  ;; Googol [1][4].
	  ((equal? p_n1 "Googol")
	   (set! res (expt 10 100)))

	  ;; One Googolth [1][4].
	  ((equal? p_n1 "Googol")
	   (set! res (expt 10 -100)))
	  
	  ;; Life, the universe and everything ;) 
	  ((equal? p_n1 "The answer")
	   (set! res 42))

	  ;; Rubik 3x3 cube, possible permutations [1].
	  ((equal? p_n1 "Rubik3x3x3")
	   (set! res 43252003274489856000))

	  ;; Rubik 5x5x5 cube, possible permutations [1].
	  ((equal? p_n1 "Rubik5x5x5")
	   (set! res (* 2.83 (expt 10 74))))

	  ;; Rubik 6x6x6 cube, possible permutations  [1].
	  ((equal? p_n1 "Rubik6x6x6")
	   (set! res (* 1.57 (expt 10 116))))

	  ;; Rubik 7x7x7 cube, possible permutations  [1].
	  ((equal? p_n1 "Rubik7x7x7")
	   (set! res (* 1.95 (expt 10 160))))

	  ;; Rubik 33x33x33 cube, possible permutations  [1].
	  ((equal? p_n1 "Rubik33x33x33")
	   (set! res (* 1.896 (expt 10 4099))))

	  ;; Borges' Library of Babel lower estimate of books  [1].
	  ((equal? p_n1 "LibraryBabel")
	   (set! res (* 1.956 (expt 10 1834097))))

	  ;; Linde-Vanchurin universes  [1].
	  ((equal? p_n1 "Linde-Vanchurin")
	   (set! res (expt 10 (expt 10 10000000))))
	  
	  ;; Atoms in the human body  [1].
	  ((equal? p_n1 "HumanAtoms")
	   (set! res (* 7 (expt 10 27))))

	  ;; Atoms on planet Earth  [1].
	  ((equal? p_n1 "EarthAtoms")
	   (set! res (* 1.33 (expt 10 50))))

	  ;; Alexander's star possible positions  [1].
	  ((equal? p_n1 "AlexanderStar")
	   (set! res (* 7.24 (expt 10 34))))
	  
	  ;; Estimated bacterial cells on Earth  [1].
	  ((equal? p_n1 "BacteriesEarth")
	   (set! res (* 5 (expt 10 30))))

	  ;; Shannon chess complexity number [1]..
	  ((equal? p_n1 "Shannon")
	   (set! res (expt 10 120)))

	  ;; Xiangqi complexity number [1].
	  ((equal? p_n1 "Xiangqi")
	   (set! res (expt 10 150)))

	  ;; Asamkhyeya 1 [1].
	  ((equal? p_n1 "Asamkhyeya1")
	   (set! res (expt 10 140)))

	  ;; Asamkhyeya 2 [1].
	  ((equal? p_n1 "Asamkhyeya2")
	   (set! res (expt 10 (* 5 (expt 2 103)))))

	  ;; Asamkhyeya 3 [1].
	  ((equal? p_n1 "Asamkhyeya2")
	   (set! res (expt 10 (* 7 (expt 2 103)))))  

          ;; Asamkhyeya 4 [1].
	  ((equal? p_n1 "Asamkhyeya4")
	   (set! res (expt 10 (* 10 (expt 2 104)))))  

	  ;; Grains of sand on Earth [1].
	  ((equal? p_n1 "EarthSand")
	   (set! res (expt 10 21)))

	  ;; Insects on Earth [1].
	  ((equal? p_n1 "EarthInsects")
	   (set! res (expt 10 19)))

	  ;; Human cells in the human body [1].
	  ((equal? p_n1 "HumanCellsHumanBody")
	   (set! res (expt 10 13)))

	  ;; Toatal cells in the human body [1].
	  ((equal? p_n1 "TotalCellsHumanBody")
	   (set! res (expt 10 14)))

	  ;; Bacterial cells in the human body [1].
	  ((equal? p_n1 "BacterialCellsHumanBody")
	   (set! res (expt 10 12)))

	  ;; Bacterial cells in the human mouth [1].
	  ((equal? p_n1 "BacterialCellsHumanMouth")
	   (set! res (expt 10 10)))
	  
	  ;; Neurons in the human brain [1].
	  ((equal? p_n1 "NeuronsHumanBrain")
	   (set! res (expt 10 11)))

	  ;; Connections of the human neuron [1].
	  ((equal? p_n1 "NeuronsHumanConnections")
	   (set! res 10000))
	  
	  ;; Stars in the Andromeda galaxy [1].
	  ((equal? p_n1 "StarsAndromeda")
	   (set! res (expt 10 12)))

	  ;; Stars in the Milky Way galaxy [1].
	  ((equal? p_n1 "StarsMilkyWay")
	   (set! res (expt 10 11)))
	  
          ;; -------------------------------------------------------------------
	  
	  ;; Million [5][6].
	  ((equal? p_n1 "Million")
	   (set! res (expt 10 6)))

	  ;; Billion [5][6].
	  ((equal? p_n1 "Billion")
	   (set! res (expt 10 9)))

	  ;; Trillion [5][6].
	  ((equal? p_n1 "Trillion")
	   (set! res (expt 10 12)))

	  ;; Quadrillion [5][6].
	  ((equal? p_n1 "Quadrillion")
	   (set! res (expt 10 15)))

	  ;; Quintillion [5][6].
	  ((equal? p_n1 "Quintillion")
	   (set! res (expt 10 18)))

	  ;; Sextillion [5][6].
	  ((equal? p_n1 "Sextillion")
	   (set! res (expt 10 21)))

	  ;; Septillion [5][6].
	  ((equal? p_n1 "Septillion")
	   (set! res (expt 10 24)))

	  ;; Octillion [5][6].
	  ((equal? p_n1 "Octillion")
	   (set! res (expt 10 27)))

	  ;; Nonillion [5][6].
	  ((equal? p_n1 "Nonillion")
	   (set! res (expt 10 30)))

	  ;; Decillion [5][6].
	  ((equal? p_n1 "Decillion")
	   (set! res (expt 10 33)))

          ;; -------------------------------------------------------------------
	  
	  ;; Million [5][6].
	  ((equal? p_n1 "Mega")
	   (set! res (expt 10 6)))

	  ;; Billion [5][6].
	  ((equal? p_n1 "Giga")
	   (set! res (expt 10 9)))

	  ;; Trillion [5][6].
	  ((equal? p_n1 "Tera")
	   (set! res (expt 10 12)))

	  ;; Quadrillion [5][6].
	  ((equal? p_n1 "Peta")
	   (set! res (expt 10 15)))

	  ;; Quintillion [5][6].
	  ((equal? p_n1 "Exa")
	   (set! res (expt 10 18)))

	  ;; Sextillion [5][6].
	  ((equal? p_n1 "Zetta")
	   (set! res (expt 10 21)))

	  ;; Septillion [5][6].
	  ((equal? p_n1 "Yotta")
	   (set! res (expt 10 24)))

          ;; -------------------------------------------------------------------
	  
	  ;; Millionth [5][6].
	  ((equal? p_n1 "Millionth")
	   (set! res (expt 10 -6)))

	  ;; Billionth [5][6].
	  ((equal? p_n1 "Billionth")
	   (set! res (expt 10 -9)))

	  ;; Trillionth [5][6].
	  ((equal? p_n1 "Trillionth")
	   (set! res (expt 10 -12)))

	  ;; Quadrillionth [5][6].
	  ((equal? p_n1 "Quadrillionth")
	   (set! res (expt 10 -15)))

	  ;; Quintillionth [5][6].
	  ((equal? p_n1 "Quintillionth")
	   (set! res (expt 10 -18)))

	  ;; Sextillionth [5][6].
	  ((equal? p_n1 "Sextillionth")
	   (set! res (expt 10 -21)))

	  ;; Septillionth [5][6].
	  ((equal? p_n1 "Septillionth")
	   (set! res (expt 10 -24)))

	  ;; Octillionth [5][6].
	  ((equal? p_n1 "Octillionth")
	   (set! res (expt 10 -27)))

	  ;; Nonillionth [5][6].
	  ((equal? p_n1 "Nonillionth")
	   (set! res (expt 10 -30)))

	  ;; Decillionth [5][6].
	  ((equal? p_n1 "Decillionth")
	   (set! res (expt 10 -33)))

          ;; -------------------------------------------------------------------
	  
	  ;; Micro [5][6].
	  ((equal? p_n1 "Micro")
	   (set! res (expt 10 -6)))

	  ;; Nano [5][6].
	  ((equal? p_n1 "Nano")
	   (set! res (expt 10 -9)))

	  ;; Pico [5][6].
	  ((equal? p_n1 "Pico")
	   (set! res (expt 10 -12)))

	  ;; Femto [5][6].
	  ((equal? p_n1 "Femto")
	   (set! res (expt 10 -15)))

	  ;; Atto [5][6].
	  ((equal? p_n1 "Atto")
	   (set! res (expt 10 -18)))

	  ;; Septo [5][6].
	  ((equal? p_n1 "Septo")
	   (set! res (expt 10 -21)))

	  ;; Yocto [5][6].
	  ((equal? p_n1 "Yocto")
	   (set! res (expt 10 -24)))
	  
          ;; -------------------------------------------------------------------
	  
	  ;; ISQ - Kibi [5][6].
	  ((equal? p_n1 "Kibi")
	   (set! res (expt 1024 1)))

	  ;; ISQ - Mebi [5][6].
	  ((equal? p_n1 "Mebi")
	   (set! res (expt 1024 2)))

	  ;; ISQ - Gibi [5][6].
	  ((equal? p_n1 "Gibi")
	   (set! res (expt 1024 3)))

	  ;; ISQ - Tebi [5][6].
	  ((equal? p_n1 "Tebi")
	   (set! res (expt 1024 4)))

	  ;; ISQ - Pebi [5][6].
	  ((equal? p_n1 "Pebi")
	   (set! res (expt 1024 5)))

	  ;; ISQ - Exbi [5][6].
	  ((equal? p_n1 "Exbi")
	   (set! res (expt 1024 6)))

	  ;; ISQ - Zebi [5][6].
	  ((equal? p_n1 "Zebi")
	   (set! res (expt 1024 7)))

	  ;; ISQ - Yobi [5][6].
	  ((equal? p_n1 "Yobi")
	   (set! res (expt 1024 8)))	  

          ;; -------------------------------------------------------------------	  	  
	  
          ;; Archimedes' constant. Pi [1][2].
	  ((equal? p_n1 "A000796")
	   (set! res 3.14159265358979323846))

	  ;; Euler's number. e [1][2].
	  ((equal? p_n1 "A001113")
	   (set! res 2.71828182845904523536)) 

	  ;; Golden ratio. Phi [1][2].
	  ((equal? p_n1 "A001622")
	   (set! res 1.61803398874989484820))	  

	  ;; Wallis's constant. W [1][2].
	  ((equal? p_n1 "A007493")
	   (set! res 2.09455148154232659148))

	  ;; Sophomore's dream. I1 [1][2].
	  ((equal? p_n1 "A083648")
	   (set! res 0.78343051071213440705))

	  ;; Sophomore's dream. I2 [1][2].
	  ((equal? p_n1 "A073009")
	   (set! res 1.29128599706266354040))

	  ;; Euler-Mascheroni. Gamma [1][2].
	  ((equal? p_n1 "A001620")
	   (set! res 0.57721566490153286060))

	  ;; Erdos-Borwein. EB [1][2].
	  ((equal? p_n1 "A065442")
	   (set! res 1.60669515241529176378))	  

	  ;; Laplace limit. La [1][2].
	  ((equal? p_n1 "A033259")
	   (set! res 0.66274341934918158097))

	  ;; Gauss constant. G [1][2].
	  ((equal? p_n1 "A014549")
	   (set! res 0.83462684167407318628))

	  ;; Ramanujan-Soldner [1][2].
	  ((equal? p_n1 "A070769")
	   (set! res 1.45136923488338105028))

	  ;; Riemann Z(-2) [1][2][3].
	  ((equal? p_n1 "Z-2")
	   (set! res 0))
	  
	  ;; Riemann Z(3), Apery's constant [1][2][3].
	  ((equal? p_n1 "A002117")
	   (set! res 1.20205690315959428539))

	  ;; Riemann. Z(2) [1][2][3].
	  ((equal? p_n1 "A013661")
	   (set! res 1.64493406684822643647))

	  ;; Riemann Z(0.5) [1][2][3].
	  ((equal? p_n1 "A059750")
	   (set! res -1.4603545088095868128)) 
	  
	  ;; Riemann Z(0) [1][2][3].
	  ((equal? p_n1 "Z0")
	   (set! res -1/2))  

	  ;; Riemann Z(-1) [1][2][3].
	  ((equal? p_n1 "Z-1")
	   (set! res -1/12))
 
	  ;; Riemann Z(-2) [1][2][3].
	  ((equal? p_n1 "Z-2")
	   (set! res 0))

	  ;; Riemann Z(+inf.0) [1][2][3].
	  ((equal? p_n1 "+inf.0")
	   (set! res 0))
	  
	  ;; Liouville's constant. Li [1][2].
	  ((equal? p_n1 "A012245")
	   (set! res 0.110001000000000000000001))
	  
	  ;; Hermite-Ramanujan constant. R [1][2].
	  ((equal? p_n1 "A060295")
	   (set! res 262537412640768743.999999999999250073))
	  
	  ;; Catalan's constant. C [1][2].
	  ((equal? p_n1 "A006752")
	   (set! res 0.91596559417721901505))

	  ;; Dottie number. d [1][2].
	  ((equal? p_n1 "A003957")
	   (set! res 0.73908513321516064165))
	  
	  ;; Meissel-Mertens constant. M [1][2].
	  ((equal? p_n1 "A077761")
	   (set! res 0.26149721284764278375))

	  ;; Brun's constant, twin primes. B2 [1][2].
	  ((equal? p_n1 "A065421")
	   (set! res 1.902160583104))	  

	  ;; Weierstrass constant. WS [1][2].
	  ((equal? p_n1 "A094692")
	   (set! res 0.47494937998792065033))

	  ;; Kasner number. R [1][2].
	  ((equal? p_n1 "A072449")
	   (set! res 1.75793275661800453270))

	  ;; Cahem's constant. E2 [1][2].
	  ((equal? p_n1 "A080130")
	   (set! res 0.64341054628833802618))

	  ;; Universal parabolic constant. P2 [1][2].
	  ((equal? p_n1 "A103710")
	   (set! res 2.29558714939263807403))
	  
	  ;; Golden angle. b [1][2].
	  ((equal? p_n1 "A131988")
	   (set! res 2.39996322972865332223))

	  ;; Sierpinski constant. K [1][2].
	  ((equal? p_n1 "A062089")
	   (set! res 2.58498175957925321706))

	  ;; Bernstein's constant. Beta [1][2].
	  ((equal? p_n1 "A073001")
	   (set! res 0.28016949902386913303))

	  ;; Twin primes constant. C2 [1][2].
	  ((equal? p_n1 "A005597")
	   (set! res 0.66016181584686957392))

	  ;; Golomb-Dickman constant. Lambda [1][2].
	  ((equal? p_n1 "A084945")
	   (set! res 0.62432998854355087099))	  

	  ;; Feller-Tornier constant. CFT [1][2].
	  ((equal? p_n1 "A065493")
	   (set! res 0.66131704946962233528))
	  
	  ;; Champerowne constant. C10 [1][2].
	  ((equal? p_n1 "A033307")
	   (set! res 0.12345678910111213141))	  

	  ;; Calabi triangle constant. CCR [1][2].
	  ((equal? p_n1 "A046095")
	   (set! res 1.55138752454832039226))	  

	  ;; Euler-Gompertz constant. G [1].
	  ((equal? p_n1 "A073003")
	   (set! res 0.59634736232319407434))
	  
	  ;; Lieb's square ice constant. W2D [1][2].
	  ((equal? p_n1 "A118273")
	   (set! res 1.53960071783900203869))

	  ;; Feigenbaum constant 1. Fe1 [1][2].
	  ((equal? p_n1 "A006890")
	   (set! res 4.66920160910299067185))	  

	  ;; Feigembaum constant 2. Fe2 [1][2].
	  ((equal? p_n1 "A006891")
	   (set! res 2.502907875095892822283902873218))
	  
	  ;; Fransen-Robinson constant. F [1][2].
	  ((equal? p_n1 "A058655")
	   (set! res 2.80777024202851936522))

	  ;; Robbins constant. Delta3 [1][2].
          ((equal? p_n1 "A073012")
	   (set! res 0.66170718226717623515))

	  ;; Prevost constant. Psi [1][2].
	  ((equal? p_n1 "A079586")
	   (set! res 3.35988566624317755317))

	  ;; Vardi constant. Vc [1][2].
	  ((equal? p_n1 "A076393")
	   (set! res 1.26408473530530111307))	  

	  ;; Flajolet-Richmond constant. Q [1][2].
	  ((equal? p_n1 "A048651")
	   (set! res 0.28878809508660242127))

	  ;; Murata constant. Cm [1][2].
	  ((equal? p_n1 "A065485")
	   (set! res 2.82641999706759157554))	  

	  ;; Viswanath constant. CVi [1][2].
	  ((equal? p_n1 "A078416")
	   (set! res 1.1319882487943))

	  ;; Time constant. Tau [1][2].
	  ((equal? p_n1 "A068996")
	   (set! res 0.63212055882855767840))	  

	  ;; Komornik-Loretti constant. q [1][2].
	  ((equal? p_n1 "A055060")
	   (set! res 1.78723165018296593301))

	  ;; Khinchin harmonic mean. K-1 [1][2].
	  ((equal? p_n1 "A087491")
	   (set! res 1.74540566240734686349))	  

	  ;; Regular paper folding constant. Pf [1][2].
	  ((equal? p_n1 "A143347")
	   (set! res 0.85073618820186726036))

	  ;; Artin's constant. CArtin [1][2].
	  ((equal? p_n1 "A005596")
	   (set! res 0.37395581361920228805))	  

	  ;; MRB constant [1][2].
	  ((equal? p_n1 "A037077")
	   (set! res 0.18785964246206712024))

	  ;; Hall-Montgomery constant [1][2].
	  ((equal? p_n1 "A143301")
	   (set! res 0.17150049314153606586))

	  ;; Dimer 2D constant [1][2].
	  ((equal? p_n1 "A143233")
	   (set! res 0.29156090403081878013))

	  ;; Somos' qr constant [1][2].
	  ((equal? p_n1 "A065481")
	   (set! res 1.66168794963359412129))

	  ;; Steiner iterated exponent constant [1][2].
	  ((equal? p_n1 "A073229")
	   (set! res 1.44466786100976613365))

	  ;; Gauss Lemniscate constant [1][2].
	  ((equal? p_n1 "A093341")
	   (set! res 1.85407467730137191843))	  

	  ;; Prouhet–Thue–Morse constant [1][2].
	  ((equal? p_n1 "A014571")
	   (set! res 0.41245403364010759778))

	  ;; Heath-Brown-Moroz constant [1][2].
	  ((equal? p_n1 "A118228")
	   (set! res 0.00131764115485317810))

	  ;; Magic angle (radians) [1][2].
          ((equal? p_n1 "A195696")
	   (set! res 0.955316618124509278163))

	  ;; Polya random walk P(3) constant [1][2].
	  ((equal? p_n1 "A086230")
	   (set! res 0.34053732955099914282))

	  ;; Landau-Ramanujan constant [1][2].
          ((equal? p_n1 "A064533")
	   (set! res 0.76422365358922066299))

	  ;; Gieseking constant [1][2].
	  ((equal? p_n1 "A143298")
	   (set! res 1.01494160640965362502))

	  ;; Fractal dimension of the Cantor set [1][2].
          ((equal? p_n1 "A102525")
	   (set! res 0.63092975357145743709))

	  ;; Connective constant [1][2].
	  ((equal? p_n1 "A179260")
	   (set! res 1.84775906502257351225))

	  ;; Bronze ratio [1][2].
	  ((equal? p_n1 "A098316")
	   (set! res 3.30277563773199464655))

	  ;; Tetranacci constant [1][2].
	  ((equal? p_n1 "A086088")
	   (set! res 1.92756197548292530426))

	  ;; Module of infinite tetration of i [1][2].
	  ((equal? p_n1 "A212479")
	   (set! res 0.56755516330695782538))

	  ;; Goh-Schmutz constant [1][2].
	  ((equal? p_n1 "A143300")
	   (set! res 1.11786415118994497314))	  
	  
	  ;; Sarnak constant [1][2].
	  ((equal? p_n1 "A065476")
	   (set! res 0.72364840229820000940))
	  
	  ;; Paris constant [1][2].
	  ((equal? p_n1 "A105415")
	   (set! res 1.09864196439415648573))
	  
	  ;; First Trott constant [1][2].
	  ((equal? p_n1 "A039662")
	   (set! res 0.10841015122311136151))
	  
	  ;; Second Trott constant [1][2].
	  ((equal? p_n1 "A091694")
	   (set! res 0.27394419573927161717))
	  
	  ;; Third Trott constant [1][2].
	  ((equal? p_n1 "A113307")
	   (set! res 0.48267728193918159949))
	  
	  ;; Median of the Gumbel distribution [1][2].
	  ((equal? p_n1 "A074785")
	   (set! res 0.36651292058166432701))	       
	  
 	  	  	  	  	  	  
	  ;; -------------------------------------------------------------------
	  ;; Physics

          ;; Fine structure constant [30].
	  ((equal? p_n1 "Alpha")
	   (set! res 0.0072973525713))
	  
          ;; Light speed. m/s [7][8].
	  ((equal? p_n1 "c")
	   (set! res 299792458))

	  ;; Astronomical unit, m [7][8].
	  ((equal? p_n1 "AU")
	   (set! res 149597870700))

	  ;; Parsec, m [7][8].
	  ((equal? p_n1 "PC")
	   (set! res (* 206264.806247096 (gconst "AU"))))

	  ;; Light year, m. [7][8].
	  ((equal? p_n1 "LY")
	   (set! res (* (* (gconst "c") (gconst "ED")) (gconst "JY"))))

	  ;; Julian year, ephemeris days [7][8].
	  ((equal? p_n1 "JY")
	   (set! res 365.25))	   

	  ;; Tropical year, ephemeris days (2000) [10].
	  ((equal? p_n1 "TY")
	   (set! res 365.24219))	  

	  ;; Ephemeris day, s.
	  ((equal? p_n1 "ED")
	   (set! res 86400))	  

	  ;; Mean solar day, s [11]
	  ((equal? p_n1 "MSD")
	   (set! res 86400.002))	  

	  ;; Sidereal day, s [9].
	  ((equal? p_n1 "SID")
	   (set! res 86164.0905))

	  ;; Stellar day, s [9].
	  ((equal? p_n1 "STD")
	   (set! res 86164.098903691))
	  
	  ;; Spat, m. (Astronomy).
	  ((equal? p_n1 "S")
	   (set! res (* 1.0 (expt 10 12))))
	  
          ;; Gravitational constant. (N * ( m ** 2)) /(kg ** 2).
	  ((equal? p_n1 "G")
	   (set! res (* 6.674 (expt 10 -11))))

          ;; Standard gravity, m/s**2 [14].
	  ((equal? p_n1 "g0")
	   (set! res 9.80665))

          ;; Gravity at equator, m/s**2 [14][15][17].
	  ((equal? p_n1 "gequator")
	   (set! res 9.7803253359))

          ;; Gravity at poles, m/s**2 [14][15][17].
	  ((equal? p_n1 "gpoles")
	   (set! res 9.8321849378))	  

          ;; Earth, radius, mean (m) [18].
	  ((equal? p_n1 "rmean")
	   (set! res 6371000))

          ;; Earth, radius, equatorial (m) [18].
	  ((equal? p_n1 "requator")
	   (set! res 6378100))	  

          ;; Earth, radius, polar (m) [18].
	  ((equal? p_n1 "rpoles")
	   (set! res 6356800))	  
	  
          ;; Earth, oblateness [19].
	  ((equal? p_n1 "Earth oblateness")
	   (set! res (/ 1 298.257223563)))	

	  ;; Planck's constant. (2019) (kg * (m ** 2) * (s ** -1)).
	  ((equal? p_n1 "ht")
	   (set! res (* 6.62607015 (expt 10 -34))))

          ;; Coulomb's constant. (N * (m ** 2) / (c ** 2)).
	  ((equal? p_n1 "ke")
	   (set! res (* 8.9875517873681764 (expt 10 9))))

          ;; Boltzmann's constant. ((m ** 2) * kg * (s ** -2) * (K ** -1)).
	  ((equal? p_n1 "h")
	   (set! res (* 1.38064852 (expt 10 -23))))

          ;; Planck's length. (m).
	  ((equal? p_n1 "lp")
	   (set! res (* 1.616255 (expt 10 -35))))	  

          ;; Planck's time. (s).
	  ((equal? p_n1 "tp")
	   (set! res (* 5.39124 (expt 10 -44))))

          ;; Planck's mass. (kg).
	  ((equal? p_n1 "mp")
	   (set! res (* 2.17644 (expt 10 -8))))

          ;; Planck's charge. (C).
	  ((equal? p_n1 "qp")
	   (set! res (* 1.875545870 (expt 10 -18))))

          ;; Planck's temperature. (K).
	  ((equal? p_n1 "tp")
	   (set! res (* 1.416785 (expt 10 32))))
	  
          ;; Avogadro. (entities).
	  ((equal? p_n1 "Na")
	   (set! res (* 6.02214076 (expt 10 23))))

          ;; Elementary positive charge. (C).
	  ((equal? p_n1 "qe")
	   (set! res (* 1.602176634 (expt 10 -19))))

          ;; Electron rest mass. (kg).
	  ((equal? p_n1 "me")
	   (set! res (* 9.1093837015 (expt 10 -31))))

          ;; Proton mass. (kg).
	  ((equal? p_n1 "mpr")
	   (set! res (* 1.67262192369 (expt 10 -27))))
	  
          ;; Vacuum permittivity. (F * (m ** -1)).
	  ((equal? p_n1 "e0")
	   (set! res (* 8.8541878128 (expt 10 -12))))	  

          ;; Eddington-Dirac number.
	  ((equal? p_n1 "Eddington-Dirac")
	   (set! res (expt 10 40)))

          ;; Chronon. (s) (Caldirola, 1980).
	  ((equal? p_n1 "ch")
	   (set! res (* 6.27 (expt 10 -24))))

          ;; Distance from the Sun to Proxima Centauri (AU) (+/- 126) [8][9].
	  ((equal? p_n1 "AU Proxima Centauri")
	   (set! res 268000))

          ;; Mean distance from the Sun to Mercury (AU) [8][9].
	  ((equal? p_n1 "AU Mercury")
	   (set! res 0.38709893))

          ;; Mean distance from the Sun to Venus (AU) [8][9][12].	  
	  ((equal? p_n1 "AU Venus")
	   (set! res 0.72333199))	  

          ;; Mean distance from the Sun to Earth (AU) [8][9][12].	  
	  ((equal? p_n1 "1.00000011")
	   (set! res 1.00))

          ;; Mean distance from the Sun to Mars (AU) [8][9][12]. 
	  ((equal? p_n1 "AU Mars")
	   (set! res 1.52366231))

          ;; Mean distance from the Sun to Jupiter (AU) [8][9][12].
	  ((equal? p_n1 "AU Jupiter")
	   (set! res 5.20336301))

          ;; Mean distance from the Sun to Saturn (AU) [8][9][12].
	  ((equal? p_n1 "AU Saturn")
	   (set! res 9.53707032))

          ;; Mean distance from the Sun to Uranus (AU) [8][9][12].
	  ((equal? p_n1 "AU Uranus")
	   (set! res 19.19126393))

          ;; Mean distance from the Sun to Neptune (AU) [8][9][12].
	  ((equal? p_n1 "AU Neptune")
	   (set! res 30.06896348))	  

          ;; Mean distance from the Sun to Ceres (AU) [8][9][12].
	  ((equal? p_n1 "AU Ceres")
	   (set! res 2.766))

          ;; Mean distance from the Sun to Pluto (AU) [8][9][12].
	  ((equal? p_n1 "AU Pluto")
	   (set! res 39.482))

          ;; Mean distance from the Sun to Haumea (AU) [8][9][12].
	  ((equal? p_n1 "AU Haumea")
	   (set! res 43.335))

          ;; Mean distance from the Sun to Makemake (AU) [8][9][12].	  
	  ((equal? p_n1 "AU Makemake")
	   (set! res 45.792))

          ;; Mean distance from the Sun to Eris (AU) [8][9][12].
	  ((equal? p_n1 "AU Eris")
	   (set! res 67.668))

          ;; Mean distance from the Sun to Orcus [8][9][12].
	  ((equal? p_n1 "AU Orcus")
	   (set! res 39.419))	  

          ;; Mean distance from the Sun to Salacia (AU) [8][9][12].
	  ((equal? p_n1 "AU Salacia")
	   (set! res 42.18))

          ;; Mean distance from the Sun to Quaoar (AU) [8][9][12].
	  ((equal? p_n1 "AU Quaoar")
	   (set! res 43.69))

          ;; Mean distance from the Sun to Gonggong (AU) [8][9][12].
	  ((equal? p_n1 "AU Gonggong")
	   (set! res 67.33))

          ;; Mean distance from the Sun to Sedna (AU) [8][9][12].
	  ((equal? p_n1 "AU Sedna")
	   (set! res 525.86))

          ;; Mean distance from the Sun to the inner limit of the Kuiper belt
	  ;; (AU) [8][9].
	  ((equal? p_n1 "Inner Kuiper belt")
	   (set! res 30.00))

          ;; Distance (est) from the Sun to the outer limit of the Oort cloud
	  ;; (AU) [8][9].
	  ((equal? p_n1 "Outer Oort cloud")
	   (set! res 75000))

          ;; Distance (est) from the Sun to the galactic center (AU) [8][9].
	  ((equal? p_n1 "Milky Way center")
	   (set! res 1700000000))

	  ;; Specific energy (W * h / kg). Antimatter [13].
	  ((equal? p_n1 "Specific energy of antimatter")
	   (set! res 24965421631578))

	  ;; Specific energy (W * h / kg). Natural gas [13].
	  ((equal? p_n1 "Specific energy of natural gas")
	   (set! res 14888.9))

	  ;; Specific energy (W * h / kg). Uranium [13].
	  ((equal? p_n1 "Specific energy of uranium")
	   (set! res 22394000000))

	  ;; Specific energy (W * h / kg). Deuterium [13].
	  ((equal? p_n1 "Specific energy of deuterium")
	   (set! res 158661876600))

	  ;; Specific energy (W * h / kg). Hidrogen fusion [13].
	  ((equal? p_n1 "Specific energy of hidrogen fusion")
	   (set! res 177716755600))

	  ;; Mean radius, Earth (m) [16].
	  ((equal? p_n1 "RE")
	   (set! res (* 6.3781 (expt 10 6))))
	  
	  ;; Mass, Earth (kg) [23].
	  ((equal? p_n1 "Mass Earth")
	   (set! res (* 5.9742 (expt 10 24))))

	  ;; Mass, Sun (Earth masses) [23].
	  ((equal? p_n1 "Mass Sun")
	   (set! res 332946.0487))
	  
	  ;; Mass, Nercury (Earth masses) [23].
	  ((equal? p_n1 "Mass Mercury")
	   (set! res 0.0553))

	  ;; Mass, Venus (Earth masses) [23].
	  ((equal? p_n1 "Mass Venus")
	   (set! res 0.815))	  

	  ;; Mass, Mars (Earth masses) [23].
	  ((equal? p_n1 "Mass Mars")
	   (set! res 0.107))

	  ;; Mass, Jupiter (Earth masses) [23].
	  ((equal? p_n1 "Mass Jupiter")
	   (set! res 317.8))

	  ;; Mass, Saturn (Earth masses) [23].
	  ((equal? p_n1 "Mass Saturn")
	   (set! res 95.2))

	  ;; Mass, Uranus (Earth masses) [23].
	  ((equal? p_n1 "Mass Uranus")
	   (set! res 14.5))

	  ;; Mass, Neptune (Earth masses) [23].
	  ((equal? p_n1 "Mass Neptune")
	   (set! res 17.1))

	  ;; Mass, Pluto (Earth masses) [23].
	  ((equal? p_n1 "Mass Pluto")
	   (set! res 0.0025))

	  ;; Mass, Moon (Earth masses) [23].
	  ((equal? p_n1 "Mass Moon")
	   (set! res 0.0123000371))

	  ;; Mass loss rate of the Sun at present stage (Earth masses) [24].
	  ((equal? p_n1 "Mass loss rate Sun G2V")
	   (set! res (* (gconst "Mass Sun") 2.5 (expt 10 -14))))

	  ;; Mass WR124 (Solar masses) [25].
	  ((equal? p_n1 "Mass WR124")
	   (set! res 33.0))

	  ;; Mass R136a1 (Solar masses) [25].
	  ((equal? p_n1 "Mass R136a1")
	   (set! res 215.0))

	  ;; Mass TON618 (Solar masses) [26].
	  ((equal? p_n1 "Mass TON618")
	   (set! res (* 6.6 (expt 10 10))))

	  ;; Mass Powehi (Solar masses) [26].
	  ((equal? p_n1 "Mass Powehi")
	   (set! res (* 7.22 (expt 10 9))))

	  ;; Mass Sagittarius A* (Solar masses) [26].
	  ((equal? p_n1 "Mass Sagittarius A*")
	   (set! res (* 4.3 (expt 10 6))))
	  
	  (else (set! res 0)))

    res))

