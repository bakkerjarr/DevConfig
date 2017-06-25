# General aliases
alias agdu="sudo apt-get update; sudo apt-get dist-upgrade -y; sudo apt autoremove -y;"
alias pip3chk="pip3 list --outdated"
alias udpip3="pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs sudo pip3 install -U"

# ACLSwitch aliases
alias asw="cd; ryu-manager --verbose ~/PycharmProjects/ACLSwitch/Ryu_Application/controller.py ;"
alias asw="cd; cd PycharmProjects/ACLSwitch; ./start_asw.sh ;"
alias aswcli="cd; cd PycharmProjects/ACLSwitch; ./start_cli.sh ;"
alias aswmn="cd; cd PycharmProjects/ACLSwitch; ./start_network.sh ;"
alias aswtest="cd; cd PycharmProjects/ACLSwitch; ./run_tests.sh ;"
