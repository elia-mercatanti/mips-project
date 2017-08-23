# Title: Esercizio 1 - Unione e Intersezione di Vettori
# Authors: Andrea Pinto, Elia Mercatanti, Samuele Bucciero 
# E-mails: andrea.pinto1@stud.unifi.it, eliamercatanti@yahoo.it, samuele.bucciero@gmail.com
# Date: 31/08/2014

################################## Data segment #####################################################################################################################

.data

	sceltaAzione:          .asciiz "\n Decidere se fare un'unione oppure un' intersezione (0=unione;1=intersezione)"
	howManyArrays:         .asciiz "\nQuanti array vuoi usare? (max 5)--> "
	howManyElements:       .asciiz "\nQuanti elementi vuoi inserire? (max 50)--> "
	emptyArray:		       .asciiz "\n Un vettore e' vuoto , dunque l' intersezione dei vettori è un vettore vuoto"
	vettoreUnione:	       .asciiz "\n Vettore-Unione: "
	vettoreIntersezione:   .asciiz"\n Vettore-Intersezione: "
	vett0:	               .asciiz "\n Vett0: "
	vett1:	               .asciiz "\n Vett1: "
	vett2:	               .asciiz "\n Vett2: "
	vett3:	               .asciiz "\n Vett3: "
	vett4:	               .asciiz "\n Vett4: "
	input:                 .asciiz "\nInserire un carattere --> "
	fine:                  .asciiz "\nFine del programma!"
	titolo:	               .asciiz "Esercizio 1 - Unione e Intersezione di Vettori\n"
	array0:                .space 51   #alloca 50 byte (ogni carattere vale 1 byte)
	array1:                .space 51   #alloca 50 byte 
	array2:                .space 51   #alloca 50 byte 
	array3:                .space 51   #alloca 50 byte
	array4:                .space 51   #alloca 50 byte 
	array5:		           .byte 0:53  #array unione
	arrayDim:              .space 28   #array per 7 interi, che esprimono la grandezza di ogni vettore,il numero di array usati,la grandezza e l' indice del piu piccolo

################################## Code segment #####################################################################################################################

.text
.globl main 

main:	
	li $t7,0			#num elementi totali
	
	li $t1,0
	li $t0,91			
	sb $t0,array5($t1)	#carico la parentesi quadra aperta nella prima posizione del vettore risultato
	
	la $a0,titolo		#stampo il titolo
	li $v0,4
	syscall

quantiArray:
	la $a0, howManyArrays
	li $v0, 4
	syscall   
	li $v0, 5
	syscall
	move $t9,$v0 						#$t9 contiene il numero di array usati
	bgt $t9,5,quantiArray
	li $v0,7
	sb $t9,arrayDim($v0)
	beqz $t9,exit

quantiElementi:
	la $a0, howManyElements
	li $v0, 4
	syscall   
	li $v0, 5
	syscall
	move $t8,$v0						#$t8 contiene il num elementi attuale
	bgt $t8,50,quantiElementi
	sb $t8, arrayDim($t1)
	beqz $t8,decrementaNumArrays	
	add $t7,$t7,$t8

azzeraIndice:
	li $t0,0

richiestaCarattere:
	la $a0, input   #stampa della stringa input   
	li $v0, 4       
	syscall
	li $v0, 12
	syscall
	beq $t1,0,caricaArray0
	beq $t1,1,caricaArray1
	beq $t1,2,caricaArray2
	beq $t1,3,caricaArray3
	beq $t1,4,caricaArray4
	#non dovrebbe mai poter non fare nessuno dei casi precedenti
	
caricaArray0:
	sb $v0, array0($t0)
	addi $t0,$t0 1
	bne $t0, $t8,richiestaCarattere	
	j decrementaNumArrays
caricaArray1:
	sb $v0, array1($t0)
	addi $t0,$t0, 1
	bne $t0, $t8,richiestaCarattere	
	j decrementaNumArrays
caricaArray2:
	sb $v0, array2($t0)
	addi $t0,$t0, 1
	bne $t0, $t8,richiestaCarattere	
	j decrementaNumArrays
caricaArray3:
	sb $v0, array3($t0)
	addi $t0,$t0, 1
	bne $t0, $t8,richiestaCarattere	
	j decrementaNumArrays
caricaArray4:
	sb $v0, array4($t0)
	addi $t0,$t0, 1
	bne $t0, $t8,richiestaCarattere	
	j decrementaNumArrays
	
decrementaNumArrays:
#addi $t9,-1
addi $t1,$t1,1 #contatore array caricati

checkNumArrays:
bge $t1,$t9,cosaFare   			#####etichetta che manda all unione/intersezione
j quantiElementi

cosaFare:
	la $a0, sceltaAzione
	li $v0, 4
	syscall   
	li $v0, 5
	syscall
	beqz $v0,azzeraT1
	beq $v0,1,prepIntersezione
	j cosaFare

#UNIONE DEI VETTORI---------------------------------------------------------------------------------------------------------------------------------------------------	
azzeraT1:
li $t1,0
prepUnione:
li $t2,1				#indice dell array unione			
lb $t0,arrayDim($t1)

whereToGo:
li $t2,1		
beq $t1,0,special	
beq $t1,1,unione1
beq $t1,2,unione2
beq $t1,3,unione3
beq $t1,4,unione4

special:				#etichetta necessaria per il link
		jal unione0
unione0:
	addi $t0,$t0,-1
	#beqz $t0,
	lb $t3,array0($t0)
	bgez $t0,checkExistence
	addi $t1,$t1,1			#incremento il contatore array già verificati
	beq $t1,$t9,prepPrintUnione
	jal prepUnione
unione1: #unione1
	addi $t0,$t0,-1
	lb $t3,array1($t0)
	bgez $t0,checkExistence
	addi $t1,$t1,1
	jal prepUnione
unione2: #unione2
	addi $t0,$t0,-1
	lb $t3,array2($t0)
	bgez $t0,checkExistence
	addi $t1,$t1,1
	jal prepUnione
unione3: #unione1
	addi $t0,$t0,-1
	lb $t3,array3($t0)
	bgez $t0,checkExistence
	addi $t1,$t1,1
	jal prepUnione
unione4: #unione4
	addi $t0,$t0,-1
	lb $t3,array4($t0)
	bgez $t0,checkExistence
	j prepPrintUnione
	
checkExistence:			#controllo se l elemento in esame è già presente all' interno del vettoreUnione
	lb $t4,array5($t2)
	addi $t2,$t2,1
	beq $t3,$t4,return
	bnez $t4,checkExistence
	j insertElement	
insertElement:			# inserisco l elemento sotto controllo nel vettore unione
	addi $t2,$t2,-1
	sb $t3,array5($t2)
	li $t2,1
	j whereToGo	
return:
li $t2,1
addi $t7,$t7,-1 #decremento il numero di elementi nel vettore unione
jr $ra

prepPrintUnione:
	li $t5,0
	li $t0,93
	addi $t7,$t7,1
	sb $t0,array5($t7)
prepComune:
	li $t4,7
	lb $t4,arrayDim($t4)	#prelevo il numero di array usati
	li $t3,0
	lb $t2,arrayDim($t3)	#prelevo la dimensione del primo array
	li $t0,0
	addi $t7,$t7,1
	j textVett0
attivaT5:
	li $t5,1
	move $t7,$t1				#$t7 serve per la print	
	addi $t7,$t7,1
	li $t0,93	
	sb $t0,array5($t7)
	j prepComune
textVett0:
	la $a0, vett0
	li $v0, 4
	syscall   
printVett0:
	lb $a0,array0($t0)
	addi $t0, $t0, 1	#li visualizzo dal primo all' ultimo
	li $v0, 11
	syscall	
	ble $t0,$t2,printVett0
	addi $t4,$t4,-1
	j nextArray
textVett1:
	la $a0, vett1
	li $v0, 4
	syscall  
printVett1:
	lb $a0,array1($t0)
	addi $t0, $t0, 1	#li visualizzo dal primo all' ultimo
	li $v0, 11
	syscall	
	ble $t0,$t2,printVett1
	addi $t4,$t4,-1
	j nextArray
textVett2:
	la $a0, vett2
	li $v0, 4
	syscall  
printVett2:
	lb $a0,array2($t0)
	addi $t0, $t0, 1	#li visualizzo dal primo all' ultimo
	li $v0, 11
	syscall	
	ble $t0,$t2,printVett2
	addi $t4,$t4,-1
	j nextArray
textVett3:
	la $a0, vett3
	li $v0, 4
	syscall  
printVett3:
	lb $a0,array3($t0)
	addi $t0, $t0, 1	#li visualizzo dal primo all' ultimo
	li $v0, 11
	syscall	
	ble $t0,$t2,printVett3
	addi $t4,$t4,-1
	j nextArray
textVett4:
	la $a0, vett4
	li $v0, 4
	syscall  
printVett4:
	lb $a0,array4($t0)
	addi $t0, $t0, 1	#li visualizzo dal primo all' ultimo
	li $v0, 11
	syscall	
	ble $t0,$t2,printVett4
	addi $t4,$t4,-1
	j nextArray

nextArray:
	li $t0,0
	blez $t4,quale
	addi $t3,$t3,1
	lb $t2,arrayDim($t3)	#prelevo la dimensione dell array successivo
	beq $t3,1,textVett1
	beq $t3,2,textVett2
	beq $t3,3,textVett3
	beq $t3,4,textVett4
	j exit	
quale:
	beqz $t5,printTextUnione
	j printTextIntersezione
printTextUnione:
	la $a0, vettoreUnione
	li $v0, 4
	syscall 
j printResult
printTextIntersezione:
	move $t7,$t1				#$t7 serve per la print	
	addi $t7,$t7,1
	#li $v0,1
	#move $a0,$t7
	#syscall
	li $t0,93	
	sb $t0,array5($t7)
	li $t0,0	
	la $a0, vettoreIntersezione
	li $v0, 4
	syscall 	
printResult:
	lb $a0, array5($t0)
	addi $t0,$t0,1	#li visualizzo dal primo all' ultimo
	li $v0, 11
	syscall	
	bgt $t0,$t7,exit
	j printResult

#INTERSEZIONE DEI VETTORI---------------------------------------------------------------------------------------------------------------------------------------------------
#registri occupati: $t9 che contiene il num di array usati

prepIntersezione:
li $t0,9
li $t1,0
li $t2,8		#pos 8:grandezza del minore/pos 9:indice del minore
move $t7,$t9
li $t8,50

caricaAttuale:
addi $t7,$t7,-1
lb $t1,arrayDim($t7)	#prelevo la grandezza dell ULTIMO array
bgez $t7,checkMin
j isMin

checkMin:
	blt $t8,$t1,caricaAttuale	#checkMin e newMin devo essere adiacenti
newMin:
	beqz $t1,vuoto
	move $t8,$t1
	sb $t1,arrayDim($t2) #salvo la grandezza del minore
	sb $t7,arrayDim($t0) #salvo l indice del minore
	j caricaAttuale

isMin:
lb $t1,arrayDim($t2)		#t1 contiene la grandezza del minore
lb $t2,arrayDim($t0)		#t2 contiene l indice del minore
li $t0,0
move $t7,$t1				#$t7 serve per la print
addi $t7,$t7,1					#come sopra
beq $t2,1,loadWithShortest1
beq $t2,2,loadWithShortest2
beq $t2,3,loadWithShortest3
beq $t2,4,loadWithShortest4
bnez $t2,exit

loadWithShortest0:
	lb $t3,array0($t0)
	addi $t0,$t0,1
	sb $t3,array5($t0)
	beq $t0,$t1,prepCheck
	j loadWithShortest0
loadWithShortest1:
	lb $t3,array1($t0)
	addi $t0,$t0,1
	sb $t3,array5($t0)
	beq $t0,$t1,prepCheck
	j loadWithShortest1
loadWithShortest2:
	lb $t3,array2($t0)
	addi $t0,$t0,1
	sb $t3,array5($t0)
	beq $t0,$t1,prepCheck
	j loadWithShortest2
loadWithShortest3:
	lb $t3,array3($t0)
	addi $t0,$t0,1
	sb $t3,array5($t0)
	beq $t0,$t1,prepCheck
	j loadWithShortest3
loadWithShortest4:
	lb $t3,array4($t0)
	addi $t0,$t0,1
	sb $t3,array5($t0)
	beq $t0,$t1,prepCheck
	j loadWithShortest4

prepCheck:		# RICORDA $t9 contiene il numero di vettori usati
	li $t0,1	#indice che scorre array5 fino a raggiungere $t1 (che contiene la grandezza del vettore5) RICORDA:posizione 0 occupata da [
	li $t2,0	#contiene il dato di cui si sta controllando l esistenza negli altri array
	li $t3,0	#indice per i vari vettori
	li $t4,0	#contiene i dati dei vettori
	li $t5,-1	#tiene conto dei vettori controllati
	
nextArray2:	
	li $t8,0
	addi $t5,$t5,1
	beq $t5,$t9,attivaT5
	lb $t6,arrayDim($t5)
	beqz $t6,vuoto
	li $t0,1
	li $t3,0	
	
loadElement:
	li $t8,0		#flag
	lb $t2,array5($t0)	
		
whereToGo2:
	beq $t5,0,checkArray0
	beq $t5,1,checkArray1
	beq $t5,2,checkArray2
	beq $t5,3,checkArray3
	beq $t5,4,checkArray4	


checkArray0:
	lb $t4,array0($t3)
	j checkPresence

checkArray1:
	lb $t4,array1($t3)
	j checkPresence
checkArray2:
	lb $t4,array2($t3)
	j checkPresence
checkArray3:
	lb $t4,array3($t3)
	j checkPresence
checkArray4:
	lb $t4,array4($t3)
	j checkPresence
	
checkPresence:
		beq $t2,$t4, deleteDuplicatesPrep
		addi $t3,$t3,1
		beq $t3,$t6,controllaFlag
		j whereToGo2
	
controllaEsiste: j attivaT5

deleteDuplicatesPrep:	
	move $t7,$t0	
isDuplicate:
	addi $t7,$t7,1
	bgt $t7,$t1,incrementaT0
	lb $t8,array5($t7)
	beq $t8,$t4,deleteDuplicate
	j isDuplicate
	
deleteDuplicate:
	addi $t7,$t7,1
	bgt $t7,$t1,ultimo
	lb $t8,array5($t7)
	addi $t7,$t7,-1
	sb $t8,array5($t7)
	addi $t7,$t7,1
	j deleteDuplicate
	
incrementaT3:
	addi $t3,$t3,1	
	beq $t3,$t6,nextArray2
	j whereToGo2
	
#azzeraT0:	
incrementaT0:
	li $t8,0
	addi $t0,$t0,1
	bgt $t0,$t1,nextArray2
	li $t3,0
	j loadElement

controllaFlag:
	beq $t8,0,prepDeleteElement
	addi $t0,$t0,1
	beq $t0,$t1,nextArray2	
	li $t3,0
	j whereToGo2
	
prepDeleteElement:
	move $t7,$t0
deleteElement:	
	addi $t7,$t7,1
	bgt $t7,$t1,ultimo2
	lb $t8,array5($t7)
	addi $t7,$t7,-1 
	sb $t8,array5($t7)
	addi $t7,$t7,1
	j deleteElement
ultimo:
	li $t8,0
	addi $t1,$t1,-1
	#addi $t0,1
	li $t3,0
	j loadElement
ultimo2:
	addi $t1,$t1,-1
	j loadElement
vuoto:
	la $a0, emptyArray   
	li $v0, 4   
	syscall	
	
exit:
	la $a0, fine   #stampa della stringa fine   
	li $v0, 4   
	syscall
	li $v0, 10	#uscita dal programma
	syscall	
