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

---

## 👥 Equipe

| Integrante | Pasta | Casos automatizados |
|---|---|---|
| Bruno       | `bruno/`    | COMPLETAR |
| Gabriela    | `gabriela/` | COMPLETAR |
| Isabelle    | `isabelle/` | COMPLETAR |
| Laura       | `laura/`    | COMPLETAR |
| Pedro       | `pedro/`    | COMPLETAR |

---

## 🗂️ Estrutura do repositório

```
Avaliacao-Somativa-RA3-Testes-Automatizados/
├── README.md
├── requirements.txt
├── isabelle/
│   ├── resources.robot     # variáveis e keywords do integrante
│   ├── testes.robot        # casos de teste do integrante
│   └── resultados/         # report.html, log.html, output.xml e prints
├── [integrante2]/
│   ├── resources.robot
│   ├── testes.robot
│   └── resultados/
└── ...
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

Os testes só funcionam com o sistema no ar.

1. Inicie **Apache** e **MySQL** no painel do XAMPP.
2. Coloque o projeto Printly em: `COMPLETAR (ex.: pasta htdocs do XAMPP)`
3. Importe o banco de dados: `COMPLETAR (nome do banco e arquivo .sql)`
4. Importe os dados de teste: `COMPLETAR (script SQL com os usuários e registros usados nos testes)`
5. Acesse no navegador: `COMPLETAR (URL, ex.: http://localhost/printly/)`

**Usuários de teste** (apenas dados fictícios):

| Perfil | Usuário/E-mail | Senha |
|---|---|---|
| Cliente | COMPLETAR | COMPLETAR |
| Maker | COMPLETAR | COMPLETAR |

> Se a porta 80 estiver ocupada, altere a porta do Apache no XAMPP e informe a nova URL
> na hora de executar os testes (veja a próxima seção).

---

## ▶️ Como executar os testes

Todos os comandos são executados **a partir da raiz do repositório**.

**Executar os testes de um integrante** (trocando `isabelle` pela sua pasta):

```bash
py -m robot --outputdir isabelle/resultados isabelle/testes.robot
```

Para executar especificamente os testes do Bruno no Windows, também é possível
usar o arquivo `bruno\executar_testes.bat`. Os relatórios, logs, XML e capturas
serão gerados automaticamente em `bruno\resultados`:

```bat
bruno\executar_testes.bat
```

**Executar apenas uma tag** (por exemplo, `login`):

```bash
py -m robot --outputdir isabelle/resultados -i login isabelle/testes.robot
```

**Executar com outra URL** (por exemplo, outra porta do XAMPP):

```bash
py -m robot --outputdir isabelle/resultados -v URL:http://localhost:8080/printly/ isabelle/testes.robot
```

---

## 📊 Resultados

Após cada execução, a pasta `resultados/` do integrante contém:

| Arquivo | Conteúdo |
|---|---|
| `report.html` | Relatório resumido (aprovados, reprovados, tempo) |
| `log.html` | Log detalhado, passo a passo, com os prints de cada teste |
| `output.xml` | Saída em XML (usada para gerar os relatórios) |
| `selenium-screenshot-*.png` | Capturas de tela ao final de cada teste |

Para visualizar, abra o `report.html` ou o `log.html` no navegador.

---

## ✅ Casos de teste automatizados

Cada teste automatizado referencia o ID do caso de teste do plano do RA2.

| ID (RA2) | Funcionalidade | Responsável | Tag | Resultado |
|---|---|---|---|---|
| COMPLETAR | COMPLETAR | COMPLETAR | COMPLETAR | COMPLETAR |

---

## 📐 Convenções do grupo

- **Pastas:** primeiro nome do integrante, em minúsculas e sem acento.
- **Nome dos testes:** `CTxx - Descrição do caso`, mantendo o ID do plano do RA2.
- **Tags:** uma por funcionalidade (ex.: `login`, `pedido`, `portfolio`).
- **Commits:** mensagens curtas, no imperativo, em português (ex.: `Adiciona testes de login`).
- **Fluxo no Git:** `pull` antes de começar e `push` ao terminar, alterando só a própria pasta.

---

## ⚠️ Limitações e observações

- Aspectos visuais e de usabilidade não são avaliados pela automação e continuam
  dependendo de testes manuais.
- Os testes dependem do Printly rodando localmente e dos dados de teste importados.
- `COMPLETAR`: casos do plano do RA2 que não foram automatizados e o motivo.

---

## 📦 Entrega

`COMPLETAR` (formato e contéudo do zip, após confirmação com o professor).

---

## 🎓 Créditos

Projeto acadêmico desenvolvido na PUCPR, na disciplina de Verificação e Validação.
