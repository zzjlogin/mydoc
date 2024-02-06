import argparse
import math

parser = argparse.ArgumentParser()
parser.add_argument('foo', type=int)
parser.add_argument('bar', type=open)
print(parser.parse_args('2 temp.txt'.split()))
#Namespace(bar=<_io.TextIOWrapper name='temp.txt' encoding='UTF-8'>, foo=2)


parser2 = argparse.ArgumentParser()
parser2.add_argument('bar', type=argparse.FileType('w'))
print(parser2.parse_args(['out.txt']))
#Namespace(bar=<_io.TextIOWrapper name='out.txt' encoding='UTF-8'>)


def perfect_square(string):
    value = int(string)
    sqrt = math.sqrt(value)
    if sqrt != int(sqrt):
        msg = "%r is not a perfect square" % string
        raise argparse.ArgumentTypeError(msg)
    return value

parser3 = argparse.ArgumentParser(prog='PROG')
parser3.add_argument('foo', type=perfect_square)
print(parser3.parse_args(['9']))
#Namespace(foo=9)
print(parser3.parse_args(['7']))
#usage: PROG [-h] foo
#PROG: error: argument foo: '7' is not a perfect square