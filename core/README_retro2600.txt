StellaBlue - Retro2600: An FPGA clone of the Atari 2600 based on [Retromaster]'s cores.

-------------------------------------------------------------------------------

This project aims to use the hardware with the original atari cartridge configuration. Additionaly, the board also supports the original Paddle Controller (not fully tested) and the standard one.

The quartus project contains the glue logic to join the Retromaster's cores to the hardware (EP2C5T144 board - AKA "cheap FPGA blue board").

Using a fpga blaster; upload the "retro2600.pof" file via "Active Serial Programming". The device is EPCS4. Check the programming options "Program/Configure; Verifiy and Blank-Check".

[Danjovic]  (Daniel Jose Viana)
Websites:	danjovic.blogspot.com ; hackaday.io/danjovic & github.com/Danjovic
email:		danjovic@hotmail.com


[rflamino] (Reinaldo de Sales Flamino)
Website:	hackaday.io/rflamino
email:		reinaldosflamino@gmail.com

[Danjovic]: <https://hackaday.io/danjovic/>
[rflamino] : <https://hackaday.io/rflamino/>
[Retromaster]: <https://retromaster.wordpress.com/a2601/>