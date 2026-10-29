@demo @wallet @api
Feature: Demo de API de Carteira

  Background:
    * url karate.properties['DEMO_URL'] || 'http://localhost:3000'

  Scenario: Retorna o saldo da carteira de demonstração
    Given path '/api/wallet/balance/demo-wallet'
    When method GET
    Then status 200
    And match response == { walletId: 'demo-wallet', balance: 125.5, currency: 'BRL' }
    And match response.walletId == 'demo-wallet'
    And match response.balance == 125.5
    And match response.currency == 'BRL'
