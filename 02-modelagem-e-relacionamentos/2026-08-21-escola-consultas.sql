DROP TABLE IF EXISTS tb_matricula   CASCADE;
DROP TABLE IF EXISTS tb_nota        CASCADE;
DROP TABLE IF EXISTS tb_aluno       CASCADE;
DROP TABLE IF EXISTS tb_curso       CASCADE;
DROP TABLE IF EXISTS tb_turma       CASCADE;
DROP TABLE IF EXISTS tb_professor   CASCADE;
DROP TABLE IF EXISTS tb_disciplina  CASCADE;
 
DROP VIEW IF EXISTS vw_alunos_aprovados;
DROP VIEW IF EXISTS vw_media_por_turma;
 
-- ─────────────────────────────────────────────────────────────
-- 1. DDL – CRIAÇÃO DAS TABELAS
-- ─────────────────────────────────────────────────────────────
 
CREATE TABLE tb_curso (
    id_curso    SERIAL PRIMARY KEY,
    tx_nome     VARCHAR(100) NOT NULL,
    nr_carga_horaria INT NOT NULL
);
 
CREATE TABLE tb_professor (
    id_professor SERIAL PRIMARY KEY,
    tx_nome      VARCHAR(100) NOT NULL,
    tx_email     VARCHAR(100) UNIQUE,
    tx_especialidade VARCHAR(80)
);
 
CREATE TABLE tb_disciplina (
    id_disciplina SERIAL PRIMARY KEY,
    tx_nome       VARCHAR(100) NOT NULL,
    id_curso      INT REFERENCES tb_curso(id_curso),
    id_professor  INT REFERENCES tb_professor(id_professor),
    nr_carga_horaria INT NOT NULL
);
 
CREATE TABLE tb_turma (
    id_turma   SERIAL PRIMARY KEY,
    tx_codigo  VARCHAR(20) NOT NULL,  -- ex: 'WEB-2024-A'
    id_curso   INT REFERENCES tb_curso(id_curso),
    tx_periodo VARCHAR(20),           -- 'Manhã', 'Tarde', 'Noite'
    nr_ano     INT NOT NULL
);
 
CREATE TABLE tb_aluno (
    id_aluno   SERIAL PRIMARY KEY,
    tx_nome    VARCHAR(100) NOT NULL,
    tx_email   VARCHAR(100) UNIQUE,
    dt_nascimento DATE,
    tx_cidade  VARCHAR(80)
);
 
CREATE TABLE tb_matricula (
    id_matricula  SERIAL PRIMARY KEY,
    id_aluno      INT REFERENCES tb_aluno(id_aluno),
    id_turma      INT REFERENCES tb_turma(id_turma),
    dt_matricula  DATE DEFAULT CURRENT_DATE,
    tx_status     VARCHAR(20) DEFAULT 'Ativo'  -- 'Ativo', 'Trancado', 'Concluído'
);
 
CREATE TABLE tb_nota (
    id_nota       SERIAL PRIMARY KEY,
    id_matricula  INT REFERENCES tb_matricula(id_matricula),
    id_disciplina INT REFERENCES tb_disciplina(id_disciplina),
    vl_nota       NUMERIC(4,1) CHECK (vl_nota BETWEEN 0 AND 10),
    tx_bimestre   VARCHAR(10)  -- '1B', '2B', '3B', '4B'
);
 
-- ─────────────────────────────────────────────────────────────
-- 2. DML – INSERÇÃO DE DADOS
-- ─────────────────────────────────────────────────────────────
 
-- CURSOS
INSERT INTO tb_curso (tx_nome, nr_carga_horaria) VALUES
  ('Desenvolvimento Web Full Stack', 1600),
  ('Redes de Computadores',          1200),
  ('Banco de Dados',                  800),
  ('Análise e Desenvolvimento de Sistemas', 2000);
 
-- PROFESSORES
INSERT INTO tb_professor (tx_nome, tx_email, tx_especialidade) VALUES
  ('Carlos Mendes',   'carlos@escola.com',   'JavaScript / Node.js'),
  ('Ana Beatriz',     'ana@escola.com',       'PostgreSQL / SQL'),
  ('Roberto Lima',    'roberto@escola.com',   'Redes / Infraestrutura'),
  ('Fernanda Costa',  'fernanda@escola.com',  'React / Frontend'),
  ('Juliana Ramos',   'juliana@escola.com',   'Python / Data Science');
 
-- DISCIPLINAS
INSERT INTO tb_disciplina (tx_nome, id_curso, id_professor, nr_carga_horaria) VALUES
  ('HTML e CSS',          1, 4, 80),
  ('JavaScript',          1, 1, 120),
  ('Node.js',             1, 1, 100),
  ('React',               1, 4, 100),
  ('Banco de Dados SQL',  1, 2, 80),
  ('TypeScript',          1, 1, 80),
  ('SQL Avançado',        3, 2, 120),
  ('PostgreSQL Admin',    3, 2, 100),
  ('Redes Básicas',       2, 3, 120),
  ('Cabeamento e Infra',  2, 3, 100),
  ('Lógica de Programação', 4, 5, 80),
  ('Python Básico',       4, 5, 100);
 
-- TURMAS
INSERT INTO tb_turma (tx_codigo, id_curso, tx_periodo, nr_ano) VALUES
  ('WEB-2024-A', 1, 'Manhã',  2024),
  ('WEB-2024-B', 1, 'Noite',  2024),
  ('REDES-2024', 2, 'Tarde',  2024),
  ('BD-2024',    3, 'Manhã',  2024),
  ('ADS-2024',   4, 'Noite',  2024),
  ('WEB-2023-A', 1, 'Manhã',  2023);   -- turma antiga (sem alunos novos)
 
-- ALUNOS (17 alunos, referência à sua turma real 😉)
INSERT INTO tb_aluno (tx_nome, tx_email, dt_nascimento, tx_cidade) VALUES
  ('Lucas Oliveira',     'lucas@email.com',    '2005-03-10', 'Chapecó'),
  ('Mariana Santos',     'mariana@email.com',  '2004-07-22', 'São Miguel d''Oeste'),
  ('Gabriel Souza',      'gabriel@email.com',  '2005-01-05', 'Joinville'),
  ('Isabela Ferreira',   'isabela@email.com',  '2004-11-30', 'Florianópolis'),
  ('Matheus Alves',      'matheus@email.com',  '2005-05-15', 'Chapecó'),
  ('Julia Lima',         'julia@email.com',    '2004-09-08', 'Blumenau'),
  ('Pedro Rocha',        'pedro@email.com',    '2005-02-28', 'São Miguel d''Oeste'),
  ('Amanda Pereira',     'amanda@email.com',   '2004-12-12', 'Joinville'),
  ('Rafael Costa',       'rafael@email.com',   '2005-08-19', 'Chapecó'),
  ('Camila Martins',     'camila@email.com',   '2004-04-03', 'Florianópolis'),
  ('Bruno Carvalho',     'bruno@email.com',    '2005-06-25', 'Blumenau'),
  ('Letícia Gomes',      'leticia@email.com',  '2004-10-17', 'São Miguel d''Oeste'),
  ('Diego Ribeiro',      'diego@email.com',    '2005-09-01', 'Joinville'),
  ('Fernanda Barbosa',   'fernanda_a@email.com','2004-03-14', 'Chapecó'),
  ('Victor Mendonça',    'victor@email.com',   '2005-07-07', 'Florianópolis'),
  ('Thiago Nascimento',  'thiago@email.com',   '2004-08-23', 'Blumenau'),
  ('Aline Cardoso',      'aline@email.com',    '2005-04-11', 'São Miguel d''Oeste'),
  ('Felipe Torres',      'felipe@email.com',   '2003-12-30', 'Curitiba');   -- sem matrícula (para LEFT JOIN)
 
-- MATRÍCULAS
INSERT INTO tb_matricula (id_aluno, id_turma, dt_matricula, tx_status) VALUES
  -- Turma WEB-2024-A (manhã) – alunos 1 ao 8
  (1,  1, '2024-02-01', 'Ativo'),
  (2,  1, '2024-02-01', 'Ativo'),
  (3,  1, '2024-02-01', 'Ativo'),
  (4,  1, '2024-02-01', 'Ativo'),
  (5,  1, '2024-02-01', 'Ativo'),
  (6,  1, '2024-02-01', 'Trancado'),
  (7,  1, '2024-02-01', 'Ativo'),
  (8,  1, '2024-02-01', 'Ativo'),
  -- Turma WEB-2024-B (noite) – alunos 9 ao 14
  (9,  2, '2024-02-03', 'Ativo'),
  (10, 2, '2024-02-03', 'Ativo'),
  (11, 2, '2024-02-03', 'Ativo'),
  (12, 2, '2024-02-03', 'Ativo'),
  (13, 2, '2024-02-03', 'Ativo'),
  (14, 2, '2024-02-03', 'Ativo'),
  -- Turma BD-2024 – alunos 15 ao 17
  (15, 4, '2024-02-05', 'Ativo'),
  (16, 4, '2024-02-05', 'Ativo'),
  (17, 4, '2024-02-05', 'Ativo');
 
-- NOTAS (1º e 2º bimestre para turmas WEB e BD)
INSERT INTO tb_nota (id_matricula, id_disciplina, vl_nota, tx_bimestre) VALUES
-- Matrícula 1 (Lucas, WEB-A)
  (1, 1, 8.5, '1B'), (1, 1, 9.0, '2B'),
  (1, 2, 7.0, '1B'), (1, 2, 7.5, '2B'),
  (1, 5, 9.5, '1B'), (1, 5, 9.0, '2B'),
-- Matrícula 2 (Mariana, WEB-A)
  (2, 1, 9.0, '1B'), (2, 1, 9.5, '2B'),
  (2, 2, 8.0, '1B'), (2, 2, 8.5, '2B'),
  (2, 5, 10.0,'1B'), (2, 5, 9.5, '2B'),
-- Matrícula 3 (Gabriel, WEB-A)
  (3, 1, 6.0, '1B'), (3, 1, 6.5, '2B'),
  (3, 2, 5.5, '1B'), (3, 2, 6.0, '2B'),
  (3, 5, 7.0, '1B'), (3, 5, 7.5, '2B'),
-- Matrícula 4 (Isabela, WEB-A)
  (4, 1, 10.0,'1B'), (4, 1, 9.5, '2B'),
  (4, 2, 9.0, '1B'), (4, 2, 9.5, '2B'),
  (4, 5, 8.5, '1B'), (4, 5, 9.0, '2B'),
-- Matrícula 5 (Matheus, WEB-A)
  (5, 1, 4.5, '1B'), (5, 1, 5.0, '2B'),
  (5, 2, 3.5, '1B'), (5, 2, 4.0, '2B'),
  (5, 5, 5.5, '1B'), (5, 5, 6.0, '2B'),
-- Matrícula 7 (Pedro, WEB-A) – Julia está trancada, sem nota
  (7, 1, 7.5, '1B'), (7, 1, 8.0, '2B'),
  (7, 2, 6.5, '1B'), (7, 2, 7.0, '2B'),
-- Matrícula 8 (Amanda, WEB-A)
  (8, 1, 8.0, '1B'), (8, 1, 8.5, '2B'),
  (8, 2, 7.0, '1B'), (8, 2, 7.5, '2B'),
-- Matrículas 9-14 (WEB-B)
  (9,  1, 6.0, '1B'),  (9,  2, 7.0, '1B'),
  (10, 1, 9.0, '1B'),  (10, 2, 8.5, '1B'),
  (11, 1, 5.0, '1B'),  (11, 2, 4.5, '1B'),
  (12, 1, 7.5, '1B'),  (12, 2, 8.0, '1B'),
  (13, 1, 3.0, '1B'),  (13, 2, 3.5, '1B'),
  (14, 1, 8.5, '1B'),  (14, 2, 9.0, '1B'),
-- Matrículas 15-17 (BD-2024)
  (15, 7, 9.0, '1B'),  (15, 8, 8.5, '1B'),
  (16, 7, 7.5, '1B'),  (16, 8, 7.0, '1B'),
  (17, 7, 6.0, '1B'),  (17, 8, 5.5, '1B');
 


SELECT
    tx_nome,
    tx_cidade
FROM tb_aluno
ORDER BY tx_cidade ASC;


SELECT
    tb_aluno.tx_nome,
    tb_nota.vl_nota
FROM tb_aluno
INNER JOIN tb_matricula
    ON tb_matricula.id_aluno = tb_aluno.id_aluno
INNER JOIN tb_nota
    ON tb_nota.id_matricula = tb_matricula.id_matricula
WHERE tb_nota.vl_nota  < 5 
ORDER BY vl_nota ASC;

SELECT
    tb_turma.id_turma,
    tb_turma.tx_codigo
FROM tb_turma
LEFT JOIN tb_matricula
    ON tb_matricula.id_turma = tb_turma.id_turma
LEFT JOIN tb_nota
    ON tb_nota.id_matricula = tb_matricula.id_matricula
WHERE tb_nota.id_nota IS NULL
ORDER BY tb_turma.id_turma ASC;



SELECT
    tb_aluno.tx_nome,
    tb_matricula.tx_status
FROM tb_aluno
LEFT JOIN tb_matricula
    ON tb_matricula.id_aluno = tb_aluno.id_aluno
WHERE tb_matricula.tx_status IS NULL;

select 
    tx_nome,
    tx_cidade
FROM tb_aluno
 WHERE LOWER(tx_cidade) = LOWER ('chapecó') 
ORDER BY tx_cidade ASC;

explain
SELECT
    tb_aluno.tx_nome,
    tb_nota.vl_nota
FROM tb_aluno
INNER JOIN tb_matricula
    ON tb_matricula.id_aluno = tb_aluno.id_aluno
INNER JOIN tb_nota
    ON tb_nota.id_matricula = tb_matricula.id_matricula
WHERE tb_nota.vl_nota IN (5, 3, 7, 9)
ORDER BY tb_nota.vl_nota ASC;




SELECT
    tb_turma.tx_codigo,
    COUNT(tb_nota.vl_nota) 
    
FROM tb_turma
LEFT JOIN tb_matricula
    ON tb_matricula.id_turma = tb_turma.id_turma
LEFT JOIN tb_nota
    ON tb_nota.id_matricula = tb_matricula.id_matricula
    group by tx_codigo
ORDER BY tb_turma.tx_codigo ASC;

SELECT
    tx_cidade,
    sum(id_aluno)
FROM tb_aluno
GROUP BY tx_cidade
ORDER BY tx_cidade ASC;

