*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem

*** Variables ***
${BROWSER}          Chrome
${URL}              http://localhost/Printly/public/index.php?rota=login

# Usuários de teste
${EMAIL_CLIENTE}    joao@email.com
${SENHA_CLIENTE}    123456
${EMAIL_MAKER}      maria@email.com
${SENHA_MAKER}      123456

# Localizadores da tela de login
${CAMPO_EMAIL}      id:email
${CAMPO_SENHA}      id:senha
${BOTAO_ENTRAR}     css:.btn-primary-custom

# Perfil do fabricante e materiais
${LINK_PERFIL}               css:a.nav-link[href*='perfil-fabricante']
${BOTAO_ADD_MATERIAL}        css:button[onclick='abrirModalMaterial()']
${SELECT_MATERIAL}           id:modalMatTipo
${CAMPO_PRECO_MATERIAL}      id:modalMatPreco
${BOTAO_SALVAR_MATERIAL}     id:btnSalvarMaterial


# Dados do CT17 (conforme o plano de testes)
${MATERIAL_TESTE}           PETG
${PRECO_TESTE}              0.19
${PRECO_EXIBIDO}            0,19

${LISTA_MATERIAIS}          id:portfolioMateriais

# Dados do CT18
${PRECO_INVALIDO}               0
${MENSAGEM_PRECO_INVALIDO}      Informe um preço por grama válido.


*** Keywords ***
Abrir Navegador
    Open Browser    ${URL}    ${BROWSER}
    ...    options=add_experimental_option("prefs", {"credentials_enable_service": False, "profile.password_manager_enabled": False, "profile.password_manager_leak_detection": False})
    Maximize Browser Window
    # AJUSTADO: cada teste começa com os prints indo para a pasta padrão (resultados)
    Set Screenshot Directory    ${OUTPUT DIR}

Fechar Navegador
    Run Keyword And Ignore Error    Capture Page Screenshot    tela_final_{index}.png
    Close Browser

# NOVO: cria a pasta de evidências do caso dentro de resultados e manda os prints para ela
Definir Pasta De Evidencias
    [Arguments]    ${pasta}
    ${caminho}=    Set Variable    ${OUTPUT DIR}${/}${pasta}
    Create Directory    ${caminho}
    Set Screenshot Directory    ${caminho}

# NOVO: print de um passo importante, com nome escolhido por nós
Registrar Evidencia
    [Arguments]    ${nome}
    Capture Page Screenshot    ${nome}.png

Fazer Login
    [Arguments]    ${email}    ${senha}
    Go To    url=${URL}
    Input Text      ${CAMPO_EMAIL}    ${email}
    Input Text      ${CAMPO_SENHA}    ${senha}
    Click Element   ${BOTAO_ENTRAR}

# NOVA: confirma que o login funcionou (a tela de login deixa de aparecer)
Verificar Login Realizado
    Wait Until Element Is Not Visible    ${CAMPO_EMAIL}    timeout=10s

Acessar Perfil Do Fabricante
    # Diagnóstico temporário: quantos links batem com o localizador (o ideal é 1)
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

# NOVO: conta os cards da lista que têm o nome e o preço informados
Contar Materiais
    [Arguments]    ${nome}    ${preco}
    ${qtd}=    Get Element Count
    ...    xpath://div[@id='portfolioMateriais']//div[contains(@class,'portfolio-item')][.//strong[normalize-space()='${nome}']][.//small[contains(.,'${preco}')]]
    RETURN    ${qtd}

# NOVO: compara a contagem atual com a esperada
Verificar Quantidade De Materiais
    [Arguments]    ${nome}    ${preco}    ${esperado}
    ${qtd}=    Contar Materiais    ${nome}    ${preco}
    Should Be Equal As Integers    ${qtd}    ${esperado}

# NOVO: conta TODOS os materiais da lista (não só um tipo)
Contar Todos Os Materiais
    ${qtd}=    Get Element Count    css:#portfolioMateriais .portfolio-item
    RETURN    ${qtd}

# NOVO: confere o texto do alerta nativo do navegador e clica em OK
Verificar Alerta De Preco Invalido
    Alert Should Be Present    ${MENSAGEM_PRECO_INVALIDO}    action=ACCEPT    timeout=5s
