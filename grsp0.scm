;; =============================================================================
;;
;; grsp0.scm
;;
;; A library of some useful, simple functions for GNU Guile Scheme programs 
;; created or adapted during the development of several other projects.
;;
;; =============================================================================
;;
;; Copyright (C) 2018 - 2023 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;;
;; - Read sources for limitations on function parameters.
;; - Read at least the general notes of all scm files in this library before
;;   use.
;;
;; - Compilation:
;;
;;   - (use-modules (grsp grsp0)(grsp grsp1)(grsp grsp2)(grsp grsp3)(grsp grsp4)(grsp grsp5)(grsp grsp6)(grsp grsp7)(grsp grsp8)(grsp grsp9)(grsp grsp10)(grsp grsp11)(grsp grsp12)(grsp grsp13)(grsp grsp14)(grsp grsp15)(grsp grsp16)(grsp grsp17))
;;
;; Sources:
;;
;; See code of functions used and their respective source files for more
;; credits and references.
;;
;; - [1] Shido.info. (2019). 9. IO. [online] Available at:
;;   http://www.shido.info/lisp/scheme9_e.html [Accessed 15 Sep. 2019].
;; - [2] Gnu.org. (2019). File Ports (Guile Reference Manual). [online]
;;   Available at:
;;   https://www.gnu.org/software/guile/manual/html_node/File-Ports.html
;;   [Accessed 15 Sep. 2019].
;; - [3] Edronkin, P. (2019). sqlp - Simple terminal query and .sql file
;;   processing for  Sqlite3. [online] sqlp. Available at:
;;   https://peschoenberg.github.io/sqlp/ [Accessed 5 Oct. 2019].
;; - [4] Gnu.org. 2021. Dynamic Types (Guile Reference Manual). [online]
;;   Available at:
;;   https://www.gnu.org/software/guile/manual/html_node/Dynamic-Types.html
;;   [Accessed 1 October 2021].
;; - [5] Gnu.org. 2021. Data Types (Guile Reference Manual). [online]
;;   Available at:
;;   https://www.gnu.org/software/guile/manual/html_node/Data-Types.html
;;   [Accessed 1 October 2021].
;; - [6] Academic.oup.com. 2021. How the strengths of Lisp-family languages
;;   facilitate building complex and flexible bioinformatics applications.
;;   Bohdan B Khomtchouk, Edmund Weitz, Peter D Karp, Claes Wahlestedt.
;;   [online] Available at:
;;   https://academic.oup.com/bib/article-pdf/19/3/537/25603287/bbw130.pdf
;;   [Accessed 11 October 2021].
;; - [7] En.wikipedia.org. 2022. Mathematics Subject Classification - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Mathematics_Subject_Classification
;;   [Accessed 16 June 2022].
;; - [8] En.wikipedia.org. 2022. ACM Computing Classification System -
;;   Wikipedia. [online] Available at:
;;   https://en.wikipedia.org/wiki/ACM_Computing_Classification_System
;;   [Accessed 16 June 2022].
;; - [9] List of terms relating to algorithms and data structures (2023)
;;   Wikipedia. Wikimedia Foundation. Available at:
;;   https://en.wikipedia.org/wiki/List_of_terms_relating_to_algorithms_and_data_structures
;;   (Accessed: February 8, 2023). 
;; - [10] Dictionary of algorithms and Data Structures (no date) NIST.
;;   Available at: https://www.nist.gov/dads/ (Accessed: February 8, 2023).
;; - [11] Scheme requests for implementation (no date) Scheme Requests for
;;   Implementation. Available at: https://srfi.schemers.org/
;;   (Accessed: 29 July 2023). 
;; - [12] Practical scheme (no date) Practical Scheme. Available at:
;;   https://practical-scheme.net/ (Accessed: 29 July 2023).
;; - [13] Project MAC (‘Switzerland’) (no date) Project MAC Home Page.
;;   Available at: http://groups.csail.mit.edu/mac/projects/mac/
;;   (Accessed: 29 July 2023). 


(define-module (grsp grsp0)
  #:use-module (grsp grsp3)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 futures)  
  #:export (pline
	    ptit
	    newlines
	    clear
	    pres
	    pres2
	    newspaces
	    strings-append
	    read-file-as-string
	    grsp-lang-effective-version
	    grsp-test
	    grsp-save-to-file
	    grsp-delete-file
	    grsp-n2s
	    grsp-s2n
	    grsp-sqlp
	    grsp-ld
	    grsp-dl
	    grsp-ldl
	    grsp-ldvl
	    grsp-cd
	    grsp-ask
	    grsp-askn
	    grsp-ask-etc
	    grsp-placebo
	    in
	    de
	    grsp-bcn2s
	    grsp-argtype
	    grsp-dstr
	    grsp-jstr
	    grsp-hw
	    grsp-gb
	    grsp-string-tlength
	    grsp-string-ltlength
	    grsp-string-ltrim
	    grsp-string-pjustify
	    grsp-string-repeat
	    grsp-string-lpjustify
	    grsp-ln2ls
	    grsp-ls2ln
	    grsp-ls2s
	    grsp-s2ln
	    grsp-ln2s
	    grsp-generate-file-name
	    grsp-list-file-name
	    grsp-trprnd
	    grsp-intercal
	    grsp-s2dbc
	    grsp-ln2ns
	    grsp-dbc2s
	    grsp-lns2ln
	    grsp-dsc
	    grsp-dscn
	    grsp-dline
	    grsp-dtext
	    displayl
	    displayf
	    grsp-slists-append
	    grsp-lam
	    grsp-random-state-set
	    displayc
	    grsp-confirm
	    grsp-b2s
	    grsp-s2b
	    grsp-y2s
	    grsp-nan2s
	    grsp-s2nan
	    grsp-inf2s
	    grsp-s2inf
	    grsp-s2y
	    grsp-confirm-ask
	    grsp-art1
	    grsp-art2
	    grsp-string-is-number
	    grsp-art3
	    grsp-s2qs
	    grsp-touch-lf))


;;;; pline - Displays string p_s1 p_l1 times in one line at the console.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: line character to display.
;; - p_l1: line length.
;;
;; Examples:
;;
;; - example1.scm, example3.scm.
;;
;; Output:
;; 
;; - String.
;;
(define (pline p_s1 p_l1)
  (let ((s1 ""))

    ;; Cycle.
    (let loop ((i1 0))
      (if (= i1 p_l1)
	  (begin (newlines 1)
		 (display s1)
		 (newlines 1))
	  (begin (set! s1 (string-append s1 p_s1))
	         (loop (+ i1 1)))))))


;;;; ptit - Displays a console title with one or two lines.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: line string to display.
;; - p_l1: line length.
;; - p_n1: number of lines (1 or 2, defaults to 1 line above title).
;; - p_t1: title to display.
;;
;; Examples:
;;
;; - example1.scm, example3.scm.
;;
;; Output:
;; 
;; - String.
;;
(define (ptit p_s1 p_l1 p_n1 p_t1)
  (if (<= p_n1 1)
      (pline p_s1 p_l1))
  
  (if (>= p_n1 2)
      (pline p_s1 p_l1))
  
  (display p_t1)
  
  (if (>= p_n1 2)
      (pline p_s1 p_l1))
  
  (newline))


;;;; newlines - Repeats function newline p_n1 times.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_n: number of iterations.
;;
(define (newlines p_n1)
  (let loop ((i1 0))
    (if (<= i1 p_n1)
	(begin (newline)
	       (loop (+ i1 1))))))


;;;; clear - Clears the shell by inserting 100 blank lines.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Examples:
;;
;; - example3.scm.
;;
(define (clear)
  (newlines 100))


;;;; pres - Display results with a reference string or title and an equal sign
;; preceeding the results string.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: reference, string.
;; - p_s2: result, string.
;;
;; Notes:
;;
;; -  See pres2.
;;
;; Examples:
;;
;; - example1.scm. 
;;
;; Output:
;; 
;; - String.
;;
(define (pres p_s1 p_s2)
  (let ((res1 " "))

    (set! res1 (string-append p_s1 (string-append " = " p_s2)))
      (display res1)
      (newline)))


;;;; pres2 - Display results. Does not require p_s2 to be a string.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: reference, string.
;; - p_s2: result.
;;
;; Notes:
;;
;; -  See pres.
;;
;; Output:
;; 
;; - String.
;;
(define (pres2 p_s1 p_s2)
  (newline)
  (display p_s1)
  (display " = ")
  (display p_s2)
  (newline))


;;;; newspaces - Adds p_n blank spaces to string p_l1.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_n1: number of blanks to add.
;; - p_l1: string to display.
;; - p_s1: side where to add spaces,
;;
;;   - 0 for left side.
;;   - 1 for right side.
;;
;; Examples:
;;
;; - example1.scm.
;;
;; Output:
;;
;; - String.
;;
(define (newspaces p_n1 p_l1 p_s1)
  (let ((res1 " ")
	(s1 ""))

    (let loop ((i1 0))
      
      ;; Create a string of blanks.
      (if (< i1 p_n1)
	  (begin (set! s1 (string-append s1 " "))
		 (loop (+ i1 1)))))
      
      ;; Add the blank string.
      (if (= p_s1 0)
  	  (set! res1 (string-append s1 p_l1)))
      
      (if (= p_s1 1)
	  (set! res1 (string-append p_l1 s1)))

      res1))


;;;; strings-append - Appends strings entered in a list as one larger string.
;; Use it to avoid complex, nested calls to string-append when you have to join 
;; several strings into one.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_l1: list of strings.
;; - p_s1: add a blank space after each list element.
;;
;;   - 0 for no spaces.
;;   - 1 to add one blank space.
;;
;; Examples:
;;
;; - example1.scm, example3.scm.
;;
;; Output:
;;
;; - String.
;;
(define (strings-append p_l1 p_s1)
  (let ((res1 "")
	(elem #f))

    ;; Cycle.
    (set! elem (car p_l1))
    (while (not (equal? elem #f))
	   
	   (if (equal? p_s1 1)
	       (set! elem (string-append elem " ")))
	   
	   (set! res1 (string-append res1 elem))
	   (set! p_l1 (cdr p_l1))
	   
	   (if (> (length p_l1) 0)
	       (set! elem (car p_l1)))
	   
	   (if (= (length p_l1) 0)
	       (set! elem #f)))

    res1))


;;;; read-file-as-string - Reads a file as a string; adapted from an example 
;; from sources indicated below. The string will be formatted and include 
;; characters such as \n and \r. What this does in practice is to read a 
;; file and return it as one single string. 
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_f1: file name.
;;
;; Sources:
;;
;; - [1].
;;
;; Output:
;;
;; - String.
;;
(define (read-file-as-string p_f1)
  (call-with-input-file p_f1
    (lambda (p1)
      (let loop((ls1 '()) (c1 (read-char p1)))	
	(if (eof-object? c1)
	    (begin
	      (close-input-port p1)
	      (list->string (reverse ls1)))
	    (loop (cons c1 ls1) (read-char p1)))))))


;;;; grsp-lang-effective-version - Checks if currently instaled GNU Guile's
;; effective version is less, equal or higher than value of the version
;; argument.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: enter the one of the following strings.
;;
;;   - "lt" less than.
;;   - "eq" equal to.
;;   - "ht" higher than.
;;
;; - p_v1: version number to check against.
;;
;; Examples:
;;
;; - example1.scm.
;;
;; Output:
;;
;; - Boolean. Defaults to #f if p_s1 is entered incorrectly.
;;
(define (grsp-lang-effective-version p_s1 p_v1)
  (let ((res1 #f)
	(ev (string->number (effective-version))))

    (if (equal? p_s1 "lt")
	(set! res1 (< ev p_v1)))
   
    (if (equal? p_s1 "eq")
	(set! res1 (= ev p_v1)))
    
    (if (equal? p_s1 "ht")
	(set! res1 (> ev p_v1)))

    res1))


;;;; grsp-test - A simple test function.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Output:
;;
;; - String.
;;
(define (grsp-test)
  (grsp-ld "grsp-test"))
	      

;;;; grsp-save-to-file - Saves a string to file p_f1.   
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string to save.
;; - p_f1: file.
;; - p_m1: save mode.
;;
;;  - "w": open for input. Rewrite if exists.
;;  - "a": open for append. Create if does not exist.
;;
;; Output:
;;
;; - File.
;;
;; Sources;
;;
;; - [2].
;;
(define (grsp-save-to-file p_s1 p_f1 p_m1)
  (let ((output-port (open-file p_f1 p_m1)))    

    (display p_s1 output-port)
    (newline output-port)
    (close output-port)))


;;;; grsp-delete-file - Deletes file p_f1.   
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: mode:
;;
;;   - "#f": equivalent to rm -f, without confirmation.
;;   - "#c": eqivalent to rm, with confirmation.
;;
;; - p_f1: file name.
;;
(define (grsp-delete-file p_s1 p_f1)
  (let ((s1 p_s1)
	(s2 "rm")
	(s3 ""))

    (cond ((equal? p_s1 "#f")
	   (set! s3 "-f")))
	
    (system (strings-append (list s2 s3 p_f1) 1))))


;; grsp-n2s - A convenience function, shorter to write than number->string that
;; performs the same function. That is, to convert a number to a string.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_n1: number to convert.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-n2s p_n1)
  (let ((res1 ""))

    (set! res1 (number->string p_n1))

    res1))


;;;; grsp-s2n - A convenience function, shorter to write than string->number 
;; that performs the same function. That is, to convert a string to a number.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string to convert.
;;
;; Output:
;;
;; - Numeric.
;;
;;
(define (grsp-s2n p_s1)
  (let ((res1 0.0))

    (set! res1 (string->number p_s1))

    res1))


;;;; grsp-sqlp - Calls sqlp to access Sqlite3 or HDF5 databases from within a  
;; Guile program. Requires sqlp to be installed.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_p1: path to the sqlp executable.
;; - p_d1: database file, with path.
;; - p_s1: SQL or HDFQL snippet or file, with path.
;; - p_a1: sqlp macro (see sqlp's documentation for more on this).
;;
;; Sources:
;;
;; - [3].
;;
(define (grsp-sqlp p_p1 p_d1 p_s1 p_a1)
  (system (strings-append (list p_p1 p_d1 p_s1 p_a1) 1)))


;;;; grsp-ld - Line and display. Displays a string after a newline.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;; Examples:
;;
;; - example3.scm.
;;
;; Output:
;; 
;; - String.
;;
(define (grsp-ld p_s1)
  (newline)
  (display p_s1))


;;;; grsp-dl - Display and line. Displays a newline after a string.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-dl p_s1)
  (display p_s1)
  (newline))


;;;; grsp-ldl - Line, display. line. Displays p_n1 blank lines before
;; string p_s1 and p_n2 blank lines after p_s1.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string.
;; - p_n1: number of new lines preceeding the string.
;; - p_n2: number of new lines after the string.
;;
;; Examples:
;;
;; - example3.scm.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ldl p_s1 p_n1 p_n2)
  (let ((n1 0))

    (set! n1 (- p_n1 1))
    
    (cond ((< n1 0)
	   (set! n1 0)))
    
    (newlines n1)
    (display p_s1)
    (newlines p_n2)))


;;;; grsp-ldvl - Line, display value, line. Displays p_n1 blank lines before
;; string p_s1 and p_n2 blank lines after p_s1.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string (i.e. description or title of p_v1).
;; - p_v1: value.
;; - p_n1: number of new lines preceeding the string.
;; - p_n2: number of new lines after the string.
;;
;; Examples:
;;
;; - example28.scm.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ldvl p_s1 p_v1 p_n1 p_n2)
  (let ((n1 0))

    (set! n1 (- p_n1 1))
    
    (cond ((< n1 0)
	   (set! n1 0)))
    
    (newlines n1)
    (display p_s1)
    (display " ")
    (display p_v1)
    (newlines p_n2)))


;;;; grsp-cd - Same as grsp-ld, but performs a clear instead of newline, meaning
;; that it clears the screen or console instead of just adding a line break.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-cd p_s1)
  (clear)
  (display p_s1))


;;;; grsp-ask - Input query, string.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string representing the question to ask.
;;
;; Examples:
;;
;; - example3.scm.
;;
;; Output:
;;
;; - Returns data from the user's input. You may need to use symbol->[type] in
;;   order to return the proper type variable for your needs.
;;
(define (grsp-ask p_s1)
  (let ((res1 " "))

    (newline)
    (grsp-ld p_s1)
    (set! res1 (read))

    res1))


;;;; grsp-askn - Input query for numbers.
;;
;; Keywords:
;;
;; - console, numbers
;;
;; Parameters:
;;
;; - p_s1: string representing the question to ask.
;;
;; Output:
;;
;; - Numeric. Returns data from the user's input as a number.
;;
(define (grsp-askn p_s1)
  (let ((res1 0))

    (newline)
    (grsp-ld p_s1)
    (set! res1 (read))

    res1))


;;;; grsp-ask-etc - Asks top press <ENT> to continue.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Examples:
;;
;; - example3.scm
;;
;; Output:
;;
;; - A question asking to press <ENT> to continue.
;;
(define (grsp-ask-etc)
  (let ((res1 " "))

    (grsp-ask "Press <ENT> to continue.")
    
    res1))


;;;; grsp-placebo - This function is a placebo.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string or number.
;;
;; Output:
;;
;; - Returns p_s1.
;;
(define (grsp-placebo p_s1)
  (let ((res1 p_s1))
    
    ;; Does nothing, which sometimes can be useful.
    
    res1))


;; in - Increments p_n1 by one.
;;
;; Keywords:
;;
;; - console, numbers
;;
;; Parameters:
;;
;; - p_n1: number.
;;
;; Output:
;;
;; - Numeric.
;;
(define (in p_n1)
  (let ((res1 0))

    (set! res1 (+ p_n1 1))

    res1))


;; de - Decrements p_n1 by one.
;;
;; Keywords:
;;
;; - console, numbers
;;
;; Parameters:
;;
;; - p_n1: number.
;;
;; Output:
;;
;; - Numeric.
;;
(define (de p_n1)
  (let ((res1 0))

    (set! res1 (- p_n1 1))

    res1))


;;;; grsp-bcn2s - Casts p_a1 to string, being p_a1 a boolean, char or numeric
;; argument.
;;
;; Keywords:
;;
;; - console, numbers
;;
;; Parameters:
;;
;; - p_a1: argument (any type).
;;
;; Output:
;;
;; - String.
;;
;;   - String "nc2s" (not convertible to string) if the argument cannot be cast
;;     as a string.
;;   - A string representing the argument, otherwise.
;;
(define (grsp-bcn2s p_a1)
  (let ((res1 "nc2s")
	(l1 '()))

    (cond ((string? p_a1)
	   (set! res1 p_a1))	  
	  ((boolean? p_a1)
	   (cond ((equal? p_a1 #t)
		  (set! res1 "#t"))
		 (else (set! res1 "#f"))))
	  ((char? p_a1)
	   (set! l1 (list p_a1))
	   (set! res1 (list->string l1)))
	  ((integer? p_a1)
	   (set! res1 (number->string p_a1)))
	  ((real? p_a1)
	   (set! res1 (number->string p_a1)))
	  ((complex? p_a1)
	   (set! res1 (number->string p_a1))))
    
    res1))


;;;; grsp-argtype - Finds the type of p_a1.
;;
;; Keywords:
;;
;; - console, arguments, types
;;
;; Parameters:
;;
;; - p_a1: argument.
;;
;; Output:
;;
;; - Numeric.
;;
;;   - 0: undefined.
;;   - 1: list.
;;   - 2: string.
;;   - 3: array.
;;   - 4: boolean.
;;   - 5: char.
;;   - 6: integer.
;;   - 7: real.
;;   - 8: complex.
;;   - 9: inf.
;;   - 10: nan.
;;
;; Sources:
;;
;; - [4][5].
;;
(define (grsp-argtype p_a1)
  (let ((res1 0)
	(a1 0))

    (cond ((list? p_a1)
	   (set! res1 1))
	  ((string? p_a1)
	   (set! res1 2))	  
	  ((array? p_a1)
	   (set! res1 3))	  
	  ((boolean? p_a1)
	   (set! res1 4))
	  ((char? p_a1)
	   (set! res1 5))	  
	  ((integer? p_a1)
	   (set! res1 6))
	  ((real? p_a1)
	   (set! res1 7))
	  ((complex? p_a1)
	   (set! res1 8)))

    ;; This should be processed separatedly.
    (cond ((< res1 8)
	   
	   (cond ((inf? p_a1)
		  (set! res1 9))
		 ((nan? p_a1)
		  (set! res1 10)))))		 
    
    res1))


;;;; grsp-dstr - Duplicates string p_s1 by concatenationg it with itself so that
;; if from p_s1 is obtained p_s1+p_s1.
;;
;; Keywords:
;;
;; - console, arguments, types
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-dstr p_s1)
  (let ((res1 p_s1))

    (set! res1 (string-append res1 p_s1))

    res1))


;;;; grsp-jstr - Will form a string of p_n1 elements, including strings p_s1,
;; p_s2 and enough repetitions of string p_s3 in order to justify p_s1 to the
;; left and p_s2 to the right.
;;
;; Keywords:
;;
;; - console, strings.
;;
;; Parameters:
;;
;; - p_s1: string.
;; - p_s2: string.
;; - p_s3: string (one element in length).
;; - p_n1: number. Should be greater than the length of p_s1, p_s2 and p_s3
;;   put together.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-jstr p_s1 p_s2 p_s3 p_n1)
  (let ((res1 " ")
	(l1 0)
	(l2 0)
	(l3 0)
	(n1 0)
	(i1 0)
	(s3 ""))

    (set! l1 (string-length p_s1))
    (set! l2 (string-length p_s2))  
    (set! n1 (- p_n1 (+ l1 l2)))

    ;; Cycle.
    (while (< l3 n1)
	   (set! s3 (string-append s3 p_s3))
	   (set! l3 (string-length s3)))

    ;; Compose results.    
    (set! res1 (strings-append (list p_s1 s3 p_s2) 0))
    
    res1))


;;;; grsp-hw - Salutes the world. Sometimes this is all what is needed.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Output:
;;
;; - String.
;;
(define (grsp-hw)
  (grsp-ldl "Hello world!" 1 1))


;;;; grsp-gb - Says goodbye.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Output:
;;
;; - String.
;;
(define (grsp-gb)
  (grsp-ldl "Good bye!" 1 1))


;;;; grsp-string-tlength - Returns the length of trimmed string p_s2.
;;
;; Keywords:
;;
;; - console, trim, strings
;;
;; Parameters:
;;
;; - p_s1: sitring. Mode.
;;
;;   - "#l": trim left.
;;   - "#r": trim right.
;;   - "#b": trim left and right.
;;   - "#n": do not trim.
;;
;; - p_s2: string.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-string-tlength p_s1 p_s2)
  (let ((res1 0)
	(res2 0))

    (cond ((equal? p_s1 "#l")
	   (set! res1 (string-length (string-trim p_s2))))
	  ((equal? p_s1 "#r")
	   (set! res1 (string-length (string-trim-right p_s2))))
	  ((equal? p_s1 "#b")
	   (set! res1 (string-length (string-trim-both p_s2))))
	  ((equal? p_s1 "#n")
	   (set! res1 (string-length p_s2))))
	  
    res1))


;;;; grsp-string-ltlength - Find the length of each string in a string list.
;;
;; Keywords:
;;
;; - console, trim, strings
;;
;; Parameters:
;;
;; - p_s1: sitring. Mode.
;;
;;   - "#l": trim left.
;;   - "#r": trim right.
;;   - "#b": trim left and right.
;;   - "#n": do not trim.
;;
;; - p_l1: list of strings.
;;
;; Notes:
;;
;; - See grsp-string-tlength, grsp-string-ltrim.
;;
;; Output:
;;
;; - List, numeric.
;;
(define (grsp-string-ltlength p_s1 p_l1)
  (let ((res1 '())
	(res2 '())
	(n1 0)
	(s2 "")
	(hn (length p_l1)))    

    ;; Trim according to p_s1.
    (set! res2 (grsp-string-ltrim p_s1 p_l1))
    
    ;; Create results list.
    (set! res1 (make-list hn 0))

    ;; Cycle.
    (let loop ((j1 0))
      (if (< j1 hn)
	  (begin (set! s2 (list-ref res2 j1))
		 (set! n1 (string-length s2))
		 (list-set! res1 j1 n1)
		 (loop (+ j1 1)))))
   
    res1))


;;;; grsp-string-ltrim - Trim spaces on all elements of list p_l1 according to
;; p_s1.
;;
;; Keywords:
;;
;; - console, trim, strings
;;
;; Parameters:
;;
;; - p_s1: sitring. Mode.
;;
;;   - "#l": trim left.
;;   - "#r": trim right.
;;   - "#b": trim left and right.
;;   - "#n": do not trim.
;;
;; - p_l1: list of strings.
;;
;; Notes:
;;
;; - See grsp-string-tlength.
;;
;; Output:
;;
;; - List, string.
;;
(define (grsp-string-ltrim p_s1 p_l1)
  (let ((res1 '()))  

    (set! res1 p_l1)
    
    ;; Trim according to p_s1.
    (cond ((equal? p_s1 "#l")
	   (set! res1 (map string-trim res1)))
	  ((equal? p_s1 "#r")
	   (set! res1 (map string-trim-right res1)))
	  ((equal? p_s1 "#b")
	   (set! res1 (map string-trim-both res1))))
    
    res1))


;;;; grsp-string-pjustify - Pads with string p_s3 and justifies string p_s2
;; into a string of total length p_n1.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string. Mode.
;;
;;   - "#l": p_s2 to the left.
;;   - "#r": p_s2 to the right.
;;   - "#b": center p_s2.
;;
;; - p_s2: string.
;; - p_s3: string for padding (one char length).
;; - p_n1: numeric. Length of padded and justified string.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-string-pjustify p_s1 p_s2 p_s3 p_n1)
  (let ((res1 p_s2)
	(s4 "")
	(s5 "")
	(j1 0)
	(n1 p_n1)
	(n2 (string-length p_s2))
	(n3 0)
	(n4 0))

    ;; n1 cannot be shorter than n2.
    (cond ((< n1 n2)
	   (set! n1 n2)))

    ;; If n1 equals n2 for whatever reason, there is no need to justify
    ;; anything because the resulting string will be of the same length
    ;; as p_s2, so the function returns the original p_s2.
    (cond ((> n1 n2)
	   ;; Find out how many characters should be padded using p_s3.
	   (set! n3 (- n1 n2))
	   
	   ;; Compose results.
	   (cond ((equal? p_s1 "#r")
		  (set! s4 (grsp-string-repeat p_s3 n3))
		  (set! res1 (strings-append (list s4 p_s2) 0)))
		 ((equal? p_s1 "#l")
		  (set! s4 (grsp-string-repeat p_s3 n3))
		  (set! res1 (strings-append (list p_s2 s4) 0)))
		 ((equal? p_s1 "#b")
		  
		  (cond ((odd? n3)
			 (set! n4 (/ (- n3 1) 2))
			 (set! s4 (grsp-string-repeat p_s3 n4))
			 (set! s5 (grsp-string-repeat p_s3 (+ n4 1))))			 
			((even? n3)
			 (set! n4 (/ n3 2))
			 (set! s4 (grsp-string-repeat p_s3 n4))
			 (set! s5 s4)))

		  (set! res1 (strings-append (list s5 p_s2 s4) 0))))))
    
    res1))


;;;; grsp-string-repeat - Concatenate p_n1 copies of string p_s1
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string.
;; - p_n1: number. How many times should p_s1 be repeated.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-string-repeat p_s1 p_n1)
  (let ((res1 ""))

	(let loop ((j1 0))
	  (if (< j1 p_n1)
	      (begin (set! res1 (string-append res1 p_s1))
		     (loop (+ j1 1)))))
  
    res1))


;;;; grsp-string-lpjustify - Applies grsp-string-pjustify to every element of
;; p_l1, producing a list of strings of equal length, padded with p_s3 and
;; lustified according to p_s1.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string. Mode.
;;
;;   - "#l": p_s2 to the left.
;;   - "#r": p_s2 to the right.
;;   - "#b": center p_s2.
;;
;; - p_l1: list of strings.
;; - p_s3: string for padding (one char length).
;; - p_n1: numeric. Length of padded and justified string.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-string-lpjustify p_s1 p_l1 p_s3 p_n1)
  (let ((res1 '())
	(s2 "")
	(hn (length p_l1)))

    ;; Create results list.
    (set! res1 (make-list hn s2))
    (let loop ((j1 0))
      (if (< j1 hn)
	  (begin (list-set! res1 j1 (grsp-string-pjustify p_s1
							  (list-ref p_l1 j1)
							  p_s3
							  p_n1))
		 (loop (+ j1 1)))))
    
    res1))


;;;; grsp-ln2ls - Casts a list of numbers as a list of strings that represent
;; numbers.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_l1: list of numbers to convert to strings.
;;
;; Output:
;;
;; - List, string.
;;
(define (grsp-ln2ls p_l1)
  (let ((res1 '()))

    (set! res1 (map grsp-n2s p_l1))
    
    res1))


;;;; grsp-ls2ln - Casts a list of strings representing numbers as a list of
;; numbers.
;;
;; Keywords:
;;
;; - console, strings, utf, database
;;
;; Parameters:
;;
;; - p_l1: list of strings to convert to numbers.
;;
;; Output:
;;
;; - List, numeric.
;;
(define (grsp-ls2ln p_l1)
  (let ((res1 '()))

    (set! res1 (map grsp-s2n p_l1))
    
    res1))


;;;; grsp-ls2s - Casts a list of strings as single string.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_l1: list of strings to convert to a single string.
;;
;; Output:
;;
;; - String. 
;;
(define (grsp-ls2s p_l1)
  (let ((res1 ""))

    (let loop ((j1 0))
      (if (< j1 (length p_l1))
	  (begin (set! res1 (string-append res1 (list-ref p_l1 j1)))
		 (loop (+ j1 1)))))
    
    res1))


;;;; grsp-s2ln - String to list of numbers representing the Unicode number of
;; each character in the original string.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;; Output:
;;
;; - List, numeric.
;;
(define (grsp-s2ln p_s1)
  (let ((res1 '())
	(l1 '()))
	     
    (set! l1 (string->list p_s1))
    (set! res1 (map char->integer l1))
    
    res1))


;;;; grsp-ln2s - List of numbers to string. The numbers in the list should
;; represent Unicode characters.
;;
;; Keywords:
;;
;; - console, strings, unicode, utf
;;
;; Parameters:
;;
;; - p_l1: list.
;;
;; Notes: 
;;
;; - grsp-ln2s casts unicode number sets to alphanumeric characters, while
;;   grsp-ln2ss casts unicode number sets as a numeric string.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ln2s p_l1)
  (let ((res1 "")
	(l1 '()))

    (set! l1 (map integer->char p_l1))
    (set! res1 (list->string l1))
    
    res1))


;;;; grsp-generate-file-name - Generates a file name string that appends to
;; string p_s1 a random number and a file descriptor in order to provide an
;; unique file name even if the descriptor or p_s1 are the same in various
;; instances.
;;
;; Keywords:
;;
;; - functions, random, string, files, name, naming
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: if p_s1 and a separator are to be used.
;;   - #f: otherwise.
;;
;; - p_s1: string.
;; - p_s2: string, file type descriptor (example "txt").
;;
;; Notes:
;;
;; - See grsp-list-fname, grsp-random-state-set.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-generate-file-name p_b1 p_s1 p_s2)
  (let ((res1 ""))

    (cond ((equal? p_b1 #t)
	   (set! res1 (strings-append (list p_s1 "-" (grsp-trprnd) "." p_s2) 0)))
	  (else (set! res1 (strings-append (list (grsp-trprnd) "." p_s2) 0))))
    
    res1))


;;;; grsp-list-file-name - Transforms a string created by grsp-generate-fname
;; into a three-element list.
;;
;; Keywords:
;;
;; - functions, random, string
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;; Notes:
;;
;; - The user should provide a valid string for this function. See
;;   grsp-generate-fname.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-list-file-name p_s1)
  (let ((res1 '())
	(l1 '())
	(l2 '()))

    ;; Split on finding relevant characters.
    (set! l1 (string-split p_s1 #\-))
    (set! l2 (string-split (cadr l1) #\.))

    ;; Compose results.
    (set! res1 ((car l1) (car l2) (cadr l2)))
    
    res1))


;;;; grsp-trprnd - Generates a string containing numeric characters,
;; which is a combination of a timestamp and a random number (uniform
;; distribution).
;;
;; Keywords:
;;
;; - functions, random, string
;;
;; Notes:
;;
;; - See grsp-random-state-set.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-trprnd)
  (let ((res1 0))

    (set! res1 (strings-append (list (grsp-n2s (current-time))
				     (grsp-n2s (random 1000000000)))
			       0))
    
    res1))


;;;; grsp-intercal - Intercalates string p_s2 between the characters of string
;; p_s3 according to mode p_s1.
;;
;; Keywords:
;;
;; - functions, random, string
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#l": place p_s2 only at the beginning.
;;   - "#h": place p_s2 only at the end
;;   - "#m": place p_s2 between characters bun neither at the beginning nor the
;;     end.
;;   - "#lm": place p_s2 at the beginning and between characters but not at the
;;     end.
;;   - "#mh": place p_s2 between the middle characters and at the end of the
;;     string.
;;   - "#lh": place p_s2 at the beginning and at the end of the string, but not
;;     between characters.
;;   - "#lmh": place p_s2 at the beginning, between characters and at the end.
;;
;; - p_s2: string to place between characters.
;; - p_s3: string to be modified.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-intercal p_s1 p_s2 p_s3)
  (let ((res1 "")
	(b1 #f)
	(s3 "")
	(s4 "")
	(sus "")
	(hn 0))

    (set! s3 p_s3)
    (set! s3 (string-trim-both s3))
    (set! hn (- (string-length s3) 1))

    ;; If p_s2 will be inserted only at the extremes.
    (cond ((equal? p_s1 "#l")
	   (set! b1 #t)
	   (set! res1 (strings-append (list p_s2 s3) 0)))
	  ((equal? p_s1 "#h")
	   (set! b1 #t)
	   (set! res1 (strings-append (list s3 p_s2) 0)))
	  ((equal? p_s1 "#lh")
	   (set! b1 #t)
	   (set! res1 (strings-append (list p_s2 s3 p_s2) 0))))

    ;; If p_s2 will be inserted also beteen characters.
    (cond ((equal? b1 #f)

	   (cond ((equal? p_s1 "#m")

		  (let loop ((j1 0))
		    (if (<= j1 hn)
			(begin (set! s4 (substring s3 j1 (+ j1 1)))
			       
			       (cond ((> j1 0)
				      (set! sus (strings-append (list sus p_s2 s4) 0)))
				     (else (set! sus s4)))
			       
			       (loop (+ j1 1)))))
		  
		  (set! res1 sus))
		 ((equal? p_s1 "#mh")
		  (set! s3 (grsp-intercal "#m" p_s2 s3))
		  (set! res1 (grsp-intercal "#h" p_s2 s3)))
		 ((equal? p_s1 "#lmh")
		  (set! s3 (grsp-intercal "#m" p_s2 s3))
		  (set! res1 (grsp-intercal "#lh" p_s2 s3)))
		 ((equal? p_s1 "#lm")
		  (set! s3 (grsp-intercal "#m" p_s2 s3))
		  (set! res1 (grsp-intercal "#l" p_s2 s3))))

	   ))
		  		  
    res1))


;;;; grsp-s2dbc - Casts a string as a number composed of a succession of the
;; unicode representation of each character string interspected by the unicode
;; representation of the string "|" . This is a useful way to store
;; strings in numeric matrices as integers. This function converts any string
;; to a number apt to be stored in a grsp relational matrix.
;;
;; Keywords:
;;
;; - functions, random, string
;;
;; Parameters
;;
;; - p_s1: string.
;;
;; Notes:
;;
;; - See grsp-dbc2s, grsp3.grsp-matrix-create.
;; - String "|" is used to clearly separate each character string and hence the
;;   unicode number of each one of them.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-s2dbc p_s1)
  (let ((res1 0)
	(l1 '())
	(s1 "")
	(s2 ""))

    (set! s1 (grsp-intercal "#lmh" "|" p_s1))
    (set! l1 (grsp-s2ln s1))
    (set! s2 (grsp-ln2ns l1))
    (set! res1 (grsp-s2n s2))
    
    res1))


;;;; grsp-dbc2s - Inverse function of grsp-s2dbc. This function converts back
;; strings initially converted into numbers by grsp-s2dbc back to string,
;; human readable form.
;;
;; Keywords:
;;
;; - functions, random, string
;;
;; Parameters:
;;
;; - p_n1: number. Should have been composed as described in grsp-s2dbc.
;;
;; Notes:
;;
;; - See grsp-s2dbc, grsp3.grsp-matrix-create, grsp3.grsp-dbc2lls.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-dbc2s p_n1)
  (let ((res1 "")
	(l1 '())
	(s1 "")
	(s2 "")
	(s3 ""))

    ;; Convert number to string.
    (set! s1 (grsp-n2s p_n1))

    ;; Replace sequences of "124" with "|".
    (set! s2 (string-replace-substring s1 "124" "|"))

    ;; Split string along character #\|.
    (set! s3 (string-split s2 #\|))

    ;; Casy from list of numeric strings to list of numbers.
    (set! l1 (grsp-lns2ln s3))

    ;; Cast from list of numbers to one string that rebuilds the original one.
    (set! res1 (grsp-ln2s l1))
    
    res1))


;;;; grsp-ln2ns - List of numbers to numeric string. The numbers in the list
;; should represent Unicode characters.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_l1: list.
;;
;; Notes:
;;
;; - grsp-ln2s casts unicode number sets to alphanumeric characters, while
;;   grsp-ln2ss casts unicode number sets as a numeric string.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-ln2ns p_l1)
  (let ((res1 "")
	(s1 0))

    (let loop ((j1 0))
      (if (< j1 (length p_l1))
	  (begin (set! s1 (grsp-n2s (list-ref p_l1 j1)))
		 (cond ((= j1 0)
			(set! res1 s1))
		       (else (set! res1 (string-append res1 s1))))
		 (loop (+ j1 1)))))
    
    res1))
  

;;;; grsp-lns2ln - Casts a list of numeric strings representing Unicode
;; characters into numbers representing those Unicode characters.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_l1: list.
;;
;; Output:
;;
;; - List.
;;
(define (grsp-lns2ln p_l1)
  (let ((res1 '())
	(l1 '())
	(l2 '())
	(j1 0)
	(s1 ""))

    (set! l1 p_l1)
    (set! l2 (delete "" l1))   
    (set! res1 (map grsp-s2n l2))
    
    res1))


;;;; grsp-dsc - Displays double semicolon for comments.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Output:
;;
;; - String.
;;
(define (grsp-dsc)
  (display ";; "))


;;;; grsp-dscn - Displays double semicolon and a free line.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Output:
;;
;; - String.
;;
(define (grsp-dscn)
  (grsp-dsc)
  (newline))


;;;; grsp-dline - Displays a double line.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Output:
;;
;; - String.
;;
(define (grsp-dline)
  (grsp-dsc)
  (display (grsp-string-repeat "=" 78))
  (newline))


;;;; grsp-dtext - Displays a commented line.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-dtext p_s1)
  (grsp-dsc)
  (grsp-dl p_s1))


;;;; displayl - Displays all elements of list p_l1 separated (preceeded)
;; by string p_s1.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string.
;; - p_l1: list.
;;
;; Output:
;;
;; - String.
;;
(define (displayl p_s1 p_l1)
  (let ((b1 #f)
	(b2 #f))
    
    (let loop ((j1 0))
      (if (< j1 (length p_l1))
	  (begin (display p_s1)

		 ;; Find out if special display arrangements are to
		 ;; be used in a few cases.
		 (set! b2 (array? (list-ref p_l1 j1)))		 

		 ;; Special display arrangements.
		 (cond ((equal? b2 #t)
			(grsp-matrix-display (list-ref p_l1 j1))
			(set! b1 #t)))

		 ;; Default display option.
		 (cond ((equal? b1 #f)
			(display (list-ref p_l1 j1)))
		       ((equal? b1 #t)
			(set! b1 #f)))
		 
		 (loop (+ j1 1)))))))


;;;; displayf - Displays the contents of a plain text file.
;;
;; Keywords:
;;
;; - console, strings, engrams
;;
;; Parameters:
;;
;; - p_f1: string. File name.
;;
;; Output:
;;
;; - String.
;;
(define (displayf p_f1)
  (display (read-file-as-string p_f1)))


;;;; grsp-slists-append - Appends each consecutive element of string list
;; p_l1 to each element of string list p_l2 separated by string p_s1.
;;
;; Keywords:
;;
;; - console, strings, appending, lists
;;
;; Parameters:
;;
;; - p_l1: list of string elements.
;; - p_l2: list of string elements.
;; - p_s1: string.
;;
;; Output:
;;
;; - List of strings.
;;
(define (grsp-slists-append p_l1 p_l2 p_s1)
  (let ((res1 '())
	(l3 (make-list (length p_l1) p_s1)))

    (set! res1 (map string-append p_l1 l3))
    (set! res1 (map string-append res1 p_l2))

    res1))


;;;; grsp-lam - List of strings enumerating the available modules of the grsp
;; library.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Output:
;;
;; - String.
;;
(define (grsp-lam)
  (let ((res1 '()))

    (set! res1 (list "(grsp grsp0)"
		     "(grsp grsp1)"
		     "(grsp grsp2)"
		     "(grsp grsp3)"
		     "(grsp grsp4)"
		     "(grsp grsp5)"
		     "(grsp grsp6)"
		     "(grsp grsp7)"
		     "(grsp grsp8)"
		     "(grsp grsp9)"
		     "(grsp grsp10)"
		     "(grsp grsp11)"
		     "(grsp grsp12)"
		     "(grsp grsp13)"
		     "(grsp grsp14)"
		     "(grsp grsp15)"
		     "(grsp grsp16)"
		     "(grsp grsp17"))
    
    res1))


;;;; grsp-random-state-set - Seed random state using platform-specific
;; properties if p_b1 is #t. If you leave p_b1 as #f the value fo the system
;; variable random-state will remain the same and therefore, you will get
;; the same pseudo-random numbers each time you generate a random series. This
;; could be useful in order to repeat experimental data. Otherwise, you should
;; set p_b1 to #t in order ot get different number each time you star a program
;; or call a random generation function.
;;
;; Keywords:
;;
;; - random, seeding, repetition
;;
;; Parameters:
;;
;; - p_b1: boolean. #t to set new random state, #f otherwise.
;;
(define (grsp-random-state-set p_b1)

  (cond ((equal? p_b1 #t)
	 (set! *random-state* (random-state-from-platform)))))


;;;; displayc - Displays p_v1 if p_b1 is #t.
;;
;; Keywords:
;;
;; - console, display
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: display p_v1.
;;   - #f: otherwise-
;;
;; - p_v1: value.
;;
(define (displayc p_b1 p_v1)

  (cond ((equal? p_b1 #t)
	 (grsp-ldl p_v1 0 0))))


;;;; grsp-confirm - If p_b1 #t, asks for confirmation.
;;
;; Keywords:
;;
;; - confirmation, safety
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t to ask for confirmation.
;;   - #f otherwise.
;;
(define (grsp-confirm p_b1)
  (let ((res1 #f))

  (cond ((equal? p_b1 #t)
	 (set! res1 (grsp-ask "Confirm operation [#t/#f]? "))))

  res1))


;;;; grsp-b2s - Casts a boolean value as string.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;; Output:
;;
;; - String.
(define (grsp-b2s p_b1)
  (let ((res1 ""))

    (cond ((equal? p_b1 #t)
	   (set! res1 "#t"))
	  (else (set! res1 "#f")))

    res1))


;;;; grsp-s2b - Casts a string representing a boolean value as boolean.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_s1: string.
;;
;;   - "#t" for #t.
;;   - "#f" otherwise.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-s2b p_s1)
  (let ((res1 #f))

    (cond ((equal? p_s1 "#t")
	   (set! res1 #t))
	  (else (set! res1 #f)))

    res1))


;;;; grsp-y2s - Casts various different types to string.
;;
;; Keywords:
;;
;; - types. multi, multicast
;;
;; Parameters:
;;
;; - p_v1: value.
;;
;; Notes:
;;
;; - Cannot cast arrays, lists, undefined types.
;;
(define (grsp-y2s p_v1)
  (let ((res1 ""))

    (cond ((equal? (string? p_v1) #t)
	   (set! res1 p_v1))
	  ((equal? (boolean? p_v1) #t)
	   (set! res1 (grsp-b2s p_v1)))	  
	  ((equal? (real? p_v1) #t)
	   (set! res1 (grsp-n2s p_v1)))
	  ((equal? (number? p_v1) #t)
	   (set! res1 (grsp-n2s p_v1)))
	  ((equal? (complex? p_v1) #t)
	   (set! res1 (grsp-n2s p_v1)))
	  ((equal? (integer? p_v1) #t)
	   (set! res1 (grsp-n2s p_v1)))
	  ((equal? (nan? p_v1) #t)
	   (set! res1 (grsp-nan2s p_v1)))
	  ((equal? (inf? p_v1) #t)
	   (set! res1 (grsp-inf2s p_v1))))
    
    res1))


;;;; grsp-nan2s - Casts a NaN value as string.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_v1; value.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-nan2s p_v1)
  (let ((res1 ""))

    (cond ((equal? p_v1 +nan.0)
	   (set! res1 "+nan.0"))
	  ((equal? p_v1 -nan.0)
	   (set! res1 "-nan.0")))

    res1))


;;;; grsp-s2nan - Casts a NaN string value as a real NaN.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_v1; value.
;;
;; Output:
;;
;; - NaN.
;;
(define (grsp-s2nan p_v1)
  (let ((res1 0))

    (cond ((equal? p_v1 "+nan.0")
	   (set! res1 +nan.0))
	  ((equal? p_v1 "-nan.0")
	   (set! res1 -nan.0)))

    res1))


;;;; grsp-inf2s - Casts an inf value as string.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_v1; value.
;;
;; Output:
;;
;; - String.
;;
(define (grsp-inf2s p_v1)
  (let ((res1 ""))

    (cond ((equal? p_v1 +inf.0)
	   (set! res1 "+inf.0"))
	  ((equal? p_v1 -inf.0)
	   (set! res1 "-inf.0")))

    res1))


;;;; grsp-s2inf - Casts an inf string value as a real inf.
;;
;; Keywords:
;;
;; - console, strings
;;
;; Parameters:
;;
;; - p_v1; value.
;;
;; Output:
;;
;; - NaN.
;;
(define (grsp-s2inf p_v1)
  (let ((res1 0))

    (cond ((equal? p_v1 "+inf.0")
	   (set! res1 +inf.0))
	  ((equal? p_v1 "-inf.0")
	   (set! res1 -inf.0)))

    res1))


;;;; grsp-s2y - Casts a string to various different types.
;;
;; Keywords:
;;
;; - types. multi, multicast
;;
;; Parameters:
;;
;; - p_v1: value.
;;
;; Notes:
;;
;; - Cannot cast arrays, lists, undefined types.
;;
(define (grsp-s2y p_v1)
  (let ((res1 ""))

    (cond ((equal? (or (equal? p_v1 "#t") (equal? p_v1 "#f")) #t)
	   (set! res1 (grsp-s2b p_v1)))
	  ((equal? (or (equal? p_v1 "-nan.0") (equal? p_v1 "+nan.0")) #t)
	   (set! res1 (grsp-s2nan p_v1)))
	  ((equal? (or (equal? p_v1 "-inf.0") (equal? p_v1 "+inf.0")) #t)
	   (set! res1 (grsp-s2inf p_v1)))
	  ((string? p_v1)

	   (cond ((equal? (grsp-string-is-number p_v1) #t)
		  (set! res1 (grsp-s2n p_v1)))
		 (else (set! res1 p_v1)))))
    
    res1))


;;;; grsp-confirm-ask - If p_b1 #t, asks for confirmation of p_s1.
;;
;; Keywords:
;;
;; - confirmation, safety, input
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t to ask for confirmation.
;;   - #f otherwise.
;;
;; - p_s1: Text to display.
;;
(define (grsp-confirm-ask p_b1 p_s1)
  (let ((res1 #f))

  (cond ((equal? p_b1 #t)
	 (set! res1 (grsp-ask p_s1))))

  res1))


;;;; grsp-art1 - Art 1 value method.
;;
;; Keywords:
;; 
;; - art, value, caluclation, method, valuation
;;
;; Paramters:
;;
;; - p_n1: length.
;; - p_n2: width.
;; - p_n3; square unit reference value.
;;
(define (grsp-art1 p_n1 p_n2 p_n3)
  (let ((res1 0))

    (set! res1 (* p_n1 p_n2 p_n3))

    res1))


;;;; grsp-art2 - Art 2 value method.
;;
;; Keywords:
;; 
;; - art, value, caluclation, method, valuation
;;
;; Paramters:
;;
;; - p_n1: length.
;; - p_n2: width.
;; - p_n3: initial reference year.
;; - p_n4: final reference year.
;; - p_n5: reputation factor.
;;
(define (grsp-art2 p_n1 p_n2 p_n3 p_n4 p_n5)
  (let ((res1 0))

    (set! res1 (* (+ p_n1 p_n2) (* (- p_n4 p_n3) p_n5)))

    res1))


;;;; grsp-string-is-number - The function finds out if string p_s1
;; represents a number.
;;
;; Keywords:
;;
;; - stirngs, numbers, alphanumeric, valuation
;;
;; Parameters:
;;
;; - p_s1: string
;;
;; Output:
;;
;; - #t if p_s1 represents a number.
;; - #f otherwise.
;;
(define (grsp-string-is-number p_s1)
  (let ((res1 #f))

    (cond ((equal? (string->number p_s1) #f)
	   (set! res1 #f))
	  (else (set! res1 #t)))
    
    res1))

;;;; grsp-art3 - Provides combines results of grsp-art1 and grsp-art2 in list
;; format.
;;
;; Keywords:
;; 
;; - art, value, caluclation, method, valuation
;;
;; Paramters:
;;
;; - p_n1: length.
;; - p_n2: width.
;; - p_n3; square unit reference value.
;; - p_n4: initial reference year.
;; - p_n5: final reference year.
;; - p_n6: reputation factor.
;;
;; Output:
;;
;; - List:
;;
;;   - Elem 0: Value basen on grsp-art1.
;;   - Elem 1: Value based on grsp-art2.
;;   - Elem 2: Absoulte mean of elem 1 and 2.
;;
(define (grsp-art3 p_n1 p_n2 p_n3 p_n4 p_n5 p_n6)
  (let ((res1 '())
	(v1 0)
	(v2 0)
	(v3 0))

    (set! v1 (grsp-art1 p_n1 p_n2 p_n3))
    (set! v2 (grsp-art2 p_n1 p_n2 p_n4 p_n5 p_n6))
    (set! v3 (/ (+ v1 v2) 2))
    
    ;; Compose results
    (set! res1 (list v1 v2 v3))
    
    res1))


;;;; grsp-s2qs - Ads quotes at the beginning and endo fo a string as part of the string itself.
;;
;; Keywords
;;
;; - quotations, quoted
;;
;; Parameter:
;;
;; p_s1: string.
;;
(define (grsp-s2qs p_s1)
  (let ((res1 ""))

    (set! res1 (strings-append (list "\"" p_s1 "\"") 0))
    
    res1))


;;;; grsp-touch-lf - Touch all ellements of p_l1.
;;
;; Keywords:
;;
;; - mth, futures
;;
;; Parameters:
;; 
;; - p_a1: list, futures.
;;
;; Output:
;;
;; - List containing the results of the operation for each element of p_l1; the
;;   type of each element of the list and the number of elements it may contain
;;   depends on the properties of p_l1 and its elements.
;;
(define (grsp-touch-lf p_l1)
  (let ((res1 '()))

    (set! res1 (map touch p_l1))

    res1))
