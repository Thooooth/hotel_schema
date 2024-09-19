CREATE DATABASE IF NOT EXISTS hotel_reservas;
USE hotel_reservas;

CREATE TABLE hoteis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    classificacao INT CHECK (classificacao BETWEEN 1 AND 5),
    telefone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE tipos_quarto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    capacidade INT NOT NULL
);

CREATE TABLE quartos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT,
    tipo_quarto_id INT,
    numero VARCHAR(10) NOT NULL,
    andar INT,
    status ENUM('disponivel', 'ocupado', 'manutencao') DEFAULT 'disponivel',
    preco_diaria DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES hoteis(id),
    FOREIGN KEY (tipo_quarto_id) REFERENCES tipos_quarto(id)
);

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cpf VARCHAR(11) UNIQUE,
    data_nascimento DATE,
    endereco VARCHAR(255),
    cidade VARCHAR(100),
    estado CHAR(2),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reservas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    quarto_id INT,
    data_checkin DATE NOT NULL,
    data_checkout DATE NOT NULL,
    num_hospedes INT NOT NULL,
    status ENUM('confirmada', 'cancelada', 'concluida') DEFAULT 'confirmada',
    valor_total DECIMAL(10, 2) NOT NULL,
    data_reserva DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (quarto_id) REFERENCES quartos(id)
);

CREATE TABLE servicos_adicionais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL
);

CREATE TABLE reserva_servicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT,
    servico_id INT,
    quantidade INT DEFAULT 1,
    data_solicitacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reserva_id) REFERENCES reservas(id),
    FOREIGN KEY (servico_id) REFERENCES servicos_adicionais(id)
);

CREATE TABLE pagamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT,
    valor DECIMAL(10, 2) NOT NULL,
    metodo_pagamento ENUM('credito', 'debito', 'dinheiro', 'pix') NOT NULL,
    status ENUM('pendente', 'aprovado', 'recusado') DEFAULT 'pendente',
    data_pagamento DATETIME,
    FOREIGN KEY (reserva_id) REFERENCES reservas(id)
);

-- Índices
CREATE INDEX idx_reservas_cliente ON reservas(cliente_id);
CREATE INDEX idx_reservas_quarto ON reservas(quarto_id);
CREATE INDEX idx_quartos_hotel ON quartos(hotel_id);
CREATE INDEX idx_reserva_servicos_reserva ON reserva_servicos(reserva_id);

-- Triggers
DELIMITER //

CREATE TRIGGER atualiza_status_quarto AFTER INSERT ON reservas
FOR EACH ROW
BEGIN
    UPDATE quartos SET status = 'ocupado'
    WHERE id = NEW.quarto_id AND NEW.status = 'confirmada';
END;
//

CREATE TRIGGER calcula_valor_total BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN
    DECLARE dias INT;
    DECLARE preco_diaria DECIMAL(10, 2);
    
    SET dias = DATEDIFF(NEW.data_checkout, NEW.data_checkin);
    SELECT preco_diaria INTO preco_diaria FROM quartos WHERE id = NEW.quarto_id;
    
    SET NEW.valor_total = dias * preco_diaria;
END;
//

DELIMITER ;

-- Views
CREATE VIEW ocupacao_atual AS
SELECT h.nome AS hotel, COUNT(r.id) AS quartos_ocupados, 
       (SELECT COUNT(*) FROM quartos WHERE hotel_id = h.id) AS total_quartos
FROM hoteis h
LEFT JOIN quartos q ON h.id = q.hotel_id
LEFT JOIN reservas r ON q.id = r.quarto_id AND r.status = 'confirmada'
    AND CURDATE() BETWEEN r.data_checkin AND r.data_checkout
GROUP BY h.id;

CREATE VIEW receita_mensal AS
SELECT DATE_FORMAT(r.data_checkin, '%Y-%m') AS mes,
       SUM(r.valor_total) AS receita_total
FROM reservas r
WHERE r.status = 'concluida'
GROUP BY DATE_FORMAT(r.data_checkin, '%Y-%m')
ORDER BY mes DESC;
