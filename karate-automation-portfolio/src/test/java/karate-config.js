function fn() {
  var env = karate.env; // Recupera a propriedade do sistema 'karate.env' (ex: mvn test -Dkarate.env=e2e)
  karate.log('karate.env definido como:', env);

  if (!env) {
    env = 'dev';
  }

  // Configurações globais de ambiente conectadas à API e à aplicação do portfólio
  var config = {
    env: env,
    baseUrl: 'https://portfolio-omega-six-18.vercel.app',
    apiUrl: 'https://portfolio-omega-six-18.vercel.app/api',
    docsUrl: 'https://portfolio-omega-six-18.vercel.app/api-docs',
    automationPath: '/automation',
    demoUser: {
      email: 'qa@exemplo.com',
      password: 'LabQA!Run-7kV2pX9m',
      simplePassword: '123456'
    },
    demoCoupon: 'CYPRESS10'
  };

  // Timeouts de conexão e leitura configurados adequadamente (em milissegundos)
  karate.configure('connectTimeout', 15000);
  karate.configure('readTimeout', 15000);
  karate.configure('ssl', true);

  return config;
}
