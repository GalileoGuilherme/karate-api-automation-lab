package automation;

import com.intuit.karate.junit5.Karate;

/**
 * TestRunner JUnit 5 do Karate Framework.
 * Responsável por orquestrar a execução de todas as suítes de testes de API e UI
 * baseadas na especificação Swagger OpenAPI (https://portfolio-omega-six-18.vercel.app/api-docs)
 * e nos fluxos da Loja de Testes.
 */
public class TestRunner {

    /**
     * Executa todos os testes de API documentados no Swagger OpenAPI:
     * - Health Check (/api/health)
     * - Autenticação e Gestão de Usuários (/api/auth/* e /api/users/*)
     * - Catálogo e Busca de Produtos (/api/products/*)
     * - Gestão do Carrinho (/api/cart/*)
     * - Cupons de Desconto e Frete (/api/coupons/* e /api/shipping/*)
     * - Pedidos e Checkout (/api/orders/*)
     */
    @Karate.Test
    Karate testAllApis() {
        return Karate.run(
            "api_health",
            "api_auth_usuarios",
            "api_produtos",
            "api_carrinho",
            "api_cupons_frete",
            "api_pedidos_checkout"
        ).relativeTo(getClass());
    }

    /**
     * Executa os testes de Health Check e Monitoramento.
     */
    @Karate.Test
    Karate testHealthApi() {
        return Karate.run("api_health").relativeTo(getClass());
    }

    /**
     * Executa os testes de Autenticação e Usuários.
     */
    @Karate.Test
    Karate testAuthUsuariosApi() {
        return Karate.run("api_auth_usuarios").relativeTo(getClass());
    }

    /**
     * Executa os testes de Catálogo e Produtos.
     */
    @Karate.Test
    Karate testProdutosApi() {
        return Karate.run("api_produtos").relativeTo(getClass());
    }

    /**
     * Executa os testes de Carrinho de Compras.
     */
    @Karate.Test
    Karate testCarrinhoApi() {
        return Karate.run("api_carrinho").relativeTo(getClass());
    }

    /**
     * Executa os testes de Cupons e Frete.
     */
    @Karate.Test
    Karate testCuponsFreteApi() {
        return Karate.run("api_cupons_frete").relativeTo(getClass());
    }

    /**
     * Executa os testes de Pedidos e Checkout.
     */
    @Karate.Test
    Karate testPedidosCheckoutApi() {
        return Karate.run("api_pedidos_checkout").relativeTo(getClass());
    }

    /**
     * Executa os testes de interface gráfica (UI) no Google Chrome via Karate Driver.
     */
    @Karate.Test
    Karate testUiSuite() {
        return Karate.run("autenticacao_ui", "catalogo_carrinho_ui").relativeTo(getClass());
    }

    /**
     * Executa a suíte de ponta a ponta da Loja de Testes.
     */
    @Karate.Test
    Karate testLojaSuite() {
        return Karate.run("loja_testes", "autenticacao_ui", "catalogo_carrinho_ui").relativeTo(getClass());
    }

    /**
     * Executa os testes replicados da aplicação Demo local (Wallet API + Login).
     */
    @Karate.Test
    Karate testDemoSuite() {
        return Karate.run("demo_wallet_api", "demo_login_api", "demo_login_ui").relativeTo(getClass());
    }

}
