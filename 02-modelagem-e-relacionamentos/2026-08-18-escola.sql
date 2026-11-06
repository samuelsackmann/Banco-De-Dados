 
DROP TABLE IF EXISTS tb_nota        CASCADE;
DROP TABLE IF EXISTS tb_matricula   CASCADE;
DROP TABLE IF EXISTS tb_turma       CASCADE;
DROP TABLE IF EXISTS tb_disciplina  CASCADE;
DROP TABLE IF EXISTS tb_professor   CASCADE;
DROP TABLE IF EXISTS tb_aluno       CASCADE;
DROP TABLE IF EXISTS tb_curso       CASCADE;
 
-- Cursos oferecidos pela escola
CREATE TABLE tb_curso (
    id_curso          SERIAL          PRIMARY KEY,
    tx_nome           VARCHAR(100)    NOT NULL,
    nr_duracao_meses  NUMERIC(18,0)   NOT NULL
);
 
-- Alunos
CREATE TABLE tb_aluno (
    id_aluno    SERIAL          PRIMARY KEY,
    tx_nome     VARCHAR(100)    NOT NULL,
    tx_email    VARCHAR(150)    UNIQUE NOT NULL,
    dt_nasc     DATE,
    tx_cidade   VARCHAR(80),
    cd_curso    INTEGER         NOT NULL REFERENCES tb_curso(id_curso)
);
 
-- Professores
CREATE TABLE tb_professor (
    id_professor  SERIAL          PRIMARY KEY,
    tx_nome       VARCHAR(100)    NOT NULL,
    tx_email      VARCHAR(150)    UNIQUE NOT NULL,
    vl_salario    NUMERIC(18,3)   NOT NULL
);
 
-- Disciplinas
CREATE TABLE tb_disciplina (
    id_disciplina   SERIAL          PRIMARY KEY,
    tx_nome         VARCHAR(100)    NOT NULL,
    nr_carga_horaria NUMERIC(18,0)  NOT NULL,
    cd_professor    INTEGER         NOT NULL REFERENCES tb_professor(id_professor)
);
 
-- Turmas (disciplina + período)
CREATE TABLE tb_turma (
    id_turma       SERIAL          PRIMARY KEY,
    cd_disciplina  INTEGER         NOT NULL REFERENCES tb_disciplina(id_disciplina),
    tx_semestre    VARCHAR(10)     NOT NULL,
    tx_sala        VARCHAR(20)
);
 
-- Matrículas (aluno ↔ turma)
CREATE TABLE tb_matricula (
    id_matricula  SERIAL        PRIMARY KEY,
    cd_aluno      INTEGER       NOT NULL REFERENCES tb_aluno(id_aluno),
    cd_turma      INTEGER       NOT NULL REFERENCES tb_turma(id_turma),
    dt_matricula  DATE          NOT NULL DEFAULT CURRENT_DATE,
    UNIQUE (cd_aluno, cd_turma)
);
 
-- Notas (uma por matrícula)
CREATE TABLE tb_nota (
    id_nota       SERIAL          PRIMARY KEY,
    cd_matricula  INTEGER         NOT NULL REFERENCES tb_matricula(id_matricula),
    vl_nota_1     NUMERIC(18,3),
    vl_nota_2     NUMERIC(18,3),
    vl_nota_3     NUMERIC(18,3),
    vl_media      NUMERIC(18,3) GENERATED ALWAYS AS
                      (ROUND((vl_nota_1 + vl_nota_2 + vl_nota_3) / 3.0, 3)) STORED
);
 
 SELECT * from tb_curso;


SELECT * from tb_professor
inner join tb_disciplina on tb_disciplina.cd_profesor =
tb_professor.id_professor



SELECT * from tb_aluno
inner join tb_curso 
on
tb_curso.id_curso =
tb_aluno.cd_curso


SELECT
    tb_aluno.tx_nome,
    tb_curso.tx_nome,
    tb_nota.vl_nota_1,
    tb_nota.vl_nota_2,
    tb_nota.vl_nota_3,
    tb_nota.vl_media
FROM tb_aluno
INNER JOIN tb_curso
    ON tb_curso.id_curso = tb_aluno.cd_curso
INNER JOIN tb_matricula
    ON tb_matricula.cd_aluno = tb_aluno.id_aluno
INNER JOIN tb_nota
    ON tb_nota.cd_matricula = tb_matricula.id_matricula
WHERE tb_curso.id_curso IN (4, 2);
--  2. DADOS — INSERT
-- ============================================================
 
-- tb_curso
INSERT INTO tb_curso (tx_nome, nr_duracao_meses) VALUES
    ('Web Full Stack Development', 18),
    ('Sistemas para Internet',     24),
    ('Análise e Desenvolvimento',  24),
    ('Banco de Dados',             12);
 
-- tb_aluno
INSERT INTO tb_aluno (tx_nome, tx_email, dt_nasc, tx_cidade, cd_curso) VALUES
    ('Ana Souza',       'ana@email.com',      '2001-03-14', 'Florianópolis', 1),
    ('Carlos Mendes',   'carlos@email.com',   '2000-07-22', 'Joinville',     1),
    ('João Lima',       'joao@email.com',     '2002-01-05', 'Chapecó',       2),
    ('Maria Fernanda',  'maria@email.com',    '2001-11-30', 'Blumenau',      2),
    ('Pedro Alves',     'pedro@email.com',    '2003-05-18', 'Florianópolis', 3),
    ('Larissa Costa',   'larissa@email.com',  '2002-08-09', 'Joinville',     3),
    ('Rafael Torres',   'rafael@email.com',   '2001-04-27', 'Lages',         4),
    ('Juliana Pires',   'juliana@email.com',  '2000-12-03', 'Chapecó',       1),
    ('Bruno Farias',    'bruno@email.com',    '2003-02-14', 'Blumenau',      2),
    ('Camila Rocha',    'camila@email.com',   '2001-09-20', 'Florianópolis', 4),
    ('Thiago Nunes',    'thiago@email.com',   '2002-06-11', 'Joinville',     1),
    ('Isabela Martins', 'isabela@email.com',  '2000-10-25', 'Lages',         3);
 
-- tb_professor
INSERT INTO tb_professor (tx_nome, tx_email, vl_salario) VALUES
    ('Prof. Eduardo Santos', 'edu@escola.com',      4800.000),
    ('Profa. Renata Lima',   'renata@escola.com',   5200.000),
    ('Prof. André Gomes',    'andre@escola.com',    4500.000),
    ('Profa. Patrícia Dias', 'patricia@escola.com', 5000.000);
 
-- tb_disciplina
INSERT INTO tb_disciplina (tx_nome, nr_carga_horaria, cd_professor) VALUES
    ('HTML e CSS Avançado',     60,  1),
    ('TypeScript Fundamentos',  80,  1),
    ('Banco de Dados SQL',      80,  2),
    ('Desenvolvimento de APIs', 80,  3),
    ('React com TypeScript',    80,  1),
    ('Git e Versionamento',     40,  4),
    ('Redes de Computadores',   60,  4),
    ('Lógica de Programação',   60,  3);
 
-- tb_turma
INSERT INTO tb_turma (cd_disciplina, tx_semestre, tx_sala) VALUES
    (1, '2024-1', 'Lab 01'),
    (2, '2024-1', 'Lab 01'),
    (3, '2024-1', 'Lab 02'),
    (4, '2024-1', 'Lab 02'),
    (5, '2024-2', 'Lab 01'),
    (6, '2024-2', 'Lab 03'),
    (7, '2024-2', 'Lab 03'),
    (8, '2024-1', 'Lab 02');
 
-- tb_matricula
INSERT INTO tb_matricula (cd_aluno, cd_turma, dt_matricula) VALUES
    (1,1,'2024-02-10'),(1,2,'2024-02-10'),(1,3,'2024-02-10'),
    (2,1,'2024-02-11'),(2,2,'2024-02-11'),(2,4,'2024-02-11'),
    (3,3,'2024-02-12'),(3,4,'2024-02-12'),(3,8,'2024-02-12'),
    (4,3,'2024-02-12'),(4,5,'2024-02-12'),(4,6,'2024-02-12'),
    (5,1,'2024-02-13'),(5,6,'2024-02-13'),(5,7,'2024-02-13'),
    (6,2,'2024-02-14'),(6,3,'2024-02-14'),(6,8,'2024-02-14'),
    (7,4,'2024-02-15'),(7,5,'2024-02-15'),(7,7,'2024-02-15'),
    (8,1,'2024-02-16'),(8,2,'2024-02-16'),(8,3,'2024-02-16'),
    (9,4,'2024-02-17'),(9,6,'2024-02-17'),(9,8,'2024-02-17'),
   (10,5,'2024-02-18'),(10,7,'2024-02-18'),(10,3,'2024-02-18'),
   (11,1,'2024-02-19'),(11,2,'2024-02-19'),(11,4,'2024-02-19'),
   (12,3,'2024-02-20'),(12,5,'2024-02-20'),(12,6,'2024-02-20');
 
-- tb_nota
INSERT INTO tb_nota (cd_matricula, vl_nota_1, vl_nota_2, vl_nota_3) VALUES
    (1, 8.5, 7.0, 9.0),  (2, 6.0, 7.5, 8.0),  (3, 9.0, 8.5, 9.5),
    (4, 5.0, 6.0, 7.0),  (5, 4.5, 5.5, 6.0),  (6, 7.0, 8.0, 7.5),
    (7, 8.0, 9.0, 8.5),  (8, 6.5, 7.0, 7.5),  (9, 9.5, 9.0, 9.0),
   (10, 7.0, 8.0, 6.5), (11, 8.5, 7.5, 8.0), (12, 5.0, 5.5, 6.0),
   (13, 9.0, 9.5, 8.5), (14, 6.0, 6.5, 7.0), (15, 7.5, 8.0, 8.5),
   (16, 8.0, 7.0, 9.0), (17, 5.5, 6.0, 7.0), (18, 9.0, 8.5, 9.0),
   (19, 7.0, 7.5, 8.0), (20, 6.0, 5.5, 7.0), (21, 8.5, 9.0, 8.0),
   (22, 7.5, 8.5, 9.0), (23, 6.0, 7.0, 6.5), (24, 8.0, 7.5, 8.5),
   (25, 5.0, 6.0, 5.5), (26, 9.0, 8.5, 9.5), (27, 7.0, 8.0, 7.5),
   (28, 8.5, 9.0, 8.0), (29, 6.5, 7.0, 7.0), (30, 9.5, 9.0, 9.0),
   (31, 7.0, 8.0, 7.5), (32, 5.5, 6.0, 6.5), (33, 8.0, 8.5, 9.0),
   (34, 9.0, 8.0, 8.5), (35, 7.5, 7.0, 8.0), (36, 6.0, 6.5, 7.5);


