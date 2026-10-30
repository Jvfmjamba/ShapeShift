# ShapeShift

Aplicativo iOS para acompanhar alimentação, hábitos e progresso corporal. Você informa seus dados, registra refeições (com foto e descrição) e o app estima calorias e macronutrientes usando a API do Google Gemini.

## Funcionalidades

- **Onboarding:** cadastro de nome, idade, altura, peso atual, peso meta e sexo.
- **Meta calórica:** calculada automaticamente (fórmula de Mifflin-St Jeor) ou definida manualmente.
- **Início:** resumo de calorias consumidas no dia versus a meta e controle de hidratação (+250 ml).
- **Refeições:** registre uma refeição com foto e/ou descrição, clique em *Analisar com IA* e o app identifica cada alimento e estima quantidade, calorias, proteína, carboidratos e gordura. Os valores podem ser editados antes de salvar. Há também um resumo diário por data.
- **Hábitos:** checklist diário de hábitos.
- **Perfil:** visualização e edição dos seus dados.

## Tecnologias

- Swift e SwiftUI
- SwiftData (armazenamento local)
- Google Gemini API (`gemini-2.5-flash`)

## Como rodar

Requisitos: macOS com Xcode e uma chave de API do Gemini (obtenha em https://aistudio.google.com/apikey).

1. Clone o repositório:
   ```bash
   git clone https://github.com/Jvfmjamba/ShapeShift.git
   ```
2. Abra o projeto no Xcode.
3. Crie o arquivo `Secrets.xcconfig` (já está no `.gitignore`) com sua chave:
   ```
   GEMINI_API_KEY = sua_chave_aqui
   ```
4. Associe o `Secrets.xcconfig` à configuração do projeto (*Project → Info → Configurations*). O `Info.plist` lê a chave por `$(GEMINI_API_KEY)`.
5. Selecione um simulador ou dispositivo iOS e execute (⌘R).

Sem a chave, o app encerra ao tentar analisar uma refeição.

## Estrutura

```
App/          Ponto de entrada e container SwiftData
Models/       Modelos (UserProfile, Meals, FoodItem, DailyLog, ChecklistItem...)
ViewModels/   Estado do app
Views/        Telas (Home, Meals, Checklist, Profile, Onboarding)
Services/     Integração com o Gemini
Helpers/      Leitura da chave de API
```

## Autor

João Vitor Franca
