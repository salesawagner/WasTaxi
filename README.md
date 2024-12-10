# Quero ser Itau

Fala reviwer, tudo bem? Aqui está o projeto para o desafio. Para setup e gerenciamento do projeto eu utilizei algumas ferramentas como o `XcodeGen`, `Cocopods` e `Swiftlint` para facilitar no desenvolvimento, evitar conflitos e código mais limpo(lint). Optei por não colocar os arquivos de projeto(`.xcworkspace`, `.xcodeproj` etc...) e pods no `.gitignore` propositalmente para facilitar a execução dos projetos pra vcs. ;) 

Se houver alguma dificuldade para executor os projetos, na guia **START** tem o passo a passo de como fazer o setup dos projetos. 

![Swift](https://img.shields.io/badge/Swift-5.0-orange)
![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen)
![Xcode Version](https://img.shields.io/badge/Xcode-16-blue)
![iOS Version](https://img.shields.io/badge/iOS-17.0-blue)

# Requerimentos
- **XcodeGen** ([https://github.com/yonaskolb/XcodeGen](https://github.com/yonaskolb/XcodeGen))</br>
Utilizei o XcodeGen para evitar conflitos com os arquivos `.xcodeproj`

- **Cocoapods** ([https://cocoapods.org](https://cocoapods.org))</br>
Utilizado para gerenciamento de dependencias

- **Swiftlint** ([https://github.com/realm/SwiftLint](https://github.com/realm/SwiftLint))

# Start
### - API  
Responsável pelas tratativas de request e response do APP: [API.xcworkspace](API/API.xcworkspace). Para fazer o setup basta ir na pasta [API](API/) e rodar os comandos no terminal:

```
$  xcodegen generate
$  pod install
```

Abrir o arquivo: [API.xcworkspace](API/API.xcworkspace)

### - APP  
Responsável pela aplicação UI: [challange.xcworkspace](APP/challange.xcworkspace). Para fazer o setup basta ir na pasta [APP](APP/) e rodar os comandos no terminal:

```
$  xcodegen generate
$  pod install
```

Abrir o arquivo: [challenge.xcworkspace](APP/challenge.xcworkspace)