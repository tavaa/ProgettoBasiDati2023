-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema aeroporti software
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema aeroporti software
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `aeroporti software` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `aeroporti software` ;

-- -----------------------------------------------------
-- Table `aeroporti software`.`città`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`città` (
  `nome` VARCHAR(45) NOT NULL,
  `nazione` VARCHAR(45) NULL,
  PRIMARY KEY (`nome`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `aeroporti software`.`aeroporto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`aeroporto` (
  `codice` INT NOT NULL,
  CONSTRAINT 'codice_aeroporto_range' CHECK ('codice' >= 00000 AND 'codice' <= 99999),
  `nome` VARCHAR(45) NOT NULL,
  `città` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codice`),
  INDEX `città_idx` (`città` ASC) VISIBLE, 
  CONSTRAINT `città`
    FOREIGN KEY (`città`)
    REFERENCES `aeroporti software`.`città` (`nome`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `aeroporti software`.`tipo_aeroplano`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`tipo_aeroplano` (
  `nome` VARCHAR(45) NOT NULL,
  `azienda_costruttrice` VARCHAR(45) NULL,
  `autonomia_volo` INT NOT NULL,
  CONSTRAINT 'autonomia_volo_valida' CHECK ('autonomia_volo' > 0000 AND 'autonomia_volo' <= 9999),
  `n_posti_max` INT NOT NULL,
  CONSTRAINT 'n_posti_valido' CHECK ('n_posti_max' > 000 AND 'n_posti_max' <= 999),
  PRIMARY KEY (`nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`aeroplano`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`aeroplano` (
  `codice` INT NOT NULL,
  CONSTRAINT 'codice_aeroplano_valido' CHECK ('codice' > 0000 AND 'codice' <= 9999),
  `tipo_aeroplano` VARCHAR(45) NOT NULL,
  `n_posti_effettivi` INT NOT NULL,
  CONSTRAINT 'n_posti_valido' CHECK ('n_posti_effettivi' > 000 AND 'n_posti_effettivi' <= 999),
  PRIMARY KEY (`codice`),
  INDEX `tipo_aeroplano_idx` (`tipo_aeroplano` ASC) VISIBLE,
  CONSTRAINT `tipo_aeroplano`
    FOREIGN KEY (`tipo_aeroplano`)
    REFERENCES `aeroporti software`.`tipo_aeroplano` (`nome`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`atterra_decolla`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`atterra_decolla` (
  `codice_aeroporto` INT NOT NULL,
  CONSTRAINT 'codice_aeroporto_range' CHECK ('codice_aeroporto' >= 00000 AND 'codice_aeroporto' <= 99999),
  `tipo_aeroplano` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codice_aeroporto`, `tipo_aeroplano`),
  INDEX `tipo_aeroplano_idx` (`tipo_aeroplano` ASC) VISIBLE,
  CONSTRAINT `codice_aeroporto`
    FOREIGN KEY (`codice_aeroporto`)
    REFERENCES `aeroporti software`.`aeroporto` (`codice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `tipo_aeroplano`
    FOREIGN KEY (`tipo_aeroplano`)
    REFERENCES `aeroporti software`.`tipo_aeroplano` (`nome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`compagnia_aerea`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`compagnia_aerea` (
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`utilizzato_da`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`utilizzato_da` (
  `codice_aeroplano` INT NOT NULL,
  CONSTRAINT 'codice_aeroplano_valido' CHECK ('codice_aeroplano' > 0000 AND 'codice_aeroplano' <= 9999),
  `compagnia_aerea` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codice_aeroplano`, `compagnia_aerea`),
  INDEX `compagnia_aerea_idx` (`compagnia_aerea` ASC) VISIBLE,
  CONSTRAINT `codice_aeroplano`
    FOREIGN KEY (`codice_aeroplano`)
    REFERENCES `aeroporti software`.`aeroplano` (`codice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `compagnia_aerea`
    FOREIGN KEY (`compagnia_aerea`)
    REFERENCES `aeroporti software`.`compagnia_aerea` (`nome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`volo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`volo` (
  `codice` CHAR(6) NOT NULL,
  CONSTRAINT 'codice_volo_valido'  CHECK ('codice' REGEXP '^[A-Z]{2}[0-9]{4}$'),
  `compagnia_aerea` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codice`),
  INDEX `compagnia_aerea_idx` (`compagnia_aerea` ASC) VISIBLE,
  CONSTRAINT `compagnia_aerea`
    FOREIGN KEY (`compagnia_aerea`)
    REFERENCES `aeroporti software`.`compagnia_aerea` (`nome`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`giorni_settimana`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`giorni_settimana` (
  `giorni` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`giorni`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`effettuato_in`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`effettuato_in` (
  `codice` CHAR(6) NOT NULL,
  CONSTRAINT 'codice_volo_valido'  CHECK ('codice' REGEXP '^[A-Z]{2}[0-9]{4}$'),
  `giorni` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codice`, `giorni`),
  INDEX `giorni_idx` (`giorni` ASC) VISIBLE,
  CONSTRAINT `codice`
    FOREIGN KEY (`codice`)
    REFERENCES `aeroporti software`.`volo` (`codice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `giorni`
    FOREIGN KEY (`giorni`)
    REFERENCES `aeroporti software`.`giorni_settimana` (`giorni`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`classe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`classe` (
  `prezzo_biglietto` INT NOT NULL,
  CONSTRAINT 'prezzo_range' CHECK ('prezzo_biglietto' > 0 AND 'prezzo_biglietto' < 9999),
  `tipo_classe` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`tipo_classe`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`diviso_in`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`diviso_in` (
  `codice` CHAR(6) NOT NULL,
   CONSTRAINT 'codice_volo_valido'  CHECK ('codice' REGEXP '^[A-Z]{2}[0-9]{4}$'),
  `tipo_classe` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codice`, `tipo_classe`),
  INDEX `tipo_classe_idx` (`tipo_classe` ASC) VISIBLE,
  CONSTRAINT `codice`
    FOREIGN KEY (`codice`)
    REFERENCES `aeroporti software`.`volo` (`codice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `tipo_classe`
    FOREIGN KEY (`tipo_classe`)
    REFERENCES `aeroporti software`.`classe` (`tipo_classe`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`tratta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`tratta` (
  `numero_progressivo` INT NOT NULL,
  CONSTRAINT 'numero_tratta_range'  CHECK ('numero_progressivo' > 0 AND 'numero_progressivo' < 10),
  PRIMARY KEY (`numero_progressivo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`istanza_di_tratta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`istanza_di_tratta` (
  `data` DATE NOT NULL,
  `n_posti_disponibili` INT NOT NULL,
   CONSTRAINT 'n_posti_valido' CHECK ('n_posti_disponibili' > 000 AND 'n_posti_disponibili' <= 999),
  `codice` CHAR(6) NOT NULL,
  CONSTRAINT 'codice_volo_valido'  CHECK ('codice' REGEXP '^[A-Z]{2}[0-9]{4}$'),
  `numero` INT NOT NULL,
  CONSTRAINT 'numero_tratta_range'  CHECK ('numero' > 0 AND 'numero' < 10),
  PRIMARY KEY (`data`, `n_posti_disponibili`, `codice`, `numero`),
  INDEX `codice_idx` (`codice` ASC) VISIBLE,
  INDEX `numero_idx` (`numero` ASC) VISIBLE,
  CONSTRAINT `codice`
    FOREIGN KEY (`codice`)
    REFERENCES `aeroporti software`.`volo` (`codice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `numero`
    FOREIGN KEY (`numero`)
    REFERENCES `aeroporti software`.`tratta` (`numero_progressivo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`prenotazione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`prenotazione` (
  `nome` VARCHAR(45) NOT NULL,
  `cognome` VARCHAR(45) NOT NULL,
  `recapito_telefonico` INT NOT NULL,
  CONSTRAINT 'chk_numero_formato' CHECK ('recapito_telefonico' REGEXP '^[0-9]{12}$'),
  `posto_prenotato` CHAR(3) NOT NULL,
  CONSTRAINT 'formato_codice_posto_prenotato' CHECK ('posto_prenotato' REGEXP '^[0-9]{2}[A-Z]{1}$'),
  `data` DATE NOT NULL,
  PRIMARY KEY (`posto_prenotato`),
  INDEX `data_idx` (`data` ASC) VISIBLE,
  CONSTRAINT `data`
    FOREIGN KEY (`data`)
    REFERENCES `aeroporti software`.`istanza_di_tratta` (`data`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`partenza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`partenza` (
  `codice_aeroporto` INT NOT NULL,
  CONSTRAINT 'codice_aeroporto_range' CHECK ('codice_aeroporto' >= 00000 AND 'codice' <= 99999),
  `numero_progressivo` INT NOT NULL,
  CONSTRAINT 'numero_tratta_range'  CHECK ('numero_progressivo' > 0 AND 'numero_progressivo' < 10),
  `orario` DATETIME NOT NULL,
  PRIMARY KEY (`codice_aeroporto`, `numero_progressivo`),
  INDEX `numero_progressivo_idx` (`numero_progressivo` ASC) VISIBLE,
  CONSTRAINT `codice`
    FOREIGN KEY (`codice_aeroporto`)
    REFERENCES `aeroporti software`.`aeroporto` (`codice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `numero_progressivo`
    FOREIGN KEY (`numero_progressivo`)
    REFERENCES `aeroporti software`.`tratta` (`numero_progressivo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aeroporti software`.`arrivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aeroporti software`.`arrivo` (
  `codice_aeroporto` INT NOT NULL,
  CONSTRAINT 'codice_aeroporto_range' CHECK ('codice_aeroporto' >= 00000 AND 'codice' <= 99999),
  `numero_progressivo` INT NOT NULL,
  CONSTRAINT 'numero_tratta_range'  CHECK ('numero_progressivo' > 0 AND 'numero_progressivo' < 10),
  `orario` DATETIME NOT NULL,
  PRIMARY KEY (`codice_aeroporto`, `numero_progressivo`),
  INDEX `numero_progressivo_idx` (`numero_progressivo` ASC) VISIBLE,
  CONSTRAINT `codice_aeroporto`
    FOREIGN KEY (`codice_aeroporto`)
    REFERENCES `aeroporti software`.`aeroporto` (`codice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `numero_progressivo`
    FOREIGN KEY (`numero_progressivo`)
    REFERENCES `aeroporti software`.`tratta` (`numero_progressivo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;