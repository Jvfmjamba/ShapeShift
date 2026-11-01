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
- Backend Python (FastAPI) para intermediar as chamadas ao Google Gemini
- Google Gemini API (`gemini-2.5-flash`), acessada exclusivamente pelo backend

## Como rodar

### Backend

Requisitos: Python 3.10+ e uma chave de API do Gemini (https://aistudio.google.com/apikey).

1. Entre na pasta do backend:
   ```bash
   cd backend
   ```
2. Crie e ative um ambiente virtual:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   ```
   No Windows, use `.venv\\Scripts\\activate`.
3. Instale as dependências:
   ```bash
   pip install -r requirements.txt
   ```
4. Configure as variáveis de ambiente. Copie `.env.example` para `.env` e informe sua chave em `GEMINI_API_KEY`. O arquivo `.env` está ignorado pelo Git e não deve ser enviado ao repositório.
5. Inicie o servidor:
   ```bash
   uvicorn main:app --host 0.0.0.0 --port 8000
   ```

O endpoint de análise é `POST /analyze`. O endpoint `GET /health` verifica se o servidor está ativo.

### Aplicativo iOS

1. Abra o projeto no Xcode.
2. Em **Build Settings**, adicione uma configuração definida pelo usuário chamada `BACKEND_URL`, com a URL base do backend (por exemplo, `http://127.0.0.1:8000` para testar no simulador local).
3. Execute o aplicativo. A chave Gemini não deve ser adicionada ao projeto iOS: ela fica somente no ambiente do backend.

Para testar em um iPhone físico, use o endereço de rede ou domínio HTTPS do computador/servidor que executa o backend. Não use `127.0.0.1` no aparelho físico, pois esse endereço aponta para o próprio iPhone.

**Importante:** antes de disponibilizar o backend publicamente, implemente autenticação, limitação de requisições e controles de uso. O endpoint de exemplo ainda não inclui esses mecanismos e não deve ser publicado aberto à internet.

## Estrutura

```
App/          Ponto de entrada e container SwiftData
Models/       Modelos (UserProfile, Meals, FoodItem, DailyLog, ChecklistItem...)
ViewModels/   Estado do app
Views/        Telas (Home, Meals, Checklist, Profile, Onboarding)
Services/     Comunicação com o backend
Helpers/      Configuração da URL do backend
backend/      API Python que acessa o Gemini
```

## Autor

João Vitor Franca
