import argparse

parser = argparse.ArgumentParser(prog='PROG', allow_abbrev=True)
parser.add_argument('--foobar', action='store_true')
parser.add_argument('--foonley', action='store_false')

print("\n允许简写的\n")
print(parser.parse_args(['--foon']))

print("\n不允许简写的\n")
parser.allow_abbrev=False
print(parser.parse_args(['--foon']))
