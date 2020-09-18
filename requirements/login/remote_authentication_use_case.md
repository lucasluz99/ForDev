# Remote Authentication Use Case

## Caso de sucesso
1. OK - Sistema valida os dados
2. OK - Sistema faz uma requisição para a URL da API de login
3. Sistema valida os dados recebidos da API
4. Sistema entrega os dados da conta do usuário

## Exceção - URL inválida
1. OK - Sistema retorna uma mesagem de erro inesperado

## Execeção - Dados inválidos
1. OK - Sistema retorna uma mensagem de erro inesperado

## Execeção - Resposta inválida
1. Sistema retorna uma mensagem de erro inesperado

## Execeção - Falha no servidor
1. Sistema retorna uma mensagem de erro inesperado

## Execeção - Credenciais inválidas
1. Sistema retorna uma mensagem de erro inesperado informando que as credenciais estão erradas