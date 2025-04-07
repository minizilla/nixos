vm_addr ?= unset
ssh_options = -o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no
uname := $(shell uname)
hostname := $(shell hostname -s)

define source_brew
# Brew
eval "$$(/opt/homebrew/bin/brew shellenv)"
# End Brew
endef
export source_brew

is_darwin:
ifneq ($(uname), Darwin)
	@echo Darwin command only; exit 1
endif

is_linux:
ifneq ($(uname), Linux)
	@echo Linux command only; exit 1
endif

lint:
	@editorconfig-checker && echo "OK"

secret: is_linux
	@echo opening secret management via syncthing...
	@xdg-open localhost:8384

build:
	@echo reconfigure $(hostname) machine...
ifeq ($(uname), Darwin)
	@darwin-rebuild switch --flake .#$(hostname)
else
	@sudo nixos-rebuild switch --flake .#$(hostname)
endif

update:
	@nix flake update

update/nixpkgs:
	@nix flake lock --override-input nixpkgs github:NixOS/nixpkgs/$(rev)

gc:
	@nix-collect-garbage -d
	@df -h /

gcroots:
	@nix-store --gc --print-roots

optimise:
	@nix-store --optimise

darwin/brew-install: is_darwin
	@echo installing homebrew...
	@sudo NONINTERACTIVE=1 curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
	@echo "$$source_brew" >> ~/.zprofile

darwin/nix-install: is_darwin
	@echo installing nix...
	@curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

darwin/nix-darwin-install: is_darwin
	@echo installing nix-darwin...
	@nix run nix-darwin -- switch --flake .#$(hostname)

# TODO: rsync not installed in the vm
vm/nixos-install:
ifeq ($(vm_addr), unset)
	@echo vm_addr is unset; exit 1
endif
	@echo installing nixos... hostname=$(hostname) vm_addr=@$(vm_addr)
	@ssh $(ssh_options) root@$(vm_addr) " \
		parted /dev/nvme0n1 -- mklabel gpt; \
		parted /dev/nvme0n1 -- mkpart primary 512MiB -8GiB; \
		parted /dev/nvme0n1 -- mkpart primary linux-swap -8GiB 100\%; \
		parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB; \
		parted /dev/nvme0n1 -- set 3 esp on; \
		sleep 1; \
		mkfs.ext4 -L nixos /dev/nvme0n1p1; \
		mkswap -L swap /dev/nvme0n1p2; \
		mkfs.fat -F 32 -n boot /dev/nvme0n1p3; \
		sleep 1; \
		mount /dev/disk/by-label/nixos /mnt; \
		mkdir -p /mnt/boot; \
		mount /dev/disk/by-label/boot /mnt/boot; \
		swapon /dev/disk/by-label/swap; \
		nix-env -iA nixos.rsync
	"
	@rsync -av -e "ssh $(ssh_options)" \
		--exclude=".git/" \
		./ root@$(vm_addr):/tmp/nixos-install
	@ssh $(ssh_options) root@$(vm_addr) " \
		sudo nixos-install --no-channel-copy --no-root-password --flake /tmp/nixos-install#$(hostname); \
	"
