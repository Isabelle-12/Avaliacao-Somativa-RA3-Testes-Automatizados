*** Settings ***
Documentation    Casos de teste automatizados do Printly (autora: Isabelle)
Resource         resources.robot
Test Setup       Abrir Navegador
Test Teardown    Fechar Navegador

*** Test Cases ***
CT00 - Login como cliente (teste de base)
    [Documentation]    Valida a base da automação: abre o navegador, faz login e fecha
    [Tags]    fumaca    login
    Fazer Login    ${EMAIL_CLIENTE}    ${SENHA_CLIENTE}
    Verificar Login Realizado