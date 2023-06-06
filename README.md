# Contador 10 bits (con interrupciones).

## 1. Funcionamiento del proyecto.

EL proyecto consiste en un contador ascendente-descendente de 10 bits que posee dos botones que tienen como proposito dos tareas: el boton A aumenta la velocidad de la cuenta, mientras que el boton B sirve para cambiar el modo de cuenta, es decir de ascendente a descendente. Estas dos funcionalidades fueron implementadas mediante el uso de interrupciones externas. Para el uso de una interrupcion es importante saber que se tiene que configurar un pin GPIO como entrada, ademas de configurar una fuente de interrupcion externa para los pines con los cuales se desea trabajar. Es importante saber que constante de configuracion asignar para que se realice el disparo, en el caso de este proyecto se usaron los pines B0 y B4, por lo cual se tendria que encender los bits en 1 segun la hoja de especificaciones de EXTI_PR. Tambien es importante recalcar que las interrupciones programadas se agreguen al apartado de NVIC.
## A continuacion se presenta una diagrama de flujo con el funcionamiento del programa:

![Diagrama sin título-Página-3 drawio (4)](https://github.com/paprikadreamdetective/Contador-10-bits-con-interrupciones-/assets/133156970/d2a0c5b1-4667-4c78-9cee-c0a8331960cc)

## 2. Compilacion.
Para la compilacion del proyecto es necesario tener instalado el compilador cruzado de arm, la utilidad para grabar el programa en el grabador a usar y la utilidad make. El comando de instalacion es el siguiente: 
```asm
sudo apt install stlink-tools gcc-arm-none-eabi make

```
Este comando funciona siempre y cuando se este trabajando bajo una distribucion de linux basada en ubuntu.
Una vez se haya instalado correctamente los paquetes correspondientes queda realizar la compilacion de nuestro programa, para esto es importante tener los archivos .inc en el mismo directorio en el que se encuentran los archivos fuente del programa. Los archivos .inc contienen las compensaciones y la direccion base para poder configurar los registros GPIO. La compilacion se hace mediante los siguientes comandos:
```asm
$ make clean
$ make 
$ make write
```
make clean: Sirve para eliminar los codigo objeto .o.
make: Crea los codigos objeto con base en los archivos fuente .s.
make write: Sirve para grabar los archivos .bin en la tarjeta.

Tambien hay que tener en cuenta que si el codigo fuente fue escrito en diferentes archivos, entonces los archivos con terminacion .s tendran que ser añadidos a la linea 10 del makefile ya que si no se agregan el compilador no tomara en cuenta dichos archivos.

Otro punto a destacar es que si se escribieron las interrupciones en archivos fuente es importante tambien incluirlos, como se muestra en el siguiente comando: 

```asm
# List of source files
SRCS = cnt10.s ivt.s default_handler.s reset_handler.s delay.s exti_isr.s systick_isr.s speed.s # En esta parte van los archivos fuente a compilar
```
## 3. Diagrama del hardware.
Para las salidas de los leds, se usaron los pines A0-A9, para las entradas de los pines B0 y B4 correspondientes a las interrupciones configuradas anteriormente.

![esquematicop4](https://github.com/paprikadreamdetective/Contador-10-bits-con-interrupciones-/assets/133156970/0b5359ef-4d1a-4fbe-b21a-3959a0da7f5a)




