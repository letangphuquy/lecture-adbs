# Convenience wrapper around build.sh (GNU make).
#   make                        build all weeks
#   make week05                 build one week (any prefix of the folder name)
#   make notes W=week05         build main-notes.pdf (only slides with speaker notes)
#   make watch W=week05         rebuild on every save (latexmk -pvc)
#   make clean                  remove build output
#   make new W=week06-topic     create a new week from the template
.PHONY: all clean notes watch new help
all:
	@sh ./build.sh
clean:
	@sh ./build.sh --clean
notes:
	@sh ./build.sh --notes $(W)
watch:
	@cd "$$(ls -d $(W)*/ | head -n1)" && latexmk -pvc -interaction=nonstopmode main.tex
new:
	@sh ./build.sh --new $(W)
help:
	@sed -n '2,7p' Makefile
week%:
	@sh ./build.sh $@
