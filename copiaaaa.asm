.macro printInt(%num)
	li $v0 1
	move $a0 %num
	syscall
.end_macro
.data

bienvenida: .asciiz "--------Bienvenidos a nuestra calculadora--------\n"

enunciado: .asciiz "Con esta calculadora se podran realizar una serie de tres operaciones: SUMA, RESTA, MULTIPLICACION. Con la unica restriccion de que solo \n se puede introducir numeros con un maximo de 50 digitos \n[1] + (Suma) \n[2] - (Resta) \n[3] x (Multiplicacion)\n "

warning: .asciiz "OPCION INVALIDA"

count_msg: .asciiz "\nCantidad de digitos: "

count1: .word 0
count2: .word 0

ingresarNum1: .asciiz "Ingrese el numero 1:  "
ingresarNum2: .asciiz "Ingrese el numero 2:  "
ResultadoOperacion: 
Resultado: .asciiz "El resultado es: "
acarrear: .asciiz "toca acarreo"

numero1:	.space 53
numero2:	.space 53
resultado:	.space 54

meter: .asciiz  "va a meter"


igual: .asciiz "igual"
noigual: .asciiz "no igual"


espacio: .asciiz "\n"
.text
li $s7 10
presentacion:


	li   $v0,4
	la   $a0, bienvenida
	syscall

	li   $v0,4
	la   $a0, enunciado
	syscall


	li  $v0, 5
	syscall
	move $t9, $v0
			
	beq $t9, 1, input
	beq $t9, 2, input
	beq $t9, 3, input
	beq $t9, 4, invalido
	j invalido
				
invalido:	li $v0, 4
		la $a0, warning
		syscall
		j presentacion
		
		
input:		
			li $v0, 4
			la $a0, ingresarNum1
			syscall
	
			li $v0, 8
			la $a0, numero1
			la $a1, 51
			syscall
		
			
	
			li $v0, 4
			la $a0, ingresarNum2
			syscall
			
			li $v0, 8
			la $a0, numero2
			la $a1, 51
			syscall
			
cabtidadDigitos:

	li $t0, 0      
    	li $t1, 0 	
			
	loop:
        lbu $s0, numero1($t0)      
        lbu $s1, numero2($t0)      
        
  
        beq $s0, $s1, next
      
        bgt $s0, $s1, found
        j next
        
        found:
            li $t1, 1
            j next
        
        next:
            addi $t0, $t0, 1        
            bne $s0, $zero, loop    
            
            				
contarDigitos:

  
 la $t0, numero1  
    li $t1, 0   
count_digits1_loop:
    lb $t2, ($t0)  
    beqz $t2, print_counts  
    addi $t0, $t0, 1  
   
    blt $t2, 48, count_digits1_loop 
    bgt $t2, 57, count_digits1_loop  
    addi $t1, $t1, 1  
    j count_digits1_loop
  
  
print_counts:
 
    	move $t6 $t1
    
	
	
   
    li $v0, 4
    la $a0, count_msg
    syscall

    
  
  	li $v0, 1        
	move $a0, $t6  
	syscall  
  	
  	
  #NUMERO 2 -------------------------------------------------------------------------------------------------------
  
  
   la $t0, numero2  
    li $t1, 0   
count_digits2_loop:
    lb $t2, ($t0) 
    beqz $t2, print_counts2 
    addi $t0, $t0, 1  
   
    blt $t2, 48, count_digits2_loop  
    bgt $t2, 57, count_digits2_loop  
    addi $t1, $t1, 1  
    j count_digits2_loop
  
  
print_counts2:
   
	move $t7 $t1
    
	
	
    
    li $v0, 4
    la $a0, count_msg
    syscall

 
  
  	li $v0, 1       
	move $a0, $t7  
	syscall  
  
  
   li $v0, 4
	la $a0, espacio
	syscall
 
  
detectarsigno:



	li $t1 0
	




	lb $t2 numero1($t1)

	


	lb $t3 numero2($t1)
    
 	
 	
 	beq $t3 $t2 iguales
	bne  $t3 $t2 noiguales

iguales:
	
	
	j sumaconacarreo
	
noiguales:	
	
	j end












######################################## SUMA #########################################################

sumaconacarreo:

move $t5 $t6
subi $t5 $t5 1
j mayorprimero

mayorprimero:

	#printInt($t6)
 	#printInt($t5)
 	
 	
	li $t1 0
	li $t2 0
	li $t4 0



	lb $t2 numero2($t6)
	lb $t3 numero1($t7)

	subi $t2  $t2 48

 	subi $t3 $t3 48
 
 	add $t4 $t3 $t2
 	
	
	
	blt   $t7 1 seacabo1
	
	bgt $t4 9 acarreo
	
	
	j noacarreo

	
seacabo1:
	#printInt($t6)
 	#printInt($t5)
 	
	
 	lb $s1 numero1($t6)
 	
 	
 	li $v0, 4
	la $a0, espacio
	syscall
	
	
	subi $s1 $s1 48
 	
 	
 	
 	#j end
	
	addi $s1 $s1 48
	sb $s1 resultado($t5)
 
 	subi $t6 $t6 1
	subi $t5 $t5 1
 	bnez  $t6  seacabo1
 

 	j imprimir	
				
						
								
										
												
																
			
					

acarreo:
	li $s4 1

	
	div $t4 $s7
	#lo que se va a poner en el resultado $v0
	mfhi $s0
	addi $s0 $s0 48
	sb $s0 resultado($t5)
	
	beq $t6 $s4 ultimodigito
	j sumarlado
	
	
	
ultimodigito:
	li $v0, 4
	la $a0, Resultado
	syscall
 	
printInt($s4)

j imprimir
	
	
	
	
	
	
	
sumarlado:
	subi $t7 $t7 1
	subi $t6 $t6 1
	subi $t5 $t5 1	
	lb $v1 numero1($t6)
	subi $v1 $v1 47
	
	
	addi $v1 $v1 48
	sb $v1 numero1($t6)
	
	j mayorprimero
		
	
	

	
	
	
	
	

noacarreo:
	
	addi $t4 $t4 48
	
	
 	sb $t4 resultado($t5)
 	
 	
 	
 	subi $t7 $t7 1
	subi $t6 $t6 1
	subi $t5 $t5 1
 
 	bnez $t6 mayorprimero
 

 	j imprimir
 
 
 imprimir:
 
 	
 	li $v0, 4
	la $a0, resultado
	syscall
 				
end:
li $v0  10
syscall
