.PHONY: clean train-nlu train-core cmdline server start-vincent start-vincent-debug

TEST_PATH=./

help:
	@echo "    clean"
	@echo "        Remove python artifacts and build artifacts."
	@echo "    train-nlu"
	@echo "        Trains a new nlu model using the projects Rasa NLU config"
	@echo "    train-core"
	@echo "        Trains a new dialogue model using the story training data"
	@echo "    action-server"
	@echo "        Starts the server for custom action."
	@echo "    cmdline"
	@echo "       This will load the assistant in your terminal for you to chat."


clean:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f  {} +
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	rm -rf docs/_build

train-nlu:
	python3 -m rasa_nlu.train -c nlu_config.yml --data data/nlu_data.md -o models --project current --verbose

evaluate-nlu:
	python3 -m rasa_nlu.evaluate --data models/nlu/current/training_data.json --model models/nlu/current

evaluate-nlu-cross:
	python3 -m rasa_nlu.evaluate --data models/nlu/current/training_data.json --config nlu_config.yml --mode crossvalidation

run-nlu:
	python3 -m rasa_nlu.server --path ./models/current/nlu

train-core:
	python3 -m rasa_core.train -d domain.yml -s data/stories.md -o models/dialogue -c policies.yml

start-vincent:
	make run-actions&
	python3 -m rasa_core.run -d models/dialogue -u models/nlu --endpoints endpoints.yml --credentials credentials.yml

start-vincent-local:
	make kill-process&
	make run-actions&
	python3 -m rasa_core.run -d models/dialogue -u models/nlu --endpoints endpoints.yml --debug

start-vincent-debug:
	make run-actions&
	python3 -m rasa_core.run -d models/dialogue -u models/nlu --endpoints endpoints.yml --credentials credentials.yml --debug 
	
run-actions:
	python3 -m rasa_core_sdk.endpoint --actions actions

kill-process:
	sudo fuser -k 5055/tcp