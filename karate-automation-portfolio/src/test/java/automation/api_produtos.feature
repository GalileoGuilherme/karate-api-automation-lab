@api @produtos
Feature: Catálogo de Produtos e Busca Textual (Swagger /api-docs)

  Como um Usuário ou Sistema de E-Commerce
  Quero consultar produtos, listar categorias, aplicar filtros, pesquisar por texto e gerenciar o catálogo
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

  Scenario: Listagem de todas as categorias distintas do catálogo (GET /api/products/categories)
    Given path '/api/products/categories'
    When method get
    Then status 200
    And match response.success == true
    And assert response.total >= 1
    And match response.categories == '#[]'
    And match response.categories contains 'Eletrônicos'

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

  Scenario: Criação e posterior exclusão de produto de teste (POST e DELETE /api/products/{id})
    # 1. Cria o produto
    * def uniqueProdId = 'prod-qa-' + java.lang.System.currentTimeMillis()
    Given path '/api/products'
    And request
      """
      {
        "id": "#(uniqueProdId)",
        "name": "Teclado Ergonômico Split",
        "price": 389.90,
        "category": "Eletrônicos",
        "description": "Teclado mecânico split para desenvolvedores.",
        "stock": 15
      }
      """
    When method post
    Then status 201
    And match response.success == true
    And match response.product.id == uniqueProdId

    # 2. Exclui o produto criado
    Given path '/api/products/' + uniqueProdId
    When method delete
    Then status 200
    And match response.success == true
    And match response.message contains 'excluído com sucesso'

  Scenario: Rejeição de exclusão de produto inexistente (HTTP 404)
    Given path '/api/products/id-produto-inexistente-para-exclusao'
    When method delete
    Then status 404
    And match response.success == false
    And match response.error contains 'não encontrado para exclusão'

  Scenario: Falha na criação de produto sem campos obrigatórios (HTTP 400)
    Given path '/api/products'
    And request { "description": "Sem nome e sem preço" }
    When method post
    Then status 400
    And match response.success == false
    And match response.error contains 'name e price'
