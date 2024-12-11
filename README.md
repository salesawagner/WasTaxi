# Desafio iOS 🚀

Olá, reviewer! Tudo certo? Este é o projeto desenvolvido para o desafio. Abaixo, você encontrará detalhes sobre o setup e gerenciamento utilizados no desenvolvimento, além de instruções para facilitar a execução.

## Ferramentas Utilizadas

Para organizar e simplificar o desenvolvimento, empreguei as seguintes ferramentas:

- **XcodeGen**: Geração automatizada do arquivo `.xcodeproj` para evitar conflitos de versão.
- **Cocoapods**: Gerenciamento de dependências do projeto.
- **SwiftLint**: Garantia de código mais limpo e padronizado.

**Nota:** Optei por não adicionar os arquivos de projeto (`.xcworkspace`, `.xcodeproj`, etc.) e os Pods ao `.gitignore`. Isso foi feito propositalmente para facilitar a execução do projeto por vocês. 😉

Caso encontre alguma dificuldade, consulte a seção **Início Rápido** abaixo, onde detalho o passo a passo para configurar o projeto.

---

![Swift](https://img.shields.io/badge/Swift-5.0-orange)  
![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen)  
![Xcode Version](https://img.shields.io/badge/Xcode-16-blue)  
![iOS Version](https://img.shields.io/badge/iOS-17.0-blue)  

---

## Requisitos

Certifique-se de ter as seguintes ferramentas instaladas:

- **[XcodeGen](https://github.com/yonaskolb/XcodeGen)**  
  Utilizado para evitar conflitos com o arquivo `.xcodeproj`.  

- **[Cocoapods](https://cocoapods.org)**  
  Ferramenta para gerenciamento de dependências.  

- **[SwiftLint](https://github.com/realm/SwiftLint)**  
  Ferramenta para análise e padronização de código.  

---

## Início Rápido 🚀

### Configuração da API

A pasta **API** contém os arquivos relacionados ao tratamento de requisições e respostas do aplicativo.  

#### Passos para configuração:
1. Navegue até a pasta `API`:
    ```bash
    cd API
    ```
2. Execute os seguintes comandos no terminal:
    ```bash
    xcodegen generate
    pod install
    ```
3. Abra o workspace gerado:  
   [API.xcworkspace](API/API.xcworkspace)

---

### Configuração do APP

A pasta **APP** contém os arquivos responsáveis pela interface do usuário.  

#### Passos para configuração:
1. Navegue até a pasta `APP`:
    ```bash
    cd APP
    ```
2. Execute os seguintes comandos no terminal:
    ```bash
    xcodegen generate
    pod install
    ```
3. Abra o workspace gerado:  
   [challenge.xcworkspace](APP/challenge.xcworkspace)

---

Se precisar de qualquer ajuda ou esclarecimento, não hesite em entrar em contato! 😊

📧 **Email**: salesawagner@gmail.com