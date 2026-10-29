@ui @catalogo @carrinho
Feature: Catálogo de Produtos e Fluxo de Carrinho

  Background:
    * configure driver = { type: 'chrome', showDriverLog: false }
    * def baseUrl = karate.properties['CYPRESS_BASE_URL'] || 'https://portfolio-omega-six-18.vercel.app'

  Scenario: Busca de produto no catálogo com resultado dinâmico
    Given driver baseUrl + '/automation'
    And waitFor('#qa-login-email')
    And input('#qa-login-email', 'qa@exemplo.com')
    And input('#qa-login-password', 'LabQA!Run-7kV2pX9m')
    And click('#qa-login-submit')
    Then waitFor('#qa-product-search')
    When input('#qa-product-search', 'Fone Bluetooth')
    Then retry(5, 1000).waitFor('#qa-product-fone-bluetooth')
    And match exists('#qa-product-fone-bluetooth') == true

  Scenario: Adição de item ao carrinho e validação de quantidade/total
    Given driver baseUrl + '/automation'
    And waitFor('#qa-login-email')
    And input('#qa-login-email', 'qa@exemplo.com')
    And input('#qa-login-password', 'LabQA!Run-7kV2pX9m')
    And click('#qa-login-submit')
    Then waitFor('#qa-add-fone-bluetooth')
    When click('#qa-add-fone-bluetooth')
    Then waitFor('#qa-cart-count')
    And match text('#qa-cart-count') contains '1'
    And match text('#qa-subtotal') != 'R$ 0,00'

  Scenario: Remoção de item e validação de carrinho vazio
    Given driver baseUrl + '/automation'
    And waitFor('#qa-login-email')
    And input('#qa-login-email', 'qa@exemplo.com')
    And input('#qa-login-password', 'LabQA!Run-7kV2pX9m')
    And click('#qa-login-submit')
    Then waitFor('#qa-add-fone-bluetooth')
    And click('#qa-add-fone-bluetooth')
    And waitFor('#qa-remove-fone-bluetooth')
    When click('#qa-remove-fone-bluetooth')
    Then waitFor('#qa-cart-empty')
    And match exists('#qa-cart-empty') == true
