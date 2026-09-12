
CREATE TABLE tb_categoria (
  id_categoria  SERIAL          PRIMARY KEY,
  tx_nome       VARCHAR(100)    NOT NULL
);
 
CREATE TABLE tb_produto (
  id_produto    SERIAL          PRIMARY KEY,
  tx_nome       VARCHAR(150)    NOT NULL,
  vl_preco      NUMERIC(18,2)   NOT NULL,
  nr_estoque    NUMERIC(18,0)   DEFAULT 0,
  fl_ativo      BOOLEAN         DEFAULT TRUE,
  cd_categoria  INTEGER         REFERENCES tb_categoria(id_categoria)
);
 
CREATE TABLE tb_pedido (
  id_pedido     SERIAL          PRIMARY KEY,
  cd_produto    INTEGER         REFERENCES tb_produto(id_produto),

  nr_quantidade NUMERIC(18,0)   NOT NULL,
  dt_pedido     DATE            DEFAULT CURRENT_DATE
);

-- Adicionar coluna
ALTER TABLE tb_produto
  ADD COLUMN tx_obs VARCHAR(300);
 
-- Renomear coluna
ALTER TABLE tb_produto
  RENAME COLUMN tx_obs TO tx_descricao;
 
-- Mudar tipo da coluna
ALTER TABLE tb_produto
  ALTER COLUMN tx_descricao TYPE TEXT;
 
-- Remover coluna
ALTER TABLE tb_produto
  DROP COLUMN tx_descricao;


INSERT INTO tb_categoria (tx_nome) VALUES
  ('Eletrônicos'),
  ('Roupas'),
  ('Alimentos');
 
INSERT INTO tb_produto (tx_nome, vl_preco, nr_estoque, fl_ativo, cd_categoria) VALUES
  ('Notebook',        3500.00, 10,  TRUE,  1),
  ('Smartphone',      1800.00, 25,  TRUE,  1),
  ('Fone Bluetooth',   250.00, 50,  TRUE,  1),
  ('Camiseta',          59.90, 100, TRUE,  2),
  ('Calça Jeans',      129.90, 40,  TRUE,  2),
  ('Arroz 5kg',         28.50, 200, TRUE,  3),
  ('Feijão 1kg',        12.00, 180, FALSE, 3);
 
INSERT INTO tb_pedido (cd_produto, nr_quantidade, dt_pedido) VALUES
  (1,  2, '2024-01-10'),
  (2,  5, '2024-01-12'),
  (3,  3, '2024-01-15'),
  (4, 10, '2024-01-15'),
  (5,  4, '2024-02-01'),
  (1,  1, '2024-02-05'),
  (6, 20, '2024-02-10'),
  (7, 15, '2024-02-10'),
  (2,  2, '2024-03-01');




CREATE TABLE tb_cliente (
    id_cliente SERIAL PRIMARY KEY,
    tx_nome VARCHAR(255) NOT NULL,
    vl_idade NUMERIC(3,0) CHECK (vl_idade > 0) NOT NULL,
    tx_uf VARCHAR(2)  check (tx_uf = upper(tx_uf) ) NOT NULL
);
 

INSERT INTO tb_cliente (tx_nome, vl_idade, tx_uf)
VALUES
    ('Samuel', 18, 'SC'),
    ('João', 25, 'PR'),
    ('Maria', 30, 'RS'),
    ('Carlos', 22, 'SP'),
    ('Ana', 28, 'SC');

select* from  tb_cliente;



ALTER TABLE tb_pedido
ADD COLUMN cd_cliente INTEGER REFERENCES tb_cliente(id_cliente);

UPDATE tb_pedido
SET cd_cliente = 2
where  id_pedido = 2;

UPDATE tb_pedido
SET cd_cliente = 1
where  id_pedido in (5,3,7);

UPDATE tb_pedido
SET cd_cliente = 3
where  id_pedido in (4,6,8);

select * from tb_pedido;





Colunas esperadas: tx_produto, tx_categoria,
 nr_estoque_atual, vl_media_categoria,
 nr_diferenca

with estoque as (
select
cd_categoria,
sum(nr_estoque ) / count(id_produto )
as media
from
tb_produto
group by cd_categoria
)
select
produto.tx_descricao ,
cat.tx_descricao,
produto.nr_estoque,
estoque.media,
estoque.media - produto.nr_estoque as diferenca
from
tb_produto produto
inner join tb_categoria cat on
cat.id_categoria = produto.cd_categoria
inner join estoque on
estoque.cd_categoria = produto.cd_categoria
where
estoque.media > produto.nr_estoque





with funcao as (
select
count(tb_produto.id_produto) as total,
tb_categoria.tx_nome
from
tb_produto
inner join tb_categoria
on tb_categoria.id_categoria
= tb_produto.cd_categoria
where tb_produto.fl_ativo is true
group by tb_categoria.tx_nome
) select * from funcao where total > 2

Listar as categorias, exibindo seu nome e a quantidade de produtos vinculados com status ativo.
Busque o nome da categoria que possui mais de dois produtos vinculados. ( se possível usar having )

select
count(tb_produto.id_produto) as total,
tb_categoria.tx_nome
from
tb_produto
inner join tb_categoria
on tb_categoria.id_categoria
= tb_produto.cd_categoria
where tb_produto.fl_ativo is true
group by tb_categoria.tx_nome
having count(tb_produto.id_produto) > 2






