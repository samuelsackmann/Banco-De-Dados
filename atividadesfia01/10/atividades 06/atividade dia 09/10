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



-----------------------------------------------------





CREATE TABLE tb_valor (
    nr_total NUMERIC(18,2),
    nr_valor NUMERIC(18,2),
    nr_percentual NUMERIC(18,2)
);


INSERT INTO tb_valor ( nr_valor, nr_percentual)
VALUES
    ( '44', '741'),
    ( '2', '316'),
   ( '56654', '741'),
    ( '274', '211'),
    ( '414', '741'),
    ( '212', '3162')

select * from tb_valor;

CREATE OR REPLACE FUNCTION fn_desconto(
    total NUMERIC,
    desconto NUMERIC
)
RETURNS NUMERIC(18,2)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN total * (desconto / 100);
END;
$$;

SELECT fn_desconto(100, 8);


--------------------------------------

CREATE OR REPLACE FUNCTION fn_calculadora(
    tecla NUMERIC,
    n1 NUMERIC,
    n2 NUMERIC
)
RETURNS NUMERIC(18,2)
LANGUAGE plpgsql
AS $$
BEGIN
    IF tecla = 1 THEN
        RETURN n1 + n2;

    ELSIF tecla = 2 THEN
        RETURN n1 - n2;

    ELSIF tecla = 3 THEN
        RETURN n1 * n2;

    ELSIF tecla = 4 THEN
 		RETURN n1 / n2;
        IF n2 = 0 THEN

            RAISE EXCEPTION 'Não é possível dividir por zero';
        END IF;

       

    ELSE







        RAISE EXCEPTION 'Tecla inválida';
    END IF;
END;
$$;

SELECT fn_calculadora(1, 100, 8);


CREATE OR REPLACE FUNCTION fn_custos(
    valor NUMERIC
)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF valor < 50 THEN
        RETURN 'Barato';

    ELSIF valor >= 50 AND valor <= 200 THEN
        RETURN 'Médio';

    ELSE
        RETURN 'Caro';
    END IF;
END;
$$;
SELECT fn_custos(50);

------------------------------------------


CREATE OR REPLACE FUNCTION fn_multiplica(
    valor NUMERIC
)
RETURNS NUMERIC(18,2)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN valor * 2;
END;
$$;

SELECT fn_multiplica(50);
-------------------------------------------

CREATE OR REPLACE FUNCTION fn_parimpar(
    valor NUMERIC
)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF valor % 2 = 0 THEN
        RETURN 'Numero e par';
    ELSE
        RETURN 'Numero e impar';
    END IF;
END;
$$;

SELECT fn_parimpar(50);
SELECT fn_parimpar(7);
----------------------------------------------

CREATE OR REPLACE FUNCTION fn_Notas(
    nr_valor NUMERIC
)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF nr_valor > 7 THEN
        RETURN 'aprovado';

    ELSIF nr_valor >= 5 AND nr_valor <= 7 THEN
        RETURN 'Recuperação';

    ELSE
        RETURN 'reprovado';
    END IF;
END;
$$;
SELECT fn_Notas(50);
-----------------------------------------------

CREATE OR REPLACE FUNCTION atividade_log_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO tb_atividade_log (
        tx_query,
        nr_idade,
        tx_mensagem,
        cd_atividade
    )
    VALUES (
        current_query(),
        EXTRACT(YEAR FROM AGE(OLD.dt_nascimento)),
        'Mensagem via trigger',
        NEW.id_atividade
    );

    RETURN NEW;
END;
$$;

-----------------------------------------

CREATE TRIGGER trg_atividade_update
BEFORE UPDATE ON tb_atividade
FOR EACH ROW
EXECUTE FUNCTION atividade_log_update();

-----------------------------------------

UPDATE tb_atividade
SET dt_nascimento = '1999-12-23'
WHERE id_atividade = 1;

-----------------------------------------

SELECT * FROM tb_atividade_log;

-----------------------------------------
DROP TABLE IF EXISTS tb_pagamento_log;
DROP SEQUENCE IF EXISTS id_pagamento;
--

CREATE SEQUENCE id_pagamento start 1 increment 1;
--
CREATE TABLE tb_pagamento_log (
    id_pagamento NUMERIC(18,0)
        DEFAULT nextval('id_pagamento') NOT NULL,
    tx_query VARCHAR(800),
    tx_forma VARCHAR(100),
    nr_valorantes NUMERIC(18,2),
    nr_valordepois NUMERIC(18,2),
    dt_modificacao TIMESTAMP DEFAULT NOW()
);
--
CREATE OR REPLACE FUNCTION pagamento_log()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.tx_forma := lower(NEW.tx_forma);

    INSERT INTO tb_pagamento_log (
        tx_query,
        tx_forma,
        nr_valorantes,
        nr_valordepois
    )
    VALUES (
        LEFT(current_query(), 800),
        NEW.tx_forma,
        OLD.vl_pagamento,
        NEW.vl_pagamento
    );

    RETURN NEW;
END;
$$;
--
DROP TRIGGER IF EXISTS trg_pagamento_log ON tb_pagamentos;
--
CREATE TRIGGER trg_pagamento_log
BEFORE INSERT OR UPDATE ON tb_pagamentos
FOR EACH ROW
EXECUTE FUNCTION pagamento_log();
--

INSERT INTO tb_pagamentos (
    cd_pedido,
    tx_forma,
    vl_pagamento,
    dt_pagamento
)
VALUES (
    1,
    UPPER('pix'),
    100.00,
    NOW()
);
--

SELECT *
FROM tb_pagamento_log;