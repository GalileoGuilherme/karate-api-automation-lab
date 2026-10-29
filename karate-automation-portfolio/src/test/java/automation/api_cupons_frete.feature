@api @cupons @frete
Feature: Validação de Cupons Promocionais e Cálculo de Frete (Swagger /api-docs)

  Como um Usuário do E-Commerce
  Quero aplicar cupons de desconto válidos e simular cálculo de frete por CEP
  Para certificar que os descontos e opções de entrega estão em conformidade com as regras de negócio

  Background:
    * url baseUrl

  Scenario Outline: Validação de cupons promocionais ativos com desconto esperado
    Given path '/api/coupons/validate'
    And request { "code": "<cupom>" }
    When method post
    Then status 200
    And match response.valid == true
    And match response.code == '<codigoEsperado>'
    And match response.discountPercent == <descontoEsperado>
    And match response.message contains '<descontoEsperado>%'

    Examples:
      | cupom        | codigoEsperado | descontoEsperado |
      | CYPRESS10    | CYPRESS10      | 10               |
      | cypress10    | CYPRESS10      | 10               |
      | PLAYWRIGHT15 | PLAYWRIGHT15   | 15               |
      | QALAB20      | QALAB20        | 20               |

  Scenario: Rejeição de cupom promocional inexistente ou inválido (HTTP 400)
    Given path '/api/coupons/validate'
    And request { "code": "CUPOM_DESCONHECIDO_99" }
    When method post
    Then status 400
    And match response.valid == false
    And match response.error contains 'inválido ou expirado'

  Scenario: Falha ao validar cupom sem código informado (HTTP 400)
    Given path '/api/coupons/validate'
    And request { "code": "" }
    When method post
    Then status 400
    And match response.valid == false
    And match response.error contains 'obrigatório'

  Scenario: Cálculo de frete com CEP válido retornando opções Padrão e Expressa
    Given path '/api/shipping/calculate'
    And request { "cep": "50000-000" }
    When method post
    Then status 200
    And match response.success == true
    And match response.cep == '50000-000'
    And match response.methods == '#[2]'
    And match response.methods[0].id == 'standard'
    And match response.methods[0].price == 0.0
    And match response.methods[1].id == 'express'
    And match response.methods[1].price == 15.0

  Scenario: Cálculo de frete aceitando CEP formatado com caracteres especiais
    Given path '/api/shipping/calculate'
    And request { "cep": "51.020-010" }
    When method post
    Then status 200
    And match response.success == true
    And match response.cep == '51020-010'
    And match response.methods[0].price == 0.0

  Scenario: Rejeição de frete com CEP de tamanho inválido (HTTP 400)
    Given path '/api/shipping/calculate'
    And request { "cep": "123" }
    When method post
    Then status 400
    And match response.success == false
    And match response.error contains 'Deve conter 8 dígitos'

  Scenario: Rejeição de frete sem informar o CEP (HTTP 400)
    Given path '/api/shipping/calculate'
    And request { }
    When method post
    Then status 400
    And match response.success == false
    And match response.error contains 'obrigatório'

