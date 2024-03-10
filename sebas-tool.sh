 #!/bin/bash

# ███████╗███████╗██████╗  █████╗ ███████╗    ████████╗ ██████╗  ██████╗ ██╗
# ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝    ╚══██╔══╝██╔═══██╗██╔═══██╗██║
# ███████╗█████╗  ██████╔╝███████║███████╗       ██║   ██║   ██║██║   ██║██║
# ╚════██║██╔══╝  ██╔══██╗██╔══██║╚════██║       ██║   ██║   ██║██║   ██║██║
# ███████║███████╗██████╔╝██║  ██║███████║       ██║   ╚██████╔╝╚██████╔╝███████╗
# ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚══════╝       ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝
##############################################################################################
<< COMMENT
   AVVERTENZE
   Questo script è stato pensato per puro esercizio ludico, con la finalità di impostare in
   fretta la medesima configurazione in uso sul mio notebook, un Asus ROG Zephyrus del 2022,
   edizione AMD Advantage.
   Non è pensato per essere utilizzato direttametne da altri, ma secondo lo spirito dell'open
   source, usalo a tuo più completo piacimento per poter impostare il tuo...
   Nello script sono presenti diversi rimandi a progetti già presenti su GitHub, si fa chiaro
   riferimento ai rispettivi autori per i crediti.
   INOLTRE
   Vi sono messaggi di errore pensati per essere easter egg personali, se vuoi usare questo
   script, comincia con il cambiarli...
COMMENT
##############################################################################################
# Verifica se git è già installato
if ! command -v git &> /dev/null; then
    echo "Git non è installato. Procedo con l'installazione..."
    sudo pacman -Sy --noconfirm git || { echo 'Purtroppo Demarinis mi ha licenziato... prendo le scale e arrivederci.'; exit 1; }
fi
##############################################################################################
# Verifica se paru è già installato
if ! pacman -Qs paru &>/dev/null; then
    echo "Paru non è installato. Procedo con l'installazione..."
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ..
    rm -rf paru
fi
##############################################################################################
#Installazione del repo di Asus-Linux
installa_asus_linux() {
    echo "Installazione del repository asus-linux..."
    pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
    pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
    wget "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x8b15a6b0e9a3fa35" -O g14.sec
    sudo pacman-key -a g14.sec
    echo "[g14]" | sudo tee -a /etc/pacman.conf
    echo "Server = https://arch.asus-linux.org" | sudo tee -a /etc/pacman.conf
    paru -Syu
    paru -S asusctl supergfxctl rog-control-center
    sudo systemctl enable --now power-profiles-daemon.service
    sudo systemctl enable --now supergfxd
}
##############################################################################################
# Chaotic-AUR
installa_chaotic_aur_repo() {
    echo "Installazione del repository chaotic-aur..."
    pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    pacman-key --lsign-key 3056513887B78AEB
    pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    paru -Syu
}
##############################################################################################
# Fish SHELL - DA ERRORE ALLA RIGA " [ "$switch_user_shell" == "y" ]; then "
#installa_fish_shell() {
#    echo "Fish in the Shell". Cercando Scarlett Johansson in mezzo ai tonni...""
#    sudo pacman -Sy --noconfirm fish || { echo 'Purtroppo Demarinis mi ha licenziato... prendo le scale e arrivederci.'; exit 1; }
#    read -p "Vuoi andare a pescare nel terminale? (y/n): " switch_user_shell
#    [ "$switch_user_shell" == "y" ]; then
#        if chsh -s "/usr/bin/fish"; then
#            echo "La pescheria è aperta... usa il suo potere con responsabilità."
#        else
#            echo "Perché non ringrazi per tutto il pesce?." >&2
#        exit 1
#        fi
#    read -p "Vuoi dare pesci alla radice? (y/n): " switch_root_shell
#        if [ "$switch_root_shell" == "y" ]; then
#            if sudo chsh -s "/usr/bin/fish" root; then
#                echo "Anche il terminale di root ora puzza di merluzzo."
#            else
#                echo "Perché non vuoi che nemmeno Root possa mangiare il pesce?." >&2
#            exit 1
#            fi
#        else
#            echo "Root in the Shell rimasta uguale, la Johansson faceva schifo come Kusanagi."
#        fi
#}
##############################################################################################
# Supporto flatpak                                     
supporto_flatpak() {
    echo "Installazione del supporto per flatpak..."
    paru -S flatpak flatpak-builder flatpak-xdg-utils
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}
aggiorna_flatpak() {
    echo "Aggiornamento dei pacchetti Flatpak in corso..."
    flatpak update
    # Verifica se l'aggiornamento dei pacchetti Flatpak è avvenuto con successo
    if [ $? -eq 0 ]; then
        echo "Aggiornamento dei pacchetti Flatpak completato con successo! 🎉"
    else
        echo "Errore durante l'aggiornamento dei pacchetti Flatpak."
        echo "Vuoi riprovare? (Sì/No)"
        read riprova_scelta
        case $riprova_scelta in
            [Ss]*) aggiorna_flatpak ;;  # Riprova l'aggiornamento
            *) echo "Tornando al menu principale..." ;;
        esac
    fi
}
##############################################################################################
# ROG Grub Theme
installa_rog_grub() {
git clone https://github.com/thekarananand/ROG_GRUB_Theme
cd ROG_GRUB_Theme
chmod +x install.sh
sudo ./install.sh
}
##############################################################################################
# AGGIORNAMENTI
aggiorna_sistema_e_flatpak() {
    echo "Aggiornamento dei pacchetti di sistema in corso..."
    paru -Syu  # Comando per l'aggiornamento dei pacchetti di sistema
    # Verifica se l'aggiornamento dei pacchetti di sistema è avvenuto con successo
    if [ $? -eq 0 ]; then
        echo "Aggiornamento dei pacchetti di sistema completato con successo! 🎉"
    else
        echo "Errore durante l'aggiornamento dei pacchetti di sistema."
        echo "Vuoi riprovare? (Sì/No)"
        read riprova_scelta
        case $riprova_scelta in
            [Ss]*) aggiorna_sistema_e_flatpak ;;  # Riprova l'aggiornamento
            *) echo "Tornando al menu principale..." ;;
        esac
    fi
    echo "Aggiornamento dei pacchetti Flatpak in corso..."
      flatpak update  # Comando per l'aggiornamento dei pacchetti Flatpak
    # Verifica se l'aggiornamento dei pacchetti Flatpak è avvenuto con successo
    if [ $? -eq 0 ]; then
        echo "Aggiornamento dei pacchetti Flatpak completato con successo! 🎉"
    else
        echo "Errore durante l'aggiornamento dei pacchetti Flatpak."
        echo "Vuoi riprovare? (Sì/No)"
        read riprova_scelta
        case $riprova_scelta in
            [Ss]*) aggiorna_sistema_e_flatpak ;;  # Riprova l'aggiornamento
            *) echo "Tornando al menu principale..." ;;
        esac
    fi
}
##############################################################################################
# PACCHETTI
# Lista di pacchetti obbligatori
pacchetti_obbligatori() {
echo "Installazione di pacchetti 'obbligatori'per me..."
    paru -S micro nerd-fonts otf-alegreya otf-alegreya-sans ttf-meslo-nerd ttf-meslo-nerd-powerlevel10k
}
# Lista per BTRFS
lista_btrfs() {
echo "Installazione di pacchetti utili a BTRFS..."
    paru -S btrfs-assistant btrfs-progs os-prober-btrfs grub-btrfs btrfsmaintenance timeshift timeshif-autosnap timeshift-support
}
##############################################################################################
# MENU DI SELEZIONE
mostra_menu_principale() {
    clear
    echo "  ╔════════════════════════════════════════════════════════════════════════════════╗"
    echo "  ║ ███████╗███████╗██████╗  █████╗ ███████╗   ████████╗ ██████╗  ██████╗ ██╗      ║"
    echo "  ║ ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝   ╚══██╔══╝██╔═══██╗██╔═══██╗██║      ║"
    echo "  ║ ███████╗█████╗  ██████╔╝███████║███████╗█████╗██║   ██║   ██║██║   ██║██║      ║"
    echo "  ║ ╚════██║██╔══╝  ██╔══██╗██╔══██║╚════██║╚════╝██║   ██║   ██║██║   ██║██║      ║"
    echo "  ║ ███████║███████╗██████╔╝██║  ██║███████║      ██║   ╚██████╔╝╚██████╔╝███████╗ ║"
    echo "  ║ ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚══════╝      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝ ║"
    echo "  ╚═════════════════════════════════════════════════════════════ by Omar Cavaleri ═╝"
    echo "  ╔════════ SELEZIONA un OPZIONE ══════════════════════════════════════════════════╗"
    echo "  ║       : 1 :   Utility                                                          ║"
    echo "  ║       : 2 :   Repository                                                       ║"
    echo "  ║       : 3 :   Liste di pacchetti                                               ║"
    echo "  ║       : 4 :   Flatpak                                                          ║"
    echo "  ╚════════════════════════════════════════════════════════════════════════════════╝"
    echo "  ╔════════════════════════════════════════════════════╗ ╔═════════════════════════╗"
    echo "  ║       : u :   Aggiorna il sistema                  ║ ║       : q :  Esci       ║"
    echo "  ╚════════════════════════════════════════════════════╝ ╚═════════════════════════╝"

}
##############################################################################################
# Funzione per il sottomenu di Utility
mostra_sottomenu_utility() {
    clear
    echo "  ╔════════════════════════════════════════════════════════════════════════════════╗"
    echo "  ║ ███████╗███████╗██████╗  █████╗ ███████╗   ████████╗ ██████╗  ██████╗ ██╗      ║"
    echo "  ║ ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝   ╚══██╔══╝██╔═══██╗██╔═══██╗██║      ║"
    echo "  ║ ███████╗█████╗  ██████╔╝███████║███████╗█████╗██║   ██║   ██║██║   ██║██║      ║"
    echo "  ║ ╚════██║██╔══╝  ██╔══██╗██╔══██║╚════██║╚════╝██║   ██║   ██║██║   ██║██║      ║"
    echo "  ║ ███████║███████╗██████╔╝██║  ██║███████║      ██║   ╚██████╔╝╚██████╔╝███████╗ ║"
    echo "  ║ ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚══════╝      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝ ║"
    echo "  ╚═════════════════════════════════════════════════════════════ by Omar Cavaleri ═╝"
    echo "  ╔════════ UTILITY ═══════════════════════════════════════════════════════════════╗"
    echo "  ║       : 1 :   Paru                                                             ║"
    echo "  ║       : 2 :   Fish shell                                                       ║"
    echo "  ║       : 3 :   Ripristina tema grub ROG                                         ║"
    echo "  ╚════════════════════════════════════════════════════════════════════════════════╝"
    echo "  ╔════════════════════════════════════════════════════════════════════════════════╗"
    echo "  ║                                          : m :  Torna al menu principale       ║"
    echo "  ╚════════════════════════════════════════════════════════════════════════════════╝"
    read -p "Scelta: " repo_scelta
    case $repo_scelta in
        1) installa_paru ;;
        2) installa_fish_shell ;;
        3) installa_rog_grub;;
        m) echo "Tornando al menu principale..." ;;
        *) echo "Opzione non valida. Riprova." ;;
    esac
}
##############################################################################################
# Funzione per il sottomenu di Repository
mostra_sottomenu_repository() {
    clear
    echo "  ╔════════════════════════════════════════════════════════════════════════════════╗"
    echo "  ║ ███████╗███████╗██████╗  █████╗ ███████╗   ████████╗ ██████╗  ██████╗ ██╗      ║"
    echo "  ║ ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝   ╚══██╔══╝██╔═══██╗██╔═══██╗██║      ║"
    echo "  ║ ███████╗█████╗  ██████╔╝███████║███████╗█████╗██║   ██║   ██║██║   ██║██║      ║"
    echo "  ║ ╚════██║██╔══╝  ██╔══██╗██╔══██║╚════██║╚════╝██║   ██║   ██║██║   ██║██║      ║"
    echo "  ║ ███████║███████╗██████╔╝██║  ██║███████║      ██║   ╚██████╔╝╚██████╔╝███████╗ ║"
    echo "  ║ ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚══════╝      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝ ║"
    echo "  ╚═════════════════════════════════════════════════════════════ by Omar Cavaleri ═╝"
    echo "  ╔════════ REPOSITORY ════════════════════════════════════════════════════════════╗"
    echo "  ║       : 1 :   Asus-Linux (repo g14)                                            ║"
    echo "  ║       : 2 :   Chaotic-AUR                                                      ║"
    echo "  ╚════════════════════════════════════════════════════════════════════════════════╝"
    echo "  ╔════════════════════════════════════════════════════════════════════════════════╗"
    echo "  ║                                          : m :  Torna al menu principale       ║"
    echo "  ╚════════════════════════════════════════════════════════════════════════════════╝"
    read -p "Scelta: " repo_scelta
    case $repo_scelta in
        1) installa_asus_linux ;;  # Esegue la funzione per installare Asus Linux
        2) installa_chaotic_aur ;;  # Esegue la funzione per installare Chaotic AUR

        q) echo "Tornando al menu principale..." ;;
        *) echo "Opzione non valida. Riprova." ;;
    esac
}
##############################################################################################
# Funzione per il sottomenu di Liste
mostra_sottomenu_pacchetti() {
    clear
    echo "  ╔════════════════════════════════════════════════════════════════════════════════╗"
    echo "  ║ ███████╗███████╗██████╗  █████╗ ███████╗   ████████╗ ██████╗  ██████╗ ██╗      ║"
    echo "  ║ ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝   ╚══██╔══╝██╔═══██╗██╔═══██╗██║      ║"
    echo "  ║ ███████╗█████╗  ██████╔╝███████║███████╗█████╗██║   ██║   ██║██║   ██║██║      ║"
    echo "  ║ ╚════██║██╔══╝  ██╔══██╗██╔══██║╚════██║╚════╝██║   ██║   ██║██║   ██║██║      ║"
    echo "  ║ ███████║███████╗██████╔╝██║  ██║███████║      ██║   ╚██████╔╝╚██████╔╝███████╗ ║"
    echo "  ║ ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚══════╝      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝ ║"
    echo "  ╚═════════════════════════════════════════════════════════════ by Omar Cavaleri ═╝"
    echo "  ╔════════ PACCHETTI ═════════════════════════════════════════════════════════════╗"
    echo "  ║       : 1 :   Pacchetti obbligatori per me                                     ║"
    echo "  ║       : 2 :   Pacchetti utili per filesistem BTRFS                             ║"
    echo "  ╚════════════════════════════════════════════════════════════════════════════════╝"
    echo "  ╔════════════════════════════════════════════════════════════════════════════════╗"
    echo "  ║                                          : m :  Torna al menu principale       ║"
    echo "  ╚════════════════════════════════════════════════════════════════════════════════╝"
    read -p "Scelta: " repo_scelta
    case $repo_scelta in
        1) pacchetti_obbligatori ;;
        2) lista_btrfs ;;
        
        m) echo "Tornando al menu principale..." ;;
        *) echo "Opzione non valida. Riprova." ;;
    esac
}
##############################################################################################
# Funzione per il sottomenu di Flatpak
mostra_sottomenu_flatpak() {
    clear
    echo "  ╔════════════════════════════════════════════════════════════════════════════════╗"
    echo "  ║ ███████╗███████╗██████╗  █████╗ ███████╗   ████████╗ ██████╗  ██████╗ ██╗      ║"
    echo "  ║ ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝   ╚══██╔══╝██╔═══██╗██╔═══██╗██║      ║"
    echo "  ║ ███████╗█████╗  ██████╔╝███████║███████╗█████╗██║   ██║   ██║██║   ██║██║      ║"
    echo "  ║ ╚════██║██╔══╝  ██╔══██╗██╔══██║╚════██║╚════╝██║   ██║   ██║██║   ██║██║      ║"
    echo "  ║ ███████║███████╗██████╔╝██║  ██║███████║      ██║   ╚██████╔╝╚██████╔╝███████╗ ║"
    echo "  ║ ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚══════╝      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝ ║"
    echo "  ╚═════════════════════════════════════════════════════════════ by Omar Cavaleri ═╝"
    echo "  ╔════════ FLATPAK ═══════════════════════════════════════════════════════════════╗"
    echo "  ║       : 1 :   Installa Flatpak                                                 ║"
    echo "  ║       : 2 :   Aggiorna pacchetti Flatpak installati                            ║"
    echo "  ╚════════════════════════════════════════════════════════════════════════════════╝"
    echo "  ╔════════════════════════════════════════════════════════════════════════════════╗"
    echo "  ║                                          : m :  Torna al menu principale       ║"
    echo "  ╚════════════════════════════════════════════════════════════════════════════════╝"
    read -p "Scelta: " repo_scelta
    clear
    case $repo_scelta in
        1) supporto_flatpak ;;  # Esegue la funzione per installare Asus Linux
        2) aggiorna_flatpak ;;  # Esegue la funzione per installare Chaotic AUR

        m) echo "Tornando al menu principale..." ;;
        *) echo "Opzione non valida. Riprova." ;;
    esac
}
##############################################################################################
# Funzione per il sottomenu di commiato
see_you() {
    clear
    echo "  ╔═════════════════════════════════════════════════════════╗"
    echo "  ║ ███████╗███████╗███████╗    ██╗   ██╗ ██████╗ ██╗   ██╗ ║"
    echo "  ║ ██╔════╝██╔════╝██╔════╝    ╚██╗ ██╔╝██╔═══██╗██║   ██║ ║"
    echo "  ║ ███████╗█████╗  █████╗       ╚████╔╝ ██║   ██║██║   ██║ ║"
    echo "  ║ ╚════██║██╔══╝  ██╔══╝        ╚██╔╝  ██║   ██║██║   ██║ ║"
    echo "  ║ ███████║███████╗███████╗       ██║   ╚██████╔╝╚██████╔╝ ║"
    echo "  ║ ╚══════╝╚══════╝╚══════╝       ╚═╝    ╚═════╝  ╚═════╝  ║"
    echo "  ╚══════════════════════════════════════════ SPACE COWBOY ═╝"
    sleep 3  # Aspetta 3 secondi
    exit
}
##############################################################################################
# Loop del menu PRINCIPALE
while true; do
    mostra_menu_principale
    read -p "Scelta: " scelta

    case $scelta in
        1) mostra_sottomenu_utility ;;
        2) mostra_sottomenu_repository ;;
        3) mostra_sottomenu_pacchetti;;
        4) mostra_sottomenu_flatpak ;;

        u) aggiorna_sistema_e_flatpak ;;

        q) see_you ;;
        *) echo "Opzione non valida. Riprova." ;;
    esac
done
exit
