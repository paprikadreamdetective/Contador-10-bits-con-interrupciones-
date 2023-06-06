# Contador 10 bits (con interrupciones).

## 1. Funcionamiento del proyecto.

EL proyecto consiste en un contador ascendente-descendente de 10 bits que posee dos botones que tienen como proposito dos tareas: el boton A aumenta la velocidad de la cuenta, mientras que el boton B sirve para cambiar el modo de cuenta, es decir de ascendente a descendente. Estas dos funcionalidades fueron implementadas mediante el uso de interrupciones externas. Para el uso de una interrupcion es importante saber que se tiene que configurar un pin GPIO como entrada, ademas de configurar una fuente de interrupcion externa para los pines con los cuales se desea trabajar. Es importante saber que constante de configuracion asignar para que se realice el disparo, en el caso de este proyecto se usaron los pines B0 y B4, por lo cual se tendria que encender los bits en 1 segun la hoja de especificaciones de EXTI_PR. Tambien es importante recalcar que las interrupciones programadas se agreguen al apartado de NVIC.
## A continuacion se presenta una diagrama de flujo con el funcionamiento del programa:

![Diagrama sin título-Página-3 drawio (4)](https://github.com/paprikadreamdetective/Contador-10-bits-con-interrupciones-/assets/133156970/d2a0c5b1-4667-4c78-9cee-c0a8331960cc)
