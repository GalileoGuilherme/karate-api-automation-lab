@api @produtos
Feature: Catálogo de Produtos e Busca Textual (Swagger /api-docs)

  Como um Usuário ou Sistema de E-Commerce
  Quero consultar produtos, aplicar filtros, pesquisar por texto e gerenciar o catálogo
  Para validar os contratos e comportamentos dos endpoints de produtos

  Background:
    * url baseUrl

  Scenario: Listagem completa do catálogo de produtos
    Given path '/api/products'
    When method get
    Then status 200
    And match response.success == true
    And match response.total == '#number'
    And match response.products == '#[]'
    And match response.products[0].id == '#string'
    And match response.products[0].name == '#string'
    And match response.products[0].price == '#number'
    And match response.products[0].category == '#string'
    And match response.products[0].stock == '#number'

  Scenario: Filtragem de produtos por categoria (Eletrônicos)
    Given path '/api/products'
    And param category = 'Eletrônicos'
    When method get
    Then status 200
    And match response.success == true
    And match each response.products contains { category: 'Eletrônicos' }

  Scenario: Filtragem de produtos por categoria (Casa)
    Given path '/api/products'
    And param category = 'Casa'
    When method get
    Then status 200
    And match response.success == true
    And match each response.products contains { category: 'Casa' }

  Scenario: Busca textual de produtos com resultados (Fone)
    Given path '/api/products/search'
    And param q = 'Fone'
    When method get
    Then status 200
    And match response.success == true
    And match response.query == 'fone'
    And assert response.total >= 1
    And match response.products[0].name contains 'Fone'

  Scenario: Busca textual sem resultados (termo inexistente)
    Given path '/api/products/search'
    And param q = 'termo-que-nao-existe-no-catalogo-xyz'
    When method get
    Then status 200
    And match response.success == true
    And match response.total == 0
    And match response.products == []

  Scenario: Consulta de detalhes de produto por ID existente (fone-bluetooth)
    Given path '/api/products/fone-bluetooth'
    When method get
    Then status 200
    And match response.success == true
    And match response.product.id == 'fone-bluetooth'
    And match response.product.name == 'Fone Bluetooth'
    And match response.product.price == 199.9

  Scenario: Consulta de produto por ID inexistente (HTTP 404)
    Given path '/api/products/id-produto-fantasma-999'
    When method get
    Then status 404
    And match response.success == false
    And match response.error contains 'não encontrado'

  Scenario: Criação de novo produto no catálogo (HTTP 201)
    Given path '/api/products'
    And request
      """
      {
        "name": "Mouse Ergonômico Vertical",
        "price": 149.90,
        "category": "Eletrônicos",
        "description": "Mouse ergonômico para prevenção de LER.",
        "stock": 18
      }
      """
    When method post
    Then status 201
    And match response.success == true
    And match response.message contains 'criado com sucesso'
    And match response.product.name == 'Mouse Ergonômico Vertical'
    And match response.product.price == 149.90
    And match response.product.id == '#string'

  Scenario: Falha na criação de produto sem campos obrigatórios (HTTP 400)
    Given path '/api/products'
    And request { "description": "Sem nome e sem preço" }
    When method post
    Then status 400
    And match response.success == false
    And match response.error contains 'name e price'
