import argparse
import sys

parser = argparse.ArgumentParser()
parser.add_argument('--foo', nargs=2)
parser.add_argument('bar', nargs=1)
print(parser.parse_args('c --foo a b'.split()))
#Namespace(bar=['c'], foo=['a', 'b'])

parser2 = argparse.ArgumentParser()
parser2.add_argument('--foo', nargs='?', const='c', default='d')
parser2.add_argument('bar', nargs='?', default='d')
print(parser2.parse_args(['XX', '--foo', 'YY']))
#Namespace(bar='XX', foo='YY')
print(parser2.parse_args(['XX', '--foo']))
#Namespace(bar='XX', foo='c')
print(parser2.parse_args([]))
#Namespace(bar='d', foo='d')


parser3 = argparse.ArgumentParser()
parser3.add_argument('infile', nargs='?', type=argparse.FileType('r'), default=sys.stdin)
parser3.add_argument('outfile', nargs='?', type=argparse.FileType('w'), default=sys.stdout)
print(parser3.parse_args(['input.txt', 'output.txt']))
#Namespace(infile=<_io.TextIOWrapper name='input.txt' encoding='UTF-8'>,outfile=<_io.TextIOWrapper name='output.txt' encoding='UTF-8'>)
print(parser3.parse_args([]))
#Namespace(infile=<_io.TextIOWrapper name='<stdin>' encoding='UTF-8'>,outfile=<_io.TextIOWrapper name='<stdout>' encoding='UTF-8'>)

parser4 = argparse.ArgumentParser()
parser4.add_argument('--foo', nargs='*')
parser4.add_argument('--bar', nargs='*')
parser4.add_argument('baz', nargs='*')
print(parser4.parse_args('a b --foo x y --bar 1 2'.split()))
#Namespace(bar=['1', '2'], baz=['a', 'b'], foo=['x', 'y'])

parser5 = argparse.ArgumentParser(prog='PROG')
parser5.add_argument('foo', nargs='+')
print(parser5.parse_args(['a', 'b']))
#Namespace(foo=['a', 'b'])
parser5.parse_args([])
#usage: PROG [-h] foo [foo ...]
#PROG: error: too few arguments

parser6 = argparse.ArgumentParser(prog='PROG')
parser6.add_argument('--foo')
parser6.add_argument('command')
parser6.add_argument('args', nargs=argparse.REMAINDER)
print(parser6.parse_args('--foo B cmd --arg1 XX ZZ'.split()))
#Namespace(args=['--arg1', 'XX', 'ZZ'], command='cmd', foo='B')