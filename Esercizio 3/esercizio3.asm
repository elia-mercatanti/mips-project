# Title: Esercizio 3 - Conversione da Binario a Naturale
# Authors: Bucciero Samuele, Mercatanti Elia, Pinto Andrea
# E-mails: samuele.bucciero@gmail.com, eliamercatanti@yahoo.it, andrea.pinto1@stud.unifi.it
# Date: 31/08/2014

################################## Data segment #####################################################################################################################

.data

	head:			.asciiz "Esercizio 3 - Convertitore di Stringhe da Binario in Decimale.\n"
	insert:			.asciiz "\nInserire il carattere: "
	err:			.asciiz	"\n\nIl carattere inserito e' errato, si prega di inserirne un altro."
	maxLimitReach:	.asciiz "\n\nHai inserito il numero massimo di elementi, procedo con il convertire il numero in decimale"
	binary:			.asciiz "\n\nBinario puro: ["
	closeQ:			.asciiz "]"
	decimal:		.asciiz "\nNumero decimale: "	
	arrayB:			.byte 0:10

################################## Code segment #####################################################################################################################

.text
.globl main 

main: 
	
	li $s0, -1 		# s0 contiene il numero massimo di elementi meno uno
	li $s1, 0 		# s1 viene utilizzato per caricare il risultato della conversione
	li $s2, 0		# s2 viene utilizzato per scorrere il vettore
	li $a1, 0		# a1 viene utilizzato per scorrere il vettore
	la $a0, head	     
	li $v0, 4		
	syscall
	
input:						
	beq $s0, 9, maxLimit 	# controlla se è possibile inserire ulteriori caratteri, nel caso passa all'etichetta "maxLimit"
	la $a0, insert			# stampa la stringa "insert"
	li $v0, 4
	syscall
	li $v0, 12				# legge il carattere in input
	syscall
	jal inputController		# controlla se il carattere inserito è accettabile
	addi $v0, $v0, -48		# essendo $v0 è un carattere, al suo interno è memorizzato il codice ascii di '0' e '1'. Sottraendo 48 si ottiene, appunto, '0' o '1'
	addi $s0, $s0, 1		# incremento il numero di elementi inseriti
	sb $v0, arrayB($s2)		# memorizzo il carattere all'interno di un vettore
	addi $s2, $s2, 1		# incremento l'indirizzo di base del vettore
	j input					# ripeto il ciclo input

inputController:			# funzione per controllare che il contenuto di $v0 puo' essere accettato o meno
	beq $v0, 48, inputOk	# se il contenuto di $v0 è uguale a 48 (=0) l'inserimento è corretto
	beq $v0, 49, inputOk	# se il contenuto di $v0 è uguale a 49 (=1) l'inserimento è corretto
	beq $v0, 120, inputEnd	# se il contenuto di $v0 è uguale a 120 (=x) l'inserimento è corretto e l'input viene interrotto

inputErr:					
	la $a0, err				# stampa la stringa "err"
	li $v0, 4
	syscall
	j input					# ritorna ad 'input'
	
inputOk:				#se l'inserimento e' OK, non ci sono problemi e si ritorna all'etichetta input
	jr $ra			
	
maxLimit:
	la $a0, maxLimitReach	#stampa la stringa "maxLimitReach"
	li $v0, 4
	syscall
	
inputEnd:
	jal conversion		# viene chiamata la funzione conversion
	j printBinary		# salto all'etichetta printBinary
	
conversion:					#funzione necessaria per convertire il numero da binario a decimale
	addi $sp, $sp, -4		# push sullo stack per salvare le variabili
	sw $ra, 0($sp)			# salvo $ra per il ritorno
	lb $a3, arrayB($a1) 	# salvo il contenuto di v[k] in $a3
	beq $a1, $s0, prereturn	# controllo se siamo arrivati all'ultimo elemento del vettore, nel caso passa all'etichetta "prereturn"
	sub $a2, $s0 , $a1		# calcolo a2 sottraendo l'elemento corrente al numero massimo di elementi (m-k)
	addi $a1, $a1, 1		# incremento k
	jal mul2				# chiamo la funzione mul2
	add $s1, $s1, $v1		# sommo al risultato il valore di ritorno della funzione mul2
	jal conversion			# chiamo la funzione conversion
	j return2				# salto a return2
	
	
prereturn:
	add $s1, $s1, $a3		# aggiungo v[k] al totale

return2:
	lw $ra, 0($sp)			# riprendo il ritorno
	addi $sp, $sp, 4		# pop sullo stack per liberare le variabili
	jr $ra		
	
mul2:							#funzione necessaria per calcolare il corretto valore in decimale di v[k]
	addi $sp, $sp, -4			# push sullo stack per salvare le variabili
	sw $ra, 0($sp)				# salvo $ra per il ritorno
	beq $a3, $zero, mul2base1	# controllo se il valore di v[k] è uguale a zero, nel caso passa all'etichetta "mul2base1"
	li $t0, 1					
	beq $a2, $t0, mul2base2		# controllo se il valore di 'm-k' è uguale a uno, nel caso passa all'etichetta "mul2base2"
	add $a3, $a3, $a3			# calcolo il nuovo v[k] come 2*v[k]
	addi $a2, $a2, -1			# decremento il valore di 'm-k' di uno
	jal mul2					# chiamo la funzione mul2
	j mul2End					# salto all'etichetta mul2End

mul2base1:				#primo caso base, ci entra solo se v[k] = 0
	li $v1, 0			# setta $v1 (il valore di ritorno) uguale a zero
	j mul2End			# salta all'etichetta mul2End
	
mul2base2:				#secondo caso base, ci entra solo se $a2 = 1
	add $v1, $a3, $a3	# calcolo $v1 (il valore di ritorno) come 2*v[k]
	
mul2End:				#funzione necessaria per il ritorno
	lw $ra, 0($sp)		# riprendo il ritorno
	addi $sp, $sp, 4	# pop sullo stack per liberare le variabili
	jr $ra				# salto al valorelore del registro $ra
	
loopBinary:						#funzione necessaria per visualizzare i singoli elementi del vettore
	addi $s2, $s2, 1			# incrementa l'indirizzo di base del vettore
	lb $a0, arrayB($s2)			# stampa il contenuto di v[k]
	li $v0, 1
	syscall	
	bne $s2, $s0, loopBinary	# controllare se siamo arrivati all'ultimo elemento del vettore, nel caso contrario richiama se stessa
	jr $ra						# salto al velore del registro $ra
	
printBinary:			#funzione necessaria per la stampa del numero in binario puro
	la $a0, binary		# stampa la stringa "binary"
	li $v0, 4
	syscall 		
	li $s2, -1			# setta il contenuto di $s2 a -1
	jal loopBinary		# chiama la funzione loopBinary
	la $a0, closeQ		# stampa la stringa "closeQ"
	li $v0, 4
	syscall
	
printConv:				#funzione necessaria per la stampa del numero naturale corrispondente al binario puro
	la $a0, decimal		# stampa la stringa "decimal"
	li $v0, 4
	syscall 
	move $a0, $s1		# stampa il contenuto di $s1, ovvero il risultato dell'etichetta "conversion"
	li $v0, 1
	syscall
	
	
exit:
	li $v0, 10   #uscita dal programma
	syscall