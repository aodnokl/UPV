# ============================================================
#  Practica 1 - AIC-IA: Instrucciones basicas RISC-V
# ============================================================

    .data  # (datos comienzan en 0x10000000)
a:  .word  0x00A0FF81     # (dato a)
b:  .word  0x00000001     # (dato b)
c:  .word  0x00000000     # (resultado)
d:  .word  0x00000000     # (otro resultado)


    .text  # (código comienza en 0x00000000)
    .globl main
main:
    # --- PREPARACION ---
    lui x10,0x10000       # x10 <- 0x10000000 (apunta a a:)

    # --- LOAD: Lectura de datos desde memoria ---
    lw  x11, 0(x10)       # x11 <- MEM[a]
    lw  x12, 4(x10)       # x12 <- MEM[b] (desplazamiento de 4 bytes)

    # --- ALU: Operaciones aritmeticas ---
    add x13, x11, x12     # x13 <- x11 + x12
    addi x14, x11, -1     # x14 <- x11 - 1

    # --- STORE: Escritura del resultado en memoria ---
    sw x13, 8(x10)        # MEM[c] <- x13 (desplazamiento de 8 bytes)

    # --- BRANCH: Salto condicional ---
    beq x14, x0, iguales  # si x14 == 0, saltar a la etiqueta 'iguales'

    # Si x4 != 0 
    addi x15, x0, 0       # x15 <- 0
    j fin                 # salto incondicional a 'fin'
    
iguales:
    addi x15, x0, 1       # x15 <- 1

fin:
    sw x15,12(x10)        # MEM[d] <- x15 (desplazamiento de 12 bytes)
    
    # --- FIN DE EJECUCION ---
    addi x17, x0, 10      # x17 (a7) = 10 (Codigo para syscall Exit)
    ecall                 # Llamada al sistema (detiene el simulador)