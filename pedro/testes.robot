*** Settings ***
Documentation    Casos de teste automatizados do Printly (autor: Pedro)
...    Casos do plano do RA2 sob responsabilidade do Pedro: CT25, CT27, CT29, CT30 e CT31.
Resource         resources.robot
Test Setup       Abrir Navegador
Test Teardown    Fechar Navegador

*** Test Cases ***
CT25 - Cliente verifica o histórico de atualizações do pedido em ordem cronológica
    [Documentation]    Cliente abre os detalhes do projeto "Carrinho de Brinquedo" em "Meus Projetos".
    ...    Esperado: o "Histórico de Atualizações" é exibido em ordem cronológica, com data, hora
    ...    e descrição de cada etapa.
    ...    Pré-condição: o cliente João possui o projeto "Carrinho de Brinquedo" com histórico registrado.
    ...    Evidências: resultados/CT25_Evidencias

    [Tags]    projetos    historico    ct25

    Definir Pasta De Evidencias    CT25_Evidencias

    Fazer Login    ${EMAIL_CLIENTE}    ${SENHA_CLIENTE}
    Verificar Login Realizado
    Registrar Evidencia    CT25_01_login_realizado
    Acessar Meus Projetos
    Registrar Evidencia    CT25_02_meus_projetos
    Abrir Detalhes Do Projeto    ${PROJETO_CT25}
    Registrar Evidencia    CT25_03_detalhes_do_projeto
    Rolar Ate O Historico
    Verificar Historico Em Ordem Cronologica
    Registrar Evidencia    CT25_04_historico_de_atualizacoes

CT27 - Cliente verifica nome, data de envio, status e miniatura na lista de "Meus Projetos"
    [Documentation]    Cliente confere, na lista de "Meus Projetos", o card do projeto "Porta Canetas":
    ...    nome "Porta Canetas", data de envio 20/09/2026, status "Concluído" e miniatura.
    ...    Resultado desta automação: FALHA esperada (defeito conhecido): o nome, a data e o status são
    ...    exibidos corretamente, mas a miniatura do projeto não aparece (só o ícone de pasta).
    ...    O teste registra a falha de propósito e segue conferindo os demais dados.
    ...    Pré-condição: o cliente João possui o projeto "Porta Canetas", concluído, enviado em 20/09/2026.
    ...    Evidências: resultados/CT27_Evidencias

    [Tags]    projetos    ct27    defeito_conhecido

    Definir Pasta De Evidencias    CT27_Evidencias

    Fazer Login    ${EMAIL_CLIENTE}    ${SENHA_CLIENTE}
    Verificar Login Realizado
    Registrar Evidencia    CT27_01_login_realizado
    Acessar Meus Projetos
    Registrar Evidencia    CT27_02_meus_projetos
    ${card}=    Localizar Card Do Projeto    ${PROJETO_CT27}
    Registrar Evidencia    CT27_03_card_do_projeto
    Verificar Dados Do Card Do Projeto    ${card}    ${PROJETO_CT27}    ${DATA_ENVIO_CT27}    ${STATUS_CT27}

    # Resultado ESPERADO pelo plano (miniatura visível): falha de propósito, documentando o defeito.
    Run Keyword And Continue On Failure    Verificar Miniatura Do Projeto    ${card}    ${PROJETO_CT27}

CT29 - Cliente filtra fabricantes por localização e vê apenas os da região informada
    [Documentation]    Cliente pesquisa fabricantes na cidade "Curitiba", estado "PR", pelo filtro de localização.
    ...    Esperado: são exibidos apenas fabricantes de Curitiba/PR.
    ...    Pré-condição: existem fabricantes aprovados em Curitiba/PR (ex.: Maria e CaCa 3D).
    ...    Evidências: resultados/CT29_Evidencias

    [Tags]    fabricantes    filtro    ct29

    Definir Pasta De Evidencias    CT29_Evidencias

    Fazer Login    ${EMAIL_CLIENTE}    ${SENHA_CLIENTE}
    Verificar Login Realizado
    Registrar Evidencia    CT29_01_login_realizado
    Acessar Lista De Fabricantes
    Registrar Evidencia    CT29_02_lista_de_fabricantes
    Preencher Filtro De Localizacao    ${CIDADE_CT29}    ${ESTADO_CT29}
    Registrar Evidencia    CT29_03_filtro_preenchido
    Buscar Fabricantes Por Localizacao
    Verificar Fabricantes Somente Da Regiao    ${CIDADE_CT29}    ${ESTADO_CT29}
    Rolar Ate O Elemento    ${GRID_FABRICANTES}
    Registrar Evidencia    CT29_04_fabricantes_da_regiao

CT30 - Cliente filtra fabricantes em região sem cadastro e vê a mensagem de nenhum encontrado
    [Documentation]    Cliente pesquisa fabricantes na cidade "Campo Largo", estado "PR", onde não há fabricantes.
    ...    Esperado: o sistema exibe a mensagem "Nenhum fabricante encontrado nesta região." e nenhum card.
    ...    Pré-condição: não existe fabricante aprovado cadastrado em Campo Largo/PR.
    ...    Evidências: resultados/CT30_Evidencias

    [Tags]    fabricantes    filtro    ct30

    Definir Pasta De Evidencias    CT30_Evidencias

    Fazer Login    ${EMAIL_CLIENTE}    ${SENHA_CLIENTE}
    Verificar Login Realizado
    Registrar Evidencia    CT30_01_login_realizado
    Acessar Lista De Fabricantes
    Registrar Evidencia    CT30_02_lista_de_fabricantes
    Preencher Filtro De Localizacao    ${CIDADE_CT30}    ${ESTADO_CT30}
    Registrar Evidencia    CT30_03_filtro_preenchido
    Buscar Fabricantes Por Localizacao
    Verificar Mensagem De Nenhum Fabricante
    Rolar Ate O Elemento    ${FILTRO_MENSAGEM}
    Registrar Evidencia    CT30_04_nenhum_fabricante_encontrado

CT31 - Cliente envia mensagem ao fabricante e ela aparece na conversa com o horário do envio
    [Documentation]    Cliente abre o chat do projeto "Caneca" e envia a mensagem
    ...    "Oi, como está o andamento do projeto?".
    ...    Esperado: a mensagem aparece imediatamente na conversa, com o horário do envio.
    ...    Pré-condição: o cliente João possui o projeto "Caneca" vinculado a um fabricante.
    ...    Dados: grava uma mensagem nova na conversa a cada execução.
    ...    Evidências: resultados/CT31_Evidencias

    [Tags]    chat    ct31

    Definir Pasta De Evidencias    CT31_Evidencias

    Fazer Login    ${EMAIL_CLIENTE}    ${SENHA_CLIENTE}
    Verificar Login Realizado
    Registrar Evidencia    CT31_01_login_realizado
    Acessar Meus Projetos
    Registrar Evidencia    CT31_02_meus_projetos
    Abrir Chat Do Projeto    ${PROJETO_CT31}
    ${antes}=    Contar Minhas Mensagens No Chat
    Registrar Evidencia    CT31_03_conversa_aberta
    Enviar Mensagem No Chat    ${MENSAGEM_CT31}
    Verificar Mensagem Enviada Com Horario    ${MENSAGEM_CT31}    ${antes}
    Registrar Evidencia    CT31_04_mensagem_enviada_com_horario