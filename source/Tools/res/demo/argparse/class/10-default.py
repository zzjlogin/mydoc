import argparse

parser = argparse.ArgumentParser(argument_default=argparse.SUPPRESS)
parser.add_argument('--foo')
parser.add_argument('bar', nargs='?')
print(parser.parse_args(['--foo', '1', 'BAR']))
print(parser.parse_args([]))


parser2 = argparse.ArgumentParser()
parser2.add_argument('--foo')
parser2.add_argument('bar', nargs='?')
print(parser2.parse_args(['--foo', '1', 'BAR']))
print(parser2.parse_args([]))