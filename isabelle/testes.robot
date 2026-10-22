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


CT19 - Cliente preenche todos os campos obrigatórios do pedido e confirma com sucesso
    [Documentation]    Cliente solicita um pedido de impressão ao fabricante CaCa 3D (Carlos).
    ...    Esperado (plano): o pedido é registrado e o sistema exibe confirmação com o resumo.
    ...    Resultado esperado desta automação: FALHA na verificação do resumo (defeito conhecido,
    ...    HU 22 critério 1): o sistema redireciona direto para "Meus Projetos".
    ...    O teste continua após essa falha para conferir que o pedido foi registrado.
    ...    Evidências: resultados/CT19_Evidencias

    [Tags]    pedido    ct19    defeito_conhecido

    Definir Pasta De Evidencias    CT19_Evidencias

    Fazer Login    ${EMAIL_CLIENTE}    ${SENHA_CLIENTE}
    Verificar Login Realizado
    Registrar Evidencia    CT19_01_login_realizado
    ${antes}=    Contar Projetos Do Cliente    ${NOME_PROJETO}
    Acessar Lista De Fabricantes
    Registrar Evidencia    CT19_02_lista_de_fabricantes
    Abrir Portfolio Do Fabricante
    Registrar Evidencia    CT19_03_portfolio_do_fabricante
    Abrir Formulario De Pedido
    Registrar Evidencia    CT19_04_formulario_de_pedido
    Preencher Dados Do Pedido    ${NOME_PROJETO}    ${DESCRICAO_PROJETO}    ${PRAZO_PEDIDO}    ${ENDERECO_PEDIDO}
    Registrar Evidencia    CT19_05_dados_preenchidos
    Adicionar Parte Personalizada    ${PARTE_NOME_TESTE}    ${PARTE_DESCRICAO_TESTE}    ${PARTE_COR_TESTE}
    Registrar Evidencia    CT19_06_parte_preenchida
    Enviar Pedido
    Aguardar Resposta Do Envio
    Registrar Evidencia    CT19_07_apos_enviar
    Run Keyword And Continue On Failure    Verificar Confirmacao Com Resumo
    ${depois}=    Contar Projetos Do Cliente    ${NOME_PROJETO}
    Registrar Evidencia    CT19_08_meus_projetos
    ${esperado}=    Evaluate    ${antes} + 1
    Should Be Equal As Integers    ${depois}    ${esperado}
    ...    msg=O pedido não apareceu em "Meus Projetos".

CT20 - Cliente tenta confirmar o pedido sem preencher um ou mais campos obrigatórios
    [Documentation]    Cliente tenta enviar o pedido ao fabricante CaCa 3D (Carlos) deixando o
    ...    nome do projeto em branco e preenchendo apenas o prazo.
    ...    Esperado: o sistema não processa o pedido, permanece no formulário e destaca o campo vazio.
    ...    Observação: o destaque visual (contorno) não é avaliado pela automação; o teste verifica
    ...    que o campo está inválido e com o foco do navegador.
    ...    Evidências: resultados/CT20_Evidencias

    [Tags]    pedido    ct20

    Definir Pasta De Evidencias    CT20_Evidencias
    
    Fazer Login    ${EMAIL_CLIENTE}    ${SENHA_CLIENTE}
    Verificar Login Realizado
    Registrar Evidencia    CT20_01_login_realizado
    ${antes}=    Contar Todos Os Projetos
    Acessar Lista De Fabricantes
    Registrar Evidencia    CT20_02_lista_de_fabricantes
    Abrir Portfolio Do Fabricante
    Registrar Evidencia    CT20_03_portfolio_do_fabricante
    Abrir Formulario De Pedido
    Registrar Evidencia    CT20_04_formulario_de_pedido
    Definir Prazo    ${PRAZO_PEDIDO}
    Registrar Evidencia    CT20_05_somente_prazo_preenchido
    Clicar Em Enviar Pedido
    Verificar Que O Pedido Nao Foi Processado
    Verificar Campo Obrigatorio Destacado    nome_projeto
    Registrar Evidencia    CT20_06_campo_obrigatorio_destacado
    ${depois}=    Contar Todos Os Projetos
    Should Be Equal As Integers    ${depois}    ${antes}
    ...    msg=Um pedido foi criado mesmo com campos obrigatórios vazios.