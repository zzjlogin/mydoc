import argparse

parser = argparse.ArgumentParser()
parser.add_argument('foo', type=int)
parser.set_defaults(bar=42, baz='badger')
print(parser.get_default('bar'))
print(parser.parse_args(['736']))
