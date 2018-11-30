CONTAINERS = $(wildcard ./src/*)
clean_CONTAINERS = $(addprefix clean_,$(CONTAINERS))

.PHONY: $(CONTAINERS) $(clean_CONTAINERS)

all: update build

update:
	./scripts/fetch_updates.py

build: $(CONTAINERS)
clean: $(clean_CONTAINERS)

deploy:
	cd ansible ; ansible-playbook -K -i hosts \
		--private-key ~/.ssh/id_ed25519_r3boot site.yml

$(CONTAINERS):
	make -C $@ clean all

$(clean_CONTAINERS):
	make -C $(patsubst clean_%,%,$@) clean
