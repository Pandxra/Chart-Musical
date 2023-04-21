-- Consulta 1
-- quais sao as musicas lançadas em um determinado ano
select mu.nome_faixa, al.titulo 
from musica mu join album al on mu.album = al.id_album 
where al.ano = 2022;

-- Consulta 2
-- qual é o album mais favoritado
select al.titulo, tabela.qtde_favoritos from album al join (
	select album, count(album) as qtde_favoritos 
	from favoritar_album
	group by album
) tabela
on al.id_album = tabela.album
order by tabela.qtde_favoritos desc limit 1;

-- Consulta 3
-- quantos artistas nao sao agenciados por nenhuma empresa
select count(id_artista) as quantidade
from artista 
where empresa is null;

--Consulta 4
-- qual compositor com mais musicas escritas
select comp.id_pessoa, comp.nome, num_composicoes from (
	select compositor, count(*) as num_composicoes 
	from escrever_musica em
	group by em.compositor
) tabela 
join 
pessoa comp
on comp.id_pessoa = tabela.compositor
order by num_composicoes desc limit 1;

-- Consulta 5
--  quantos usuarios favoritaram uma musica e tambem o album a que ela pertence
select count(usuario) from 
 ((select album, usuario from favoritar_album) 
 intersect 
 (select album, usuario from favoritar_musica)) tabela

-- Consulta 6
-- qual a duracao media das musicas por album
select al.titulo, tabela.duracao_media from album al join (
	select album, avg(duracao) as duracao_media 
	from musica
	group by album
) tabela
on al.id_album = tabela.album