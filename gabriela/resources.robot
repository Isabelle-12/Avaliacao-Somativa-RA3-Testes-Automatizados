*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem
Library           Collections
Library           String

*** Variables ***
${BROWSER}          Chrome
${URL}              http://localhost/Printly/public/index.php?rota=login
${URL_MEUS_PROJETOS}    http://localhost/Printly/public/index.php?rota=meus_projetos

# ---------- Usuários de teste (senha 123456) ----------
${EMAIL_CLIENTE}    joao@email.com
${SENHA_CLIENTE}    123456
# Fabricante usado nos CT9 a CT12 (Maria, como no plano de testes)
${EMAIL_MAKER}      maria@email.com
${SENHA_MAKER}      123456

# ---------- Login (mesmos seletores da Isabelle) ----------
${CAMPO_EMAIL}      id:email
${CAMPO_SENHA}      id:senha
${BOTAO_ENTRAR}     css:.btn-primary-custom
${LINK_PERFIL}      css:a.nav-link[href*='perfil-fabricante']

# =====================================================================
# Seletores conferidos no código-fonte do Printly (editar_perfil_fabricante.html,
# perfil_fabricante.html, portfolio_fabricante.js e portfolio_makers_listagem.js).
# Se o front mudar, ajuste só esta seção.
# =====================================================================

# ---------- CT9 / CT10: edição de perfil ----------
# "Editar Perfil" é um LINK (<a>) que abre outra página, não um botão/modal
${BOTAO_EDITAR_PERFIL}      css:a[href*='editar-perfil-fabricante']
${PERFIL_NOME}              id:nome
${PERFIL_EMAIL}             id:email
${PERFIL_TELEFONE}          id:telefone
${PERFIL_DOCUMENTO}         id:documento
${PERFIL_CEP}               id:cep
${PERFIL_CIDADE}            id:cidade
${PERFIL_ESTADO}            id:estado
${PERFIL_ENDERECO}          id:endereco
${BOTAO_SALVAR_PERFIL}      css:button[type='submit'].btn-editar-card

# Dados do CT9 (conforme o plano do RA2)
${PERFIL_NOME_TESTE}        TESTE
${PERFIL_EMAIL_TESTE}       TESTE@email.com
${PERFIL_TEL_TESTE}         11111111111
${PERFIL_DOC_TESTE}         11111111111
${PERFIL_CEP_TESTE}         22222222
${PERFIL_CIDADE_TESTE}      TESTE
${PERFIL_ESTADO_TESTE}      SP
${PERFIL_ENDERECO_TESTE}    TESTE

${MSG_PERFIL_SALVO}         Perfil atualizado com sucesso!
${MSG_PERFIL_VAZIO}         Nome e e-mail não podem ficar vazios.

# ---------- CT11 / CT12: impressoras ----------
${BOTAO_ADD_IMPRESSORA}     css:button.btn-add-impressora[onclick='abrirModalImpressora()']
${IMP_MODELO}               id:modalImpModelo
${IMP_VOLUME}               id:modalImpVolume
${IMP_QUANTIDADE}           id:modalImpQuantidade
${MODAL_IMPRESSORA}         id:modalImpressora
${MSG_IMP_SEM_MODELO}       Informe o modelo da impressora.
${BOTAO_SALVAR_IMPRESSORA}  id:btnSalvarImpressora
${LISTA_IMPRESSORAS}        id:portfolioImpressoras

# Dados do CT11
${IMP_MODELO_TESTE}         Bambu
${IMP_VOLUME_TESTE}         33
${IMP_QTD_TESTE}            2
${IMP_TIPO_TESTE}           FDM,SLS

# Dados do CT12 (modelo fica em branco)
${IMP_VOLUME_CT12}          29
${IMP_QTD_CT12}             4
${IMP_TIPO_CT12}           SLA,DLP

# ---------- CT15: avaliação do fabricante ----------
${PROJETO_CONCLUIDO}        asd
${NOTA_AVALIACAO}           4
${COMENTARIO_AVALIACAO}     Ótima qualidade
${CARD_PROJETO_CONCLUIDO}   xpath://div[contains(@class,'projeto-card')][.//h5[contains(@class,'card-titulo')][normalize-space()='${PROJETO_CONCLUIDO}']]
${BOTAO_AVALIAR}            ${CARD_PROJETO_CONCLUIDO}//button[contains(@class,'btn-feedback')]
${CAMPO_COMENTARIO}         id:comentario-feedback
${BOTAO_ENVIAR_AVALIACAO}   css:.btn-enviar-feedback
${MSG_AVALIACAO_OK}         css:#form-feedback-msg .form-feedback-msg.ok
${TEXTO_AVALIACAO_OK}       Feedback enviado com sucesso


*** Keywords ***
# ====================== Infraestrutura (igual ao padrão do grupo) ======================
Abrir Navegador
    Open Browser    ${URL}    ${BROWSER}
    ...    options=add_experimental_option("prefs", {"credentials_enable_service": False, "profile.password_manager_enabled": False, "profile.password_manager_leak_detection": False})
    Maximize Browser Window
    Set Screenshot Directory    ${OUTPUT DIR}

Fechar Navegador
    Run Keyword And Ignore Error    Capture Page Screenshot    tela_final_{index}.png
    Close Browser

Definir Pasta De Evidencias
    [Arguments]    ${pasta}
    ${caminho}=    Set Variable    ${OUTPUT DIR}${/}${pasta}
    Create Directory    ${caminho}
    Set Screenshot Directory    ${caminho}

Registrar Evidencia
    [Arguments]    ${nome}
    Capture Page Screenshot    ${nome}.png

Fazer Login
    [Arguments]    ${email}    ${senha}
    Go To    url=${URL}
    Input Text      ${CAMPO_EMAIL}    ${email}
    Input Text      ${CAMPO_SENHA}    ${senha}
    Click Element   ${BOTAO_ENTRAR}

Verificar Login Realizado
    Wait Until Element Is Not Visible    ${CAMPO_EMAIL}    timeout=10s

Acessar Perfil Do Fabricante
    Wait Until Element Is Visible    ${LINK_PERFIL}    timeout=10s
    Scroll Element Into View    ${LINK_PERFIL}
    Click Element    ${LINK_PERFIL}
    Wait Until Page Contains Element    ${BOTAO_EDITAR_PERFIL}    timeout=10s

# ====================== Utilitários ======================
Definir Valor Do Campo
    [Documentation]    Preenche um campo, seja input/textarea (digita) ou select (escolhe o valor).
    [Arguments]    ${locator}    ${valor}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    ${elemento}=    Get WebElement    ${locator}
    IF    '${elemento.tag_name}' == 'select'
        Select From List By Value    ${locator}    ${valor}
    ELSE
        Input Text    ${locator}    ${valor}
    END

Obter Valor Do Campo
    [Arguments]    ${locator}
    ${valor}=    Get Value    ${locator}
    RETURN    ${valor}

Tratar Mensagem Do Sistema
    [Documentation]    O Printly pode avisar por alerta nativo ou por texto na página.
    ...    Tenta o alerta primeiro; se não houver, procura o texto na página.
    ...    Retorna o texto do alerta, ou vazio se a mensagem estava na página.
    [Arguments]    ${texto_esperado}
    ${status}    ${retorno}=    Run Keyword And Ignore Error
    ...    Handle Alert    action=ACCEPT    timeout=5s
    IF    '${status}' == 'PASS'
        Should Contain    ${retorno}    ${texto_esperado}
        RETURN    ${retorno}
    END
    Wait Until Page Contains    ${texto_esperado}    timeout=10s
    RETURN    ${EMPTY}

# ====================== CT9 / CT10: perfil ======================
Abrir Edicao Do Perfil
    Wait Until Element Is Visible    ${BOTAO_EDITAR_PERFIL}    timeout=10s
    Execute Javascript    document.querySelector("a[href*='editar-perfil-fabricante']").scrollIntoView({block: 'center'});
    Sleep    1s
    Click Element    ${BOTAO_EDITAR_PERFIL}
    Wait Until Location Contains    editar-perfil-fabricante    timeout=10s
    Wait Until Element Is Visible    ${PERFIL_NOME}    timeout=10s
    # os campos são preenchidos por um fetch assíncrono: espera os dados chegarem
    Wait For Condition    return document.getElementById('nome').value !== '';    timeout=10s

Guardar Dados Originais Do Perfil
    [Documentation]    Lê os valores atuais para o teste conseguir restaurá-los no final.
    ${nome}=        Obter Valor Do Campo    ${PERFIL_NOME}
    ${email}=       Obter Valor Do Campo    ${PERFIL_EMAIL}
    ${telefone}=    Obter Valor Do Campo    ${PERFIL_TELEFONE}
    ${documento}=   Obter Valor Do Campo    ${PERFIL_DOCUMENTO}
    ${cep}=         Obter Valor Do Campo    ${PERFIL_CEP}
    ${cidade}=      Obter Valor Do Campo    ${PERFIL_CIDADE}
    ${estado}=      Obter Valor Do Campo    ${PERFIL_ESTADO}
    ${endereco}=    Obter Valor Do Campo    ${PERFIL_ENDERECO}
    ${dados}=    Create Dictionary
    ...    nome=${nome}    email=${email}    telefone=${telefone}    documento=${documento}
    ...    cep=${cep}    cidade=${cidade}    estado=${estado}    endereco=${endereco}
    RETURN    ${dados}

Preencher Perfil
    [Arguments]    ${nome}    ${email}    ${telefone}    ${documento}
    ...    ${cep}    ${cidade}    ${estado}    ${endereco}
    Definir Valor Do Campo    ${PERFIL_NOME}        ${nome}
    Definir Valor Do Campo    ${PERFIL_EMAIL}       ${email}
    Definir Valor Do Campo    ${PERFIL_TELEFONE}    ${telefone}
    Definir Valor Do Campo    ${PERFIL_DOCUMENTO}   ${documento}
    Definir Valor Do Campo    ${PERFIL_CEP}         ${cep}
    Definir Valor Do Campo    ${PERFIL_CIDADE}      ${cidade}
    Definir Valor Do Campo    ${PERFIL_ESTADO}      ${estado}
    Definir Valor Do Campo    ${PERFIL_ENDERECO}    ${endereco}

Salvar Perfil
    Scroll Element Into View    ${BOTAO_SALVAR_PERFIL}
    Click Element    ${BOTAO_SALVAR_PERFIL}

Verificar Dados Do Perfil Salvos
    [Documentation]    Recarrega a página, reabre a edição e confere que os dados persistiram.
    Acessar Perfil Do Fabricante
    Abrir Edicao Do Perfil
    Textfield Value Should Be    ${PERFIL_NOME}        ${PERFIL_NOME_TESTE}
    Textfield Value Should Be    ${PERFIL_EMAIL}       ${PERFIL_EMAIL_TESTE}
    Textfield Value Should Be    ${PERFIL_TELEFONE}    ${PERFIL_TEL_TESTE}
    Textfield Value Should Be    ${PERFIL_DOCUMENTO}   ${PERFIL_DOC_TESTE}
    Textfield Value Should Be    ${PERFIL_CEP}         ${PERFIL_CEP_TESTE}
    Textfield Value Should Be    ${PERFIL_CIDADE}      ${PERFIL_CIDADE_TESTE}
    Textfield Value Should Be    ${PERFIL_ESTADO}      ${PERFIL_ESTADO_TESTE}
    Textfield Value Should Be    ${PERFIL_ENDERECO}    ${PERFIL_ENDERECO_TESTE}

Restaurar Perfil Original
    [Documentation]    Devolve o perfil ao estado inicial para não quebrar o login (nem os
    ...    testes de outros integrantes) nas próximas execuções.
    [Arguments]    ${dados}
    Acessar Perfil Do Fabricante
    Abrir Edicao Do Perfil
    Preencher Perfil
    ...    ${dados}[nome]    ${dados}[email]    ${dados}[telefone]    ${dados}[documento]
    ...    ${dados}[cep]    ${dados}[cidade]    ${dados}[estado]    ${dados}[endereco]
    Salvar Perfil
    Run Keyword And Ignore Error    Tratar Mensagem Do Sistema    ${MSG_PERFIL_SALVO}

Apagar Nome E Email Do Perfil
    Input Text    ${PERFIL_NOME}     ${EMPTY}
    Input Text    ${PERFIL_EMAIL}    ${EMPTY}

Verificar Salvamento Bloqueado Por Campos Vazios
    [Documentation]    O Printly recusa o envio com um alerta nativo ("Nome e e-mail não podem
    ...    ficar vazios.") e permanece na tela de edição, sem redirecionar.
    Alert Should Be Present    ${MSG_PERFIL_VAZIO}    action=ACCEPT    timeout=10s
    Location Should Contain    editar-perfil-fabricante

Verificar Dados Do Perfil Nao Foram Alterados
    [Arguments]    ${nome_original}    ${email_original}
    Acessar Perfil Do Fabricante
    Abrir Edicao Do Perfil
    Textfield Value Should Be    ${PERFIL_NOME}     ${nome_original}
    Textfield Value Should Be    ${PERFIL_EMAIL}    ${email_original}

# ====================== CT11 / CT12: impressoras ======================
Contar Impressoras
    ${qtd}=    Get Element Count    css:#portfolioImpressoras .portfolio-item
    RETURN    ${qtd}

Contar Impressoras Do Modelo
    [Arguments]    ${modelo}
    ${qtd}=    Get Element Count
    ...    xpath://div[@id='portfolioImpressoras']//div[contains(@class,'portfolio-item')][contains(.,'${modelo}')]
    RETURN    ${qtd}

Abrir Formulario De Impressora
    Wait Until Element Is Visible    ${BOTAO_ADD_IMPRESSORA}    timeout=10s
    Execute Javascript    document.querySelector("button.btn-add-impressora[onclick='abrirModalImpressora()']").scrollIntoView({block: 'center'});
    Sleep    1s
    Click Element    ${BOTAO_ADD_IMPRESSORA}
    Wait Until Element Is Visible    ${MODAL_IMPRESSORA}    timeout=10s
    Wait Until Element Is Visible    ${IMP_MODELO}    timeout=10s
    Sleep    1s    # espera a animação (fade) do modal terminar

Preencher Impressora
    [Arguments]    ${modelo}    ${volume}    ${quantidade}    ${tipo}
    [Documentation]    Os tipos são checkboxes; ${tipo} aceita vários separados por vírgula (ex.: FDM,SLS).
    Wait Until Element Is Visible    ${IMP_MODELO}    timeout=10s
    Input Text    ${IMP_MODELO}        ${modelo}
    Input Text    ${IMP_VOLUME}        ${volume}
    Input Text    ${IMP_QUANTIDADE}    ${quantidade}
    Marcar Tipos De Impressora    ${tipo}

Marcar Tipos De Impressora
    [Arguments]    ${tipos}
    @{lista}=    Split String    ${tipos}    ,
    FOR    ${tipo}    IN    @{lista}
        ${tipo}=    Strip String    ${tipo}
        Select Checkbox    id:chk${tipo}
    END

Salvar Impressora
    Wait Until Element Is Visible    ${BOTAO_SALVAR_IMPRESSORA}    timeout=10s
    Click Element    ${BOTAO_SALVAR_IMPRESSORA}

Verificar Quantidade De Impressoras Do Modelo
    [Arguments]    ${modelo}    ${esperado}
    ${qtd}=    Contar Impressoras Do Modelo    ${modelo}
    Should Be Equal As Integers    ${qtd}    ${esperado}

Aguardar Impressoras Carregadas
    [Documentation]    O portfólio vem de um fetch assíncrono (buscar_portfolio.php): o HTML começa
    ...    com "Nenhuma impressora cadastrada." e o CNPJ como "Não informado". Quando o fetch
    ...    termina, o JS preenche o CNPJ da Maria (12.345.678/0001-90) e monta a lista.
    ...    Por isso espera o CNPJ aparecer, e NÃO um card de impressora: a Maria não tem
    ...    impressora no seed, então a lista pode legitimamente estar vazia.
    Wait Until Element Is Visible    ${BOTAO_ADD_IMPRESSORA}    timeout=10s
    Wait For Condition
    ...    return document.getElementById('portfolioCnpj').textContent.trim() !== 'Não informado';
    ...    timeout=15s

Excluir Impressoras Criadas No Teste
    [Documentation]    Limpeza do CT11: remove as impressoras do modelo informado que passaram
    ...    de ${total_antes} (a exclusão pede confirmação nativa, que é aceita).
    [Arguments]    ${modelo}    ${total_antes}
    ${agora}=    Contar Impressoras Do Modelo    ${modelo}
    ${extras}=    Evaluate    ${agora} - ${total_antes}
    FOR    ${i}    IN RANGE    ${extras}
        Click Element
        ...    xpath:(//div[@id='portfolioImpressoras']//div[contains(@class,'portfolio-item')][contains(.,'${modelo}')])[last()]//button[contains(@class,'btn-imp-excluir')]
        Handle Alert    action=ACCEPT    timeout=5s
        ${esperado}=    Evaluate    ${agora} - ${i} - 1
        Wait Until Keyword Succeeds    10s    500ms
        ...    Verificar Quantidade De Impressoras Do Modelo    ${modelo}    ${esperado}
    END

Verificar Alerta De Modelo Obrigatorio
    Alert Should Be Present    ${MSG_IMP_SEM_MODELO}    action=ACCEPT    timeout=10s
    Element Should Be Visible    ${MODAL_IMPRESSORA}

Verificar Impressora Nao Foi Salva
    [Documentation]    Confere, após recarregar, que nenhuma impressora nova foi gravada.
    [Arguments]    ${total_antes}
    Reload Page
    Aguardar Impressoras Carregadas
    ${depois}=    Contar Impressoras
    Should Be Equal As Integers    ${depois}    ${total_antes}
    ...    msg=Uma impressora foi gravada mesmo sem o campo Modelo.

# ====================== CT15: avaliação ======================
Abrir Meus Projetos
    Go To    ${URL_MEUS_PROJETOS}
    Wait Until Page Contains Element    css:.projeto-card    timeout=10s

Abrir Avaliacao Do Projeto
    Wait Until Element Is Visible    ${CARD_PROJETO_CONCLUIDO}    timeout=10s
    Scroll Element Into View    ${CARD_PROJETO_CONCLUIDO}
    Click Element    ${BOTAO_AVALIAR}
    # "Avaliar" leva à listagem de fabricantes e abre o portfólio do maker em um modal,
    # onde está o formulário de feedback (o modal abre ~800 ms depois do carregamento).
    Wait Until Location Contains    abrir_portfolio    timeout=10s
    Wait Until Element Is Visible    ${CAMPO_COMENTARIO}    timeout=15s

Marcar Estrelas
    [Arguments]    ${nota}
    Wait Until Element Is Visible    css:#rating-input i[data-nota='${nota}']    timeout=10s
    Scroll Element Into View    css:#rating-input i[data-nota='${nota}']
    Click Element    css:#rating-input i[data-nota='${nota}']
    Page Should Contain Element    css:#rating-input i.ativa[data-nota='${nota}']
    ${valor}=    Execute Javascript    return document.getElementById('nota-selecionada').value;
    Should Be Equal As Strings    ${valor}    ${nota}

Escrever Comentario Da Avaliacao
    [Arguments]    ${texto}
    Input Text    ${CAMPO_COMENTARIO}    ${texto}

Monitorar Mensagem De Feedback
    [Documentation]    Em enviarFeedback() o Printly escreve a mensagem em #form-feedback-msg e, na
    ...    MESMA execução síncrona, chama carregarAvaliacoesNoModal(), que remove a seção inteira
    ...    (formulário e mensagem). Quando um observer comum roda, a mensagem já saiu do DOM.
    ...    Por isso este observer lê os nós ADICIONADOS (mutation records), que continuam
    ...    acessíveis mesmo depois de removidos, e guarda o texto em window.__feedbackTexto
    ...    (classe "ok" ou "erro" em window.__feedbackClasse).
    Execute Javascript
    ...    window.__feedbackOk = false; window.__feedbackTexto = ''; window.__feedbackClasse = '';
    ...    if (window.__feedbackObs) { window.__feedbackObs.disconnect(); }
    ...    window.__feedbackObs = new MutationObserver(function (registros) {
    ...        registros.forEach(function (r) {
    ...            r.addedNodes.forEach(function (n) {
    ...                if (n.nodeType !== 1) { return; }
    ...                var el = n.classList && n.classList.contains('form-feedback-msg') ? n : n.querySelector('.form-feedback-msg');
    ...                if (el) {
    ...                    window.__feedbackTexto = el.textContent;
    ...                    window.__feedbackClasse = el.className;
    ...                    if (el.classList.contains('ok')) { window.__feedbackOk = true; }
    ...                }
    ...            });
    ...        });
    ...    });
    ...    window.__feedbackObs.observe(document.body, {childList: true, subtree: true});

Enviar Avaliacao
    Scroll Element Into View    ${BOTAO_ENVIAR_AVALIACAO}
    Monitorar Mensagem De Feedback
    Click Element    ${BOTAO_ENVIAR_AVALIACAO}

Verificar Avaliacao Registrada
    [Documentation]    Confere (1) que a mensagem de sucesso chegou a aparecer (capturada pelo
    ...    observer, pois a seção é recriada logo depois) e (2) que a avaliação passou a constar
    ...    na lista "Avaliações" do modal, com o comentário enviado.
    Wait For Condition    return window.__feedbackClasse !== '';    timeout=10s
    ${classe}=    Execute Javascript    return window.__feedbackClasse;
    ${texto}=    Execute Javascript    return window.__feedbackTexto;
    Should Contain    ${classe}    ok    msg=O sistema recusou o feedback: ${texto}
    ${texto}=    Execute Javascript    return window.__feedbackTexto;
    Should Contain    ${texto}    ${TEXTO_AVALIACAO_OK}
    Wait Until Element Contains    id:lista-avaliacoes    ${COMENTARIO_AVALIACAO}    timeout=10s
    Scroll Element Into View    id:lista-avaliacoes
