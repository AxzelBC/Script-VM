#! /usr/bin/bash

#################################################################################################
#                                                                                               #
# Nombre: WM-script.sh                                                                          #
#                                                                                               #
# Descripción:  el script descarga una iso de Arch linux (64 bits) y la usa para crear          #
#               una máquina virtual.                                                            #
#                                                                                               #
# Fecha: 30/09/2021.                                                                            #
#                                                                                               #
# Autor: @Axzel {alejo13580@gmail.com}                                                          #
# Estudiante: Alejandro Cardona Mosquera - 2022499                                              #
# Autor: @Akira                                                                                 #
# Estudiante: [Nombre] - [Código]                                                               #
#                                                                                               #
#################################################################################################

# Descarga de la ISO.
wget http://mirrors.udenar.edu.co/archlinux/iso/2021.09.01/archlinux-2021.09.01-x86_64.iso


# Definición e inicialización de la variable WM. Esta será usada para refrenciar nuestra máquina.
VM='Arch-Linux-64bits'

# Creación de un disco dínamico de 32Gb
VBoxManage createhd --filename $VM.vdi --size 20480


# Creación de la máquina virtual.
VBoxManage createvm --name $VM --ostype "ArchLinux_64" --register


# Se agrega un controldaor SATA con el controlador del disco adjunto.
VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VM.vdi

# Adición de controlador de disco para instalar SO.
VBoxManage storagectl $VM --name "IDE Controller" --add ide
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium archlinux-2021.09.01-x86_64.iso


# Configuración general del sistema.
#
#
VBoxManage modifyvm $VM --ioapic on
# Configuración de booteo de la BIOS.
VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none
# Configuración de la tarjera y adaptadores de Red.
VBoxManage modifyvm $VM --nic1 bridged --bridgeadapter1 eno1
# Memoria RAM y memoria de vídeo.
VBoxManage modifyvm $VM --memory 1024 --vram 64


# Comando de arranque.
# VBoxHeadless -s $VM