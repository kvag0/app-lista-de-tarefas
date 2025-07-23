# Aplicativo de Lista de Tarefas em Flutter (Projeto 2)

Este projeto é a segunda parte de uma série de estudos de tech stacks. Trata-se de uma aplicação móvel, construída com **Flutter**, que funciona como o cliente (frontend) para a [API de Lista de Tarefas](https://github.com/kvag0/api-lista-de-tarefas) desenvolvida no Projeto 1.

O aplicativo conecta-se à API para buscar, exibir, criar e atualizar tarefas, oferecendo uma experiência de utilizador interativa e reativa.

---

## ✨ Funcionalidades

* **Listagem de Tarefas:** Exibe a lista de tarefas recebida da API.
* **Estado de Carregamento:** Mostra um indicador de progresso circular (`CircularProgressIndicator`) enquanto os dados estão a ser buscados.
* **Estado Vazio:** Exibe uma mensagem amigável quando não existem tarefas para serem mostradas.
* **Atualizar Tarefa (PUT):** Permite ao utilizador tocar numa tarefa para marcar/desmarcar como concluída, enviando um pedido `PUT` para a API e atualizando a UI.
* **Criar Tarefa (POST):** Através de um botão flutuante (`FloatingActionButton`), abre um diálogo (`AlertDialog`) que permite ao utilizador inserir o texto de uma nova tarefa e enviá-la para a API através de um pedido `POST`.

---

## 🛠️ Tech Stack & Ferramentas

* **Framework:** Flutter
* **Linguagem:** Dart
* **Pacotes Principais:**
    * `http`: Para realizar as chamadas HTTP para a nossa API REST.
* **Conceitos de Flutter Aplicados:**
    * Widgets Essenciais: `MaterialApp`, `Scaffold`, `AppBar`, `ListView.builder`, `ListTile`, `FloatingActionButton`, `AlertDialog`.
    * Gestão de Estado: Conversão de `StatelessWidget` para `StatefulWidget` para gerir o ciclo de vida dos dados.
    * Ciclo de Vida: Uso do `initState()` para buscar dados iniciais.
    * UI Reativa: Uso do `setState()` para reconstruir a interface após a chegada de novos dados.
    * Requisições Assíncronas: Uso de `async / await` para lidar com a comunicação de rede.

---

## ⚙️ Como Executar o Projeto Localmente

**Pré-requisitos:**
1.  Ter o [**Flutter SDK**](https://docs.flutter.dev/get-started/install) instalado.
2.  Ter um Simulador de iOS (com Xcode) ou Emulador de Android (com Android Studio) configurado e a correr.
3.  Ter a [**API do Projeto 1**](https://github.com/kvag0/api-lista-de-tarefas) a correr localmente na sua máquina.

**Passos:**

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/kvag0/app-lista-de-tarefas.git](https://github.com/kvag0/app-lista-de-tarefas.git)
    cd app-lista-de-tarefas
    ```

2.  **Instale as dependências do projeto:**
    ```bash
    flutter pub get
    ```

3.  **Configure o Endereço da API:**
    * **Importante:** Abra o ficheiro `lib/main.dart`.
    * Encontre as linhas que contêm `Uri.parse('http://192.168.1.103...')`.
    * Substitua o endereço de IP `192.168.1.103` pelo endereço de IP local da máquina onde a sua API do Projeto 1 está a correr.

4.  **Execute a aplicação:**
    ```bash
    flutter run
    ```
    Ou use a funcionalidade de "Run and Debug" (`F5`) do VScodium.
