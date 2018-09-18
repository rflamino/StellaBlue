# StellaBlue

StellaBlue AKA Retro2600: An FPGA-based clone of the Atari 2600 based on [Retromaster]'s cores.

-------------------------------------------------------------------------------

This project aims to use the hardware with the original atari cartridge configuration. Additionaly, the board also supports original Paddle Controller (not fully tested) and the standard one.

The quartus project contains the glue logic to join the Retromaster's cores to the hardware (EP2C5T144 board - AKA "cheap FPGA blue board").

Using a fpga blaster; upload the "retro2600.pof" file via "Active Serial Programming". The device is EPCS4. Check the programming options "Program/Configure; Verifiy and Blank-Check".

The file "CartridgeGuide.stl" contains a Cartridge Guide socket. Print it! - with a 3D printer :)


rflamino AKA (Reinaldo de Sales Flamino)
Website:	[hackaday.io/rflamino]
email:		reinaldosflamino@gmail.com

[Danjovic]  AKA (Daniel Jose Viana)
Websites:	[danjovic.blogspot.com] & [hackaday.io/danjovic]
email:		danjovic@hotmail.com


[Danjovic]: <https://hackaday.io/danjovic/>
[hackaday.io/rflamino]: <https://hackaday.io/rflamino/>
[danjovic.blogspot.com]: <https://danjovic.blogspot.com/>
[hackaday.io/danjovic]: <https://hackaday.io/danjovic/>
[Danjovic]: <https://github.com/Danjovic/>
[Retromaster]: <https://retromaster.wordpress.com/a2601/>


First PCB!

![alt text](https://github.com/rflamino/StellaBlue/blob/master/pictures/StellaBlue.jpg
)

Working!

![alt text](https://github.com/rflamino/StellaBlue/blob/master/pictures/20161107_231717.jpg)
