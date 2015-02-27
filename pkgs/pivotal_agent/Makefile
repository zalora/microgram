gemfiles := Gemfile.lock Gemfile.nix

update: $(gemfiles)
	rm result

$(gemfiles): %: result/%
	rm -f $@
	cp $< $@

result/%:
	nix-build bootstrap.nix
