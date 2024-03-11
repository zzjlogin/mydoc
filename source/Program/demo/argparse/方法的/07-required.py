import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--foo', required=True)
print(parser.parse_args(['--foo', 'BAR']))
#Namespace(foo='BAR')
print(parser.parse_args([]))
#usage: argparse.py [-h] [--foo FOO]
#argparse.py: error: option --foo is required