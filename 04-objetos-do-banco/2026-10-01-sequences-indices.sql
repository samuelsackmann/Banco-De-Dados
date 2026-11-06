-- ---------------------------------------------------------------------
-- 1. Sequences
-- ---------------------------------------------------------------------
CREATE SEQUENCE sq_usuario     START 1;
CREATE SEQUENCE sq_endereco    START 1;
CREATE SEQUENCE sq_categoria   START 1;
CREATE SEQUENCE sq_produto     START 1;
CREATE SEQUENCE sq_pedido      START 1;
CREATE SEQUENCE sq_item_pedido START 1;
CREATE SEQUENCE sq_pagamento   START 1;

-- ---------------------------------------------------------------------
-- 2. Tabelas
-- ---------------------------------------------------------------------
CREATE TABLE tb_usuarios (
    id_usuario   numeric(18,0) PRIMARY KEY DEFAULT nextval('sq_usuario'),
    tx_nome      varchar(255)  NOT NULL,
    tx_email     varchar(255)  NOT NULL,
    tx_cpf       varchar(255)  NOT NULL,
    nr_idade     numeric(18,0) NOT NULL,
    fl_ativo     boolean       NOT NULL DEFAULT true,
    dt_cadastro  timestamp     NOT NULL DEFAULT now()
);

CREATE TABLE tb_enderecos (
    id_endereco    numeric(18,0) PRIMARY KEY DEFAULT nextval('sq_endereco'),
    cd_usuario     numeric(18,0) NOT NULL REFERENCES tb_usuarios (id_usuario),
    tx_logradouro  varchar(255)  NOT NULL,
    nr_numero      numeric(18,0) NOT NULL,
    tx_cidade      varchar(255)  NOT NULL,
    tx_uf          varchar(255)  NOT NULL,
    tx_cep         varchar(255)  NOT NULL,
    fl_principal   boolean       NOT NULL DEFAULT false
);

CREATE TABLE tb_categorias (
    id_categoria  numeric(18,0) PRIMARY KEY DEFAULT nextval('sq_categoria'),
    tx_nome       varchar(255)  NOT NULL,
    tx_descricao  varchar(255),
    fl_ativo      boolean       NOT NULL DEFAULT true
);

CREATE TABLE tb_produtos (
    id_produto    numeric(18,0) PRIMARY KEY DEFAULT nextval('sq_produto'),
    cd_categoria  numeric(18,0) NOT NULL REFERENCES tb_categorias (id_categoria),
    tx_nome       varchar(255)  NOT NULL,
    tx_descricao  varchar(255),
    vl_preco      numeric(18,3) NOT NULL,
    nr_estoque    numeric(18,0) NOT NULL,
    fl_ativo      boolean       NOT NULL DEFAULT true,
    dt_cadastro   timestamp     NOT NULL DEFAULT now()
);

CREATE TABLE tb_pedidos (
    id_pedido   numeric(18,0) PRIMARY KEY DEFAULT nextval('sq_pedido'),
    cd_usuario  numeric(18,0) NOT NULL REFERENCES tb_usuarios (id_usuario),
    tx_status   varchar(255)  NOT NULL,
    vl_total    numeric(18,3) NOT NULL DEFAULT 0,
    fl_pago     boolean       NOT NULL DEFAULT false,
    dt_pedido   timestamp     NOT NULL
);

CREATE TABLE tb_itens_pedido (
    id_item_pedido  numeric(18,0) PRIMARY KEY DEFAULT nextval('sq_item_pedido'),
    cd_pedido       numeric(18,0) NOT NULL REFERENCES tb_pedidos (id_pedido),
    cd_produto      numeric(18,0) NOT NULL REFERENCES tb_produtos (id_produto),
    nr_quantidade   numeric(18,0) NOT NULL,
    vl_unitario     numeric(18,3) NOT NULL,
    vl_desconto     numeric(18,3) NOT NULL DEFAULT 0
);

CREATE TABLE tb_pagamentos (
    id_pagamento  numeric(18,0) PRIMARY KEY DEFAULT nextval('sq_pagamento'),
    cd_pedido     numeric(18,0) NOT NULL REFERENCES tb_pedidos (id_pedido),
    tx_forma      varchar(255)  NOT NULL,
    vl_pagamento  numeric(18,3) NOT NULL,
    dt_pagamento  timestamp     NOT NULL
);

ALTER SEQUENCE sq_usuario     OWNED BY tb_usuarios.id_usuario;
ALTER SEQUENCE sq_endereco    OWNED BY tb_enderecos.id_endereco;
ALTER SEQUENCE sq_categoria   OWNED BY tb_categorias.id_categoria;
ALTER SEQUENCE sq_produto     OWNED BY tb_produtos.id_produto;
ALTER SEQUENCE sq_pedido      OWNED BY tb_pedidos.id_pedido;
ALTER SEQUENCE sq_item_pedido OWNED BY tb_itens_pedido.id_item_pedido;
ALTER SEQUENCE sq_pagamento   OWNED BY tb_pagamentos.id_pagamento;

-- ---------------------------------------------------------------------
-- 3. Carga de dados (volumes, todos >= 20k)
--    tb_usuarios       50.000
--    tb_enderecos      60.000
--    tb_categorias     20.000
--    tb_produtos      100.000
--    tb_pedidos       200.000
--    tb_itens_pedido  500.000
--    tb_pagamentos    ~140.000 (pedidos pagos)
-- ---------------------------------------------------------------------

-- Usuários
INSERT INTO tb_usuarios (tx_nome, tx_email, tx_cpf, nr_idade, fl_ativo, dt_cadastro)
SELECT
    (ARRAY['Ana','Bruno','Carlos','Daniela','Eduardo','Fernanda','Gabriel','Helena','Igor','Juliana'])[1 + (g % 10)]
      || ' ' ||
    (ARRAY['Silva','Souza','Oliveira','Santos','Pereira','Costa','Rodrigues','Almeida','Nascimento','Lima'])[1 + ((g / 10) % 10)]
      || ' ' || g,
    'usuario' || g || '@exemplo.com',
    lpad(g::text, 11, '0'),
    18 + floor(random() * 63),
    random() > 0.10,
    now() - make_interval(days => (random() * 1825)::int)
FROM generate_series(1, 50000) g;

-- Endereços
INSERT INTO tb_enderecos (cd_usuario, tx_logradouro, nr_numero, tx_cidade, tx_uf, tx_cep, fl_principal)
SELECT
    1 + floor(random() * 50000),
    'Rua ' || (ARRAY['das Flores','Central','XV de Novembro','Sete de Setembro','das Palmeiras'])[1 + (g % 5)],
    1 + floor(random() * 2000),
    (ARRAY['São Miguel d''Oeste','Chapecó','Florianópolis','Joinville','Blumenau','Curitiba','Porto Alegre','São Paulo','Cascavel','Maringá'])[s.i],
    (ARRAY['SC','SC','SC','SC','SC','PR','RS','SP','PR','PR'])[s.i],
    lpad((floor(random() * 99999999))::text, 8, '0'),
    random() > 0.5
FROM (SELECT g, 1 + floor(random() * 10)::int AS i FROM generate_series(1, 60000) g) s;

-- Categorias
INSERT INTO tb_categorias (tx_nome, tx_descricao, fl_ativo)
SELECT
    'Categoria ' || g,
    'Descrição da categoria ' || g,
    random() > 0.05
FROM generate_series(1, 20000) g;

-- Produtos
INSERT INTO tb_produtos (cd_categoria, tx_nome, tx_descricao, vl_preco, nr_estoque, fl_ativo, dt_cadastro)
SELECT
    1 + floor(random() * 20000),
    (ARRAY['Notebook','Mouse','Teclado','Monitor','Cadeira','Mesa','Headset','Webcam','Impressora','Roteador'])[1 + (g % 10)] || ' modelo ' || g,
    'Descrição detalhada do produto ' || g,
    round((5 + random() * 4995)::numeric, 2),
    floor(random() * 1000),
    random() > 0.08,
    now() - make_interval(days => (random() * 1095)::int)
FROM generate_series(1, 100000) g;

-- Pedidos
INSERT INTO tb_pedidos (cd_usuario, tx_status, vl_total, fl_pago, dt_pedido)
SELECT
    1 + floor(random() * 50000),
    s.status,
    0,
    s.status IN ('PAGO','ENVIADO','ENTREGUE'),
    now() - make_interval(days => (random() * 1095)::int, secs => (random() * 86400)::int)
FROM (
    SELECT (ARRAY['PENDENTE','PAGO','ENVIADO','ENTREGUE','CANCELADO'])[1 + floor(random() * 5)::int] AS status
    FROM generate_series(1, 200000)
) s;

-- Itens do pedido
INSERT INTO tb_itens_pedido (cd_pedido, cd_produto, nr_quantidade, vl_unitario, vl_desconto)
SELECT
    s.cd_pedido,
    s.cd_produto,
    s.qtd,
    s.preco,
    round((random() * 0.2 * s.qtd * s.preco)::numeric, 2)
FROM (
    SELECT
        1 + floor(random() * 200000)          AS cd_pedido,
        1 + floor(random() * 100000)          AS cd_produto,
        1 + floor(random() * 10)              AS qtd,
        round((5 + random() * 995)::numeric, 2) AS preco
    FROM generate_series(1, 500000)
) s;

-- Total dos pedidos (a partir dos itens)
UPDATE tb_pedidos p
   SET vl_total = t.total
  FROM (
        SELECT cd_pedido, SUM(nr_quantidade * vl_unitario - vl_desconto) AS total
          FROM tb_itens_pedido
         GROUP BY cd_pedido
       ) t
 WHERE t.cd_pedido = p.id_pedido;

-- Pagamentos (somente pedidos pagos)
INSERT INTO tb_pagamentos (cd_pedido, tx_forma, vl_pagamento, dt_pagamento)
SELECT
    p.id_pedido,
    (ARRAY['PIX','CARTAO','BOLETO','DINHEIRO'])[1 + floor(random() * 4)::int],
    p.vl_total,
    p.dt_pedido + make_interval(hours => (random() * 72)::int)
FROM tb_pedidos p
WHERE p.fl_pago;





select * from tb_pedidos
where cd_usuario = 1234; 

CREATE INDEX idx_pedidos_usuarios
ON tb_pedidos(cd_usuario);
    20,45% de melhora com o index0,

SELECT
    tb_usuarios.tx_nome AS nome_usuario,
    tb_pedidos.id_pedido AS codigo_pedido,
    tb_produtos.tx_nome AS nome_produto,
    tb_itens_pedido.nr_quantidade AS quantidade_comprada,
    tb_itens_pedido.vl_unitario AS valor_unitario


FROM tb_usuarios

INNER JOIN tb_pedidos
    ON tb_pedidos.cd_usuario = tb_usuarios.id_usuario

INNER JOIN tb_itens_pedido
    ON tb_itens_pedido.cd_pedido = tb_pedidos.id_pedido

INNER JOIN tb_produtos
    ON tb_produtos.id_produto = tb_itens_pedido.cd_produto

WHERE tb_pedidos.cd_usuario = 1234;


SELECT
    tb_pedidos.id_pedido AS codigo_pedido,
    tb_pedidos.vl_total AS valor_total
FROM tb_pedidos
WHERE upper(tx_status) =upper('ENTREGUE') 
  AND tb_pedidos.dt_pedido >= '2023-05-23';

CREATE INDEX idx_pedidos_status
ON tb_pedidos(tx_status);
DROP INDEX  idx_pedidos_status;
de 0,003
para 0,001
ao todo 66% melhor


SELECT
    tb_enderecos.tx_cidade,
    tb_enderecos.nr_numero,
    tb_enderecos.tx_logradouro,
    tb_usuarios.tx_nome
FROM tb_enderecos
INNER JOIN tb_usuarios
    ON tb_enderecos.cd_usuario = tb_usuarios.id_usuario;

CREATE INDEX idx_enderecos_usuario
ON tb_enderecos(cd_usuario);
0,019
para  0,007
63% melhor
