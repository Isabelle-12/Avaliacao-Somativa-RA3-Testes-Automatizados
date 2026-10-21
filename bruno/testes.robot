*** Settings ***
Resource    resources.robot
Test Teardown    Fechar Navegador Bruno

*** Test Cases ***
C23 - Integridade De Dados Na Transacao De Pedido
    Abrir Navegador Bruno
    Abrir Tela De Login Bruno
    Logar Como Fabricante Bruno
    Abrir Gerenciamento De Pedidos Bruno
    Alterar Status Do Pedido Para Em Producao Bruno
    Validar Status No Painel Do Fabricante Bruno
    Sair Do Sistema Bruno
    Logar Como Cliente Bruno
    Acessar Meus Pedidos Bruno
    Validar Status No Painel Do Cliente Bruno

C16 - Envio De Mensagens Entre Cliente E Fabricante
    Abrir Navegador Bruno
    Abrir Tela De Login Bruno
    Logar Como Cliente Bruno
    Acessar Meus Pedidos Bruno
    Abrir Conversa Do Pedido Bruno
    Validar Se Pode Abrir Conversa Bruno

C20 - Usabilidade Do Fluxo De Solicitacao De Pedido
    Abrir Navegador Bruno
    Abrir Tela De Login Bruno
    Logar Como Cliente Bruno
    Abrir Formulario De Pedido C20 Bruno
    Validar Formulario Incompleto C20 Bruno

C8 - Cliente Envia Avaliacao Sobre O Fabricante
    Abrir Navegador Bruno
    Abrir Tela De Login Bruno
    Logar Como Cliente Bruno
    Acessar Meus Pedidos Bruno
    Avaliar Pedido Bruno

C21 - Protecao Contra SQL Injection No Login
    Abrir Navegador Bruno
    Abrir Tela De Login Bruno
    Tentar Login Com SQL Injection Bruno
