Feature: Login
Como um cliente
Quero poder acessar minha conta e me manter logado
Para que possa ver e responder enquetes de forma rápida

Cenário: Crendenciais Válidas
Dado que o cliente informou credenciais Válidas
Quando Solicitar para fazer o Login
Então o sistema deve enviar o usuário para a tela de pesquisas
E manter o usuário conectado

Cenário: Crenciais Inválidas
Dado que o cliente informou credenciais inválidas
Quando solicitar para fazer Login
Então o sistema deve retorna uma mensagem de erro