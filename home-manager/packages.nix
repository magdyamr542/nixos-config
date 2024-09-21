{
  pkgs,
  lib,
  ...
}: 
let
  customGoPrograms = pkgs.callPackage ./custom-programs/go.nix {};
in
{


  # User packages
  home.packages = with pkgs; [
	#TODO manage neovim
	zsh-autosuggestions
	zsh-completions
	zsh-powerlevel10k
	zsh-syntax-highlighting
	zsh-history-substring-search
	tmux
    alacritty
    arandr
	bat
	vscode
	diffutils
	fd
	google-chrome
	insomnia
	kubectl
	neofetch
	ngrok
	powerline
	slack
	zoom-us
	vagrant
	virtualbox
	vokoscreen-ng
	go
	gopls
	gotools
	delve
	autojump
	vim
	delta
	rofi
	feh
	networkmanagerapplet
	picom
	pulseaudio
	xclip
	libnotify
	nerdfonts
	kustomize
	customGoPrograms.ssh-tunnel-manager
	customGoPrograms.browser-tab-groups
	customGoPrograms.project-root
	(pkgs.buildEnv { name = "my-bash-scripts"; paths = [ ./scripts ]; })
  ];

}