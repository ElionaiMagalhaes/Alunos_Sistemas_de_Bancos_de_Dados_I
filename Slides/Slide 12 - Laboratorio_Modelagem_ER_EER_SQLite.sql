-- Laboratório complementar: modelagem ER e implementação relacional
-- Disciplina: Sistemas de bancos de dados
-- Ambiente: DBeaver com SQLite
-- Atenção: este script implementa o exercício da biblioteca no modelo relacional.
-- A hierarquia EER (LEITOR -> ESTUDANTE/SERVIDOR) é discutida no diagrama
-- conceitual e NÃO é implementada neste roteiro simplificado.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS emprestimo;
DROP TABLE IF EXISTS livro;
DROP TABLE IF EXISTS leitor;

CREATE TABLE leitor (
    id_leitor INTEGER PRIMARY KEY,
    nome TEXT NOT NULL
);

CREATE TABLE livro (
    id_livro INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL
);

CREATE TABLE emprestimo (
    id_emprestimo INTEGER PRIMARY KEY,
    id_leitor INTEGER NOT NULL,
    id_livro INTEGER NOT NULL,
    data_retirada TEXT NOT NULL,
    devolucao_prevista TEXT NOT NULL,
    devolucao_real TEXT,
    FOREIGN KEY (id_leitor) REFERENCES leitor(id_leitor),
    FOREIGN KEY (id_livro) REFERENCES livro(id_livro)
);

INSERT INTO leitor (id_leitor, nome) VALUES
(1, 'Ana Lima'), (2, 'Bruno Reis'), (3, 'Carla Melo');

INSERT INTO livro (id_livro, titulo) VALUES
(10, 'Introdução a Banco de Dados'),
(11, 'Modelagem de Dados'),
(12, 'Fundamentos de SQL');

INSERT INTO emprestimo
(id_emprestimo, id_leitor, id_livro, data_retirada, devolucao_prevista, devolucao_real)
VALUES
(100, 1, 10, '2026-10-01', '2026-10-15', '2026-10-14'),
(101, 1, 11, '2026-10-05', '2026-10-19', NULL),
(102, 2, 10, '2026-10-10', '2026-10-24', NULL);

-- Observe a cardinalidade: Ana possui dois empréstimos, Bruno possui um
-- e Carla ainda não possui empréstimos (participação mínima zero).
SELECT l.nome, COUNT(e.id_emprestimo) AS total_emprestimos
FROM leitor AS l
LEFT JOIN emprestimo AS e ON e.id_leitor = l.id_leitor
GROUP BY l.id_leitor, l.nome
ORDER BY l.nome;

-- Observe o vínculo obrigatório de cada empréstimo com leitor e livro.
SELECT e.id_emprestimo, l.nome AS leitor, b.titulo AS livro,
       e.data_retirada, e.devolucao_prevista
FROM emprestimo AS e
JOIN leitor AS l ON l.id_leitor = e.id_leitor
JOIN livro AS b ON b.id_livro = e.id_livro
ORDER BY e.id_emprestimo;

-- Conferir os vínculos de chave estrangeira no SQLite:
PRAGMA foreign_key_list(emprestimo);
