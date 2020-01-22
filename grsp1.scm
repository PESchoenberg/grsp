; ==============================================================================
;
; grsp1.scm
;
; Constants.
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


(define-module (grsp grsp1)
  #:export (gconst))
	    

; gconst - Various constants.
;
; Arguments:
; - p_n1: constant name, string.
;
; Sources:
; - En.wikipedia.org. (2020). List of mathematical constants. [online] Available
;   at: https://en.wikipedia.org/wiki/List_of_mathematical_constants
;   [Accessed 1 Jan. 2020].
; - Oeis.org. (2020). The On-Line Encyclopedia of Integer Sequences® (OEIS®).
;   [online] Available at: https://oeis.org/ [Accessed 1 Jan. 2020].
; - En.wikipedia.org. (2020). Particular values of the Riemann zeta function.
;   [online] Available at: https://en.wikipedia.org/wiki/Particular_values_of
;   _the_Riemann_zeta_function [Accessed 1 Jan. 2020].
; - En.wikipedia.org. (2020). Names of large numbers. [online] Available at:
;   https://en.wikipedia.org/wiki/Names_of_large_numbers#The_googol_family
;   [Accessed 1 Jan. 2020].
; - En.wikipedia.org. (2020). Power of 10. [online] Available at:
;   https://en.wikipedia.org/wiki/Power_of_10 [Accessed 1 Jan. 2020].
; - En.wikipedia.org. (2020). Orders of magnitude (numbers). [online] Available
;   at: https://en.wikipedia.org/wiki/Orders_of_magnitude_(numbers)
;   [Accessed 6 Jan. 2020].
;
(define (gconst p_n1)
  (let ((res 0))
    (cond ((equal? p_n1 "gr")(set! res 1.00))

	  ; --------------------------------------------------------------------
	  ; Math

	  ; Googol.
	  ((equal? p_n1 "Googol")(set! res (expt 10 100)))

	  ; One Googolth.
	  ((equal? p_n1 "Googol")(set! res (expt 10 -100)))
	  
	  ; Life, the universe and everything ;) 
	  ((equal? p_n1 "The answer")(set! res 42))

	  ; Rubik 3x3 cube, possible permutations.
	  ((equal? p_n1 "Rubik3x3x3")(set! res 43252003274489856000))

	  ; Rubik 5x5x5 cube, possible permutations.
	  ((equal? p_n1 "Rubik5x5x5")(set! res (* 2.83 (expt 10 74))))

	  ; Rubik 6x6x6 cube, possible permutations.
	  ((equal? p_n1 "Rubik6x6x6")(set! res (* 1.57 (expt 10 116))))

	  ; Rubik 7x7x7 cube, possible permutations.
	  ((equal? p_n1 "Rubik7x7x7")(set! res (* 1.95 (expt 10 160))))

	  ; Rubik 33x33x33 cube, possible permutations.
	  ((equal? p_n1 "Rubik33x33x33")(set! res (* 1.896 (expt 10 4099))))

	  ; Borges' Library of Babel lower estimate of books.
	  ((equal? p_n1 "LibraryBabel")(set! res (* 1.956 (expt 10 1834097))))

	  ; Linde-Vanchurin universes.
	  ((equal? p_n1 "Linde-Vanchurin")(set! res (expt 10 (expt 10 10000000))))
	  
	  ; Atoms in the human body.
	  ((equal? p_n1 "HumanAtoms")(set! res (* 7 (expt 10 27))))

	  ; Atoms on planet Earth.
	  ((equal? p_n1 "EarthAtoms")(set! res (* 1.33 (expt 10 50))))

	  ; Alexander's star possible positions.
	  ((equal? p_n1 "AlexanderStar")(set! res (* 7.24 (expt 10 34))))
	  
	  ; Estimated bacterial cells on Earth.
	  ((equal? p_n1 "BacteriesEarth")(set! res (* 5 (expt 10 30))))

	  ; Shannon chess complexity number.
	  ((equal? p_n1 "Shannon")(set! res (expt 10 120)))

	  ; Xiangqi complexity number.
	  ((equal? p_n1 "Xiangqi")(set! res (expt 10 150)))

	  ; Asamkhyeya 1.
	  ((equal? p_n1 "Asamkhyeya1")(set! res (expt 10 140)))

	  ; Asamkhyeya 2.
	  ((equal? p_n1 "Asamkhyeya2")(set! res (expt 10 (* 5 (expt 2 103)))))

	  ; Asamkhyeya 3.
	  ((equal? p_n1 "Asamkhyeya2")(set! res (expt 10 (* 7 (expt 2 103)))))  

          ; Asamkhyeya 4.
	  ((equal? p_n1 "Asamkhyeya4")(set! res (expt 10 (* 10 (expt 2 104)))))  

	  ; Grains of sand on Earth.
	  ((equal? p_n1 "EarthSand")(set! res (expt 10 21)))

	  ; Insects on Earth.
	  ((equal? p_n1 "EarthInsects")(set! res (expt 10 19)))

	  ; Human cells in the human body.
	  ((equal? p_n1 "HumanCellsHumanBody")(set! res (expt 10 13)))

	  ; Toatal cells in the human body.
	  ((equal? p_n1 "TotalCellsHumanBody")(set! res (expt 10 14)))

	  ; Bacterial cells in the human body.
	  ((equal? p_n1 "BacterialCellsHumanBody")(set! res (expt 10 12)))

	  ; Bacterial cells in the human mouth.
	  ((equal? p_n1 "BacterialCellsHumanMouth")(set! res (expt 10 10)))
	  
	  ; Neurons in the human brain.
	  ((equal? p_n1 "NeuronsHumanBrain")(set! res (expt 10 11)))

	  ; Connections of the human neuron.
	  ((equal? p_n1 "NeuronsHumanConnections")(set! res 10000))
	  
	  ; Stars in the Andromeda galaxy.
	  ((equal? p_n1 "StarsAndromeda")(set! res (expt 10 12)))

	  ; Stars in the Milky Way galaxy.
	  ((equal? p_n1 "StarsMilkyWay")(set! res (expt 10 11)))
	  
          ; --------------------------------------------------------------------
	  
	  ; Million.
	  ((equal? p_n1 "Million")(set! res (expt 10 6)))

	  ; Billion.
	  ((equal? p_n1 "Billion")(set! res (expt 10 9)))

	  ; Trillion.
	  ((equal? p_n1 "Trillion")(set! res (expt 10 12)))

	  ; Quadrillion.
	  ((equal? p_n1 "Quadrillion")(set! res (expt 10 15)))

	  ; Quintillion.
	  ((equal? p_n1 "Quintillion")(set! res (expt 10 18)))

	  ; Sextillion.
	  ((equal? p_n1 "Sextillion")(set! res (expt 10 21)))

	  ; Septillion.
	  ((equal? p_n1 "Septillion")(set! res (expt 10 24)))

	  ; Octillion.
	  ((equal? p_n1 "Octillion")(set! res (expt 10 27)))

	  ; Nonillion.
	  ((equal? p_n1 "Nonillion")(set! res (expt 10 30)))

	  ; Decillion.
	  ((equal? p_n1 "Decillion")(set! res (expt 10 33)))

          ; --------------------------------------------------------------------
	  
	  ; Million.
	  ((equal? p_n1 "Mega")(set! res (expt 10 6)))

	  ; Billion.
	  ((equal? p_n1 "Giga")(set! res (expt 10 9)))

	  ; Trillion.
	  ((equal? p_n1 "Tera")(set! res (expt 10 12)))

	  ; Quadrillion.
	  ((equal? p_n1 "Peta")(set! res (expt 10 15)))

	  ; Quintillion.
	  ((equal? p_n1 "Exa")(set! res (expt 10 18)))

	  ; Sextillion.
	  ((equal? p_n1 "Zetta")(set! res (expt 10 21)))

	  ; Septillion.
	  ((equal? p_n1 "Yotta")(set! res (expt 10 24)))

          ; --------------------------------------------------------------------
	  
	  ; Millionth.
	  ((equal? p_n1 "Millionth")(set! res (expt 10 -6)))

	  ; Billionth.
	  ((equal? p_n1 "Billionth")(set! res (expt 10 -9)))

	  ; Trillionth.
	  ((equal? p_n1 "Trillionth")(set! res (expt 10 -12)))

	  ; Quadrillionth.
	  ((equal? p_n1 "Quadrillionth")(set! res (expt 10 -15)))

	  ; Quintillionth.
	  ((equal? p_n1 "Quintillionth")(set! res (expt 10 -18)))

	  ; Sextillionth.
	  ((equal? p_n1 "Sextillionth")(set! res (expt 10 -21)))

	  ; Septillionth.
	  ((equal? p_n1 "Septillionth")(set! res (expt 10 -24)))

	  ; Octillionth.
	  ((equal? p_n1 "Octillionth")(set! res (expt 10 -27)))

	  ; Nonillionth.
	  ((equal? p_n1 "Nonillionth")(set! res (expt 10 -30)))

	  ; Decillionth.
	  ((equal? p_n1 "Decillionth")(set! res (expt 10 -33)))

          ; --------------------------------------------------------------------
	  
	  ; Micro.
	  ((equal? p_n1 "Micro")(set! res (expt 10 -6)))

	  ; Nano.
	  ((equal? p_n1 "Nano")(set! res (expt 10 -9)))

	  ; Pico.
	  ((equal? p_n1 "Pico")(set! res (expt 10 -12)))

	  ; Femto.
	  ((equal? p_n1 "Femto")(set! res (expt 10 -15)))

	  ; Atto.
	  ((equal? p_n1 "Atto")(set! res (expt 10 -18)))

	  ; Septo.
	  ((equal? p_n1 "Septo")(set! res (expt 10 -21)))

	  ; Yocto.
	  ((equal? p_n1 "Yocto")(set! res (expt 10 -24)))
	  
          ; --------------------------------------------------------------------
	  
	  ; ISQ - Kibi.
	  ((equal? p_n1 "Kibi")(set! res (expt 1024 1)))

	  ; ISQ - Mebi.
	  ((equal? p_n1 "Mebi")(set! res (expt 1024 2)))

	  ; ISQ - Gibi.
	  ((equal? p_n1 "Gibi")(set! res (expt 1024 3)))

	  ; ISQ - Tebi.
	  ((equal? p_n1 "Tebi")(set! res (expt 1024 4)))

	  ; ISQ - Pebi.
	  ((equal? p_n1 "Pebi")(set! res (expt 1024 5)))

	  ; ISQ - Exbi.
	  ((equal? p_n1 "Exbi")(set! res (expt 1024 6)))

	  ; ISQ - Zebi.
	  ((equal? p_n1 "Zebi")(set! res (expt 1024 7)))

	  ; ISQ - Yobi.
	  ((equal? p_n1 "Yobi")(set! res (expt 1024 8)))	  

          ; --------------------------------------------------------------------	  	  
	  
          ; Archimedes' constant. Pi.
	  ((equal? p_n1 "A000796")(set! res 3.14159265358979323846))

	  ; Euler's number. e.
	  ((equal? p_n1 "A001113")(set! res 2.71828182845904523536)) 

	  ; Golden ratio. Phi.
	  ((equal? p_n1 "A001622")(set! res 1.61803398874989484820))	  

	  ; Wallis's constant. W.
	  ((equal? p_n1 "A007493")(set! res 2.09455148154232659148))

	  ; Sophomore's dream. I1.
	  ((equal? p_n1 "A083648")(set! res 0.78343051071213440705))

	  ; Sophomore's dream. I2.
	  ((equal? p_n1 "A073009")(set! res 1.29128599706266354040))

	  ; Euler-Mascheroni. Gamma.
	  ((equal? p_n1 "A001620")(set! res 0.57721566490153286060))

	  ; Erdos-Borwein. EB.
	  ((equal? p_n1 "A065442")(set! res 1.60669515241529176378))	  

	  ; Laplace limit. La.
	  ((equal? p_n1 "A033259")(set! res 0.66274341934918158097))

	  ; Gauss constant. G.
	  ((equal? p_n1 "A014549")(set! res 0.83462684167407318628))

	  ; Ramanujan-Soldner.
	  ((equal? p_n1 "A070769")(set! res 1.45136923488338105028))

	  ; Riemann Z(3), Apery's constant.
	  ((equal? p_n1 "A002117")(set! res 1.20205690315959428539))

	  ; Riemann. Z(2).
	  ((equal? p_n1 "A013661")(set! res 1.64493406684822643647))
	  
	  ; Riemann Z(0).
	  ((equal? p_n1 "Z0")(set! res -1/2))  

	  ; Riemann Z(-1).
	  ((equal? p_n1 "Z-1")(set! res -1/12))
 
	  ; Riemann Z(-2).
	  ((equal? p_n1 "Z-2")(set! res 0))

	  ; Liouville's constant. Li.
	  ((equal? p_n1 "A012245")(set! res 0.110001000000000000000001))
	  
	  ; Hermite-Ramanujan constant. R.
	  ((equal? p_n1 "A060295")(set! res 262537412640768743.999999999999250073))
	  
	  ; Catalan's constant. C.
	  ((equal? p_n1 "A006752")(set! res 0.91596559417721901505))

	  ; Dottie number. d.
	  ((equal? p_n1 "A003957")(set! res 0.73908513321516064165))
	  
	  ; Meissel-Mertens constant. M.
	  ((equal? p_n1 "A077761")(set! res 0.26149721284764278375))

	  ; Brun's constant, twin primes. B2.
	  ((equal? p_n1 "A065421")(set! res 1.902160583104))	  

	  ; Weierstrass constant. WS.
	  ((equal? p_n1 "A094692")(set! res 0.47494937998792065033))

	  ; Kasner number. R.
	  ((equal? p_n1 "A072449")(set! res 1.75793275661800453270))

	  ; Cahem's constant. E2
	  ((equal? p_n1 "A080130")(set! res 0.64341054628833802618))

	  ; Universal parabolic constant. P2
	  ((equal? p_n1 "A103710")(set! res 2.29558714939263807403))
	  
	  ; Golden angle. b.
	  ((equal? p_n1 "A131988")(set! res 2.39996322972865332223))

	  ; Sierpinski constant. K.
	  ((equal? p_n1 "A062089")(set! res 2.58498175957925321706))

	  ; Bernstein's constant. Beta.
	  ((equal? p_n1 "A073001")(set! res 0.28016949902386913303))

	  ; Twin primes constant. C2.
	  ((equal? p_n1 "A005597")(set! res 0.66016181584686957392))

	  ; Golomb-Dickman constant. Lambda.
	  ((equal? p_n1 "A084945")(set! res 0.62432998854355087099))	  

	  ; Feller-Tornier constant. CFT.
	  ((equal? p_n1 "A065493")(set! res 0.66131704946962233528))
	  
	  ; Champerowne constant. C10.
	  ((equal? p_n1 "A033307")(set! res 0.12345678910111213141))	  

	  ; Calabi triangle constant.CCR.
	  ((equal? p_n1 "A046095")(set! res 1.55138752454832039226))	  

	  ; Euler-Gompertz constant. G.
	  ((equal? p_n1 "A073003")(set! res 0.59634736232319407434))
	  
	  ; Lieb's square ice constant. W2D.
	  ((equal? p_n1 "A118273")(set! res 1.53960071783900203869))

	  ; Feigenbaum constant 1. Fe1.
	  ((equal? p_n1 "A006890")(set! res 4.66920160910299067185))	  

	  ; Feigembaum constant 2. Fe2.
	  ((equal? p_n1 "A006891")(set! res 2.502907875095892822283902873218))
	  
	  ; Fransen-Robinson constant. F.
	  ((equal? p_n1 "A058655")(set! res 2.80777024202851936522))

	  ; Robbins constant. Delta3.
          ((equal? p_n1 "A073012")(set! res 0.66170718226717623515))

	  ; Prevost constant. Psi.
	  ((equal? p_n1 "A079586")(set! res 3.35988566624317755317))

	  ; Vardi constant. Vc.
	  ((equal? p_n1 "A076393")(set! res 1.26408473530530111307))	  

	  ; Flajolet-Richmond constant. Q.
	  ((equal? p_n1 "A048651")(set! res 0.28878809508660242127))

	  ; Murata constant. Cm.
	  ((equal? p_n1 "A065485")(set! res 2.82641999706759157554))	  

	  ; Viswanath constant. CVi.
	  ((equal? p_n1 "A078416")(set! res 1.1319882487943))

	  ; Time constant. Tau.
	  ((equal? p_n1 "A068996")(set! res 0.63212055882855767840))	  

	  ; Komornik-Loretti constant. q.
	  ((equal? p_n1 "A055060")(set! res 1.78723165018296593301))

	  ; Khinchin harmonic mean. K-1.
	  ((equal? p_n1 "A087491")(set! res 1.74540566240734686349))	  

	  ; Regular paper folding constant. Pf.
	  ((equal? p_n1 "A143347")(set! res 0.85073618820186726036))

	  ; Artin's constant. CArtin.
	  ((equal? p_n1 "A005596")(set! res 0.37395581361920228805))	  

	  ; MRB constant.
	  ((equal? p_n1 "A037077")(set! res 0.18785964246206712024))

	  ; Hall-Montgomery constant.
	  ((equal? p_n1 "A143301")(set! res 0.17150049314153606586))

	  ; Dimer 2D constant.
	  ((equal? p_n1 "A143233")(set! res 0.29156090403081878013))

	  ; Somos' qr constant.
	  ((equal? p_n1 "A065481")(set! res 1.66168794963359412129))

	  ; Steiner iterated exponent constant.
	  ((equal? p_n1 "A073229")(set! res 1.44466786100976613365))

	  ; Gauss Lemniscate constant.
	  ((equal? p_n1 "A093341")(set! res 1.85407467730137191843))	  

	  ; Prouhet–Thue–Morse constant.
	  ((equal? p_n1 "A014571")(set! res 0.41245403364010759778))

	  ; Heath-Brown-Moroz constant.
	  ((equal? p_n1 "A118228")(set! res 0.00131764115485317810))

	  ; Magic angle (radians).
          ((equal? p_n1 "A195696")(set! res 0.955316618124509278163))

	  ; Polya random walk P(3) constant.
	  ((equal? p_n1 "A086230")(set! res 0.34053732955099914282))

	  ; Landau-Ramanujan constant.
          ((equal? p_n1 "A064533")(set! res 0.76422365358922066299))

	  ; Gieseking constant.
	  ((equal? p_n1 "A143298")(set! res 1.01494160640965362502))

	  ; Fractal dimension of the Cantor set.
          ((equal? p_n1 "A102525")(set! res 0.63092975357145743709))

	  ; Connective constant.
	  ((equal? p_n1 "A179260")(set! res 1.84775906502257351225))

	  ; Bronze ratio.
	  ((equal? p_n1 "A098316")(set! res 3.30277563773199464655))

	  ; Tetranacci constant.
	  ((equal? p_n1 "A086088")(set! res 1.92756197548292530426))

	  ; Module of infinite tetration of i.
	  ((equal? p_n1 "A212479")(set! res 0.56755516330695782538))

	  ; Goh-Schmutz constant.
	  ((equal? p_n1 "A143300")(set! res 1.11786415118994497314))	  
	  
	  ; Sarnak constant.
	  ((equal? p_n1 "A065476")(set! res 0.72364840229820000940))
	  
	  ; Paris constant.
	  ((equal? p_n1 "A105415")(set! res 1.09864196439415648573))
	  
	  ; First Trott constant.
	  ((equal? p_n1 "A039662")(set! res 0.10841015122311136151))
	  
	  ; Second Trott constant.
	  ((equal? p_n1 "A091694")(set! res 0.27394419573927161717))
	  
	  ; Third Trott constant.
	  ((equal? p_n1 "A113307")(set! res 0.48267728193918159949))
	  
	  ; Median of the Gumbel distribution.
	  ((equal? p_n1 "A074785")(set! res 0.36651292058166432701))	       
	  
	  ; 's constant.
	  ;((equal? p_n1 "GC")(set! res ))

	  	  	  	  	  	  	  
	  ; --------------------------------------------------------------------
	  ; Physics
	  
          ; Light speed. m/s
	  ((equal? p_n1 "c")(set! res 299792458))

          ; Gravitational constant. (N * ( m ** 2)) /(kg ** 2)
	  ((equal? p_n1 "G")(set! res (* 6.674 (expt 10 -11))))

          ; Planck's constant. (2019) (kg * (m ** 2) * (s ** -1))
	  ((equal? p_n1 "ht")(set! res (* 6.62607015 (expt 10 -34))))

          ; Coulomb's constant. (N * (m ** 2) / (c ** 2))
	  ((equal? p_n1 "ke")(set! res (* 8.9875517873681764 (expt 10 9))))

          ; Boltzmann's constant. ((m ** 2) * kg * (s ** -2) * (K ** -1))
	  ((equal? p_n1 "h")(set! res (* 1.38064852 (expt 10 -23))))

          ; Planck's length. (m)
	  ((equal? p_n1 "lp")(set! res (* 1.616255 (expt 10 -35))))	  

          ; Planck's time. (s)
	  ((equal? p_n1 "tp")(set! res (* 5.39124 (expt 10 -44))))

          ; Planck's mass. (kg)
	  ((equal? p_n1 "mp")(set! res (* 2.17644 (expt 10 -8))))

          ; Planck's charge. (C)
	  ((equal? p_n1 "qp")(set! res (* 1.875545870 (expt 10 -18))))

          ; Planck's temperature. (K)
	  ((equal? p_n1 "tp")(set! res (* 1.416785 (expt 10 32))))
	  
          ; Avogadro. (entities)
	  ((equal? p_n1 "Na")(set! res (* 6.02214076 (expt 10 23))))

          ; Elementary positive charge. (C)
	  ((equal? p_n1 "qe")(set! res (* 1.602176634 (expt 10 -19))))

          ; Electron rest mass. (kg)
	  ((equal? p_n1 "me")(set! res (* 9.1093837015 (expt 10 -31))))

          ; Proton mass. (kg)
	  ((equal? p_n1 "mpr")(set! res (* 1.67262192369 (expt 10 -27))))
	  
          ; Vacuum permittivity. (F * (m ** -1))
	  ((equal? p_n1 "e0")(set! res (* 8.8541878128 (expt 10 -12))))	  

          ; Eddington-Dirac number.
	  ((equal? p_n1 "Eddington-Dirac")(set! res (expt 10 40)))
	  
	  (else (set! res 0)))
  res))


