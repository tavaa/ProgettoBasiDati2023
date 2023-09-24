library(RMySQL)
library(tidyverse)
library(ggplot2)
library(stringr)
library(ggbreak) 
library(dplyr)
con = dbConnect(RMySQL::MySQL(),
                            dbname='aeroporti software',
                            host='localhost',
                            port=3306,
                            user='root',
                            password='admin')



res <- as_tibble(dbGetQuery(con, "SELECT A.codice, A.nome, AD.tipo_aeroplano
FROM aeroporto as A, atterra_decolla as AD
WHERE A.codice = AD.codice_aeroporto
GROUP BY A.codice, A.nome, AD.tipo_aeroplano
ORDER BY A.codice, AD.tipo_aeroplano"))
tab<-res %>% 
  count(codice)
tab
x1 <- tab %>% pull(n)

barplot(x1, 
        space = 2,
        main="Numeri di tipi di aeroplani che possono atterrare e decollare",
        xlab="Aeroporti",
        ylab="Numero di tipi",
        border="red",
        names.arg = c("MI", "RO", "NYC", "FR", "LO", "ML", "HT","CDG","DIA", "LA", "SK", "HK"),
        col="blue",
        density=10)




res2 <- as_tibble(dbGetQuery(con, "SELECT TA.nome, AP.codice, TA.n_posti_max/AP.n_posti_effettivi AS rapporto
FROM tipo_aeroplano AS TA, Aeroplano AS AP
WHERE TA.nome = AP.tipo_aeroplano
ORDER BY rapporto DESC"))
res2 %>%
  tail(10) %>%
  ggplot( aes(codice, rapporto)) +
  geom_line() +
  geom_point()+ scale_x_continuous( breaks=c(89, 1211,2244, 3232, 4267, 5436, 6290,8765, 7466,5486,9965,6290,2770,2865))


res3 <- as_tibble(dbGetQuery(con, "SELECT GS.giorni AS giorni_settimana, COUNT(EI.codice) AS numero_voli
FROM giorni_settimana GS
LEFT JOIN effettuato_in EI ON GS.giorni = EI.giorni
GROUP BY GS.giorni
ORDER BY numero_voli DESC"))
res3 %>%
  ggplot(aes(x="", y=numero_voli, fill=giorni_settimana)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) 

