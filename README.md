# Sistema de Gerenciamento de E-Sports — Modelagem Relacional & MySQL

Projeto de engenharia e modelagem de banco de dados relacional desenvolvido no curso de **Análise e Desenvolvimento de Sistemas** da **Universidade Mogi das Cruzes (UMC)**. A proposta envolve a arquitetura completa do ecossistema de dados para administração de ligas de esportes eletrônicos, cobrindo organizações competitivas, atletas profissionais (*pro-players*), treinadores, campeonatos e confrontos.

---

## Ciclo de Desenvolvimento do Banco de Dados

O projeto foi executado seguindo formalmente as etapas de engenharia de software e banco de dados:

1. **Engenharia de Requisitos:** Mapeamento de entidades de negócio, regras de integridade e requisitos funcionais do ecossistema competitivo.
2. **Modelo Conceitual (MER / DER):** Elaboração de diagramas com justificativa teórica de cardinalidades mínimas e máximas.
3. **Modelo Lógico Relacional:** Resolução técnica de relacionamentos 1:1, 1:N e N:N, além do tratamento formal de atributos compostos e multivalorados.
4. **Normalização Formal (Até a 3FN):** Decomposição controlada para eliminação de redundâncias, dependências funcionais parciais e dependências transitivas.
5. **Dicionário de Dados & Implementação Física (DDL/DML):** Script SQL parametrizado para o SGBD **MySQL 8.0+** com integridade referencial e triggers/constraints de consistência.

---

## Regras de Negócio e Resolução Estrutural

* **Treinador ⟷ Equipe (1:1):** Exclusividade técnica. Uma equipe possui um único treinador e cada treinador comanda apenas uma organização. Resolvido no modelo lógico através de constraint `UNIQUE` na chave estrangeira (`Cod_Registo_Treinador`).
* **Equipe ⟷ Jogador (1:N):** Cada organização conta com múltiplos pro-players contratados, mas cada atleta mantém vínculo federativo exclusivo com apenas uma equipe por vez.
* **Equipe ⟷ Torneio (N:N):** Equipes disputam múltiplos campeonatos e cada torneio reúne diversas organizações. Resolvido mediante tabela associativa `EQUIPE_TORNEIO` com chave primária composta (`Nome_Oficial_Equipe`, `Codigo_Torneio`).
* **Torneio ⟷ Partida (1:N):** O chaveamento e histórico das partidas pertencem estritamente ao torneio de origem.
* **Tratamento de Atributo Multivalorado:** Os contatos de atendimento das equipes foram extraídos para a tabela `TELEFONE_EQUIPE` com chave primária composta (`Nome_Oficial_Equipe`, `Numero_Telefone`).
* **Tratamento de Atributo Composto:** Decomposição do nome do atleta em `Primeiro_Nome` e `Sobrenome` para assegurar atomicidade escalar na 1FN.

---

## Verificação Formal das Formas Normais

| Forma Normal | Validação e Aplicação no Projeto |
| :--- | :--- |
| **1FN (Primeira)** | Todos os atributos contêm valores atômicos e indivisíveis. Nomes compostos foram atomizados e atributos multivalorados (telefones) foram migrados para uma tabela dedicada. |
| **2FN (Segunda)** | Modelo na 1FN sem dependências parciais. Nas tabelas com chave primária composta (`EQUIPE_TORNEIO` e `TELEFONE_EQUIPE`), não existem atributos não-chave dependentes de frações da PK. |
| **3FN (Terceira)** | Modelo na 2FN sem dependências transitivas. Nenhum atributo não-chave determina outro atributo não-chave; todos dependem exclusivamente da chave primária. |

---

## 📂 Estrutura de Arquivos no Repositório

```bash
├── docs/
│   ├── modelo_conceitual_mer.pdf       # Diagrama Entidade-Relacionamento conceitual
│   ├── modelo_logico_der.pdf           # Diagrama lógico com mapeamento de PK, FK e UK
│   └── dicionario_de_dados.pdf         # Especificação formal de domínios, tipos e restrições
├── sql/
│   └── database_esports.sql            # Script DDL de criação do schema e DML de testes
└── README.md                           # Documentação central do projeto
