*** Settings ***
Documentation    Casos de teste automatizados do Printly (autora: Isabelle)
Resource         resources.robot
Test Setup       Abrir Navegador
Test Teardown    Fechar Navegador

*** Test Cases ***
CT17 - Fabricante define o preço por grama de filamento e salva com sucesso
    [Documentation]    Fabricante define o preço por grama de um material e salva.
    ...    Pré-condição: a fabricante Maria possui uma impressora FDM cadastrada (libera o PETG).
    ...    Observação: o sistema aceita material duplicado, então a verificação compara a
    ...    quantidade de cards antes e depois de salvar.
    ...    Evidências: resultados/CT17_Evidencias

    [Tags]    material    ct17

    Definir Pasta De Evidencias    CT17_Evidencias

    Fazer Login    ${EMAIL_MAKER}    ${SENHA_MAKER}
    Verificar Login Realizado
    Registrar Evidencia    CT17_01_login_realizado
    Acessar Perfil Do Fabricante
    ${antes}=    Contar Materiais    ${MATERIAL_TESTE}    ${PRECO_EXIBIDO}
    Scroll Element Into View    ${LISTA_MATERIAIS}
    Registrar Evidencia    CT17_02_perfil_antes_de_salvar
    Abrir Formulario De Material
    Registrar Evidencia    CT17_03_formulario_aberto
    Preencher Material    ${MATERIAL_TESTE}    ${PRECO_TESTE}
    Registrar Evidencia    CT17_04_formulario_preenchido
    Salvar Material
    ${esperado}=    Evaluate    ${antes} + 1
    Wait Until Keyword Succeeds    10s    500ms
    ...    Verificar Quantidade De Materiais    ${MATERIAL_TESTE}    ${PRECO_EXIBIDO}    ${esperado}
    Wait Until Element Is Not Visible    ${SELECT_MATERIAL}    timeout=10s
    Scroll Element Into View    ${LISTA_MATERIAIS}
    Registrar Evidencia    CT17_05_material_salvo_na_lista