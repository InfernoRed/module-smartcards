#!/bin/bash

python3 -m pip install pipenv
python3 -m pipenv install

FLASK_APP=smartcards.core python3 -m pipenv run python3 -m flask run --port 3001
