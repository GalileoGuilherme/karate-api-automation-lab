@api @auth
Feature: Gestão de Autenticação e Usuários (Swagger /api-docs)

  Como um Usuário do QA Automation Lab
  Quero autenticar, verificar sessão, registrar, atualizar senha e gerenciar perfil via REST API
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

  Scenario: Validação de integridade do JWT e sessão ativa com Bearer token (GET /api/auth/verify)
    # 1. Realiza login para obter o token JWT
    Given path '/api/auth/login'
    And request { email: '#(demoUser.email)', password: '#(demoUser.simplePassword)' }
    When method post
    Then status 200
    * def authToken = response.token

    # 2. Valida o token gerado no endpoint de verificação
    Given path '/api/auth/verify'
    And header Authorization = 'Bearer ' + authToken
    When method get
    Then status 200
    And match response.valid == true
    And match response.message contains 'ativo'
    And match response.session.email == demoUser.email
    And match response.session.userId == 'user-qa-01'

  Scenario: Rejeição de verificação de sessão sem token ou formato inválido (HTTP 401)
    Given path '/api/auth/verify'
    When method get
    Then status 401
    And match response.valid == false
    And match response.error contains 'Token não fornecido'

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

  Scenario: Cadastro simulado de novo usuário com e-mail dinâmico (HTTP 201)
    * def uniqueEmail = 'qa.novo.' + java.lang.System.currentTimeMillis() + '@exemplo.com'
    Given path '/api/auth/register'
    And request
      """
      {
        "name": "Engenheiro QA Automação",
        "email": "#(uniqueEmail)",
        "password": "SenhaSegura123!"
      }
      """
    When method post
    Then status 201
    And match response.success == true
    And match response.message contains 'registrado com sucesso'
    And match response.user.id == '#string'
    And match response.user.name == 'Engenheiro QA Automação'
    And match response.user.email == uniqueEmail
    And match response.user.createdAt == '#string'

  Scenario: Rejeição de cadastro com e-mail duplicado de teste (HTTP 409)
    Given path '/api/auth/register'
    And request
      """
      {
        "name": "Usuário Duplicado",
        "email": "qa@exemplo.com",
        "password": "QualquerSenha123!"
      }
      """
    When method post
    Then status 409
    And match response.success == false
    And match response.error contains 'Já existe um usuário de teste cadastrado'

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

  Scenario: Atualização de senha de usuário com persistência (PATCH /api/users/me/password)
    Given path '/api/users/me/password'
    And request
      """
      {
        "email": "qa@exemplo.com",
        "currentPassword": "LabQA!Run-7kV2pX9m",
        "newPassword": "LabQA!Run-7kV2pX9m"
      }
      """
    When method patch
    Then status 200
    And match response.success == true
    And match response.message contains 'atualizada com sucesso'

  Scenario: Rejeição de atualização de senha curta com menos de 6 caracteres (HTTP 400)
    Given path '/api/users/me/password'
    And request
      """
      {
        "email": "qa@exemplo.com",
        "currentPassword": "LabQA!Run-7kV2pX9m",
        "newPassword": "123"
      }
      """
    When method patch
    Then status 400
    And match response.success == false
    And match response.error contains 'mínimo 6 caracteres'

  Scenario: Rejeição de atualização com senha atual incorreta (HTTP 401)
    Given path '/api/users/me/password'
    And request
      """
      {
        "email": "qa@exemplo.com",
        "currentPassword": "senha_totalmente_errada",
        "newPassword": "NovaSenhaForte123!"
      }
      """
    When method patch
    Then status 401
    And match response.success == false
    And match response.error contains 'Senha atual incorreta'

  Scenario: Listagem de todos os usuários cadastrados e mockados (GET /api/users)
    Given path '/api/users'
    When method get
    Then status 200
    And match response.success == true
    And assert response.total >= 1
    And match response.users == '#[]'
    And match response.users[0].id == '#string'
    And match response.users[0].name == '#string'
    And match response.users[0].email == '#string'
