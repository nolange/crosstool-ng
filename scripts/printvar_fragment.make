pvar-%:
	@printf -- "%s\n" "$(strip $($*))"

apvar-%:
	@printf -- "%s\n" "$(strip $(abspath $($*)))"

pvar_sh-%:
	@printf -- '%s="%s"\n' $* "$(strip $($*))"

apvar_sh-%:
	@printf -- '%s="%s"\n' $* "$(strip $(abspath $($*)))"
