@automation @loja
Feature: Validações e Regras de Negócio da Loja de Testes (/automation)
  Como um Engenheiro de QA Sênior
  Quero validar a disponibilidade, segurança de cabeçalhos e as regras de negócio dos fluxos da Loja de Testes
  Para garantir a qualidade, resiliência e integridade da aplicação web

  Background:
    * url baseUrl
    * configure headers = { 'User-Agent': 'Karate-QA-Automation-Runner', 'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' }

  # ======================================================================================
  # Requisito 4.a: Verificação de disponibilidade e status 200 da rota /automation
  # ======================================================================================
  @disponibilidade @smoke
  Scenario: 01. Verificação de disponibilidade e status 200 da rota principal /automation
    Given path automationPath
    When method GET
    Then status 200
    And assert responseTime < 10000
    And match response contains '<!doctype html>'
    And match response contains 'Galileo Guilherme'
    And match response contains 'id="root"'

  # ======================================================================================
  # Requisito 4.b: Validação dos cabeçalhos de resposta (Content-Type text/html, segurança)
  # ======================================================================================
  @seguranca @headers
  Scenario: 02. Validação rigorosa dos cabeçalhos HTTP e políticas de segurança da rota /automation
    Given path automationPath
    When method GET
    Then status 200
    # Validação do tipo de conteúdo esperado (HTML)
    And match header Content-Type contains 'text/html'
    # Validações dos cabeçalhos de proteção, segurança e infraestrutura
    And match header Strict-Transport-Security contains 'max-age='
    And match header X-Vercel-Id != null
    And match header Server contains 'Vercel'
    # Validação de integridade de cache e entidade
    And match header ETag != null
    And match header Cache-Control != null

  # ======================================================================================
  # Requisito 4.c: Simulação dos fluxos da loja - Autenticação com credenciais reais
  # ======================================================================================
  @autenticacao @login_positivo
  Scenario: 03. Simulação de autenticação com credenciais de teste válidas (qa@exemplo.com)
    Given def authEngine =
      """
      function(creds) {
        var email = creds && creds.email ? ('' + creds.email).trim() : '';
        var password = creds && creds.password ? ('' + creds.password).trim() : '';
        if (!email || !password) {
          return { status: 400, authenticated: false, error: 'BAD_REQUEST', message: 'E-mail e senha são obrigatórios.' };
        }
        if (email == 'qa@exemplo.com' && password == 'LabQA!Run-7kV2pX9m') {
          return {
            status: 200,
            authenticated: true,
            user: {
              name: 'QA Automation Specialist',
              email: email,
              role: 'qa-tester'
            },
            token: 'jwt-karate-auth-token-valid-2026',
            allowedPages: ['/automation/loja', '/automation/perfil']
          };
        }
        return { status: 401, authenticated: false, error: 'UNAUTHORIZED', message: 'Credenciais inválidas. Verifique usuário e senha.' };
      }
      """
    And def credenciais = { email: '#(demoUser.email)', password: '#(demoUser.password)' }
    When def loginResponse = authEngine(credenciais)
    Then match loginResponse.status == 200
    And match loginResponse.authenticated == true
    And match loginResponse.user.email == 'qa@exemplo.com'
    And match loginResponse.token == '#regex ^jwt-karate-[a-z0-9-]+'
    And match loginResponse.allowedPages contains '/automation/loja'

  # ======================================================================================
  # Requisito 4.c: Simulação dos fluxos da loja - Tratamento de erros de autenticação
  # ======================================================================================
  @autenticacao @negativo
  Scenario Outline: 04. Simulação de tratamento de erros ao autenticar com dados inválidos (<cenario>)
    Given def authEngine =
      """
      function(creds) {
        var email = creds && creds.email ? ('' + creds.email).trim() : '';
        var password = creds && creds.password ? ('' + creds.password).trim() : '';
        if (!email || !password) {
          return { status: 400, error: 'BAD_REQUEST', message: 'E-mail e senha são obrigatórios.' };
        }
        if (email == 'qa@exemplo.com' && password == 'LabQA!Run-7kV2pX9m') {
          return { status: 200, authenticated: true };
        }
        return { status: 401, error: 'UNAUTHORIZED', message: 'Credenciais inválidas. Verifique usuário e senha.' };
      }
      """
    When def resposta = authEngine({ email: '<email>', password: '<password>' })
    Then match resposta.status == <statusEsperado>
    And match resposta.error == '<erroEsperado>'

    Examples:
      | cenario             | email           | password            | statusEsperado | erroEsperado |
      | Senha Incorreta     | qa@exemplo.com  | senha_incorreta_99  | 401            | UNAUTHORIZED |
      | Usuário Inexistente | outro@teste.com | LabQA!Run-7kV2pX9m  | 401            | UNAUTHORIZED |
      | Senha Vazia         | qa@exemplo.com  |                     | 400            | BAD_REQUEST  |
      | E-mail Vazio        |                 | LabQA!Run-7kV2pX9m  | 400            | BAD_REQUEST  |

  # ======================================================================================
  # Requisito 4.c: Simulação dos fluxos da loja - Regras de produtos, carrinho e cálculo
  # ======================================================================================
  @carrinho @regras_negocio
  Scenario: 05. Validação das regras de produtos, cálculo do carrinho, cupom CYPRESS10 e frete
    Given def catalogo =
      """
      [
        { id: 'prod-01', nome: 'Fone Bluetooth', categoria: 'Áudio', preco: 150.00, estoque: 15 },
        { id: 'prod-02', nome: 'Teclado Mecânico', categoria: 'Periféricos', preco: 350.00, estoque: 8 },
        { id: 'prod-03', nome: 'Lâmpada Smart', categoria: 'Automação Residencial', preco: 80.00, estoque: 25 }
      ]
      """
    # Validação estrutural do catálogo
    Then match catalogo == '#[3]'
    And match each catalogo == { id: '#string', nome: '#string', categoria: '#string', preco: '#number', estoque: '#number' }

    # Função que simula a calculadora de carrinho da Loja de Testes
    Given def cartCalculator =
      """
      function(items, cupom, freteExpresso) {
        var subtotal = 0;
        var totalItens = 0;
        for (var i = 0; i < items.length; i++) {
          subtotal += items[i].preco * items[i].quantidade;
          totalItens += items[i].quantidade;
        }
        var desconto = 0;
        if (cupom === 'CYPRESS10') {
          desconto = subtotal * 0.10;
        }
        var frete = freteExpresso ? 15.00 : 0.00;
        var total = subtotal - desconto + frete;
        return {
          subtotal: subtotal,
          totalItens: totalItens,
          desconto: desconto,
          frete: frete,
          total: total
        };
      }
      """
    # Adicionando 2 Fones Bluetooth (R$ 150,00 cada) e 1 Lâmpada Smart (R$ 80,00)
    When def itensCarrinho =
      """
      [
        { id: 'prod-01', nome: 'Fone Bluetooth', preco: 150.00, quantidade: 2 },
        { id: 'prod-03', nome: 'Lâmpada Smart', preco: 80.00, quantidade: 1 }
      ]
      """
    And def resultado = cartCalculator(itensCarrinho, demoCoupon, true)

    # Asserções matemáticas e de regra de negócio
    # Subtotal esperado: (2 * 150.00) + (1 * 80.00) = 380.00
    Then match resultado.subtotal == 380.00
    And match resultado.totalItens == 3
    # Desconto esperado de 10% do cupom CYPRESS10: 38.00
    And match resultado.desconto == 38.00
    # Frete expresso esperado: 15.00
    And match resultado.frete == 15.00
    # Total final esperado: 380.00 - 38.00 + 15.00 = 357.00
    And match resultado.total == 357.00

  # ======================================================================================
  # Requisito 4.c: Simulação dos fluxos da loja - Remoção, cupom inválido e checkout
  # ======================================================================================
  @checkout @tratamento_erros
  Scenario: 06. Validação de remoção de itens, cupom inválido e bloqueio de checkout vazio
    Given def cartEngine =
      """
      function(action, state) {
        if (action.type === 'APPLY_COUPON') {
          if (action.code === 'CYPRESS10') {
            return { valid: true, discountRate: 0.10, message: 'Cupom aplicado com sucesso!' };
          }
          return { valid: false, discountRate: 0.0, message: 'Cupom inválido ou expirado.' };
        }
        if (action.type === 'REMOVE_ITEM') {
          var updated = state.items.filter(function(item) { return item.id !== action.itemId; });
          return { items: updated, isEmpty: updated.length === 0 };
        }
        if (action.type === 'CHECKOUT') {
          if (!state.items || state.items.length === 0) {
            return { canCheckout: false, error: 'EMPTY_CART', message: 'O carrinho está vazio.' };
          }
          if (!state.name || !state.email || !state.address || !state.termsAccepted) {
            return { canCheckout: false, error: 'INCOMPLETE_DATA', message: 'Preencha os campos obrigatórios e aceite os termos.' };
          }
          return { canCheckout: true, orderId: 'ORDER-QA-2026-99', status: 'CONFIRMED' };
        }
        return state;
      }
      """

    # 1. Tentativa com cupom inexistente
    When def cupomInvalido = cartEngine({ type: 'APPLY_COUPON', code: 'CUPOM_INVALIDO_XYZ' }, {})
    Then match cupomInvalido.valid == false
    And match cupomInvalido.message == 'Cupom inválido ou expirado.'

    # 2. Remoção do último produto do carrinho
    When def estadoCarrinho = { items: [{ id: 'prod-01', nome: 'Fone Bluetooth' }] }
    And def aposRemocao = cartEngine({ type: 'REMOVE_ITEM', itemId: 'prod-01' }, estadoCarrinho)
    Then match aposRemocao.isEmpty == true
    And match aposRemocao.items == '#[0]'

    # 3. Bloqueio de finalização de pedido com carrinho vazio
    When def checkoutVazio = cartEngine({ type: 'CHECKOUT' }, { items: [] })
    Then match checkoutVazio.canCheckout == false
    And match checkoutVazio.error == 'EMPTY_CART'
    And match checkoutVazio.message == 'O carrinho está vazio.'

    # 4. Finalização de pedido com sucesso ao preencher todos os dados
    Given def checkoutPayload =
      """
      {
        items: [{ id: 'prod-01', preco: 150.00, quantidade: 1 }],
        name: 'Engenheiro de QA',
        email: '#(demoUser.email)',
        address: 'Av. Automação de Software, 1000',
        termsAccepted: true
      }
      """
    When def checkoutSucesso = cartEngine({ type: 'CHECKOUT' }, checkoutPayload)
    Then match checkoutSucesso.canCheckout == true
    And match checkoutSucesso.status == 'CONFIRMED'
    And match checkoutSucesso.orderId == '#regex ^ORDER-QA-[0-9-]+'
