package automation;

import com.intuit.karate.junit5.Karate;

/**
 * TestRunner JUnit 5 do Karate Framework.
 * Responsável por orquestrar a execução de todas as suítes de testes de API REST
 * cobrindo 100% dos endpoints formalizados na documentação Swagger OpenAPI
 * (https://portfolio-omega-six-18.vercel.app/api-docs).
 */
public class TestRunner {

    /**
     * Executa todos os testes de API documentados no Swagger OpenAPI:
     * - Monitoramento e Health Check (/api/health)
     * - Autenticação e Gestão de Usuários (/api/auth/* e /api/users/*)
     * - Catálogo e Busca de Produtos (/api/products/*)
     * - Gestão do Carrinho (/api/cart/*)
     * - Cupons de Desconto e Cálculo de Frete (/api/coupons/* e /api/shipping/*)
     * - Pedidos e Finalização de Checkout (/api/orders/*)
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
     * Executa os testes de Monitoramento e Health Check (/api/health).
     */
    @Karate.Test
    Karate testHealthApi() {
        return Karate.run("api_health").relativeTo(getClass());
    }

    /**
     * Executa os testes de Autenticação, Verificação de Sessão, Registro e Perfil de Usuários.
     */
    @Karate.Test
    Karate testAuthUsuariosApi() {
        return Karate.run("api_auth_usuarios").relativeTo(getClass());
    }

    /**
     * Executa os testes de Catálogo de Produtos, Categorias, Busca Textual e Gestão CRUD.
     */
    @Karate.Test
    Karate testProdutosApi() {
        return Karate.run("api_produtos").relativeTo(getClass());
    }

    /**
     * Executa os testes de Gestão do Carrinho de Compras (Adição, Alteração, Exclusão e Limpeza).
     */
    @Karate.Test
    Karate testCarrinhoApi() {
        return Karate.run("api_carrinho").relativeTo(getClass());
    }

    /**
     * Executa os testes de Validação de Cupons Promocionais e Cálculo de Frete por CEP.
     */
    @Karate.Test
    Karate testCuponsFreteApi() {
        return Karate.run("api_cupons_frete").relativeTo(getClass());
    }

    /**
     * Executa os testes de Pedidos, Checkout, Atualização de Status e Cancelamento.
     */
    @Karate.Test
    Karate testPedidosCheckoutApi() {
        return Karate.run("api_pedidos_checkout").relativeTo(getClass());
    }

}
