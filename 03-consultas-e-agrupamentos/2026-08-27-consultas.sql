-- ============================================================
--  1. CRIAÇÃO DAS TABELAS (DDL)
-- ============================================================

-- --------------------------------------------------------
-- Tipo de Contato (tabela domínio)
-- --------------------------------------------------------
CREATE TABLE tb_tipo_contato (
    id_tipo_contato SERIAL          PRIMARY KEY,
    tx_descricao    VARCHAR(50)     NOT NULL   -- E-mail, Celular, Telefone Fixo
);

-- --------------------------------------------------------
-- Endereço (reutilizado por cliente e empresa)
-- --------------------------------------------------------
CREATE TABLE tb_endereco (
    id_endereco     SERIAL          PRIMARY KEY,
    tx_logradouro   VARCHAR(255)    NOT NULL,
    tx_numero       VARCHAR(10)     NOT NULL,
    tx_complemento  VARCHAR(100),
    tx_bairro       VARCHAR(100)    NOT NULL,
    tx_cidade       VARCHAR(100)    NOT NULL,
    tx_estado       CHAR(2)         NOT NULL,
    tx_cep          VARCHAR(10)     NOT NULL
);

-- --------------------------------------------------------
-- Empresa
-- --------------------------------------------------------
CREATE TABLE tb_empresa (
    id_empresa      SERIAL          PRIMARY KEY,
    tx_razao_social VARCHAR(255)    NOT NULL,
    tx_cnpj         VARCHAR(18)     NOT NULL UNIQUE,
    cd_endereco     INTEGER         REFERENCES tb_endereco(id_endereco),
    fl_ativo        BOOLEAN         NOT NULL DEFAULT TRUE,
    dt_abertura     TIMESTAMP       NOT NULL
);

-- --------------------------------------------------------
-- Fornecedor
-- --------------------------------------------------------
CREATE TABLE tb_fornecedor (
    id_fornecedor   SERIAL          PRIMARY KEY,
    tx_nome         VARCHAR(255)    NOT NULL,
    tx_cnpj         VARCHAR(18)     NOT NULL UNIQUE,
    cd_endereco     INTEGER         REFERENCES tb_endereco(id_endereco),
    fl_ativo        BOOLEAN         NOT NULL DEFAULT TRUE,
    dt_cadastro     TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- --------------------------------------------------------
-- Contato do Fornecedor
-- --------------------------------------------------------
CREATE TABLE tb_contato_fornecedor (
    id_contato_fornecedor   SERIAL          PRIMARY KEY,
    cd_fornecedor           INTEGER         NOT NULL REFERENCES tb_fornecedor(id_fornecedor),
    cd_tipo_contato         INTEGER         NOT NULL REFERENCES tb_tipo_contato(id_tipo_contato),
    tx_contato              VARCHAR(255)    NOT NULL,   -- valor: e-mail ou número
    fl_principal            BOOLEAN         NOT NULL DEFAULT FALSE,
    fl_ativo                BOOLEAN         NOT NULL DEFAULT TRUE
);

-- --------------------------------------------------------
-- Categoria de Produto
-- --------------------------------------------------------
CREATE TABLE tb_categoria (
    id_categoria    SERIAL          PRIMARY KEY,
    tx_nome         VARCHAR(100)    NOT NULL,
    tx_descricao    VARCHAR(255),
    cd_categoria_pai INTEGER        REFERENCES tb_categoria(id_categoria)  -- auto-relacionamento
);

-- --------------------------------------------------------
-- Produto
-- --------------------------------------------------------
CREATE TABLE tb_produto (
    id_produto      SERIAL          PRIMARY KEY,
    tx_nome         VARCHAR(255)    NOT NULL,
    tx_descricao    VARCHAR(255),
    tx_codigo_barras VARCHAR(50)    UNIQUE,
    vl_preco        NUMERIC(18,2)   NOT NULL,
    vl_custo        NUMERIC(18,2)   NOT NULL,
    nr_estoque      NUMERIC(18,0)   NOT NULL DEFAULT 0,
    nr_estoque_min  NUMERIC(18,0)   NOT NULL DEFAULT 5,
    cd_categoria    INTEGER         NOT NULL REFERENCES tb_categoria(id_categoria),
    cd_fornecedor   INTEGER         NOT NULL REFERENCES tb_fornecedor(id_fornecedor),
    fl_ativo        BOOLEAN         NOT NULL DEFAULT TRUE,
    dt_cadastro     TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- --------------------------------------------------------
-- Histórico de Preço do Produto
-- --------------------------------------------------------
CREATE TABLE tb_preco_historico (
    id_preco_historico  SERIAL          PRIMARY KEY,
    cd_produto          INTEGER         NOT NULL REFERENCES tb_produto(id_produto),
    vl_preco_anterior   NUMERIC(18,2)   NOT NULL,
    vl_preco_novo       NUMERIC(18,2)   NOT NULL,
    dt_alteracao        TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- --------------------------------------------------------
-- Cliente
-- --------------------------------------------------------
CREATE TABLE tb_cliente (
    id_cliente      SERIAL          PRIMARY KEY,
    tx_nome         VARCHAR(255)    NOT NULL,
    tx_cpf          VARCHAR(14)     NOT NULL UNIQUE,
    cd_endereco     INTEGER         REFERENCES tb_endereco(id_endereco),
    nr_idade        NUMERIC(18,0),
    fl_ativo        BOOLEAN         NOT NULL DEFAULT TRUE,
    dt_cadastro     TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- --------------------------------------------------------
-- Contato do Cliente  ← NOVA TABELA SOLICITADA
-- --------------------------------------------------------
CREATE TABLE tb_contato (
    id_contato      SERIAL          PRIMARY KEY,
    cd_cliente      INTEGER         NOT NULL REFERENCES tb_cliente(id_cliente),
    cd_tipo_contato INTEGER         NOT NULL REFERENCES tb_tipo_contato(id_tipo_contato),
    tx_contato      VARCHAR(255)    NOT NULL,   -- valor: e-mail ou número
    fl_principal    BOOLEAN         NOT NULL DEFAULT FALSE,
    fl_ativo        BOOLEAN         NOT NULL DEFAULT TRUE
);

-- --------------------------------------------------------
-- Funcionário
-- --------------------------------------------------------
CREATE TABLE tb_funcionario (
    id_funcionario  SERIAL          PRIMARY KEY,
    tx_nome         VARCHAR(255)    NOT NULL,
    tx_cpf          VARCHAR(14)     NOT NULL UNIQUE,
    tx_cargo        VARCHAR(100)    NOT NULL,
    vl_salario      NUMERIC(18,2)   NOT NULL,
    cd_empresa      INTEGER         NOT NULL REFERENCES tb_empresa(id_empresa),
    cd_endereco     INTEGER         REFERENCES tb_endereco(id_endereco),
    fl_ativo        BOOLEAN         NOT NULL DEFAULT TRUE,
    dt_admissao     TIMESTAMP       NOT NULL
);

-- --------------------------------------------------------
-- Contato do Funcionário
-- --------------------------------------------------------
CREATE TABLE tb_contato_funcionario (
    id_contato_func SERIAL          PRIMARY KEY,
    cd_funcionario  INTEGER         NOT NULL REFERENCES tb_funcionario(id_funcionario),
    cd_tipo_contato INTEGER         NOT NULL REFERENCES tb_tipo_contato(id_tipo_contato),
    tx_contato      VARCHAR(255)    NOT NULL,
    fl_principal    BOOLEAN         NOT NULL DEFAULT FALSE,
    fl_ativo        BOOLEAN         NOT NULL DEFAULT TRUE
);

-- --------------------------------------------------------
-- Venda (cabeçalho)
-- --------------------------------------------------------
CREATE TABLE tb_venda (
    id_venda        SERIAL          PRIMARY KEY,
    cd_cliente      INTEGER         NOT NULL REFERENCES tb_cliente(id_cliente),
    cd_empresa      INTEGER         NOT NULL REFERENCES tb_empresa(id_empresa),
    cd_funcionario  INTEGER         REFERENCES tb_funcionario(id_funcionario),
    tx_status       VARCHAR(50)     NOT NULL DEFAULT 'PENDENTE',
    tx_forma_pagamento VARCHAR(50)  NOT NULL DEFAULT 'DINHEIRO',  -- DINHEIRO, CARTAO, PIX, BOLETO
    nr_parcelas     NUMERIC(18,0)   NOT NULL DEFAULT 1,
    vl_desconto     NUMERIC(18,2)   NOT NULL DEFAULT 0,
    dt_venda        TIMESTAMP       NOT NULL DEFAULT NOW(),
    dt_entrega      TIMESTAMP
);

-- --------------------------------------------------------
-- Item de Venda (detalhe)
-- --------------------------------------------------------
CREATE TABLE tb_item_venda (
    id_item_venda   SERIAL          PRIMARY KEY,
    cd_venda        INTEGER         NOT NULL REFERENCES tb_venda(id_venda),
    cd_produto      INTEGER         NOT NULL REFERENCES tb_produto(id_produto),
    nr_quantidade   NUMERIC(18,0)   NOT NULL,
    vl_unitario     NUMERIC(18,2)   NOT NULL,
    vl_desconto_item NUMERIC(18,2)  NOT NULL DEFAULT 0
);

-- --------------------------------------------------------
-- Avaliação de Produto
-- --------------------------------------------------------
CREATE TABLE tb_avaliacao (
    id_avaliacao    SERIAL          PRIMARY KEY,
    cd_produto      INTEGER         NOT NULL REFERENCES tb_produto(id_produto),
    cd_cliente      INTEGER         NOT NULL REFERENCES tb_cliente(id_cliente),
    nr_nota         NUMERIC(18,0)   NOT NULL CHECK (nr_nota BETWEEN 1 AND 5),
    tx_comentario   VARCHAR(255),
    dt_avaliacao    TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- --------------------------------------------------------
-- Cupom de Desconto
-- --------------------------------------------------------
CREATE TABLE tb_cupom (
    id_cupom        SERIAL          PRIMARY KEY,
    tx_codigo       VARCHAR(50)     NOT NULL UNIQUE,
    tx_descricao    VARCHAR(255),
    vl_desconto     NUMERIC(18,2),       -- desconto fixo em R$
    vl_percentual   NUMERIC(5,2),        -- desconto percentual
    nr_uso_maximo   NUMERIC(18,0)   NOT NULL DEFAULT 1,
    nr_uso_atual    NUMERIC(18,0)   NOT NULL DEFAULT 0,
    fl_ativo        BOOLEAN         NOT NULL DEFAULT TRUE,
    dt_validade     TIMESTAMP       NOT NULL
);

-- --------------------------------------------------------
-- Venda x Cupom (N:N — uma venda pode ter vários cupons)
-- --------------------------------------------------------
CREATE TABLE tb_venda_cupom (
    id_venda_cupom  SERIAL          PRIMARY KEY,
    cd_venda        INTEGER         NOT NULL REFERENCES tb_venda(id_venda),
    cd_cupom        INTEGER         NOT NULL REFERENCES tb_cupom(id_cupom),
    vl_aplicado     NUMERIC(18,2)   NOT NULL
);


-- ============================================================
--  2. DADOS DE EXEMPLO (DML)
-- ============================================================

-- Tipos de Contato
INSERT INTO tb_tipo_contato (tx_descricao) VALUES
('E-mail'),           -- id 1
('Celular'),          -- id 2
('Telefone Fixo');    -- id 3

-- Endereços
INSERT INTO tb_endereco (tx_logradouro, tx_numero, tx_complemento, tx_bairro, tx_cidade, tx_estado, tx_cep) VALUES
('Rua XV de Novembro',  '100',  NULL,       'Centro',       'Chapecó',       'SC', '89801-000'),  -- 1
('Av. Beira Mar Norte', '500',  'Sala 10',  'Agronômica',   'Florianópolis', 'SC', '88015-200'),  -- 2
('Rua das Palmeiras',   '250',  NULL,       'Anita Garib',  'Joinville',     'SC', '89201-100'),  -- 3
('Av. Paulista',        '1000', '3º Andar', 'Bela Vista',   'São Paulo',     'SP', '01310-100'),  -- 4
('Rua dos Andradas',    '75',   NULL,       'Centro',       'Porto Alegre',  'RS', '90020-005'),  -- 5
('Av. Eduardo Andrade', '320',  NULL,       'Centro',       'Chapecó',       'SC', '89802-112'),  -- 6
('Rua Blumenau',        '88',   'Apto 3',   'Victor Konder','Blumenau',      'SC', '89010-300'),  -- 7
('Rua das Acácias',     '512',  NULL,       'América',      'Joinville',     'SC', '89204-050'),  -- 8
('Av. Batel',           '700',  NULL,       'Batel',        'Curitiba',      'PR', '80420-090'),  -- 9
('Rua Araraquara',      '14',   'Casa',     'Estreito',     'Florianópolis', 'SC', '88070-610'),  -- 10
('Av. Industrial',      '2000', NULL,       'Distrito Ind', 'São Paulo',     'SP', '02110-000'),  -- 11
('Rua Ipiranga',        '410',  NULL,       'Ipiranga',     'Porto Alegre',  'RS', '90160-090'),  -- 12
('Av. Amazonas',        '1800', NULL,       'Centro',       'Manaus',        'AM', '69010-000');  -- 13

-- Empresas
INSERT INTO tb_empresa (tx_razao_social, tx_cnpj, cd_endereco, dt_abertura) VALUES
('TechVenda Ltda',    '11.111.111/0001-11', 1, '2010-03-15'),
('MegaStore S/A',     '22.222.222/0001-22', 2, '2005-07-20'),
('Distribuidora Sul', '33.333.333/0001-33', 3, '2015-01-10');

-- Fornecedores
INSERT INTO tb_fornecedor (tx_nome, tx_cnpj, cd_endereco) VALUES
('Samsung Brasil',    '44.444.444/0001-44', 4),
('Apple Inc.',        '55.555.555/0001-55', 4),
('Dell Technologies', '66.666.666/0001-66', 5),
('LG Electronics',    '77.777.777/0001-77', 13),
('Multilaser',        '88.888.888/0001-88', 11);

-- Contatos dos Fornecedores
INSERT INTO tb_contato_fornecedor (cd_fornecedor, cd_tipo_contato, tx_contato, fl_principal) VALUES
(1, 1, 'samsung@fornecedor.com',    TRUE),
(1, 2, '(11) 99999-1111',           FALSE),
(2, 1, 'apple@fornecedor.com',      TRUE),
(2, 2, '(11) 99999-2222',           FALSE),
(3, 1, 'dell@fornecedor.com',       TRUE),
(3, 3, '(51) 3333-1111',            FALSE),
(4, 1, 'lg@fornecedor.com',         TRUE),
(4, 2, '(92) 99999-4444',           FALSE),
(5, 1, 'multi@fornecedor.com',      TRUE),
(5, 2, '(11) 98888-5555',           FALSE),
(5, 3, '(11) 3333-5555',            FALSE);

-- Categorias (com auto-relacionamento: subcategorias)
INSERT INTO tb_categoria (tx_nome, tx_descricao, cd_categoria_pai) VALUES
('Eletrônicos',     'Produtos eletrônicos em geral',       NULL),   -- 1
('Informática',     'Computadores e periféricos',           NULL),   -- 2
('Celulares',       'Smartphones e acessórios',             1),      -- 3 → filho de Eletrônicos
('Áudio e Vídeo',   'TVs, fones e caixas de som',          1),      -- 4 → filho de Eletrônicos
('Escritório',      'Material e equipamentos de escritório',NULL),   -- 5
('Notebooks',       'Notebooks e ultrabooks',               2),      -- 6 → filho de Informática
('Desktops',        'Computadores de mesa',                 2),      -- 7 → filho de Informática
('Periféricos',     'Mouse, teclado, monitor etc.',         2),      -- 8 → filho de Informática
('Smartwatches',    'Relógios inteligentes',                1),      -- 9 → filho de Eletrônicos
('Tablets',         'Tablets e e-readers',                  1);      -- 10 → filho de Eletrônicos

-- Produtos
INSERT INTO tb_produto (tx_nome, tx_descricao, tx_codigo_barras, vl_preco, vl_custo, nr_estoque, nr_estoque_min, cd_categoria, cd_fornecedor) VALUES
('Galaxy S24',          'Smartphone Samsung topo de linha',  '7891234000001', 4999.99, 3200.00, 50,  5,  3, 1),
('iPhone 15',           'Smartphone Apple com chip A16',     '7891234000002', 7499.99, 5100.00, 30,  5,  3, 2),
('Dell Inspiron 15',    'Notebook Dell i5 16GB RAM',         '7891234000003', 3499.99, 2200.00, 20,  3,  6, 3),
('LG OLED 55"',         'Smart TV OLED 4K 55 polegadas',     '7891234000004', 5999.99, 3800.00, 15,  2,  4, 4),
('Mouse Multilaser',    'Mouse sem fio ergonômico',          '7891234000005',   89.90,   35.00,200, 20,  8, 5),
('Teclado Multilaser',  'Teclado mecânico retroiluminado',   '7891234000006',  199.90,   80.00,150, 15,  8, 5),
('Samsung Galaxy Tab',  'Tablet Samsung 10.5" 128GB',        '7891234000007', 1899.99, 1200.00, 40,  5, 10, 1),
('AirPods Pro',         'Fone de ouvido sem fio Apple',      '7891234000008', 1799.99, 1100.00, 60,  5,  4, 2),
('Dell Monitor 27"',    'Monitor IPS Full HD 27 polegadas',  '7891234000009', 1299.99,  750.00, 35,  5,  8, 3),
('LG Soundbar',         'Soundbar 2.1 300W Bluetooth',       '7891234000010',  799.99,  430.00, 25,  5,  4, 4),
('Galaxy Watch 6',      'Smartwatch Samsung 44mm',           '7891234000011', 1499.99,  890.00, 45,  5,  9, 1),
('iPad Air',            'Tablet Apple M1 64GB',              '7891234000012', 5499.99, 3600.00, 18,  3, 10, 2),
('Multilaser Webcam',   'Webcam Full HD 1080p',              '7891234000013',  149.90,   55.00,100, 10,  8, 5),
('Samsung SSD 1TB',     'SSD NVMe M.2 1TB',                 '7891234000014',  399.99,  200.00, 80, 10,  2, 1),
('Dell Inspiron Desktop','Desktop Dell i7 32GB 1TB SSD',    '7891234000015', 5299.99, 3400.00, 10,  2,  7, 3);

-- Histórico de preços (alguns produtos já tiveram reajuste)
INSERT INTO tb_preco_historico (cd_produto, vl_preco_anterior, vl_preco_novo, dt_alteracao) VALUES
(1, 4599.99, 4999.99, '2024-02-01'),
(2, 6999.99, 7499.99, '2024-01-15'),
(3, 3199.99, 3499.99, '2024-03-10'),
(4, 5499.99, 5999.99, '2024-02-20'),
(11,1299.99, 1499.99, '2024-04-05');

-- Clientes
INSERT INTO tb_cliente (tx_nome, tx_cpf, cd_endereco, nr_idade) VALUES
('Ana Souza',      '111.111.111-11', 6,  29),
('Bruno Lima',     '222.222.222-22', 2,  35),
('Carla Mendes',   '333.333.333-33', 3,  42),
('Diego Ramos',    '444.444.444-44', 9,  27),
('Eva Costa',      '555.555.555-55', 5,  31),
('Felipe Nunes',   '666.666.666-66', 4,  55),
('Gabriela Pinto', '777.777.777-77', 6,  23),
('Henrique Alves', '888.888.888-88', 7,  48),
('Isabela Rocha',  '999.999.999-99', 8,  33),
('João Pedro',     '000.000.000-00', 10, 61);

-- Contatos dos Clientes (tb_contato)
INSERT INTO tb_contato (cd_cliente, cd_tipo_contato, tx_contato, fl_principal) VALUES
-- Ana Souza
(1, 1, 'ana@email.com',          TRUE),
(1, 2, '(49) 99111-0001',        FALSE),
-- Bruno Lima
(2, 1, 'bruno@email.com',        TRUE),
(2, 2, '(48) 99222-0002',        FALSE),
(2, 3, '(48) 3222-0002',         FALSE),
-- Carla Mendes
(3, 1, 'carla@email.com',        TRUE),
(3, 2, '(47) 99333-0003',        FALSE),
-- Diego Ramos
(4, 1, 'diego@email.com',        TRUE),
(4, 2, '(41) 99444-0004',        FALSE),
-- Eva Costa
(5, 1, 'eva@email.com',          TRUE),
(5, 2, '(51) 99555-0005',        FALSE),
(5, 3, '(51) 3555-0005',         FALSE),
-- Felipe Nunes (sem e-mail — só telefones)
(6, 2, '(11) 99666-0006',        TRUE),
(6, 3, '(11) 3666-0006',         FALSE),
-- Gabriela Pinto
(7, 1, 'gabi@email.com',         TRUE),
(7, 2, '(49) 99777-0007',        FALSE),
-- Henrique Alves
(8, 1, 'henri@email.com',        TRUE),
(8, 2, '(47) 99888-0008',        FALSE),
(8, 3, '(47) 3888-0008',         FALSE),
-- Isabela Rocha
(9, 1, 'isa@email.com',          TRUE),
(9, 2, '(47) 99999-0009',        FALSE),
-- João Pedro (sem e-mail — só telefones)
(10, 2, '(48) 90000-0010',       TRUE),
(10, 3, '(48) 3000-0010',        FALSE);

-- Funcionários
INSERT INTO tb_funcionario (tx_nome, tx_cpf, tx_cargo, vl_salario, cd_empresa, cd_endereco, dt_admissao) VALUES
('Marcos Vieira',    'AAA.111.111-11', 'Vendedor',   2800.00, 1, 6,  '2021-03-01'),
('Priscila Gomes',   'BBB.222.222-22', 'Gerente',    5500.00, 1, 6,  '2018-07-15'),
('Rafael Borges',    'CCC.333.333-33', 'Vendedor',   2800.00, 2, 2,  '2022-01-10'),
('Tatiane Lopes',    'DDD.444.444-44', 'Supervisora',4200.00, 2, 2,  '2019-09-05'),
('Cláudio Farias',   'EEE.555.555-55', 'Vendedor',   2800.00, 3, 3,  '2023-02-20'),
('Juliana Matos',    'FFF.666.666-66', 'Gerente',    5500.00, 3, 5,  '2016-04-12');

-- Contatos dos Funcionários
INSERT INTO tb_contato_funcionario (cd_funcionario, cd_tipo_contato, tx_contato, fl_principal) VALUES
(1, 1, 'marcos@techvenda.com',    TRUE),
(1, 2, '(49) 99100-1001',         FALSE),
(2, 1, 'priscila@techvenda.com',  TRUE),
(2, 2, '(49) 99100-1002',         FALSE),
(3, 1, 'rafael@megastore.com',    TRUE),
(3, 2, '(48) 99200-2001',         FALSE),
(4, 1, 'tatiane@megastore.com',   TRUE),
(5, 1, 'claudio@distsul.com',     TRUE),
(6, 1, 'juliana@distsul.com',     TRUE),
(6, 3, '(47) 3300-3001',          FALSE);

-- Cupons
INSERT INTO tb_cupom (tx_codigo, tx_descricao, vl_desconto, vl_percentual, nr_uso_maximo, dt_validade) VALUES
('PROMO10',  'Desconto de R$10 em qualquer compra',   10.00, NULL, 100, '2024-12-31'),
('DESC100',  'R$100 off em compras acima de R$1000',  100.00,NULL,  50, '2024-06-30'),
('PCT5',     '5% de desconto geral',                  NULL,   5.00,200, '2024-12-31'),
('VIP250',   'Cupom VIP R$250',                       250.00,NULL,  10, '2024-09-30'),
('TECH50',   'R$50 para produtos de informática',      50.00, NULL,  30, '2024-07-31');

-- Vendas
INSERT INTO tb_venda (cd_cliente, cd_empresa, cd_funcionario, tx_status, tx_forma_pagamento, nr_parcelas, vl_desconto, dt_venda, dt_entrega) VALUES
(1, 1, 1, 'PAGO',      'PIX',     1,   0.00, '2024-01-10 09:30:00', '2024-01-12 14:00:00'),
(2, 1, 1, 'PAGO',      'CARTAO',  3, 100.00, '2024-01-15 14:00:00', '2024-01-17 10:00:00'),
(3, 2, 3, 'PAGO',      'CARTAO',  6,   0.00, '2024-02-03 11:15:00', '2024-02-05 16:00:00'),
(4, 2, 3, 'CANCELADO', 'CARTAO',  1,   0.00, '2024-02-20 16:45:00', NULL),
(5, 3, 5, 'PAGO',      'BOLETO',  1, 250.00, '2024-03-05 10:00:00', '2024-03-10 09:00:00'),
(1, 1, 2, 'PAGO',      'PIX',     1,   0.00, '2024-03-22 13:30:00', '2024-03-24 11:00:00'),
(6, 3, 5, 'PENDENTE',  'BOLETO',  1,   0.00, '2024-04-01 09:00:00', NULL),
(7, 1, 1, 'PAGO',      'CARTAO',  2,  50.00, '2024-04-18 15:20:00', '2024-04-20 14:00:00'),
(8, 2, 4, 'PAGO',      'PIX',     1,   0.00, '2024-05-07 10:45:00', '2024-05-09 10:00:00'),
(9, 3, 6, 'PAGO',      'CARTAO', 12, 150.00, '2024-05-30 14:00:00', '2024-06-03 16:00:00'),
(2, 2, 3, 'PAGO',      'DINHEIRO',1,   0.00, '2024-06-12 11:00:00', '2024-06-14 09:00:00'),
(10,1, 2, 'PENDENTE',  'BOLETO',  1,   0.00, '2024-06-25 16:30:00', NULL);

-- Venda x Cupom
INSERT INTO tb_venda_cupom (cd_venda, cd_cupom, vl_aplicado) VALUES
(2,  2, 100.00),   -- Bruno usou DESC100
(5,  4, 250.00),   -- Eva usou VIP250
(8,  1,  10.00),   -- Gabriela usou PROMO10
(10, 3,  50.00);   -- Isabela usou PCT5 (aplicado como valor fixo)

-- Itens de Venda
INSERT INTO tb_item_venda (cd_venda, cd_produto, nr_quantidade, vl_unitario, vl_desconto_item) VALUES
-- Venda 1 (Ana - TechVenda - Marcos)
(1, 1, 1, 4999.99, 0.00),
(1, 5, 2,   89.90, 0.00),

-- Venda 2 (Bruno - TechVenda - Marcos)
(2, 3, 1, 3499.99, 0.00),
(2, 6, 1,  199.90, 0.00),
(2, 9, 1, 1299.99, 0.00),

-- Venda 3 (Carla - MegaStore - Rafael)
(3, 2, 1, 7499.99, 0.00),
(3, 8, 1, 1799.99, 0.00),

-- Venda 4 (Diego - MegaStore - Rafael - CANCELADO)
(4, 4, 1, 5999.99, 0.00),

-- Venda 5 (Eva - Distribuidora - Cláudio)
(5, 4, 1, 5999.99, 0.00),
(5,10, 1,  799.99, 0.00),

-- Venda 6 (Ana - TechVenda - Priscila)
(6,11, 1, 1499.99, 0.00),
(6, 7, 1, 1899.99, 0.00),

-- Venda 7 (Felipe - Distribuidora - PENDENTE)
(7,15, 1, 5299.99, 0.00),

-- Venda 8 (Gabriela - TechVenda - Marcos)
(8,12, 1, 5499.99, 0.00),
(8, 8, 1, 1799.99, 0.00),

-- Venda 9 (Henrique - MegaStore - Tatiane)
(9, 3, 1, 3499.99, 0.00),
(9,14, 2,  399.99, 0.00),

-- Venda 10 (Isabela - Distribuidora - Juliana)
(10, 1, 2, 4999.99, 0.00),
(10, 5, 3,   89.90, 0.00),

-- Venda 11 (Bruno - MegaStore - Rafael)
(11, 2, 1, 7499.99, 0.00),
(11,13, 1,  149.90, 0.00),

-- Venda 12 (João - TechVenda - Priscila - PENDENTE)
(12,15, 1, 5299.99, 0.00),
(12, 9, 2, 1299.99, 0.00);

-- Avaliações
INSERT INTO tb_avaliacao (cd_produto, cd_cliente, nr_nota, tx_comentario) VALUES
(1,  1, 5, 'Excelente smartphone, câmera incrível!'),
(1,  9, 4, 'Muito bom, mas veio sem película.'),
(2,  3, 5, 'Melhor celular que já tive.'),
(3,  2, 4, 'Rápido e bom custo-benefício.'),
(3,  8, 3, 'Trava um pouco ao abrir muitos apps.'),
(4,  5, 5, 'TV impressionante, imagem perfeita.'),
(8,  3, 5, 'Som excepcional, vale cada centavo.'),
(8,  7, 5, 'Melhor fone sem fio do mercado.'),
(9,  2, 4, 'Monitor com ótimas cores.'),
(11, 1, 5, 'Smartwatch completo, bateria excelente.'),
(12, 7, 5, 'iPad perfeito para trabalho e lazer.'),
(14, 8, 4, 'SSD rápido, instalação simples.');

SELECT
    tb_cliente.tx_nome AS nome_cliente,
    email.tx_contato AS email,
    telefone.tx_contato AS telefone,
    Celular.tx_contato AS Celular
FROM tb_cliente

INNER JOIN tb_contato email
    ON email.cd_cliente = tb_cliente.id_cliente
    AND email.cd_tipo_contato = 1

INNER JOIN tb_contato telefone
    ON telefone.cd_cliente = tb_cliente.id_cliente
    AND telefone.cd_tipo_contato = 2
INNER JOIN tb_contato Celular
    ON Celular.cd_cliente = tb_cliente.id_cliente
    AND Celular.cd_tipo_contato = 3
    
    SELECT
    tb_cliente.tx_nome AS nome_cliente,
    fl_principal.tx_contato AS fl_principal

FROM tb_cliente
    INNER JOIN tb_contato fl_principal
    ON fl_principal.cd_cliente = tb_cliente.id_cliente
    
    AND fl_principal.cd_tipo_contato = 1
    
    
    SELECT
    tb_cliente.tx_nome AS nome_cliente,
    email.tx_contato AS email


FROM tb_cliente

LEFT JOIN tb_contato email
    ON email.cd_cliente = tb_cliente.id_cliente
    AND email.cd_tipo_contato = 1
ORDER BY tb_cliente.tx_nome ASC;
--------------------------------------------------------------
SELECT
    tb_cliente.tx_nome AS nome_cliente,
    tb_avaliacao.cd_produto AS produto,
    tb_avaliacao.nr_nota AS nota,
    tb_avaliacao.tx_comentario AS comentario

FROM tb_cliente

INNER JOIN tb_avaliacao
    ON tb_avaliacao.cd_cliente = tb_cliente.id_cliente;
----------------------------------------------------------------

SELECT
    tx_nome,
    nr_idade
FROM tb_cliente
WHERE nr_idade > (
    SELECT SUM(nr_idade) / COUNT(id_cliente)
    FROM tb_cliente
);
-------------------------------------------------------

SELECT
    COUNT( email.cd_cliente) AS qtd_email,
    COUNT( telefone.cd_cliente) AS qtd_telefone,
    COUNT( celular.cd_cliente) AS qtd_celular
FROM tb_cliente

LEFT JOIN tb_contato email
    ON email.cd_cliente = tb_cliente.id_cliente
    AND email.cd_tipo_contato = 1

LEFT JOIN tb_contato telefone
    ON telefone.cd_cliente = tb_cliente.id_cliente
    AND telefone.cd_tipo_contato = 2

LEFT JOIN tb_contato celular
    ON celular.cd_cliente = tb_cliente.id_cliente
    AND celular.cd_tipo_contato = 3
group by tb_contato Celular;

---------------------------------------------------------
SELECT
    tb_cliente.tx_nome AS nome_cliente,
    tb_pedido.dt_compra AS data_compra
FROM tb_cliente
INNER JOIN tb_pedido
    ON tb_pedido.cd_cliente = tb_cliente.id_cliente
    limit 1
ORDER BY tb_pedido.dt_compra ASC;
