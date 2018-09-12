Ref:

* sam
* pipenv
* chalice (cool but not used)

export PIPENV_VENV_IN_PROJECT=1

pipenv install --dev

cp -r src .venv/lib/python3.6/site-packages


Alt: https://en.zebradil.me/post/2018-05-25-pipenv-for-aws-lambda/
0. Install package: `pipenv install requests`
1. Install locally `pipenv run pip install -r <(pipenv lock -r) --target _build/`
2. Copy sources: `cp -r src/* _build`
3. Deploy...
4. run locally with `pipenv run python src/main.py`

## Testing
hard to find the API Gateway URL... and it needs to be just right

```
curl  --request GET  https://kunkg33lmc.execute-api.us-west-2.amazonaws.com/Prod/model/1234
curl  --request PUT --data '{"foo":"bar","number":44}' https://kunkg33lmc.execute-api.us-west-2.amazonaws.com/Prod/model/1234
```
