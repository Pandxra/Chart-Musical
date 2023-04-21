-- cria a tabela ‘pessoa’
CREATE TABLE pessoa (
	id_pessoa VARCHAR(11) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	genero VARCHAR(10) CHECK (genero IN ('F', 'M', 'OUTRO')) DEFAULT 'OUTRO',
	dataNasc date NOT NULL, 
	idade INTEGER -- minimo de 10 anos
);

-- cria a tabela ‘usuario’, especialização de ‘pessoa’
CREATE TABLE usuario (
	id_usuario VARCHAR(11) PRIMARY KEY,
	nome_usuario VARCHAR(50) UNIQUE NOT NULL,
	email VARCHAR(50) UNIQUE NOT NULL,
	senha VARCHAR(20) NOT NULL,
	telefone VARCHAR(15) UNIQUE,
	FOREIGN KEY (id_usuario) REFERENCES pessoa (id_pessoa)
	ON DELETE CASCADE
);

-- cria a tabela ‘compositor’, especialização de ‘pessoa’
CREATE TABLE compositor (
	id_compositor VARCHAR(11) PRIMARY KEY,
	pseudonimo VARCHAR(50) NOT NULL,
	instagram VARCHAR(30) UNIQUE,
	twitter VARCHAR(30) UNIQUE,
	FOREIGN KEY (id_compositor) REFERENCES pessoa (id_pessoa)
	ON DELETE CASCADE
);

-- cria a tabela ‘empresa’
CREATE TABLE empresa (
	CNPJ VARCHAR(14) PRIMARY KEY,
	nome VARCHAR(30) NOT NULL,
	email VARCHAR(50) UNIQUE NOT NULL,
	telefone VARCHAR(15) UNIQUE NOT NULL, -- POSSIBILIDADE DE TRIGGER CHECAGEM PRA VALIDAR NUMERO DE TELEFONE
	pais VARCHAR(20) NOT NULL,
	cidade VARCHAR(20) NOT NULL,
	bairro VARCHAR(20) NOT NULL,
	rua VARCHAR(20) NOT NULL,
	numero INTEGER NOT NULL CHECK (numero > 0)
);

-- cria a tabela ‘artista’
CREATE TABLE artista (
	id_artista INTEGER PRIMARY KEY,
	ano_estreia INTEGER NOT NULL CHECK (ano_estreia > 1930 AND ano_estreia < 2024),
	nome_artistico VARCHAR(30) NOT NULL,
	empresa VARCHAR(14) DEFAULT NULL,
	FOREIGN KEY (empresa) REFERENCES empresa(CNPJ)
	ON DELETE CASCADE
);

-- cria a tabela ‘album’
CREATE TABLE album (
	id_album INTEGER PRIMARY KEY,
	genero VARCHAR(30) CHECK (genero IN ('POP', 'ELETRONICA', 'HIP HOP', 'FUNK', 'ROCK', 'GOSPEL', 'PUNK', 'INDIE', 'COUNTRY', 'LATINA', 'OUTRO')) DEFAULT 'OUTRO',
	ano INTEGER NOT NULL CHECK (ano > 1930 AND ano < 2024),
	titulo VARCHAR(30) NOT NULL,
	artista INTEGER NOT NULL,
	FOREIGN KEY (artista) REFERENCES artista(id_artista)
	ON DELETE CASCADE
);

-- cria a tabela ‘musica’
CREATE TABLE musica (
	album INTEGER NOT NULL,
	num_faixa INTEGER  NOT NULL CHECK (num_faixa > 0),
	nome_faixa VARCHAR(30) NOT NULL,
	duracao TIME NOT NULL,
	idioma VARCHAR(10) CHECK (idioma IN ('INGLES', 'PORTUGUES', 'ESPANHOL', 'JAPONES', 'COREANO', 'OUTRO')) DEFAULT 'OUTRO',
	PRIMARY KEY (album, num_faixa),

	FOREIGN KEY (album) REFERENCES album (id_album)
	ON DELETE CASCADE
);

-- cria a tabela ‘favoritar_musica’
CREATE TABLE favoritar_musica (
	usuario VARCHAR(11) NOT NULL,
	album INTEGER NOT NULL,
	num_faixa INTEGER NOT NULL,
	
	PRIMARY KEY (usuario, album, num_faixa),
	
	
	FOREIGN KEY (usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE,
	FOREIGN KEY (album, num_faixa) REFERENCES musica (album, num_faixa) ON DELETE CASCADE
	
);

-- cria a tabela ‘favoritar_album’
CREATE TABLE favoritar_album (
	usuario VARCHAR(11) NOT NULL,
	album INTEGER NOT NULL,
	
	PRIMARY KEY (usuario, album),
	
	FOREIGN KEY (usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE,
	FOREIGN KEY (album) REFERENCES album (id_album) ON DELETE CASCADE
);

CREATE TABLE escrever_musica (
	compositor VARCHAR(11) NOT NULL,
	album INTEGER NOT NULL,
	musica INTEGER NOT NULL,
	
	PRIMARY KEY (compositor, album, musica),
	
	FOREIGN KEY (compositor) REFERENCES compositor (id_compositor) ON DELETE CASCADE,
	FOREIGN KEY (album, musica) REFERENCES musica (album, num_faixa ) ON DELETE CASCADE
);