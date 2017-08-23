# Title: Esercizio 2 - Traduttore di Stringhe
# Authors: Elia Mercatanti, Samuele Bucciero, Andrea Pinto
# E-mails: eliamercatanti@yahoo.it, samuele.bucciero@gmail.com, andrea.pinto1@stud.unifi.it
# Date: 31/08/2014

################################## Data segment #####################################################################################################################

.data
		titolo:        .asciiz "Esercizio 2 - Traduttore di Stringhe\n"                       # stringa per il titolo
		input:         .asciiz "\nInserire un stringa qualsiasi (MAX 100 Caratteri) : "       # stringa per l'input utente
		erroreIns:     .asciiz "\nNon hai inserito nessun carattere!! \n"                     # stringa per messaggio di errore
		output:        .asciiz "\nRisultato della traduzione: "                               # stringa per messaggio dell'output del programma
		uno:           .asciiz "uno"
		due:           .asciiz "due"
		tre:           .asciiz "tre"
		quattro:       .asciiz "quattro"                                                      # stringhe per i vari numeri
		cinque:        .asciiz "cinque"
		sei:           .asciiz "sei"
		sette:         .asciiz "sette"
		otto:          .asciiz "otto"
		nove:          .asciiz "nove"
		string:        .space 101                     # spazio allocato per la stringa che viene inserita dall'utente     
		result:        .space 101                     # spazio allocato per la stringa finale che viene resa in output a fine programma 
		array:         .space 101                     # spazio allocato per l'array di appoggio, usato per i vari confronti con le stringhe dei numeri 

################################## Code segment #####################################################################################################################
		
.text
.globl main 

main:  
		la $a0, titolo      # stampa stringa titolo
		li $v0, 4
		syscall

stampaS:	
		la $a0, input       # stampa stringa input
		li $v0, 4
		syscall
		  
	    la $a0, string      # legge la stringa inserita
		li $a1, 101
		li $v0, 8
	    syscall

lunghezzaS:                     # controlla la lunghezza della stringa
        li $t1,0                # t1 conta la lunghezza
        la $t2, string          # t2 punta a un carattere della stringa

nextCh:                         # scorre i caratteri della stringa
        lbu $t0,($t2)           # legge un carattere della stringa
        beqz $t0,controllo      # controlla il termine della stringa (0=null ASCII)
        addu $t1,$t1,1          # incrementa il contatore
        addu $t2,$t2,1          # incrementa la posizione sulla stringa
        j nextCh                # ciclo
		
controllo:                      # controlla se la stringa e' vuota
		addi $t1, $t1, -1       # viene tolto dal conteggio il carrattere "invio"
        bnez $t1, init          # controlla il corretto inserimento della stringa
		
		la $a0, erroreIns       # stampa stringa erroreIns
	    li $v0, 4
	    syscall
		j stampaS
		
init:                       # vengono inizializzate le principali variabili
	    li $s0, 0     	    # s0 viene utilizzato come indice per scorrere la stringa inserita
	    li $s2, 0     	    # s2 viene utilizzato come indice per scorrere l' array di appoggio
	    li $s3, 32   	 	# s3 viene utilizzato per caricare il carattere "spazio" (in codice ASCII)
	    li $s4, 49   	 	# s4 viene utilizzato per sapere che numero aggiungere alla stringa finale (codice ASCII 49 = numero 1)
	    li $s5, 0     	    # s5 viene utilizzato come indice della stringa risultante
	    li $s6, 63    	    # s6 viene utilizzato per caricare il carattere "?" (in codice ASCII)
	    move $s7, $t1       # s7 viene utilizzato per contenere la lunghezza della stringa inserita in input
		
scorriS:	                            # scorre la stringa inserita in input
	    lb $s1, string($s0)             # s1 viene utilizzato per leggere, ad ogni ciclo, un carattere della stringa
	    sb $s1, array($s2)              # carica il carattere appena letto nell'array di appoggio
	    beq $s1, $s3, checkSpazio       # controlla se il carattere letto e' uno spazio
	    beq $s7, $s0, checkSpazio       # controlla se il carattere letto e' l'ultimo della stringa di input
	    addi $s2, $s2, 1                # incrementa l'incice dell' array di appoggio
	    addi $s0, $s0, 1                # incrementa l'incice della stringa inserita in input
	    blt $s0, 101 , scorriS          # controlla se il ciclo e' arrivato a fine, ovvero se la stringa input e' stata completamente processata
	    j stampaRes                     # salta alle istruzioni per la stampa della stringa finale

checkSpazio:                       # controlla se lo spazio inserito nell' array di appoggio e' isolato oppure si trova in fondo ad una sotto-stringa di "input"
		beqz $s2, salta            # controlla se l'indice dell' array di appoggio e' uguale a 0 (significa che è uno spazio isolato)
		addi $s2, $s2, -1          # decrementa di uno l'indice dell'array di appoggio per permettere di andare ad "raccogliere" -->
								   # --- > solo la sotto-stringa priva di spazi, che verra' utilizzata per i confronti
	  
checkUno:                         # confronta la sotto-stringa presente nell'array di appoggio con la stringa "uno"
        la $a0, array             # carica i parametri da passare alla funzione "strcmp", utilizzata per confrontare due stringhe
        la $a1, uno
        jal strcmp         	      # chiama la funzione per il confronto tra stringhe
        beq $v0,$zero,uguali   	  # controlla il valore di ritorno della funzione "strcmp" (0-> le due stringhe sono uguali, 1-> sono diverse). Se sono uguali salta all'etichetta "uguali"
	    addi $s4, $s4, 1          # incrementa di uno il valore contenuto nel registro s4, (il valore contenuto e' interpretato in codice ASCII)
	  
checkDue:                         # confronta la sotto-stringa presente nell'array di appoggio con la stringa "due"
	    la $a0, array 
	    la $a1, due
	    jal strcmp 
	    beq $v0,$zero,uguali
	    addi $s4, $s4, 1
	  
checkTre:                         # confronta la sotto-stringa presente nell'array di appoggio con la stringa "tre"
	    la $a0, array 
        la $a1, tre
        jal strcmp 
	    beq $v0,$zero,uguali
	    addi $s4, $s4, 1
	  
checkQuattro:                     # confronta la sotto-stringa presente nell'array di appoggio con la stringa "quattro"
	    la $a0, array 
        la $a1, quattro
        jal strcmp 
	    beq $v0,$zero,uguali
	    addi $s4, $s4, 1
	  
checkCinque:                      # confronta la sotto-stringa presente nell'array di appoggio con la stringa "cinque"
	    la $a0, array 
        la $a1, cinque
        jal strcmp 
	    beq $v0,$zero,uguali
	    addi $s4, $s4, 1
	  
checkSei:                         # confronta la sotto-stringa presente nell'array di appoggio con la stringa "sei"
	    la $a0, array 
        la $a1, sei
        jal strcmp
        beq $v0,$zero,uguali	  
	    addi $s4, $s4, 1

checkSette:                       # confronta la sotto-stringa presente nell'array di appoggio con la stringa "sette"
	    la $a0, array 
        la $a1, sette
        jal strcmp 
	    beq $v0,$zero,uguali
	    addi $s4, $s4, 1
	  
checkOtto:                        # confronta la sotto-stringa presente nell'array di appoggio con la stringa "otto"
	    la $a0, array 
        la $a1, otto
        jal strcmp 
	    beq $v0,$zero,uguali
	    addi $s4, $s4, 1
	  
checkNove:                        # confronta la sotto-stringa presente nell'array di appoggio con la stringa "nove"
	    la $a0, array 
        la $a1, nove
        jal strcmp
	    beq $v0,$zero,uguali
	  
diversoDaTutto:	                  # entra in questa etichetta solo se la sotto-stringa analizzata e' diversa da tutte le stringhe "numero" precedenti
        sb $s6, result($s5)       # aggiunge il carattere "?" alla stringa finale
        bne $s7, $s0, addSpazio   # controlla se deve aggiungere il carattere "spazio" alla stringa finale per separare le sottosequenze
		addi $s5, $s5, 1          # incrementa di uno l'indice della stringa finale
    	addi $s0, $s0, 1          # incrementa di uno l'indice della stringa inserita in input
		j reset
	  
salta:                            # entra in questa etichetta solo se il carattere "spazio" che è stato inserito nell'array di appoggio e' isolato
        addi $s0, $s0, 1          # incrementa di uno l'indice della stringa inserita in input
	    j reset
	    
uguali:                           # entra in questa etichetta solo se la sotto-stringa presente nell'array di appoggio e' uguale ad una delle stringhe "numero"
        sb $s4, result($s5)       # aggiunge il numero corrispondente compreso tra[1-9] alla stringa finale	
		bne $s7, $s0, addSpazio   # controlla se deve aggiungere il carattere "spazio" alla stringa finale per separare le sottosequenze
		addi $s5, $s5, 1          # incrementa indice della stringa finale
		addi $s0, $s0, 1          # incrementa indice della stringa inserita in input
        j reset
		
addSpazio:                        # aggiunge il carattere "spazio" alla stringa finale per separare le sottosequenze
        addi $s5, $s5, 1          # incrementa di uno l'indice della stringa finale
		sb $s3, result($s5)       # inserisce il carattere "spazio" alla stringa finale 
		addi $s5, $s5, 1          # incrementa di uno l'indice della stringa finale
    	addi $s0, $s0, 1          # incrementa di uno l'indice della stringa inserita in input
		
reset:                            # resetta alcuni registri
        li $s2, 0                 # resetta l'indice dell' array di appoggio
	    li $s4, 49                # resetta il codice ASCII (49->numero 1)
	    j scorriS                 # torna a scorrere la stringa inserita in input
		
strcmp:                                     # funzione per il confronto fra stringhe( ritorna 0 se sono uguali, 1 se sono diverse)
		add $t1,$zero,$a0 					# t1 contiene l'indirizzo di base della prima stringa
		add $t2,$zero,$a1 					# t1 contiene l'indirizzo di base della seconda stringa
		add $t5,$zero, $zero                # inizializza il contatore per lo scorrimento della sotto-stringa contenuta nell'array di appoggio
		move $t6, $s2                       # passa a t6 la dimensione della sotto-stringa da confrontare
		
loop:
		lb $t3,0($t1) 				        # carica in t3, ad ogni ciclo, un carattere della prima stringa
		lb $t4,0($t2)						# carica in t4, ad ogni ciclo, un carattere della seconda stringa
		beq $t5,$t6, check 					# controlla se siamo arrivati all'ultimo carattere della prima stringa, nel caso passa all'etichetta "check"
		beqz $t4,notEqual					# controlla se siamo arrivati all'ultimo carattere della seconda stringa, nel caso passa all'etichetta "notEqual"
		bne $t3,$t4, notEqual 				# controlla se i due caratteri letti sono diversi, nel caso passa all'etichetta "notEqual"
		addi $t1,$t1,1 						# incrementa di uno il valore del registro t1 in modo tale da passare l'analisi al prossimo carattere della prima stringa
		addi $t2,$t2,1                      # incrementa di uno il valore del registro t2 in modo tale da passare l'analisi al prossimo carattere della seconda stringa
		addi $t5, $t5, 1                    # incrementa di uno il valore del contatore per lo scorrimento della sotto-stringa contenuta nell'array di appoggio
        j loop
         
check:
        move $t7, $t2                       # \
		addi $t7, $t7, 1                    #   inserisco nel registro t7 il carattere successivo a quello appena analizzato relativo alla seconda stringa
        lb $t7, 0($t7)                      # / 
        bnez $t7, notEqual                  # controlla se la seconda stringa finira' al prossimo carattere, in tal caso continua con l'istruzione succesiva
		beq $t3, $t4,equal                  # controlla se i due caratteri letti sono uguali, nel caso passa all'etichetta "equal"
		j notEqual                               
		
equal:                         # entra in questa etichetta solo se le due stringhe sono uguali
		li $v0,0               # inserisce il valore 0 nel registro v0
		jr $ra

notEqual:                      # entra in questa etichetta solo se le due stringhe sono diverse
		li $v0, 1              # inserisce il valore 1 nel registro v0
		jr $ra

stampaRes:      
		la $a0, output         # stampa il messaggio per la stringa di output
		li $v0, 4
		syscall
        
        la $a0, result         # stampa la stringa finale
		li $v0, 4
		syscall
		
exit:  
	    li $v0, 10             # uscita dal programma
	    syscall