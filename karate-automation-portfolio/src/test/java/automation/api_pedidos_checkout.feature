@api @pedidos @checkout
Feature: Gestão de Pedidos e Finalização de Compra (Swagger /api-docs)

  Como um Usuário do E-Commerce
  Quero consultar histórico de pedidos, buscar por identificador e finalizar compras com cálculo de total
  Para validar os contratos e regras de fechamento de pedido da API de Checkout

  Background:
    * url baseUrl

  Scenario: Listagem do histórico de pedidos realizados
    Given path '/api/orders'
    When method get
    Then status 200
    And match response.success == true
    And assert response.total >= 0
    And match response.orders == '#[]'

  Scenario: Consulta de detalhes de pedido existente por ID (ORD-948210)
    Given path '/api/orders/ORD-948210'
    When method get
    Then status 200
    And match response.success == true
    And match response.order.id == 'ORD-948210'
    And match response.order.status == 'CONFIRMED'
    And match response.order.customerEmail == 'qa@exemplo.com'
    And match response.order.total == 199.9

  Scenario: Consulta de pedido com identificador inexistente (HTTP 404)
    Given path '/api/orders/ORD-INEXISTENTE-000'
    When method get
    Then status 404
    And match response.success == false
    And match response.error contains 'não encontrado'

  Scenario: Finalização de compra / Criação de novo pedido com sucesso (HTTP 201)
    Given path '/api/orders'
    And request
      """
      {
        "items": [
          {
            "id": "fone-bluetooth",
            "name": "Fone Bluetooth",
            "price": 199.9,
            "quantity": 1
          }
        ],
        "shippingMethod": "Expressa — Sedex",
        "shippingPrice": 15.0,
        "discount": 19.99,
        "customerName": "Galileo Guilherme (QA Master)",
        "customerEmail": "qa@exemplo.com",
        "address": "Rua das Automações, 500 - Recife, PE"
      }
      """
    When method post
    Then status 201
    And match response.success == true
    And match response.message contains 'Pedido realizado com sucesso'
    And match response.order.id == '#regex ^ORD-\\d+'
    And match response.order.status == 'CONFIRMED'
    And match response.order.customerEmail == 'qa@exemplo.com'
    And match response.order.shippingPrice == 15.0
    And match response.order.discount == 19.99
    And match response.order.total == 194.91
    And match response.order.createdAt == '#string'

  Scenario: Bloqueio de finalização de pedido sem itens / carrinho vazio (HTTP 400)
    # Garante que o carrinho está vazio
    Given path '/api/cart'
    When method delete
    Then status 200

    # Tenta enviar pedido sem itens
    Given path '/api/orders'
    And request { "items": [], "address": "Rua Vazia, 000" }
    When method post
    Then status 400
    And match response.success == false
    And match response.error contains 'Adicione ao menos um produto'
