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
Seacabo: .asciiz "se acabo 2"

Suma1: .asciiz "Entro en el buqule 1 "
Suma2: .asciiz "Entro en el buqule 2 "




mas: .asciiz "+"
menos: .asciiz "-"

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

	li $v0, 4
	la $a0, Resultado
	syscall
	
	beq $t3 43 imprimirmas
	beq $t3 45 imprimirmenos

	
			
imprimirmas:
	li $v0, 4
	la $a0, mas
	syscall
		
	
	j vercualmayor
	
imprimirmenos:
	li $v0, 4
	la $a0, menos
	syscall
	
	j vercualmayor
	
	
noiguales:	

	li $v0, 4
	la $a0, Resultado
	syscall
	
	j resta

vercualmayor:
	
bgt $t6 $t7 sumaconacarreo1
bgt $t7 $t6 sumaconacarreo2
j sumaconacarreo1

	
######################################## SUMA #########################################################


#MAYOR ES EL PRIMERO---------------------------------------------------
sumaconacarreo1:
	


move $t5 $t6
subi $t5 $t5 1
j mayorprimero

mayorprimero:

 	
	li $t1 0
	li $t2 0
	li $t4 0



	lb $t2 numero2($t7)
	lb $t3 numero1($t6)

	subi $t2  $t2 48

 	subi $t3 $t3 48
 
 	add $t4 $t3 $t2
 	
	
	
	
	
	blt   $t7 1 seacabo1
	
	
	bgt $t4 9 acarreo
	
	
	j noacarreo

	
seacabo1:

	
 	lb $s1 numero1($t6)

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

 
  
#MAYOR SEGUNDO -------------------------------------------------------
 sumaconacarreo2: 

move $t5 $t7
subi $t5 $t5 1
j mayorsegundo

mayorsegundo:

 	
	li $t1 0
	li $t2 0
	li $t4 0



	lb $t2 numero2($t7)
	lb $t3 numero1($t6)

	subi $t2  $t2 48

 	subi $t3 $t3 48
 
 	add $t4 $t3 $t2
 	
	
	
	
	
	blt   $t6 1 seacabo2
	
	
	bgt $t4 9 acarreo2
	
	
	j noacarreo2

	
seacabo2:
 	
 	
 	
 	lb $s1 numero2($t7)
	
	
	sb $s1 resultado($t5)
	
 	
 	subi $t7 $t7 1
	subi $t5 $t5 1
 	bnez  $t7  seacabo2
 

 	j imprimir	
					

acarreo2:
	li $s4 1

	
	div $t4 $s7
	#lo que se va a poner en el resultado $v0
	mfhi $s0
	addi $s0 $s0 48
	sb $s0 resultado($t5)
	
	beq $t7 $s4 ultimodigito2
	j sumarlado
	
	
	
ultimodigito2:
	li $v0, 4
	la $a0, Resultado
	syscall
 	
printInt($s4)

j imprimir
	
	
	
	
	
	
	
sumarlado2:
	subi $t7 $t7 1
	subi $t6 $t6 1
	subi $t5 $t5 1	
	lb $v1 numero2($t7)
	subi $v1 $v1 47
	
	
	addi $v1 $v1 48
	sb $v1 numero2($t7)
	
	j mayorsegundo
	

noacarreo2:
	
	addi $t4 $t4 48
	
	
 	sb $t4 resultado($t5)
 	
 	
 	
 	subi $t7 $t7 1
	subi $t6 $t6 1
	subi $t5 $t5 1
 
 	bnez $t7 mayorsegundo
 

 	j imprimir
    
      
#############################################################   Resta   ########################################################################

# $t5 contiene el valor de la long mas larga -1
# $t6 es la long del primer num
# $t7 es la long del seg num

resta:

		blt $t7, $t6, largoPrimNum	# si $t7 es menor que $t6, num1 es mas largo
		blt $t6, $t7, largoSegNum	# si $t6 es menor que $t7, num2 es mas largo
		beq $t6, $t7, comprobarMayor	# si $t6 y $t7 son iguales


################## num1 es mas largo asi que se le restara num2

largoPrimNum:
		beqz $t7, imprimirRestoLargo	# $t7 = 0 significa que num2 se acabo
		bnez $t7, sigoRest
		
		imprimirRestoLargo:# imprimir desde num1($t6)hasta que $t6 = 0
			beqz $t6, termine	# se acabaron digitos de num1
			lb $v1, numero1($t6)
			
			sb $v1, resultado($t5)	#cargo en el resultado el digito
			subi $t6, $t6, 1
			subi $t5, $t5, 1
			j imprimirRestoLargo

		sigoRest:
		
		li $t1, 0
		li $t2, 0
		li $t4, 0	# resultado de resta dos digitos
		li $t9, 0
		lb $t8, numero1($t9)	# signo del numero 1
		
		move $t5 $t6
		subi $t5 $t5 1
		
		loopLargoPrim:
			beqz $t6, termine
			
			lb $t2, numero1($t6)	# digito n de num 1
			lb $t3, numero2($t7)	# digito n de num 2
			
			# restar 48 para obtener el valor entero
			subi $t2, $t2, 48
 			subi $t3, $t3, 48
 
 			sub $t4, $t2, $t3	#resultado resta de los dos digitos
 		
 			bltz $t4, acarrearLargoPrim	# si resta < 0, toca acarrear
 			bgez $t4, restadoNormalLargoPrim # si resta >= 0 resto normal
 			
acarrearLargoPrim:
		addi $t2, $t2, 10	# sumo 10 al digito de arriba, el del numero mayor
       		sub $t4, $t2, $t3	# realizo otra vez la resta
        		addi $t4, $t4, 48
        		
        		sb $t4 resultado($t5)	# escribo valor en el resultado
        		
        		subi $t7 $t7 1
        		subi $t6 $t6 1
        		subi $t5 $t5 1
        		
        		# resto 1 al numero siguiente		
        		lb $v1 numero1($t6)	
        		subi $v1 $v1 1
        		sb $v1 numero1($t6)
		
		bnez $t7, loopLargoPrim
		j largoPrimNum

restadoNormalLargoPrim:		
	 	#lo que se va a poner en el resultado $v0
		addi $t4 $t4 48	#sumo 48 al entero para ponerlo en cadena
		sb $t4 resultado($t5)
		
		subi $t6, $t6, 1
		subi $t7, $t7, 1
		subi $t5, $t5, 1
		
		bnez $t7, loopLargoPrim
		j largoPrimNum
		

##################### num 2 es mas largo por lo que se le restara num1

largoSegNum:
		beqz $t6, imprimirRestoLargo2	# $t6 = 0 significa que num1 se acabo
		bnez $t6, sigoRestInv
		
		imprimirRestoLargo2:# imprimir desde num2($t7)hasta que $t7 = 0
			beqz $t7, termine
			lb $v1, numero2($t7)
			
			sb $v1, resultado($t5)
			subi $t7, $t7, 1
			subi $t5, $t5, 1
			j imprimirRestoLargo2

	sigoRestInv:
		
		li $t1, 0
		li $t2, 0
		li $t4, 0	# resultado de resta dos digitos
		li $t9, 0
		lb $t8, numero2($t9)
		
		move $t5 $t7
		subi $t5 $t5 1
		
		loopLargoSeg:
			beqz $t7, termine
			
			lb $t2, numero2($t7)	# digito n de num 2
			lb $t3, numero1($t6)	# digito n de num 1
			
			# restar 48 para obtener el valor entero
			subi $t2, $t2, 48
 			subi $t3, $t3, 48
 
 			sub $t4, $t2, $t3	#resultado resta de los dos digitos
 		
 			bltz $t4, acarrearLargoSeg	# si resta < 0, toca acarrear
 			bgez $t4, restadoNormalLargoSeg # si resta >= 0 sigo normal
				
acarrearLargoSeg:
		addi $t2, $t2, 10	# sumo 10 al digito de arriba, el del numero mayor
       		sub $t4, $t2, $t3	# realizo otra vez la resta
        		addi $t4, $t4, 48
        		
        		sb $t4 resultado($t5)	# escribo valor en el resultado
        		
        		subi $t7 $t7 1
        		subi $t6 $t6 1
        		subi $t5 $t5 1
        		
        		# resto 1 al numero siguiente		
        		lb $v1 numero2($t7)	
        		subi $v1 $v1 1
        		sb $v1 numero2($t7)
		
		bnez $t6, loopLargoSeg
		j largoSegNum

restadoNormalLargoSeg:
		#lo que se va a poner en el resultado $v0
		addi $t4 $t4 48
		sb $t4 resultado($t5)
		
		subi $t6, $t6, 1
		subi $t7, $t7, 1
		subi $t5, $t5, 1
		
		bnez $t6, loopLargoSeg
		j largoSegNum
		
		
##################### num1 y num2 tienen igual longitud, aqui se comprueba cual es mayor

comprobarMayor:
		# $t3 y $t4 son numeros en la posicion dada por $t1 y $t2
		
		li $t1, 1
		li $t2, 1
		
		loopCompMayor:
			lb $t3, numero1($t1)	#carga el numero de la posicion $t1 del numero 1
			lb $t4, numero2($t2)	#carga el numero de la posicion $t2 del numero 2
			
			# restar 48 para obtener el valor entero
			subi $t3, $t3, 48
 			subi $t4, $t4, 48
 		
 			# 3 casos, $t3 > $t4, o menor o iguales
 			
 			blt $t3, $t4, mayorSegNum
 			blt $t4, $t3, mayorPrimNum
 			beq $t3, $t4, siga
 		
 			siga:
 				beq $t1, $t6, resultadoCero	# Los numeros ingresados son iguales
 				addi $t1, $t1, 1
 				addi $t2, $t2, 1
 				b loopCompMayor


####################### num1 es mayor que num2 teniendo el mismo tamanio

 mayorPrimNum:
		li $t1, 0
		li $t2, 0
		li $t4, 0	# resultado de resta dos digitos
		li $t9, 0
		lb $t8, numero1($t9)
		
		move $t5 $t6
		subi $t5 $t5 1
		
		loopMayorPrim:
			beqz $t6, termine
			
			lb $t2, numero1($t6)	# digito n de num 1
			lb $t3, numero2($t7)	# digito n de num 2
			
			# restar 48 para obtener el valor entero
			subi $t2, $t2, 48
 			subi $t3, $t3, 48
 
 			sub $t4, $t2, $t3	#resultado resta de los dos digitos
 		
 			bltz $t4, acarrearResta	# si resta < 0, toca acarrear
 			bgez $t4, restadoNormal # si resta >= 0 sigo normal
 				
termine:
	# llama a imprimir el signo del resultado y luego llama a 'imprimir' para mostrar el resultado
	beq $t8 43 imprimirMas
	beq $t8 45 imprimirMenos
	j imprimir
	
imprimirMas:
	li $v0, 4
	la $a0, mas
	syscall
	j imprimir
	
imprimirMenos:
	li $v0, 4
	la $a0, menos
	syscall
	j imprimir			
 			
 acarrearResta:
		addi $t2, $t2, 10	# sumo 10 al digito de arriba, el del numero mayor
       		sub $t4, $t2, $t3	# realizo otra vez la resta
        		addi $t4, $t4, 48
        		
        		sb $t4 resultado($t5)	# escribo valor en el resultado
        		
        		subi $t7 $t7 1
        		subi $t6 $t6 1
        		subi $t5 $t5 1
        		
        		# resto 1 al numero siguiente		
        		lb $v1 numero1($t6)	
        		subi $v1 $v1 1
        		sb $v1 numero1($t6)
		
		bnez $t6, loopMayorPrim
		j mayorPrimNum

 restadoNormal:		
	 	#lo que se va a poner en el resultado $v0
		addi $t4 $t4 48
		sb $t4 resultado($t5)
		
		subi $t6, $t6, 1
		subi $t7, $t7, 1
		subi $t5, $t5, 1
		
		bnez $t6, loopMayorPrim
		j mayorPrimNum
		
		
###################### num 2 es mayor que num1 teniendo la misma longitud

 mayorSegNum:# se hara una resta invertida
 		li $t1, 0
		li $t2, 0
		li $t4, 0	# resultado de resta dos digitos
		li $t9, 0
		lb $t8, numero2($t9)
		
		move $t5 $t7
		subi $t5 $t5 1
		
		loopMayorSeg:
			beqz $t6, termine
			
			lb $t2, numero2($t7)	# digito n de num 2
			lb $t3, numero1($t6)	# digito n de num 1

			subi $t2, $t2, 48
 			subi $t3, $t3, 48
 
 			sub $t4, $t2, $t3	#resultado resta de los dos digitos
 		
 			bltz $t4, acarrearRestaInv	# si resta < 0, toca acarrear
 			bgez $t4, restadoNormalInv # si resta >= 0 sigo normal
				
acarrearRestaInv:
		addi $t2, $t2, 10	# sumo 10 al digito de arriba, el del numero mayor
       		sub $t4, $t2, $t3	# realizo otra vez la resta
        		addi $t4, $t4, 48
        		
        		sb $t4 resultado($t5)	# escribo valor en el resultado
        		
        		subi $t7 $t7 1
        		subi $t6 $t6 1
        		subi $t5 $t5 1
        		
        		# resto 1 al numero siguiente		
        		lb $v1 numero2($t7)	
        		subi $v1 $v1 1
        		sb $v1 numero2($t7)
		
		bnez $t7, loopMayorSeg
		j mayorSegNum

restadoNormalInv:
		#lo que se va a poner en el resultado $v0
		addi $t4 $t4 48
		sb $t4 resultado($t5)
		
		subi $t6, $t6, 1
		subi $t7, $t7, 1
		subi $t5, $t5, 1
		
		bnez $t7, loopMayorSeg
		j mayorSegNum

 resultadoCero:
		li $v0, 1
		li $a0, 0
		syscall

imprimir:
 	li $v0, 4
	la $a0, resultado
	syscall
 				
end:
	li $v0  10
	syscall
