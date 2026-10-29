@api @health
Feature: Monitoramento e Health Check da API (Swagger /api-docs)

  Como um Engenheiro de QA
  Quero validar a disponibilidade, uptime e integridade da API REST
  Para garantir que todos os serviços estejam operacionais antes dos testes E2E

  Background:
    * url baseUrl

  Scenario: Validar status 200 e integridade dos dados no Health Check
    Given path '/api/health'
    When method get
    Then status 200
    And match responseStatus == 200
    And match header Content-Type contains 'application/json'
    And match response.status == 'UP'
    And match response.service == 'qa-portfolio-api'
    And match response.version == '1.0.0'
    And match response.environment == '#string'
    And match response.uptime == '#number'
    And match response.timestamp == '#regex ^\\d{4}-\\d{2}-\\d{2}T.*'

  Scenario: Bloqueio de método HTTP não permitido (POST no Health Check)
    Given path '/api/health'
    When method post
    Then status 405
    And match response.success == false
    And match response.error contains 'Método não permitido'
    And match header Allow contains 'GET'
