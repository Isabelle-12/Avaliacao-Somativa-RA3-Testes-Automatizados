*** Settings ***
Documentation    Casos de teste automatizados do Printly (autora: Laura)
...    Casos do plano do RA2 sob responsabilidade da Laura: CT1, CT2, CT4, CT6 e CT7.
Resource         resources.robot
Test Setup       Abrir Navegador
Test Teardown    Fechar Navegador

*** Test Cases ***
CT1 - Cadastrar cliente com todos os campos obrigatórios preenchidos corretamente
    [Documentation]    Cadastra um cliente novo com todos os campos válidos e confirma que
    ...    é possível efetuar login com as credenciais recém-criadas.
    ...    Observação: a mensagem "Cadastro realizado com sucesso!" é um alerta nativo do
    ...    navegador, que o Selenium não consegue fotografar; o texto é validado e fica no log.html.
    ...    Dados: cria um cliente novo (e-mail e nome únicos) a cada execução.
    ...    Evidências: resultados/CT1_Evidencias

    [Tags]    cadastro    ct1

    Definir Pasta De Evidencias    CT1_Evidencias

    ${email}=    Gerar Email Unico    laura_cli
    ${nome}=     Gerar Nome Unico     Cliente Laura

    Abrir Formulario De Cadastro
    Registrar Evidencia    CT1_01_formulario_de_cadastro
    Preencher Cadastro De Cliente    ${nome}    ${email}    ${SENHA_PADRAO}
    Registrar Evidencia    CT1_02_dados_preenchidos
    Enviar Cadastro
    Confirmar Alerta De Cadastro Com Sucesso
    Verificar Redirecionamento Para Login
    Registrar Evidencia    CT1_03_redirecionou_para_login

    # confirma que o cliente consegue entrar com as credenciais recém-cadastradas
    Fazer Login    ${email}    ${SENHA_PADRAO}
    Verificar Login Realizado
    Wait Until Location Contains    rota=usuario-painel    timeout=10s
    Registrar Evidencia    CT1_04_login_com_novo_cliente

CT2 - Tentar cadastrar cliente com e-mail já existente no sistema
    [Documentation]    Tenta cadastrar um cliente informando um e-mail já existente (joao@email.com).
    ...    Esperado: o sistema impede a gravação, exibe a mensagem de e-mail em uso e mantém o
    ...    usuário na tela de cadastro, sem criar registro duplicado.
    ...    Observação: a mensagem de erro é um alerta nativo do navegador; o texto é validado no log.html.
    ...    Evidências: resultados/CT2_Evidencias

    [Tags]    cadastro    ct2

    Definir Pasta De Evidencias    CT2_Evidencias

    ${nome}=    Gerar Nome Unico    Cliente Duplicado Laura

    Abrir Formulario De Cadastro
    Registrar Evidencia    CT2_01_formulario_de_cadastro
    Preencher Cadastro De Cliente    ${nome}    ${EMAIL_EXISTENTE}    ${SENHA_PADRAO}
    Registrar Evidencia    CT2_02_email_existente_preenchido
    Enviar Cadastro
    Verificar Alerta De Email Duplicado
    Registrar Evidencia    CT2_03_apos_o_alerta
    Verificar Permanencia No Cadastro
    Registrar Evidencia    CT2_04_permaneceu_no_cadastro

CT4 - Tentar realizar login com senha incorreta ou e-mail inexistente
    [Documentation]    Executa dois cenários de login inválido: (1) e-mail válido com senha incorreta e
    ...    (2) e-mail inexistente com qualquer senha. Esperado: em ambos o sistema não autentica,
    ...    permanece na tela de login e apresenta a MESMA mensagem genérica, sem revelar se o e-mail existe.
    ...    Observação: a mensagem é um alerta nativo do navegador; o texto é validado no log.html.
    ...    Evidências: resultados/CT4_Evidencias

    [Tags]    login    ct4

    Definir Pasta De Evidencias    CT4_Evidencias

    # Cenário 1: e-mail válido + senha incorreta
    Fazer Login    ${EMAIL_EXISTENTE}    ${SENHA_ERRADA}
    Alert Should Be Present    ${MSG_LOGIN_INVALIDO}    action=ACCEPT    timeout=10s
    Location Should Contain    rota=login
    Element Should Be Visible    ${LOGIN_EMAIL}
    Registrar Evidencia    CT4_01_senha_incorreta

    # Cenário 2: e-mail inexistente + qualquer senha
    Fazer Login    ${EMAIL_INEXISTENTE}    ${SENHA_PADRAO}
    Alert Should Be Present    ${MSG_LOGIN_INVALIDO}    action=ACCEPT    timeout=10s
    Location Should Contain    rota=login
    Element Should Be Visible    ${LOGIN_EMAIL}
    Registrar Evidencia    CT4_02_email_inexistente

CT6 - Tentar enviar solicitação de fabricante sem informar o endereço
    [Documentation]    Um cliente envia a solicitação "Solicitar ser Maker" deixando o campo
    ...    Endereço da Empresa / Ateliê em branco.
    ...    Resultado esperado pelo plano: o sistema deveria bloquear o envio e exigir a localização.
    ...    Resultado desta automação: FALHA esperada (defeito conhecido): o sistema NÃO exige o
    ...    endereço e aceita a solicitação. O teste registra a falha de propósito e, em seguida,
    ...    confere o comportamento real (mensagem de sucesso exibida mesmo sem endereço).
    ...    Dados: cria um cliente novo a cada execução, para garantir que a solicitação seja aceita.
    ...    Evidências: resultados/CT6_Evidencias

    [Tags]    maker    ct6    defeito_conhecido

    Definir Pasta De Evidencias    CT6_Evidencias

    ${cliente}=    Cadastrar Cliente De Teste    Maker Sem Endereco    laura_maker6
    Fazer Login    ${cliente}[email]    ${cliente}[senha]
    Verificar Login Realizado
    Registrar Evidencia    CT6_01_login_do_cliente

    Abrir Formulario De Solicitacao Maker
    Registrar Evidencia    CT6_02_formulario_de_solicitacao
    Preencher Dados Do Negocio    Impressões Laura 3D    comercial_laura@teste.com    41999990000
    Preencher Impressora E Material
    Registrar Evidencia    CT6_03_dados_sem_endereco
    Enviar Solicitacao Maker

    # Resultado ESPERADO pelo plano (bloqueio): falha de propósito, documentando o defeito.
    Run Keyword And Continue On Failure    Element Should Be Visible    ${SM_FEEDBACK_ERRO}
    ...    msg=Defeito conhecido: o sistema deveria bloquear o envio e exigir o endereço, mas aceitou a solicitação sem localização.

    # Comportamento REAL observado: a solicitação é aceita mesmo sem endereço.
    Verificar Solicitacao Enviada Com Sucesso
    Registrar Evidencia    CT6_04_solicitacao_aceita_sem_endereco

CT7 - Aprovar cadastro de fabricante pelo administrador
    [Documentation]    Fluxo completo: um cliente novo envia a solicitação para ser Maker e, em
    ...    seguida, o administrador aprova o cadastro.
    ...    Esperado: o sistema pede confirmação, aprova o fabricante, exibe a mensagem de sucesso,
    ...    remove a solicitação da lista de pendentes e passa a exibi-la na aba "Fabricantes".
    ...    Observação: os diálogos de confirmação e sucesso são nativos do navegador; os textos
    ...    são validados no log.html.
    ...    Dados: cria um cliente novo e sua solicitação a cada execução.
    ...    Evidências: resultados/CT7_Evidencias

    [Tags]    maker    admin    ct7

    Definir Pasta De Evidencias    CT7_Evidencias

    # 1) cliente novo cria a solicitação (com todos os dados, inclusive endereço)
    ${cliente}=    Cadastrar Cliente De Teste    Maker Aprovar Laura    laura_maker7
    Fazer Login    ${cliente}[email]    ${cliente}[senha]
    Verificar Login Realizado
    Abrir Formulario De Solicitacao Maker
    Preencher Dados Do Negocio    Ateliê Laura 3D    comercial_laura7@teste.com    41999991111    Rua das Impressoras, 45
    Preencher Impressora E Material
    Enviar Solicitacao Maker
    Verificar Solicitacao Enviada Com Sucesso
    Registrar Evidencia    CT7_01_solicitacao_criada

    # 2) admin entra e localiza a solicitação pendente
    Sair Do Sistema
    Fazer Login    ${EMAIL_ADMIN}    ${SENHA_PADRAO}
    Verificar Login Realizado
    Go To    ${URL_ADMIN}
    Acessar Aba De Solicitacoes
    Verificar Solicitacao Pendente Listada    ${cliente}[nome]
    Registrar Evidencia    CT7_02_solicitacao_pendente

    # 3) admin aprova e confirma o resultado
    Aprovar Solicitacao Do Fabricante    ${cliente}[nome]
    Verificar Solicitacao Removida Das Pendentes    ${cliente}[nome]
    Registrar Evidencia    CT7_03_removida_das_pendentes
    Verificar Fabricante Na Aba Fabricantes    ${cliente}[nome]
    Registrar Evidencia    CT7_04_listado_em_fabricantes
