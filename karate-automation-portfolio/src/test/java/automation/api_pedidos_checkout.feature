@api @pedidos @checkout
Feature: Gestão de Pedidos e Finalização de Compra (Swagger /api-docs)

  Como um Usuário do E-Commerce
  Quero consultar histórico de pedidos, buscar por identificador, finalizar compras, atualizar status e cancelar pedidos
  Para validar os contratos e regras de fechamento e ciclo de vida de pedidos da API de Checkout

  Background:
    * url baseUrl

  Scenario: Listagem do histórico de pedidos realizados
    Given path '/api/orders'
    When method get
    Then status 200
    And match response.success == true
    And assert response.total >= 0
    And match response.orders == '#[]'

  Scenario: Consulta de detalhes de pedido por ID existente
    # 1. Garante a existência de um pedido criando um novo
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
        "customerName": "Galileo Guilherme (QA Demo)",
        "customerEmail": "qa@exemplo.com",
        "address": "Rua dos Testes, 123 - Recife, PE"
      }
      """
    When method post
    Then status 201
    * def orderId = response.order.id

    # 2. Consulta o pedido criado pelo ID retornado
    Given path '/api/orders/' + orderId
    When method get
    Then status 200
    And match response.success == true
    And match response.order.id == orderId
    And match response.order.status == 'CONFIRMED'
    And match response.order.customerEmail == 'qa@exemplo.com'
    And match response.order.total == 199.9

  Scenario: Consulta de pedido com identificador inexistente (HTTP 404)
    Given path '/api/orders/ORD-INEXISTENTE-000'
    When method get
    Then status 404
    And match response.success == false
    And match response.error contains 'não encontrado'

  Scenario: Ciclo de vida completo do pedido: Criação, Atualização de Status e Cancelamento (POST, PATCH e DELETE)
    # 1. Cria um novo pedido
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
    And match response.order.id == '#regex ^ORD-\\d+'
    * def createdOrderId = response.order.id

    # 2. Atualiza o status de entrega do pedido para SHIPPED
    Given path '/api/orders/' + createdOrderId + '/status'
    And request { "status": "SHIPPED" }
    When method patch
    Then status 200
    And match response.success == true
    And match response.order.status == 'SHIPPED'

    # 3. Cancela e remove o pedido
    Given path '/api/orders/' + createdOrderId
    When method delete
    Then status 200
    And match response.success == true
    And match response.message contains 'cancelado com sucesso'
    And match response.order.status == 'CANCELLED'

  Scenario: Rejeição de atualização de status com valor inválido (HTTP 400)
    Given path '/api/orders/ORD-948210/status'
    And request { "status": "STATUS_INEXISTENTE" }
    When method patch
    Then status 400
    And match response.success == false
    And match response.error contains 'Status inválido'

  Scenario: Rejeição de atualização de status em pedido inexistente (HTTP 404)
    Given path '/api/orders/ORD-FANTASMA-999/status'
    And request { "status": "DELIVERED" }
    When method patch
    Then status 404
    And match response.success == false
    And match response.error contains 'não encontrado'

  Scenario: Rejeição de cancelamento de pedido inexistente (HTTP 404)
    Given path '/api/orders/ORD-FANTASMA-999'
    When method delete
    Then status 404
    And match response.success == false
    And match response.error contains 'não encontrado para cancelamento'

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
