# Slither_Lua
Por josé
## Slither.io Single-Player
Slither_Lua e uma base para um jogo de arcade no estilo Slither.io, desenvolvido na linguagem de programação Luacom o framework de jogos 2D LÖVE. Este jogo oferece uma experiência de um jogador, onde o objetivo principal é controlar uma cobra, coletar alimentos e crescer, ao mesmo tempo que se evitam colisões.
## Love2D
LÖVE, frequentemente chamado de Love2D, é um framework de jogos de código aberto. Ele permite que desenvolvedores criem jogos 2D usando a linguagem de programação Lua. A principal vantagem de LÖVE é sua simplicidade e agilidade, pois ele abstrai as complexidades de renderização gráfica, áudio e entrada de dados, permitindo que o desenvolvedor se concentre na lógica do jogo.

## Como Jogar
O jogo é simples e segue a mecânica clássica do gênero Slither/Snake, mas com um toque moderno.
## Controles
Movimentação: Use as teclas de seta (Cima, Baixo, Esquerda, Direita) para guiar a cobra pela tela.
Aceleração: Pressione e segure a tecla Shift (esquerda ou direita) para acelerar.
Importante: A aceleração consome o corpo da sua cobra! Ao acelerar, você perde segmentos, diminuindo seu tamanho. Use essa habilidade com sabedoria.
## Objetivo do Jogo
Seu objetivo é coletar o máximo de alimentos possível. Cada alimento consumido aumenta sua pontuação e faz a cobra crescer. Quanto maior a cobra, mais difícil o jogo se torna, pois o risco de colidir com seu próprio corpo aumenta.

## Condições de Vitória e Derrota
Vitória: Não há uma condição de vitória final, pois o jogo se baseia em sobrevivência e pontuação máxima.
O objetivo é alcançar a maior pontuação possível.
## Derrota: O jogo termina quando a cabeça da sua cobra colide com:
As bordas da tela.
Qualquer parte do corpo da própria cobra.
## Técnica e Recursos
Gráficos: O jogo utiliza imagens (.png) para a cabeça da cobra, segmentos do corpo, alimentos e o fundo,
o que o torna visualmente mais agradável que um jogo de cobrinha tradicional com blocos simples.
Áudio: Possui efeitos sonoros básicos (.wav) para interações-chave, como o som de "comer" um alimento e o som de "morte".
Sistemas de Partículas: Para dar vida à experiência, o jogo usa sistemas de partículas para criar efeitos visuais dinâmicos.
Quando você come um alimento, partículas de "comida" são emitidas; quando a cobra morre, partículas de "morte" são geradas no local.
Placar (Score): O jogo acompanha sua pontuação em tempo real, exibindo-a no canto superior esquerdo da tela.

## Proposta
Este jogo é uma excelente demonstração de como o LÖVE pode ser usado para criar uma experiência de jogo simples,
mas envolvente, combinando mecânicas de jogo tradicionais com recursos gráficos e sonoros modernos.
