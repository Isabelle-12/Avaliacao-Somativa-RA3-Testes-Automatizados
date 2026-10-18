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

CT17 - Fabricante define o preço por grama de filamento e salva com sucesso
    [Documentation]    Fabricante define o preço por grama de um material e salva.
    ...    Pré-condição: a fabricante Maria possui uma impressora FDM cadastrada (libera o PETG).
    ...    Observação: o sistema aceita material duplicado, então a verificação compara a
    ...    quantidade de cards antes e depois de salvar.
    [Tags]    material    ct17
    Fazer Login    ${EMAIL_MAKER}    ${SENHA_MAKER}
    Verificar Login Realizado
    Acessar Perfil Do Fabricante
    ${antes}=    Contar Materiais    ${MATERIAL_TESTE}    ${PRECO_EXIBIDO}
    Abrir Formulario De Material
    Preencher Material    ${MATERIAL_TESTE}    ${PRECO_TESTE}
    Salvar Material
    ${esperado}=    Evaluate    ${antes} + 1
    Wait Until Keyword Succeeds    10s    500ms
    ...    Verificar Quantidade De Materiais    ${MATERIAL_TESTE}    ${PRECO_EXIBIDO}    ${esperado}