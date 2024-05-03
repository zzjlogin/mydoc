import argparse

parser = argparse.ArgumentParser(prog='PROG')
parser.add_argument('-f', '--foo')
parser.add_argument('bar')
result = parser.parse_args(['BAR', '--foo', 'FOO'])
print(result)

print(result.bar)