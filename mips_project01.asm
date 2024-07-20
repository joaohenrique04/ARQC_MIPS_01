.data
	# área para dados na memória principal
	
	## textos
	menu: 		.asciiz "Bem vindo!\nSelecione sua Operação:\n\n1 - Fahrenheit - > Celsius\n2 - Nº termo de Fibonnacci\n3 - N° número par\n4 - Sair\n\n=> "
	req_n: 		.asciiz "Vamos calcular o enérsimo termo de Fibonacci!\nQual termo deseja consultar? "
	ret_valor: 	.asciiz "O valor do enésimo termo é => "
	encerrando:	.asciiz "Encerrando programa..."
.text
	#área para instruiçciiz ões de programa
	
	sistema:	# praticamente a funcao principal, ira se repetir
	
		la 	$a0, menu	# atribui o menu no registrador
		jal 	imprimeString	# imprime o menu
			
		jal 	leInteiro	# le o retorno do usuario das opcoes do menu
		
		move	$s0, $v0	# guarda o retorno do usuário
		
		# usa a escolha do usuario para chamar a funcao correspondente
		# testa igualdade com branch on equal
    		#beq   	$s0, 1,                               
    		beq   	$s0, 2, fibonacci
    		#beq   	$s0, 3, 
    		beq  	$s0, 4, fechaPrograma
	
		j 	sistema 	# volta pro início
	
	## BLOCO DE FUNCOES DE UTILIDADE GERAL
	leInteiro:
		## função criada para ler valores inteiros de input
		
	 	li 	$v0, 5	# atribui 5 ao registrador (read int)
	 	syscall
	 	
	 	jr 	$ra		# retorna o valor
	 	
	imprimeInteiro:
		## função para imprimir o valor inteiro no registrador a0
		
		li 	$v0, 1	# atribui 1 ao registrador (print int)
		syscall 
		
		jr 	$ra		# retorna o valor
		
	imprimeString:
		## função para imprimir o valor de string no registrador a0
		
		li 	$v0, 4	# atribui 4 ao registrador (print string)
		syscall
		
		jr 	$ra		# retorna o valor
	 	
	pulaLinha: 
    		## função para pular linhas, apenas para organização visual
    		
    		li 	$a0, '\n'	# atribui o \n ao registrador
   		li 	$v0, 11	# atribui o print char ao registrador
    		syscall 

    		jr 	$ra 		# retorna o valor
	 	
	fechaPrograma:
		## função criada apenas para encerrar o programa
		la 	$a0, encerrando
		jal 	imprimeString 
		
		li 	$v0, 10	# atribui o syscall de saída
		syscall
		

	## BLOCO DE FUNCOES ESPECIFICAS
	fibonacci:
		la  	$a0, req_n	# carrega o endereço do texto no registrador
		jal 	imprimeString	# imprime o texto
	
	        jal 	leInteiro	# recebe input do usuário
		move	$s0, $v0	# guarda input do usuario no s0
	
		## definir valores iniciais (ambos são 1)
		li	$s1, 1
		li	$s2, 1
	
		## se o input for 1 ou 2, sempre vai ser 1 o resultado
		beq	$s0, 1, encerraFibonacci
		beq	$s0, 2, encerraFibonacci
		
		## senao...
		## será feito um loop n-2 (ja usamos 2 valores acima) vezes para chegar ao valor final
		addi	$s0, $s0, -2
		geraProximoValor:
			add	$s3, $s1, $s2 		# novo registrador com a soma dos 2 membros
			move	$s1, $s2		# s1 recebe o valor de s2
			move	$s2, $s3		# s2 recebe o valor de s3
			addi	$s0, $s0, -1		# decrementa o s0
			bgtz 	$s0, geraProximoValor	# instrucao que verifica nosso contador para saber se é maior que 0
	
		encerraFibonacci:
			# assim, o valor correto fica em $s2 sempre
			
			## printa frase final
			la	$a0, ret_valor
			jal 	imprimeString
		
			move	$a0, $s2	# coloca no registrador o nosso valor
			jal 	imprimeInteiro	# imprime noso valor
		
			jal 	pulaLinha	# pular linhas pra organizar
			jal 	pulaLinha
	
			j 	sistema		# volta ao sistema