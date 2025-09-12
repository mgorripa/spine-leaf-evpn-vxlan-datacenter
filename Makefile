SHELL := /bin/bash
REPO_ROOT := $(shell pwd)

.PHONY: up down deploy test clean grafana dev render up-esilab post-esilab

dev:
	python -m venv .venv && . .venv/bin/activate && pip install -U pip -r requirements.txt

up:
	containerlab deploy -t topology/fabric.clab.yml

up-esilab:
	containerlab deploy -t topology/fabric.v11.esilab.clab.yml

down:
	containerlab destroy -t topology/fabric.clab.yml --cleanup || true
	containerlab destroy -t topology/fabric.v11.esilab.clab.yml --cleanup || true

render:
	ansible-playbook ansible/playbooks/deploy.yml --tags render

deploy:
	ansible-playbook ansible/playbooks/deploy.yml --tags deploy

test:
	pytest -q tests || true

clean:
	rm -rf configs/*
	rm -rf batfish/snapshot/*

grafana:
	cd grafana && docker compose up -d

post-esilab:
	./scripts/postdeploy_esilab.sh
