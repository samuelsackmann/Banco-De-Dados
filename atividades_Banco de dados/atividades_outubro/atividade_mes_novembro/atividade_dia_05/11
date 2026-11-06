CREATE DATABASE assinaturas;
\c assinaturas
-- ---------- ESTRUTURA ----------
CREATE TABLE tb_planos (
id_plano SERIAL PRIMARY KEY,
tx_nome VARCHAR(50) NOT NULL,
vl_mensalidade NUMERIC(10,2) NOT NULL CHECK (vl_mensalidade > 0),
nr_limite_usuarios INT NOT NULL
);
CREATE TABLE tb_clientes (
id_cliente SERIAL PRIMARY KEY,
tx_nome VARCHAR(100) NOT NULL,
tx_email VARCHAR(100) NOT NULL UNIQUE,
cd_plano INT NOT NULL REFERENCES tb_planos(id_plano),
fl_ativo BOOLEAN NOT NULL DEFAULT TRUE,
dt_cadastro DATE NOT NULL
);
CREATE TABLE tb_cobrancas (
id_cobranca SERIAL PRIMARY KEY,
cd_cliente INT NOT NULL REFERENCES tb_clientes(id_cliente),
tx_mes CHAR(7) NOT NULL, -- 'AAAA-MM'
vl_cobranca NUMERIC(10,2) NOT NULL CHECK (vl_cobranca >= 0)
);
CREATE TABLE tb_pagamentos (
id_pagamento SERIAL PRIMARY KEY,
cd_cobranca INT NOT NULL REFERENCES tb_cobrancas(id_cobranca),
dt_pagamento DATE NOT NULL,
vl_pago NUMERIC(10,2) NOT NULL CHECK (vl_pago > 0),
tx_forma VARCHAR(10) NOT NULL CHECK (tx_forma IN ('PIX','CARTAO','BOLETO'))
);
-- ---------- DADOS ----------
INSERT INTO tb_planos (tx_nome, vl_mensalidade, nr_limite_usuarios) VALUES
('Básico', 29.90, 1),
('Padrão', 59.90, 5),
('Premium', 99.90, 20);
INSERT INTO tb_clientes (tx_nome, tx_email, cd_plano, fl_ativo, dt_cadastro) VALUES
('Ana Souza', 'ana@email.com', 3, TRUE, '2026-01-10'),
('Bruno Lima', 'bruno@email.com', 2, TRUE, '2026-02-15'),
('Carla Dias', 'carla@email.com', 1, TRUE, '2026-03-20'),
('Diego Alves', 'diego@email.com', 1, FALSE, '2026-03-25'),
('Elisa Rocha', 'elisa@email.com', 3, TRUE, '2026-04-05'),
('Fábio Mendes', 'fabio@email.com', 2, TRUE, '2026-05-12'),
('Gabriela Nunes', 'gabriela@email.com', 2, TRUE, '2026-06-18'),
('Henrique Costa', 'henrique@email.com', 3, FALSE, '2026-07-01'),
('Isabela Freitas', 'isabela@email.com', 1, TRUE, '2026-08-09'),
('João Pedro Silva', 'joao@email.com', 2, TRUE, '2026-09-14');
-- Inserir nesta ordem (ids 1 a 26 são usados em tb_pagamentos)
INSERT INTO tb_cobrancas (cd_cliente, tx_mes, vl_cobranca) VALUES
-- Setembro/2026 (ids 1 a 8)
(1,'2026-09', 99.90), (2,'2026-09', 59.90), (3,'2026-09', 29.90), (4,'2026-09', 29.90),
(5,'2026-09', 99.90), (6,'2026-09', 59.90), (7,'2026-09', 59.90), (8,'2026-09', 99.90),
-- Outubro/2026 (ids 9 a 19) - alguns clientes têm cobrança extra
(1,'2026-10', 99.90), (1,'2026-10',200.00),
(2,'2026-10', 59.90), (2,'2026-10',200.00),
(3,'2026-10', 29.90), (3,'2026-10',100.00),
(5,'2026-10', 99.90), (6,'2026-10', 59.90),
(7,'2026-10', 59.90), (9,'2026-10', 29.90),
(10,'2026-10',59.90),
-- Agosto/2026 (ids 20 a 26)
(1,'2026-08', 99.90), (2,'2026-08', 59.90), (3,'2026-08', 29.90), (4,'2026-08', 29.90),
(5,'2026-08', 99.90), (6,'2026-08', 59.90), (8,'2026-08', 99.90);
-- Cobranças sem pagamento: 4, 8, 12, 14, 17
INSERT INTO tb_pagamentos (cd_cobranca, dt_pagamento, vl_pago, tx_forma) VALUES
( 1,'2026-09-05', 99.90,'PIX'), ( 2,'2026-09-06', 59.90,'CARTAO'),
( 3,'2026-09-10', 29.90,'BOLETO'), ( 5,'2026-09-05', 99.90,'CARTAO'),
( 6,'2026-09-12', 59.90,'PIX'), ( 7,'2026-09-08', 59.90,'PIX'),
( 9,'2026-10-05', 99.90,'PIX'), (10,'2026-10-06',200.00,'CARTAO'),
(11,'2026-10-07', 59.90,'BOLETO'), (13,'2026-10-10', 29.90,'PIX'),
(15,'2026-10-05', 99.90,'CARTAO'), (16,'2026-10-09', 59.90,'PIX'),
(18,'2026-10-12', 29.90,'BOLETO'), (19,'2026-10-15', 59.90,'PIX'),
(20,'2026-08-05', 99.90,'PIX'), (21,'2026-08-07', 59.90,'CARTAO'),
(22,'2026-08-10', 29.90,'BOLETO'), (23,'2026-08-12', 29.90,'BOLETO'),
(24,'2026-08-05', 99.90,'CARTAO'), (25,'2026-08-09', 59.90,'PIX'),
(26,'2026-08-06', 99.90,'PIX');

SELECT
    tx_nome AS tx_cliente,
    id_plano AS tx_plano,
    MAX(vl_cobranca) AS maior_cobranca,
    SUM(vl_cobranca) AS vl_cobrado,
    SUM(vl_pago) AS vl_pago,
    sum(vl_cobranca - vl_pago) AS em_aberto,a
    MIN(dt_pagamento) AS primeiro_pago,
    MAX(dt_pagamento) AS ultimo_pago
FROM tb_clientes
INNER JOIN tb_planos
    ON cd_plano = id_plano
LEFT JOIN tb_cobrancas
    ON id_cliente = cd_cliente
LEFT JOIN tb_pagamentos
    ON id_cobranca = cd_cobranca
GROUP BY
    id_cliente,
    tx_nome,
    id_plano,
    vl_cobranca
ORDER BY tx_nome ASC;
-----------------------------------------------------------------------------
SELECT
    tb_clientes.tx_nome AS tx_cliente,
    tb_planos.tx_nome AS tx_plano,
    MAX(tb_cobrancas.vl_cobranca) AS maior_cobranca,
    SUM(tb_cobrancas.vl_cobranca) AS vl_cobrado,
    SUM(tb_pagamentos.vl_pago) AS vl_pago,
    SUM(tb_cobrancas.vl_cobranca) - SUM(tb_pagamentos.vl_pago) AS em_aberto,
    MIN(tb_pagamentos.dt_pagamento) AS primeiro_pago,
    MAX(tb_pagamentos.dt_pagamento) AS ultimo_pago
FROM tb_clientes
INNER JOIN tb_planos
    ON tb_clientes.cd_plano = tb_planos.id_plano
LEFT JOIN tb_cobrancas
    ON tb_clientes.id_cliente = tb_cobrancas.cd_cliente
LEFT JOIN tb_pagamentos
    ON tb_cobrancas.id_cobranca = tb_pagamentos.cd_cobranca
GROUP BY
    tb_clientes.id_cliente,
    tb_clientes.tx_nome,
    tb_planos.tx_nome
ORDER BY tb_clientes.tx_nome ASC;