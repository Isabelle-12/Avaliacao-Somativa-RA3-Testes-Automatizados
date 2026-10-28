# 🧪 Avaliação Somativa RA3 - Testes Automatizados

![Python](https://img.shields.io/badge/Python-3.x-3776AB?logo=python&logoColor=white)
![Robot Framework](https://img.shields.io/badge/Robot%20Framework-7.x-000000?logo=robotframework&logoColor=white)
![Selenium](https://img.shields.io/badge/SeleniumLibrary-web%20tests-43B02A?logo=selenium&logoColor=white)

Automação de casos de teste do sistema **Printly** com **Robot Framework**, a partir do plano de testes elaborado no RA2.

---

## 📌 Contexto

Este repositório reúne a entrega do **RA3** da disciplina de **Verificação e Validação** (PUCPR), cujo objetivo é avaliar o resultado da execução do ciclo de vida de teste em produtos de software.

- **Atividade:** escolher e automatizar casos de teste do projeto do RA2.
- **Sistema testado:** Printly, um marketplace web desenvolvido em PHP, MySQL e Bootstrap 5.
- **Ferramenta:** Robot Framework com SeleniumLibrary.
- **Requisito mínimo:** 5 casos de teste automatizados por integrante.
- **Data de entrega:** 27/10/2026.

---

## 👥 Equipe

| Integrante | Pasta | Casos automatizados |
|---|---|---|
| Bruno | `bruno/` | C23, C16, C20, C8, C21 (cenários do plano) |
| Gabriela | `gabriela/` | CT9, CT10, CT11, CT12, CT15 |
| Isabelle | `isabelle/` | CT17, CT18, CT19, CT20, CT21 (casos do plano) |
| Laura | `laura/` | CT1, CT2, CT4, CT6, CT7 |
| Pedro | `pedro/` | CT25, CT27, CT29, CT30, CT31 |

> **Notação:** `CTxx` é o ID de um caso de teste do plano do RA2; `Cxx` é o número de um cenário do plano.

---

## 🗂️ Estrutura do repositório

```
Avaliacao-Somativa-RA3-Testes-Automatizados/
├── README.md
├── requirements.txt
├── bruno/
│   ├── resources.robot         # variáveis e keywords do integrante
│   ├── testes.robot            # casos de teste do integrante
│   └── resultados/
├── gabriela/                   # mesma estrutura
├── isabelle/
│   ├── resources.robot
│   ├── testes.robot
│   └── resultados/
│       ├── report.html
│       ├── log.html
│       ├── output.xml
│       ├── CT17_Evidencias/    # prints numerados por passo
│       ├── CT18_Evidencias/
│       ├── CT19_Evidencias/
│       ├── CT20_Evidencias/
│       └── CT21_Evidencias/
├── laura/                      # mesma estrutura
└── pedro/                      # mesma estrutura
```

Cada integrante tem uma **pasta independente e autocontida**. Regra do grupo: **cada pessoa altera apenas a própria pasta**. Isso evita conflitos de merge e garante que o trabalho de um integrante não afete o de outro.

---

## ⚙️ Pré-requisitos e instalação

- [Python 3](https://www.python.org/downloads/) (na instalação, marque **Add python.exe to PATH**)
- [Google Chrome](https://www.google.com/chrome/)
- [Git](https://git-scm.com/) ou GitHub Desktop
- [XAMPP](https://www.apachefriends.org/) (para executar o Printly localmente)

Instale as dependências a partir da raiz do repositório:

```bash
py -m pip install -r requirements.txt
```

Para conferir:

```bash
py -m robot --version
```

> **Windows:** usamos `py` no lugar de `python` para evitar problemas de PATH.
> Se o comando `robot` não for reconhecido, use sempre `py -m robot`.

---

## 🛒 Preparando o Printly

**Usuários de teste** (apenas dados fictícios; todos com a senha `123456`):

| Perfil | Nome | E-mail |
|---|---|---|
| Cliente | João Silva | `joao@email.com` |
| Maker | Maria Souza | `maria@email.com` |
| Maker (CaCa 3D) | Carlos Pereira | `carlos@email.com` |
| Maker | Bruno Maker Teste | `bruno.maker@teste.com` |
| Admin | Ana Martins | `ana.admin@email.com` |

**Dados que os testes da Isabelle pressupõem:**
- A maker **Maria** tem uma impressora FDM cadastrada (isso libera o material PETG no formulário).
- A maker **Carlos** (fabricante "CaCa 3D") tem materiais cadastrados (PETG, PLA e ABS).
- O cliente **João** é quem faz os pedidos.

> Se a porta 80 estiver ocupada, altere a porta do Apache no XAMPP e informe a nova URL
> na hora de executar os testes (veja a próxima seção).

---

## ▶️ Como executar os testes

Todos os comandos são executados **a partir da raiz do repositório**.

**Executar os testes de um integrante** (trocando `isabelle` pela sua pasta):

```bash
py -m robot --outputdir isabelle/resultados isabelle/testes.robot
```

**Executar apenas um caso ou grupo, por tag** (por exemplo, o CT17 ou todos os de pedido):

```bash
py -m robot --outputdir isabelle/resultados -i ct17 isabelle/testes.robot
py -m robot --outputdir isabelle/resultados -i pedido isabelle/testes.robot
```

> Os testes do Bruno não usam tags. Para executá-los, rode o arquivo inteiro
> (`py -m robot --outputdir bruno/resultados bruno/testes.robot`) ou um teste pelo nome, com `-t`.

---

## 🔢 Ordem de execução

A ordem de execução dos testes é a ordem em que eles aparecem no `testes.robot` de cada integrante: o Robot Framework executa de cima para baixo. Para respeitá-la, execute o arquivo inteiro do integrante (primeiro comando da seção anterior).

| Integrante | Arquivo | Ordem de execução | Dependências e observações |
|---|---|---|---|
| Bruno | `bruno/testes.robot` | C23 → C16 → C20 → C8 → C21 | - |
| Gabriela | `gabriela/testes.robot` | Ct09 → Ct10 → Ct11 → Ct12 → Ct15 | - |
| Isabelle | `isabelle/testes.robot` | CT17 → CT18 → CT19 → CT20 → CT21 | O **CT21 depende do CT19**: ele aceita o pedido pendente criado pelo CT19, que deve rodar antes. Os demais são independentes. |
| Laura | `laura/testes.robot` | CT1 → CT2 → CT4 → CT6 → CT7 | Independentes entre si: cada execução cria dados novos (e-mail e nome únicos). |
| Pedro | `pedro/testes.robot` | CT25 → CT27 → CT29 → CT30 → CT31 | Independentes entre si. Pressupõem que o cliente João tenha os projetos "Carrinho de Brinquedo" (com histórico), "Porta canetas" (Concluído, enviado em 27/10/2026) e "Caneca". |

Se for necessário executar apenas parte dos testes da Isabelle por tag, mantenha o CT19 junto do CT21:

```bash
py -m robot --outputdir isabelle/resultados -i ct19ORct21 isabelle/testes.robot
```

---

## 📊 Resultados

Após cada execução, a pasta `resultados/` do integrante contém:

| Arquivo | Conteúdo |
|---|---|
| `report.html` | Relatório resumido (aprovados, reprovados, tempo) |
| `log.html` | Log detalhado, passo a passo, com os prints de cada teste |
| `output.xml` | Saída em XML (usada para gerar os relatórios) |
| `CTxx_Evidencias/` | Prints numerados dos passos importantes de cada caso (ex.: `CT17_03_formulario_aberto.png`) e o print final do teste |

Para visualizar, abra o `report.html` ou o `log.html` no navegador.

---

## ✅ Casos de teste automatizados

Cada teste automatizado referencia o ID do caso (`CTxx`) ou o número do cenário (`Cxx`) do plano do RA2.

| ID (RA2) | Funcionalidade | Responsável | Tag | Resultado |
|---|---|---|---|---|
| C23 | Integridade de dados na transação de pedido: o fabricante altera o status do pedido para "Em produção" e o mesmo status é validado nos painéis do fabricante e do cliente | Bruno | — | ✅ Passou |
| C16 | Envio de mensagens entre cliente e fabricante: o cliente abre a conversa do pedido e valida que ela pode ser aberta | Bruno | — | ✅ Passou |
| C20 | Usabilidade do fluxo de solicitação de pedido: valida o comportamento do formulário de pedido incompleto | Bruno | — | ✅ Passou |
| C8 | Cliente envia avaliação sobre o fabricante, a partir do pedido em "Meus Pedidos" | Bruno | — | ✅ Passou |
| C21 | Proteção contra SQL Injection no login | Bruno | — | ✅ Passou |
| CT9 | Fabricante atualiza as informações do perfil e salva com sucesso | Gabriela | - | ✅ Passou |
| CT10 | Fabricante tenta salvar o perfil sem preencher nome e e-mail | Gabriela | - | ✅ Passou |
| CT11 | Fabricante adiciona uma nova impressora ao portfólio e salva com sucesso | Gabriela | - | ✅ Passou |
| CT12 | Fabricante tenta salvar uma impressora sem informar o modelo | Gabriela | - | ✅ Passou |
| CT15 | Cliente envia uma avaliação (nota e comentário) sobre o fabricante após a entrega | Gabriela | - | ✅ Passou |
| CT17 | Fabricante define o preço por grama de filamento e salva com sucesso (C9) | Isabelle | `ct17`, `material` | ✅ Passou |
| CT18 | Fabricante tenta inserir valor de material igual ou inferior a zero (C9) | Isabelle | `ct18`, `material` | ✅ Passou |
| CT19 | Cliente preenche todos os campos obrigatórios do pedido e confirma com sucesso (C10) | Isabelle | `ct19`, `pedido`, `defeito_conhecido` | ❌ Falha esperada (defeito da HU 22) |
| CT20 | Cliente tenta confirmar o pedido sem preencher campos obrigatórios (C10) | Isabelle | `ct20`, `pedido` | ✅ Passou |
| CT21 | Fabricante aceita um pedido e verifica se o status muda para "Em produção" (C11) | Isabelle | `ct21`, `pedido` | ✅ Passou |
| CT1 | Cadastrar cliente com todos os campos obrigatórios corretos (C1) | Laura | `ct1`, `cadastro` | ✅ Passou |
| CT2 | Tentar cadastrar cliente com e-mail já existente (C1) | Laura | `ct2`, `cadastro` | ✅ Passou |
| CT4 | Login com senha incorreta ou e-mail inexistente (C2) | Laura | `ct4`, `login` | ✅ Passou |
| CT6 | Solicitar ser fabricante sem informar o endereço (C3) | Laura | `ct6`, `maker`, `defeito_conhecido` | ❌ Falha esperada (defeito: aceita sem endereço) |
| CT7 | Administrador aprova cadastro de fabricante (C4) | Laura | `ct7`, `maker`, `admin` | ✅ Passou |
| CT25 | Cliente verifica o histórico de atualizações do pedido em ordem cronológica, com data, hora e descrição (C13) | Pedro | `ct25`, `projetos`, `historico` | ✅ Passou |
| CT27 | Cliente verifica nome, data de envio, status e miniatura na lista de "Meus Projetos" (C14) | Pedro | `ct27`, `projetos`, `defeito_conhecido` | ❌ Falha esperada (miniatura não exibida) |
| CT29 | Cliente filtra fabricantes por cidade/UF e vê apenas os da região (C15) | Pedro | `ct29`, `fabricantes`, `filtro` | ✅ Passou |
| CT30 | Cliente filtra uma região sem fabricantes e vê a mensagem de nenhum encontrado (C15) | Pedro | `ct30`, `fabricantes`, `filtro` | ✅ Passou |
| CT31 | Cliente envia mensagem ao fabricante e ela aparece com o horário do envio (C16) | Pedro | `ct31`, `chat` | ✅ Passou |

---

## 📐 Convenções do grupo

- **Pastas:** primeiro nome do integrante, em minúsculas e sem acento.
- **Nome dos testes:** `CTxx - Descrição do caso`, mantendo o ID do plano do RA2.
- **Tags:** uma por funcionalidade (ex.: `login`, `pedido`, `material`) e uma por caso (ex.: `ct17`).
- **Evidências:** uma pasta `CTxx_Evidencias` por caso, com prints numerados na ordem dos passos (`CTxx_01_descricao.png`).
- **Commits:** mensagens curtas, no imperativo, em português (ex.: `Adiciona testes de login`).
- **Fluxo no Git:** `pull` antes de começar e `push` ao terminar, alterando só a própria pasta.

---

## ⚠️ Limitações e observações

**Achados dos testes (Isabelle):**
- **CT19, defeito conhecido (HU 22, critério de aceite 1):** depois de enviar o pedido, o Printly redireciona direto
  para "Meus Projetos", sem exibir a confirmação com o resumo do pedido. O teste registra a falha de propósito e,
  em seguida, confere que o pedido foi criado.
- **CT17, observação:** o Printly permite cadastrar o mesmo material mais de uma vez, com os mesmos dados, sem aviso.
  Por isso o teste confere o resultado contando os cards antes e depois de salvar.
- **CT19, divergência com o plano:** o plano indica "sem partes personalizadas", mas o formulário exige ao menos uma
  parte; o teste adiciona uma.

**Achados dos testes (Laura):**
- **CT6, defeito conhecido (C3):** ao solicitar ser Maker, o Printly **não exige o endereço** e aceita a solicitação
  mesmo com o campo "Endereço da Empresa / Ateliê" em branco (o back-end só valida impressora e material). O teste
  registra a falha de propósito (o esperado seria o bloqueio) e, em seguida, confere o comportamento real: a mensagem
  de sucesso é exibida mesmo sem o endereço.
- **Alertas nativos (CT1, CT2, CT4):** as mensagens de cadastro e de login são janelas nativas do navegador, que o
  Selenium não fotografa; o texto de cada uma é validado e fica registrado no `log.html`.
- **Cliques no rodapé:** o checkbox de termos e o botão "Cadastrar" ficam no fim da página; os cliques são feitos via
  JavaScript (rolando até o centro) para evitar o erro "element click intercepted".

**Dados criados pelos testes (Laura):**
- O CT1, o CT6 e o CT7 cadastram um cliente novo (e-mail e nome únicos) a cada execução.
- O CT6 cria uma solicitação de Maker pendente; o CT7 cria outra solicitação e a aprova, tornando o cliente um Maker.

**Limitações da automação:**
- Aspectos visuais e de usabilidade não são avaliados pela automação e continuam dependendo de testes manuais
  (por exemplo, o contorno azul do campo vazio no CT20: o teste confere que o campo está inválido e com o foco).
- Alertas nativos do navegador (CT18 e CT21) não aparecem nos prints; o teste valida o texto deles e o registra no `log.html`.

**Dados criados pelos testes (Isabelle):**
- O CT17 cadastra um PETG novo a cada execução.
- O CT19 cria um pedido novo a cada execução, e o CT21 o consome ao aceitá-lo.

**Achados dos testes (Pedro):**
- **CT27, defeito conhecido (C14):** a listagem de "Meus Projetos" exibe nome, data de envio e status, mas não exibe a
  miniatura do projeto (aparece só o ícone de pasta). O teste registra a falha de propósito.
- **CT27, divergência com o plano:** o plano indica o projeto "Porta Canetas", enviado em 20/09/2026; no banco usado
  na automação o projeto se chama "Porta canetas" e foi enviado em 27/10/2026. O teste valida os dados reais.
- **CT31:** grava uma mensagem nova no chat do projeto "Caneca" a cada execução.
- Os projetos usados no testes feitos pelo Pedro não estão no `printly.sql`; precisam existir na conta do cliente João.


**Outros:**
- Os testes dependem do Printly rodando localmente e dos dados de teste importados.

---

## 📦 Entrega

A entrega é feita em **um único arquivo `.zip`**, enviado ao professor até **27/10/2026**.

**Conteúdo do zip:**
- `README.md` e `requirements.txt`;
- a pasta de cada integrante (`bruno/`, `gabriela/`, `isabelle/`, `laura/` e `pedro/`), com `resources.robot`,
  `testes.robot` e `resultados/` (relatórios, logs, XML e evidências em prints).

---

## 🎓 Créditos

Projeto acadêmico desenvolvido na PUCPR, na disciplina de Verificação e Validação.
