*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${URL_INICIAL}       http://localhost/bruno/Printly/public/
${BROWSER}           chrome
${TIMEOUT}           15s

${FABRICANTE_USER}   maria@email.com
${FABRICANTE_PASS}   123456
${CLIENTE_USER}      joao@email.com
${CLIENTE_PASS}      123456
${NUMERO_PEDIDO}     1
${PAYLOAD_SQL_INJECTION}    ' OR '1'='1
${MAKER_ID_C20}    2

*** Keywords ***
Abrir Navegador Bruno
    ${opcoes}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    ${preferencias}=    Create Dictionary
    ...    credentials_enable_service=${False}
    ...    profile.password_manager_enabled=${False}
    ...    profile.password_manager_leak_detection=${False}
    Call Method    ${opcoes}    add_experimental_option    prefs    ${preferencias}
    Open Browser    ${URL_INICIAL}    ${BROWSER}    options=${opcoes}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Abrir Tela De Login Bruno
    Click Link    xpath=//a[@href='index.php?rota=login']
    Wait Until Element Is Visible    id=email

Tentar Login Com SQL Injection Bruno
    Input Text    id=email    ${PAYLOAD_SQL_INJECTION}
    Input Password    id=senha    ${PAYLOAD_SQL_INJECTION}
    Click Element    id=entrar
    ${mensagem}=    Handle Alert    accept
    Log    Mensagem retornada pelo login: ${mensagem}
    Should Be Equal    ${mensagem}    Usuário não encontrado ou senha incorreta
    Wait Until Element Is Visible    id=email

Logar Como Fabricante Bruno
    Input Text    id=email    ${FABRICANTE_USER}
    Input Password    id=senha    ${FABRICANTE_PASS}
    Click Element    id=entrar
    Wait Until Page Does Not Contain Element    id=email

Abrir Gerenciamento De Pedidos Bruno
    Click Link    xpath=//a[@href='index.php?rota=gerenciar-projetos']
    Wait Until Element Is Visible    id=cardsGerenciar

Abrir Pedido Bruno
    ${pedido}=    Set Variable    xpath=//div[contains(@class,'projeto-card')][.//*[contains(.,'Pedido #${NUMERO_PEDIDO}')]]
    Wait Until Element Is Visible    ${pedido}
    Click Element    xpath=//div[contains(@class,'projeto-card')][.//*[contains(.,'Pedido #${NUMERO_PEDIDO}')]]//button[contains(.,'Ver / Atualizar')]
    Wait Until Element Is Visible    id=mg-novo-status

Alterar Status Do Pedido Para Em Producao Bruno
    ${pedido}=    Set Variable    xpath=//div[contains(@class,'projeto-card')][.//*[contains(.,'Pedido #${NUMERO_PEDIDO}')]]
    Wait Until Element Is Visible    ${pedido}
    ${ja_produzindo}=    Run Keyword And Return Status
    ...    Element Should Contain    ${pedido}    Em Produção
    IF    ${ja_produzindo}
        Return From Keyword
    END
    Abrir Pedido Bruno
    Aguardar Seletor De Status Bruno
    ${pode_produzir}=    Run Keyword And Return Status
    ...    Select From List By Value    id=mg-novo-status    EM_PRODUCAO
    IF    not ${pode_produzir}
        Aguardar Seletor De Status Bruno
        Select From List By Value    id=mg-novo-status    ACEITO
        Click Element    id=btn-salvar-status
        Wait Until Element Contains    id=toast-msg    Status atualizado com sucesso!
        Fechar Modal Do C23 Bruno
        Abrir Pedido Bruno
        Aguardar Seletor De Status Bruno
        Select From List By Value    id=mg-novo-status    EM_PRODUCAO
    END
    Click Element    id=btn-salvar-status
    Wait Until Element Contains    id=toast-msg    Status atualizado com sucesso!
    Fechar Modal Do C23 Bruno

Validar Status No Painel Do Fabricante Bruno
    ${pedido}=    Set Variable    xpath=//div[contains(@class,'projeto-card')][.//*[contains(.,'Pedido #${NUMERO_PEDIDO}')]]
    Wait Until Element Contains    ${pedido}    Em Produção

Sair Do Sistema Bruno
    Click Element    id=sair
    Handle Alert    accept
    Handle Alert    accept
    Wait Until Element Is Visible    id=email

Logar Como Cliente Bruno
    Input Text    id=email    ${CLIENTE_USER}
    Input Password    id=senha    ${CLIENTE_PASS}
    Click Element    id=entrar
    Wait Until Page Does Not Contain Element    id=email

Acessar Meus Pedidos Bruno
    Click Link    xpath=//a[@href='index.php?rota=meus_projetos']
    Wait Until Element Is Visible    id=cardsProjetos

Abrir Formulario De Pedido C20 Bruno
    Go To    ${URL_INICIAL}index.php?rota=realizar-pedido&maker_id=${MAKER_ID_C20}
    Wait Until Element Is Visible    id=formPedido
    Wait Until Element Is Visible    id=nome_projeto
    Wait Until Element Is Enabled    id=btnEnviarPedido

Validar Formulario Incompleto C20 Bruno
    Execute Javascript    return validarFormulario();
    Wait Until Element Contains    id=mensagensFormulario    Corrija os campos obrigatórios
    ${nome_classes}=    Get Element Attribute    id=nome_projeto    class
    ${descricao_classes}=    Get Element Attribute    id=descricao    class
    ${endereco_classes}=    Get Element Attribute    id=endereco    class
    Should Contain    ${nome_classes}    is-invalid
    Should Contain    ${descricao_classes}    is-invalid
    Should Contain    ${endereco_classes}    is-invalid

Abrir Conversa Do Pedido Bruno
    ${projeto}=    Set Variable    xpath=//div[contains(@class,'projeto-card')][.//*[contains(.,'${NUMERO_PEDIDO}')]]
    Wait Until Element Is Visible    ${projeto}
    ${botao_chat}=    Set Variable    xpath=//div[contains(@class,'projeto-card')][.//*[contains(.,'${NUMERO_PEDIDO}')]]//button[contains(@class,'btn-chat')]
    Scroll Element Into View    ${botao_chat}
    Wait Until Element Is Enabled    ${botao_chat}
    Click Element    ${botao_chat}
    Wait Until Element Is Visible    id=modal-chat
    Wait Until Element Is Visible    id=chat-mensagens

Validar Se Pode Abrir Conversa Bruno
    Wait Until Element Is Visible    id=modal-chat
    Wait Until Element Is Visible    id=chat-mensagens
    Wait Until Element Is Visible    id=chat-input
    Wait Until Element Is Visible    id=chat-form

Validar Status No Painel Do Cliente Bruno
    Wait Until Element Is Visible
    ...    xpath=//*[@id='cardsProjetos']//*[@data-status='EM_PRODUCAO']

Aguardar Seletor De Status Bruno
    Wait Until Element Is Visible    id=mg-novo-status
    Wait Until Element Is Enabled    id=mg-novo-status
    Scroll Element Into View    id=mg-novo-status
    Sleep    1s

Abrir Avaliacao Do Pedido Bruno
    ${pedido}=    Set Variable
    ...    xpath=//div[contains(@class,'projeto-card') and @data-status='CONCLUIDO'][.//button[contains(@class,'btn-feedback')]]
    ${botao_avaliar}=    Set Variable
    ...    xpath=//div[contains(@class,'projeto-card') and @data-status='CONCLUIDO'][.//button[contains(@class,'btn-feedback')]]//button[contains(@class,'btn-feedback')]
    Wait Until Element Is Visible    ${pedido}
    Scroll Element Into View    ${botao_avaliar}
    Wait Until Element Is Enabled    ${botao_avaliar}
    Click Element    ${botao_avaliar}
    Wait Until Element Is Visible    id=modalPortfolio
    Wait Until Element Is Visible    id=form-feedback

Avaliar Pedido Bruno
    Abrir Avaliacao Do Pedido Bruno
    ${estrela}=    Set Variable    xpath=//*[@id='rating-input']//*[@data-nota='4']
    Scroll Element Into View    ${estrela}
    Wait Until Element Is Enabled    ${estrela}
    Click Element    ${estrela}
    ${nota}=    Get Value    id=nota-selecionada
    Should Be Equal    ${nota}    4
    Scroll Element Into View    id=comentario-feedback
    Input Text    id=comentario-feedback    Ótima qualidade
    Scroll Element Into View    css=.btn-enviar-feedback
    Wait Until Element Is Enabled    css=.btn-enviar-feedback
    Click Element    css=.btn-enviar-feedback
    Wait Until Page Contains    Ótima qualidade
    Click Element    id=fecharModal
    Wait Until Element Is Not Visible    id=modalPortfolio

Aguardar Modal Fechar Bruno
    Wait Until Keyword Succeeds    ${TIMEOUT}    250ms    Verificar Modal Fechado Bruno

Fechar Modal Do C23 Bruno
    ${aberto}=    Run Keyword And Return Status
    ...    Element Should Be Visible    id=modalGerenciar
    IF    ${aberto}
        Click Element    xpath=//*[@id='modalGerenciar']//button[contains(@class,'btn-close')]
    END
    Wait Until Keyword Succeeds    ${TIMEOUT}    250ms    Verificar Modal Fechado Bruno

Verificar Modal Fechado Bruno
    ${classes}=    Get Element Attribute    id=modalGerenciar    class
    Should Not Contain    ${classes}    show

Fechar Navegador Bruno
    Close All Browsers
