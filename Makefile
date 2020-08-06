HELM := helm
CHARTS := tf-operator
BUILD_CHARTS := $(foreach chart, $(CHARTS), build-$(chart))

.phony: all

all: $(BUILD_CHARTS)

build-%: lint-% init-%
	@echo "========================================="
	@echo "      helm pack	$*     "
	@echo "========================================="
	if [ -f $*/Chart.yaml ]; then $(HELM) package $*; fi

lint-%: init-%
	@echo "===================================="
	@echo "      helm lint	$*     "
	@echo "===================================="
	if [ -f $*/Chart.yaml ]; then $(HELM) lint $*; fi

init-%:
	@echo "============================================="
	@echo " helm dependency update	$* "
	@echo "============================================="
	if [ -f $*/requirements.yaml -a -f $*/Chart.yaml ]; then $(HELM) dep up $*; fi

clean:
	rm -rf *.tgz
	rm -rf */charts
	rm -rf */*.lock

