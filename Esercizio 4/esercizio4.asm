# Title: Esercizio 4 - Split di Liste
# Authors: Elia Mercatanti, Samuele Bucciero, Andrea Pinto
# E-mails: eliamercatanti@yahoo.it, samuele.bucciero@gmail.com, andrea.pinto1@stud.unifi.it
# Date: 31/08/2014

################################## Data segment #####################################################################################################################

.data
	titolo:            .asciiz "Esercizio 4 - Split di Liste\n"                                                          
	menu0:             .asciiz "\n-Menu-"
	menu1:	           .asciiz "\n1 - Creazione di una nuova lista di interi. "
	menu2:	           .asciiz "\n2 - Split due. "                                                                         
	menu3:	           .asciiz "\n3 - Split tre. "
	menu4:	           .asciiz "\n4 - Esci dal programma.\n"
	sceltaMenu:        .asciiz "\nInserisci un comando: "
	sceltaErrata:      .asciiz "\nHai inserito un comando non valido, inserirne un' altro.\n"                              
	uscita:            .asciiz "\nUscita dal programma"
	lista0:            .asciiz "\nList-"
	lista1:            .asciiz ": "                                                                                       
	lista2:            .asciiz "["
	lista3:            .asciiz "]"
	inserimento:       .asciiz "\nInserisci un numero intero nella lista (0 per terminare): "
	spazio:            .asciiz " "
	nil:               .asciiz "Nil"
	newLine:           .asciiz "\n"
	zeroListe:         .asciiz "\nNon e' stata inserita nessuna lista, lo split richiesto non puo' essere eseguito\n"
	listeCreate:       .asciiz "\nListe create fino ad ora:"
	splitEseguito:     .asciiz "\nLo split richiesto e' stato eseguito:"
   
################################## Code segment #####################################################################################################################

.text
.globl main 

main:
	li $s0, 0            # contatore delle liste create
	li $s1, 0            # contatore del numero di elementi inseriti in una lista
	
	la $a0, titolo       # stampa il titolo
	li $v0, 4
	syscall 
	
menu:
    la $a0, menu0       # stampa il menu0
	li $v0, 4
	syscall  
	
	la $a0, menu1       # stampa il menu1
	li $v0, 4
	syscall   
	
	la $a0, menu2       # stampa il menu2
	li $v0, 4
	syscall   
	
	la $a0, menu3       # stampa il menu3
	li $v0, 4
	syscall  
	
	la $a0, menu4       # stampa il menu4
	li $v0, 4
	syscall  
	
	la $a0, sceltaMenu   # stampa la sceltaMenu
	li $v0, 4
	syscall   
	
	li $v0, 5            # legge il comando inserito dall'utente
	syscall  
		
controlloMenu:
	beq $v0, 1, nuovaLista       # viene controllato se e' stata richiesta la creazione di una nuova lista
	beq $v0, 2, splitDue         # viene controllato se e' stato richiesto lo split due sulle liste create
	beq $v0, 3, splitTre         # viene controllato se e' stato richiesto lo split tre sulle liste create
	beq $v0, 4, exit             # viene controllato se e' stato richiesta l'uscita dal programma
	
	la $a0, sceltaErrata         # viene stampato un messaggio di errore che avverte l'utente
	li $v0, 4
	syscall
	
	j menu                       # torna a stampare il menu
	
nuovaLista:
    jal creazioneLista           # chiama la procedura che gestira' la creazione di una nuova lista
	addi $sp,$sp, -12            # crea spazio per tre words nello stack frame
	sw $v0, 8($sp)               # salvo la testa della lista appena creata nello stack frame
	sw $v1, 4($sp)               # salvo la coda della lista appena creata nello stack frame
	sw $s1, 0($sp)               # salvo il numero di elementi della lista appena creata nello stack frame
	addi $s0, $s0, 1             # aumento di uno il contatore delle liste create
	
	li $v0, 4
	la $a0, listeCreate          # stampa "listeCreate", che indica all'utente le liste stampate fino ad ora
	syscall 
	
	jal stampaListe              # funzione chiamata per stampare le liste create fino ad ora
	
	li $v0, 4
	la $a0, newLine              # inserisce una nuova linea per staccare la stampa delle stringhe dal menu
	syscall 
	
	j menu                       # torna a stampare il menu

creazioneLista:
    move $t8, $zero	    		 # t8 viene utilizzato come riferimento alla Testa della lista e posto a 0
    move $t9, $zero	    		 # t9 viene utilizzato come riferimento alla Coda della lista e posto a 0
	li $s1, 0                    # s1 viene inizializzato a 0
	
inputloop:                       # inizio loop di input; 
	li $v0, 4
	la $a0, inserimento
	syscall                       # stampa messaggio di inserimento

	li $v0, 5
	syscall                       # legge un intero inserito dall'utente
	
	beq $v0, $zero, fineLista     # se l'intero letto e' zero, procedera' a stampare tutte le liste inserite fino ad ora
	move $t1, $v0
    addi $s1, $s1, 1              # incremento il numero degli elementi inseriti
	
    li $v0, 9
	li $a0, 12                    # restituisce un blocco, puntato da v0 di 12 byte (4 byte per l'intero, 4 byte per il 
	syscall                       # puntatore al precedente,4 byte per il puntatore al succesivo

	sw $zero, 0($v0)              	# campo dedicato all'elemento-precedente = nil
	sw $t1, 4($v0)              	# campo dedicato all'intero = t1
	sw $zero, 8($v0)              	# campo dedicato all'elemento-successivo = nil
	
	bne $t8, $zero, linkLast       	# se t8!=nil (coda non vuota) vai a linkLast
    move $t8, $v0                 	# altrimenti (prima inserzione)  Testa=v0
    move $t9, $v0                   # altrimenti (prima inserzione)  Coda=v0
	
	j inputloop                  	# torna all'inizio del loop di input

linkLast:                           # se la coda e' non vuota, collega l'ultimo elemento della lista, puntato da Coda (t9) al nuovo record; 
    sw $v0, 8($t9)                  # dopodiche' modifica Coda per farlo puntare al nuovo record
	sw $t9, 0($v0)					# il campo elemento successivo dell'ultimo del record prende v0			
	move $t9, $v0             	    # Coda = v0
	j inputloop   	                # salta all'inizio del loop
	
fineLista:
    move $v0, $t8                 #	sposto la testa della lista appena creata in $v0 come parametro di ritorno
	move $v1, $t9                 #	sposto la coda della lista appena creata in $v1 come parametro di ritorno
	jr  $ra
	
stampaListe:
    move $t0, $s0                  # uso t0 per sapere il numero delle liste ancora da stampare
	li $t2, 1                      # uso t2 come contatore per sapere quale lista sta esaminando
	
loopListe:
    mul $t3, $t0, 12               # uso t3 per calcolare corettamente la posizione nello stack da cui prelevare la Testa e la Coda delle varie liste
	add $t3, $t3, $sp              # mi calcolo l'indirizzo di base da cui prendere le corrette informazioni
    lw $t8, -4($t3)                # uso t8 per salvare la testa della lista esaminata
	lw $t9, -8($t3)                # uso t9 per salvare la coda della lista esaminata
	
	move $t4, $t8			       # t4 = Testa. t4 verra' usato come puntatore per scorrere gli elementi della lista
   
	li $v0, 4
	la $a0, lista0			       # stampo lista0
	syscall	
	
	li $v0, 1
	move $a0, $t2			       # stampo il numero della lista
	syscall	
	
	li $v0, 4
	la $a0, lista1		           # stampo lista1
	syscall	
	
	beq $t9, $zero, stampaNil      # se  t9 = 0 la lista e' "nil"
	
	li $v0, 4
	la $a0, lista2		           # stampo lista2
	syscall	
	
loopStampa:
	beq $t4, $zero, fineStampa	   # se  t4 = 0 si e' raggiunta la fine della lista e si esce
	
	li $v0, 1				       # altrimenti si stampa l'elemento corrente. Cioe':
	lw $a0, 4($t4)			       # a0 = valore del campo intero dell'elemento corrente (puntato da t4)
	syscall				           # stampa valore intero dell'elemento corrente
	
	lw $t4, 8($t4)			       # t4 = valore del campo elemento-successivo dell'elemento corrente (puntato da t4)
	beq $t4, $zero, loopStampa     # se t4 punta a 0 significa che l'elemento processato e' l'ultimo e quindi non viene
	                               # stampato lo spazio
	li $v0, 4
	la $a0, spazio			
	syscall				           # stampa spazio
	
	j loopStampa		           # salta all'inizio del ciclo di stampa
	
fineStampa:
    li $v0, 4
	la $a0, lista3			       # stampo lista3
	syscall	
	
	j concludiStampa
	
stampaNil:	
    li $v0, 4
	la $a0, nil			           # stampo nil
	syscall	
	
concludiStampa:	
	addi $t0, $t0, -1              # decremento di 1 il numero delle liste da stampare
	addi $t2, $t2, 1               # aumento di 1 il numero per identificare la prossima lista
	bne $t0, $zero, loopListe      # se ci sono ancora liste da stampare torna a "loopListe"
    jr  $ra                        # altrimenti la stampa di tutte le liste e' conclusa

splitDue:
    beq $s0, $zero, nessunaLista   # se il numero delle liste e' pari a zero non deve essere possibile eseguire lo splitDue, quindi salta a "nessunaLista"
    jal splitDueListe              # funzione che esegue lo split due di tutte le liste create
	
	li $v0, 4
	la $a0, splitEseguito          # stampa "splitEseguito", che indica all'utente che lo split e' stato eseguito
	syscall 
	
	jal stampaListe                # funzione chiamata per stampare le liste create fino ad ora
	
	li $v0, 4
	la $a0, newLine                # inserisce una nuova linea per staccare la stampa delle stringhe dal menu
	syscall 
	
	j menu                         # torna a stampare il menu

nessunaLista:
    li $v0, 4
	la $a0, zeroListe              # stmapa zeroListe, per indicare all'utente che non può eseguire lo split
	syscall 
	
    j menu                         # torna a stampare il menu
	
splitDueListe:
	move $t0, $s0                  # uso t0 per sapere il numero delle liste su cui fare lo split due
	move $t1, $s0                  # uso t1 per calcolare correttamente la posizione nello stack da cui prelevare la Testa e la Coda delle varie liste
	
loopSplitDue:	
    li $t6, 0                      # uso t6 come contatore per scorre la lista, per sapere cosa eliminare
    mul $t2, $t1, 12               # uso t2 per salvare la posizione corretta dello stack per prelevare le informazioni necessarie
	add $t2, $t2, $sp              # mi calcolo l'indirizzo di base da cui prendere le corrette informazioni
	lw $t3, -12($t2)               # uso t3 per salvare il numero di elementi della lista esaminata	
	beq $t3, $zero, splitDueNil    # se t3 e' uguale a 0 significa che la lista e' "nil"
	
	div $t4, $t3, 2                # uso t4 per sapere quanti elementi dovranno rimanere nella lista (t3/2)
	lw $t8, -4($t2)                # uso t8 per salvare la testa della lista esaminata
	lw $t7, -8($t2)                # uso t7 per salvare la coda della lista esaminata
	move $t5, $t8			       # t5 = Testa. t5 verra' usato come puntatore per scorrere gli elementi
	
scorrimentoLista1:
	beq $t6, $t4, creaSplitDue     # se il contatore t6 e' uguale al numero di elementi che non dovranno essere modificati
    lw $t5, 8($t5)			       # t5 = valore del campo elemento-successivo dell'elemento corrente (puntato da t5)
    addi $t6, $t6, 1               # incremento il contatore t6 per sapere quanti elementi ho scansionato
	j scorrimentoLista1
	
creaSplitDue:
    move $t9, $t5                 # salvo il valore di t5 in t9
    lw $t5, 0($t5)                # metto in t5 il puntatore all'elemento precedente della lista
	
	bne $t5, $zero, notNil2       # se t5=0 allora la lista dovra' essere modificata in "nil", altrimenti salta a "notNil2"
	sw $zero, -12($t2)            # setto il num. di elementi a 0
	sw $zero, -8($t2)             # setto la coda a 0
    sw $zero, -4($t2)             # setto la testa a 0
	j nuovaListaSplit2
	
notNil2:	
    sw $t5, -8($t2)               # cambio la coda della lista esaminata con il puntatore in t5
	sw $t4, -12($t2)              # setto il num. di elementi che saranno presenti nella lista dopo la modifica
	sw $zero, 8($t5)              # cambio l'elemento succesivo di t5 con 0
	
nuovaListaSplit2:	
	sw $zero, 0($t9)             # pongo il puntatore al precedente del primo elemento della nuova lista a 0
	addi $sp,$sp, -12            # crea spazio per tre words nello stack frame
	sw $t9, 8($sp)               # salvo la testa, che sara' t9, della nuova lista appena creata nello stack frame
	sw $t7, 4($sp)               # salvo la coda della lista appena creata nello stack frame
	sub $t7, $t3, $t6            # uso t7 come appoggio per conoscere il num. di elementi della nuova lista(t3-t6)
	sw $t7, 0($sp)               # salvo il numero di elementi della lista appena creata nello stack frame
	addi $s0, $s0, 1             # aumento di uno il contatore delle liste create
	j fineSplitDue

splitDueNil:                     # decremento di 1 t1 per calcolare corettamente la posizione nello stack da cui prelevare le info
    addi $t1, $t1, -1            # in questo caso infatti non viene creata nessuna nuova lista
        
fineSplitDue:
    addi $t0, $t0, -1              # decremento di 1 il numero delle liste da splittare
    bne $t0, $zero, loopSplitDue   # se ci sono ancora liste da splittare torna a "loopSplitDue"
    jr  $ra                        # altrimenti lo split due di tutte le liste e' concluso
	
splitTre:
    beq $s0, $zero, nessunaLista   # se il numero delle liste e' pari a zero non deve essere possibile eseguire lo splitTre, quindi salta a "nessunaLista"
    jal splitTreListe              # funzione che esegue lo split tre di tutte le liste create
	
	li $v0, 4
	la $a0, splitEseguito          # stampa "splitEseguito", che indica all'utente che lo split e' stato eseguito
	syscall 
	
	jal stampaListe                # funzione chiamata per stampare le liste create fino ad ora
	
	li $v0, 4
	la $a0, newLine                # inserisce una nuova linea per staccare la stampa delle stringhe dal menu
	syscall 
	
	j menu                         # torna a stampare il menu

splitTreListe:
	move $t0, $s0                  # uso t0 per sapere il numero delle liste su cui fare lo split tre
	move $t1, $s0                  # uso t1 per calcolare corettamente la posizione nello stack da cui prelevare la Testa e la Coda delle varie liste
	
loopSplitTre:	
    li $t6, 0                      # uso t6 come contatore per scorre la lista, per sapere cosa eliminare
    mul $t2, $t1, 12               # uso t2 per salvare la posizione corretta dello stack per prelevare le informazioni necessarie
	add $t2, $t2, $sp              # mi calcolo l'indirizzo di base da cui prendere le corrette informazioni
	lw $t3, -12($t2)               # uso t3 per salvare il numero di elementi della lista esaminata	
	beq $t3, $zero, splitTreNil    # se t3 e' uguale a 0 significa che la lista e' "nil"
	
	div $t4, $t3, 3                # uso t4 per sapere quanti elementi dovranno rimanere nella lista (t3/3)
	lw $t8, -4($t2)                # uso t8 per salvare la testa della lista esaminata
	lw $t7, -8($t2)                # uso t7 per salvare la coda della lista esaminata
	move $t5, $t8			       # t5 = Testa. t5 verra' usato come puntatore per scorrere gli elementi
	li $t8, 0                      # t8 viene ora utilizzato per sapere a che punto dello split siamo (se bisogna creare nuove liste o meno)
	
scorrimentoLista2:
	beq $t6, $t4, creaSplitTre     # se il contatore t6 e' uguale al numero di elementi che non dovranno essere modificati
    lw $t5, 8($t5)			       # t5 = valore del campo elemento-successivo dell'elemento corrente (puntato da t4)
    addi $t6, $t6, 1               # incremento il contatore t6 per sapere quanti elementi ho scansionato
	j scorrimentoLista2
	
creaSplitTre:
    li $t6, 2                            # uso t6 per caricare il valore 2 
    addi $t8, $t8, 1                     # incremento t8 per sapere se la prossima mossa da fare e' creare una nuova lista
	beq $t8, $t6, creaNuoveListeSplit3   # se t8 e' maggiore di 1 allora crea nuove liste
    move $t9, $t5                        # salvo il puntatore all'elemento della lista in t9
    lw $t5, 0($t5)                       # metto in t5 il puntatore all'elemento precedente della lista
	
	bne $t5, $zero, notNil3       # se t5=0 allora la lista dovra' essere modificata in "nil", altrimenti salta a "notNil3"
	sw $zero, -12($t2)            # setto il num. di elementi a 0
	sw $zero, -8($t2)             # setto la coda a 0
    sw $zero, -4($t2)             # setto la testa a 0
	j nuovaListaSplit3
	
notNil3:	
    sw $t5, -8($t2)               # cambio la coda della lista esaminata con il puntatore in t5
	sw $t4, -12($t2)              # setto il num. di elementi che saranno presenti nella lista dopo la modifica
	sw $zero, 8($t5)              # cambio l'elemento succesivo di t5 con 0
	
nuovaListaSplit3:
    li $t6, 0   	             # uso t6 come contatore per scorre la lista, per sapere cosa eliminare
	move $t5, $t9                # salvo il puntatore all'elemento della lista in t5
	j scorrimentoLista2

creaNuoveListeSplit3:
	sw $zero, 0($t9)             # pongo il puntatore al precedente del primo elemento della nuova lista a 0
	addi $sp,$sp, -12            # crea spazio per tre words nello stack frame
	lw $t8, 0($t5)               # uso t8 per salvare l'elemento precedente a quello puntato da t5( che sara' la coda della nuova lista)
	bne $t8, $zero, notNewNil3   # se t8=0 allora la lista dovra' essere modificata in "nil", altrimenti salta a "notNewNil3"
	
	sw $zero, 0($sp)             # setto il num. di elementi a 0
	sw $zero, 4($sp)             # setto la coda a 0
    sw $zero, 8($sp)             # setto la testa a 0
	addi $s0, $s0, 1             # aumento di uno il contatore delle liste create
	j prossimaLista

notNewNil3:	
    sw $t9, 8($sp)               # salvo la testa, che sara' t9, della nuova lista appena creata nello stack frame
	sw $zero, 8($t8)             # rendo il puntatore-succesivo della coda nullo=0
	sw $t8, 4($sp)               # salvo la coda della lista appena creata nello stack frame
	sw $t4, 0($sp)               # salvo il numero di elementi della lista appena creata nello stack frame
	addi $s0, $s0, 1             # aumento di uno il contatore delle liste create

prossimaLista:	
	sw $zero, 0($t5)             # pongo il puntatore al precedente del primo elemento della nuova lista a 0
	addi $sp,$sp, -12            # crea spazio per tre words nello stack frame
	sw $t5, 8($sp)               # salvo la testa, che sara' t5, della nuova lista appena creata nello stack frame
	sw $t7, 4($sp)               # salvo la coda della lista appena creata nello stack frame
	sub $t7, $t3, $t4            # uso t7 come appoggio per conoscere il num. di elementi 
	sub $t7, $t7, $t4            # della nuova lista(t3-t6)
	sw $t7, 0($sp)               # salvo il numero di elementi della lista appena creata nello stack frame
	addi $s0, $s0, 1             # aumento di uno il contatore delle liste create
	addi $t1, $t1, 1             # umento di 1 t1 per calcolare corettamente la posizione nello stack da cui prelevare le info
	j fineSplitTre

splitTreNil:                     # decremento di 1 t1 per calcolare corettamente la posizione nello stack da cui prelevare le info
    addi $t1, $t1, -1            # in questo caso infatti non viene creata nessuna nuova lista
        
fineSplitTre:
    addi $t0, $t0, -1              # decremento di 1 il numero delle liste da splittare
    bne $t0, $zero, loopSplitTre   # se ci sono ancora liste da splittare torna a "loopSplitTre"
    jr  $ra                        # altrimenti lo split tre di tutte le liste e' concluso   
	
exit:
    mul $t0, $s0, 12             # utilizzo t0 per sapere quanto spazio deve essere liberato
    add $sp,$sp, $t0             # libera lo spazio occupato dello stack
	 
    la $a0, uscita
	li $v0, 4
	syscall  
    
	li $v0, 10
	syscall