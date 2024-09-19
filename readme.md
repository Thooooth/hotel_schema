# Sistema de Reservas de Hotel

Este projeto implementa um sistema de reservas de hotel utilizando MySQL. O sistema permite o gerenciamento de hotéis, quartos, clientes, reservas e serviços adicionais.

## Estrutura do Banco de Dados

O banco de dados `hotel_reservas` consiste nas seguintes tabelas principais:

- `hoteis`: Armazena informações sobre os hotéis.
- `tipos_quarto`: Define os diferentes tipos de quartos disponíveis.
- `quartos`: Contém detalhes sobre cada quarto individual.
- `clientes`: Armazena informações dos clientes.
- `reservas`: Registra as reservas feitas pelos clientes.
- `servicos_adicionais`: Lista serviços extras oferecidos pelo hotel.
- `reserva_servicos`: Associa serviços adicionais às reservas.
- `pagamentos`: Registra os pagamentos das reservas.

## Funcionalidades Principais

1. Gerenciamento de hotéis e quartos.
2. Cadastro e gerenciamento de clientes.
3. Sistema de reservas com cálculo automático de valor.
4. Adição de serviços extras às reservas.
5. Controle de pagamentos.
6. Relatórios de ocupação e receita.

## Como Utilizar

1. Execute o script `hotel_schema.sql` em seu servidor MySQL para criar o banco de dados e as tabelas.
2. Implemente a lógica de backend para interagir com o banco de dados.
3. Desenvolva uma interface de usuário para o sistema de reservas.

## Considerações de Segurança

- Implemente autenticação e autorização robustas para proteger dados sensíveis.
- Use prepared statements para prevenir injeção de SQL.
- Implemente validação de dados em todas as entradas do usuário.
- Proteja informações de pagamento de acordo com as normas PCI DSS.

## Manutenção

- Monitore o desempenho das consultas e ajuste os índices conforme necessário.
- Implemente um sistema de backup regular.
- Mantenha os dados de teste separados dos dados de produção.

## Extensões Futuras

- Implementação de um sistema de fidelidade para clientes frequentes.
- Integração com sistemas de pagamento online.
- Adição de um módulo de avaliações de clientes.
- Implementação de um sistema de reservas online para clientes.
