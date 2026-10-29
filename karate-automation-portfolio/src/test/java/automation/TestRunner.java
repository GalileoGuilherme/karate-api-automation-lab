package automation;

import com.intuit.karate.junit5.Karate;

public class TestRunner {

    /**
     * Executa todos os testes da aplicação Loja de Testes (API + UI).
     */
    @Karate.Test
    Karate testLojaSuite() {
        return Karate.run("loja_testes", "autenticacao_ui", "catalogo_carrinho_ui").relativeTo(getClass());
    }

    /**
     * Executa somente a suíte de testes de API e regras de negócio da Loja de Testes.
     */
    @Karate.Test
    Karate testLoja() {
        return Karate.run("loja_testes").relativeTo(getClass());
    }

    /**
     * Executa a automação de interface (UI) de autenticação com Karate Driver.
     */
    @Karate.Test
    Karate testAutenticacaoUi() {
        return Karate.run("autenticacao_ui").relativeTo(getClass());
    }

    /**
     * Executa a automação de interface (UI) do catálogo e carrinho com Karate Driver.
     */
    @Karate.Test
    Karate testCatalogoCarrinhoUi() {
        return Karate.run("catalogo_carrinho_ui").relativeTo(getClass());
    }

    /**
     * Executa os testes replicados da aplicação Demo local (Wallet API + Login).
     * Requer a aplicação local rodando em http://localhost:3000 (npm run demo).
     */
    @Karate.Test
    Karate testDemoSuite() {
        return Karate.run("demo_wallet_api", "demo_login_api", "demo_login_ui").relativeTo(getClass());
    }

}
