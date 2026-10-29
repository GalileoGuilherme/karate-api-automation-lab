@ui @autenticacao
Feature: Autenticação de Usuário no QA Automation Lab

  Background:
    * configure driver = { type: 'chrome', showDriverLog: false }
    * def baseUrl = karate.properties['CYPRESS_BASE_URL'] || 'https://portfolio-omega-six-18.vercel.app'
    * def Key = Java.type('com.intuit.karate.driver.Key')

  Scenario: Login com credenciais válidas e acesso ao dashboard
    Given driver baseUrl + '/automation'
    And waitFor('#qa-login-email')
    And input('#qa-login-email', 'qa@exemplo.com')
    And input('#qa-login-password', 'LabQA!Run-7kV2pX9m')
    When click('#qa-login-submit')
    Then waitFor('#qa-products-section')
    And match exists('#qa-products-section') == true
    And match exists('#qa-store-user') == true

  Scenario: Tentativa de login com senha incorreta
    Given driver baseUrl + '/automation'
    And waitFor('#qa-login-email')
    And input('#qa-login-email', 'qa@exemplo.com')
    And input('#qa-login-password', 'senhaErrada')
    When click('#qa-login-submit')
    Then waitFor('#qa-login-error')
    And match text('#qa-login-error') contains 'inválidos'
    And match enabled('#qa-login-submit') == true

  Scenario: Bloqueio de submissão com campos obrigatórios vazios
    Given driver baseUrl + '/automation'
    And waitFor('#qa-login-submit')
    When click('#qa-login-submit')
    Then match attribute('#qa-login-email', 'required') != null
    And match attribute('#qa-login-password', 'required') != null

  Scenario: Acessibilidade e navegação por teclado (Tab e Enter)
    Given driver baseUrl + '/automation'
    And waitFor('#qa-login-email')
    When script("document.querySelector('#qa-login-email').focus()")
    # Simula foco e envio por teclado
    And input('#qa-login-email', ['qa@exemplo.com', Key.TAB])
    And input('#qa-login-password', ['LabQA!Run-7kV2pX9m', Key.ENTER])
    Then waitFor('#qa-products-section')
    And match exists('#qa-products-section') == true
