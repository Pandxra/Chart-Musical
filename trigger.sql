-- função executada por uma trigger que checa a idade que está sendo inserida
CREATE OR REPLACE FUNCTION checa_idade()
RETURNS trigger AS $$
DECLARE
	ano_nasc integer; -- ano da data de nascimento fornecida
	ano_atual integer; -- ano atual
BEGIN
	-- seleciona o ano de nascimento recebido
	SELECT date_part('year', (NEW.dataNasc)) into ano_nasc;

	-- seleciona o ano atual
	SELECT date_part('year', (SELECT current_timestamp)) into ano_atual;

	-- checa se a idade está entre 10 e 125 anos
	IF (ano_atual - ano_nasc >= 10) AND (ano_atual - ano_nasc <= 125) THEN
		-- calcula a idade e atualiza o atributo 'idade'
		NEW.idade := ano_atual - ano_nasc;

		RETURN NEW; -- passou pela verificação, então a idade é válida
	END IF;

	-- a idade é inválida, não realiza a inserção
	RAISE EXCEPTION 'Idade inválida!';
	RETURN NULL;
END
$$ LANGUAGE plpgsql;

-- trigger que checa se a idade é válida
CREATE TRIGGER t_checa_idade
BEFORE INSERT OR UPDATE ON pessoa
FOR EACH ROW
EXECUTE PROCEDURE checa_idade();


-- função executada por uma trigger que checa o número de telefone que está sendo inserido
CREATE OR REPLACE FUNCTION checa_telefone()
RETURNS trigger AS $$
DECLARE
	phone VARCHAR(1); -- formatação do telefone
BEGIN
	-- checa se o tamanho (quantidade de números) está correto
	IF (SELECT LENGTH(NEW.telefone) = 11) THEN
		-- verifica se existem apenas números
		FOR i IN 1..11 LOOP
			SELECT SUBSTRING(NEW.telefone, i, 1) into phone;

			-- retorna um erro se tentar converter algo que não seja um número
			PERFORM CAST(CAST(phone AS INTEGER) AS BOOLEAN);
		END LOOP;

		-- formata o telefone
		SELECT '(' || LEFT(NEW.telefone, 2) || ') ' || RIGHT(NEW.telefone, 9) into NEW.telefone;

		RETURN NEW; -- passou pela verificação, o telefone é válido
	END IF;

	-- o telefone é inválido, não realiza a inserção
	RAISE EXCEPTION 'Número de telefone inválido!';
	RETURN NULL;
END
$$ LANGUAGE plpgsql;

-- trigger que checa se o telefone de usuário é válido
CREATE TRIGGER t_checa_telefone_usuario
BEFORE INSERT OR UPDATE ON usuario
FOR EACH ROW
EXECUTE PROCEDURE checa_telefone();

-- trigger que checa se o telefone de usuário é válido
CREATE TRIGGER t_checa_telefone_empresa
BEFORE INSERT OR UPDATE ON empresa
FOR EACH ROW
EXECUTE PROCEDURE checa_telefone();


-- função executada por uma trigger que checa se o album possui pelo menos uma musica antes de permitir que seja favoritado
CREATE OR REPLACE FUNCTION album_valido()
RETURNS trigger AS $$
DECLARE
	quantidade integer;
BEGIN
	
	SELECT COUNT(album) FROM musica 
	WHERE album = NEW.album
	INTO quantidade;
	
	IF (quantidade < 1) THEN 
		RAISE EXCEPTION 'Álbum não possui nenhuma música!';
		RETURN NULL;
	END IF;
	RETURN NEW;
	
END
$$ LANGUAGE plpgsql;

-- trigger que checa se o album possui alguma musica
CREATE TRIGGER checa_validade_album
BEFORE INSERT OR UPDATE ON favoritar_album
FOR EACH ROW
EXECUTE PROCEDURE album_valido();
