
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

		shellAliases = {
			ll = "ls -l";
			gcm = "git commit -m";
			update = "sudo nixos-rebuild switch --flake /etc/nixos#amr";
			updatehome = "home-manager switch --flake /etc/nixos#amr";
			deletegarbage = "nix-collect-garbage --delete-old";
			tm = "ssh-tunnel-manager";
			br = "browser-tab-groups";
			t = "tree";
		};

		oh-my-zsh = {
			enable = true;
			plugins = [
				"git" 
				"docker" 
				"docker-compose" 
				"autojump" 
				"colored-man-pages" 
				"history-substring-search" 
				"fd" 
				"kubectl"
			];
		};

		plugins = [
			{
				name = "zsh-autosuggestions";
				src = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
			}
			{
				name = "zsh-syntax-highlighting";
				src = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
			}
			{
				name = "powerlevel10k";
				src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
			}
		];

		history = {
			size = 10000;
			extended = true;
			path = "${config.xdg.dataHome}/.zsh_history";
		};

		initExtra = ''
source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.p10k.zsh
source $HOME/.proot/project-root.sh
bindkey jj vi-cmd-mode 
		'';
	};

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

}