(deftemplate date  
(slot day)
(slot month)
(slot year)
(slot nr)
)
(deftemplate rezultat
(slot rez)
(slot nr)
)

;(deffacts initial
;  (date (day 12) (month 3)(year 1900) (nr 1))
;  (date (day 12) (month 6)(year 2000) (nr 2))
;  (rezultat (rez 0)(nr 1))
;  (rezultat (rez 0)(nr 2))
;)

(defrule first_days 
?a<-(date (day ?x)(month ?y)(year ?z)(nr ?t)) 
?b<-(rezultat (rez ?r)(nr ?t)) (test (> ?x 0))
=>
(modify ?a (day (- ?x 1)))
(modify ?b (rez (+ ?r 1)))
)
(defrule days_in_month_30  
?a<-(date (day 0) (month ?x) (year ?y) (nr ?z)) 
?b<-(rezultat (rez ?r) (nr ?z))
(or (test (= ?x 4)) (test (= ?x 6)) (test (= ?x 9)) (test (= ?x 11)))
=>
(modify ?a (month (- ?x 1)))
(modify ?b (rez (+ ?r 30)))
)

(defrule days_in_month_31  
?a<-(date (day 0) (month ?x) (year ?y) (nr ?z)) 
?b<-(rezultat (rez ?r) (nr ?z))
(or (test (= ?x 1)) (test (= ?x 3)) (test (= ?x 5)) (test (= ?x 7)) (test (= ?x 8)) (test (= ?x 10)) (test (= ?x 12)))
=>
(modify ?a (month (- ?x 1)))
(modify ?b (rez (+ ?r 31)))
)

(defrule days_in_month_28  ;nebisect
?a<-(date (day 0) (month ?x) (year ?y) (nr ?z)) 
?b<-(rezultat (rez ?r) (nr ?z))
(or (test  (or (<>  (mod ?y 4) 0)
               (and  (= (mod ?y 100) 0)
                     (<> (mod ?y 400) 0)))))
(test (> ?x 0))
=>
(modify ?a (month (- ?x 1)))
(modify ?b (rez (+ ?r 28 )))
)
(defrule days_in_month_29  ;bisect
?a<-(date (day 0) (month ?x) (year ?y) (nr ?z)) 
?b<-(rezultat (rez ?r) (nr ?z))
(or (test  (or (=  (mod ?y 4) 0)
               (and  (<> (mod ?y 100) 0)
                     (= (mod ?y 400) 0)))))
(test (> ?x 0))
=>
(modify ?a (month (- ?x 1)))
(modify ?b (rez (+ ?r 29 )))
)

(defrule days_years_365 ;nebisect
?a<-(date (day 0)(month 0)(year ?y)(nr ?z))
?b<-(rezultat (rez ?r)(nr ?z))
(test (> ?y 0))
(or (test  (or (<>  (mod ?y 4) 0)
               (and  (= (mod ?y 100) 0)
                     (<> (mod ?y 400) 0)))))
=>
(modify ?a (year (- ?y 1)))
(modify ?b (rez (+ ?r 365)))
)
(defrule days_years_366 ;bisect
?a<-(date (day 0)(month 0)(year ?y)(nr ?z))
?b<-(rezultat (rez ?r)(nr ?z))
(test (> ?y 0))
(or (test  (or (=  (mod ?y 4) 0)
               (and  (<> (mod ?y 100) 0)
                     (= (mod ?y 400) 0)))))
=>
(modify ?a (year (- ?y 1)))
(modify ?b (rez (+ ?r 366)))
)
(defrule rezultat_final
?a<-(date (day 0)(month 0)(year 0)(nr 1))
?b<-(date (day 0)(month 0)(year 0)(nr 2))
?re1<- (rezultat (rez ?r1)(nr 1))
?re2<-(rezultat  (rez ?r2)(nr 2))
=>
  (assert (rezultat_final ( abs (- ?r1 ?r2) )))
  (retract ?a)
  (retract ?b)
  (retract ?re1)
  (retract ?re2)
)






