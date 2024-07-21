.data
	# �rea para dados na mem�ria principal
	
	## textos
	menu: 			.asciiz "Bem vindo!\nSelecione sua Opera��o:\n\n1 - Fahrenheit - > Celsius\n2 - N� termo de Fibonnacci\n3 - N� n�mero par\n4 - Sair\n\n=> "
	
	entrada_conversor:	.asciiz "Vamos converter de Fahrenheit para Celsius!\nQual temperatura deseja consultar? (�F) "
	saida_conversor:	.asciiz "O valor da temperatura em Celsius � aproximadamente => "
	
	entrada_fibonacci: 	.asciiz "Vamos calcular o en�rsimo termo de Fibonacci!\nQual termo deseja consultar? "
	saida_fibonacci: 	.asciiz "O valor do en�simo termo � => "
	
	entrada_par:		.asciiz "Vamos calcular o valor do en�rsimo termo par!\nQual termo deseja consultar? "
	saida_par:		.asciiz "O valor do en�simo termo par � => "
	
	encerrando:		.asciiz "Encerrando programa..."
	
	## constante utilizada para arredondamento
	val_10: 		.float 10.0
.text
	#�rea para instru��es de programa
	
	sistema:	# praticamente a funcao principal, ira se repetir
	
		la 	$a0, menu		# atribui o menu no registrador
		jal 	imprimeString		# imprime o menu
				
		jal 	leInteiro		# le o retorno do usuario das opcoes do menu
		
		move	$s0, $v0		# guarda o retorno do usu�rio
		
		# usa a escolha do usuario para chamar a funcao correspondente
		# testa igualdade com beq ( branch on equal )
    		beq   	$s0, 1, converte	# se 1, chama converte          
    		beq   	$s0, 2, fibonacci	# se 2, chama fibonacci
    		beq   	$s0, 3, enesimoPar	# se 3, chama enesimoPar
    		beq  	$s0, 4, fechaPrograma	# se 4, fecha o programa
    		
		# qualquer outro valor...
		j 	sistema 		# volta pro in�cio
	
	## BLOCO DE FUNCOES DE UTILIDADE GERAL
	leInteiro:
		## fun��o criada para ler valores inteiros de input
		
	 	li 	$v0, 5	# atribui 5 ao registrador (read int)
	 	syscall
	 	
	 	jr 	$ra	# retorna o valor
	 	
	leFloat:
		## fun��o criada para ler valores flutuantes de input
		
	 	li 	$v0, 6	# atribui 6 ao registrador (read float)
	 	syscall
	 	
	 	jr 	$ra	# retorna o valor 	
	 	
	leString:
		## fun��o criada para ler valores string
		
		li	$v0, 8	# atribui 8 ao registrador (read string)
		syscall
		
		jr	$ra	# retorna o valor
	 	
	imprimeInteiro:
		## fun��o para imprimir o valor inteiro no registrador a0
		
		li 	$v0, 1	# atribui 1 ao registrador (print int)
		syscall 
		
		jr 	$ra	# retorna o valor
		
	imprimeFloat:
		## fun��o para imprimir o valor float no registrador f12
		
		li 	$v0, 2	# atribui 2 ao registrador (print float)
		syscall 
		
		jr 	$ra	# retorna o valor	
		
	imprimeString:
		## fun��o para imprimir o valor de string no registrador a0
		
		li 	$v0, 4	# atribui 4 ao registrador (print string)
		syscall
		
		jr 	$ra	# retorna o valor
		
	corrigeFloat:
		## fun��o para corre��o de int pra float
		
		mtc1	$t0, $f1	# move para o coprocessador 1 (FPU) para movermos o t0 para o f1 como float
		cvt.s.w $f1, $f1	# converter o valor (word) para precisao unica (evitar dizimas quebradas)
		
		jr 	$ra		# retorna o valor
		
	arredonda:
		## fun��o para arredondar nossos pontos flutuantes com 1 casa decimal
		
		l.s $f1, val_10         # carrega 10.0 em f1
    		mul.s $f2, $f0, $f1     # multiplica o valor em f0 por 10
    		round.w.s $f2, $f2      # arredonda o valor multiplcado para o inteiro mais proximo
    		cvt.s.w $f2, $f2        # converte o inteiro de volta para float
    		div.s $f0, $f2, $f1	# divide por 10 de novo (assim so ter� uma casa decimal)
		
		jr	$ra		# retorna o valor
		
	 	
	pulaLinha: 
    		## fun��o para pular linhas, apenas para organiza��o visual
    		
    		li 	$a0, '\n'	# atribui o \n ao registrador
   		li 	$v0, 11		# atribui 11 ao registrador (print char)
    		syscall 

    		jr 	$ra 		# retorna o valor

	encerraSubPrograma:
		## fun��o criada para encapsular a parte final dos subprogramas, evitando repeticao de codigo
		
		jal 	pulaLinha	# pular linhas pra organizar
		jal	leString	# organizar aguardando valor
		jal 	pulaLinha	# pular linhas pra organizar
	
		j 	sistema		# volta ao sistema
	 	
	fechaPrograma:
		## fun��o criada apenas para encerrar o programa
		
		la 	$a0, encerrando	# atribui o texto de encerramento ao registrador
		jal 	imprimeString 	# imprime
		
		li 	$v0, 10		# atribui o syscall de sa�da
		syscall
		

	## BLOCO DE FUNCOES ESPECIFICAS
	converte:
		la	$a0, entrada_conversor	# carrega o endere�o do texto de entrada no registrador
		jal	imprimeString		# imprime o texto
		
		jal	leFloat			# recebe input do usuario
		
		aplicaFormula:	# organiza��o
			li	$t0, 32			# guarda o valor 32 em t0
			jal 	corrigeFloat		# coloca nosso valor inteiro como aceitavel para operacao float em f1
			sub.s	$f0, $f0, $f1		# f0 recebe o valor subtraido por 32
		
			li	$t0, 5			# guarda o valor 5 em t0
			jal	corrigeFloat		# coloca nosso valor inteiro como aceitavel para operacao float em f1
			mul.s	$f0, $f0, $f1		# multiplica o valor em f0 por 5	
				
			li	$t0, 9			# guarda o valor 9 em t0
			jal	corrigeFloat		# coloca nosso valor inteiro como aceitavel para operacao float em f1
			div.s	$f0, $f0, $f1		# divide o valor em f0 por 9
			
			jal 	arredonda		# funcao para arredondar e melhorar exibi��o
			
			mov.s 	$f12, $f0		# move nosso valor para o f12 que sera usado na sa�da
			
		encerraConversao: # organiza��o
			# assim, o valor final est� em $f0
			
			## printa frase final
			la	$a0, saida_conversor
			jal	imprimeString
			
			move	$a0, $s0	# move para o registrador o nosso valor final
			jal	imprimeFloat	# imprime o valor
			
		jal	encerraSubPrograma	
	
	fibonacci:
		la  	$a0, entrada_fibonacci	# carrega o endere�o do texto de entrada no registrador
		jal	imprimeString		# imprime o texto
	
		jal	leInteiro		# recebe input do usu�rio
		move	$s0, $v0		# guarda input do usuario no s0
	
		## definir valores iniciais (ambos s�o 1)
		li	$s1, 1
		li	$s2, 1
	
		## se o input for 1 ou 2, sempre vai ser 1 o resultado
		beq	$s0, 1, encerraFibonacci	# pulamos para o encerramento
		beq	$s0, 2, encerraFibonacci	# pulamos para o encerramento
		
		## senao...
		## ser� feito um loop n-2 (ja usamos 2 valores acima) vezes para chegar ao valor final
		addi	$s0, $s0, -2
		geraProximoValor:
			add	$s3, $s1, $s2 		# novo registrador com a soma dos 2 membros
			move	$s1, $s2		# s1 recebe o valor de s2
			move	$s2, $s3		# s2 recebe o valor de s3
			addi	$s0, $s0, -1		# decrementa o s0
			bgtz  	$s0, geraProximoValor	# instrucao que verifica nosso contador para saber se � maior que 0
							 # bgtz = segue o caminho se for maior que zero
	
		encerraFibonacci:
			# assim, o valor correto fica em $s2 sempre
			
			## printa frase final
			la	$a0, saida_fibonacci
			jal 	imprimeString
		
			move	$a0, $s2	# coloca no registrador o nosso valor
			jal 	imprimeInteiro	# imprime noso valor
			
		jal	encerraSubPrograma
		
	enesimoPar:
		la  	$a0, entrada_par	# carrega o endere�o do texto de entrada no registrador
		jal	imprimeString		# imprime o texto
	
		jal	leInteiro		# recebe input do usu�rio
		move	$s0, $v0		# guarda input do usuario no s0
		
		geraTermo: 	# organiza��o
			li	$s1, 2			# guarda 2 no registrador s1
			mult  	$s0, $s1		# multiplica o input por 2 pra gerar o enesimo termo
			mflo	$s0			# move o valor que fica no LO para nosso registrador
							 # esse valor fica no LO nessas multiplicaoes pois sao o LOwer bits,
							 # menos significativos

		finalizaTermo:	# organiza��o
		
			## printa frase final
			la	$a0, saida_fibonacci
			jal 	imprimeString
		
			move	$a0, $s0	# coloca no registrador o nosso valor
			jal 	imprimeInteiro	# imprime nosso valor
		
	
		jal	encerraSubPrograma