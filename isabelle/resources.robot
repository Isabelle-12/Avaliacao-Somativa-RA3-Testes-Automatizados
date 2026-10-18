*** Settings ***
Library           SeleniumLibrary

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


*** Keywords ***
Abrir Navegador
    Open Browser    ${URL}    ${BROWSER}
    ...    options=add_experimental_option("prefs", {"credentials_enable_service": False, "profile.password_manager_enabled": False, "profile.password_manager_leak_detection": False})
    Maximize Browser Window

Fechar Navegador
    Capture Page Screenshot
    Close Browser

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