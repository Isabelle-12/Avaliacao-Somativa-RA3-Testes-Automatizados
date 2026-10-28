*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           Collections

*** Variables ***
${BROWSER}                  Chrome

# ----- URLs do Printly -----
${URL_BASE}                 http://localhost/Printly/Printly-main/public/index.php
${URL_LOGIN}                ${URL_BASE}?rota=login
${URL_MEUS_PROJETOS}        ${URL_BASE}?rota=meus_projetos
${URL_FABRICANTES}          ${URL_BASE}?rota=listagem-maker

# ----- Usuário de teste (dados fictícios; senha padrão 123456) -----
${EMAIL_CLIENTE}            joao@email.com
${SENHA_CLIENTE}            123456

# ----- Login (rota=login) -----
${LOGIN_EMAIL}              id:email
${LOGIN_SENHA}              id:senha
${LOGIN_BOTAO}              id:entrar

# ----- Menu (sub-navbar do cliente) -----
${LINK_MEUS_PROJETOS}       css:a.nav-link[href*='meus_projetos']
${LINK_FABRICANTES}         css:a.nav-link[href*='listagem-maker']

# ----- Meus Projetos (meus_projetos.html / meus_projetos.js) -----
${LISTA_PROJETOS}           id:cardsProjetos
${CARD_PROJETO}             css:#cardsProjetos .projeto-card
${MODAL_DETALHES}           id:modalProjeto
${CONTEUDO_DETALHES}        id:conteudoModalProjeto
${ITEM_HISTORICO}           css:#conteudoModalProjeto .timeline-real .tr-item

# ----- Chat (chat.js) -----
${MODAL_CHAT}               id:modal-chat
${CHAT_MENSAGENS}           id:chat-mensagens
${CHAT_INPUT}               id:chat-input
${CHAT_BOTAO_ENVIAR}        css:#chat-form .chat-btn-enviar
${CHAT_MINHAS_MSGS}         css:#chat-mensagens .chat-msg.eu

# ----- Fabricantes / filtro de localização (portfolio_makers.html) -----
${GRID_FABRICANTES}         id:grid-makers
${CARD_FABRICANTE}          css:#grid-makers .maker-card
${FILTRO_CEP}               id:filtro-cep
${FILTRO_CIDADE}            id:filtro-cidade
${FILTRO_ESTADO}            id:filtro-estado
${FILTRO_BOTAO_BUSCAR}      css:button.btn-filtro-buscar
${FILTRO_MENSAGEM}          id:mensagem-filtro

# ----- Dados dos casos de teste (plano do RA2) -----
# CT25
${PROJETO_CT25}             Carrinho de Brinquedo
# CT27
${PROJETO_CT27}             Porta canetas
${DATA_ENVIO_CT27}          27/10/2026
${STATUS_CT27}              Concluído
# CT29
${CIDADE_CT29}              Curitiba
${ESTADO_CT29}              PR
# CT30
${CIDADE_CT30}              Campo Largo
${ESTADO_CT30}              PR
${MSG_SEM_FABRICANTE}       Nenhum fabricante encontrado nesta região.
# CT31
${PROJETO_CT31}             Caneca
${MENSAGEM_CT31}            Oi, como está o andamento do projeto?


*** Keywords ***
# ----- Utilitário de clique -----
Clicar Via JS
    [Documentation]    Rola o elemento até o centro da tela e clica via JavaScript.
    ...    Evita o erro "element click intercepted" em botões que ficam atrás de outros elementos.
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    ${el}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].scrollIntoView({block:'center'}); arguments[0].click();    ARGUMENTS    ${el}

Rolar Ate O Elemento
    [Arguments]    ${locator}
    ${el}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].scrollIntoView({block:'center'});    ARGUMENTS    ${el}
    Sleep    500ms

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

# ----- Login -----
Fazer Login
    [Arguments]    ${email}    ${senha}
    Go To    ${URL_LOGIN}
    Wait Until Element Is Visible    ${LOGIN_EMAIL}    timeout=10s
    Input Text       ${LOGIN_EMAIL}    ${email}
    Input Text       ${LOGIN_SENHA}    ${senha}
    Click Element    ${LOGIN_BOTAO}

Verificar Login Realizado
    Wait Until Element Is Not Visible    ${LOGIN_EMAIL}    timeout=10s
    Wait Until Location Contains    rota=usuario-painel    timeout=10s

# ----- Meus Projetos -----
Acessar Meus Projetos
    Wait Until Element Is Visible    ${LINK_MEUS_PROJETOS}    timeout=10s
    Click Element    ${LINK_MEUS_PROJETOS}
    Wait Until Location Contains    rota=meus_projetos    timeout=10s
    Wait Until Page Contains Element    ${CARD_PROJETO}    timeout=10s

Montar Locator Do Card
    [Documentation]    Retorna o xpath do (primeiro) card de projeto com o nome informado.
    [Arguments]    ${nome}
    RETURN    xpath:(//div[contains(@class,'projeto-card')][.//h5[contains(@class,'card-titulo')][normalize-space()='${nome}']])[1]

Localizar Card Do Projeto
    [Arguments]    ${nome}
    ${card}=    Montar Locator Do Card    ${nome}
    Wait Until Page Contains Element    ${card}    timeout=10s
    ...    error=O projeto "${nome}" não foi encontrado em "Meus Projetos" do cliente.
    Rolar Ate O Elemento    ${card}
    RETURN    ${card}

# ----- CT25: detalhes e histórico -----
Abrir Detalhes Do Projeto
    [Arguments]    ${nome}
    ${card}=    Localizar Card Do Projeto    ${nome}
    Clicar Via JS    ${card}//button[contains(@class,'btn-ver')]
    Wait Until Element Is Visible    ${MODAL_DETALHES}    timeout=10s
    Wait Until Page Contains Element    xpath://div[@id='conteudoModalProjeto']//h6[contains(.,'Histórico de Atualizações')]    timeout=10s
    Sleep    1s

Rolar Ate O Historico
    ${titulo}=    Set Variable    xpath://div[@id='conteudoModalProjeto']//h6[contains(normalize-space(.),'Histórico de Atualizações')]
    Rolar Ate O Elemento    ${titulo}

Verificar Historico Em Ordem Cronologica
    [Documentation]    Lê cada etapa do "Histórico de Atualizações" e confere que todas têm
    ...    descrição (nome da etapa), data e hora, e que estão em ordem cronológica (mais antiga primeiro).
    ${qtd}=    Get Element Count    ${ITEM_HISTORICO}
    Should Be True    ${qtd} > 0    msg=O projeto não possui etapas no "Histórico de Atualizações".
    ${datas}=    Create List
    FOR    ${i}    IN RANGE    1    ${qtd} + 1
        ${item}=         Set Variable    css:#conteudoModalProjeto .timeline-real .tr-item:nth-child(${i})
        ${descricao}=    Get Text    ${item} .tr-label
        ${data_hora}=    Get Text    ${item} .tr-data
        Should Not Be Empty    ${descricao}    msg=A etapa ${i} do histórico está sem descrição.
        Should Match Regexp    ${data_hora}    \\d{2}/\\d{2}/\\d{4},?\\s+\\d{2}:\\d{2}
        ...    msg=A etapa ${i} ("${descricao}") não exibe data e hora no formato esperado: "${data_hora}".
        Log    Etapa ${i}: ${descricao} - ${data_hora}
        ${dt}=    Evaluate    datetime.datetime.strptime(' '.join(re.search(r'(\\d{2}/\\d{2}/\\d{4})\\D+(\\d{2}:\\d{2})', $data_hora).groups()), '%d/%m/%Y %H:%M')    modules=datetime,re
        Append To List    ${datas}    ${dt}
    END
    ${ordenado}=    Evaluate    $datas == sorted($datas)
    Should Be True    ${ordenado}    msg=O histórico não está em ordem cronológica: ${datas}

# ----- CT27: listagem de projetos -----
Verificar Dados Do Card Do Projeto
    [Arguments]    ${card}    ${nome}    ${data_envio}    ${status}
    Element Text Should Be    ${card}//h5[contains(@class,'card-titulo')]    ${nome}
    Element Should Contain    ${card}//div[contains(@class,'info-item')][contains(.,'Enviado')]    ${data_envio}
    ...    message=A data de envio do projeto "${nome}" deveria ser ${data_envio}.
    Element Should Contain    ${card}//span[contains(@class,'badge-status')]    ${status}
    ...    message=O status do projeto "${nome}" deveria ser "${status}".

Verificar Miniatura Do Projeto
    [Documentation]    A miniatura é uma <img> dentro de ".card-capa". Quando o projeto não tem imagem,
    ...    o Printly não cria a <img> e mostra apenas o ícone de pasta (classe "sem-capa").
    [Arguments]    ${card}    ${nome}
    ${tem_img}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${card}//div[contains(@class,'card-capa')]//img
    Should Be True    ${tem_img}
    ...    msg=Defeito: o projeto "${nome}" não exibe miniatura na listagem de "Meus Projetos" (aparece apenas o ícone de pasta).
    ${el}=    Get WebElement    ${card}//div[contains(@class,'card-capa')]//img
    ${carregou}=    Execute Javascript    return arguments[0].complete && arguments[0].naturalWidth > 0;    ARGUMENTS    ${el}
    Should Be True    ${carregou}    msg=A miniatura do projeto "${nome}" não carregou.

# ----- CT29 / CT30: filtro de localização -----
Acessar Lista De Fabricantes
    Wait Until Element Is Visible    ${LINK_FABRICANTES}    timeout=10s
    Click Element    ${LINK_FABRICANTES}
    Wait Until Location Contains    rota=listagem-maker    timeout=10s
    Wait Until Element Is Visible    ${FILTRO_CIDADE}    timeout=10s
    Wait Until Page Contains Element    ${CARD_FABRICANTE}    timeout=10s

Preencher Filtro De Localizacao
    [Arguments]    ${cidade}    ${estado}
    Clear Element Text    ${FILTRO_CEP}
    Input Text    ${FILTRO_CIDADE}    ${cidade}
    Input Text    ${FILTRO_ESTADO}    ${estado}

Buscar Fabricantes Por Localizacao
    Clicar Via JS    ${FILTRO_BOTAO_BUSCAR}
    # a busca é feita via fetch: espera a mensagem de retorno do filtro aparecer
    Wait Until Element Is Visible    ${FILTRO_MENSAGEM}    timeout=10s
    Wait Until Keyword Succeeds    10s    500ms    Element Should Not Contain    ${GRID_FABRICANTES}    Buscando fabricantes
    Sleep    500ms

Obter Localizacoes Dos Fabricantes Exibidos
    ${locais}=    Execute Javascript
    ...    return Array.from(document.querySelectorAll('#grid-makers .maker-card .maker-local')).map(e => e.innerText.trim());
    RETURN    ${locais}

Verificar Fabricantes Somente Da Regiao
    [Arguments]    ${cidade}    ${estado}
    ${locais}=    Obter Localizacoes Dos Fabricantes Exibidos
    ${qtd}=    Get Length    ${locais}
    Should Be True    ${qtd} > 0    msg=Nenhum fabricante foi exibido para ${cidade}/${estado}.
    Log    Fabricantes exibidos (${qtd}): ${locais}
    FOR    ${local}    IN    @{locais}
        Should Contain    ${local}    ${cidade}    msg=Fabricante fora da cidade filtrada: "${local}".
        Should Contain    ${local}    ${estado}    msg=Fabricante fora do estado filtrado: "${local}".
    END
    Element Should Contain    ${FILTRO_MENSAGEM}    fabricante(s) encontrado(s)

Verificar Mensagem De Nenhum Fabricante
    Element Should Contain    ${FILTRO_MENSAGEM}    ${MSG_SEM_FABRICANTE}
    Element Should Contain    ${GRID_FABRICANTES}    ${MSG_SEM_FABRICANTE}
    ${qtd}=    Get Element Count    ${CARD_FABRICANTE}
    Should Be Equal As Integers    ${qtd}    0    msg=Foram exibidos fabricantes em uma região sem cadastro.

# ----- CT31: chat -----
Abrir Chat Do Projeto
    [Arguments]    ${nome}
    ${card}=    Localizar Card Do Projeto    ${nome}
    Clicar Via JS    ${card}//button[contains(@class,'btn-chat')]
    Wait Until Element Is Visible    ${MODAL_CHAT}    timeout=10s
    Wait Until Element Is Visible    ${CHAT_INPUT}    timeout=10s
    # espera o carregamento inicial das mensagens terminar
    Wait Until Keyword Succeeds    10s    500ms    Element Should Not Contain    ${CHAT_MENSAGENS}    Carregando mensagens
    Element Should Contain    id:chat-subtitulo    ${nome}

Contar Minhas Mensagens No Chat
    ${qtd}=    Get Element Count    ${CHAT_MINHAS_MSGS}
    RETURN    ${qtd}

Enviar Mensagem No Chat
    [Arguments]    ${mensagem}
    Input Text    ${CHAT_INPUT}    ${mensagem}
    Click Element    ${CHAT_BOTAO_ENVIAR}

Verificar Mensagem Enviada Com Horario
    [Arguments]    ${mensagem}    ${qtd_antes}
    ${esperado}=    Evaluate    ${qtd_antes} + 1
    # a mensagem deve aparecer logo após o envio (sem recarregar a página)
    Wait Until Keyword Succeeds    5s    250ms
    ...    Verificar Quantidade De Mensagens    ${esperado}
    ${ultima}=    Set Variable    css:#chat-mensagens .chat-msg.eu:last-child .chat-msg-balao
    Element Should Contain    ${ultima}    ${mensagem}
    ${hora}=    Get Text    css:#chat-mensagens .chat-msg.eu:last-child .chat-msg-hora
    Should Match Regexp    ${hora}    \\d{2}:\\d{2}    msg=A mensagem enviada não exibe o horário do envio.
    ${agora}=    Get Time    hour:min
    Log    Horário exibido na mensagem: ${hora} | Horário do computador no envio: ${agora}[0]:${agora}[1]

Verificar Quantidade De Mensagens
    [Arguments]    ${esperado}
    ${qtd}=    Contar Minhas Mensagens No Chat
    Should Be Equal As Integers    ${qtd}    ${esperado}