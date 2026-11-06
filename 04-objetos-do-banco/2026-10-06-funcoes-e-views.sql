CREATE SEQUENCE sq_atividade START 1;
CREATE SEQUENCE sq_atividade_log START 1;

CREATE TABLE tb_atividade (
    id_atividade NUMERIC(18,0) PRIMARY KEY DEFAULT nextval('sq_atividade'),
    tx_nome VARCHAR(255) NOT NULL,
    dt_nascimento DATE NOT NULL,
    tx_genero VARCHAR(20) NOT NULL
);
drop table 

INSERT INTO tb_atividade (tx_nome, dt_nascimento, tx_genero)
VALUES
    ('Samuel', '2005-08-15', 'Masculino'),
    ('João', '2004-03-20', 'Masculino'),
    ('mocoto', '2006-11-10', 'Masculino'),
	   ('Ana', '2003-07-25', 'Feminino'),
    ('Carlos', '2005-01-12', 'Masculino'),
    ('Juliana', '2004-09-18', 'Feminino');

CREATE VIEW vw_atividade AS
SELECT *
FROM tb_atividade;

CREATE MATERIALIZED VIEW vw_atividadeM AS
SELECT *
FROM tb_atividade;

CREATE TABLE tb_atividade_log (
id_atividade_log NUMERIC(18,0) PRIMARY KEY DEFAULT nextval('sq_atividade_log'),
    tx_query VARCHAR(800),
    nr_idade NUMERIC(3,0),
    tx_mensagem VARCHAR(255),
    cd_atividade NUMERIC(18,0)
);
refresh materialized view vw_atividadeM;

drop function fn_nome;


CREATE FUNCTION fn_nome(valor numeric)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF (valor > 18) THEN
        RETURN 'maior de idade';

    ELSIF (valor = 18) THEN
        RETURN 'voce tem 18';

    ELSE
        RETURN 'menor de idade';

    END IF;

END
$$;

SELECT *, 
fn_nome(25),
fn_nome(18) FROM tb_atividade;


*select current_date,
age(dt_nascimento)

drop function fn_idade;

extract (year from age(dt_nascimento)
from tb_atividades

CREATE OR REPLACE FUNCTION fn_idade(dt_nascimento DATE)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
DECLARE
    idade NUMERIC;
BEGIN

    idade := EXTRACT(YEAR FROM AGE(dt_nascimento));
    
    IF (idade > 18) THEN
      return '  maior de idade';
    Elsif
 (idade = 18) THEN
 return  ' exatamente 18';
else
      return  '  menor de idade👅🦐';
    END IF;

END
$$;

SELECT *, 
fn_idade(dt_nascimento),
fn_idade('2026/02/02') FROM tb_atividade;


*select current_date,
age(dt_nascimento)