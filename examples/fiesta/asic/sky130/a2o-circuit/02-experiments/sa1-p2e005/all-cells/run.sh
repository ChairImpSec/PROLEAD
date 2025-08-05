"$PROLEAD" -l "$PROLEAD_LIB/sky130.json" -n "sky130" -d ../../00-design/gate/design.v -m circuit -c config.json 2>&1 | tee results/report.txt
