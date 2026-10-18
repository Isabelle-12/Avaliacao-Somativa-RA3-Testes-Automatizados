*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${BROWSER}          Chrome
${URL}              http://localhost/Printly/public/index.php?rota=login

# Usuários de teste
${EMAIL_CLIENTE}    joao@email.com
${SENHA_CLIENTE}    123456
${EMAIL_MAKER}      COMPLETAR
${SENHA_MAKER}      123456

# Localizadores da tela de login
${CAMPO_EMAIL}      id:email
${CAMPO_SENHA}      id:senha
${BOTAO_ENTRAR}     css:.btn-primary-custom

*** Keywords ***
Abrir Navegador
    Open Browser    ${URL}    ${BROWSER}
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