CREATE OR REPLACE VIEW informacoes_projeto AS
SELECT 
	pro.id,
	pro.nome AS projeto, 
	pro.descricao, 
	DATE(ed.data_hora) AS data, 
	COUNT(pes.id) 
FROM 
	projetos AS pro 
JOIN 
	edicoes AS ed 
ON 
	pro.id_edicao = ed.id
LEFT JOIN
	expositores_projetos AS exp_proj
ON
	exp_proj.id_projeto = pro.id
LEFT JOIN
	pessoas AS pes
ON
	exp_proj.id_aluno = pes.id
JOIN
	estuda AS est
ON
	est.id_aluno = pes.id
GROUP BY
	pro.id,
	projeto,
	pro.descricao,
	data
ORDER BY
	projeto ASC;

CREATE OR REPLACE VIEW informacoes_expositores AS	
SELECT 
	pro.id AS id,
	pro.nome AS projeto, 
	DATE(ed.data_hora) AS data, 
	FORMAT('%s %s', pes.pnome, pes.snome) AS aluno,
	est.matricula AS matricula
FROM 
	projetos AS pro 
JOIN 
	edicoes AS ed 
ON 
	pro.id_edicao = ed.id
JOIN
	expositores_projetos AS exp_proj
ON
	exp_proj.id_projeto = pro.id
JOIN
	pessoas AS pes
ON
	exp_proj.id_aluno = pes.id
JOIN
	estuda AS est
ON
	est.id_aluno = pes.id
ORDER BY
	projeto ASC;	