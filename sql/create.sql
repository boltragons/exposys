CREATE TABLE cursos (
	id SERIAL,
  	nome VARCHAR(50) NOT NULL UNIQUE,
	PRIMARY KEY ("id")
);

CREATE TABLE pessoas (
    id SERIAL,
    cpf CHAR(14) NOT NULL UNIQUE CHECK (cpf ~ '^\d{3}\.\d{3}\.\d{3}-\d{2}$'),
    pnome VARCHAR(100) NOT NULL,
    snome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    telefone CHAR(15) UNIQUE CHECK (telefone ~ '^\(\d{2}\) \d{5}-\d{4}$'),
    login VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL,
    eh_adm BOOLEAN DEFAULT FALSE,
    biografia VARCHAR(250),
    PRIMARY KEY (id)
);

CREATE TABLE estuda (
	id_curso INT REFERENCES cursos(id) ON DELETE CASCADE NOT NULL,
	id_aluno INT REFERENCES pessoas(id) ON DELETE CASCADE NOT NULL,
	matricula CHAR(6) NOT NULL UNIQUE,
	PRIMARY KEY ("id_curso", "id_aluno")
);

CREATE TABLE edicoes (
	id SERIAL,
  	data_hora TIMESTAMP NOT NULL UNIQUE,
	PRIMARY KEY ("id")
);

CREATE TABLE projetos (
	id SERIAL,
  	nome VARCHAR(100) NOT NULL,
  	descricao VARCHAR(250),
  	id_edicao INT REFERENCES edicoes(id) ON DELETE CASCADE NOT NULL,
	PRIMARY KEY ("id")
);

CREATE TABLE expositores_projetos (
	id_aluno INT REFERENCES pessoas(id) ON DELETE CASCADE NOT NULL,
	id_projeto INT REFERENCES projetos(id) ON DELETE CASCADE NOT NULL,
	PRIMARY KEY ("id_aluno", "id_projeto")
);

CREATE TABLE participacoes_projetos (
	id_pessoa INT REFERENCES pessoas(id) ON DELETE CASCADE NOT NULL,
	id_projeto INT REFERENCES projetos(id) ON DELETE CASCADE NOT NULL,
	data_av TIMESTAMP NOT NULL,
	nota DECIMAL(10, 2),
	comentario VARCHAR(250),
	PRIMARY KEY ("id_pessoa", "id_projeto")
);


