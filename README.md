# Karate AI & Automation Starter 🥋

Projeto de automação de testes com **Karate Framework (1.4.1)**, **Maven** e **JUnit 5** para UI e API, incluindo uma aplicação local reproduzível e suíte completa para a [Loja de Testes pública](https://portfolio-omega-six-18.vercel.app/automation).

## Requisitos

- **Java JDK 11 ou superior** (homologado inclusive com Java 17 e 21 LTS)
- **Apache Maven 3.9 ou superior**
- **Node.js 18 ou superior** (para execução da aplicação local de demonstração)
- **Google Chrome** (para os testes de interface gráfica com Karate Driver)

## O que o projeto demonstra

- Automação de testes Karate de UI e API com sintaxe nativa BDD/Gherkin.
- Testes E2E de uma aplicação local reproduzível (**Wallet API** e **Login UI**), sem depender de serviços externos.
- Suíte completa de testes de contrato, integridade de cabeçalhos HTTP, autenticação e regras de negócio para a [Loja de Testes](https://portfolio-omega-six-18.vercel.app/automation).
- Suporte a eventos reais de teclado (`Key.TAB`, `Key.ENTER`) e manipulação de elementos via Chrome DevTools Protocol (CDP).
- Relatórios nativos ricos em HTML interativo com métricas de tempo, requisições, payloads e status de cada passo.

## Estrutura

```text
karate-api-automation-lab/
├── demo/                                    # Aplicação local reproduzível (Node.js)
│   ├── index.html                           # Interface visual da demo (login & dashboard)
│   └── server.mjs                           # Servidor HTTP com endpoints de Wallet e Login
├── karate-automation-portfolio/             # Módulo do projeto Maven / Karate JUnit 5
│   ├── pom.xml                              # Dependências do Karate 1.4.1 e Surefire
│   └── src/test/java/
│       ├── karate-config.js                 # Configurações globais de ambiente e timeouts
│       └── automation/
│           ├── TestRunner.java              # JUnit 5 Runner modular
│           ├── loja_testes.feature          # Suíte completa da Loja de Testes pública
│           ├── autenticacao_ui.feature      # Automação de interface no Chrome (Login & Teclado)
│           ├── catalogo_carrinho_ui.feature # Automação de interface no Chrome (Catálogo & Carrinho)
│           ├── demo_wallet_api.feature      # Teste replicado da Wallet API local
│           ├── demo_login_api.feature       # Teste replicado de Login API local
│           └── demo_login_ui.feature        # Teste replicado de Login UI local
├── package.json                             # Scripts npm integrados
├── pom.xml                                  # Maven Aggregator raiz
└── README.md                                # Documentação técnica
```

## Instalação

Compile o projeto e baixe as dependências do Maven:

```bash
mvn clean compile
```

## Executar a demo e os testes locais

Inicie a aplicação de demonstração em um terminal:

```bash
npm run demo
```

Ela ficará disponível em `http://localhost:3000`. A tela de login usa estas credenciais locais:

```text
E-mail: demo@example.com
Senha:  Cypress123!
```

O endpoint de exemplo `GET /api/wallet/balance/demo-wallet` retorna uma carteira fixa com saldo de demonstração:

```json
{
  "walletId": "demo-wallet",
  "balance": 125.5,
  "currency": "BRL"
}
```

Em outro terminal, execute os testes da demo local:

```bash
npm run test:demo
# ou via Maven:
mvn test -Dtest=TestRunner#testDemoSuite
```

> **Atenção:** A aplicação é apenas uma demo local. Credenciais fixas e endpoints simplificados não devem ser usados em produção.

## Executar a suíte da Loja de Testes (Pública)

Para executar a suíte completa contra a aplicação pública [Automação QA](https://portfolio-omega-six-18.vercel.app/automation):

```bash
npm run test:loja
# ou via Maven:
mvn test -Dtest=TestRunner#testLojaSuite
```

Para executar testes de API sem interface gráfica:

```bash
npm run test:api
# ou via Maven:
mvn test "-Dkarate.options=--tags ~@ui"
```

Para executar testes de interface gráfica no Google Chrome via Karate Driver:

```bash
npm run test:ui
# ou via Maven:
mvn test "-Dkarate.options=--tags @ui"
```

## Scripts disponíveis

| Comando | Descrição |
| --- | --- |
| `npm run demo` | Inicia a aplicação local de demonstração em `http://localhost:3000` |
| `npm test` | Executa a suíte principal da Loja de Testes via Karate JUnit 5 |
| `npm run test:all` | Executa todas as features do projeto (Loja pública + Demo local) |
| `npm run test:loja` | Executa os testes de API e UI da Loja de Testes pública |
| `npm run test:demo` | Executa os testes replicados da Wallet API e Login local |
| `npm run test:api` | Executa apenas os testes de API (sem navegador) |
| `npm run test:ui` | Executa os testes de UI no Google Chrome via Karate Driver |
| `npm run report` | Abre o relatório interativo HTML gerado no navegador padrão |

## Relatórios de Execução

Após a execução, visualize o relatório gerado pelo Karate:

```powershell
start karate-automation-portfolio/target/karate-reports/karate-summary.html
```
