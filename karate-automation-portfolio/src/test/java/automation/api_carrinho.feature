@api @carrinho
Feature: Gestão do Carrinho de Compras (Swagger /api-docs)

  Como um Usuário do E-Commerce
  Quero adicionar produtos ao carrinho, alterar quantidades, remover itens e limpar o carrinho
  Para validar os contratos e cálculos de valores do carrinho de compras

  Background:
    * url baseUrl

  Scenario: Consulta do carrinho de compras atual
    Given path '/api/cart'
    When method get
    Then status 200
    And match response.success == true
    And match response.items == '#[]'
    And match response.total == '#number'
    And match response.count == '#number'

  Scenario: Adição de produto ao carrinho de compras (HTTP 201)
    Given path '/api/cart'
    And request { "productId": "garrafa-termica", "quantity": 1 }
    When method post
    Then status 201
    And match response.success == true
    And match response.message contains 'adicionado ao carrinho'
    And assert response.total > 0

  Scenario: Adição com incremento de quantidade do mesmo produto
    Given path '/api/cart'
    And request { "productId": "garrafa-termica", "quantity": 2 }
    When method post
    Then status 201
    And match response.success == true

  Scenario: Falha ao adicionar produto inexistente no catálogo (HTTP 404)
    Given path '/api/cart'
    And request { "productId": "produto-inexistente-xyz", "quantity": 1 }
    When method post
    Then status 404
    And match response.success == false
    And match response.error contains 'não encontrado no catálogo'

  Scenario: Falha ao adicionar item sem o campo obrigatório productId (HTTP 400)
    Given path '/api/cart'
    And request { "quantity": 2 }
    When method post
    Then status 400
    And match response.success == false
    And match response.error contains 'productId'

  Scenario: Atualização da quantidade de um item no carrinho (HTTP 200)
    # Garante que o item fone-bluetooth está presente
    Given path '/api/cart'
    And request { "productId": "fone-bluetooth", "quantity": 1 }
    When method post
    Then status 201

    # Atualiza a quantidade para 3
    Given path '/api/cart/fone-bluetooth'
    And request { "quantity": 3 }
    When method put
    Then status 200
    And match response.success == true
    And match response.item.quantity == 3
    And match response.item.subtotal == 599.70

  Scenario: Remoção de item específico do carrinho (DELETE /api/cart/{id})
    Given path '/api/cart/fone-bluetooth'
    When method delete
    Then status 200
    And match response.success == true
    And match response.message contains 'removido do carrinho'

  Scenario: Limpeza completa do carrinho de compras (DELETE /api/cart)
    Given path '/api/cart'
    When method delete
    Then status 200
    And match response.success == true
    And match response.message contains 'limpo com sucesso'
    And match response.items == []
    And match response.total == 0
    And match response.count == 0
