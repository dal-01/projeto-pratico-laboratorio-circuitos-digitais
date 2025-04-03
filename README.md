# Jogo em Verilog para Circuitos Digitais

## Introdução  
O projeto consiste na criação de um jogo para ser jogado por dois jogadores em uma plataforma FPGA. O jogo envolve a movimentação de dois retângulos, representando as raquetes, e uma bolinha que rebate nas raquetes e vai em direção ao campo do oponente. A lógica de movimentação, detecção de colisões e contagem de pontos foi implementada utilizando Verilog, uma linguagem de descrição de hardware. O projeto foi desenvolvido para ser simulado em plataformas de prototipagem de circuitos digitais.

## Descrição das Funções do Programa
- **Movimentação das Raquetes**: Implementa a lógica para controlar a movimentação dos dois retângulos (raquetes) que podem ser movidos pelos jogadores dentro de uma área determinada.  
- **Detecção de Colisões**: A bolinha rebate nas raquetes e muda de direção, indo em direção ao campo do oponente. A detecção de colisões foi implementada para garantir uma jogabilidade fluida.  
- **Contador de Pontos**: Implementa um sistema de contagem de pontos, onde cada vez que a bola atravessa o campo de um jogador, o ponto é contabilizado para o oponente.  
- **Simulação de Circuitos Digitais**: Todo o código foi desenvolvido em Verilog para ser simulado em uma FPGA, utilizando recursos de controle de hardware, como contadores e flip-flops.

## Conclusão  
O projeto foi bem-sucedido ao criar um jogo funcional que utiliza técnicas de **Verilog** para controle de hardware. Foi possível simular a movimentação de objetos e o processamento de eventos, como colisões e contagem de pontos, em uma **FPGA**. Além de aplicar conceitos de circuitos digitais, o projeto também foi uma oportunidade de aprendizado em relação ao uso de **FPGAs** e à lógica de controle de hardware. Essa experiência foi importante para o desenvolvimento das habilidades em **programação de hardware**, além de proporcionar um melhor entendimento sobre a implementação de sistemas em circuitos digitais e a interação entre software e hardware.
