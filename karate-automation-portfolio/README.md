<p align="center">
  <img src="https://raw.githubusercontent.com/karatelabs/karate/develop/assets/karate-logo.svg" width="120" alt="Karate Logo" />
</p>

<h1 align="center">Karate Automation Portfolio 🥋</h1>

<p align="center">
  <b>Módulo de Automação Exclusivo de APIs REST com Karate Framework 1.4.1 e JUnit 5</b>
</p>

<p align="center">
  <a href="https://portfolio-omega-six-18.vercel.app/api-docs"><img src="https://img.shields.io/badge/Swagger-OpenAPI%203.0.3-85EA2D?style=for-the-badge&logo=swagger&logoColor=black" alt="Swagger Docs"></a>
  <a href="https://portfolio-omega-six-18.vercel.app/api/health"><img src="https://img.shields.io/badge/API-Health%20UP-success?style=for-the-badge&logo=statuspage&logoColor=white" alt="API Health"></a>
  <a href="https://github.com/karatelabs/karate"><img src="https://img.shields.io/badge/Karate-1.4.1-FF5A00?style=for-the-badge&logo=cucumber&logoColor=white" alt="Karate Version"></a>
  <a href="https://adoptium.net/"><img src="https://img.shields.io/badge/Java-11%20%7C%2017%20%7C%2021%20LTS-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white" alt="Java LTS"></a>
  <a href="https://junit.org/junit5/"><img src="https://img.shields.io/badge/Runner-JUnit%205-25A162?style=for-the-badge&logo=junit5&logoColor=white" alt="JUnit 5"></a>
</p>

---

## 📑 Visão Geral

Este módulo Maven contém todas as especificações em BDD/Gherkin executadas pelo **Karate Framework (1.4.1)** e orquestradas pelo **JUnit 5 Platform**.

O projeto é **exclusivamente focado na validação de backend e APIs REST**, cobrindo 100% dos contratos, parâmetros e regras de negócio da documentação oficial [Swagger OpenAPI (/api-docs)](https://portfolio-omega-six-18.vercel.app/api-docs).

---

## 📊 Cobertura da API REST (Swagger / OpenAPI)

| Módulo / Domínio | Verbo | Rota HTTP | Arquivo Feature | Cenários | Status |
| :--- | :---: | :--- | :--- | :---: | :---: |
| **Monitoramento** | `GET`, `POST` | `/api/health` | [`api_health.feature`](src/test/java/automation/api_health.feature) | **2** | 🟢 100% |
| **Autenticação & Usuários** | `POST`, `GET`, `PUT`, `PATCH` | `/api/auth/login`, `/verify`, `/register`, `/logout`<br>`/api/users/me`, `/password`, `/api/users` | [`api_auth_usuarios.feature`](src/test/java/automation/api_auth_usuarios.feature) | **16** | 🟢 100% |
| **Catálogo de Produtos** | `GET`, `POST`, `DELETE` | `/api/products`, `/categories`, `/search`, `/{id}` | [`api_produtos.feature`](src/test/java/automation/api_produtos.feature) | **11** | 🟢 100% |
| **Carrinho de Compras** | `GET`, `POST`, `PUT`, `DELETE` | `/api/cart`, `/api/cart/{id}` | [`api_carrinho.feature`](src/test/java/automation/api_carrinho.feature) | **8** | 🟢 100% |
| **Cupons e Frete** | `POST` | `/api/coupons/validate`<br>`/api/shipping/calculate` | [`api_cupons_frete.feature`](src/test/java/automation/api_cupons_frete.feature) | **10** | 🟢 100% |
| **Pedidos (Checkout)** | `GET`, `POST`, `PATCH`, `DELETE` | `/api/orders`, `/api/orders/{id}`<br>`/api/orders/{id}/status` | [`api_pedidos_checkout.feature`](src/test/java/automation/api_pedidos_checkout.feature) | **8** | 🟢 100% |

> **Total do Módulo de Backend:** **6 Features / 55 Cenários Automatizados** (100% aprovados e 0 falhas).

---

## 📁 Estrutura de Diretórios

```text
karate-automation-portfolio/
├── pom.xml                                  # Dependências do Karate 1.4.1 e Surefire Plugin
├── docs/
│   └── assets/
│       └── karate-summary.png               # Evidência oficial de execução
└── src/test/java/
    ├── karate-config.js                     # Configuração global de ambiente e timeouts
    └── automation/
        ├── TestRunner.java                  # Runner JUnit 5 com anotações @Karate.Test
        ├── api_health.feature               # Health Check e monitoramento da API
        ├── api_auth_usuarios.feature        # Autenticação JWT, Registro, Senha e Perfil
        ├── api_produtos.feature             # Catálogo, Categorias e Busca Textual
        ├── api_carrinho.feature             # Adição, Edição e Limpeza de Carrinho
        ├── api_cupons_frete.feature         # Validação de Cupons e Cálculo de Frete
        └── api_pedidos_checkout.feature     # Ciclo de Vida de Pedidos e Checkout
```

---

## 🚀 Como Executar

### Executar a suíte completa de APIs do Swagger (55 cenários):

```bash
mvn test -Dtest=TestRunner#testAllApis
```

### Executar módulos de API individualmente:

```bash
# Monitoramento e Health Check (/api/health)
mvn test -Dtest=TestRunner#testHealthApi

# Autenticação, JWT e Usuários
mvn test -Dtest=TestRunner#testAuthUsuariosApi

# Catálogo, Categorias e Busca de Produtos
mvn test -Dtest=TestRunner#testProdutosApi

# Carrinho de Compras
mvn test -Dtest=TestRunner#testCarrinhoApi

# Cupons Promocionais e Frete
mvn test -Dtest=TestRunner#testCuponsFreteApi

# Pedidos e Checkout
mvn test -Dtest=TestRunner#testPedidosCheckoutApi
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
- 🌐 [Portfolio](https://portfolio-omega-six-18.vercel.app/) • 📖 [Swagger Docs](https://portfolio-omega-six-18.vercel.app/api-docs) • 🐙 [GitHub](https://github.com/GalileoGuilherme) • 💼 [LinkedIn](https://linkedin.com/in/galileosilva)
