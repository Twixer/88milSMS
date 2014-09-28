Introduction
============

This project is an R analysis of the 88milSMS project. The initial
project is hosted at <http://88milsms.huma-num.fr/index.html>.

About the data
==============

The project

    data <- load.data()

    ## The clean data file already exists.

    xtable <- function(x, ...) {
       for (i in which(sapply(x, function(y) !all(is.na(match(c("POSIXt","Date"),class(y))))))) x[[i]] <- as.character(x[[i]])
       xtable::xtable(x, ...)
    }

    xt <- xtable(data)
    print(head(xt), type="html")

<!-- html table generated in R 3.1.1 by xtable 1.7-4 package -->
<!-- Fri Sep 26 20:03:06 2014 -->
<table border=1>
<tr> <th>  </th> <th> 
id.sms
</th> <th> 
id.mobile
</th> <th> 
timestamp
</th> <th> 
month
</th> <th> 
day
</th> <th> 
hour
</th> <th> 
day.type
</th> <th> 
sms
</th>  </tr>
  <tr> <td align="right"> 
1
</td> <td align="right">   
1
</td> <td> 
477
</td> <td> 
2011-09-15 07:28:55
</td> <td> 
9
</td> <td> 
15
</td> <td> 
7
</td> <td> 
Weekday
</td> <td> 
Hey ca va? Alors cette rentree? Va falloir se trouver un p'tit creneau
pour se voir! Dis moi, est-ce que tu sais quand commence les cours de
langue non specialiste? Bisoux
</td> </tr>
  <tr> <td align="right"> 
2
</td> <td align="right">   
2
</td> <td> 
477
</td> <td> 
2011-09-15 08:02:08
</td> <td> 
9
</td> <td> 
15
</td> <td> 
8
</td> <td> 
Weekday
</td> <td> 
Ok super merci! Oui j'y comprends rien du tout moi a cette fac :p J'irai
me renseigner aussi ( si j'trouve le batiment :) ) Merci encore! Bonne
soiree bisoux!
</td> </tr>
  <tr> <td align="right"> 
3
</td> <td align="right">   
3
</td> <td> 
477
</td> <td> 
2011-09-15 08:03:01
</td> <td> 
9
</td> <td> 
15
</td> <td> 
8
</td> <td> 
Weekday
</td> <td> 
Coucou ! C'est quand la feria de Nimes? J'suis pas bien sure de la faire
mais pourquoi pas! Sinon oui, j'profite de ma derniere semaine de
vacance! Bon courage! Bisoux
</td> </tr>
  <tr> <td align="right"> 
4
</td> <td align="right">   
4
</td> <td> 
477
</td> <td> 
2011-09-15 08:03:35
</td> <td> 
9
</td> <td> 
15
</td> <td> 
8
</td> <td> 
Weekday
</td> <td> 
Coucou :) Oui ca c'est bien passe! Alors je sais pas du tout pour jeudi
soir... Non pas que je veuille pas mais je suis pas sure d'etre sur
Montpel. J'y serai de sur qu'a partir de lundi prochain car je commence
les cours...
</td> </tr>
  <tr> <td align="right"> 
5
</td> <td align="right">   
5
</td> <td> 
477
</td> <td> 
2011-09-15 09:05:28
</td> <td> 
9
</td> <td> 
15
</td> <td> 
9
</td> <td> 
Weekday
</td> <td> 
On peut se rejoindre quelque part? Tu as cours ou ?
</td> </tr>
  <tr> <td align="right"> 
6
</td> <td align="right">   
6
</td> <td> 
477
</td> <td> 
2011-09-15 09:06:26
</td> <td> 
9
</td> <td> 
15
</td> <td> 
9
</td> <td> 
Weekday
</td> <td> 
Encore moi... J'te harcele, oui oui et j'assume :) Juste j'te tiens au
courant. On sera 4. Toi, \<PRE\_7\>, \<PRE\_3\> et moi a participer. On
t'avance?
</td> </tr>
   </table>
License
=======

Data
----

The license about the terms of use for the data is described at
<http://88milsms.huma-num.fr/corpus.html>.
