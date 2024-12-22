# -*- mode: makefile -*-
# vim:ft=make:

OUTPUT_DIR = .
BASH_DEBUG_PREFACE ?= "In yt-dlp bash completion setup"
BASH_OUTPUT_FILENAME ?= yt-dlp-completion-setup.bash
ZSH_DEBUG_PREFACE ?= "In yt-dlp zsh completion setup"
ZSH_OUTPUT_FILENAME ?= yt-dlp-completion-setup.zsh

.PHONY : all
all : bash-completion zsh-completion

fetch-yt-dlp-repo:
	@echo Fetching yt-dlp git repository
	@[ -d yt-dlp ] && (cd yt-dlp && git fetch --depth=1 && git reset --hard origin/$$(git rev-parse --abbrev-ref HEAD)) || git clone --depth=1 https://github.com/yt-dlp/yt-dlp.git

.PHONY : bash-completion
bash-completion : fetch-yt-dlp-repo
	@echo Generating yt-dlp bash completion setup script
	@$(MAKE) -C yt-dlp completion-bash
	@/bin/echo -e "# -*- mode: sh; sh-shell: bash -*-\\n\
# vim:ft=sh:\\n\
\\n\
# /bin/echo -e '$(BASH_DEBUG_PREFACE)'\\n" > $(OUTPUT_DIR)/$(BASH_OUTPUT_FILENAME) &&\
	cat yt-dlp/completions/bash/yt-dlp >> $(OUTPUT_DIR)/$(BASH_OUTPUT_FILENAME)

.PHONY : zsh-completion
zsh-completion :
	@echo Generating yt-dlp ZSH completion setup script
	@$(MAKE) -C yt-dlp completion-zsh
	@/bin/echo -e "# -*- mode: sh; sh-shell: zsh -*-\\n\
# vim:ft=sh:\\n\
\\n\
# /bin/echo -e '$(ZSH_DEBUG_PREFACE)'\\n" > $(OUTPUT_DIR)/$(ZSH_OUTPUT_FILENAME) &&\
	cat yt-dlp/completions/zsh/_yt-dlp >> $(OUTPUT_DIR)/$(ZSH_OUTPUT_FILENAME)

.PHONY : clean
clean :
	rm -f $(OUTPUT_DIR)/$(BASH_OUTPUT_FILENAME)
	rm -f $(OUTPUT_DIR)/$(ZSH_OUTPUT_FILENAME)
