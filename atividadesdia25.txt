CREATE TABLE regioes (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(50)  NOT NULL,
    uf        CHAR(2)      NOT NULL
);

CREATE TABLE vendedores (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    email     VARCHAR(120) UNIQUE NOT NULL,
    regiao_id INT          REFERENCES regioes(id),
    ativo     BOOLEAN      DEFAULT true,
    criado_em TIMESTAMP    DEFAULT NOW()
);

CREATE TABLE clientes (
    id          SERIAL PRIMARY KEY,
    nome        VARCHAR(100) NOT NULL,
    email       VARCHAR(120) UNIQUE NOT NULL,
    cpf         CHAR(11)     UNIQUE NOT NULL,
    nascimento  DATE,
    genero      CHAR(1),          -- M / F / O
    regiao_id   INT          REFERENCES regioes(id),
    criado_em   TIMESTAMP    DEFAULT NOW(),
    ativo       BOOLEAN      DEFAULT true
);

CREATE TABLE enderecos (
    id          SERIAL PRIMARY KEY,
    cliente_id  INT          NOT NULL REFERENCES clientes(id),
    logradouro  VARCHAR(150) NOT NULL,
    numero      VARCHAR(10),
    bairro      VARCHAR(80),
    cidade      VARCHAR(80),
    uf          CHAR(2),
    cep         CHAR(8),
    principal   BOOLEAN      DEFAULT false
);

CREATE TABLE categorias (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(80)  NOT NULL,
    pai_id    INT          REFERENCES categorias(id)   -- hierarquia
);

CREATE TABLE produtos (
    id            SERIAL PRIMARY KEY,
    nome          VARCHAR(150) NOT NULL,
    descricao     TEXT,
    categoria_id  INT          REFERENCES categorias(id),
    preco         NUMERIC(10,2) NOT NULL,
    custo         NUMERIC(10,2),
    ativo         BOOLEAN      DEFAULT true,
    criado_em     TIMESTAMP    DEFAULT NOW()
);

CREATE TABLE estoque (
    id          SERIAL PRIMARY KEY,
    produto_id  INT     NOT NULL REFERENCES produtos(id),
    quantidade  INT     NOT NULL DEFAULT 0,
    minimo      INT     NOT NULL DEFAULT 5,
    atualizado  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE pedidos (
    id            SERIAL PRIMARY KEY,
    cliente_id    INT           NOT NULL REFERENCES clientes(id),
    vendedor_id   INT           REFERENCES vendedores(id),
    endereco_id   INT           REFERENCES enderecos(id),
    status        VARCHAR(20)   NOT NULL DEFAULT 'pendente',
        -- pendente | aprovado | enviado | entregue | cancelado
    total         NUMERIC(12,2),
    desconto      NUMERIC(10,2) DEFAULT 0,
    criado_em     TIMESTAMP     DEFAULT NOW(),
    atualizado_em TIMESTAMP     DEFAULT NOW()
);

CREATE TABLE itens_pedido (
    id          SERIAL PRIMARY KEY,
    pedido_id   INT            NOT NULL REFERENCES pedidos(id),
    produto_id  INT            NOT NULL REFERENCES produtos(id),
    quantidade  INT            NOT NULL,
    preco_unit  NUMERIC(10,2)  NOT NULL,
    desconto    NUMERIC(10,2)  DEFAULT 0
);

CREATE TABLE pagamentos (
    id           SERIAL PRIMARY KEY,
    pedido_id    INT           NOT NULL REFERENCES pedidos(id),
    metodo       VARCHAR(30)   NOT NULL,
        -- cartao_credito | cartao_debito | pix | boleto
    status       VARCHAR(20)   NOT NULL DEFAULT 'pendente',
        -- pendente | aprovado | recusado | estornado
    valor        NUMERIC(12,2) NOT NULL,
    parcelas     INT           DEFAULT 1,
    pago_em      TIMESTAMP
);


-- =============================================================
-- 2. DADOS FIXOS
-- =============================================================

INSERT INTO regioes (nome, uf) VALUES
    ('Grande São Paulo',   'SP'),
    ('Interior SP',        'SP'),
    ('Grande Rio',         'RJ'),
    ('Interior RJ',        'RJ'),
    ('Belo Horizonte',     'MG'),
    ('Interior MG',        'MG'),
    ('Grande Porto Alegre','RS'),
    ('Interior RS',        'RS'),
    ('Grande Curitiba',    'PR'),
    ('Interior PR',        'PR'),
    ('Nordeste',           'BA'),
    ('Centro-Oeste',       'GO');

INSERT INTO categorias (nome, pai_id) VALUES
    ('Eletrônicos',      NULL),   -- 1
    ('Informática',      1),      -- 2
    ('Smartphones',      1),      -- 3
    ('Áudio e Vídeo',    1),      -- 4
    ('Eletrodomésticos', NULL),   -- 5
    ('Cozinha',          5),      -- 6
    ('Climatização',     5),      -- 7
    ('Vestuário',        NULL),   -- 8
    ('Masculino',        8),      -- 9
    ('Feminino',         8),      -- 10
    ('Calçados',         NULL),   -- 11
    ('Esporte e Lazer',  NULL),   -- 12
    ('Livros',           NULL),   -- 13
    ('Beleza',           NULL);   -- 14


-- =============================================================
-- 3. DADOS GERADOS (100 k+)
-- =============================================================

-- 3.1  Vendedores (200)
INSERT INTO vendedores (nome, email, regiao_id, ativo, criado_em)
SELECT
    'Vendedor ' || i,
    'vendedor' || i || '@loja.com',
    1 + (i % 12),
    i % 10 != 0,
    NOW() - ((random() * 1000)::INT || ' days')::INTERVAL
FROM generate_series(1, 200) i;

-- 3.2  Clientes (30 000)
INSERT INTO clientes (nome, email, cpf, nascimento, genero, regiao_id, criado_em, ativo)
SELECT
    (ARRAY[
        'Ana','Bruno','Carlos','Diana','Eduardo','Fernanda',
        'Gabriel','Helena','Igor','Julia','Lucas','Mariana',
        'Nicolas','Olivia','Pedro','Rafaela','Samuel','Tatiane',
        'Vinícius','Wesley'
    ])[1 + (i % 20)]
    || ' '
    || (ARRAY[
        'Silva','Souza','Oliveira','Santos','Pereira','Costa',
        'Rodrigues','Almeida','Nascimento','Lima','Araújo',
        'Fernandes','Carvalho','Gomes','Martins','Ribeiro',
        'Barbosa','Rocha','Alves','Monteiro'
    ])[1 + ((i * 7) % 20)],

    'cliente' || i || '@email.com',
    LPAD(i::TEXT, 11, '0'),
    DATE '1960-01-01' + ((random() * 21900)::INT),
    (ARRAY['M','F','O'])[1 + (i % 3)],
    1 + (i % 12),
    NOW() - ((random() * 1500)::INT || ' days')::INTERVAL,
    i % 20 != 0
FROM generate_series(1, 30000) i;

-- 3.3  Endereços (40 000 — alguns clientes têm mais de um)
INSERT INTO enderecos (cliente_id, logradouro, numero, bairro, cidade, uf, cep, principal)
SELECT
    1 + (i % 30000),
    'Rua ' || (ARRAY[
        'das Flores','do Comércio','Brasil','São João',
        'das Acácias','XV de Novembro','Sete de Setembro',
        'das Palmeiras','dos Ipês','da Paz'
    ])[1 + (i % 10)],
    (1 + (random() * 2000)::INT)::TEXT,
    'Bairro ' || (1 + (i % 50)),
    (ARRAY[
        'São Paulo','Rio de Janeiro','Belo Horizonte','Porto Alegre',
        'Curitiba','Salvador','Fortaleza','Manaus','Recife','Goiânia'
    ])[1 + (i % 10)],
    (ARRAY['SP','RJ','MG','RS','PR','BA','CE','AM','PE','GO'])[1 + (i % 10)],
    LPAD((10000000 + i)::TEXT, 8, '0'),
    i % 4 = 0   -- 1 em cada 4 é o principal
FROM generate_series(1, 40000) i;

-- 3.4  Produtos (2 000)
INSERT INTO produtos (nome, descricao, categoria_id, preco, custo, ativo, criado_em)
SELECT
    (ARRAY[
        'Notebook','Smartphone','Tablet','Smart TV','Fone de Ouvido',
        'Teclado','Mouse','Monitor','Câmera','Impressora',
        'Geladeira','Fogão','Micro-ondas','Ar-condicionado','Liquidificador',
        'Camiseta','Calça Jeans','Vestido','Tênis','Sandália',
        'Bicicleta','Mochila','Livro Técnico','Perfume','Shampoo'
    ])[1 + (i % 25)]
    || ' Modelo ' || i,

    'Descrição detalhada do produto ' || i,
    1 + (i % 14),
    (50 + (random() * 4950)::NUMERIC)::NUMERIC(10,2),
    (20 + (random() * 2000)::NUMERIC)::NUMERIC(10,2),
    i % 15 != 0,
    NOW() - ((random() * 730)::INT || ' days')::INTERVAL
FROM generate_series(1, 2000) i;

-- 3.5  Estoque (1 registro por produto)
INSERT INTO estoque (produto_id, quantidade, minimo)
SELECT i, (random() * 500)::INT, 5 + (i % 20)
FROM generate_series(1, 2000) i;

-- 3.6  Pedidos (50 000)
INSERT INTO pedidos (cliente_id, vendedor_id, endereco_id, status, total, desconto, criado_em, atualizado_em)
SELECT
    1 + (i % 30000),
    1 + (i % 200),
    1 + (i % 40000),
    (ARRAY['pendente','aprovado','enviado','entregue','cancelado'])[
        1 + (CASE
            WHEN i % 10 = 0 THEN 4   -- 10% cancelado
            WHEN i % 5  = 0 THEN 0   -- 20% pendente
            WHEN i % 3  = 0 THEN 2   -- ~33% enviado
            WHEN i % 2  = 0 THEN 3   -- ~16% entregue
            ELSE 1                   -- ~21% aprovado
        END)
    ],
    (100 + (random() * 9900)::NUMERIC)::NUMERIC(12,2),
    (random() * 200)::NUMERIC(10,2),
    NOW() - ((random() * 730)::INT || ' days')::INTERVAL,
    NOW() - ((random() * 100)::INT  || ' days')::INTERVAL
FROM generate_series(1, 50000) i;

-- 3.7  Itens de pedido (~150 000 — média 3 itens por pedido)
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit, desconto)
SELECT
    1 + (i % 50000),
    1 + (i % 2000),
    1 + (i % 5),
    p.preco,
    (random() * 50)::NUMERIC(10,2)
FROM generate_series(1, 150000) i
JOIN produtos p ON p.id = 1 + (i % 2000);

-- 3.8  Pagamentos (55 000 — alguns pedidos têm 2 pagamentos parciais)
INSERT INTO pagamentos (pedido_id, metodo, status, valor, parcelas, pago_em)
SELECT
    1 + (i % 50000),
    (ARRAY['cartao_credito','cartao_debito','pix','boleto'])[1 + (i % 4)],
    (ARRAY['aprovado','aprovado','aprovado','recusado','pendente','estornado'])[1 + (i % 6)],
    (50 + (random() * 5000)::NUMERIC)::NUMERIC(12,2),
    1 + (i % 12),
    CASE WHEN i % 6 < 3
         THEN NOW() - ((random() * 700)::INT || ' days')::INTERVAL
         ELSE NULL
    END
FROM generate_series(1, 55000) i;


-- =============================================================
-- 4. ATUALIZAR TOTAIS DOS PEDIDOS (consistência)
-- =============================================================
UPDATE pedidos p
SET total = (
    SELECT COALESCE(SUM((ip.preco_unit * ip.quantidade) - ip.desconto), 0)
    FROM itens_pedido ip
    WHERE ip.pedido_id = p.id
);

----------------------------------------------------------------

SELECT
    COUNT(*) AS quantidade_pedidos,
    SUM(total) AS valor_total
FROM pedidos
WHERE status = 'entregue'
  AND atualizado_em >= NOW() - INTERVAL '90 days';
---------------------------------------------------------------
SELECT
    vendedores.nome,
    COUNT(*) AS quantidade_pedidos,
    SUM(pedidos.total) AS faturamento
FROM pedidos
INNER JOIN vendedores
    ON pedidos.vendedor_id = vendedores.id
WHERE pedidos.atualizado_em >= NOW() - INTERVAL '30 days'
  AND pedidos.status <> 'cancelado'
GROUP BY vendedores.nome
ORDER BY faturamento DESC;