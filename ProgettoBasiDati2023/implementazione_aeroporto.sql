-- 5. IMPLEMENTAZIONE 

---------------- CREAZIONE DEI TRIGGER ---------------------------------

-- 1) Crea un trigger  controlla che l’aeroplano abbia effettivamente meno posti posti effettivi 
--    del numero massimo dei posti disponibili del tipo di aeroplano che lo caratterizza.


CREATE TRIGGER verifica_posti_effettivi
BEFORE INSERT OR UPDATE ON AEROPLANO
FOR EACH ROW
BEGIN
    DECLARE max_posti INT;
    
    SELECT numero_max_posti INTO max_posti
    FROM TIPO_AEROPLANO
    WHERE nome = NEW.tipo_aeroplano;
    
    IF NEW.n_posti_effettivi > max_posti THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: Numero posti effettivi supera il numero massimo di posti consentito';
    END IF;
END;


-- 2) Trigger  che controlla che i biglietti di un dato volo relativi alla stessa classe abbiano tutti lo stesso prezzo.

CREATE TRIGGER verifica_prezzo_biglietti
BEFORE INSERT OR UPDATE ON DIVISO_IN
FOR EACH ROW
BEGIN
    DECLARE classe_prezzo DECIMAL(10, 2);
    
    SELECT prezzo_biglietto INTO classe_prezzo
    FROM CLASSE
    WHERE tipo_classe = NEW.tipo_classe;
    
    IF EXISTS (
        SELECT *
        FROM DIVISO_IN AS d JOIN CLASSE AS c ON d.tipo_classe = c.tipo_classe
        WHERE d.codice = NEW.codice
          AND c.prezzo_biglietto <> classe_prezzo
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: I biglietti della stessa classe devono avere lo stesso prezzo';
    END IF;
END;

-------------POPOLAMENTO DELLA BASE DI DATI----------------------------

INSERT INTO città (nome, nazione)
VALUES ('Milano', 'Italy'),
       ('Roma', 'Italy'),
       ('New York City', 'Usa'),
       ('Frankfurt', 'Germany'),
       ('Paris', 'France'),
       ('Dubai', 'Emirates'),
       ('LA', 'Usa'),
       ('Sydney', 'Australia'),
       ('Hong Kong', 'HK' ),
       ('London', 'Uk');

INSERT INTO aeroporto (codice, nome, città)
VALUES ('00001', 'Malpensa airport', 'Milano'),
       ('00002', 'Fiumicino airport', 'Roma'),
       ('00003', 'Jfk airport', 'New York City'),
       ('00004', 'Frankfurt airport', 'Frankfurt'),
       ('00005', 'Ashford airport', 'London'),
       ('00006', 'Linate Airport', 'Milano'),
       ('00007', 'Heathrow Airport', 'London'),
       ('00008', 'Charles de Gaulle Airport', 'Paris'),
       ('00009', 'Dubai International Airport', 'Dubai'),
       ('00010', 'Los Angeles International Airport', 'LA'),
       ('00011', 'Sydney Kingsford Smith Airport', 'Sydney'),
       ('00012', 'Hong Kong Airport', 'Hong Kong');

INSERT INTO tipo_aeroplano (nome, azienda_costruttrice, autonomia_volo, n_posti_max)
VALUES ('CRJ','Mitsubishi Heavy Industries', '2491', '50' ),
       ('ATR','ATR Industries', '1370', '78' ),
       ('Boeing 717', 'The Boeing Company', '2648', '117' ),
       ('Boeing 737', 'The Boeing Company', '2988', '147'),
       ('Airbus A380', 'Airbus Company', '2500', '120');

 INSERT INTO aeroplano (codice, tipo_aeroplano, n_posti_effettivi)
VALUES ('2770','CRJ','46'),
       ('2865','ATR','78'),
       ('5436','ATR', '70'),
       ('6290','Boeing 717','100'),
       ('9965','Boeing 717','95'),
       ('5436','CRJ', '32'); 
       ('3232', 'Boeing 737', '55'),
       ('4267', 'Boeing 737', '100'),
       ('8765', 'Boeing 737', '100'),
       ('2244', 'Airbus A380', '119'),
       ('1211', 'CRJ', '46'),
       ('0089', 'Airbus A380', '119' );

INSERT INTO atterra_decolla (codice_aeroporto, tipo_aeroplano)
VALUES ('00001', 'ATR'),
       ('00001', 'CRJ'),
       ('00001', 'Boeing 717'),
       ('00002', 'Airbus A380'),
       ('00002', 'CRJ'),
       ('00002', 'ATR'),
       ('00002', 'Boeing 717'),
       ('00003', 'CRJ'),
       ('00003', 'ATR'),
       ('00004', 'Boeing 717'),
       ('00004', 'Boeing 737'),
       ('00005', 'ATR'),
       ('00005', 'Airbus A380'),
       ('00005', 'Boeing 737'),
       ('00005', 'CRJ'),
       ('00005', 'Boeing 717'),
       ('00006', 'ATR'),
       ('00006', 'CRJ'),
       ('00007', 'ATR'),
       ('00008', 'Boeing 717'),
       ('00008', 'Boeing 713'),
       ('00008', 'ATR'),
       ('00009', 'ATR'),
       ('00009', 'CRJ'),
       ('00009', 'Airbus A380'),
       ('00009', 'Boeing 733'),
       ('00010', 'Boeing 713'),
       ('00010', 'CRJ'),
       ('00010', 'Airbus A380'),
       ('00010', 'ATR'),
       ('00011', 'Airbus A380'),
       ('00011', 'ATR'),
       ('00012', 'Airbus A380');


 INSERT INTO compagnia_aerea (nome)
VALUES ('Lufthansa'),
       ('Easyjet'),
       ('Ryanair'), 
       ('Emirates'),
       ('ItaAirway');

 INSERT INTO utilizzato_da (codice_aeroplano, compagnia_aerea)
VALUES ('2770','Lufthansa'),
       ('2865','EasyJet'),
       ('5436','Ryanair');  
       ('6290','Ryanair'),
       ('9965','ItaAirways'),
       ('5436','Easyjet');

INSERT INTO volo (codice, compagnia_aerea)
VALUES ('LU3200', 'Lufthansa'),
       ('EJ4671', 'Easyjet'),
       ('EJ7635', 'Easyjet'), 
       ('RA8765', 'Ryanair'),
       ('LU3260', 'Lufthansa'),
       ('EM8822', 'Emirates'),
       ('EJ0022', 'Easyjet'),
       ('EJ2972', 'Easyjet'),
       ('EJ1011', 'Easyjet'),
       ('EM0923', 'Emirates'), 
       ('EM7766', 'Emirates'),
       ('LU9203', 'Lufthansa'),
       ('RA3333', 'Ryanair'),
       ('EJ4563', 'Easyjet'), 
       ('RA0001', 'Ryanair');

INSERT INTO giorni_settimana (giorni)
VALUES ('Lunedì'),
       ('Martedì'),
       ('Mercoledì'), 
       ('Giovedì'),
       ('Venerdì'),
       ('Sabato'),
       ('Domenica');

INSERT INTO effettuato_in (codice, giorni)
VALUES ('LU3200', 'Lunedì'),
       ('LU3200', 'Martedì'),
       ('LU3200', 'Giovedì'),
       ('LU3200', 'Sabato'),
       ('EJ4671', 'Lunedì'),
       ('EJ4671', 'Venerdì'),
       ('EJ4671', 'Domenica'),
       ('EJ7635', 'Martedì'),
       ('EJ7635', 'Mercoledì'),
       ('RA8765', 'Lunedì'),  
       ('RA8765', 'Martedì'),
       ('RA8765', 'Giovedì'), 
       ('RA8765', 'Venerdì'),
       ('LU3260', 'Lunedì'),
       ('LU3260', 'Martedì'),
       ('LU3260', 'Domenica'),
       ('EM8822', 'Giovedì'),
       ('EM8822', 'Venerdì'),
       ('EJ0022', 'Lunedì'),
       ('EJ0022', 'Martedì'),
       ('EJ0022', 'Domenica'),
       ('EJ2972', 'Venerdì'),
       ('EJ2972', 'Sabato'),
       ('EJ1011', 'Martedì'),
       ('EJ1011', 'Mercoledì'),
       ('EJ1011', 'Venerdì'),
       ('EJ1011', 'Sabato'),
       ('EM0923', 'Martedì'),
       ('EM7766', 'Lunedì'),
       ('EM7766', 'Martedì'),
       ('EM7766', 'Giovedì'),
       ('EM7766', 'Sabato'),
       ('EM7766', 'Domenica'),
       ('LU9203', 'Lunedì'),
       ('LU9203', 'Mercoledì'),
       ('LU9203', 'Sabato'),
       ('LU9203', 'Domenica'),
       ('RA3333', 'Martedì'),
       ('RA3333', 'Giovedì'),
       ('EJ4563', 'Lunedì'),
       ('EJ4563', 'Martedì'),
       ('EJ4563', 'Mercoledì'),
       ('EJ4563', 'Giovedì'),
       ('EJ4563', 'Venerdì'),
       ('RA0001', 'Sabato');
       ('RA0001', 'Domenica');



INSERT INTO classe (prezzo_biglietto, tipo_classe)
VALUES ('70', 'Business'),
       ('200', 'First class'),
       ('30', 'Economy'), 
       ('40', 'Standard');

INSERT INTO diviso_in (codice, tipo_classe)
VALUES ('RF3200', 'Economy'),
       ('RF3200', 'Business'),
       ('EJ4671', 'Business'),
       ('EJ4671', 'Standard'),
       ('EJ7635', 'First class'), 
       ('RA8765', 'Standard');

INSERT INTO tratta (numero_progressivo)
VALUES ('1'),
       ('2'),
       ('3'), 
       ('4'),
       ('5');

INSERT INTO istanza_di_tratta (data, n_posti_disponibili, codice, numero)
VALUES ('2023/05/17','44', 'EJ4671', '3'),
       ('2023/05/17','83', 'EJ7635', '4' ),
       ('2023/11/28','2', 'LU3200', '1' ),
       ('2023/10/27', '22','RA8765', '1' );

INSERT INTO prenotazione (nome, cognome, recapito_telefonico, posto_selezionato, data)
VALUES ('Matt','Black', '393459651494', '20B', '2023/05/17' ),
       ('Sam','White', '393352401485', '02A', '2023/11/28' ),
       ('Dem', 'Gray','39398071225', '15C', '2023/10/27' ),
       ('Alex','Blue', '393209805452', '02A', '2023/07/08' );

 INSERT INTO arrivo (codice_aeroporto, numero_progressivo, orario)
VALUES ('00001', '3', '2023/05/17 10:00:00'),
       ('00003', '4', '2023/05/17 04:00:00'),
       ('00004', '1', '2023/11/28 14:00:00'),
       ('00005', '1', '2023/10/27 9:00:00');
       
 INSERT INTO partenza (codice_aeroporto, numero_progressivo, orario)
VALUES ('00001', '4', '2023/05/17 8:00:00'),
       ('00003', '2', '2023/11/28 16:00:00'),
       ('00004', '3', '2023/05/17 20:00:00');

------------------  QUERY ---------------------------------------------------------------

--1) Visualizza, per ogni aeroporto i tipi di aeroplano che vi possono atterrare o decollare.

SELECT A.codice, A.nome, AD.tipo_aeroplano
FROM aeroporto as A, atterra_decolla as AD
WHERE A.codice = AD.codice_aeroporto
GROUP BY A.codice, A.nome, AD.tipo_aeroplano
ORDER BY A.codice, AD.tipo_aeroplano


--2) Determinare quali tipi di aeroplani hanno un rapporto di numero_max_posti e n.posti_effettivi migliore.

SELECT TA.nome, AP.codice, TA.n_posti_max/AP.n_posti_effettivi AS rapporto
FROM tipo_aeroplano AS TA, Aeroplano AS AP
WHERE TA.nome = AP.tipo_aeroplano
ORDER BY rapporto DESC

--3) Determinare quali sono i giorni della settimana dove vengono effettuati più voli.

SELECT GS.giorni AS giorni_settimana, COUNT(EI.codice) AS numero_voli
FROM giorni_settimana GS
LEFT JOIN effettuato_in EI ON GS.giorni = EI.giorni
GROUP BY GS.giorni
ORDER BY numero_voli DESC;