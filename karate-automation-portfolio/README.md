<p align="center">
  <img src="https://raw.githubusercontent.com/karatelabs/karate/develop/assets/karate-logo.svg" width="120" alt="Karate Logo" />
</p>

<h1 align="center">Karate Automation Portfolio 🥋</h1>

<p align="center">
  <b>Módulo de Automação de Testes de APIs REST (Swagger OpenAPI) e Interface com Karate JUnit 5</b>
</p>

<p align="center">
  <a href="https://portfolio-omega-six-18.vercel.app/api-docs"><img src="https://img.shields.io/badge/Swagger-OpenAPI%203.0.3-85EA2D?style=for-the-badge&logo=swagger&logoColor=black" alt="Swagger Docs"></a>
  <a href="https://portfolio-omega-six-18.vercel.app/automation"><img src="https://img.shields.io/badge/Web%20App-QA%20Lab-007ACC?style=for-the-badge&logo=googlechrome&logoColor=white" alt="Live App"></a>
  <a href="https://github.com/karatelabs/karate"><img src="https://img.shields.io/badge/Karate-1.4.1-FF5A00?style=for-the-badge&logo=cucumber&logoColor=white" alt="Karate Version"></a>
  <a href="https://adoptium.net/"><img src="https://img.shields.io/badge/Java-11%20%7C%2017%20%7C%2021%20LTS-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white" alt="Java LTS"></a>
  <a href="https://junit.org/junit5/"><img src="https://img.shields.io/badge/Runner-JUnit%205-25A162?style=for-the-badge&logo=junit5&logoColor=white" alt="JUnit 5"></a>
</p>

---

## 📑 Visão Geral

Este módulo Maven contém todas as especificações em BDD/Gherkin executadas pelo **Karate Framework (1.4.1)** e orquestradas pelo **JUnit 5 Platform**.

Ele implementa cobertura integral de testes de contrato e integração para as APIs REST documentadas no [Swagger OpenAPI (/api-docs)](https://portfolio-omega-six-18.vercel.app/api-docs) e automação de interface no navegador Google Chrome via **Karate Driver**.

---

## 📊 Cobertura da API REST (Swagger / OpenAPI)

| Módulo / Domínio | Método | Rota HTTP | Arquivo Feature | Cenários | Status |
| :--- | :---: | :--- | :--- | :---: | :---: |
| **Monitoramento** | `GET` | `/api/health` | [`api_health.feature`](src/test/java/automation/api_health.feature) | **2** | 🟢 100% |
| **Autenticação** | `POST` | `/api/auth/login` | [`api_auth_usuarios.feature`](src/test/java/automation/api_auth_usuarios.feature) | **4** | 🟢 100% |
| **Cadastro** | `POST` | `/api/auth/register` | [`api_auth_usuarios.feature`](src/test/java/automation/api_auth_usuarios.feature) | **2** | 🟢 100% |
| **Sessão** | `POST` | `/api/auth/logout` | [`api_auth_usuarios.feature`](src/test/java/automation/api_auth_usuarios.feature) | **1** | 🟢 100% |
| **Perfil** | `GET`, `PUT` | `/api/users/me` | [`api_auth_usuarios.feature`](src/test/java/automation/api_auth_usuarios.feature) | **2** | 🟢 100% |
| **Catálogo** | `GET`, `POST` | `/api/products` | [`api_produtos.feature`](src/test/java/automation/api_produtos.feature) | **4** | 🟢 100% |
| **Busca Textual** | `GET` | `/api/products/search` | [`api_produtos.feature`](src/test/java/automation/api_produtos.feature) | **2** | 🟢 100% |
| **Gestão Produto** | `GET`, `DELETE` | `/api/products/{id}` | [`api_produtos.feature`](src/test/java/automation/api_produtos.feature) | **3** | 🟢 100% |
| **Carrinho Geral** | `GET`, `POST`, `DELETE`| `/api/cart` | [`api_carrinho.feature`](src/test/java/automation/api_carrinho.feature) | **6** | 🟢 100% |
| **Item Carrinho** | `PUT`, `DELETE` | `/api/cart/{id}` | [`api_carrinho.feature`](src/test/java/automation/api_carrinho.feature) | **2** | 🟢 100% |
| **Cupons** | `POST` | `/api/coupons/validate` | [`api_cupons_frete.feature`](src/test/java/automation/api_cupons_frete.feature) | **6** | 🟢 100% |
| **Frete CEP** | `POST` | `/api/shipping/calculate` | [`api_cupons_frete.feature`](src/test/java/automation/api_cupons_frete.feature) | **4** | 🟢 100% |
| **Pedidos** | `GET`, `POST` | `/api/orders` | [`api_pedidos_checkout.feature`](src/test/java/automation/api_pedidos_checkout.feature) | **3** | 🟢 100% |
| **Consulta Pedido**| `GET` | `/api/orders/{id}` | [`api_pedidos_checkout.feature`](src/test/java/automation/api_pedidos_checkout.feature) | **2** | 🟢 100% |

> **Total de Cenários de API do Swagger:** **43 cenários** com 100% de sucesso.

---

## 📁 Estrutura de Diretórios

```text
karate-automation-portfolio/
├── pom.xml                                  # Configurações do Maven, Karate 1.4.1 e Surefire
├── docs/
│   └── assets/
│       └── karate-summary.png               # Evidência oficial de execução
└── src/test/java/
    ├── karate-config.js                     # Configuração global de ambiente e timeouts
    └── automation/
        ├── TestRunner.java                  # JUnit 5 Runner modular
        ├── api_health.feature               # Health Check e monitoramento da API
        ├── api_auth_usuarios.feature        # Autenticação JWT, Registro e Perfil
        ├── api_produtos.feature             # Catálogo, Filtros e Busca Textual
        ├── api_carrinho.feature             # Adição, Edição e Limpeza de Carrinho
        ├── api_cupons_frete.feature         # Validação de Cupons e Cálculo de Frete
        ├── api_pedidos_checkout.feature     # Criação de Pedidos e Checkout
        ├── loja_testes.feature              # Suíte combinada da Loja pública
        ├── autenticacao_ui.feature          # Automação de tela no Chrome (Login)
        ├── catalogo_carrinho_ui.feature     # Automação de tela no Chrome (Catálogo)
        ├── demo_wallet_api.feature          # Teste de API da demo local
        ├── demo_login_api.feature           # Teste de login API da demo local
        └── demo_login_ui.feature            # Teste visual da demo local
```

---

## 🚀 Como Executar

### Executar a suíte completa de APIs do Swagger (43 cenários):

```bash
mvn test -Dtest=TestRunner#testAllApis
```

### Executar módulos de API individualmente:

```bash
# Monitoramento e Health Check
mvn test -Dtest=TestRunner#testHealthApi

# Autenticação e Usuários
mvn test -Dtest=TestRunner#testAuthUsuariosApi

# Catálogo e Produtos
mvn test -Dtest=TestRunner#testProdutosApi

# Carrinho de Compras
mvn test -Dtest=TestRunner#testCarrinhoApi

# Cupons e Frete
mvn test -Dtest=TestRunner#testCuponsFreteApi

# Pedidos e Checkout
mvn test -Dtest=TestRunner#testPedidosCheckoutApi
```

### Executar testes de interface gráfica no Google Chrome:

```bash
mvn test -Dtest=TestRunner#testUiSuite
```

### Executar a suíte da demo local:

```bash
mvn test -Dtest=TestRunner#testDemoSuite
```

---

## 📈 Relatórios de Execução

Após a execução, abra o relatório HTML interativo:

```powershell
start target/karate-reports/karate-summary.html
```

<p align="center">
  <img src="docs/assets/karate-summary.png" width="900" alt="Karate Summary Execution Report" />
</p>

---

## 👤 Autor

**Galileo Guilherme**  
*QA Automation Specialist / Software Test Engineer*  
- 🌐 [Portfolio](https://portfolio-omega-six-18.vercel.app/) • 🐙 [GitHub](https://github.com/GalileoGuilherme) • 💼 [LinkedIn](https://linkedin.com/in/galileosilva)
