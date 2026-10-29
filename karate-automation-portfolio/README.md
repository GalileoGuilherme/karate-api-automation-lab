# Karate Automation Suite - Portfolio & Swagger APIs

Módulo de testes automatizados com **Karate Framework (1.4.1)** e **JUnit 5**, cobrindo 100% dos endpoints REST especificados no [Swagger OpenAPI (/api-docs)](https://portfolio-omega-six-18.vercel.app/api-docs) e a aplicação pública [Automação QA](https://portfolio-omega-six-18.vercel.app/automation).

## Funcionalidades e Escopo de Testes

- **43 Cenários de API REST**: Validações de contrato, esquemas JSON, códigos de status e regras de negócio.
- **Suíte E2E de Interface (UI)**: Testes automatizados no Google Chrome via Karate Driver com CDP.
- **Estrutura BDD/Gherkin**: Especificações legíveis e reutilizáveis em arquivos `.feature`.
- **Relatório Oficial do Karate**: Métricas visuais e logs completos de requisições e respostas HTTP em formato HTML.

## Cobertura da API REST (Swagger / OpenAPI)

| Módulo | Endpoints | Feature | Cenários |
| --- | --- | --- | :---: |
| **Monitoramento** | `GET /api/health` | `api_health.feature` | 2 |
| **Autenticação & Usuários** | `POST /api/auth/login`, `POST /api/auth/register`, `POST /api/auth/logout`, `GET/PUT /api/users/me` | `api_auth_usuarios.feature` | 9 |
| **Catálogo de Produtos** | `GET /api/products`, `GET /api/products/search`, `GET/DELETE /api/products/{id}`, `POST /api/products` | `api_produtos.feature` | 9 |
| **Carrinho de Compras** | `GET/POST/DELETE /api/cart`, `PUT/DELETE /api/cart/{id}` | `api_carrinho.feature` | 8 |
| **Cupons e Frete** | `POST /api/coupons/validate`, `POST /api/shipping/calculate` | `api_cupons_frete.feature` | 10 |
| **Pedidos (Checkout)** | `GET /api/orders`, `GET /api/orders/{id}`, `POST /api/orders` | `api_pedidos_checkout.feature` | 5 |

## Estrutura do Módulo

```text
src/test/java/
├── karate-config.js                 # Configuração global de ambiente e timeouts
└── automation/
    ├── TestRunner.java              # Runner JUnit 5 com métodos modulares
    ├── api_health.feature           # Monitoramento da API (/api/health)
    ├── api_auth_usuarios.feature    # Login, Cadastro, Logout e Perfil
    ├── api_produtos.feature         # Catálogo, Busca e Gestão de Produtos
    ├── api_carrinho.feature         # Gestão Completa do Carrinho
    ├── api_cupons_frete.feature     # Validação de Cupons e Cálculo de Frete
    ├── api_pedidos_checkout.feature # Finalização de Compras e Pedidos
    ├── loja_testes.feature          # Suíte combinada da Loja pública
    ├── autenticacao_ui.feature      # Automação de interface no Chrome (Login)
    ├── catalogo_carrinho_ui.feature # Automação de interface no Chrome (Catálogo)
    ├── demo_wallet_api.feature      # Teste replicado da Wallet API local
    ├── demo_login_api.feature       # Teste replicado de Login API local
    └── demo_login_ui.feature        # Teste replicado de Login UI local
```

## Como Executar

### Executar a suíte completa de APIs do Swagger (43 cenários):

```bash
mvn test -Dtest=TestRunner#testAllApis
```

### Executar módulos individuais de API:

```bash
mvn test -Dtest=TestRunner#testHealthApi
mvn test -Dtest=TestRunner#testAuthUsuariosApi
mvn test -Dtest=TestRunner#testProdutosApi
mvn test -Dtest=TestRunner#testCarrinhoApi
mvn test -Dtest=TestRunner#testCuponsFreteApi
mvn test -Dtest=TestRunner#testPedidosCheckoutApi
```

### Executar testes de interface gráfica no Google Chrome:

```bash
mvn test -Dtest=TestRunner#testUiSuite
```

### Executar testes da Demo local:

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
