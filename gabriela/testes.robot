*** Settings ***
Documentation    Casos de teste automatizados do Printly (autora: Gabriela)
Resource         resources.robot
Test Setup       Abrir Navegador
Test Teardown    Fechar Navegador

*** Test Cases ***
CT9 - Fabricante atualiza as informações do perfil e salva com sucesso
    [Documentation]    Fabricante edita nome, e-mail, telefone, documento, CEP, cidade, estado e
    ...    endereço do perfil e salva.
    ...    Esperado: mensagem "Perfil atualizado com sucesso!", redirecionamento ao perfil e
    ...    dados mantidos ao reabrir a edição.
    ...    O teste guarda os dados originais e os restaura no final, para não quebrar o login
    ...    do fabricante nas próximas execuções.
    ...    Evidências: resultados/CT9_Evidencias

    [Tags]    perfil    ct9

    Definir Pasta De Evidencias    CT9_Evidencias

    Fazer Login    ${EMAIL_MAKER}    ${SENHA_MAKER}
    Verificar Login Realizado
    Registrar Evidencia    CT9_01_login_realizado
    Acessar Perfil Do Fabricante
    Registrar Evidencia    CT9_02_perfil_do_fabricante
    Abrir Edicao Do Perfil
    ${originais}=    Guardar Dados Originais Do Perfil
    Registrar Evidencia    CT9_03_formulario_de_edicao
    Preencher Perfil    ${PERFIL_NOME_TESTE}    ${PERFIL_EMAIL_TESTE}    ${PERFIL_TEL_TESTE}
    ...    ${PERFIL_DOC_TESTE}    ${PERFIL_CEP_TESTE}    ${PERFIL_CIDADE_TESTE}
    ...    ${PERFIL_ESTADO_TESTE}    ${PERFIL_ENDERECO_TESTE}
    Registrar Evidencia    CT9_04_dados_preenchidos
    TRY
        Salvar Perfil
        Tratar Mensagem Do Sistema    ${MSG_PERFIL_SALVO}
        Wait For Condition    return window.location.href.includes('rota=perfil-fabricante');    timeout=10s
        Registrar Evidencia    CT9_05_apos_salvar
        Verificar Dados Do Perfil Salvos
        Registrar Evidencia    CT9_06_dados_mantidos
    FINALLY
        Restaurar Perfil Original    ${originais}
    END

CT10 - Fabricante tenta salvar o perfil sem preencher nome e e-mail
    [Documentation]    Fabricante apaga nome e e-mail do perfil e tenta salvar.
    ...    Esperado: alerta "Nome e e-mail não podem ficar vazios.", sem redirecionar, e os dados
    ...    originais permanecem. O alerta é nativo e não aparece nos prints; o teste valida o texto.
    ...    Evidências: resultados/CT10_Evidencias

    [Tags]    perfil    ct10

    Definir Pasta De Evidencias    CT10_Evidencias

    Fazer Login    ${EMAIL_MAKER}    ${SENHA_MAKER}
    Verificar Login Realizado
    Registrar Evidencia    CT10_01_login_realizado
    Acessar Perfil Do Fabricante
    Abrir Edicao Do Perfil
    ${nome_original}=     Obter Valor Do Campo    ${PERFIL_NOME}
    ${email_original}=    Obter Valor Do Campo    ${PERFIL_EMAIL}
    Registrar Evidencia    CT10_02_formulario_de_edicao
    Apagar Nome E Email Do Perfil
    Registrar Evidencia    CT10_03_campos_apagados
    Salvar Perfil
    Verificar Salvamento Bloqueado Por Campos Vazios
    Registrar Evidencia    CT10_04_salvamento_bloqueado
    Verificar Dados Do Perfil Nao Foram Alterados    ${nome_original}    ${email_original}
    Registrar Evidencia    CT10_05_dados_originais_mantidos

CT11 - Fabricante adiciona uma nova impressora ao portfólio e salva com sucesso
    [Documentation]    Fabricante cadastra a impressora Bambu (volume 33, quantidade 2, tipos FDM e SLS).
    ...    Esperado: a impressora aparece na lista "Minhas Impressoras".
    ...    Dado criado: uma impressora nova a cada execução (o teste confere pela contagem
    ...    antes e depois de salvar) e a remove no final, para a lista não crescer.
    ...    Evidências: resultados/CT11_Evidencias

    [Tags]    impressora    ct11

    Definir Pasta De Evidencias    CT11_Evidencias

    Fazer Login    ${EMAIL_MAKER}    ${SENHA_MAKER}
    Verificar Login Realizado
    Registrar Evidencia    CT11_01_login_realizado
    Acessar Perfil Do Fabricante
    Aguardar Impressoras Carregadas
    ${antes}=    Contar Impressoras Do Modelo    ${IMP_MODELO_TESTE}
    Scroll Element Into View    ${LISTA_IMPRESSORAS}
    Registrar Evidencia    CT11_02_impressoras_antes_de_salvar
    Abrir Formulario De Impressora
    Registrar Evidencia    CT11_03_formulario_aberto
    Preencher Impressora    ${IMP_MODELO_TESTE}    ${IMP_VOLUME_TESTE}    ${IMP_QTD_TESTE}    ${IMP_TIPO_TESTE}
    Registrar Evidencia    CT11_04_formulario_preenchido
    TRY
        Salvar Impressora
        Wait Until Element Is Not Visible    ${MODAL_IMPRESSORA}    timeout=10s
        ${esperado}=    Evaluate    ${antes} + 1
        Wait Until Keyword Succeeds    10s    500ms
        ...    Verificar Quantidade De Impressoras Do Modelo    ${IMP_MODELO_TESTE}    ${esperado}
        Scroll Element Into View    ${LISTA_IMPRESSORAS}
        Registrar Evidencia    CT11_05_impressora_salva_na_lista
    FINALLY
        Run Keyword And Ignore Error    Excluir Impressoras Criadas No Teste    ${IMP_MODELO_TESTE}    ${antes}
    END

CT12 - Fabricante tenta salvar uma impressora sem informar o modelo
    [Documentation]    Fabricante preenche volume 29, quantidade 4 e tipos SLA e DLP, deixa o Modelo em branco
    ...    e tenta salvar.
    ...    Esperado: alerta "Informe o modelo da impressora." e nenhuma impressora gravada.
    ...    O alerta é nativo e não aparece nos prints; o teste valida o texto.
    ...    Evidências: resultados/CT12_Evidencias

    [Tags]    impressora    ct12

    Definir Pasta De Evidencias    CT12_Evidencias

    Fazer Login    ${EMAIL_MAKER}    ${SENHA_MAKER}
    Verificar Login Realizado
    Registrar Evidencia    CT12_01_login_realizado
    Acessar Perfil Do Fabricante
    Aguardar Impressoras Carregadas
    ${antes}=    Contar Impressoras
    Scroll Element Into View    ${LISTA_IMPRESSORAS}
    Registrar Evidencia    CT12_02_impressoras_antes_de_salvar
    Abrir Formulario De Impressora
    Registrar Evidencia    CT12_03_formulario_aberto
    Preencher Impressora    ${EMPTY}    ${IMP_VOLUME_CT12}    ${IMP_QTD_CT12}    ${IMP_TIPO_CT12}
    Registrar Evidencia    CT12_04_modelo_em_branco
    Salvar Impressora
    Verificar Alerta De Modelo Obrigatorio
    Registrar Evidencia    CT12_05_apos_tentar_salvar
    Verificar Impressora Nao Foi Salva    ${antes}
    Scroll Element Into View    ${LISTA_IMPRESSORAS}
    Registrar Evidencia    CT12_06_lista_apos_recarregar

CT15 - Cliente envia uma avaliação (nota e comentário) sobre o fabricante após a entrega
    [Documentation]    Cliente João avalia com 4 estrelas e o comentário "Ótima qualidade" o projeto
    ...    concluído "asd".
    ...    Pré-condição: existe um projeto concluído "asd" do João (fabricante "TESTE") ainda sem
    ...    avaliação. Esses dados não vêm do printly.sql: crie-os antes e, como a avaliação
    ...    consome o pedido, recrie-o a cada nova execução.
    ...    Fluxo: "Avaliar" abre o portfólio do fabricante, onde fica o formulário de feedback.
    ...    Obs.: o sistema grava a avaliação no pedido concluído mais recente do João com esse
    ...    fabricante que ainda não foi avaliado.
    ...    Evidências: resultados/CT15_Evidencias

    [Tags]    avaliacao    ct15

    Definir Pasta De Evidencias    CT15_Evidencias

    Fazer Login    ${EMAIL_CLIENTE}    ${SENHA_CLIENTE}
    Verificar Login Realizado
    Registrar Evidencia    CT15_01_login_realizado
    Abrir Meus Projetos
    Registrar Evidencia    CT15_02_meus_projetos
    Abrir Avaliacao Do Projeto
    Registrar Evidencia    CT15_03_formulario_de_avaliacao
    Marcar Estrelas    ${NOTA_AVALIACAO}
    Escrever Comentario Da Avaliacao    ${COMENTARIO_AVALIACAO}
    Registrar Evidencia    CT15_04_avaliacao_preenchida
    Enviar Avaliacao
    Verificar Avaliacao Registrada
    Registrar Evidencia    CT15_05_avaliacao_enviada
