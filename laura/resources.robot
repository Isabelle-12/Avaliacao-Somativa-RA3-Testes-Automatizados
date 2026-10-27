*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem
Library           String

*** Variables ***
${BROWSER}                  Chrome

# ----- URLs do Printly -----
${URL_BASE}                 http://localhost/Printly/public/index.php
${URL_LOGIN}                ${URL_BASE}?rota=login
${URL_CADASTRO}             ${URL_BASE}?rota=cadastro
${URL_SOLICITAR_MAKER}      ${URL_BASE}?rota=solicitar-maker
${URL_ADMIN}                ${URL_BASE}?rota=admin-usuarios
${URL_PAINEL_CLIENTE}       ${URL_BASE}?rota=usuario-painel
${URL_LOGOUT}               http://localhost/Printly/config/logout.php

# ----- Usuários de teste (dados fictícios; senha padrão 123456) -----
${EMAIL_EXISTENTE}          joao@email.com
${EMAIL_ADMIN}              ana.admin@email.com
${SENHA_PADRAO}             123456

# ----- Cadastro de cliente (rota=cadastro) -----
${CAD_NOME}                 id:nome
${CAD_EMAIL}                id:email
${CAD_SENHA}                id:senha
${CAD_CONFIRMAR}            id:confirmar_senha
${CAD_TELEFONE}             id:telefone
${CAD_DOCUMENTO}            id:documento
${CAD_CEP}                  id:cep
${CAD_CIDADE}               id:cidade
${CAD_ESTADO}               id:estado
${CAD_ENDERECO}             id:endereco
${CAD_TERMOS}               id:termos_uso
${CAD_BOTAO}                id:enviar

# dados válidos para o formulário (telefone, documento e CEP só aceitam números)
${TELEFONE_VALIDO}          41999990000
${DOCUMENTO_VALIDO}         12345678901
${CEP_VALIDO}               80000000
${CIDADE_PADRAO}            Curitiba
${ESTADO_PADRAO}            PR
${ENDERECO_PADRAO}          Rua das Flores, 123 - Centro

# mensagens esperadas (vêm de cadastro.php e são exibidas via alert nativo)
${MSG_CADASTRO_OK}          Cadastro realizado com sucesso!
${MSG_EMAIL_DUPLICADO}      Erro: Este e-mail já está em uso.

# ----- Login (rota=login) -----
${LOGIN_EMAIL}              id:email
${LOGIN_SENHA}              id:senha
${LOGIN_BOTAO}              id:entrar
${MSG_LOGIN_INVALIDO}       Usuário não encontrado ou senha incorreta
${SENHA_ERRADA}             senha_incorreta_123
${EMAIL_INEXISTENTE}        nao_existe_laura@teste.com

# ----- Solicitar ser Maker (rota=solicitar-maker) -----
${SM_NOME_EMPRESA}          id:nome_empresa
${SM_EMAIL_COMERCIAL}       id:email_comercial
${SM_CNPJ}                  id:cnpj
${SM_TELEFONE}              id:telefone_comercial
${SM_ENDERECO}              id:endereco_empresa
${SM_IMP_MODELO}            css:.linha-impressora .imp-modelo
${SM_IMP_VOLUME}            css:.linha-impressora .imp-volume
${SM_IMP_QTD}               css:.linha-impressora .imp-quantidade
${SM_IMP_FDM}               xpath://div[contains(@class,'linha-impressora')]//input[@type='checkbox' and @value='FDM']
${SM_MAT_TIPO}              css:.linha-material .mat-tipo
${SM_MAT_PRECO}             css:.linha-material .mat-preco
${SM_BOTAO_ENVIAR}          xpath://button[contains(@onclick,'enviarSolicitacao')]
${SM_FEEDBACK}              id:msg-feedback
${SM_FEEDBACK_OK}           css:#msg-feedback.alert-success
${SM_FEEDBACK_ERRO}         css:#msg-feedback.alert-danger
${MATERIAL_MAKER}           PLA
${PRECO_MATERIAL}           0.15

# ----- Painel do Admin (rota=admin-usuarios) -----
${ADMIN_TAB_SOLICITACOES}   xpath://button[@data-bs-target='#solicitacoes']
${ADMIN_TAB_FABRICANTES}    xpath://button[@data-bs-target='#fabricantes']
${ADMIN_LISTA_SOLIC}        id:listaSolicitacoes
${ADMIN_LISTA_FAB}          id:listaFabricantes
${MSG_APROVADO}             Fabricante APROVADO com sucesso!


*** Keywords ***
# ----- Utilitário de clique -----
Clicar Via JS
    [Documentation]    Rola o elemento até o centro da tela e clica via JavaScript.
    ...    Evita o erro "element click intercepted" em botões/checkbox no rodapé da página.
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    ${el}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].scrollIntoView({block:'center'}); arguments[0].click();    ARGUMENTS    ${el}

# ----- Navegador / evidências -----
Abrir Navegador
    Open Browser    ${URL_LOGIN}    ${BROWSER}
    ...    options=add_experimental_option("prefs", {"credentials_enable_service": False, "profile.password_manager_enabled": False, "profile.password_manager_leak_detection": False})
    Maximize Browser Window
    Set Screenshot Directory    ${OUTPUT DIR}

Fechar Navegador
    Run Keyword And Ignore Error    Capture Page Screenshot    tela_final_{index}.png
    Close Browser

Definir Pasta De Evidencias
    [Arguments]    ${pasta}
    ${caminho}=    Set Variable    ${OUTPUT DIR}${/}${pasta}
    Create Directory    ${caminho}
    Set Screenshot Directory    ${caminho}

Registrar Evidencia
    [Arguments]    ${nome}
    Capture Page Screenshot    ${nome}.png

# ----- Dados dinâmicos -----
Gerar Email Unico
    [Arguments]    ${prefixo}
    ${ts}=       Get Time    epoch
    ${rnd}=      Evaluate    random.randint(100, 999)    modules=random
    RETURN       ${prefixo}_${ts}${rnd}@teste.com

Gerar Nome Unico
    [Arguments]    ${prefixo}
    ${ts}=       Get Time    epoch
    RETURN       ${prefixo} ${ts}

# ----- Login / Logout -----
Fazer Login
    [Arguments]    ${email}    ${senha}
    Go To    ${URL_LOGIN}
    Wait Until Element Is Visible    ${LOGIN_EMAIL}    timeout=10s
    Input Text       ${LOGIN_EMAIL}    ${email}
    Input Text       ${LOGIN_SENHA}    ${senha}
    Click Element    ${LOGIN_BOTAO}

Verificar Login Realizado
    Wait Until Element Is Not Visible    ${LOGIN_EMAIL}    timeout=10s

Sair Do Sistema
    Go To    ${URL_LOGOUT}
    Delete All Cookies

# ----- Cadastro de cliente -----
Abrir Formulario De Cadastro
    Go To    ${URL_CADASTRO}
    Wait Until Element Is Visible    ${CAD_NOME}    timeout=10s

Preencher Cadastro De Cliente
    [Arguments]    ${nome}    ${email}    ${senha}
    Input Text       ${CAD_NOME}         ${nome}
    Input Text       ${CAD_EMAIL}        ${email}
    Input Text       ${CAD_SENHA}        ${senha}
    Input Text       ${CAD_CONFIRMAR}    ${senha}
    Input Text       ${CAD_TELEFONE}     ${TELEFONE_VALIDO}
    Input Text       ${CAD_DOCUMENTO}    ${DOCUMENTO_VALIDO}
    Input Text       ${CAD_CEP}          ${CEP_VALIDO}
    Input Text       ${CAD_CIDADE}       ${CIDADE_PADRAO}
    Input Text       ${CAD_ESTADO}       ${ESTADO_PADRAO}
    Input Text       ${CAD_ENDERECO}     ${ENDERECO_PADRAO}
    Marcar Termos De Uso

Marcar Termos De Uso
    [Documentation]    Marca o aceite dos termos de forma determinística (checked=true via JS).
    ...    O cadastro.js lê apenas o estado .checked no envio, sem depender do evento de clique.
    Wait Until Element Is Visible    ${CAD_TERMOS}    timeout=10s
    Execute Javascript    document.getElementById('termos_uso').checked = true;
    Checkbox Should Be Selected    ${CAD_TERMOS}

Enviar Cadastro
    Clicar Via JS    ${CAD_BOTAO}

Confirmar Alerta De Cadastro Com Sucesso
    Alert Should Be Present    ${MSG_CADASTRO_OK}    action=ACCEPT    timeout=10s

Verificar Alerta De Email Duplicado
    Alert Should Be Present    ${MSG_EMAIL_DUPLICADO}    action=ACCEPT    timeout=10s

Verificar Redirecionamento Para Login
    Wait Until Location Contains    rota=login    timeout=10s

Verificar Permanencia No Cadastro
    Location Should Contain    rota=cadastro
    Element Should Be Visible    ${CAD_NOME}

Cadastrar Cliente De Teste
    [Documentation]    Cria um cliente novo (e-mail e nome únicos) e retorna um dicionário
    ...    com nome, email e senha, para ser reutilizado em outros fluxos.
    [Arguments]    ${prefixo_nome}=Cliente Laura    ${prefixo_email}=laura_cli
    ${email}=    Gerar Email Unico    ${prefixo_email}
    ${nome}=     Gerar Nome Unico     ${prefixo_nome}
    Abrir Formulario De Cadastro
    Preencher Cadastro De Cliente    ${nome}    ${email}    ${SENHA_PADRAO}
    Enviar Cadastro
    Confirmar Alerta De Cadastro Com Sucesso
    Verificar Redirecionamento Para Login
    &{cliente}=    Create Dictionary    nome=${nome}    email=${email}    senha=${SENHA_PADRAO}
    RETURN    &{cliente}

# ----- Solicitar ser Maker -----
Abrir Formulario De Solicitacao Maker
    Go To    ${URL_SOLICITAR_MAKER}
    Wait Until Element Is Visible    ${SM_NOME_EMPRESA}    timeout=10s

Preencher Dados Do Negocio
    [Arguments]    ${nome_empresa}    ${email_comercial}    ${telefone}    ${endereco}=${EMPTY}
    Input Text    ${SM_NOME_EMPRESA}     ${nome_empresa}
    Input Text    ${SM_EMAIL_COMERCIAL}  ${email_comercial}
    Input Text    ${SM_TELEFONE}         ${telefone}
    Run Keyword If    '${endereco}' != '${EMPTY}'    Input Text    ${SM_ENDERECO}    ${endereco}

Preencher Impressora E Material
    [Documentation]    Preenche a impressora (marcando FDM) e seleciona um material compatível.
    ...    O material só aparece depois de marcar o tipo de impressora.
    Input Text       ${SM_IMP_MODELO}    Ender 3 S1
    Input Text       ${SM_IMP_VOLUME}    15625
    Input Text       ${SM_IMP_QTD}       1
    Clicar Via JS    ${SM_IMP_FDM}
    Wait Until Page Contains Element    css:.linha-material .mat-tipo option[value='${MATERIAL_MAKER}']    timeout=10s
    Select From List By Value    ${SM_MAT_TIPO}    ${MATERIAL_MAKER}
    Input Text       ${SM_MAT_PRECO}     ${PRECO_MATERIAL}

Enviar Solicitacao Maker
    Clicar Via JS    ${SM_BOTAO_ENVIAR}

Verificar Solicitacao Enviada Com Sucesso
    Wait Until Element Is Visible    ${SM_FEEDBACK_OK}    timeout=10s

# ----- Painel do Admin -----
Acessar Aba De Solicitacoes
    Wait Until Element Is Visible    ${ADMIN_TAB_SOLICITACOES}    timeout=10s
    Click Element    ${ADMIN_TAB_SOLICITACOES}
    Wait Until Element Is Visible    ${ADMIN_LISTA_SOLIC}    timeout=10s

Verificar Solicitacao Pendente Listada
    [Arguments]    ${nome}
    Wait Until Page Contains Element
    ...    xpath://tbody[@id='listaSolicitacoes']/tr[td[1][normalize-space()='${nome}']]    timeout=10s

Aprovar Solicitacao Do Fabricante
    [Arguments]    ${nome}
    ${botao}=    Set Variable
    ...    xpath://tbody[@id='listaSolicitacoes']/tr[td[1][normalize-space()='${nome}']]//button[contains(@class,'btn-success')]
    Wait Until Element Is Visible    ${botao}    timeout=10s
    # rola até o centro via JS (evita interceptação), mas o clique é nativo porque o
    # onclick abre um confirm(): um JS click aqui travaria aguardando o diálogo
    ${el}=    Get WebElement    ${botao}
    Execute Javascript    arguments[0].scrollIntoView({block:'center'});    ARGUMENTS    ${el}
    Click Element    ${botao}
    # 1º diálogo nativo: confirmação da ação
    Handle Alert    action=ACCEPT    timeout=10s
    # 2º diálogo nativo: mensagem de sucesso
    Alert Should Be Present    ${MSG_APROVADO}    action=ACCEPT    timeout=10s

Verificar Solicitacao Removida Das Pendentes
    [Arguments]    ${nome}
    Wait Until Page Does Not Contain Element
    ...    xpath://tbody[@id='listaSolicitacoes']/tr[td[1][normalize-space()='${nome}']]    timeout=10s

Verificar Fabricante Na Aba Fabricantes
    [Arguments]    ${nome}
    Wait Until Element Is Visible    ${ADMIN_TAB_FABRICANTES}    timeout=10s
    Click Element    ${ADMIN_TAB_FABRICANTES}
    Wait Until Element Is Visible    ${ADMIN_LISTA_FAB}    timeout=10s
    Wait Until Page Contains Element
    ...    xpath://tbody[@id='listaFabricantes']/tr[td[2][normalize-space()='${nome}']]    timeout=10s
