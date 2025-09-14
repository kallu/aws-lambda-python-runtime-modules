import importlib.metadata

# https://gist.github.com/gene1wood/4a052f39490fae00e0c3

def lambda_handler(event, context):
    dists = set([tuple(str(d._path).split('/')[-1].replace('.dist-info', '').rsplit('-', 1)) for d in importlib.metadata.distributions()])
    reqs = sorted([f'{dist}~={version}' for (dist,version) in dists])
    print('\n'.join(reqs))

lambda_handler(None, None)
