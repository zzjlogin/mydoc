import argparse
parser = argparse.ArgumentParser(prog='PROG')
parser.add_argument('--foo', action='store_true', help='foo help')

subparsers = parser.add_subparsers(help='sub-command help')

parser_a = subparsers.add_parser('a', help='a help')
parser_a.add_argument('bar', type=int, help='bar help')


# 可以使用别名去简化子命令的编写
parser_b = subparsers.add_parser('checkout', help='b help',aliases=["co"])
parser_b.add_argument('--baz', choices='XYZ', help='baz help')


print(parser.parse_args(['a', '12']))
#Namespace(bar=12, foo=False)
print(parser.parse_args(['--foo', 'checkout', '--baz', 'Z']))
#Namespace(baz='Z', foo=True)
print(parser.parse_args(['--foo', 'co', '--baz', 'Z']))
#Namespace(baz='Z', foo=True)