-- =============================================================================
-- PROJETO: Sistema de Gerenciamento de E-Sports
-- DISCIPLINA: Modelagem de Banco de Dados - UMC (Universidade Mogi das Cruzes)
-- DESENVOLVEDORES: João Victor Silva Santos e equipe
-- SGBD: MySQL 8.0+
-- DESCRIÇÃO: Criação de schema, tabelas normalizadas (3FN), constraints e DML.
-- =============================================================================

DROP DATABASE IF EXISTS gerenciamento_esports;

CREATE DATABASE gerenciamento_esports
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE gerenciamento_esports;

-- -----------------------------------------------------------------------------
-- 1. TABELA: TREINADOR
-- -----------------------------------------------------------------------------
CREATE TABLE TREINADOR (
    Cod_Registo INT AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Data_Contratacao DATE NOT NULL,
    CONSTRAINT pk_treinador PRIMARY KEY (Cod_Registo)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 2. TABELA: EQUIPE (Relacionamento 1:1 com Treinador via UNIQUE na FK)
-- -----------------------------------------------------------------------------
CREATE TABLE EQUIPE (
    Nome_Oficial VARCHAR(100) NOT NULL,
    Data_Fundacao DATE NOT NULL,
    Cod_Registo_Treinador INT NOT NULL,
    CONSTRAINT pk_equipe PRIMARY KEY (Nome_Oficial),
    CONSTRAINT uk_treinador_equipe UNIQUE (Cod_Registo_Treinador),
    CONSTRAINT fk_equipe_treinador FOREIGN KEY (Cod_Registo_Treinador)
        REFERENCES TREINADOR (Cod_Registo)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 3. TABELA: TELEFONE_EQUIPE (Resolução de atributo multivalorado - PK composta)
-- -----------------------------------------------------------------------------
CREATE TABLE TELEFONE_EQUIPE (
    Nome_Oficial_Equipe VARCHAR(100) NOT NULL,
    Numero_Telefone VARCHAR(20) NOT NULL,
    CONSTRAINT pk_telefone_equipe PRIMARY KEY (Nome_Oficial_Equipe, Numero_Telefone),
    CONSTRAINT fk_telefone_equipe FOREIGN KEY (Nome_Oficial_Equipe)
        REFERENCES EQUIPE (Nome_Oficial)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 4. TABELA: JOGADOR (Atributos atômicos e vínculo 1:N com Equipe)
-- -----------------------------------------------------------------------------
CREATE TABLE JOGADOR (
    CPF CHAR(11) NOT NULL,
    Nickname VARCHAR(50) NOT NULL,
    Data_Nascimento DATE NOT NULL,
    Primeiro_Nome VARCHAR(50) NOT NULL,
    Sobrenome VARCHAR(100) NOT NULL,
    Nome_Oficial_Equipe VARCHAR(100) NOT NULL,
    CONSTRAINT pk_jogador PRIMARY KEY (CPF),
    CONSTRAINT uk_jogador_nickname UNIQUE (Nickname),
    CONSTRAINT fk_jogador_equipe FOREIGN KEY (Nome_Oficial_Equipe)
        REFERENCES EQUIPE (Nome_Oficial)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 5. TABELA: TORNEIO
-- -----------------------------------------------------------------------------
CREATE TABLE TORNEIO (
    Codigo_Torneio INT AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Premiacao DECIMAL(10, 2) NOT NULL,
    Data_Inicio DATE NOT NULL,
    CONSTRAINT pk_torneio PRIMARY KEY (Codigo_Torneio),
    CONSTRAINT uk_torneio_nome UNIQUE (Nome)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 6. TABELA: PARTIDA (Relacionamento 1:N com Torneio)
-- -----------------------------------------------------------------------------
CREATE TABLE PARTIDA (
    Codigo_Partida INT AUTO_INCREMENT,
    Data DATE NOT NULL,
    Hora TIME NOT NULL,
    Resultado VARCHAR(50) DEFAULT 'Pendente',
    Codigo_Torneio INT NOT NULL,
    CONSTRAINT pk_partida PRIMARY KEY (Codigo_Partida),
    CONSTRAINT fk_partida_torneio FOREIGN KEY (Codigo_Torneio)
        REFERENCES TORNEIO (Codigo_Torneio)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 7. TABELA: EQUIPE_TORNEIO (Tabela Associativa N:N com PK Composta)
-- -----------------------------------------------------------------------------
CREATE TABLE EQUIPE_TORNEIO (
    Nome_Oficial_Equipe VARCHAR(100) NOT NULL,
    Codigo_Torneio INT NOT NULL,
    CONSTRAINT pk_equipe_torneio PRIMARY KEY (Nome_Oficial_Equipe, Codigo_Torneio),
    CONSTRAINT fk_et_equipe FOREIGN KEY (Nome_Oficial_Equipe)
        REFERENCES EQUIPE (Nome_Oficial)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_et_torneio FOREIGN KEY (Codigo_Torneio)
        REFERENCES TORNEIO (Codigo_Torneio)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =============================================================================
-- CARGA DE DADOS DE TESTE (DML - INSERT)
-- =============================================================================

INSERT INTO TREINADOR (Cod_Registo, Nome, Data_Contratacao) VALUES
(1, 'Matheus Tarasconi', '2023-01-15'),
(2, 'Nicholas Nogueira', '2022-05-20'),
(3, 'Pedro Luis', '2024-02-10');

INSERT INTO EQUIPE (Nome_Oficial, Data_Fundacao, Cod_Registo_Treinador) VALUES
('LOUD', '2019-02-28', 1),
('FURIA Esports', '2017-08-10', 2),
('MIBR', '2003-03-01', 3);

INSERT INTO TELEFONE_EQUIPE (Nome_Oficial_Equipe, Numero_Telefone) VALUES
('LOUD', '11988881111'),
('LOUD', '11988882222'),
('FURIA Esports', '11977773333'),
('MIBR', '11966664444');

INSERT INTO JOGADOR (CPF, Nickname, Data_Nascimento, Primeiro_Nome, Sobrenome, Nome_Oficial_Equipe) VALUES
('12345678901', 'cauanzin', '2005-06-09', 'Cauan', 'Pereira', 'LOUD'),
('23456789012', 'Less', '2005-02-25', 'Felipe', 'Basso', 'LOUD'),
('34567890123', 'mwzera', '2001-06-25', 'Leonardo', 'Serrati', 'FURIA Esports'),
('45678901234', 'artzin', '2003-09-12', 'Arthur', 'Araújo', 'MIBR');

INSERT INTO TORNEIO (Codigo_Torneio, Nome, Premiacao, Data_Inicio) VALUES
(1, 'VCT Americas Kickoff', 250000.00, '2026-02-16'),
(2, 'Valorant Champions Tour Masters', 500000.00, '2026-05-10'),
(3, 'Copa Brasil de E-Sports', 100000.00, '2026-09-01');

INSERT INTO PARTIDA (Codigo_Partida, Data, Hora, Resultado, Codigo_Torneio) VALUES
(1, '2026-02-16', '16:00:00', 'LOUD 2 x 1 FURIA Esports', 1),
(2, '2026-02-17', '19:00:00', 'MIBR 2 x 0 FURIA Esports', 1),
(3, '2026-05-12', '15:00:00', 'LOUD 2 x 0 MIBR', 2);

INSERT INTO EQUIPE_TORNEIO (Nome_Oficial_Equipe, Codigo_Torneio) VALUES
('LOUD', 1),
('FURIA Esports', 1),
('MIBR', 1),
('LOUD', 2);
