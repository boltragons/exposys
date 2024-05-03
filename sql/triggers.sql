-- VERIFICA SE O EXPOSITOR É UM ALUNO 
CREATE OR REPLACE FUNCTION validar_aluno_projeto()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM estuda WHERE id_aluno = NEW.id_aluno) THEN
        RAISE EXCEPTION 'A pessoa não é uma aluna e não pode estar o projeto';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_validar_aluno_projeto
BEFORE INSERT ON expositores_projetos
FOR EACH ROW
EXECUTE FUNCTION validar_aluno_projeto();

-- VERIFICA SE O PROJETO POSSUI 6 OU MENOS EXPOSITORES
CREATE FUNCTION verificar_expositores()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM expositores_projetos WHERE id_projeto = NEW.id_projeto) >= 6 THEN
        RAISE EXCEPTION 'O projeto já possui 6 expositores (quantidade máxima)';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_verificar_expositores
BEFORE INSERT ON expositores_projetos
FOR EACH ROW
EXECUTE FUNCTION verificar_expositores();

-- VERIFICA SE A NOTA ESTÁ ENTRE 0 E 10
CREATE OR REPLACE FUNCTION limitar_nota()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nota > 10 THEN
        RAISE EXCEPTION 'A nota não pode ser maior que 10';
    END IF;
    IF NEW.nota < 0 THEN
        RAISE EXCEPTION 'A nota não pode ser menor que 0';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_limitar_nota
BEFORE INSERT OR UPDATE ON participacoes_projetos
FOR EACH ROW
EXECUTE FUNCTION limitar_nota();

-- VERIFICA SE A PESSOA QUE ESTÁ VOTANDO NÃO APRESENTOU PROJETO NA MESMA EDIÇÃO.
CREATE OR REPLACE FUNCTION verificar_votacao_apresentacao()
RETURNS TRIGGER AS
$$ DECLARE apresentou_projeto BOOLEAN;
BEGIN
    SELECT TRUE INTO apresentou_projeto
    FROM expositores_projetos AS ep
    INNER JOIN projetos AS p ON ep.id_projeto = p.id
    INNER JOIN edicoes AS e ON p.id_edicao = e.id
    WHERE ep.id_aluno = NEW.id_pessoa AND e.id = (SELECT id_edicao FROM projetos WHERE id = NEW.id_projeto);
    IF apresentou_projeto THEN
        RAISE EXCEPTION 'A pessoa que apresentou um projeto na mesma edição não pode votar.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_verificar_votacao_apresentacao
BEFORE INSERT OR UPDATE ON participacoes_projetos
FOR EACH ROW
EXECUTE FUNCTION verificar_votacao_apresentacao();

-- VERIFICA SE A DATA DA AVALIAÇÃO É POSTERIOR À DATA DA EDIÇÃO.
CREATE OR REPLACE FUNCTION verificar_data_avaliacao()
    RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM projetos AS p
        INNER JOIN edicoes AS e ON p.id_edicao = e.id
        WHERE p.id = NEW.id_projeto AND NEW.data_av <= e.data_hora
    ) THEN
        RAISE EXCEPTION 'A data de avaliação deve ser posterior à data da edição do projeto.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_verificar_data_avaliacao
BEFORE INSERT OR UPDATE ON participacoes_projetos
FOR EACH ROW
EXECUTE FUNCTION verificar_data_avaliacao();
