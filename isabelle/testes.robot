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

CT18 - Fabricante tenta inserir um valor de material igual ou inferior a zero
    [Documentation]    Fabricante tenta cadastrar um material com preço 0.
    ...    Esperado: alerta de erro e nenhum material gravado.
    ...    Pré-condição: a fabricante Maria possui uma impressora FDM cadastrada (libera o PETG).
    ...    Observação: o alerta é uma janela nativa do navegador, que o Selenium não consegue
    ...    fotografar; o texto dele é validado pelo teste e fica registrado no log.html.
    ...    Evidências: resultados/CT18_Evidencias

    [Tags]    material    ct18

    Definir Pasta De Evidencias    CT18_Evidencias
    
    Fazer Login    ${EMAIL_MAKER}    ${SENHA_MAKER}
    Verificar Login Realizado
    Registrar Evidencia    CT18_01_login_realizado
    Acessar Perfil Do Fabricante
    ${antes}=    Contar Todos Os Materiais
    Scroll Element Into View    ${LISTA_MATERIAIS}
    Registrar Evidencia    CT18_02_lista_antes_de_salvar
    Abrir Formulario De Material
    Registrar Evidencia    CT18_03_formulario_aberto
    Preencher Material    ${MATERIAL_TESTE}    ${PRECO_INVALIDO}
    Registrar Evidencia    CT18_04_preco_zero_preenchido
    Salvar Material
    Verificar Alerta De Preco Invalido
    Registrar Evidencia    CT18_05_formulario_apos_o_alerta
    Reload Page
    Wait Until Page Contains Element    ${BOTAO_ADD_MATERIAL}    timeout=10s
    Scroll Element Into View    ${LISTA_MATERIAIS}
    Registrar Evidencia    CT18_06_lista_apos_recarregar
    ${depois}=    Contar Todos Os Materiais
    Should Be Equal As Integers    ${depois}    ${antes}