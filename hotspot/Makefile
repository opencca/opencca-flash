PWD=$$(pwd)
SCRIPT_DIR=$(shell cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJ_ROOT=$(SCRIPT_DIR)
TMP_DIR=$(SCRIPT_DIR)/tmp

SYSTEMD_DIR=/etc/systemd/system
SERVICE_TEMPLATE=opencca-hotspot.template
SERVICE_FILE=opencca-hotspot.service

all: install

.PHONY:
install: 
	echo "===> install hotspot as systemd service"
	mkdir -p $(TMP_DIR) 
	sed "s|PROJ_DIR|$(SCRIPT_DIR)|g" $(SERVICE_TEMPLATE) > $(TMP_DIR)/$(SERVICE_FILE)
	cp -rf $(TMP_DIR)/$(SERVICE_FILE) $(SYSTEMD_DIR)/
	cat $(SYSTEMD_DIR)/$(SERVICE_FILE)
	systemctl daemon-reload
	systemctl enable $(SERVICE_FILE)
	systemctl restart $(SERVICE_FILE)


.PHONY:
uninstall: 
	echo "===> uninstall hotspot as systemd service"
	systemctl stop $(SERVICE_FILE) || true
	systemctl disable $(SERVICE_FILE) || true
	rm -f $(SYSTEMD_DIR)/$(SERVICE_FILE)
	systemctl daemon-reload
	systemctl reset-failed

.PHONY:
status:
	echo "===> status hotspot"
	journalctl -u $(SERVICE_FILE) --no-pager --lines=100 || true
	systemctl status $(SERVICE_FILE) --no-pager --lines=50 || true
	

.PHONY:
log:
	echo "===> logfile hotspot"
	cat $(SCRIPT_DIR)/hotspot.*.txt


.PHONY:
start:
	echo "===> starting hotspot"
	systemctl restart $(SERVICE_FILE)
	systemctl status $(SERVICE_FILE) --no-pager --lines=50


.PHONY:
stop:
	echo "===> stopping hotspot"
	systemctl stop $(SERVICE_FILE)

.PHONY:
wifi:
	nmcli connection show
