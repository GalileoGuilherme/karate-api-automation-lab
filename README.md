# Karate AI & Automation Starter 🥋

Projeto de automação de testes de alta performance com **Karate Framework (1.4.1)**, **Maven** e **JUnit 5** focado na validação completa dos contratos, regras de negócio e cenários da API REST documentada no [Swagger OpenAPI (/api-docs)](https://portfolio-omega-six-18.vercel.app/api-docs) e dos fluxos da aplicação pública [Automação QA](https://portfolio-omega-six-18.vercel.app/automation).

## Requisitos

- **Java JDK 11 ou superior** (homologado inclusive com Java 17 e 21 LTS)
- **Apache Maven 3.9 ou superior**
- **Node.js 18 ou superior** (para execução de scripts e da demo local)
- **Google Chrome** (para os testes de interface gráfica com Karate Driver)

## O que o projeto demonstra

- **Cobertura completa de API REST**: 43 cenários automatizados cobrindo 100% dos endpoints especificados no [Swagger /api-docs](https://portfolio-omega-six-18.vercel.app/api-docs).
- **Validação de Contratos e Schemas JSON**: Verificação estrita de payloads, tipos de dados (`#string`, `#number`, `#regex`), códigos HTTP de sucesso (`200`, `201`) e tratamento de erros (`400`, `401`, `404`, `405`).
- **Automação E2E e UI com Karate Driver**: Navegação no Google Chrome, validação visual, preenchimento de formulários e interação por teclado (`Key.TAB`, `Key.ENTER`) via Chrome DevTools Protocol (CDP).
- **Testes de Integração e Negócio**: Gestão de ciclo de vida completo de compras (Login ➔ Catálogo ➔ Carrinho ➔ Cupom de Desconto ➔ Cálculo de Frete ➔ Criação de Pedido).
- **Relatórios Interativos HTML**: Geração automática de métricas executivas de execução, tempos de resposta e rastreamento completo de tráfego HTTP.

## Cobertura da API REST (Swagger / OpenAPI)

Os testes foram organizados de acordo com as tags e módulos da documentação oficial disponível em [https://portfolio-omega-six-18.vercel.app/api-docs](https://portfolio-omega-six-18.vercel.app/api-docs):

| Módulo / Tag | Endpoints Cobertos | Arquivo Feature | Cenários |
| --- | --- | --- | :---: |
| **Monitoramento** | `GET /api/health` | `api_health.feature` | 2 |
| **Autenticação & Usuários** | `POST /api/auth/login`<br>`POST /api/auth/register`<br>`POST /api/auth/logout`<br>`GET/PUT /api/users/me` | `api_auth_usuarios.feature` | 9 |
| **Catálogo de Produtos** | `GET /api/products`<br>`GET /api/products?category=`<br>`GET /api/products/search?q=`<br>`GET/DELETE /api/products/{id}`<br>`POST /api/products` | `api_produtos.feature` | 9 |
| **Carrinho de Compras** | `GET /api/cart`<br>`POST /api/cart`<br>`PUT/DELETE /api/cart/{id}`<br>`DELETE /api/cart` | `api_carrinho.feature` | 8 |
| **Cupons e Frete** | `POST /api/coupons/validate`<br>`POST /api/shipping/calculate` | `api_cupons_frete.feature` | 10 |
| **Pedidos (Checkout)** | `GET /api/orders`<br>`GET /api/orders/{id}`<br>`POST /api/orders` | `api_pedidos_checkout.feature` | 5 |

## Estrutura do Projeto

```text
karate-api-automation-lab/
├── demo/                                    # Aplicação local reproduzível (Node.js)
│   ├── index.html                           # Interface visual da demo (login & dashboard)
│   └── server.mjs                           # Servidor HTTP com endpoints de Wallet e Login
├── docs/
│   └── assets/
│       └── karate-summary.png               # Evidência oficial do relatório Karate
├── karate-automation-portfolio/             # Módulo Maven / Karate JUnit 5
│   ├── pom.xml                              # Dependências do Karate 1.4.1 e Surefire
│   └── src/test/java/
│       ├── karate-config.js                 # Configurações globais, endpoints e timeouts
│       └── automation/
│           ├── TestRunner.java              # JUnit 5 Runner modular
│           ├── api_health.feature           # Monitoramento e Health Check
│           ├── api_auth_usuarios.feature    # Autenticação, Cadastro e Perfil
│           ├── api_produtos.feature         # Catálogo, Busca e Gestão de Produtos
│           ├── api_carrinho.feature         # Gestão Completa do Carrinho
│           ├── api_cupons_frete.feature     # Validação de Cupons e Cálculo de Frete
│           ├── api_pedidos_checkout.feature # Finalização de Compras e Pedidos
│           ├── loja_testes.feature          # Suíte combinada da Loja pública
│           ├── autenticacao_ui.feature      # Automação de interface no Chrome (Login)
│           ├── catalogo_carrinho_ui.feature # Automação de interface no Chrome (Catálogo)
│           ├── demo_wallet_api.feature      # Teste replicado da Wallet API local
│           ├── demo_login_api.feature       # Teste replicado de Login API local
│           └── demo_login_ui.feature        # Teste replicado de Login UI local
├── package.json                             # Scripts NPM integrados
├── pom.xml                                  # Maven Aggregator raiz
└── README.md                                # Documentação técnica
```

## Instalação

Compile o projeto e baixe as dependências do Maven:

```bash
mvn clean compile
```

## Como Executar

### 1. Executar a Suíte Completa de APIs (Swagger /api-docs)

Para rodar todos os 43 cenários de API:

```bash
npm test
# ou via Maven:
mvn test -Dtest=TestRunner#testAllApis
```

### 2. Executar Testes por Módulo da API

Você pode executar cada domínio isoladamente:

```bash
# Monitoramento e Health Check
npm run test:health
mvn test -Dtest=TestRunner#testHealthApi

# Autenticação e Usuários
npm run test:auth
mvn test -Dtest=TestRunner#testAuthUsuariosApi

# Catálogo e Produtos
npm run test:products
mvn test -Dtest=TestRunner#testProdutosApi

# Carrinho de Compras
npm run test:cart
mvn test -Dtest=TestRunner#testCarrinhoApi

# Cupons e Cálculo de Frete
npm run test:coupons
mvn test -Dtest=TestRunner#testCuponsFreteApi

# Pedidos e Checkout
npm run test:orders
mvn test -Dtest=TestRunner#testPedidosCheckoutApi
```

### 3. Executar Testes de Interface Gráfica (UI no Google Chrome)

Para disparar os testes de interface gráfica via Karate Driver:

```bash
npm run test:ui
# ou via Maven:
mvn test -Dtest=TestRunner#testUiSuite
```

### 4. Executar a Demo Local (Wallet API + Login)

Inicie o servidor local em um terminal:

```bash
npm run demo
```

Em outro terminal, execute os testes da demo:

```bash
npm run test:demo
# ou via Maven:
mvn test -Dtest=TestRunner#testDemoSuite
```

## Scripts Disponíveis

| Comando | Descrição |
| --- | --- |
| `npm test` | Executa a suíte completa de APIs do Swagger (43 cenários) |
| `npm run test:apis` | Alias para execução de todas as APIs |
| `npm run test:health` | Executa os testes de Health Check (`GET /api/health`) |
| `npm run test:auth` | Executa os testes de Login, Registro, Logout e Perfil |
| `npm run test:products` | Executa os testes de Catálogo, Busca e Produtos |
| `npm run test:cart` | Executa os testes de Carrinho de Compras |
| `npm run test:coupons` | Executa os testes de Validação de Cupons e Frete |
| `npm run test:orders` | Executa os testes de Criação e Consulta de Pedidos |
| `npm run test:ui` | Executa os testes visuais de interface no Google Chrome |
| `npm run test:loja` | Executa a suíte E2E da Loja pública |
| `npm run test:demo` | Executa os testes da aplicação demo local |
| `npm run test:all` | Executa todas as features do projeto |
| `npm run demo` | Inicia o servidor Node.js local em `http://localhost:3000` |
| `npm run report` | Abre o relatório interativo HTML gerado no navegador padrão |

## Relatórios de Execução

Após a execução, visualize o relatório gerado pelo Karate:

```powershell
start karate-automation-portfolio/target/karate-reports/karate-summary.html
```

O Karate Framework gera relatórios completos em formato HTML contendo o sumário executivo, status de cada feature e cenário, tempos de resposta e rastreamento detalhado de requisições e passos de UI:

![Karate Summary Report](docs/assets/karate-summary.png)
