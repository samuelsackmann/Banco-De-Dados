-- Empresa
CREATE TABLE tb_empresa (
    id_empresa      SERIAL          PRIMARY KEY,
    tx_razao_social VARCHAR(255)    NOT NULL,
    tx_cnpj         VARCHAR(18)     NOT NULL UNIQUE,
    tx_cidade       VARCHAR(100)    NOT NULL,
    tx_estado       CHAR(2)         NOT NULL,
    fl_ativo        BOOLEAN         NOT NULL DEFAULT TRUE,
    dt_abertura     TIMESTAMP       NOT NULL
);

-- Fornecedor
CREATE TABLE tb_fornecedor (
    id_fornecedor   SERIAL          PRIMARY KEY,
    tx_nome         VARCHAR(255)    NOT NULL,
    tx_cnpj         VARCHAR(18)     NOT NULL UNIQUE,
    tx_cidade       VARCHAR(100)    NOT NULL,
    tx_estado       CHAR(2)         NOT NULL,
    tx_email        VARCHAR(255),
    fl_ativo        BOOLEAN         NOT NULL DEFAULT TRUE,
    dt_cadastro     TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- Categoria de Produto
CREATE TABLE tb_categoria (
    id_categoria    SERIAL          PRIMARY KEY,
    tx_nome         VARCHAR(100)    NOT NULL,
    tx_descricao    VARCHAR(255)
);

-- Produto
CREATE TABLE tb_produto (
    id_produto      SERIAL          PRIMARY KEY,
    tx_nome         VARCHAR(255)    NOT NULL,
    tx_descricao    VARCHAR(255),
    vl_preco        NUMERIC(18,2)   NOT NULL,
    nr_estoque      NUMERIC(18,0)   NOT NULL DEFAULT 0,
    cd_categoria    INTEGER         NOT NULL REFERENCES tb_categoria(id_categoria),
    cd_fornecedor   INTEGER         NOT NULL REFERENCES tb_fornecedor(id_fornecedor),
    fl_ativo        BOOLEAN         NOT NULL DEFAULT TRUE,
    dt_cadastro     TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- Cliente
CREATE TABLE tb_cliente (
    id_cliente      SERIAL          PRIMARY KEY,
    tx_nome         VARCHAR(255)    NOT NULL,
    tx_cpf          VARCHAR(14)     NOT NULL UNIQUE,
    tx_email        VARCHAR(255),
    tx_cidade       VARCHAR(100)    NOT NULL,
    tx_estado       CHAR(2)         NOT NULL,
    nr_idade        NUMERIC(18,0),
    fl_ativo        BOOLEAN         NOT NULL DEFAULT TRUE,
    dt_cadastro     TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- Venda (cabeçalho)
CREATE TABLE tb_venda (
    id_venda        SERIAL          PRIMARY KEY,
    cd_cliente      INTEGER         NOT NULL REFERENCES tb_cliente(id_cliente),
    cd_empresa      INTEGER         NOT NULL REFERENCES tb_empresa(id_empresa),
    tx_status       VARCHAR(50)     NOT NULL DEFAULT 'PENDENTE',  -- PENDENTE, PAGO, CANCELADO
    vl_desconto     NUMERIC(18,2)   NOT NULL DEFAULT 0,
    dt_venda        TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- Item de Venda (detalhe)
CREATE TABLE tb_item_venda (
    id_item_venda   SERIAL          PRIMARY KEY,
    cd_venda        INTEGER         NOT NULL REFERENCES tb_venda(id_venda),
    cd_produto      INTEGER         NOT NULL REFERENCES tb_produto(id_produto),
    nr_quantidade   NUMERIC(18,0)   NOT NULL,
    vl_unitario     NUMERIC(18,2)   NOT NULL
);


-- ============================================================
--  2. DADOS DE EXEMPLO (DML)
-- ============================================================

-- Empresas
INSERT INTO tb_empresa (tx_razao_social, tx_cnpj, tx_cidade, tx_estado, dt_abertura) VALUES
('TechVenda Ltda',      '11.111.111/0001-11', 'Chapecó',           'SC', '2010-03-15'),
('MegaStore S/A',       '22.222.222/0001-22', 'Florianópolis',     'SC', '2005-07-20'),
('Distribuidora Sul',   '33.333.333/0001-33', 'Joinville',         'SC', '2015-01-10');

-- Categorias
INSERT INTO tb_categoria (tx_nome, tx_descricao) VALUES
('Eletrônicos',     'Produtos eletrônicos em geral'),
('Informática',     'Computadores e periféricos'),
('Celulares',       'Smartphones e acessórios'),
('Áudio e Vídeo',   'TVs, fones e caixas de som'),
('Escritório',      'Material e equipamentos de escritório');

-- Fornecedores
INSERT INTO tb_fornecedor (tx_nome, tx_cnpj, tx_cidade, tx_estado, tx_email) VALUES
('Samsung Brasil',      '44.444.444/0001-44', 'São Paulo',    'SP', 'samsung@fornecedor.com'),
('Apple Inc.',          '55.555.555/0001-55', 'São Paulo',    'SP', 'apple@fornecedor.com'),
('Dell Technologies',   '66.666.666/0001-66', 'Porto Alegre', 'RS', 'dell@fornecedor.com'),
('LG Electronics',      '77.777.777/0001-77', 'Manaus',       'AM', 'lg@fornecedor.com'),
('Multilaser',          '88.888.888/0001-88', 'São Paulo',    'SP', 'multi@fornecedor.com');

-- Produtos
INSERT INTO tb_produto (tx_nome, tx_descricao, vl_preco, nr_estoque, cd_categoria, cd_fornecedor) VALUES
('Galaxy S24',              'Smartphone Samsung topo de linha',     4999.99,  50, 3, 1),
('iPhone 15',               'Smartphone Apple com chip A16',        7499.99,  30, 3, 2),
('Dell Inspiron 15',        'Notebook Dell i5 16GB RAM',            3499.99,  20, 2, 3),
('LG OLED 55"',             'Smart TV OLED 4K 55 polegadas',        5999.99,  15, 4, 4),
('Mouse Multilaser',        'Mouse sem fio ergonômico',               89.90, 200, 5, 5),
('Teclado Multilaser',      'Teclado mecânico retroiluminado',       199.90, 150, 5, 5),
('Samsung Galaxy Tab',      'Tablet Samsung 10.5" 128GB',           1899.99,  40, 1, 1),
('AirPods Pro',             'Fone de ouvido sem fio Apple',         1799.99,  60, 4, 2),
('Dell Monitor 27"',        'Monitor IPS Full HD 27 polegadas',     1299.99,  35, 2, 3),
('LG Soundbar',             'Soundbar 2.1 300W Bluetooth',           799.99,  25, 4, 4),
('Galaxy Watch 6',          'Smartwatch Samsung 44mm',              1499.99,  45, 1, 1),
('iPad Air',                'Tablet Apple M1 64GB',                 5499.99,  18, 1, 2),
('Multilaser Webcam',       'Webcam Full HD 1080p',                  149.90, 100, 5, 5),
('Samsung SSD 1TB',         'SSD NVMe M.2 1TB',                     399.99,  80, 2, 1),
('Dell Inspiron Desktop',   'Desktop Dell i7 32GB 1TB SSD',        5299.99,  10, 2, 3);

-- Clientes
INSERT INTO tb_cliente (tx_nome, tx_cpf, tx_email, tx_cidade, tx_estado, nr_idade) VALUES
('Ana Souza',       '111.111.111-11', 'ana@email.com',     'Chapecó',       'SC', 29),
('Bruno Lima',      '222.222.222-22', 'bruno@email.com',   'Florianópolis', 'SC', 35),
('Carla Mendes',    '333.333.333-33', 'carla@email.com',   'Joinville',     'SC', 42),
('Diego Ramos',     '444.444.444-44', 'diego@email.com',   'Curitiba',      'PR', 27),
('Eva Costa',       '555.555.555-55', 'eva@email.com',     'Porto Alegre',  'RS', 31),
('Felipe Nunes',    '666.666.666-66', NULL,                'São Paulo',     'SP', 55),
('Gabriela Pinto',  '777.777.777-77', 'gabi@email.com',    'Chapecó',       'SC', 23),
('Henrique Alves',  '888.888.888-88', 'henri@email.com',   'Blumenau',      'SC', 48),
('Isabela Rocha',   '999.999.999-99', 'isa@email.com',     'Joinville',     'SC', 33),
('João Pedro',      '000.000.000-00', NULL,                'Florianópolis', 'SC', 61);

-- Vendas
INSERT INTO tb_venda (cd_cliente, cd_empresa, tx_status, vl_desconto, dt_venda) VALUES
(1, 1, 'PAGO',      0.00,   '2024-01-10 09:30:00'),
(2, 1, 'PAGO',    100.00,   '2024-01-15 14:00:00'),
(3, 2, 'PAGO',      0.00,   '2024-02-03 11:15:00'),
(4, 2, 'CANCELADO', 0.00,   '2024-02-20 16:45:00'),
(5, 3, 'PAGO',    250.00,   '2024-03-05 10:00:00'),
(1, 1, 'PAGO',      0.00,   '2024-03-22 13:30:00'),
(6, 3, 'PENDENTE',  0.00,   '2024-04-01 09:00:00'),
(7, 1, 'PAGO',     50.00,   '2024-04-18 15:20:00'),
(8, 2, 'PAGO',      0.00,   '2024-05-07 10:45:00'),
(9, 3, 'PAGO',    150.00,   '2024-05-30 14:00:00'),
(2, 2, 'PAGO',      0.00,   '2024-06-12 11:00:00'),
(10,1, 'PENDENTE',  0.00,   '2024-06-25 16:30:00');

-- Itens de Venda
INSERT INTO tb_item_venda (cd_venda, cd_produto, nr_quantidade, vl_unitario) VALUES
-- Venda 1 (Ana - TechVenda)
(1, 1, 1, 4999.99),  -- Galaxy S24
(1, 5, 2,   89.90),  -- Mouse x2

-- Venda 2 (Bruno - TechVenda)
(2, 3, 1, 3499.99),  -- Dell Inspiron
(2, 6, 1,  199.90),  -- Teclado
(2, 9, 1, 1299.99),  -- Monitor Dell

-- Venda 3 (Carla - MegaStore)
(3, 2, 1, 7499.99),  -- iPhone 15
(3, 8, 1, 1799.99),  -- AirPods Pro

-- Venda 4 (Diego - MegaStore - CANCELADO)
(4, 4, 1, 5999.99),  -- LG OLED

-- Venda 5 (Eva - Distribuidora)
(5, 4, 1, 5999.99),  -- LG OLED
(5,10, 1,  799.99),  -- LG Soundbar

-- Venda 6 (Ana - TechVenda)
(6,11, 1, 1499.99),  -- Galaxy Watch
(6, 7, 1, 1899.99),  -- Galaxy Tab

-- Venda 7 (Felipe - Distribuidora - PENDENTE)
(7,15, 1, 5299.99),  -- Dell Desktop

-- Venda 8 (Gabriela - TechVenda)
(8,12, 1, 5499.99),  -- iPad Air
(8, 8, 1, 1799.99),  -- AirPods Pro

-- Venda 9 (Henrique - MegaStore)
(9, 3, 1, 3499.99),  -- Dell Inspiron
(9,14, 2,  399.99),  -- SSD x2

-- Venda 10 (Isabela - Distribuidora)
(10,1, 2, 4999.99),  -- Galaxy S24 x2
(10,5, 3,   89.90),  -- Mouse x3

-- Venda 11 (Bruno - MegaStore)
(11,2, 1, 7499.99),  -- iPhone 15
(11,13,1,  149.90),  -- Webcam

-- Venda 12 (João - TechVenda - PENDENTE)
(12,15,1, 5299.99),  -- Dell Desktop
(12, 9,2, 1299.99);  -- Monitor x2


---------------------------------------------------------------------------



SELECT
    tb_produto.tx_nome,
    tb_categoria.tx_nome,
    tb_produto.vl_preco,
    tb_produto.nr_estoque
FROM tb_produto
INNER JOIN tb_categoria
    ON tb_categoria.id_categoria = tb_produto.cd_categoria
WHERE tb_produto.fl_ativo is TRUE
  AND tb_produto.vl_preco BETWEEN 500 AND 1000;



SELECT
    tb_cliente.tx_nome,
    tb_cliente.tx_cpf,
    tb_cliente.tx_email,
    tb_cliente.tx_estado
FROM tb_cliente 
WHERE upper (tx_estado) IN (upper ('SC'),upper('PR'))
ORDER BY tx_nome ASC;

SELECT
    tb_cliente.tx_nome,
    tb_cliente.nr_idade,
    tb_cliente.tx_email
FROM tb_cliente
WHERE tb_cliente.tx_email IS NULL
   OR tb_cliente.nr_idade > 50
ORDER BY tx_nome ASC;
------------------------------------

SELECT
    tb_produto.tx_nome AS NomeProduto,
    tb_produto.vl_preco AS PrecoProduto,
    tb_produto.tx_descricao AS DescricaoProduto,
    tb_categoria.tx_nome AS CategoriaProduto,
    tb_produto.nr_estoque AS EstoqueProduto,
    tb_fornecedor.tx_nome AS FornecedorProduto
FROM tb_produto
INNER JOIN tb_categoria
    ON tb_categoria.id_categoria = tb_produto.cd_categoria
INNER JOIN tb_fornecedor
    ON tb_fornecedor.id_fornecedor = tb_produto.cd_fornecedor
WHERE tb_produto.fl_ativo = true
ORDER BY tb_produto.vl_preco DESC;

---------------------------------------------------------------------------------
SELECT
    tb_cliente.tx_nome AS NomeCliente,
    tb_cliente.tx_cidade AS Cidade,
    COUNT (tb_venda.id_venda) AS TotalVendas
FROM tb_cliente
INNER JOIN tb_venda
    ON tb_venda.cd_cliente = tb_cliente.id_cliente
GROUP BY
    tb_cliente.id_cliente,
    tb_cliente.tx_nome,
    tb_cliente.tx_cidade
ORDER BY TotalVendas DESC;

-------------------------------------------------------------------
SELECT
    tb_categoria.tx_nome AS NomeCategoria
FROM tb_categoria
LEFT JOIN tb_produto
    ON tb_produto.cd_categoria = tb_categoria.id_categoria
WHERE tb_produto.id_produto IS NULL
ORDER BY tb_categoria.tx_nome ASC;



-- Produtos
INSERT INTO tb_produto (tx_nome, tx_descricao, vl_preco, nr_estoque, cd_categoria, cd_fornecedor) VALUES
('Galaxy S24',              'Smartphone Samsung topo de linha',     4999.99,  50, 3, 1),
('iPhone 15',               'Smartphone Apple com chip A16',        7499.99,  30, 3, 2),
('Dell Inspiron 15',        'Notebook Dell i5 16GB RAM',            3499.99,  20, 2, 3),
('LG OLED 55"',             'Smart TV OLED 4K 55 polegadas',        5999.99,  15, 4, 4),
('Mouse Multilaser',        'Mouse sem fio ergonômico',               89.90, 200, 5, 5),
('Teclado Multilaser',      'Teclado mecânico retroiluminado',       199.90, 150, 5, 5),
('Samsung Galaxy Tab',      'Tablet Samsung 10.5" 128GB',           1899.99,  40, 1, 1),
('AirPods Pro',             'Fone de ouvido sem fio Apple',         1799.99,  60, 4, 2),
('Dell Monitor 27"',        'Monitor IPS Full HD 27 polegadas',     1299.99,  35, 2, 3),
('LG Soundbar',             'Soundbar 2.1 300W Bluetooth',           799.99,  25, 4, 4),
('Galaxy Watch 6',          'Smartwatch Samsung 44mm',              1499.99,  45, 1, 1),
('iPad Air',                'Tablet Apple M1 64GB',                 5499.99,  18, 1, 2),
('Multilaser Webcam',       'Webcam Full HD 1080p',                  149.90, 100, 5, 5),
('Samsung SSD 1TB',         'SSD NVMe M.2 1TB',                     399.99,  80, 2, 1),
('Dell Inspiron Desktop',   'Desktop Dell i7 32GB 1TB SSD',        5299.99,  10, 2, 3);
