# Karate AI & Automation Starter - Portfolio Module 🥋

Módulo principal de automação de testes com **Karate Framework (1.4.1)**, **Maven** e **JUnit 5** para UI e API, incluindo suíte completa para a [Loja de Testes pública](https://portfolio-omega-six-18.vercel.app/automation) e testes replicados de Wallet e Login.

## Requisitos

- **Java JDK 11 ou superior** (homologado com Java 17 e 21 LTS)
- **Apache Maven 3.9 ou superior**
- **Google Chrome** (para os testes de interface gráfica com Karate Driver)

## O que o projeto demonstra

- Automação de testes Karate de UI e API com sintaxe nativa BDD/Gherkin.
- Suíte completa de testes de contrato, integridade de cabeçalhos HTTP, autenticação e regras de negócio para a [Loja de Testes](https://portfolio-omega-six-18.vercel.app/automation).
- Testes E2E de uma aplicação local reproduzível (**Wallet API** e **Login UI**).
- Suporte a eventos reais de teclado (`Key.TAB`, `Key.ENTER`) e manipulação de elementos via Chrome DevTools Protocol (CDP).
- Relatórios nativos ricos em HTML interativo com métricas de tempo, requisições, payloads e status de cada passo.

## Estrutura

```text
karate-automation-portfolio/
├── pom.xml                                  # Dependências do Karate 1.4.1 e Surefire
├── README.md                                # Documentação técnica do módulo
└── src/test/java/
    ├── karate-config.js                     # Configurações globais de ambiente e timeouts
    └── automation/
        ├── TestRunner.java                  # JUnit 5 Runner modular
        ├── loja_testes.feature              # Suíte completa da Loja de Testes pública
        ├── autenticacao_ui.feature          # Automação de interface no Chrome (Login & Teclado)
        ├── catalogo_carrinho_ui.feature     # Automação de interface no Chrome (Catálogo & Carrinho)
        ├── demo_wallet_api.feature          # Teste replicado da Wallet API local
        ├── demo_login_api.feature           # Teste replicado de Login API local
        └── demo_login_ui.feature            # Teste replicado de Login UI local
```

## Como Executar

### Executar a suíte completa da Loja de Testes pública:

```bash
mvn test -Dtest=TestRunner#testLojaSuite
```

### Executar somente testes de API:

```bash
mvn test "-Dkarate.options=--tags ~@ui"
```

### Executar somente testes de interface gráfica no Google Chrome:

```bash
mvn test "-Dkarate.options=--tags @ui"
```

### Executar os testes replicados da Demo local:

```bash
mvn test -Dtest=TestRunner#testDemoSuite
```

## Relatórios de Execução

Após a execução, visualize o relatório gerado pelo Karate:

```powershell
start target/karate-reports/karate-summary.html
```

O Karate Framework gera relatórios completos em formato HTML contendo o sumário executivo, status de cada feature e cenário, tempos de resposta e rastreamento detalhado de requisições e passos de UI:

![Karate Summary Report](docs/assets/karate-summary.png)

