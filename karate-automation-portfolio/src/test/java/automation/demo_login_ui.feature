@demo @ui @login
Feature: Demo de Login - Interface (UI)

  Background:
    * configure driver = { type: 'chrome', showDriverLog: false }
    * def appUrl = karate.properties['DEMO_URL'] || 'http://localhost:3000'

  Scenario: Autentica na demo e abre o dashboard
    Given driver appUrl
    And waitFor('[data-testid=email]')
    And input('[data-testid=email]', 'demo@example.com')
    And input('[data-testid=password]', 'Cypress123!')
    When click('[data-testid=submit]')
    Then waitFor('[data-testid=dashboard]')
    And match text('[data-testid=welcome]') contains 'Bem-vindo'

