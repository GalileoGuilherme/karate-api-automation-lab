@demo @auth @api
Feature: Demo de Login - API de Autenticação

  Background:
    * url karate.properties['DEMO_URL'] || 'http://localhost:3000'

  Scenario: Autentica com sucesso com as credenciais da demo
    Given path '/api/login'
    And request { email: 'demo@example.com', password: 'Cypress123!' }
    When method POST
    Then status 200
    And match response == { user: { name: 'Demo' }, token: 'demo-token' }
    And match response.user.name == 'Demo'
    And match response.token == 'demo-token'

  Scenario: Rejeita autenticação com credenciais incorretas
    Given path '/api/login'
    And request { email: 'demo@example.com', password: 'SenhaIncorreta!' }
    When method POST
    Then status 401
    And match response == { error: 'Invalid email or password.' }

