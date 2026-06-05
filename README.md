# ZRD Despesas App

## Demo

[Acessar aplicacao](https://zrdespesas.reportzrd.com)

Aplicativo Flutter para controle de despesas pessoais com autenticacao via Supabase e isolamento de dados por usuario usando Row Level Security (RLS).

## Visao Geral

Projeto focado em:

- cadastro e login de usuarios
- emissao de despesas
- listagem de despesas do usuario logado
- cadastro categorias
- cadastro de formas de pagamento
- protecao de dados no banco com policies por usuario

Stack atual:

- Flutter
- Dart
- Supabase Auth
- Supabase Postgres
- Row Level Security (RLS)

## Funcionalidades

- autenticacao por email e senha
- roteamento inicial via `AuthGate`
- tela inicial com atalhos para modulos principais
- cadastro de despesa com:
  - data
  - descricao
  - categoria
  - forma de pagamento
  - valor
- listagem de despesas em ordem decrescente de data
- CRUD basico de categorias
- CRUD basico de formas de pagamento

## Fluxo de Autenticacao

O app inicializa o cliente Supabase em `lib/main.dart` e usa `AuthGate` para decidir:

- usuario autenticado -> `InicialPage`
- usuario nao autenticado -> `LoginPage`

O login e cadastro sao feitos por `AuthService`, encapsulando chamadas ao `supabase_flutter`.

## Banco de Dados e Seguranca

O projeto foi desenhado para usar RLS nas tabelas de dominio, com acesso restrito ao usuario que esta logado.

Tabelas principais:

- `usuarios`
- `categorias`
- `formas_pagamento`
- `despesas`

Regras esperadas:

- usuario autenticado so le os proprios dados
- usuario autenticado so insere registros ligados ao proprio `auth.uid()`
- usuario autenticado so atualiza/exclui registros proprios

Importante:

- seguranca real vem de RLS + policies corretas

## Dependencias Principais

Pacotes usados no projeto:

- `supabase_flutter`
- `intl`
- `flutter_localizations`

## Como Rodar

### 1. Instalar dependencias

```bash
flutter pub get
```

### 2. Rodar em desenvolvimento

```bash
flutter run
```

Para web:

```bash
flutter run -d chrome ou edge
```

### 3. Gerar build web

```bash
flutter build web
```

Para servir localmente a pasta usei python mesmo.

```bash
cd build/web
python -m http.server 1234 --bind 0.0.0.0
```

## Status

Projeto em evolucao, com foco atual em:

- consolidar CRUDs
- endurecer regras de acesso no banco
- melhorar UX das telas e validacoes
- adicionar imagens ao incluir despesa para dar um melhor contexto.
- adicionar filtros na hora de ver as despesas

## Obs

Projeto para aprendizado em flutter, dart e supabase.
