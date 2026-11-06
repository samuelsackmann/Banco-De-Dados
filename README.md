# Banco de Dados — SENAI

Repositório de estudos e atividades de Banco de Dados, com foco em PostgreSQL.

## Organização

| Pasta | Conteúdo |
|---|---|
| `01-fundamentos/` | DDL, criação de tabelas, tipos de usuário e estrutura básica |
| `02-modelagem-e-relacionamentos/` | Modelagem, chaves, relacionamentos e exercícios de escola/empresa |
| `03-consultas-e-agrupamentos/` | SELECT, JOIN, agregações, CTE e consultas |
| `04-objetos-do-banco/` | Sequences, índices, views, funções e triggers |
| `05-integracao/` | Scripts de integração do banco com o sistema |
| `06-seguranca-e-permissoes/` | Roles, GRANT e REVOKE |
| `07-exercicios/` | Exercícios independentes e estudos de caso |

## Como executar

1. Use PostgreSQL e abra o arquivo desejado no DBeaver ou `psql`.
2. Confira o conteúdo antes de executar: alguns arquivos são rascunhos ou continuações de aula.
3. Verifique dependências e ordem de execução. Nem todo arquivo é um script completo e independente.
4. Prefira executar exercícios em um banco de testes, pois alguns comandos usam `DROP`, `CREATE DATABASE` ou alteram estruturas existentes.

## Padrão de nomes

- Pastas numeradas por assunto para manter a navegação previsível.
- Arquivos SQL com nomes descritivos; quando a data é conhecida, ela aparece como `AAAA-MM-DD`.
- Os scripts originais foram preservados, sem correções automáticas no SQL.

## Convenção de commits

Use mensagens curtas no imperativo e com categoria:

- `docs:` documentação
- `feat:` novo exercício ou script
- `fix:` correção de SQL
- `refactor:` reorganização sem alterar o comportamento
- `chore:` manutenção de arquivos e estrutura

Exemplos:

- `feat: adiciona exercícios de joins e agregações`
- `feat: adiciona exemplos de functions e triggers`
- `fix: corrige relacionamentos da atividade de pedidos`
- `docs: documenta a estrutura do repositório`
