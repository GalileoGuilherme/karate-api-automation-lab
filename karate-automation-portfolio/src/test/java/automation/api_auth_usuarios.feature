@api @auth
Feature: Gestão de Autenticação e Usuários (Swagger /api-docs)

  Como um Usuário do QA Automation Lab
  Quero autenticar, registrar, gerenciar sessão e consultar meu perfil via REST API
  Para validar os contratos e comportamentos dos endpoints de autenticação

  Background:
    * url baseUrl

  Scenario: Autenticação com credencial padrão de QA (123456)
    Given path '/api/auth/login'
    And request { email: '#(demoUser.email)', password: '#(demoUser.simplePassword)' }
    When method post
    Then status 200
    And match response.success == true
    And match response.message contains 'sucesso'
    And match response.token == '#string'
    And match response.user.email == demoUser.email
    And match response.user.id == 'user-qa-01'

  Scenario: Autenticação com credencial alternativa da Loja (LabQA!Run-7kV2pX9m)
    Given path '/api/auth/login'
    And request { email: '#(demoUser.email)', password: '#(demoUser.password)' }
    When method post
    Then status 200
    And match response.success == true
    And match response.token == '#regex ^mock-jwt-token\\..*'
    And match response.user.email == demoUser.email

  Scenario: Falha de autenticação com credenciais incorretas (HTTP 401)
    Given path '/api/auth/login'
    And request { email: 'qa@exemplo.com', password: 'senha-totalmente-errada' }
    When method post
    Then status 401
    And match response.success == false
    And match response.error contains 'Credenciais inválidas'

  Scenario: Validação de campos obrigatórios no login (HTTP 400)
    Given path '/api/auth/login'
    And request { email: '', password: '' }
    When method post
    Then status 400
    And match response.success == false
    And match response.error contains 'obrigatórios'

  Scenario: Cadastro simulado de novo usuário com sucesso (HTTP 201)
    Given path '/api/auth/register'
    And request
      """
      {
        "name": "Engenheiro QA Automação",
        "email": "engenheiro.qa@exemplo.com",
        "password": "SenhaSegura123!"
      }
      """
    When method post
    Then status 201
    And match response.success == true
    And match response.message contains 'registrado com sucesso'
    And match response.user.id == '#string'
    And match response.user.name == 'Engenheiro QA Automação'
    And match response.user.email == 'engenheiro.qa@exemplo.com'
    And match response.user.createdAt == '#string'

  Scenario: Falha no cadastro por campos obrigatórios ausentes (HTTP 400)
    Given path '/api/auth/register'
    And request { "name": "Usuário Incompleto" }
    When method post
    Then status 400
    And match response.success == false
    And match response.error contains 'obrigatórios'

  Scenario: Invalidação de sessão / Logout (HTTP 200)
    Given path '/api/auth/logout'
    When method post
    Then status 200
    And match response.success == true
    And match response.message contains 'revogado'

  Scenario: Consulta de perfil do usuário autenticado (GET /api/users/me)
    Given path '/api/users/me'
    When method get
    Then status 200
    And match response.success == true
    And match response.user.email == 'qa@exemplo.com'
    And match response.user.id == 'user-qa-01'
    And match response.user.name contains 'Galileo Guilherme'
    And match response.user.role == '#string'

  Scenario: Atualização dos dados do perfil do usuário (PUT /api/users/me)
    Given path '/api/users/me'
    And request { "phone": "(81) 99999-8888", "address": "Av. Boa Viagem, 1000 - Recife, PE" }
    When method put
    Then status 200
    And match response.success == true
    And match response.message contains 'atualizado com sucesso'
    And match response.user.phone == '(81) 99999-8888'
    And match response.user.address == 'Av. Boa Viagem, 1000 - Recife, PE'
    And match response.user.updatedAt == '#string'
