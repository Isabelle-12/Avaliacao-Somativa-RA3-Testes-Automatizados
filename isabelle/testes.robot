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

CT17 - Definir preço base de material (EM CONSTRUÇÃO)
    [Documentation]    Fabricante define o preço por grama de um material e salva
    [Tags]    material    ct17
    Fazer Login    ${EMAIL_MAKER}    ${SENHA_MAKER}
    Verificar Login Realizado
    Acessar Perfil Do Fabricante
    Abrir Formulario De Material
    # Diagnóstico temporário: mostra no terminal quais materiais o select oferece
    ${opcoes}=    Get List Items    ${SELECT_MATERIAL}
    Log To Console    Opções do select: ${opcoes}