# Hardware Pong 🎮⚡

Um jogo do clássico **Pong** desenvolvido em **Verilog**, voltado para plataformas FPGA. Dois jogadores controlam as "raquetes" em um embate dinâmico, com movimentação, colisões e contagem de pontos implementados via lógica digital.

## 📚 Visão Geral

Este projeto implementa uma versão funcional do Pong utilizando a linguagem de descrição de hardware **Verilog**, com foco no uso em **FPGAs**. Foi desenvolvido para a disciplina de Circuitos Digitais e testado em ambiente de prototipagem.

## 🚀 Funcionalidades

- 🎮 **Movimentação das Raquetes**: Jogadores controlam as raquetes usando botões físicos, com limites de movimento definidos.
- 🟡 **Colisões Dinâmicas**: A bola rebate nas bordas e nas raquetes com lógica precisa de colisão.
- 🧠 **Contador de Pontos**: Sempre que um jogador deixa a bola passar, o adversário pontua.
- 💡 **Lógica Digital Real**: Implementação usando contadores, registradores, flip-flops e FSMs (máquinas de estados finitos).

## 🛠 Estrutura do Projeto

- `pong.v`: Lógica principal do jogo (movimentação, colisões, pontuação).
- `controlador.v`: Controla os sinais dos jogadores.
- `placar.v`: Módulo de contagem e exibição de pontos.
- `top_module.v`: Integração dos módulos para a simulação em FPGA.
- `testbench.v`: Testbench para simulação.

## 📦 Como Executar

### 🔗 1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/hardware-pong.git
cd hardware-pong
```
### 🛠 2. Abra o projeto

Abra os arquivos `.v` com sua IDE ou ferramenta de simulação HDL favorita, como:

- ModelSim  
- Quartus Prime (Intel)  
- Vivado (Xilinx)  
- GTKWave + Icarus Verilog (alternativa open-source)

### ▶️ 3. Compile e simule

Compile todos os arquivos do projeto, garantindo que `top_module.v` seja o módulo top-level. Em seguida, execute a simulação com `testbench.v` para verificar o comportamento do jogo.

```bash
# Exemplo usando Icarus Verilog
iverilog -o pong_sim *.v
vvp pong_sim
gtkwave dump.vcd
```
### ⚙️ 4. (Opcional) Sintetize para FPGA

Caso deseje rodar o jogo em uma FPGA física, adapte os pinos de entrada/saída no `top_module.v` conforme o mapeamento da sua placa. Certifique-se de conectar os seguintes elementos:

- **Entradas**: botões físicos que controlam as raquetes (por exemplo: `btn_up_p1`, `btn_down_p1`, `btn_up_p2`, `btn_down_p2`)
- **Saídas**: sinais VGA (para exibição gráfica) ou displays/LEDs para o placar

> 💡 A lógica foi escrita de forma modular, facilitando a portabilidade entre diferentes plataformas.

---

## 📌 Requisitos

- Verilog HDL
- Simulador HDL (ex: ModelSim, Icarus Verilog, Quartus Prime)
- (Opcional) Placa FPGA com suporte a VGA e entradas digitais

---

## 🎯 Objetivos de Aprendizado

Com este projeto, é possível:

- desenvolver FSMs (Finite State Machines)
- utilizar flip-flops, registradores e contadores
- aplicar conceitos de clock, sincronização e tempo de resposta
- integrar múltiplos módulos de hardware em um sistema coeso

---

## ✨ Resultado Esperado

O `hardware-pong` entrega uma experiência interativa, divertida e educativa, sendo ideal para consolidar o aprendizado de lógica digital e sistemas embarcados. Os jogadores podem interagir em tempo real por meio de botões físicos, enquanto o circuito se encarrega de renderizar e controlar o jogo com precisão.

> ✅ Simples, didático e visual. Ideal para reforçar conceitos de hardware com um toque de diversão.

---

## 📸 Imagens e Demonstrações

> *(Adicione aqui capturas de tela da simulação no GTKWave ou vídeos/fotos rodando na FPGA)*

---

## 📜 Licença

Distribuído sob a licença [MIT](LICENSE).  
Sinta-se à vontade para estudar, modificar, aprimorar e utilizar o projeto como desejar.

---

## 🤝 Contribuindo

Contribuições são bem-vindas!  
Abra uma *issue* com sugestões ou envie um *pull request* com melhorias.

---

🛠 Desenvolvido para a disciplina de **Circuitos Digitais** — Universidade Federal de Lavras (UFLA)  
👨‍💻 Autor: [Diego Oliveira](https://github.com/diegocodehub)
