# Zet: Gestor de Orçamento

Aplicativo Flutter para controle de orçamento pessoal com funcionalidades completas de gestão financeira.

## Funcionalidades

- **Controle de Orçamento Mensal** - Defina seu salário e acompanhe gastos
- **Gerenciamento de Transações** - Adicione despesas e receitas com categorias
- **Proteção por Senha** - Oculte valores sensíveis com PIN
- **Dashboard Moderno** - Visualização rápida com gráficos de pizza
- **Categorias** - Classifique suas despesas (Alimentação, Transporte, Lazer, etc.)
- **Alertas de Orçamento** - Notificações quando atingir limites
- **Relatórios** - Exportação para PDF e Excel
- **Multi-idioma** - Suporte a PT-BR, EN, ES
- **Tema Escuro** - Suporte a tema claro/escuro

## Configuração do Projeto

### Pré-requisitos

- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+
- Android Studio / VS Code

### Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/zet_gestor_orcamento.git

# Entre no diretório
cd zet_gestor_orcamento

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

### Build para Release (Android)

```bash
# Limpe builds anteriores
flutter clean

# Instale dependências
flutter pub get

# Build release
flutter build appbundle --release
```

O arquivo AAB será gerado em: `build/app/outputs/bundle/release/app-release.aab`

## Assinatura do App

O app é assinado com um keystore específico para release. As configurações estão em:

- **Keystore**: `android/zet-upload-keystore.jks`
- **Properties**: `android/key.properties`
- **Alias**: `zet-upload`

### Importante sobre Segurança

⚠️ **Nunca commite keystores ou senhas no repositório!**

O keystore e arquivos de configuração estão ignorados no `.gitignore` por segurança.

Para criar um novo keystore:

```bash
keytool -genkeypair -v -storetype JKS -keyalg RSA -keysize 2048 \
  -validity 10000 \
  -keystore android/zet-upload-keystore.jks \
  -alias zet-upload \
  -keypass "SUA_SENHA_AQUI" \
  -storepass "SUA_SENHA_AQUI" \
  -dname "CN=Zet App, OU=Development, O=Zet, L=Sao Paulo, ST=SP, C=BR"
```

## Publicação na Google Play

### Certificado para Upload

O certificado SHA-256 para upload na Google Play:

```
SHA-256 (Base64): JY0/nXstrG1/SmVWFbHw81MeffWbF7bxi9dFgqbH60Q=
```

### Steps para Publicação

1. Acesse [Google Play Console](https://play.google.com/console)
2. Crie um novo app: "Zet: Gestor de Orçamento"
3. Configure:
   - **Package name**: `br.zet.gestororcamento`
   - **Versão**: 2.0.0
4. Faça upload do certificado SHA-256
5. Preencha descrição e screenshots
6. Configure política de privacidade
7. Envie para revisão

## Arquitetura

O app utiliza:

- **BLoC Pattern** para gerenciamento de estado
- **Isar Database** para armazenamento local
- **Repository Pattern** para acesso a dados
- **Clean Architecture** com separação clara entre UI e lógica

### Estrutura de Pastas

```
lib/
├── bloc/           # Business Logic Components
├── components/     # Componentes UI reutilizáveis
├── core/           # Configurações centrais
├── database/       # Camada de banco de dados
├── models/         # Modelos de dados
├── repository/     # Repositórios
├── screens/        # Telas do app
├── services/       # Serviços (alertas, exportação)
└── main.dart       # Entry point
```

## Contribuição

1. Fork o projeto
2. Crie sua branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Crie um Pull Request

## Licença

Este projeto está sob licença MIT.

## Contato

Para dúvidas ou sugestões, abra uma issue no GitHub.
