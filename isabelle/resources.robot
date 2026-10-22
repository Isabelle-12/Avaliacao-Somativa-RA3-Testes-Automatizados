*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem

*** Variables ***
${BROWSER}          Chrome
${URL}              http://localhost/Printly/public/index.php?rota=login


${EMAIL_CLIENTE}    joao@email.com
${SENHA_CLIENTE}    123456
${EMAIL_MAKER}      maria@email.com
${SENHA_MAKER}      123456
${EMAIL_CARLOS}             carlos@email.com
${SENHA_CARLOS}             123456


${CAMPO_EMAIL}      id:email
${CAMPO_SENHA}      id:senha
${BOTAO_ENTRAR}     css:.btn-primary-custom


${LINK_PERFIL}               css:a.nav-link[href*='perfil-fabricante']
${BOTAO_ADD_MATERIAL}        css:button[onclick='abrirModalMaterial()']
${SELECT_MATERIAL}           id:modalMatTipo
${CAMPO_PRECO_MATERIAL}      id:modalMatPreco
${BOTAO_SALVAR_MATERIAL}     id:btnSalvarMaterial



${MATERIAL_TESTE}           PETG
${PRECO_TESTE}              0.19
${PRECO_EXIBIDO}            0,19

${LISTA_MATERIAIS}          id:portfolioMateriais


${PRECO_INVALIDO}               0
${MENSAGEM_PRECO_INVALIDO}      Informe um preço por grama válido.



${LINK_FABRICANTES}         css:a.nav-link[href*='listagem-maker']
${NOME_FABRICANTE}          CaCa 3D
${BOTAO_VER_PORTFOLIO}      xpath://div[contains(@class,'maker-card')][.//h3[normalize-space()='${NOME_FABRICANTE}']]//button[contains(@class,'btn-ver-perfil')]
${BOTAO_REALIZAR_PEDIDO}    css:#conteudoPortfolio a[href*='realizar-pedido']
${FORMULARIO_PEDIDO}        id:formPedido


${CAMPO_NOME_PROJETO}       id:nome_projeto
${CAMPO_DESCRICAO}          id:descricao
${CAMPO_ENDERECO}           id:endereco
${BOTAO_ADD_PARTE}          id:btnAdicionarParte
${PARTE_NOME}               css:#containerPartes .parte-card .nome-parte
${PARTE_MATERIAL}           css:#containerPartes .parte-card .material-parte
${PARTE_MATERIAL_OPCAO}     css:#containerPartes .parte-card .material-parte option:nth-child(2)
${PARTE_DESCRICAO}          css:#containerPartes .parte-card .descricao-parte
${PARTE_COR}                css:#containerPartes .parte-card .cor-parte
${CHECK_CONFIRMACAO}        id:confirmacaoPedido
${BOTAO_ENVIAR_PEDIDO}      id:btnEnviarPedido
${URL_MEUS_PROJETOS}        http://localhost/Printly/public/index.php?rota=meus_projetos


${NOME_PROJETO}             Star Wand 3D – Varinha Estelar Retrátil
${DESCRICAO_PROJETO}        Varinha estelar retrátil personalizada (pedido gerado por teste automatizado).
${PRAZO_PEDIDO}             2026-06-16
${ENDERECO_PEDIDO}          Rua das Flores, 123, Centro, Curitiba, PR - 80000-000
${PARTE_NOME_TESTE}         Corpo
${PARTE_DESCRICAO_TESTE}    Corpo principal da varinha
${PARTE_COR_TESTE}          Rosa



${BOTAO_ANALISAR_PEDIDO}    xpath:(//div[contains(@class,'card-body')][.//h6[contains(.,'${NOME_PROJETO}')]][contains(normalize-space(.),'João Silva')][.//span[contains(@class,'badge')][normalize-space()='Pendente']]//button[contains(normalize-space(.),'Analisar Pedido')])[1]
${CAMPO_VALOR_FINAL}        id:modal-input-valor
${CAMPO_PRAZO_PRODUCAO}     id:modal-input-prazo
${BOTAO_ACEITAR_PEDIDO}     css:#botoes-acao-modal button[onclick='confirmarAceite()']


${VALOR_FINAL}              1000
${PRAZO_PRODUCAO}           16

${SINO}    id:btn-sino


*** Keywords ***
Abrir Navegador
    Open Browser    ${URL}    ${BROWSER}
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

Fazer Login
    [Arguments]    ${email}    ${senha}
    Go To    url=${URL}
    Input Text      ${CAMPO_EMAIL}    ${email}
    Input Text      ${CAMPO_SENHA}    ${senha}
    Click Element   ${BOTAO_ENTRAR}

Verificar Login Realizado
    Wait Until Element Is Not Visible    ${CAMPO_EMAIL}    timeout=10s

Acessar Perfil Do Fabricante
    ${qtd}=    Get Element Count    ${LINK_PERFIL}
    Log To Console    Links de perfil encontrados: ${qtd}
    Wait Until Element Is Visible    ${LINK_PERFIL}    timeout=10s
    Scroll Element Into View    ${LINK_PERFIL}
    Click Element    ${LINK_PERFIL}
    Wait Until Page Contains Element    ${BOTAO_ADD_MATERIAL}    timeout=10s

Abrir Formulario De Material
    Wait Until Element Is Visible    ${BOTAO_ADD_MATERIAL}    timeout=10s
    Execute Javascript    document.querySelector("button[onclick='abrirModalMaterial()']").scrollIntoView({block: 'center'});
    Sleep    1s
    Click Element    ${BOTAO_ADD_MATERIAL}
    Wait Until Element Is Visible    ${SELECT_MATERIAL}    timeout=10s

Preencher Material
    [Arguments]    ${material}    ${preco}
    Wait Until Page Contains Element    css:#modalMatTipo option[value='${material}']    timeout=10s
    Select From List By Value    ${SELECT_MATERIAL}    ${material}
    Input Text    ${CAMPO_PRECO_MATERIAL}    ${preco}

Salvar Material
    Click Element    ${BOTAO_SALVAR_MATERIAL}

Contar Materiais
    [Arguments]    ${nome}    ${preco}
    ${qtd}=    Get Element Count
    ...    xpath://div[@id='portfolioMateriais']//div[contains(@class,'portfolio-item')][.//strong[normalize-space()='${nome}']][.//small[contains(.,'${preco}')]]
    RETURN    ${qtd}

Verificar Quantidade De Materiais
    [Arguments]    ${nome}    ${preco}    ${esperado}
    ${qtd}=    Contar Materiais    ${nome}    ${preco}
    Should Be Equal As Integers    ${qtd}    ${esperado}

Contar Todos Os Materiais
    ${qtd}=    Get Element Count    css:#portfolioMateriais .portfolio-item
    RETURN    ${qtd}

Verificar Alerta De Preco Invalido
    Alert Should Be Present    ${MENSAGEM_PRECO_INVALIDO}    action=ACCEPT    timeout=5s

Acessar Lista De Fabricantes
    Wait Until Element Is Visible    ${LINK_FABRICANTES}    timeout=10s
    Click Element    ${LINK_FABRICANTES}
    Wait Until Page Contains Element    css:#grid-makers .maker-card    timeout=10s

Abrir Portfolio Do Fabricante
    Wait Until Element Is Visible    ${BOTAO_VER_PORTFOLIO}    timeout=10s
    Scroll Element Into View    ${BOTAO_VER_PORTFOLIO}
    Click Element    ${BOTAO_VER_PORTFOLIO}
    Wait Until Page Contains Element    ${BOTAO_REALIZAR_PEDIDO}    timeout=10s

Abrir Formulario De Pedido
    Execute Javascript    document.querySelector("#conteudoPortfolio a[href*='realizar-pedido']").scrollIntoView({block: 'center'});
    Sleep    1s
    Click Element    ${BOTAO_REALIZAR_PEDIDO}
    Wait Until Element Is Visible    ${FORMULARIO_PEDIDO}    timeout=10s


Preencher Dados Do Pedido
    [Arguments]    ${nome}    ${descricao}    ${prazo}    ${endereco}
    Input Text    ${CAMPO_NOME_PROJETO}    ${nome}
    Input Text    ${CAMPO_DESCRICAO}    ${descricao}
    Definir Prazo    ${prazo}
    Input Text    ${CAMPO_ENDERECO}    ${endereco}

Definir Prazo
    [Arguments]    ${data_iso}
    Execute Javascript    var p = document.getElementById('prazo'); p.value = '${data_iso}'; p.dispatchEvent(new Event('input', {bubbles: true})); p.dispatchEvent(new Event('change', {bubbles: true}));

Adicionar Parte Personalizada
    [Arguments]    ${nome}    ${descricao}    ${cor}
    ${ja_existe}=    Run Keyword And Return Status
    ...    Wait Until Page Contains Element    css:#containerPartes .parte-card    timeout=3s

    IF    not ${ja_existe}
        Scroll Element Into View    ${BOTAO_ADD_PARTE}
        Click Element    ${BOTAO_ADD_PARTE}
    END

    Wait Until Element Is Visible    ${PARTE_NOME}    timeout=10s
    Input Text    ${PARTE_NOME}    ${nome}
    Wait Until Page Contains Element    ${PARTE_MATERIAL_OPCAO}    timeout=10s
    Select From List By Index    ${PARTE_MATERIAL}    1
    Input Text    ${PARTE_DESCRICAO}    ${descricao}
    Input Text    ${PARTE_COR}    ${cor}

Enviar Pedido
    Scroll Element Into View    ${CHECK_CONFIRMACAO}
    Select Checkbox    ${CHECK_CONFIRMACAO}
    Scroll Element Into View    ${BOTAO_ENVIAR_PEDIDO}
    Click Element    ${BOTAO_ENVIAR_PEDIDO}

Aguardar Resposta Do Envio
    Run Keyword And Ignore Error
    ...    Wait Until Keyword Succeeds    10s    500ms    Location Should Contain    meus_projetos

Verificar Confirmacao Com Resumo
    ${url}=    Get Location
    Should Not Contain    ${url}    meus_projetos
    ...    msg=Esperado: confirmação com o resumo do pedido. Obtido: redirecionamento direto para "Meus Projetos" (HU 22, critério de aceite 1).

Contar Projetos Do Cliente
    [Arguments]    ${nome}
    Go To    ${URL_MEUS_PROJETOS}
    Wait Until Page Contains Element    css:.projeto-card    timeout=10s
    ${qtd}=    Get Element Count
    ...    xpath://div[contains(@class,'projeto-card')][.//h5[contains(@class,'card-titulo')][normalize-space()='${nome}']]
    RETURN    ${qtd}

Clicar Em Enviar Pedido
    Scroll Element Into View    ${BOTAO_ENVIAR_PEDIDO}
    Click Element    ${BOTAO_ENVIAR_PEDIDO}

Contar Todos Os Projetos
    Go To    ${URL_MEUS_PROJETOS}
    Wait Until Page Contains Element    css:.projeto-card    timeout=10s
    ${qtd}=    Get Element Count    css:.projeto-card
    RETURN    ${qtd}

Verificar Que O Pedido Nao Foi Processado
    Sleep    2s
    Location Should Contain    realizar-pedido
    Element Should Be Visible    ${FORMULARIO_PEDIDO}

Verificar Campo Obrigatorio Destacado
    [Arguments]    ${id_campo}
    ${invalido}=    Execute Javascript    return document.getElementById('${id_campo}').matches(':invalid');
    Should Be True    ${invalido}    msg=O campo ${id_campo} deveria estar marcado como inválido.
    ${foco}=    Execute Javascript    return document.activeElement.id;
    Should Be Equal    ${foco}    ${id_campo}    msg=O foco deveria estar no campo obrigatório vazio (${id_campo}).

Abrir Analise Do Pedido
    Wait Until Element Is Visible    ${BOTAO_ANALISAR_PEDIDO}    timeout=10s
    Scroll Element Into View    ${BOTAO_ANALISAR_PEDIDO}
    Click Element    ${BOTAO_ANALISAR_PEDIDO}
    Wait Until Element Is Visible    ${CAMPO_VALOR_FINAL}    timeout=10s

Preencher Aceite Do Pedido
    [Arguments]    ${valor}    ${prazo}
    Input Text    ${CAMPO_VALOR_FINAL}    ${valor}
    Input Text    ${CAMPO_PRAZO_PRODUCAO}    ${prazo}

Obter Id Do Pedido Pendente
    ${onclick}=    Get Element Attribute    ${BOTAO_ANALISAR_PEDIDO}    onclick
    ${id}=    Evaluate    ''.join(c for c in $onclick if c.isdigit())
    RETURN    ${id}

Aceitar Pedido
    Scroll Element Into View    ${BOTAO_ACEITAR_PEDIDO}
    Click Element    ${BOTAO_ACEITAR_PEDIDO}
    Alert Should Be Present    Pedido aceito e cliente notificado com sucesso!    action=ACCEPT    timeout=10s

Verificar Aceite No Painel Do Fabricante
    [Arguments]    ${id_pedido}
    Wait Until Page Contains    Pedido #${id_pedido} - ${NOME_PROJETO}    timeout=10s
    Page Should Not Contain Element    css:button[onclick='verDetalhes(${id_pedido})']

Trocar Para Cliente
    Delete All Cookies
    Fazer Login    ${EMAIL_CLIENTE}    ${SENHA_CLIENTE}
    Verificar Login Realizado

Verificar Notificacao De Aceite
    Click Element    ${SINO}
    Wait Until Element Is Visible    css:#sino-dropdown.sino-aberto    timeout=10s
    Wait Until Page Contains Element    css:#sino-lista li.sino-item    timeout=10s
    ${titulo}=    Get Text    css:#sino-lista li.sino-item:first-child .sino-item-titulo
    ${msg}=    Get Text    css:#sino-lista li.sino-item:first-child .sino-item-msg
    Should Be Equal    ${titulo}    Pedido Aceito!
    Should Contain    ${msg}    ${NOME_PROJETO}
    Should Contain    ${msg}    prazo de ${PRAZO_PRODUCAO} dias
    Should Match Regexp    ${msg}    R\\$\\s*1\\.?000,00

Verificar Status Em Producao Para O Cliente
    [Arguments]    ${id_pedido}
    Go To    ${URL_MEUS_PROJETOS}
    ${card}=    Set Variable    xpath://div[contains(@class,'projeto-card')][.//button[@onclick='verDetalhes(${id_pedido})']]
    Wait Until Page Contains Element    ${card}    timeout=10s
    Scroll Element Into View    ${card}
    Element Should Contain    ${card}//span[contains(@class,'badge-status')]    Em produção